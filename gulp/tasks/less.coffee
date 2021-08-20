gulp = require 'gulp'
less = require 'gulp-less'
rename = require 'gulp-rename'
autoprefixer = require 'gulp-autoprefixer'
sourcemaps = require 'gulp-sourcemaps'
handleErrors = require '../util/handleErrors'

###
	return gulp.src('sass/*.sass')
	.pipe(sass({
		includePaths: require('node-bourbon').includePaths
	}).on('error', sass.logError))
	.pipe(rename({suffix: '.min', prefix : ''}))
	.pipe(autoprefixer({browsers: ['last 15 versions'], cascade: false}))
	.pipe(cleanCSS())
	.pipe(gulp.dest('app/css'))
	.pipe(browserSync.stream());
###

gulp.task 'less', ->
  gulp.src './client/stylesheets/main.less'
    .pipe sourcemaps.init()
    .pipe less()
    .on 'error', handleErrors
    .pipe autoprefixer({cascade: false, browsers: ['last 2 versions']})
    .pipe sourcemaps.write()
    .pipe rename 'style.css'
    .pipe gulp.dest('./Public/media/stylesheets')