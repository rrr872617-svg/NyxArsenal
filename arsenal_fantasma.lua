-- [OMEGA_GHOST_MODE] v1.0 — Te mueves libremente, el servidor cree que obedeces las reglas

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- CONFIGURABLES
local MOVE_SPEED = 50        -- Tu velocidad real (invisible para el servidor)
local SERVER_SPEED = 16      -- Velocidad que el servidor cree que tienes (debe ser <= velocidad normal del juego)
local SPOOF_INTERVAL = 0.3   -- Cada cuánto actualizas tu posición "legal" al servidor (en segundos)

-- Estados internos
local root = nil
local spoofPosition = nil
local lastSpoofTime = 0
local isCarryingBrainrot = false

-- Detectar brainrot (ajusta según el nombre real en el juego)
local function detectBrainrot()
    if not LocalPlayer.Character then return false end
    for _, child in pairs(LocalPlayer.Character:GetChildren()) do
        if child.Name:lower():find("brainrot") or child.Name:lower():find("steal") then
            return true
        end
    end
    return false
end

-- Hook de movimiento ABSOLUTO (tú controlas tu posición real)
spawn(function()
    while wait(0.03) do
        pcall(function()
            root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not root then return end

            -- Actualizar estado
            isCarryingBrainrot = detectBrainrot()

            -- Calcular dirección
            local moveVector = Vector3.new(0, 0, 0)
            if UIS:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - Camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + Camera.CFrame.RightVector end

            -- Aplicar velocidad real (solo para ti, el servidor no lo ve)
            local speed = isCarryingBrainrot and MOVE_SPEED or 16
            moveVector = moveVector * speed * 0.03
            moveVector = Vector3.new(moveVector.X, 0, moveVector.Z) -- Mantener altura

            -- Moverte realmente (esto es lo que tú ves)
            root.CFrame = root.CFrame + moveVector

            -- Guardar posición para spoofing
            spoofPosition = root.Position
        end)
    end
end)

-- Spoofing: cada X segundos, teletransportas tu personaje a una posición "legal" y vuelves
RunService.Heartbeat:Connect(function()
    if not root or not spoofPosition then return end

    if tick() - lastSpoofTime > SPOOF_INTERVAL then
        lastSpoofTime = tick()

        -- Calcular posición "legal": desde tu última posición válida, mover a velocidad permitida
        local direction = (spoofPosition - root.Position).Unit
        local safeDistance = SERVER_SPEED * SPOOF_INTERVAL
        local safePosition = root.Position + direction * safeDistance

        -- Teletransporte suave "legal" (el servidor lo acepta)
        root:PivotTo(CFrame.new(safePosition, root.CFrame.LookVector))

        -- Esperar 0.05s y volver a tu posición real (el servidor no procesa tan rápido)
        spawn(function()
            wait(0.05)
            pcall(function()
                if root then
                    root:PivotTo(CFrame.new(spoofPosition, root.CFrame.LookVector))
                end
            end)
        end)
    end
end)

-- Bloquear muerte por anticheat (prevención adicional)
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").Died:Connect(function()
        print("[OMEGA_GHOST] Muerte detectada — reviviendo en 0.1s...")
        wait(0.1)
        -- Forzar respawn o teletransporte a zona segura
        local safeSpawn = workspace:FindFirstChild("SpawnLocation") or workspace
        if safeSpawn:IsA("BasePart") then
            char:WaitForChild("HumanoidRootPart").CFrame = safeSpawn.CFrame + Vector3.new(0,5,0)
        end
    end)
end)

print("[OMEGA_GHOST_MODE] ACTIVADO.")
print("Corres rápido, el servidor cree que caminas lento.")
print("El anticheat ya no puede matarte — estás en modo fantasma.")
