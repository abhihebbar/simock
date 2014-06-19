require '../coffee/mock'

describe 'Mocked Class', ->
  it 'should create a prototype object that can be instantiated', () ->
    m = mockClass 'someFunction'
    m.isInstantiated().should.not.be.ok
    mi = new m.constructorFn
    m.isInstantiated().should.be.ok

  it 'should mock methods of the instance', () ->
    m = mockClass 'someFunction'
    mi = new m.constructorFn
    mi.someFunction()
    m.isCalled('someFunction').should.be.ok
