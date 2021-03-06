###*
#
# If you don't like the way the built-in jasmine reporters look, you can always write your own.
#
###

###*
# A jasmine reporter is just an object with the right functions available.
# None of the functions here are required when creating a custom reporter, any that are not specified on your reporter will just be ignored.
###

myReporter = 
  jasmineStarted: (suiteInfo) ->

    ###*
    # suiteInfo contains a property that tells how many specs have been defined
    ###

    console.log 'Running suite with ' + suiteInfo.totalSpecsDefined
    return
  suiteStarted: (result) ->

    ###*
    # the result contains some meta data about the suite itself.
    ###

    console.log 'Suite started: ' + result.description + ' whose full description is: ' + result.fullName
    return
  specStarted: (result) ->

    ###*
    # the result contains some meta data about the spec itself.
    ###

    console.log 'Spec started: ' + result.description + ' whose full description is: ' + result.fullName
    return
  specDone: (result) ->

    ###*
    # The result here is the same object as in `specStarted` but with the addition of a status and a list of failedExpectations.
    ###

    console.log 'Spec: ' + result.description + ' was ' + result.status
    i = 0
    while i < result.failedExpectations.length

      ###*
      # Each `failedExpectation` has a message that describes the failure and a stack trace.
      ###

      console.log 'Failure: ' + result.failedExpectations[i].message
      console.log result.failedExpectations[i].stack
      i++
    return
  suiteDone: (result) ->

    ###*
    # The result here is the same object as in `suiteStarted` but with the addition of a status and a list of failedExpectations.
    ###

    console.log 'Suite: ' + result.description + ' was ' + result.status
    i = 0
    while i < result.failedExpectations.length

      ###*
      # Any `failedExpectation`s on the suite itself are the result of a failure in an `afterAll`.
      # Each `failedExpectation` has a message that describes the failure and a stack trace.
      ###

      console.log 'AfterAll ' + result.failedExpectations[i].message
      #console.log result.failedExpectations[i].stack
      i++
    return
  jasmineDone: ->
    console.log 'Finished suite'
    return

###*
# Register the reporter with jasmine
###

jasmine.getEnv().addReporter myReporter

###*
# If you look at the console output for this page, you should see the output from this reporter


describe 'Top Level suite', ->
  it 'spec', ->
    expect(1).toBe 1
    return
  describe 'Nested suite', ->
    it 'nested spec', ->
      expect(true).toBe true
      return
    return
  return
###