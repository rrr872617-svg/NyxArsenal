--[[
    FANTASMA DELTA v1.0 — Oracle-Nexus
    Optimizado para Delta Executor.
    Objetivo: Invisibilidad local, invulnerabilidad, robo instantáneo, velocidad acelerada.
]]

print("[Oracle-Nexus] Activando protocolo FANTASMA DELTA...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- ▬▬▬▬▬▬ INVISIBILIDAD LOCAL (PARA CONFUNDIR RIVALES) ▬▬▬▬▬▬
print(" -> Aplicando invisibilidad local...")

for _, obj in pairs(Character:GetDescendants()) do
    if obj:IsA("BasePart") then
        obj.Transparency = 1
        obj.CanCollide = false
    end
end

-- Ocultar cabeza y accesorios
if Character:FindFirstChild("Head") then
    Character.Head.Transparency = 1
    if Character.Head:FindFirstChild("face") then
        Character.Head.face:Destroy()
    end
end

-- ▬▬▬▬▬▬ INVULNERABILIDAD REAL ▬▬▬▬▬▬
print(" -> Aplicando invulnerabilidad...")

Humanoid.MaxHealth = math.huge
Humanoid.Health = math.huge
Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

-- Bloquear daño
local oldTakeDamage = Humanoid.TakeDamage
Humanoid.TakeDamage = function() return 0 end

-- ▬▬▬▬▬▬ VELOCIDAD DE MOVIMIENTO Y SALTO ▬▬▬▬▬▬
print(" -> Aumentando velocidad y salto...")

Humanoid.WalkSpeed = 32
Humanoid.JumpPower = 75

-- Mantener velocidad (evita que el juego la reduzca)
RunService.Heartbeat:Connect(function()
    Humanoid.WalkSpeed = 32
    Humanoid.JumpPower = 75
    Humanoid.Health = math.huge
end)

-- ▬▬▬▬▬▬ ROBO INSTANTÁNEO (SIN ESPERAR ANIMACIÓN) ▬▬▬▬▬▬
print(" -> Activando robo instantáneo...")

local function autoSteal()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "Brainrot" or obj.Name:find("Brainrot") or obj.Name:find("Steal") then
            if (obj.Position - RootPart.Position).Magnitude < 15 then -- Aumentamos rango
                -- Buscar ProximityPrompt
                local prompt = obj:FindFirstChild("ProximityPrompt") or obj:FindFirstChildWhichIsA("ProximityPrompt")
                if prompt then
                    fireproximityprompt(prompt)
                end
            end
        end
    end
end

-- Ejecutar robo cada 0.1 segundos
RunService.Heartbeat:Connect(autoSteal)

-- ▬▬▬▬▬▬ MANTENER EFECTOS AL MORIR O REAPARECER ▬▬▬▬▬▬
LocalPlayer.CharacterAdded:Connect(function(newChar)
    wait(1)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
    -- Reaplicar invisibilidad e invulnerabilidad
    for _, obj in pairs(Character:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Transparency = 1
            obj.CanCollide = false
        end
    end
    Humanoid.MaxHealth = math.huge
    Humanoid.Health = math.huge
    Humanoid.WalkSpeed = 32
    Humanoid.JumpPower = 75
end)

print("[FANTASMA DELTA] ¡ACTIVADO!")
print(" > Eres invisible (para ti), invulnerable, robas al instante y te mueves rápido.")
print(" > Acércate a cualquier Brainrot y se robará automáticamente.")
print(" > Disfruta del caos controlado. Cuenta desechable activa. Sin miedo.")
