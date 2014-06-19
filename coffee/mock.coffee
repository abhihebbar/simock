class Mock
  constructor: (functions) ->
    functions = [functions] unless functions instanceof Array

    @callsLog = {}
    @functions = {}
    for fn in functions
      fn = {name: fn} if typeof fn is "string"
      @functions[fn.name] = fn
      @callsLog[fn.name] = 0
      @[fn.name] = ()->
        @callMock fn.name, arguments

  modify: (name, settings)->
    @functions[name] = _.extend @functions[name], settings

  callMock: (name, args)->
    @callsLog[name] += 1

  isCalled: (name)->
    @callsLog[name] > 0

global.mock = (functions)->
  new Mock(functions);