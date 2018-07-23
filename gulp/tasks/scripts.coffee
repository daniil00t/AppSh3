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
  clientBundlerLearnerTest = browserify
    cache: {}, packageCache: {}
    entries: './client/_learner/scripts/main.coffee'
    extensions: ['.cjsx', '.coffee']

  _.forEach dependencies, (path, dep) ->
    clientBundlerLearnerTest.external dep

  rebundleTest = ->
    bundleLogger.start 'client.js'

    clientBundlerLearnerTest.bundle()
      .on 'error', handleErrors
      .pipe source('client.js')
      .pipe gulp.dest('./Public/media/scripts/learner/test')
      .on 'end', ->
        bundleLogger.end 'client.js'

  if global.isWatching
    clientBundlerLearnerTest = watchify clientBundlerLearnerTest
    clientBundlerLearnerTest.on 'update', rebundleTest
  rebundleTest()

  # Chat
  clientBundlerLearnerChat = browserify
    cache: {}, packageCache: {}
    entries: './client/_learner_chat/scripts/main.coffee'
    extensions: ['.cjsx', '.coffee']

  _.forEach dependencies, (path, dep) ->
    clientBundlerLearnerChat.external dep

  rebundleChat = ->
    bundleLogger.start 'client.js'

    clientBundlerLearnerChat.bundle()
      .on 'error', handleErrors
      .pipe source('client.js')
      .pipe gulp.dest('./Public/media/scripts/learner/chat')
      .on 'end', ->
        bundleLogger.end 'client.js'

  if global.isWatching
    clientBundlerLearnerChat = watchify clientBundlerLearnerChat
    clientBundlerLearnerChat.on 'update', rebundleChat
  rebundleChat()

  ###Admin###


  clientBundlerAdmin = browserify
    cache: {}, packageCache: {}
    entries: './client/_admin/scripts/main.coffee'
    extensions: ['.cjsx', '.coffee']

  _.forEach dependencies, (path, dep) ->
    clientBundlerAdmin.external dep

  rebundle1 = ->
    bundleLogger.start 'client.js'

    clientBundlerAdmin.bundle()
      .on 'error', handleErrors
      .pipe source('client.js')
      .pipe gulp.dest('./Public/media/scripts/admin')
      .on 'end', ->
        bundleLogger.end 'client.js'

  if global.isWatching
    clientBundlerAdmin = watchify clientBundlerAdmin
    clientBundlerAdmin.on 'update', rebundle1
  rebundle1()

  #==========  Vendor bundler  ==========#

###  vendorBundler = browserify
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
      bundleLogger.end 'vendor.js'###