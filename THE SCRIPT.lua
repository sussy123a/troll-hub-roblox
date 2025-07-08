-- Troll GUI 2025 v2 (No parts / No DefaultChatSystemChatEvents)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "TrollHubV2"

local frame = Instance.new("Frame", gui)
frame.Position = UDim2.new(0.35, 0, 0.35, 0)
frame.Size = UDim2.new(0, 300, 0, 400)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = false

-- Top Bar
local dragBar = Instance.new("TextLabel", frame)
dragBar.Size = UDim2.new(1, 0, 0, 30)
dragBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
dragBar.BorderSizePixel = 0
dragBar.Text = "Troll Hub v1 by noneilike"
dragBar.TextColor3 = Color3.new(1, 1, 1)
dragBar.Font = Enum.Font.SourceSansBold
dragBar.TextSize = 18
dragBar.Name = "DragBar"

-- Minimize Button
local minimize = Instance.new("TextButton", dragBar)
minimize.Size = UDim2.new(0, 30, 0, 30)
minimize.Position = UDim2.new(1, -30, 0, 0)
minimize.Text = "-"
minimize.Font = Enum.Font.SourceSansBold
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
minimize.BorderSizePixel = 0

local minimized = false
minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, child in ipairs(frame:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("Frame") then
            child.Visible = not minimized
        end
    end
    dragBar.Visible = true -- Keep bar visible
    minimize.Visible = true
end)

-- Dragging Logic
local dragging, dragInput, dragStart, startPos

dragBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

dragBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Layout
local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Padding below top bar
local pad = Instance.new("Frame", frame)
pad.Size = UDim2.new(1, 0, 0, 35)
pad.BackgroundTransparency = 1
pad.LayoutOrder = 0

-- Toggle storage
local toggles = {}

-- Button builder
local function addButton(name, func)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1, -10, 0, 40)
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.BorderSizePixel = 0
    b.LayoutOrder = 1
    b.MouseButton1Click:Connect(function()
        func(name)
    end)
end

-- Buttons
addButton("Chat Spam /e", function(id)
    if toggles[id] then toggles[id] = nil return end
    toggles[id] = true
    while toggles[id] do
        StarterGui:SetCore("ChatMakeSystemMessage", {Text = "/e LOL u got trolled"})
        task.wait(1)
    end
end)

addButton("Orbit Nearest Player", function(id)
    if toggles[id] then toggles[id] = nil return end
    toggles[id] = true
    task.spawn(function()
        local angle = 0
        while toggles[id] do
            local closest = nil
            local dist = math.huge
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if d < dist then
                        closest = p
                        dist = d
                    end
                end
            end
            if closest then
                angle += 0.1
                local offset = Vector3.new(math.cos(angle)*5, 0, math.sin(angle)*5)
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(closest.Character.HumanoidRootPart.Position + offset)
            end
            task.wait()
        end
    end)
end)

addButton("Lag (Spam Accessories)", function(id)
    if toggles[id] then toggles[id] = nil return end
    toggles[id] = true
    task.spawn(function()
        while toggles[id] do
            for _, acc in ipairs(LocalPlayer.Character:GetChildren()) do
                if acc:IsA("Accessory") then
                    acc:Clone().Parent = LocalPlayer.Character
                end
            end
            task.wait(0.05)
        end
    end)
end)

addButton("Lag (Animation Spam)", function(id)
    if toggles[id] then toggles[id] = nil return end
    toggles[id] = true
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    task.spawn(function()
        while toggles[id] and humanoid do
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://148840371"
            humanoid:LoadAnimation(anim):Play()
            task.wait(0.01)
        end
    end)
end)

addButton("Fling Nearest", function(id)
    if toggles[id] then toggles[id] = nil return end
    toggles[id] = true
    task.spawn(function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local function getClosest()
            local closest, dist = nil, math.huge
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (hrp.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if d < dist then
                        closest = p
                        dist = d
                    end
                end
            end
            return closest
        end
        local target = getClosest()
        if not target then return end
        while toggles[id] and target.Character do
            hrp.CFrame = target.Character.HumanoidRootPart.CFrame
            hrp.Velocity = Vector3.new(9999, 9999, 0)
            task.wait()
        end
    end)
end)

addButton("Invisible (FE Glitch)", function()
    local char = LocalPlayer.Character
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        local clone = char:Clone()
        clone.Parent = workspace
        root:Destroy()
    end
end)

addButton("Fake Lag (Freeze)", function()
    while true do
        RunService.RenderStepped:Wait()
    end
end)
