gulp = require 'gulp'

gulp.task 'watch', ['browserSync'], ->
  gulp.watch 'client/stylesheets/*.less', ['less']
  gulp.watch 'client/stylesheets/sass/*.sass', ['sass']

gulp.task 'setWatch', ->
  global.isWatching = true