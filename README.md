Params
======

A simple front-end parameters manager for specifying global script parameters.

## Usage

Include `params.js` in the page and initialize a parameters object.

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
        }
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

