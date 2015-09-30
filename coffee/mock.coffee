_ = require 'underscore'
mockery = require 'mockery'

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
    @callsLog[name] = 1 if isNaN(@callsLog[name])

    if @functions[name].calls?
      unless typeof args[@functions[name].calls] is 'function'
        throw new Error("Expected #{@functions[name].calls + 1}th argument to be function")

      args[@functions[name].calls].apply(@, @functions[name].with)

    return @functions[name].returns if @functions[name].returns?

  checkArgs: (expected, actual)->
    matching = true;
    if typeof expected is "function"
      matching = expected(actual) 
    else
      for idx of expected
        if (typeof expected[idx] isnt typeof actual[idx])
          matching = false
        
        if typeof expected[idx] isnt 'function'
          matching = _.isEqual(expected[idx], actual[idx])

        break unless matching
        
    throw new Error("Mock called with unexpected args") unless matching

  isCalled: (name)->
    @callsLog[name] > 0

  getCallCount: (name)->
    @callsLog[name]

  reset: ()->
    @callsLog = {}

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

  reset: ()->
    @instanceCnt = 0;
    @mock.reset();

global.enableMocks = ()->
  mockery.enable({useCleanCache: true})

global.disableMocks = ()->
  mockery.deregisterAll();
  mockery.disable();

global.mock = (functions)->
  new Mock(functions);

global.mockFor = (module, functions)->
  mock = new Mock(functions);
  mockery.registerMock(module, mock)
  return mock

global.mockClass = (functions)->
  new MockClass(functions)

global.mockClassFor = (module, functions)->
  mock = new MockClass(functions)
  mockery.registerMock(module, mock)
  return mock
