require 'should'



describe 'Params', ->
    Params = require '../source/params'
    it 'should set a parameter', ->
        params = new Params()
        params.set('key', 1)
        params.key.should.equal(1)

    it 'should set a sub parameter', ->
        params = new Params()
        params.set('key.subkey', 1)
        params.key.subkey.should.equal(1)

    it 'should set a sub sub parameter', ->
        params = new Params()
        params.set('key.subkey.subsubkey', 1)
        params.key.subkey.subsubkey.should.equal(1)

    it 'should not set a sub parameter if parameter is not an object', ->
        params = new Params()
        params.set('key', 1)
        (-> params.set('key.foo', 1)).should.throw("Cannot set subparameter 'key.foo'. 'key' is not an object.")
        params.key.should.equal(1)

        (-> params.set('key.foo.bar', 1)).should.throw("Cannot set subparameter 'key.foo'. 'key' is not an object.")
        params.key.should.equal(1)

    it 'should allow the key to be overridden', ->
        params = new Params()
        params.set('key', 1)
        params.key.should.equal(1)
        params.set('key', 2)
        params.key.should.equal(2)

    it 'should prevent the key from being overridden in strict mode', ->
        params = new Params(strict: true)
        params.set('key', 1)
        params.key.should.equal(1)
        (-> params.set('key', 2)).should.throw("Param 'key' was already set with `1`")

    it 'should not allow internal properties to be set', ->
        params = new Params()
        (-> params.set('set', 1)).should.throw()
        (-> params.set('getAll', 1)).should.throw()
        (-> params.set('_strict', 1)).should.throw()

# params = new Params()

# console.log params.getAll()

# params.set('foo', 'a').set('Bar', 1234)

# console.log params.getAll()

# params.set('foo', 9)

# console.log params.getAll()


# params.set('asdf.asdf.asdf', 9)

# console.log params.getAll()

# params.set('foo.bar', 9)
# console.log params.getAll()
# console.log params.foo