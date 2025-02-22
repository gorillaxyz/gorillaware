local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local playerGui = player:WaitForChild("PlayerGui")

-- Create GUI
local screenGui = Instance.new("ScreenGui", playerGui)

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 250, 0, 250)
frame.Position = UDim2.new(0.5, -125, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.8
frame.BorderSizePixel = 0

-- Make GUI Draggable
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)
frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Title Bar
local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.Text = "Gay Deleter"
titleLabel.TextSize = 18
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1

-- Function to Equip "gunr"
local function equipGun()
    local gunr = player.Backpack:FindFirstChild("gunr")
    if gunr then
        player.Character.Humanoid:EquipTool(gunr)
    end
end

-- Function to spam gunfire at clicked player for 3 seconds
local function spamEventAtTarget(target)
    local character = target.Parent
    if character and character:FindFirstChild("HumanoidRootPart") then
        equipGun()
        local startTime = tick()

        while tick() - startTime < 3 do
            if character and character:FindFirstChild("HumanoidRootPart") then
                local args = {character.HumanoidRootPart.Position, 3000}
                player.Character.gunr.RemoteEvent:FireServer(unpack(args))
            end
            wait(0.1)  -- Adjust spam rate
        end
    end
end

-- Detect mouse click on a player
mouse.Button1Down:Connect(function()
    local target = mouse.Target
    if target and target.Parent and target.Parent:FindFirstChild("Humanoid") then
        spamEventAtTarget(target)
    end
end)

-- Function for KILL ALL
local function killAll()
    equipGun()
    for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local args = {plr.Character.HumanoidRootPart.Position, 3000}
            player.Character.gunr.RemoteEvent:FireServer(unpack(args))
        end
    end
end

-- Function for DELETE MAP
local function deleteMap()
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj.Name ~= "Baseplate" and not game.Players:GetPlayerFromCharacter(obj) then
            obj:Destroy()
        end
    end
end

-- Function for GUN TP
local function gunTp()
    local targetPart = workspace:FindFirstChild("Gunr") and workspace.Gunr:FindFirstChild("Handle")
    if targetPart then
        local originalPosition = player.Character.HumanoidRootPart.Position
        player.Character:SetPrimaryPartCFrame(targetPart.CFrame)
        wait(1)
        player.Character:SetPrimaryPartCFrame(CFrame.new(originalPosition))
    end
end

-- Buttons
local function createButton(parent, text, position, color, action)
    local button = Instance.new("TextButton", parent)
    button.Size = UDim2.new(0, 230, 0, 40)
    button.Position = position
    button.Text = text
    button.BackgroundColor3 = color
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 18
    button.BorderSizePixel = 0
    button.MouseButton1Click:Connect(action)
end

createButton(frame, "KILL ALL", UDim2.new(0, 10, 0, 40), Color3.fromRGB(255, 0, 0), killAll)
createButton(frame, "DELETE MAP", UDim2.new(0, 10, 0, 90), Color3.fromRGB(255, 255, 0), deleteMap)
createButton(frame, "GUN TP", UDim2.new(0, 10, 0, 140), Color3.fromRGB(0, 0, 255), gunTp)

-- Made By Gorilla Label
local madeByLabel = Instance.new("TextLabel", frame)
madeByLabel.Size = UDim2.new(0, 230, 0, 40)
madeByLabel.Position = UDim2.new(0, 10, 0, 190)
madeByLabel.Text = "MADE BY GORILLA"
madeByLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
madeByLabel.TextSize = 18
madeByLabel.BackgroundTransparency = 1

print("Made by Gorilla")
