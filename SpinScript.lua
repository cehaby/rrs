--[[
    快速旋转脚本 - 学习用途
    客户端运行，其他玩家可见

    你的妈妈飞到外太空去了 没事为什么要扒拉这个链接
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local rotationSpeed = 1000
local radiansPerSecond = rotationSpeed * 2 * math.pi

local screenGui
local toggleButton
local networkRootPart
local isSpinning = false
local connection

local function createGUI()
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SpinGUI"
    screenGui.Parent = player:WaitForChild("PlayerGui")

    toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleSpin"
    toggleButton.Size = UDim2.new(0, 120, 0, 40)
    toggleButton.Position = UDim2.new(0, 10, 0, 10)
    toggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Text = "开始旋转"
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextSize = 18
    toggleButton.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = toggleButton
end

local function createNetworkedRootPart()
    networkRootPart = Instance.new("Part")
    networkRootPart.Name = "NetworkedRootPart"
    networkRootPart.Anchored = true
    networkRootPart.CanCollide = false
    networkRootPart.Transparency = 1
    networkRootPart.CFrame = humanoidRootPart.CFrame
    networkRootPart.Parent = workspace

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = networkRootPart
    weld.Part1 = humanoidRootPart
    weld.Parent = networkRootPart
end

createGUI()
createNetworkedRootPart()

local function startSpinning()
    if isSpinning then return end
    isSpinning = true
    toggleButton.Text = "停止旋转"
    toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

    connection = RunService.Heartbeat:Connect(function(deltaTime)
        local rotationAmount = radiansPerSecond * deltaTime
        networkRootPart.CFrame = networkRootPart.CFrame * CFrame.Angles(0, rotationAmount, 0)
    end)
end

local function stopSpinning()
    if not isSpinning then return end
    isSpinning = false
    toggleButton.Text = "开始旋转"
    toggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

    if connection then
        connection:Disconnect()
        connection = nil
    end
end

toggleButton.MouseButton1Click:Connect(function()
    if isSpinning then
        stopSpinning()
    else
        startSpinning()
    end
end)

print("点击左上角按钮开始/停止旋转")
