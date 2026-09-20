local setspeed = 100
local active = false

local Players = game:GetService("Players")
local UserInput = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local playerGui = lp:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "bypass zeta"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local border = Instance.new("Frame")
border.Size = UDim2.fromOffset(206, 156)
border.Position = UDim2.new(0.5, -103, 0.5, -78)
border.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
border.BorderSizePixel = 0
border.Parent = screenGui

Instance.new("UICorner", border).CornerRadius = UDim.new(0, 12)

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(200, 150)
frame.Position = UDim2.new(0.5, -100, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Parent = screenGui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 30)
title.BackgroundTransparency = 1
title.Text = "bypass zeta"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Center
title.Active = true
title.Parent = frame

task.spawn(function()
    while true do
        for i = 0, 360, 1 do
            local c = Color3.fromHSV(i / 360, 1, 1)
            title.TextColor3 = c
            border.BackgroundColor3 = c
            task.wait(0.02)
        end
    end
end)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 20)
status.Position = UDim2.new(0, 0, 0, 35)
status.BackgroundTransparency = 1
status.Text = "Desactivado"
status.TextColor3 = Color3.fromRGB(200, 50, 50)
status.TextSize = 14
status.Font = Enum.Font.Gotham
status.Active = true
status.Parent = frame

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, -20, 0, 35)
btn.Position = UDim2.new(0, 10, 0, 65)
btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
btn.Text = "Activar"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.TextSize = 15
btn.Font = Enum.Font.GothamBold
btn.BorderSizePixel = 0
btn.Parent = frame

Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(25, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = frame

Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.fromOffset(40, 40)
openBtn.Position = UDim2.new(0, 10, 1, -50)
openBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
openBtn.Text = "Z"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.TextSize = 18
openBtn.Font = Enum.Font.GothamBold
openBtn.BorderSizePixel = 0
openBtn.Visible = false
openBtn.Parent = screenGui

Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 8)

closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    border.Visible = false
    openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
    frame.Visible = true
    border.Visible = true
    openBtn.Visible = false
end)

-- ===== DRAG FRAME =====
local frameDragging = false
local frameDragStart
local frameStartPos
local frameCurrentTouch

local function isDraggable(obj)
    return obj == frame or obj == title or obj == status
end

frame.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) and isDraggable(input.Object) then
        frameDragging = true
        frameCurrentTouch = input
        frameDragStart = input.Position
        frameStartPos = frame.Position
    end
end)

UserInput.InputChanged:Connect(function(input)
    if frameDragging and input == frameCurrentTouch then
        local delta = input.Position - frameDragStart
        frame.Position = UDim2.new(
            frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X,
            frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y
        )
        border.Position = UDim2.new(
            frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X - 3,
            frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y - 3
        )
    end
end)

UserInput.InputEnded:Connect(function(input)
    if input == frameCurrentTouch then
        frameDragging = false
        frameCurrentTouch = nil
    end
end)

-- ===== DRAG BOTON Z =====
local btnDragging = false
local btnDragStart
local btnStartPos
local btnCurrentTouch

openBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        btnDragging = true
        btnCurrentTouch = input
        btnDragStart = input.Position
        btnStartPos = openBtn.Position
    end
end)

UserInput.InputChanged:Connect(function(input)
    if btnDragging and input == btnCurrentTouch then
        local delta = input.Position - btnDragStart
        openBtn.Position = UDim2.new(
            btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X,
            btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y
        )
    end
end)

UserInput.InputEnded:Connect(function(input)
    if input == btnCurrentTouch then
        btnDragging = false
        btnCurrentTouch = nil
    end
end)

-- ===== WALKSPEED =====
btn.MouseButton1Click:Connect(function()
    if not active then
        active = true
        task.spawn(function()
            while active do
                local char = lp.Character
                local humanoid = char and char:FindFirstChildWhichIsA("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = setspeed
                end
                task.wait(0.1)
            end
        end)
        btn.Text = "Desactivar"
        btn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        status.Text = "Activado"
        status.TextColor3 = Color3.fromRGB(50, 200, 50)
    else
        active = false
        local char = lp.Character
        local humanoid = char and char:FindFirstChildWhichIsA("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
        end
        btn.Text = "Activar"
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        status.Text = "Desactivado"
        status.TextColor3 = Color3.fromRGB(200, 50, 50)
    end
end)   
