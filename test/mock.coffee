require '../coffee/mock'

describe 'Simple Mock', ->
  it 'should inform weather a mocked function is called', () ->
    m = mock(['someFunction','anotherFunction']);
    m.someFunction();
    m.isCalled('someFunction').should.be.ok
    m.isCalled('anotherFunction').should.not.be.ok

  it 'should allow adding functions after init', () ->
    m = mock(['someFunction'])
    m.addFunction('anotherFunction');
    m.anotherFunction();
    m.isCalled('anotherFunction').should.be.ok

  it 'should return given value when mock is called', () ->
    m = mock 'someFunction'
    m.modify 'someFunction',{'returns': 'test'}
    m.someFunction().should.eql('test')

  it 'should check if called arguments matches specification', () ->
    m = mock 'someFunction'
    m.modify 'someFunction',{'takes':['a',1,->]}
    incorrectFn = ()->
      m.someFunction()
    incorrectFn.should.throw();

    incorrectFn1 = ()->
      m.someFunction('a')
    incorrectFn1.should.throw();

    incorrectFn2 = ()->
      m.someFunction('a',1)
    incorrectFn2.should.throw();

    incorrectFn3 = ()->
      m.someFunction('n',1,->)
    incorrectFn3.should.throw();

    correctFn = ()->
      m.someFunction('a', 1, ->)
    correctFn.should.not.throw();

  it 'should call the specified callback function', (done) ->
    m = mock 'someFunction'
    m.modify 'someFunction', { calls: 1, with: [null, 'abcd'] };

    m.someFunction null, (e, data)->
      e.should.not.be.ok
      data.should.eql('abcd')