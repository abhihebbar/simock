_ = require 'underscore'

class Mock
  constructor: (functions) ->
    functions = [functions] unless functions instanceof Array

    @callsLog = {}
    @functions = {}
    for fn in functions
      fn = {name: fn} if typeof fn is "string"
      @addFunction(fn.name, fn);

  addFunction: (fnName, fnDesc={})->
    @functions[fnName] = fnDesc
    @callsLog[fnName] = 0
    @[fnName] = ()->
        @callMock fnName, arguments

  modify: (name, settings)->
    @functions[name] = _.extend @functions[name], settings

  callMock: (name, args)->
    if @functions[name].takes
      @checkArgs(@functions[name].takes, _.values args)

    @callsLog[name] += 1

    if @functions[name].calls?
      unless typeof args[@functions[name].calls] is 'function'
        throw new Error("Expected #{@functions[name].calls + 1}th argument to be function")

      args[@functions[name].calls].apply(@, @functions[name].with)

    return @functions[name].returns if @functions[name].returns?

  checkArgs: (expected, actual)->
    expected = expected() if typeof expected is "function"
    matching = true;
    for idx of expected
      matching = false if typeof expected[idx] isnt typeof actual[idx]
      matching = false if typeof expected[idx] is 'string' and expected[idx] != actual[idx]
      matching = false if typeof expected[idx] is 'number' and expected[idx] != actual[idx]
    throw new Error("Mock called with unexpected args") unless matching

  isCalled: (name)->
    @callsLog[name] > 0

  getCallCount: (name)->
    @callsLog[name]

class MockClass
  constructor: (functions) ->
    functions = [functions] unless functions instanceof Array
    functions.push('constructor');
    @mock = new Mock(functions)
    @instanceCnt = 0

  constructorFn: () =>
    @mock.callMock 'constructor', _.values arguments;
    @instanceCnt++
    return @mock

  isInstantiated: ()->
    @instanceCnt > 0

  getNoInstances: ()->
    @instanceCnt

  addFunction: (fnName, fnDesc={})->
    @mock.addFunction fnName, fnDesc

  modify: (name, settings)->
    @mock.modify name, settings

  isCalled: (name)->
    @mock.isCalled name

  getCallCount: (name)->
    @mock.getCallCount name

global.mock = (functions)->
  new Mock(functions);

global.mockClass = (functions)->
  new MockClass(functions)