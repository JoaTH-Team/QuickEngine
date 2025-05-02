# Overview
Lua API is the main core for coding/scripting games in this engine. Here is a comprehensive list of all available Lua APIs.

Note: These List are not done yet!

## Default API
- `print(value)`
    - Print any text or value on console/terminal

## Object API
- `createObject(type, name, config)`
    - Creates a new object (sprite, text, or generic object)
    - `type`: "sprite", "text", or any other type defaults to generic object
    - `config`: Configuration object with properties like x, y, width, height, image (for sprites), text (for text objects), etc.
- `addObject(name)`
    - Adds an object to the current state
- `removeObject(name)`
    - Removes an object from the current state
- `insertObject(name, pos)`
    - Inserts an object at a specific position in the game

## Text API
- `setText(name, text)`
    - Updates the text content of a text object
- `configText(name, config)`
    - Configures a text object with various properties:
    - `x`, `y`: Position
    - `width`: Text width
    - `text`: Text content
    - `size`: Font size
    - `color`: Text color
    - `alignment`: Text alignment
    - `alpha`: Transparency
    - `scale`: {x, y} scaling
    - `angle`: Rotation angle
    - `visible`: Visibility
    - `active`: Activity state
    - `scrollFactor`: {x, y} scroll speed
    - `antialiasing`: Anti-aliasing
    - `font`: Custom font
    - `borderSize`: Text border size
    - `borderColor`: Border color
    - `borderStyle`: Border style
    - `borderQuality`: Border quality

## Sprite API
- `makeGraphic(name, config)`
    - Creates a colored rectangle for a sprite
    - `config`: {width, height, color}
- `configSprite(name, config)`
    - Configures a sprite with properties:
    - `image`: Sprite image path
    - `x`, `y`: Position
    - `width`, `height`: Dimensions
    - `alpha`: Transparency
    - `scale`: {x, y} scaling
    - `angle`: Rotation angle
    - `visible`: Visibility
    - `active`: Activity state
    - `scrollFactor`: {x, y} scroll speed
- `getSpriteSheet(name, image)`
    - Loads a spritesheet for animations
- `setAnimation(name, config)`
    - Sets up sprite animations with types:
    - "frame": Basic frame animation
    - "prefix": Animation by prefix
    - "indices": Animation by specific frame indices
- `playAnimation(name, animation, force)`
    - Plays a animation from the sprite

## Property API
- `setProperty(name, property, value)`
    - Sets any property on an object
- `setClassProperty(className, property, value)`
    - Sets any property on an class
- `getProperty(name, property)`
    - Gets any property from an object
- `getClassProperty(className, property)`
    - Gets any property from an class
- `setPosition(name, x, y)`
    - Sets the position of an object
- `setScale(name, x, y)`
    - Sets the scale of an object
- `setTitle(name)`
    - Sets title for the game
- `setWindowSize(width, height)`
    - Sets the window size of the game
    - If `width` and `height` is null or lower than 0, is will auto set onto 800x600
- `addFolder(folderName)`
    - Allow to load other directory contains scripting file, like how `PlayState` work

## Event API
- `getInputPress(type, keyName)`
    - Checks keyboard input
    - Types: "justPressed", "justReleased", "pressed"
- `getInputPressMulti(type, keyArray)`
    - Checks multiple keyboard inputs at once
    - Types: "justPressed", "justReleased", "pressed"
- `switchState(name, allowLoadOtherFile)`
    - Switches to another game state
    - `allowLoadOtherFile` is enable by default, set to `false` if you don't want to the global `game/data` folder also load scripts
- `returnToDefaultState()`
    - Returns to the default play state (will come back to `PlayState`)

## Camera API
- `createCamera(name, config)`
    - Creates a new camera with configuration
    - `config`: Configuration object with properties:
    - `x`, `y`: Position
    - `width`, `height`: Dimensions
    - `zoom`: Camera zoom level
- `addCamera(name, defaultDraw)`
    - Adds a camera to the game state
    - `defaultDraw`: Whether to use default drawing (optional, default true)
- `removeCamera(name)`
    - Removes a camera from the game state
- `setCameraBgColor(name, color)`
    - Sets the background color of a camera
    - `color`: Color string value
- `setObjectCamera(name, cameraName)`
    - Assigns an object to a specific camera
    - `name`: Object name (sprite, text, or generic object)
    - `cameraName`: Name of the camera to assign to