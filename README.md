Params
======

A simple front-end parameters manager for specifying global script parameters.

## Usage

Include [`params.js`](https://github.com/droptype/params/releases/tag/v1.2.0)
in the page and initialize a Params object. Or, include the
`params-1.2.0-min.html` HTML fragment, which initializes a Params instance
under `window.params`. (It’s also slightly smaller, omitting features that
are unnecessary if there‘s only one instance.)

```javascript
params = new Params()
```

*   Set a parameter:

    ```javascript
    > params.set('eggs', 'green')
    ```

    ```javascript
    > params.set('enabled', true).set('inactive', false).set('name', 'Basil')
    ```

*   Get a parameter:

    ```javascript
    > params.eggs
    'green'
    ```

*   Override a parameter:

    ```javascript
    > params.set('eggs', 'blue')
    ! Param 'eggs' overridden (`green` with `blue`)
    > params.eggs
    'blue'
    ```

*   Set nested parameters:

    ```javascript
    > params.set('urls.static', '/static/')
    > params.set('urls.media', '/media/')
    > params.urls
    { static: '/static/', media: '/media/' }
    > params.urls.static
    '/static/'
    > params.set('a.b.c', true)
    > params.a.b.c
    true
    ```

*   Push a parameter:

    ```javascript
    > params.push('options', 'editable')
    > params.push('options', 'fancy')
    > params.push('options', 'pants')
    > params.options
    ['editable', 'fancy', 'pants']
    ```

*   Push a parameter:

    ```javascript
    > params.push('config.editor', 'title')
    > params.push('config.editor', 'cover')
    > params.config.editor
    ['title', 'cover']
    ```

*   Get all parameters:

    ```javascript
    > params.getAll()
    {
        eggs: 'blue',
        enabled: true,
        inactive: false,
        name: 'Basil',
        urls: {
            static: '/static/',
            media: '/media/'
        },
        a: {
            b: {
                c: true
            }
        },
        config: {
            editor: ['title', 'cover']
        },
        options: ['editable', 'fancy', 'pants']

    }
    ```

*   Prevent parameter overriding:

    ```javascript
    > strict_params = new Params({ strict: true })
    > strict_params.set('only_set_once', true)
    > strict_params.set('only_set_once', 'fails')
    Error: Param 'only_set_once' was already set with `true`
    > strict_params.only_set_once
    true
    ```

*   Set and unescape a parameter:

    ```javascript
    > params.setUnescaped('title', 'Green Eggs &amp; Ham')
    > params.title
    'Green Eggs & Ham'
    ```

*   Push and unescape a parameter:

    ```javascript
    > params.pushUnescaped('tags', '&lt;br&gt;').pushUnescaped('tags', '&lt;p&gt;')
    > params.tags
    ['<br>', '<p>']
    ```
