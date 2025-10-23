-- Leuno UI Library
-- A modern, sleek UI library for Roblox
-- Version 1.0

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- UI Library
local Library = {}
Library.Theme = {
    Background = Color3.fromRGB(20, 20, 25),
    Secondary = Color3.fromRGB(25, 25, 30),
    Tertiary = Color3.fromRGB(30, 30, 35),
    Accent = Color3.fromRGB(0, 150, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(180, 180, 180),
    Border = Color3.fromRGB(40, 40, 45)
}

function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LeunoUI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 650, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -325, 0.5, -250)
    MainFrame.BackgroundColor3 = self.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = self.Theme.Secondary
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = TitleBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -50, 1, 0)
    TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = self.Theme.Text
    TitleLabel.TextSize = 18
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
    TitleLabel.Parent = TitleBar
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Library.Theme.Tertiary
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Library.Theme.Text
    CloseButton.TextSize = 16
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TitleBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton
    
    local confirmationActive = false
    
    CloseButton.MouseButton1Click:Connect(function()
        if not confirmationActive then
            confirmationActive = true
            CloseButton.Text = "?"
            CloseButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
            
            task.spawn(function()
                task.wait(3)
                if confirmationActive then
                    confirmationActive = false
                    CloseButton.Text = "X"
                    CloseButton.BackgroundColor3 = Library.Theme.Tertiary
                end
            end)
        else
            ScreenGui:Destroy()
        end
    end)
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, -20, 0, 45)
    TabContainer.Position = UDim2.new(0, 10, 0, 50)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.ClipsDescendants = true
    TabContainer.Parent = MainFrame
    
    local TabList = Instance.new("UIListLayout")
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 8)
    TabList.Parent = TabContainer
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -30, 1, -115)
    ContentContainer.Position = UDim2.new(0, 15, 0, 105)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.ClipsDescendants = true
    ContentContainer.Parent = MainFrame
    
    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingLeft = UDim.new(0, 5)
    ContentPadding.PaddingRight = UDim.new(0, 5)
    ContentPadding.PaddingTop = UDim.new(0, 5)
    ContentPadding.Parent = ContentContainer
    
    -- Make draggable
    local dragging, dragInput, dragStart, startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    RunService.Heartbeat:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    Window.Library = self
    Window.Theme = self.Theme
    Window.ScreenGui = ScreenGui
    Window.MainFrame = MainFrame
    
    function Window:CreateTab(name)
        local Tab = {}
        Tab.Name = name
        Tab.Elements = {}
        
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(0, 140, 0, 40)
        TabButton.BackgroundColor3 = Window.Theme.Tertiary
        TabButton.Text = name
        TabButton.TextColor3 = Window.Theme.TextDark
        TabButton.TextSize = 15
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.BorderSizePixel = 0
        TabButton.Parent = TabContainer
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 10)
        TabCorner.Parent = TabButton
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = self.Theme.Accent
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.ClipsDescendants = true
        TabContent.Parent = ContentContainer
        
        local ContentList = Instance.new("UIListLayout")
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Padding = UDim.new(0, 8)
        ContentList.Parent = TabContent
        
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 10)
        end)
        
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Button.BackgroundColor3 = Window.Theme.Tertiary
                tab.Button.TextColor3 = Window.Theme.TextDark
                tab.Content.Visible = false
            end
            
            TabButton.BackgroundColor3 = Window.Theme.Accent
            TabButton.TextColor3 = Window.Theme.Text
            TabContent.Visible = true
            Window.CurrentTab = Tab
        end)
        
        Tab.Button = TabButton
        Tab.Content = TabContent
        Tab.ContentList = ContentList
        
        function Tab:AddSection(title)
            local Section = Instance.new("Frame")
            Section.Name = title
            Section.Size = UDim2.new(1, -10, 0, 35)
            Section.BackgroundColor3 = Window.Theme.Secondary
            Section.BorderSizePixel = 0
            Section.Parent = TabContent
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 10)
            SectionCorner.Parent = Section
            
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Size = UDim2.new(1, -15, 1, 0)
            SectionTitle.Position = UDim2.new(0, 15, 0, 0)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = title
            SectionTitle.TextColor3 = Window.Theme.Accent
            SectionTitle.TextSize = 16
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = Section
            
            return Section
        end
        
        function Tab:AddButton(title, callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, -10, 0, 40)
            Button.BackgroundColor3 = Library.Theme.Accent
            Button.Text = title
            Button.TextColor3 = Library.Theme.Text
            Button.TextSize = 15
            Button.Font = Enum.Font.GothamSemibold
            Button.BorderSizePixel = 0
            Button.Parent = TabContent
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 10)
            ButtonCorner.Parent = Button
            
            Button.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
            
            return Button
        end
        
        function Tab:AddToggle(title, default, callback)
            local Toggle = Instance.new("Frame")
            Toggle.Size = UDim2.new(1, -10, 0, 40)
            Toggle.BackgroundColor3 = Window.Theme.Secondary
            Toggle.BorderSizePixel = 0
            Toggle.Parent = TabContent
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 10)
            ToggleCorner.Parent = Toggle
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = title
            ToggleLabel.TextColor3 = Window.Theme.Text
            ToggleLabel.TextSize = 15
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = Toggle
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 45, 0, 22)
            ToggleButton.Position = UDim2.new(1, -55, 0.5, -11)
            ToggleButton.BackgroundColor3 = default and Window.Theme.Accent or Window.Theme.Tertiary
            ToggleButton.Text = ""
            ToggleButton.Parent = Toggle
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(1, 0)
            ButtonCorner.Parent = ToggleButton
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
            ToggleCircle.Position = default and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            ToggleCircle.BackgroundColor3 = Window.Theme.Text
            ToggleCircle.BorderSizePixel = 0
            ToggleCircle.Parent = ToggleButton
            
            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = ToggleCircle
            
            local toggled = default
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                
                local bgTween = TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = toggled and Window.Theme.Accent or Window.Theme.Tertiary
                })
                
                local posTween = TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                    Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
                })
                
                bgTween:Play()
                posTween:Play()
                
                pcall(function()
                    callback(toggled)
                end)
            end)
            
            local ToggleObject = {}
            function ToggleObject:Set(value)
                toggled = value
                ToggleButton.BackgroundColor3 = toggled and Window.Theme.Accent or Window.Theme.Tertiary
                ToggleCircle.Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            end
            
            return ToggleObject
        end
        
        function Tab:AddSlider(title, min, max, default, callback)
            local Slider = Instance.new("Frame")
            Slider.Size = UDim2.new(1, -10, 0, 55)
            Slider.BackgroundColor3 = Window.Theme.Secondary
            Slider.BorderSizePixel = 0
            Slider.Parent = TabContent
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 10)
            SliderCorner.Parent = Slider
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, -70, 0, 22)
            SliderLabel.Position = UDim2.new(0, 15, 0, 8)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = title
            SliderLabel.TextColor3 = Window.Theme.Text
            SliderLabel.TextSize = 15
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = Slider
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0, 55, 0, 22)
            ValueLabel.Position = UDim2.new(1, -65, 0, 8)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(default)
            ValueLabel.TextColor3 = Window.Theme.Accent
            ValueLabel.TextSize = 15
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = Slider
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -30, 0, 5)
            SliderBar.Position = UDim2.new(0, 15, 1, -18)
            SliderBar.BackgroundColor3 = Window.Theme.Tertiary
            SliderBar.BorderSizePixel = 0
            SliderBar.Parent = Slider
            
            local BarCorner = Instance.new("UICorner")
            BarCorner.CornerRadius = UDim.new(1, 0)
            BarCorner.Parent = SliderBar
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Window.Theme.Accent
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBar
            
            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = SliderFill
            
            local SliderButton = Instance.new("TextButton")
            SliderButton.Size = UDim2.new(1, 0, 1, 0)
            SliderButton.BackgroundTransparency = 1
            SliderButton.Text = ""
            SliderButton.Parent = SliderBar
            
            local dragging = false
            
            local function updateSlider(input)
                local pos = input.Position
                local relativeX = math.clamp((pos.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * relativeX)
                
                ValueLabel.Text = tostring(value)
                SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
                pcall(function()
                    callback(value)
                end)
            end
            
            SliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateSlider(input)
                end
            end)
            
            SliderButton.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
            
            local SliderObject = {}
            function SliderObject:SetValue(value)
                ValueLabel.Text = tostring(value)
                local relativeX = (value - min) / (max - min)
                SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            end
            
            return SliderObject
        end
        
        function Tab:AddKeybind(title, defaultKey, callback)
            local Keybind = Instance.new("Frame")
            Keybind.Size = UDim2.new(1, -10, 0, 40)
            Keybind.BackgroundColor3 = Window.Theme.Secondary
            Keybind.BorderSizePixel = 0
            Keybind.Parent = TabContent
            
            local KeybindCorner = Instance.new("UICorner")
            KeybindCorner.CornerRadius = UDim.new(0, 10)
            KeybindCorner.Parent = Keybind
            
            local KeybindLabel = Instance.new("TextLabel")
            KeybindLabel.Size = UDim2.new(0, 140, 1, 0)
            KeybindLabel.Position = UDim2.new(0, 15, 0, 0)
            KeybindLabel.BackgroundTransparency = 1
            KeybindLabel.Text = title
            KeybindLabel.TextColor3 = Window.Theme.Text
            KeybindLabel.TextSize = 15
            KeybindLabel.Font = Enum.Font.Gotham
            KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
            KeybindLabel.Parent = Keybind
            
            local KeybindButton = Instance.new("TextButton")
            KeybindButton.Size = UDim2.new(1, -165, 0, 28)
            KeybindButton.Position = UDim2.new(0, 155, 0, 6)
            KeybindButton.BackgroundColor3 = Window.Theme.Tertiary
            KeybindButton.Text = defaultKey
            KeybindButton.TextColor3 = Window.Theme.Text
            KeybindButton.TextSize = 14
            KeybindButton.Font = Enum.Font.Gotham
            KeybindButton.Parent = Keybind
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 8)
            BtnCorner.Parent = KeybindButton
            
            local currentKey = defaultKey
            local listening = false
            
            KeybindButton.MouseButton1Click:Connect(function()
                if listening then return end
                listening = true
                KeybindButton.Text = "..."
                
                local connection
                connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode.Name
                        KeybindButton.Text = currentKey
                        listening = false
                        connection:Disconnect()
                        pcall(function()
                            callback(currentKey)
                        end)
                    end
                end)
            end)
            
            local KeybindObject = {}
            KeybindObject.CurrentKey = currentKey
            
            function KeybindObject:GetKey()
                return currentKey
            end
            
            return KeybindObject
        end
        
        function Tab:AddDropdown(title, options, default, callback)
            local Dropdown = Instance.new("Frame")
            Dropdown.Size = UDim2.new(1, -10, 0, 40)
            Dropdown.BackgroundColor3 = Library.Theme.Secondary
            Dropdown.BorderSizePixel = 0
            Dropdown.Parent = TabContent
            
            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 10)
            DropdownCorner.Parent = Dropdown
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Size = UDim2.new(0, 140, 1, 0)
            DropdownLabel.Position = UDim2.new(0, 15, 0, 0)
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Text = title
            DropdownLabel.TextColor3 = Library.Theme.Text
            DropdownLabel.TextSize = 15
            DropdownLabel.Font = Enum.Font.Gotham
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.Parent = Dropdown
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(1, -165, 0, 28)
            DropdownButton.Position = UDim2.new(0, 155, 0, 6)
            DropdownButton.BackgroundColor3 = Library.Theme.Tertiary
            DropdownButton.Text = default or options[1] or "Select"
            DropdownButton.TextColor3 = Library.Theme.Text
            DropdownButton.TextSize = 14
            DropdownButton.Font = Enum.Font.Gotham
            DropdownButton.Parent = Dropdown
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 8)
            BtnCorner.Parent = DropdownButton
            
            local DropdownList = Instance.new("Frame")
            DropdownList.Size = UDim2.new(1, -165, 0, 0)
            DropdownList.Position = UDim2.new(0, 155, 0, 40)
            DropdownList.BackgroundColor3 = Library.Theme.Tertiary
            DropdownList.BorderSizePixel = 0
            DropdownList.Visible = false
            DropdownList.ClipsDescendants = true
            DropdownList.ZIndex = 10
            DropdownList.Parent = Dropdown
            
            local ListCorner = Instance.new("UICorner")
            ListCorner.CornerRadius = UDim.new(0, 8)
            ListCorner.Parent = DropdownList
            
            local ListLayout = Instance.new("UIListLayout")
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Parent = DropdownList
            
            local isOpen = false
            
            DropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                
                if isOpen then
                    Dropdown.Size = UDim2.new(1, -10, 0, 40 + (#options * 28))
                    DropdownList.Visible = true
                    TweenService:Create(DropdownList, TweenInfo.new(0.2), {
                        Size = UDim2.new(1, -165, 0, #options * 28)
                    }):Play()
                else
                    TweenService:Create(DropdownList, TweenInfo.new(0.2), {
                        Size = UDim2.new(1, -165, 0, 0)
                    }):Play()
                    wait(0.2)
                    DropdownList.Visible = false
                    Dropdown.Size = UDim2.new(1, -10, 0, 40)
                end
            end)
            
            for _, option in pairs(options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Size = UDim2.new(1, 0, 0, 28)
                OptionButton.BackgroundColor3 = Library.Theme.Tertiary
                OptionButton.BackgroundTransparency = 0.5
                OptionButton.Text = option
                OptionButton.TextColor3 = Library.Theme.Text
                OptionButton.TextSize = 14
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.BorderSizePixel = 0
                OptionButton.Parent = DropdownList
                
                local OptionCorner = Instance.new("UICorner")
                OptionCorner.CornerRadius = UDim.new(0, 6)
                OptionCorner.Parent = OptionButton
                
                OptionButton.MouseEnter:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.1), {
                        BackgroundTransparency = 0
                    }):Play()
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.1), {
                        BackgroundTransparency = 0.5
                    }):Play()
                end)
                
                OptionButton.MouseButton1Click:Connect(function()
                    DropdownButton.Text = option
                    isOpen = false
                    TweenService:Create(DropdownList, TweenInfo.new(0.2), {
                        Size = UDim2.new(1, -165, 0, 0)
                    }):Play()
                    task.wait(0.2)
                    DropdownList.Visible = false
                    Dropdown.Size = UDim2.new(1, -10, 0, 40)
                    pcall(function()
                        callback(option)
                    end)
                end)
            end
            
            local DropdownObject = {}
            function DropdownObject:SetValue(value)
                DropdownButton.Text = value
            end
            
            return DropdownObject
        end
        
        function Tab:AddColorPicker(title, default, callback)
            local ColorPicker = Instance.new("Frame")
            ColorPicker.Size = UDim2.new(1, -10, 0, 40)
            ColorPicker.BackgroundColor3 = Window.Theme.Secondary
            ColorPicker.BorderSizePixel = 0
            ColorPicker.Parent = TabContent
            
            local PickerCorner = Instance.new("UICorner")
            PickerCorner.CornerRadius = UDim.new(0, 10)
            PickerCorner.Parent = ColorPicker
            
            local PickerLabel = Instance.new("TextLabel")
            PickerLabel.Size = UDim2.new(0, 140, 1, 0)
            PickerLabel.Position = UDim2.new(0, 15, 0, 0)
            PickerLabel.BackgroundTransparency = 1
            PickerLabel.Text = title
            PickerLabel.TextColor3 = Window.Theme.Text
            PickerLabel.TextSize = 15
            PickerLabel.Font = Enum.Font.Gotham
            PickerLabel.TextXAlignment = Enum.TextXAlignment.Left
            PickerLabel.Parent = ColorPicker
            
            local ColorDisplay = Instance.new("TextButton")
            ColorDisplay.Size = UDim2.new(0, 80, 0, 28)
            ColorDisplay.Position = UDim2.new(1, -90, 0, 6)
            ColorDisplay.BackgroundColor3 = default
            ColorDisplay.Text = ""
            ColorDisplay.Parent = ColorPicker
            
            local DisplayCorner = Instance.new("UICorner")
            DisplayCorner.CornerRadius = UDim.new(0, 8)
            DisplayCorner.Parent = ColorDisplay
            
            -- Color Picker Popup
            local ColorPickerFrame = Instance.new("Frame")
            ColorPickerFrame.Size = UDim2.new(0, 200, 0, 220)
            ColorPickerFrame.Position = UDim2.new(1, 10, 0, 0)
            ColorPickerFrame.AnchorPoint = Vector2.new(0, 0)
            ColorPickerFrame.BackgroundColor3 = Window.Theme.Background
            ColorPickerFrame.BorderSizePixel = 1
            ColorPickerFrame.BorderColor3 = Window.Theme.Border
            ColorPickerFrame.Visible = false
            ColorPickerFrame.ZIndex = 1000
            ColorPickerFrame.Parent = ColorDisplay
            
            local PickerFrameCorner = Instance.new("UICorner")
            PickerFrameCorner.CornerRadius = UDim.new(0, 10)
            PickerFrameCorner.Parent = ColorPickerFrame
            
            local PickerTitle = Instance.new("TextLabel")
            PickerTitle.Size = UDim2.new(1, 0, 0, 30)
            PickerTitle.BackgroundColor3 = Window.Theme.Secondary
            PickerTitle.BorderSizePixel = 0
            PickerTitle.Text = "Pick Color"
            PickerTitle.TextColor3 = Window.Theme.Text
            PickerTitle.TextSize = 14
            PickerTitle.Font = Enum.Font.GothamBold
            PickerTitle.Parent = ColorPickerFrame
            
            local TitleCorner = Instance.new("UICorner")
            TitleCorner.CornerRadius = UDim.new(0, 10)
            TitleCorner.Parent = PickerTitle
            
            -- RGB Sliders
            local RSlider = Instance.new("TextLabel")
            RSlider.Size = UDim2.new(0, 20, 0, 20)
            RSlider.Position = UDim2.new(0, 10, 0, 40)
            RSlider.BackgroundTransparency = 1
            RSlider.Text = "R:"
            RSlider.TextColor3 = Color3.fromRGB(255, 100, 100)
            RSlider.TextSize = 14
            RSlider.Font = Enum.Font.GothamBold
            RSlider.Parent = ColorPickerFrame
            
            local RInput = Instance.new("TextBox")
            RInput.Size = UDim2.new(0, 150, 0, 25)
            RInput.Position = UDim2.new(0, 35, 0, 38)
            RInput.BackgroundColor3 = Window.Theme.Tertiary
            RInput.Text = tostring(math.floor(default.R * 255))
            RInput.TextColor3 = Window.Theme.Text
            RInput.TextSize = 12
            RInput.Font = Enum.Font.Gotham
            RInput.ClearTextOnFocus = false
            RInput.Parent = ColorPickerFrame
            
            local RInputCorner = Instance.new("UICorner")
            RInputCorner.CornerRadius = UDim.new(0, 4)
            RInputCorner.Parent = RInput
            
            local GSlider = Instance.new("TextLabel")
            GSlider.Size = UDim2.new(0, 20, 0, 20)
            GSlider.Position = UDim2.new(0, 10, 0, 75)
            GSlider.BackgroundTransparency = 1
            GSlider.Text = "G:"
            GSlider.TextColor3 = Color3.fromRGB(100, 255, 100)
            GSlider.TextSize = 14
            GSlider.Font = Enum.Font.GothamBold
            GSlider.Parent = ColorPickerFrame
            
            local GInput = Instance.new("TextBox")
            GInput.Size = UDim2.new(0, 150, 0, 25)
            GInput.Position = UDim2.new(0, 35, 0, 73)
            GInput.BackgroundColor3 = Window.Theme.Tertiary
            GInput.Text = tostring(math.floor(default.G * 255))
            GInput.TextColor3 = Window.Theme.Text
            GInput.TextSize = 12
            GInput.Font = Enum.Font.Gotham
            GInput.ClearTextOnFocus = false
            GInput.Parent = ColorPickerFrame
            
            local GInputCorner = Instance.new("UICorner")
            GInputCorner.CornerRadius = UDim.new(0, 4)
            GInputCorner.Parent = GInput
            
            local BSlider = Instance.new("TextLabel")
            BSlider.Size = UDim2.new(0, 20, 0, 20)
            BSlider.Position = UDim2.new(0, 10, 0, 110)
            BSlider.BackgroundTransparency = 1
            BSlider.Text = "B:"
            BSlider.TextColor3 = Color3.fromRGB(100, 100, 255)
            BSlider.TextSize = 14
            BSlider.Font = Enum.Font.GothamBold
            BSlider.Parent = ColorPickerFrame
            
            local BInput = Instance.new("TextBox")
            BInput.Size = UDim2.new(0, 150, 0, 25)
            BInput.Position = UDim2.new(0, 35, 0, 108)
            BInput.BackgroundColor3 = Window.Theme.Tertiary
            BInput.Text = tostring(math.floor(default.B * 255))
            BInput.TextColor3 = Window.Theme.Text
            BInput.TextSize = 12
            BInput.Font = Enum.Font.Gotham
            BInput.ClearTextOnFocus = false
            BInput.Parent = ColorPickerFrame
            
            local BInputCorner = Instance.new("UICorner")
            BInputCorner.CornerRadius = UDim.new(0, 4)
            BInputCorner.Parent = BInput
            
            local PreviewBox = Instance.new("Frame")
            PreviewBox.Size = UDim2.new(0, 180, 0, 30)
            PreviewBox.Position = UDim2.new(0, 10, 0, 145)
            PreviewBox.BackgroundColor3 = default
            PreviewBox.BorderSizePixel = 0
            PreviewBox.Parent = ColorPickerFrame
            
            local PreviewCorner = Instance.new("UICorner")
            PreviewCorner.CornerRadius = UDim.new(0, 6)
            PreviewCorner.Parent = PreviewBox
            
            local ApplyButton = Instance.new("TextButton")
            ApplyButton.Size = UDim2.new(0, 85, 0, 25)
            ApplyButton.Position = UDim2.new(0, 10, 1, -30)
            ApplyButton.BackgroundColor3 = Window.Theme.Accent
            ApplyButton.Text = "Apply"
            ApplyButton.TextColor3 = Window.Theme.Text
            ApplyButton.TextSize = 12
            ApplyButton.Font = Enum.Font.GothamBold
            ApplyButton.Parent = ColorPickerFrame
            
            local ApplyCorner = Instance.new("UICorner")
            ApplyCorner.CornerRadius = UDim.new(0, 6)
            ApplyCorner.Parent = ApplyButton
            
            local CancelButton = Instance.new("TextButton")
            CancelButton.Size = UDim2.new(0, 85, 0, 25)
            CancelButton.Position = UDim2.new(1, -95, 1, -30)
            CancelButton.BackgroundColor3 = Window.Theme.Tertiary
            CancelButton.Text = "Cancel"
            CancelButton.TextColor3 = Window.Theme.Text
            CancelButton.TextSize = 12
            CancelButton.Font = Enum.Font.GothamBold
            CancelButton.Parent = ColorPickerFrame
            
            local CancelCorner = Instance.new("UICorner")
            CancelCorner.CornerRadius = UDim.new(0, 6)
            CancelCorner.Parent = CancelButton
            
            local function updatePreview()
                local r = math.clamp(tonumber(RInput.Text) or 0, 0, 255)
                local g = math.clamp(tonumber(GInput.Text) or 0, 0, 255)
                local b = math.clamp(tonumber(BInput.Text) or 0, 0, 255)
                
                RInput.Text = tostring(r)
                GInput.Text = tostring(g)
                BInput.Text = tostring(b)
                
                local color = Color3.fromRGB(r, g, b)
                PreviewBox.BackgroundColor3 = color
                return color
            end
            
            RInput.FocusLost:Connect(updatePreview)
            GInput.FocusLost:Connect(updatePreview)
            BInput.FocusLost:Connect(updatePreview)
            
            ColorDisplay.MouseButton1Click:Connect(function()
                ColorPickerFrame.Visible = not ColorPickerFrame.Visible
            end)
            
            ApplyButton.MouseButton1Click:Connect(function()
                local color = updatePreview()
                ColorDisplay.BackgroundColor3 = color
                ColorPickerFrame.Visible = false
                pcall(function()
                    callback(color)
                end)
            end)
            
            CancelButton.MouseButton1Click:Connect(function()
                ColorPickerFrame.Visible = false
                RInput.Text = tostring(math.floor(ColorDisplay.BackgroundColor3.R * 255))
                GInput.Text = tostring(math.floor(ColorDisplay.BackgroundColor3.G * 255))
                BInput.Text = tostring(math.floor(ColorDisplay.BackgroundColor3.B * 255))
            end)
            
            local ColorPickerObject = {}
            function ColorPickerObject:SetColor(color)
                ColorDisplay.BackgroundColor3 = color
                RInput.Text = tostring(math.floor(color.R * 255))
                GInput.Text = tostring(math.floor(color.G * 255))
                BInput.Text = tostring(math.floor(color.B * 255))
            end
            
            return ColorPickerObject
        end
        
        table.insert(Window.Tabs, Tab)
        
        if #Window.Tabs == 1 then
            TabButton.BackgroundColor3 = Library.Theme.Accent
            TabButton.TextColor3 = Library.Theme.Text
            TabContent.Visible = true
            Window.CurrentTab = Tab
        end
        
        return Tab
    end
    
    return Window
end

return Library
