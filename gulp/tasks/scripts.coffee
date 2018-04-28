_ = require 'lodash'
gulp = require 'gulp'
browserify = require 'browserify'
watchify = require 'watchify'
source = require 'vinyl-source-stream'
bundleLogger = require '../util/bundleLogger'
handleErrors = require '../util/handleErrors'

# External dependencies we do not want to rebundle while developing
dependencies =
  react: './node_modules/react'
  lodash: './node_modules/lodash'

gulp.task 'scripts', ->
  #==========  Client bundler  ==========#
  ###Learner###
  clientBundlerLearner = browserify
    cache: {}, packageCache: {}
    entries: './app/_learner/scripts/main.coffee'
    extensions: ['.cjsx', '.coffee']

  _.forEach dependencies, (path, dep) ->
    clientBundlerLearner.external dep

  rebundle = ->
    bundleLogger.start 'client.js'

    clientBundlerLearner.bundle()
      .on 'error', handleErrors
      .pipe source('client.js')
      .pipe gulp.dest('./Public/scripts/learner/test')
      .on 'end', ->
        bundleLogger.end 'client.js'

  if global.isWatching
    clientBundlerLearner = watchify clientBundlerLearner
    clientBundlerLearner.on 'update', rebundle
  rebundle()

  ###Admin###


  clientBundlerAdmin = browserify
    cache: {}, packageCache: {}
    entries: './app/_admin/scripts/main.coffee'
    extensions: ['.cjsx', '.coffee']

  _.forEach dependencies, (path, dep) ->
    clientBundlerAdmin.external dep

  rebundle1 = ->
    bundleLogger.start 'client.js'

    clientBundlerAdmin.bundle()
      .on 'error', handleErrors
      .pipe source('client.js')
      .pipe gulp.dest('./Public/scripts/admin')
      .on 'end', ->
        bundleLogger.end 'client.js'

  if global.isWatching
    clientBundlerAdmin = watchify clientBundlerAdmin
    clientBundlerAdmin.on 'update', rebundle1
  rebundle1()

  #==========  Vendor bundler  ==========#

  vendorBundler = browserify
    cache: {}, packageCache: {}
    extensions: ['.coffee']

  _.forEach dependencies, (path, dep) ->
    vendorBundler.require path, expose: dep

  bundleLogger.start 'vendor.js'

  vendorBundler.bundle()
    .on 'error', handleErrors
    .pipe source('vendor.js')
    .pipe gulp.dest('./build/scripts')
    .on 'end', ->
      bundleLogger.end 'vendor.js'