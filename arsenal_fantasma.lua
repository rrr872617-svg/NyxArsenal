-- [OMEGA_UI_TOGGLE] — Steal a Brainrot con interfaz de activación

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- 🎛️ CONFIGURACIÓN EDITABLE
local BRAINROT_ITEM_NAME = "Brainrot"
local SPEED_BOOST = 32
local JUMP_BOOST = 75
local INVISIBILITY_ENABLED = true
local TOGGLE_KEY = Enum.KeyCode.F  -- Cambia la tecla aquí si quieres otra

-- ⚙️ Estados internos
local isActive = false
local loops = {}
local uiFrame = nil

-- 🖼️ Crear interfaz gráfica minimalista
local function createUI()
    if uiFrame then return end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "OmegaBrainrotUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 180, 0, 40)
    Frame.Position = UDim2.new(0.5, -90, 0.1, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Ω Brainrot: OFF"
    Title.TextColor3 = Color3.fromRGB(255, 100, 100)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.Parent = Frame

    Frame.MouseButton1Click:Connect(function()
        isActive = not isActive
        Title.Text = isActive and "Ω Brainrot: ON" or "Ω Brainrot: OFF"
        Title.TextColor3 = isActive and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        
        if isActive then
            startFeatures()
        else
            stopFeatures()
        end
    end)

    Frame.Parent = ScreenGui
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    uiFrame = Frame
end

-- 🔍 Buscar carpeta de coleccionables dinámicamente
local function findCollectFolder()
    local folders = {"Collectibles", "Items", "Pickups", "Loot", "Brainrots", "Stealables"}
    for _, name in pairs(folders) do
        local folder = Workspace:FindFirstChild(name)
        if folder and folder:IsA("Folder") then
            return folder
        end
    end
    warn("[OMEGA] No se encontró carpeta de coleccionables. Auto-rob desactivado.")
    return nil
end

-- 🚀 Iniciar funciones
local function startFeatures()
    if loops.autoRob then return end

    -- Auto-Rob
    loops.autoRob = spawn(function()
        local collectFolder = findCollectFolder()
        while isActive and wait(0.3) do
            pcall(function()
                if collectFolder then
                    for _, obj in pairs(collectFolder:GetChildren()) do
                        if obj:IsA("BasePart") and obj:FindFirstChild("ClickDetector") then
                            fireclickdetector(obj.ClickDetector)
                            print("[OMEGA] Robado: " .. obj.Name)
                        end
                    end
                end
            end)
        end
    end)

    -- Speed & Jump Boost
    loops.speedBoost = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end

        local hum = char:FindFirstChild("Humanoid")
        if not hum then return end

        local hasBrainrot = false
        for _, child in pairs(char:GetChildren()) do
            if child.Name == BRAINROT_ITEM_NAME or child.Name:lower():find("brainrot") then
                hasBrainrot = true
                break
            end
        end

        hum.WalkSpeed = hasBrainrot and SPEED_BOOST or 16
        hum.JumpPower = hasBrainrot and JUMP_BOOST or 50
    end)

    -- 👻 Invisibilidad
    loops.invisibility = spawn(function()
        while isActive and wait(0.5) do
            pcall(function()
                local char = LocalPlayer.Character
                if not char then continue end

                for _, child in pairs(char:GetChildren()) do
                    if child:IsA("BasePart") then
                        child.Transparency = INVISIBILITY_ENABLED and 1 or 0
                        child.CanCollide = false
                    end
                    if child:IsA("Accessory") and child:FindFirstChild("Handle") then
                        child.Handle.Transparency = INVISIBILITY_ENABLED and 1 or 0
                    end
                    if child:IsA("Tool") and (child.Name == BRAINROT_ITEM_NAME or child.Name:lower():find("brainrot")) then
                        child.Transparency = INVISIBILITY_ENABLED and 1 or 0
                    end
                end
            end)
        end
    end)
end

-- ⏹️ Detener funciones
local function stopFeatures()
    for name, loop in pairs(loops) do
        if typeof(loop) == "RBXScriptConnection" then
            loop:Disconnect()
        elseif typeof(loop) == "thread" then
            coroutine.close(loop)
        end
        loops[name] = nil
    end

    -- Restaurar valores normales
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
        end

        for _, child in pairs(char:GetChildren()) do
            if child:IsA("BasePart") then
                child.Transparency = 0
                child.CanCollide = true
            end
            if child:IsA("Accessory") and child:FindFirstChild("Handle") then
                child.Handle.Transparency = 0
            end
            if child:IsA("Tool") and (child.Name == BRAINROT_ITEM_NAME or child.Name:lower():find("brainrot")) then
                child.Transparency = 0
            end
        end
    end
end

-- 🧩 Inicializar
createUI()
print("[OMEGA_UI] Interfaz cargada. Haz clic en el panel o presiona F para activar/desactivar.")

-- ✅ También puedes usar tecla F para alternar
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == TOGGLE_KEY then
        isActive = not isActive
        local frame = uiFrame:FindFirstChildOfClass("TextLabel")
        if frame then
            frame.Text = isActive and "Ω Brainrot: ON" or "Ω Brainrot: OFF"
            frame.TextColor3 = isActive and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        end

        if isActive then
            startFeatures()
        else
            stopFeatures()
        end
    end
end)
