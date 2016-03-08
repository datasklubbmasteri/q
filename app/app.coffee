express     = require 'express';
mongoclient = require('mongodb').MongoClient
mongodb     = require('mongodb').Db

# Config
app = express()
app.set 'view engine', 'hbs'
app.set 'views', 'app/views'
app.use '/', express.static 'build/'

PORT = 3000

# set up mongo
mongo =
    host: 'localhost'
    port: 27017
mongo.url = "mongodb://#{mongo.host}:#{mongo.port}/skalan"
mongoclient.connect mongo.url, (error, database) ->
  if error
    throw error
  mongo.db = database

# view all quotes
app.get '/', (request, response) ->
  mongo.db.collection 'quotes', (error, collection) ->
    collection.find({}).toArray (error, quotes) ->
      if quotes == null
        response.json 'error': -1
      else
        quotes.reverse()
        response.render 'index', title: 'quotes', message: 'dkm e dumma i huvet', quotes: quotes

app.get '/create', (request, response) ->
  response.render 'create'

# Create a new event
app.post '/create', (request, response) ->
  q =
    _id: new Date()
    name: request.body.name
    text: request.body.text
  mongo.db.collection 'quotes', (error, collection) ->
    collection.insert q, { w: 1 }
  response.json q

app.listen PORT, ->
  console.log "Server running on #{PORT}"
