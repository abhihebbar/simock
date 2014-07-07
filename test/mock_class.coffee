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

  it 'should mock constructor methods of the instance', () ->
    m = mockClass 'someFunction'
    m.modify 'constructor',{'takes':['a', 1, ->]}
    
    m.isCalled('constructor').should.not.be.ok

    incorrectInst = ()->
      mi = new m.constructorFn('a')
    incorrectInst.should.throw();

    correctInst = ()->
      mi = new m.constructorFn('a', 1, ->)
    correctInst.should.not.throw();
    m.isCalled('constructor').should.be.ok
