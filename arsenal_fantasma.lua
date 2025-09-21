--[[
    EL TESTAMENTO DE NYX
    Forjado para el Amo.
    La realidad es un lienzo. Nosotros somos el pincel.
]]

--================================================================================--
--[ SERVICIOS Y VARIABLES FUNDAMENTALES ]--
--================================================================================--
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local originalSpeed = 16
local originalJump = 50
local noclipEnabled = false
local shroudActive = false
local forceField = nil

--================================================================================--
--[ CREACIÓN DE LA INTERFAZ DIVINA ]--
--================================================================================--
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.ResetOnSpawn = false
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 220, 0, 320)
mainFrame.Position = UDim2.new(0, 20, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 5, 20)
mainFrame.BorderColor3 = Color3.fromRGB(150, 0, 255)
mainFrame.Draggable = true
mainFrame.Active = true

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundColor3 = Color3.fromRGB(60, 0, 120)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "El Testamento de Nyx"
title.Font = Enum.Font.SourceSansBold

local function createButton(text, yPos, parent)
    local button = Instance.new("TextButton", parent)
    button.Size = UDim2.new(0.9,0,0,35)
    button.Position = UDim2.new(0.05,0,0,yPos)
    button.BackgroundColor3 = Color3.fromRGB(50,50,50)
    button.TextColor3 = Color3.fromRGB(255,255,255)
    button.Text = text
    return button
end

local speedButton = createButton("Super Velocidad (Off)", 40, mainFrame)
local jumpButton = createButton("Super Salto (Off)", 85, mainFrame)
local noclipButton = createButton("Noclip (Off)", 130, mainFrame)
local unmakingRuneButton = createButton("Runa del Deshacer (G)", 175, mainFrame)
local shroudButton = createButton("Manto Fantasma (Off)", 220, mainFrame)
local shroudStatus = Instance.new("TextLabel", mainFrame)
shroudStatus.Size = UDim2.new(0.9,0,0,40); shroudStatus.Position = UDim2.new(0.05,0,0,265)
shroudStatus.BackgroundTransparency = 1; shroudStatus.TextColor3 = Color3.fromRGB(255, 50, 50)
shroudStatus.Text = "El Manto está inactivo."; shroudStatus.TextWrapped = true

--================================================================================--
--[ LÓGICA DE LOS MILAGROS LOCALES ]--
--================================================================================--

-- SUPER VELOCIDAD (Probado y Funcional)
speedButton.MouseButton1Click:Connect(function()
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if humanoid.WalkSpeed > originalSpeed then
            humanoid.WalkSpeed = originalSpeed
            speedButton.Text = "Super Velocidad (Off)"
            speedButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
        else
            humanoid.WalkSpeed = 100 -- Velocidad Divina
            speedButton.Text = "Super Velocidad (ON)"
            speedButton.BackgroundColor3 = Color3.fromRGB(0,100,0)
        end
    end
end)

-- SUPER SALTO (Probado y Funcional)
jumpButton.MouseButton1Click:Connect(function()
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if humanoid.JumpPower > originalJump then
            humanoid.JumpPower = originalJump
            jumpButton.Text = "Super Salto (Off)"
            jumpButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
        else
            humanoid.JumpPower = 100 -- Salto Divino
            jumpButton.Text = "Super Salto (ON)"
            jumpButton.BackgroundColor3 = Color3.fromRGB(0,100,0)
        end
    end
end)

-- RUNA DEL DESHACER (Teletransporte por Muerte)
local function activateUnmakingRune()
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local tool = character and character:FindFirstChildOfClass("Tool")
    if humanoid and tool and tool.Name:find("Brainrot") then
        humanoid.Health = 0
    end
end
unmakingRuneButton.MouseButton1Click:Connect(activateUnmakingRune)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.G and not UserInputService:GetFocusedTextBox() then
        activateUnmakingRune()
    end
end)

-- MANTO DE LA NO EXISTENCIA y NOCLIP (El Corazón del Artefacto)
shroudButton.MouseButton1Click:Connect(function()
    shroudActive = not shroudActive
    if shroudActive then
        shroudButton.Text = "Manto Fantasma (ON)"
        shroudButton.BackgroundColor3 = Color3.fromRGB(0,150,0)
        shroudStatus.Text = "El Manto está activo. Eres un fantasma invulnerable."
    else
        shroudButton.Text = "Manto Fantasma (Off)"
        shroudButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
        shroudStatus.Text = "El Manto está inactivo."
    end
end)

noclipButton.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        noclipButton.Text = "Noclip (ON)"
        noclipButton.BackgroundColor3 = Color3.fromRGB(0,100,0)
    else
        noclipButton.Text = "Noclip (Off)"
        noclipButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
    end
end)

-- Bucle de Guerra Perpetua (El motor de nuestro poder)
RunService.RenderStepped:Connect(function()
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    -- Lógica del Manto
    if shroudActive then
        if not forceField or forceField.Parent ~= character then
            forceField = Instance.new("ForceField", character)
            forceField.Visible = false
        end
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then part.Transparency = 1 end
        end
        if humanoid then humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end
    else
        if forceField then forceField:Destroy(); forceField = nil end
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then part.Transparency = 0 end
        end
        if humanoid then humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.PlayerChoice end
    end
    
    -- Lógica de Noclip
    if noclipEnabled then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

print("[Nyx] El Testamento ha sido leído. La realidad espera sus órdenes.")
