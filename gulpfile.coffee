gulp        = require 'gulp'
coffee      = require 'gulp-cjsx'
del         = require 'del'
sourcemaps  = require 'gulp-sourcemaps'
cache       = require 'gulp-cached'
mocha       = require 'gulp-mocha'

# Backend is mostly the same as frontend, but it just get's compiled from cjsx.
gulp.task 'scripts', ->
  gulp
    .src 'scripts/**/*.coffee'
    .pipe cache 'scripts'
    .pipe sourcemaps.init()
    .pipe do coffee
    .pipe sourcemaps.write './'
    .pipe gulp.dest './lib/'

require 'coffee-react/register'
gulp.task 'test', ->
  gulp
    .src 'test/index.coffee', read: no
    .pipe mocha
      reporter: 'spec'

gulp.task 'clear', (done) ->
  del './lib/**/*', done

gulp.task 'build', gulp.series [
  'clear'
  'scripts'
  'test'
]

gulp.task 'watch', (done) ->
  gulp.watch ['./scripts/**/*'],  gulp.series [
    'scripts'
    'test'
  ]
  # gulp.watch ['./styles/**/*'], gulp.series   ['styles']
  # gulp.watch ['./assets/**/*'], gulp.series   ['assets']
  gulp.watch ['./test/**/*'],   gulp.series   ['test']

  # It is never done :)

gulp.task 'develop', gulp.series [
  (done) ->
    process.env.NODE_ENV ?= 'development'
    do done
  'build'
  'watch'
]
