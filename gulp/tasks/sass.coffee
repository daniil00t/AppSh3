gulp = require 'gulp'
sass = require 'gulp-sass'
rename = require 'gulp-rename'
autoprefixer = require 'gulp-autoprefixer'
sourcemaps = require 'gulp-sourcemaps'
handleErrors = require '../util/handleErrors'

cleanCSS    = require('gulp-clean-css')

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

gulp.task 'sass', ->
	gulp.src './client/stylesheets/sass/main.sass'
		.pipe sourcemaps.init()
    .pipe sass({
    	includePaths: require('node-bourbon').includePaths
    })
    .on 'error', handleErrors
    .pipe autoprefixer({cascade: false, browsers: ['last 2 versions']})
    .pipe sourcemaps.write()
    .pipe rename 'style_sass.css'
    .pipe gulp.dest('./Public/media/stylesheets')