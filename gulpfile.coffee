gulp    = require 'gulp'
sass    = require 'gulp-sass'
bourbon = require 'node-bourbon'
neat    = require 'node-neat'
plumber = require 'gulp-plumber'
sync    = require 'browser-sync'
nodemon = require 'gulp-nodemon'

sync.create()

src =
  styles: 'app/**/*.scss'
  views: 'app/views/*.hbs'
build = 'build'
maps = 'maps'

errorHandler = (error) ->
  console.log error
  @emit 'end'

# Trigger browser reload on changes in template
gulp.task 'hbs', ->
  gulp.src src.views
    .pipe sync.stream()

# Compile sass into CSS & auto-inject into browsers
gulp.task 'sass', ->
  gulp.src src.styles
    .pipe plumber errorHandler: errorHandler
    .pipe sass includePaths: neat.includePaths.concat bourbon.includePaths
    .pipe gulp.dest build
    .pipe sync.stream()

# Convenience task for running a one-off build
gulp.task 'build', ['sass']

gulp.task 'nodemon', (cb) ->
  nodemon(script: 'app/app.coffee').on 'start', cb

gulp.task 'sync', ->
  sync.init null,
    proxy: 'http://localhost:3000'
    port: 7000

gulp.task 'watch', ->
    gulp.watch src.styles, ['sass']
    gulp.watch src.views, ['hbs']

gulp.task 'default', ['build', 'nodemon', 'sync', 'watch']
