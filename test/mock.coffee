require '../coffee/mock'

describe 'Simple Mock', ->
  it 'should inform weather a mocked function is called', () ->
    m = mock(['someFunction','anotherFunction']);
    m.someFunction();
    console.log m
    m.isCalled('someFunction').should.be.ok
    # m.isCalled('anotherFunction').should.not.be.ok

  # it 'shoud throw error if incorrect va', (done) ->
    #...