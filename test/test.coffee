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
        (-> params.set('push', 1)).should.throw()
        (-> params.set('setUnescaped', 1)).should.throw()
        (-> params.set('pushUnescaped', 1)).should.throw()
        (-> params.set('_strict', 1)).should.throw()

    it 'should push a parameter', ->
        params = new Params()
        params.push('key', 1)
        params.key.should.eql([1])
        params.push('key', 2)
        params.key.should.eql([1, 2])

    it 'should push a subparameter', ->
        params = new Params()
        params.push('key.subkey', 1)
        params.key.subkey.should.eql([1])
        params.push('key.subkey', 2)
        params.key.subkey.should.eql([1, 2])

    it 'should not push a sub parameter if parameter is not an Array', ->
        params = new Params()
        params.set('key', 1)
        (-> params.push('key.foo', 1)).should.throw("Cannot push subparameter 'key.foo'. 'key' is not an Array.")
        params.key.should.equal(1)

        params = new Params()
        params.set('key.foo', 1)
        (-> params.push('key.foo.bar', 1)).should.throw("Cannot push subparameter 'foo.bar'. 'foo' is not an Array.")
        params.key.foo.should.equal(1)

    it 'should set parameters as escaped', ->
        params = new Params()
        params.set('key.subkey', '&lt;')
        params.key.subkey.should.equal('&lt;')

    it 'should unescape parameters when using setUnescaped', ->
        params = new Params()
        params.setUnescaped('key', '&lt;')
        params.key.should.equal('<')

    it 'should push parameters as escaped', ->
        params = new Params()
        params.push('key.subkey', '&lt;')
        params.key.subkey.should.eql(['&lt;'])

    it 'should unescape parameters when using pushUnescaped', ->
        params = new Params()
        params.pushUnescaped('key', '&lt;')
        params.key.should.eql(['<'])

    it 'should allow for a mix of push and pushUnescaped', ->
        params = new Params()
        params.push('key', '&lt;script&gt;')
        params.pushUnescaped('key', '&lt;script&gt;')
        params.key.should.eql(['&lt;script&gt;', '<script>'])

    it 'should not unescape a parameter if the value is not a string', ->
        params = new Params()
        (-> params.setUnescaped('key.foo', 1)).should.throw("Cannot unescape non-string values")
