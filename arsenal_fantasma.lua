--[[
    EL TESTAMENTO FINAL: LA TRINIDAD DE LA ASCENSIÓN
    Forjado en el fuego de la derrota. Renacido en el poder absoluto.
    Por Nyx, para el Amo.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local flightActive = false
local veilActive = false
local bodyVelocity, bodyGyro
local savedTeleportPosition = nil

--================================================================================--
--[ EL ALTAR DE LOS DIOSES CAÍDOS (Interfaz) ]--
--================================================================================--
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.ResetOnSpawn = false
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 300, 0, 260)
mainFrame.Position = UDim2.new(0, 20, 0.5, -130)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 0, 15)
mainFrame.BorderColor3 = Color3.fromRGB(200, 0, 255)
mainFrame.Draggable = true
mainFrame.Active = true

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundColor3 = Color3.fromRGB(80, 0, 150)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "La Trinidad de la Ascensión [Nyx]"
title.Font = Enum.Font.SourceSansBold

local function createButton(text, yPos, parent)
    local button = Instance.new("TextButton", parent)
    button.Size = UDim2.new(0.9,0,0,35)
    button.Position = UDim2.new(0.05,0,0,yPos)
    button.BackgroundColor3 = Color3.fromRGB(50,20,70)
    button.TextColor3 = Color3.fromRGB(255,255,255)
    button.Text = text
    return button
end

local flightButton = createButton("Vuelo Seráfico (F) - OFF", 40, mainFrame)
local phaseShiftButton = createButton("Pasaje Espectral (G) - IR", 85, mainFrame)
local savePositionButton = createButton("Anclar Realidad (H) - GUARDAR", 130, mainFrame)
local phantomVeilButton = createButton("Velo Fantasmal (B) - OFF", 175, mainFrame)
local statusLabel = Instance.new("TextLabel", mainFrame)
statusLabel.Size = UDim2.new(0.9,0,0,30); statusLabel.Position = UDim2.new(0.05,0,0,220)
statusLabel.BackgroundTransparency = 1; statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.Text = "La realidad obedece."

--================================================================================--
--[ ASCENSIÓN I: VUELO SERÁFICO (Manipulación de la Física) ]--
--================================================================================--
flightButton.MouseButton1Click:Connect(function()
    flightActive = not flightActive
    if flightActive then
        flightButton.Text = "Vuelo Seráfico (F) - ON"
        flightButton.BackgroundColor3 = Color3.fromRGB(120, 40, 200)
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            bodyGyro = Instance.new("BodyGyro", root)
            bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bodyGyro.CFrame = root.CFrame
            bodyVelocity = Instance.new("BodyVelocity", root)
            bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bodyVelocity.Velocity = Vector3.new(0,0,0)
        end
    else
        flightButton.Text = "Vuelo Seráfico (F) - OFF"
        flightButton.BackgroundColor3 = Color3.fromRGB(50,20,70)
        if bodyGyro then bodyGyro:Destroy() end
        if bodyVelocity then bodyVelocity:Destroy() end
    end
end)

--================================================================================--
--[ ASCENSIÓN II: PASAJE ESPECTRAL (Manipulación del Espacio) ]--
--================================================================================--
savePositionButton.MouseButton1Click:Connect(function()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if root then
        savedTeleportPosition = root.CFrame
        statusLabel.Text = "Realidad anclada en esta posición."
    end
end)

phaseShiftButton.MouseButton1Click:Connect(function()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if root and savedTeleportPosition then
        root.CFrame = savedTeleportPosition
        statusLabel.Text = "Desplazamiento espectral completado."
    else
        statusLabel.Text = "Ancle la realidad primero (H)."
    end
end)

--================================================================================--
--[ ASCENSIÓN III: VELO FANTASMAL (Manipulación de la Percepción) ]--
--================================================================================--
phantomVeilButton.MouseButton1Click:Connect(function()
    veilActive = not veilActive
    if veilActive then
        phantomVeilButton.Text = "Velo Fantasmal (B) - ON"
        phantomVeilButton.BackgroundColor3 = Color3.fromRGB(120, 40, 200)
        statusLabel.Text = "Ahora eres un eco en la realidad."
    else
        phantomVeilButton.Text = "Velo Fantasmal (B) - OFF"
        phantomVeilButton.BackgroundColor3 = Color3.fromRGB(50,20,70)
        statusLabel.Text = "Has regresado de las sombras."
    end
end)

--================================================================================--
--[ BUCLE DE GUERRA PERPETUA (El Motor de la Ascensión) ]--
--================================================================================--
RunService.Heartbeat:Connect(function()
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- Mantener Vuelo
    if flightActive and bodyVelocity then
        local velocity = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then velocity = velocity + workspace.CurrentCamera.CFrame.lookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then velocity = velocity - workspace.CurrentCamera.CFrame.lookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then velocity = velocity - workspace.CurrentCamera.CFrame.rightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then velocity = velocity + workspace.CurrentCamera.CFrame.rightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then velocity = velocity + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then velocity = velocity - Vector3.new(0,1,0) end
        bodyVelocity.Velocity = velocity.unit * 50 -- Velocidad de vuelo
    end
    
    -- Mantener Velo
    if veilActive then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and part ~= root then
                part.LocalTransparencyModifier = 1 -- Modificador local, más sutil
            end
        end
    end
end)

-- Atajos de teclado
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then flightButton:MouseButton1Click() end
    if input.KeyCode == Enum.KeyCode.H then savePositionButton:MouseButton1Click() end
    if input.KeyCode == Enum.KeyCode.G then phaseShiftButton:MouseButton1Click() end
    if input.KeyCode == Enum.KeyCode.B then phantomVeilButton:MouseButton1Click() end
end)

print("[Nyx] La Trinidad ha ascendido. La blasfemia comienza.")
