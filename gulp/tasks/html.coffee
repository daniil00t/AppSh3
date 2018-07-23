gulp = require 'gulp'
browserSync = require 'browser-sync'
reload = browserSync.reload

gulp.task 'html', ->
  gulp.src './Public/pages/**/*.html'
    .pipe gulp.dest('./client/build/admin')
    .pipe reload({ stream: true })