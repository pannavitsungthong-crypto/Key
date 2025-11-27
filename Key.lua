--// CONFIG
local CorrectKey = "MYSECRETKEY"   -- Change your key here
local KeyLink = "https://your-key-link.com" -- When pressing GET KEY, this link will be copied

--// LOADSTRING TO RUN AFTER CORRECT KEY
local ScriptToRun = [[
    loadstring(game:HttpGet("https://raw.githubusercontent.com/baconluck7-stack/ui-ex/refs/heads/main/ui%20ex"))()

]]
--// GUI CREATION
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Background overlay
local Blur = Instance.new("Frame")
Blur.Size = UDim2.new(1,0,1,0)
Blur.BackgroundColor3 = Color3.fromRGB(20,20,20)
Blur.BackgroundTransparency = 0.25
Blur.Parent = ScreenGui

-- Main Key UI
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 240)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -120)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.BackgroundTransparency = 0.15
MainFrame.Parent = ScreenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "KEY SYSTEM"
Title.TextColor3 = Color3.fromRGB(0, 255, 180)
Title.TextSize = 26
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Key Input
local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0.85, 0, 0, 40)
KeyBox.Position = UDim2.new(0.075, 0, 0.32, 0)
KeyBox.BackgroundColor3 = Color3.fromRGB(15,15,15)
KeyBox.PlaceholderText = "Enter your key..."
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.fromRGB(255,255,255)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 20
KeyBox.Parent = MainFrame

local corner2 = corner:Clone()
corner2.Parent = KeyBox

-- Confirm Button
local Confirm = Instance.new("TextButton")
Confirm.Size = UDim2.new(0.85, 0, 0, 40)
Confirm.Position = UDim2.new(0.075, 0, 0.58, 0)
Confirm.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
Confirm.Text = "Confirm Key"
Confirm.TextColor3 = Color3.fromRGB(0,0,0)
Confirm.TextSize = 20
Confirm.Font = Enum.Font.GothamBold
Confirm.Parent = MainFrame

local corner3 = corner:Clone()
corner3.Parent = Confirm

-- Get Key Button
local GetKey = Instance.new("TextButton")
GetKey.Size = UDim2.new(0.85, 0, 0, 35)
GetKey.Position = UDim2.new(0.075, 0, 0.78, 0)
GetKey.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
GetKey.Text = "Get Key"
GetKey.TextColor3 = Color3.fromRGB(255,255,255)
GetKey.TextSize = 18
GetKey.Font = Enum.Font.GothamBold
GetKey.Parent = MainFrame

local corner4 = corner:Clone()
corner4.Parent = GetKey

-- Error Text
local ErrorText = Instance.new("TextLabel")
ErrorText.Size = UDim2.new(1,0,0,25)
ErrorText.Position = UDim2.new(0,0,0.88,0)
ErrorText.BackgroundTransparency = 1
ErrorText.Text = ""
ErrorText.TextColor3 = Color3.fromRGB(255,70,70)
ErrorText.TextSize = 18
ErrorText.Font = Enum.Font.Gotham
ErrorText.Parent = MainFrame

-- Clipboard API
local Clipboard = setclipboard or toclipboard or function() end

-- Get Key button copy link
GetKey.MouseButton1Click:Connect(function()
    Clipboard(KeyLink)
    ErrorText.Text = "✔ Key link copied!"
    ErrorText.TextColor3 = Color3.fromRGB(0,255,120)

    task.delay(1.3, function()
        ErrorText.Text = ""
        ErrorText.TextColor3 = Color3.fromRGB(255,70,70)
    end)
end)

-- Confirm Key button
Confirm.MouseButton1Click:Connect(function()
    if KeyBox.Text == CorrectKey then
        
        -- Hide UI with animation
        MainFrame:TweenPosition(UDim2.new(0.5,-175,-1,0),"Out","Quart",0.6,true)
        Blur:TweenSize(UDim2.new(1,0,0,0),"Out","Quad",0.6,true)
        wait(0.6)
        Blur.Visible = false

        -- Run loadstring script
        local fn = loadstring(ScriptToRun)
        if fn then
            fn()
        else
            warn("Failed to load the script.")
        end

    else
        ErrorText.Text = "Incorrect Key!"
        ErrorText.TextColor3 = Color3.fromRGB(255,70,70)
        task.delay(1.5, function()
            ErrorText.Text = ""
        end)
    end
end)
