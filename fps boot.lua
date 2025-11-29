--=====================================================
-- MOBILE-FRIENDLY GAME UTILITY UI
--=====================================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--== UI SETUP ==
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Toggle = Instance.new("TextButton", ScreenGui)
Toggle.Size = UDim2.new(0,120,0,40)
Toggle.Position = UDim2.new(0,20,0,20)
Toggle.Text = "OPEN PANEL"
Toggle.BackgroundColor3 = Color3.fromRGB(0,150,255)
Toggle.TextColor3 = Color3.new(1,1,1)

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0,360,0,450)
Main.Position = UDim2.new(0.5,-180,0.5,-225)
Main.BackgroundColor3 = Color3.fromRGB(30,30,35)
Main.Visible = false
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "Game Utility Panel"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Color3.new(1,1,1)

-- ScrollFrame สำหรับปุ่มทั้งหมด
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1,-20,1,-60)
Scroll.Position = UDim2.new(0,10,0,50)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Scroll.ScrollBarThickness = 6

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0,5)
UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0,0,0,UIList.AbsoluteContentSize.Y + 10)
end)

--== FUNCTIONS ==
-- ปรับภาพต่ำ
local function setLowGraphics()
    game:GetService("Lighting").GlobalShadows = false
    game:GetService("Lighting").FogEnd = 9e9
    game:GetService("Lighting").Brightness = 0.5
    for _,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.Plastic
            v.CastShadow = false
        end
    end
end

-- ลบ Effects และ Map / Workspace / ReplicatedStorage
local function removeEffectsAndMap()
    -- ลบ VFX และ Object ขึ้นต้นด้วย Effect
    for _,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v.Name:match("^Effect") then
            v:Destroy()
        end
    end

    -- ตรวจ Map, Cutscenes, Thrown ใน Workspace
    local foldersToRemove = {"Map","MAP","Cutscenes","Thrown"}
    for _,folderName in ipairs(foldersToRemove) do
        for _,folder in ipairs(workspace:GetChildren()) do
            if folder:IsA("Folder") and folder.Name:match("^"..folderName.."$") then
                for _,part in ipairs(folder:GetChildren()) do
                    if part:IsA("BasePart") then
                        local pos = part.Position
                        local size = part.Size
                        part:Destroy()
                        local base = Instance.new("Part")
                        base.Size = size
                        base.Position = pos
                        base.Anchored = true
                        base.Parent = workspace
                    else
                        part:Destroy()
                    end
                end
                folder:Destroy()
            end
        end
    end

    -- ตรวจ Resources และ Cutscenes ใน ReplicatedStorage
    local rsFolders = {"Resources","Cutscenes"}
    for _,folderName in ipairs(rsFolders) do
        for _,folder in ipairs(ReplicatedStorage:GetChildren()) do
            if folder:IsA("Folder") and folder.Name:match("^"..folderName.."$") then
                folder:Destroy()
            end
        end
    end
end

-- Target Player
local function targetPlayerUI()
    -- สร้าง Popup
    local popup = Instance.new("Frame", ScreenGui)
    popup.Size = UDim2.new(0,300,0,150)
    popup.Position = UDim2.new(0.5,-150,0.5,-75)
    popup.BackgroundColor3 = Color3.fromRGB(40,40,40)

    local title = Instance.new("TextLabel", popup)
    title.Size = UDim2.new(1,0,0,30)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.new(1,1,1)
    title.Text = "Enter Player Name"

    local input = Instance.new("TextBox", popup)
    input.Size = UDim2.new(1,-20,0,30)
    input.Position = UDim2.new(0,10,0,40)
    input.Text = ""

    local ok = Instance.new("TextButton", popup)
    ok.Size = UDim2.new(0,80,0,30)
    ok.Position = UDim2.new(0.5,-40,0,80)
    ok.Text = "OK"
    ok.BackgroundColor3 = Color3.fromRGB(0,180,0)
    ok.TextColor3 = Color3.new(1,1,1)

    local close = Instance.new("TextButton", popup)
    close.Size = UDim2.new(0,80,0,30)
    close.Position = UDim2.new(0.5,-40,0,115)
    close.Text = "Close"
    close.BackgroundColor3 = Color3.fromRGB(180,60,60)
    close.TextColor3 = Color3.new(1,1,1)

    ok.MouseButton1Click:Connect(function()
        local targetName = input.Text
        local target = Players:FindFirstChild(targetName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-3)
                -- ติดตามด้านหลัง
                game:GetService("RunService").RenderStepped:Connect(function()
                    if hrp.Parent and target.Character then
                        hrp.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-3)
                    end
                end)
            end
        end
        popup:Destroy()
    end)

    close.MouseButton1Click:Connect(function()
        popup:Destroy()
    end)
end

--== BUTTONS ==
local buttons = {
    {Name="Set Low Graphics", Func=setLowGraphics},
    {Name="Remove Effects & Map", Func=removeEffectsAndMap},
    {Name="Target Player", Func=targetPlayerUI},
    {Name="Low Graphics + Remove All", Func=function()
        setLowGraphics()
        removeEffectsAndMap()
    end},
}

for _,btnData in ipairs(buttons) do
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(1,0,0,50)
    btn.Text = btnData.Name
    btn.BackgroundColor3 = Color3.fromRGB(0,150,255)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.MouseButton1Click:Connect(btnData.Func)
end

--== TOGGLE UI ==
Toggle.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    Toggle.Text = Main.Visible and "CLOSE PANEL" or "OPEN PANEL"
end)
