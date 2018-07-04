gulp = require 'gulp'

gulp.task 'watch', ['browserSync'], ->
  gulp.watch 'app/html/*.html', ['html']
  gulp.watch 'app/stylesheets/*.less', ['less']
  gulp.watch 'app/stylesheets/sass/*.sass', ['sass']

gulp.task 'setWatch', ->
  global.isWatching = true