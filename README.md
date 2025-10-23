# Leuno UI Library

A modern, sleek UI library for Roblox with a blue/black theme.

## Installation

```lua
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/leunoo/leuno/refs/heads/main/source.lua'))()
```

## Documentation

For complete documentation, examples, and advanced usage, see [documentation.md](documentation.md)

## Quick Example

```lua
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/leunoo/leuno/refs/heads/main/source.lua'))()

local Window = Library:CreateWindow("My Hub")
local Tab = Window:CreateTab("Main")

Tab:AddSection("Features")

Tab:AddToggle("Auto Farm", false, function(value)
    print("Auto Farm:", value)
end)

Tab:AddSlider("Speed", 16, 500, 16, function(value)
    print("Speed:", value)
end)

Tab:AddButton("Click Me", function()
    print("Button clicked!")
end)
```

## Features

- Modern blue/black themed interface
- Fully draggable windows
- Smooth animations
- Easy-to-use API
- Multiple UI elements (Buttons, Toggles, Sliders, Keybinds, Dropdowns, Color Pickers)
- No browser storage dependencies

## Credits

Created by Leuno

## License

MIT License
