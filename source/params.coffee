###
Parameters manager - https://github.com/droptype/params
###

INTERNAL = ['set', 'getAll', 'push', 'setUnescaped', 'pushUnescaped', '_strict']

# Unescape helper, adapted from [Underscore](http://underscorejs.org).
entities =
  '&amp;'   : '&'
  '&lt;'    : '<'
  '&gt;'    : '>'
  '&quot;'  : '"'
  '&#x27;'  : '\''
exp = new RegExp('(&amp;|&lt;|&gt;|&quot;|&#x27;)', 'g')
_unescapeHTML = (data_str) ->
    unless data_str
        return ''
    return data_str.replace exp, (match) ->
        return entities[match]



class Params

    @VERSION = '1.1.0'

    constructor: (opts={}) ->
        @_strict = if opts.strict? then opts.strict else false


    # Public: set a parameter.
    #
    # key    - a String key to set. MAY use dot notation to specify sub parameters.
    # value  - an arbitrary value to set
    # kwargs - an object of optional arguments
    #          push - a Boolean indicating the key is should be set to an Array
    #          unescape - a Boolean indicating the value should have HTML
    #            entities unescaped first.
    #
    # Returns self for chaining.
    set: (key, value, kwargs={}) =>

        if key in INTERNAL
            throw new Error("Cannot set the '#{ key }' param, silly.")

        if kwargs.unescape
            unless typeof value is 'string'
                throw new Error('Cannot unescape non-string values')
            value = _unescapeHTML(value)

        key_list = key.split('.')
        target_obj = this
        prev_key = null

        # Loop over the key list, constructing nested objects as necessary for
        # subparameters.
        while key_list.length > 0
            key = key_list.shift()

            if typeof target_obj isnt 'object'
                if kwargs.push and not target_obj.push?
                    throw new Error("Cannot push subparameter '#{ prev_key }.#{ key }'. '#{ prev_key }' is not an Array.")
                else
                    throw new Error("Cannot set subparameter '#{ prev_key }.#{ key }'. '#{ prev_key }' is not an object.")

            if key_list.length is 0
                if target_obj[key]?
                    if not kwargs.push
                        if @_strict
                            throw new Error("Param '#{ key }' was already set with `#{ target_obj[key] }`")
                        console?.warn?("Param '#{ key }' overridden (`#{ target_obj[key] }` with `#{ value }`)")
                if kwargs.push
                    unless target_obj[key]?
                        target_obj[key] = []
                    target_obj[key].push(value)
                else
                    target_obj[key] = value

            else
                if not target_obj[key]?
                    target_obj[key] = {}
                target_obj = target_obj[key]
            prev_key = key

        return this

    # Public: shortcut for `set` with `unescape: true`.
    # 
    # Returns self for chaining.
    setUnescaped: (key, value) =>
        return @set(key, value, unescape: true)

    # Public: push a parameter. If they key is not already set, it will be
    #           created. Shortcut for `set` with `push: true`.
    #
    # key    - a String key to set. MAY use dot notation to specify sub parameters.
    # value  - an arbitrary value to set
    #
    # Returns self for chaining.
    push: (key, value) =>
        return @set(key, value, push: true)

    # Public: shortcut for `set` with `push: true, unescape: true`.
    # 
    # Returns self for chaining.
    pushUnescaped: (key, value) =>
        return @set(key, value, push: true, unescape: true)

    # Public: get all of the parameters. Used to avoid getting the internal
    # properties as well.
    #
    # Returns an object of all the parameters.
    getAll: ->
        param_obj = {}
        for k, v of this
            unless k in INTERNAL
                param_obj[k] = v
        return param_obj


if module?
    module.exports = Params
else if window?
    window.Params = Params

