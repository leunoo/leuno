# Leuno UI Library
A modern, sleek UI library for Roblox with a blue/black theme. Perfect for creating powerful game hubs with ease.

## Features
- 🎨 Modern blue/black themed interface
- 🖱️ Fully draggable windows
- 📱 Responsive and smooth animations
- 🔧 Easy-to-use API
- 💾 No browser storage dependencies
- ✨ Polished tween-based interactions
- 🎯 Multiple UI element types
- 🔒 Safe pcall-wrapped callbacks

## Installation
```lua
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/leunoo/leuno/refs/heads/main/source.lua'))()
```

---

## Creating a Window
```lua
local Window = Library:CreateWindow("My Hub Title")

--[[
Title = <string> - The name of the UI window
]]
```

The window will automatically:
- Center itself on the screen
- Be draggable by the title bar
- Include a confirmation close button (click twice to close)

---

## Creating a Tab
```lua
local Tab = Window:CreateTab("Tab Name")

--[[
Name = <string> - The name of the tab
]]
```

Tabs are the main containers for your UI elements. The first tab created will automatically be selected.

---

## Creating a Section
```lua
Tab:AddSection("Section Title")

--[[
Title = <string> - The name of the section
]]
```

Sections are visual headers that help organize your UI elements into labeled groups.

---

## UI Elements

### Button
Creates a clickable button that executes a function.

```lua
Tab:AddButton("Button Text", function()
    print("Button clicked!")
end)

--[[
Title = <string> - The text displayed on the button
Callback = <function> - The function executed when clicked
]]
```

**Example:**
```lua
Tab:AddButton("Teleport to Spawn", function()
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
    end
end)
```

---

### Toggle
Creates a smooth toggle switch with on/off states.

```lua
local Toggle = Tab:AddToggle("Toggle Name", false, function(Value)
    print("Toggle state:", Value)
end)

--[[
Title = <string> - The name of the toggle
Default = <bool> - The default state (true/false)
Callback = <function> - The function executed when toggled
Returns: ToggleObject
]]
```

**Changing Toggle Value:**
```lua
Toggle:Set(true) -- Sets the toggle to enabled
Toggle:Set(false) -- Sets the toggle to disabled
```

**Example:**
```lua
local flyEnabled = false

local FlyToggle = Tab:AddToggle("Fly", false, function(value)
    flyEnabled = value
    if flyEnabled then
        print("Fly enabled")
        -- Enable fly logic
    else
        print("Fly disabled")
        -- Disable fly logic
    end
end)

-- Later in your code:
FlyToggle:Set(true) -- Programmatically enable fly
```

---

### Slider
Creates a draggable slider for numeric values.

```lua
local Slider = Tab:AddSlider("Slider Name", 0, 100, 50, function(Value)
    print("Slider value:", Value)
end)

--[[
Title = <string> - The name of the slider
Min = <number> - The minimum value
Max = <number> - The maximum value
Default = <number> - The default value
Callback = <function> - The function executed when value changes
Returns: SliderObject
]]
```

**Changing Slider Value:**
```lua
Slider:SetValue(75) -- Sets the slider to 75
```

**Example:**
```lua
local walkspeed = 16

Tab:AddSlider("Walkspeed", 16, 500, 16, function(value)
    walkspeed = value
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChildOfClass("Humanoid") then
        character.Humanoid.WalkSpeed = value
    end
end)
```

---

### Keybind
Creates a keybind selector that listens for key presses.

```lua
local Keybind = Tab:AddKeybind("Keybind Name", "E", function(Key)
    print("New key set:", Key)
end)

--[[
Title = <string> - The name of the keybind
DefaultKey = <string> - The default key (e.g., "E", "LeftControl", "Space")
Callback = <function> - The function executed when key is changed
Returns: KeybindObject
]]
```

**Getting Current Key:**
```lua
local currentKey = Keybind:GetKey()
print("Current key:", currentKey)
```

**Example:**
```lua
local toggleKey = "E"

Tab:AddKeybind("Toggle Feature Key", "E", function(key)
    toggleKey = key
    print("Feature will now toggle with:", key)
end)

-- Then use it with UserInputService:
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode.Name == toggleKey then
        print("Feature toggled!")
        -- Toggle your feature
    end
end)
```

---

### Dropdown
Creates a dropdown menu with multiple options.

```lua
local Dropdown = Tab:AddDropdown("Dropdown Name", {"Option 1", "Option 2", "Option 3"}, "Option 1", function(Value)
    print("Selected:", Value)
end)

--[[
Title = <string> - The name of the dropdown
Options = <table> - List of options to choose from
Default = <string> - The default selected option
Callback = <function> - The function executed when selection changes
Returns: DropdownObject
]]
```

**Changing Dropdown Value:**
```lua
Dropdown:SetValue("Option 2") -- Sets dropdown to Option 2
```

**Example:**
```lua
local targetPart = "Head"

Tab:AddDropdown("Target Part", {"Head", "Torso", "HumanoidRootPart", "LeftArm", "RightArm"}, "Head", function(value)
    targetPart = value
    print("Now targeting:", targetPart)
end)
```

---

### Color Picker
Creates a color picker with RGB sliders and live preview.

```lua
local ColorPicker = Tab:AddColorPicker("Color Name", Color3.fromRGB(255, 0, 0), function(Color)
    print("Color selected:", Color)
end)

--[[
Title = <string> - The name of the color picker
Default = <Color3> - The default color
Callback = <function> - The function executed when color changes
Returns: ColorPickerObject
]]
```

**Changing Color Picker Value:**
```lua
ColorPicker:SetColor(Color3.fromRGB(0, 255, 0)) -- Sets color to green
```

**Example:**
```lua
local espColor = Color3.fromRGB(255, 0, 0)

Tab:AddColorPicker("ESP Color", Color3.fromRGB(255, 0, 0), function(color)
    espColor = color
    -- Update all ESP highlights with new color
    for _, highlight in pairs(highlights) do
        highlight.FillColor = color
    end
end)
```

---

## Theme Customization

The library uses a predefined theme that can be customized:

```lua
Library.Theme = {
    Background = Color3.fromRGB(20, 20, 25),      -- Main background
    Secondary = Color3.fromRGB(25, 25, 30),       -- Secondary elements
    Tertiary = Color3.fromRGB(30, 30, 35),        -- Tertiary elements
    Accent = Color3.fromRGB(0, 150, 255),         -- Accent color (blue)
    Text = Color3.fromRGB(255, 255, 255),         -- Primary text
    TextDark = Color3.fromRGB(180, 180, 180),     -- Secondary text
    Border = Color3.fromRGB(40, 40, 45)           -- Border color
}
```

**Customizing the Theme:**
```lua
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/leunoo/leuno/refs/heads/main/source.lua'))()

-- Change theme colors before creating window
Library.Theme.Accent = Color3.fromRGB(255, 0, 0) -- Red accent
Library.Theme.Background = Color3.fromRGB(10, 10, 15) -- Darker background

local Window = Library:CreateWindow("Custom Theme Hub")
```

---

## Complete Example

Here's a full example showing how to create a hub with multiple tabs and features:

```lua
-- Load the library
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/leunoo/leuno/refs/heads/main/source.lua'))()

-- Optional: Customize theme
Library.Theme.Accent = Color3.fromRGB(255, 0, 255) -- Purple accent

-- Create window
local Window = Library:CreateWindow("My Game Hub")

-- Create tabs
local MainTab = Window:CreateTab("Main")
local SettingsTab = Window:CreateTab("Settings")

-- ========================
-- MAIN TAB
-- ========================

MainTab:AddSection("Player Features")

local autoFarmEnabled = false
MainTab:AddToggle("Auto Farm", false, function(value)
    autoFarmEnabled = value
    if value then
        print("Auto farm started")
        -- Start your auto farm loop
    else
        print("Auto farm stopped")
        -- Stop your auto farm loop
    end
end)

local farmSpeed = 5
MainTab:AddSlider("Farm Speed", 1, 10, 5, function(value)
    farmSpeed = value
    print("Farm speed set to:", value)
end)

MainTab:AddSection("Actions")

MainTab:AddButton("Collect All Items", function()
    print("Collecting all items...")
    -- Your collection logic here
end)

MainTab:AddButton("Reset Character", function()
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character.Humanoid.Health = 0
    end
end)

-- ========================
-- SETTINGS TAB
-- ========================

SettingsTab:AddSection("UI Configuration")

SettingsTab:AddKeybind("Toggle UI", "RightControl", function(key)
    print("UI toggle key set to:", key)
end)

SettingsTab:AddDropdown("Theme Preset", {"Blue", "Red", "Green", "Purple"}, "Blue", function(value)
    if value == "Red" then
        Library.Theme.Accent = Color3.fromRGB(255, 0, 0)
    elseif value == "Green" then
        Library.Theme.Accent = Color3.fromRGB(0, 255, 0)
    elseif value == "Purple" then
        Library.Theme.Accent = Color3.fromRGB(255, 0, 255)
    else
        Library.Theme.Accent = Color3.fromRGB(0, 150, 255)
    end
    print("Theme changed to:", value)
end)

SettingsTab:AddSection("Custom Colors")

SettingsTab:AddColorPicker("Accent Color", Color3.fromRGB(0, 150, 255), function(color)
    Library.Theme.Accent = color
    print("Custom accent color set")
end)
```

---

## Best Practices

### 1. Organize with Sections
Use sections to group related features:
```lua
Tab:AddSection("Movement Features")
Tab:AddToggle("Speed Boost", false, callback)
Tab:AddToggle("Flight", false, callback)

Tab:AddSection("Combat Features")
Tab:AddToggle("Auto Attack", false, callback)
Tab:AddToggle("Auto Block", false, callback)
```

### 2. Use Descriptive Names
Make your UI elements clear and easy to understand:
```lua
-- Good ✓
Tab:AddToggle("Enable Auto Farm", false, callback)
Tab:AddSlider("Farming Speed Multiplier", 1, 10, 5, callback)

-- Bad ✗
Tab:AddToggle("AF", false, callback)
Tab:AddSlider("Speed", 1, 10, 5, callback)
```

### 3. Store Elements as Variables
Store elements as variables if you need to update them later:
```lua
local SpeedSlider = Tab:AddSlider("Speed", 16, 500, 16, callback)
local FlyToggle = Tab:AddToggle("Fly", false, callback)

-- Later in your code:
SpeedSlider:SetValue(100)
FlyToggle:Set(true)
```

### 4. Use pcall for Safety
Wrap potentially unsafe operations in pcall:
```lua
Tab:AddButton("Teleport", function()
    pcall(function()
        local player = game.Players.LocalPlayer
        player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
    end)
end)
```

### 5. Add Default Values
Always provide sensible default values:
```lua
Tab:AddSlider("Walkspeed", 16, 500, 16, callback) -- Default: 16
Tab:AddToggle("Feature", false, callback) -- Default: false
Tab:AddDropdown("Mode", {"Mode1", "Mode2"}, "Mode1", callback) -- Default: "Mode1"
```

---

## Advanced Usage

### Handling Character Respawns
Reapply your features after the player respawns:

```lua
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local currentWalkspeed = 16
local flyEnabled = false

player.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Reapply walkspeed
    humanoid.WalkSpeed = currentWalkspeed
    
    -- Restart fly if it was enabled
    if flyEnabled then
        task.wait(0.5)
        -- Restart your fly system
    end
end)
```

### Creating Custom Keybind Systems
Implement keybind detection for your features:

```lua
local UserInputService = game:GetService("UserInputService")

local featureKey = "E"
local featureEnabled = false

Tab:AddKeybind("Toggle Feature", "E", function(key)
    featureKey = key
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode.Name == featureKey then
        featureEnabled = not featureEnabled
        print("Feature toggled:", featureEnabled)
    end
end)
```

### Dynamic Element Updates
Update UI elements based on game state:

```lua
local healthSlider = Tab:AddSlider("Max Health", 100, 1000, 100, function(value)
    local character = game.Players.LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.MaxHealth = value
            humanoid.Health = value
        end
    end
end)

-- Update slider when player respawns
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    healthSlider:SetValue(humanoid.MaxHealth)
end)
```

### Creating Toggle Modes
Implement toggle vs hold modes for features:

```lua
local featureMode = "Toggle"
local featureActive = false
local featureKey = "E"

Tab:AddDropdown("Activation Mode", {"Toggle", "Hold"}, "Toggle", function(value)
    featureMode = value
    featureActive = false
end)

Tab:AddKeybind("Feature Key", "E", function(key)
    featureKey = key
end)

local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode.Name == featureKey then
        if featureMode == "Toggle" then
            featureActive = not featureActive
        else -- Hold mode
            featureActive = true
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode.Name == featureKey and featureMode == "Hold" then
        featureActive = false
    end
end)
```

### Building a Complete Auto Farm
Here's a complete auto farm example using Leuno UI:

```lua
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/leunoo/leuno/refs/heads/main/source.lua'))()
local Window = Library:CreateWindow("Auto Farm Hub")
local MainTab = Window:CreateTab("Main")

MainTab:AddSection("Auto Farm Settings")

local autoFarmEnabled = false
local farmSpeed = 1
local farmDistance = 50

MainTab:AddToggle("Enable Auto Farm", false, function(value)
    autoFarmEnabled = value
end)

MainTab:AddSlider("Farm Speed", 1, 10, 1, function(value)
    farmSpeed = value
end)

MainTab:AddSlider("Max Distance", 10, 100, 50, function(value)
    farmDistance = value
end)

-- Auto Farm Loop
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

RunService.Heartbeat:Connect(function()
    if not autoFarmEnabled then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Find nearest collectible (example: coins)
    local nearestCoin = nil
    local nearestDistance = farmDistance
    
    for _, coin in pairs(workspace.Coins:GetChildren()) do
        if coin:IsA("BasePart") then
            local distance = (coin.Position - humanoidRootPart.Position).Magnitude
            if distance < nearestDistance then
                nearestCoin = coin
                nearestDistance = distance
            end
        end
    end
    
    -- Teleport to nearest coin
    if nearestCoin then
        humanoidRootPart.CFrame = nearestCoin.CFrame
        task.wait(1 / farmSpeed)
    end
end)
```

---

## UI Behavior

### Window Features
- **Draggable:** Click and drag the title bar to move the window
- **Close Confirmation:** Click the X button twice to close (prevents accidental closes)
- **Centered Start:** Window automatically centers on screen load

### Tab Switching
- Click any tab to switch to it
- Active tab is highlighted with the accent color
- Inactive tabs are grayed out

### Element Interactions
- **Toggles:** Click to switch between on/off with smooth animation
- **Sliders:** Click and drag to adjust values
- **Dropdowns:** Click to expand, click option to select, automatically collapses
- **Keybinds:** Click to listen, press any key to set
- **Color Pickers:** Click color display to open picker, adjust RGB values, click Apply/Cancel
- **Buttons:** Click to execute function

---

## Troubleshooting

### UI Not Appearing
**Issue:** The UI doesn't show when the script runs.

**Solutions:**
- Ensure the script is executed in a local environment (LocalScript or Executor)
- Verify you have internet access to load from GitHub
- Check if the game allows custom GUIs in CoreGui
- Wait for the game to fully load before executing

### Elements Not Responding
**Issue:** Clicking buttons/toggles doesn't trigger callbacks.

**Solutions:**
- Verify callbacks are properly defined as functions
- Check console for errors (press F9)
- Ensure callbacks don't contain syntax errors
- Use pcall in callbacks to catch errors

### Window Not Draggable
**Issue:** Can't move the window around.

**Solutions:**
- Make sure you're clicking on the title bar (top blue section)
- Check if another script is interfering with input
- Verify UserInputService is not being blocked

### Theme Changes Not Applying
**Issue:** Theme modifications don't appear.

**Solutions:**
- Modify theme BEFORE creating the window
- Ensure Color3.fromRGB values are valid (0-255)
- Example:
```lua
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/leunoo/leuno/refs/heads/main/source.lua'))()
Library.Theme.Accent = Color3.fromRGB(255, 0, 0) -- Change BEFORE CreateWindow
local Window = Library:CreateWindow("Hub")
```

### Callbacks Not Executing
**Issue:** Functions aren't being called when elements are interacted with.

**Solutions:**
- Verify the callback parameter is a function
- Check for errors in the callback code
- Use print statements to debug
- Wrap risky code in pcall:
```lua
Tab:AddButton("Test", function()
    pcall(function()
        -- Your code here
    end)
end)
```

---

## Technical Details

### Services Used
The library internally uses these Roblox services:
- `UserInputService` - For keybinds and input detection
- `RunService` - For smooth animations and dragging
- `TweenService` - For smooth UI animations
- `CoreGui` - For housing the UI (bypasses ResetOnSpawn)

### Performance
- Minimal impact on game performance
- Uses efficient event connections
- Automatic cleanup on window close
- No memory leaks from disconnected events

### Compatibility
- Works in any Roblox game
- Compatible with most executors
- No external dependencies required
- No browser storage APIs used
- Supports all modern Roblox clients

---

## Credits
**Leuno UI Library v1.0**  
Created by Leuno  
Custom Roblox UI Framework

GitHub: [github.com/leunoo/leuno](https://github.com/leunoo/leuno)

---

## Support & Contributing
For issues, suggestions, or contributions:
- Open an issue on GitHub
- Submit a pull request
- Join the community

## License
This library is provided as-is for educational purposes. Use responsibly and follow Roblox Terms of Service.
