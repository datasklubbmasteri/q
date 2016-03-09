express     = require('express')
bodyparser  = require('body-parser')
mongoclient = require('mongodb').MongoClient
mongodb     = require('mongodb').Db

# Config
app = express()
app.set 'view engine', 'hbs'
app.set 'views', 'app/views'
app.use '/', express.static 'build/'
app.use bodyparser.json()
app.use bodyparser.urlencoded extended: true

PORT = 3000

# set up mongo
mongo =
    host: 'localhost'
    port: 27017
mongo.url = "mongodb://#{mongo.host}:#{mongo.port}/q"
mongoclient.connect mongo.url, (error, database) ->
  if error
    throw error
  mongo.db = database

# View all quotes
app.get '/', (request, response) ->
  mongo.db.collection 'quotes', (error, collection) ->
    collection.find({}).toArray (error, quotes) ->
      if quotes == null
        response.json 'error': -1
      else
        quotes.reverse()
        response.render 'index', quotes: quotes

app.get '/create', (request, response) ->
  response.render 'create'

# Create a new quote
app.post '/create', (request, response) ->
  if !request.name? && !request.text? && !request.context?
    response.json 'error': -1
    return
  q =
    _id: new Date()
    name: request.body.name
    text: request.body.text
    context: request.body.context
  mongo.db.collection('quotes').insertOne q, (error, result) ->
    console.log q
  response.redirect '/'

app.listen PORT, ->
  console.log "Server running on #{PORT}"
