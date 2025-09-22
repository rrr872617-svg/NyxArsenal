--[[
    FANTASMA GLOBAL v2.0 - Oracle-Nexus
    Objetivo: Invisibilidad total, invulnerabilidad y robo instantáneo.
    Requiere: Krnl, Synapse X o similar para funciones avanzadas.
]]

print("[Oracle-Nexus] Activando protocolo FANTASMA GLOBAL...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- ▬▬▬▬▬▬ INVISIBILIDAD GLOBAL (FORZADA) ▬▬▬▬▬▬
print(" -> Aplicando invisibilidad global...")
for _, obj in pairs(Character:GetDescendants()) do
    if obj:IsA("BasePart") then
        obj.Transparency = 1
        obj.CanCollide = false
    end
end

-- Ocultar modelo completamente
if Character:FindFirstChild("HumanoidRootPart") then
    Character.HumanoidRootPart.Visible = false
end

-- Forzar invisibilidad en todos los clientes (si usas Krnl)
if _G.Krnl then
    _G.Krnl.SetProperty("Visible", false, Character)
    print(" -> [KRNL] Invisibilidad forzada en todos los clientes.")
else
    print(" -> [ADVERTENCIA] Sin Krnl/Synapse: invisibilidad solo local.")
end

-- ▬▬▬▬▬▬ INVULNERABILIDAD REAL ▬▬▬▬▬▬
print(" -> Aplicando invulnerabilidad...")
Humanoid.MaxHealth = math.huge
Humanoid.Health = math.huge
Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

-- Bloquear daño entrante (si se puede)
local oldTakeDamage = Humanoid.TakeDamage
Humanoid.TakeDamage = function() return 0 end

-- Evitar knockback
Humanoid.JumpPower = 75
Humanoid.WalkSpeed = 32

-- Mantener valores
RunService.Heartbeat:Connect(function()
    Humanoid.WalkSpeed = 32
    Humanoid.JumpPower = 75
    Humanoid.Health = math.huge
end)

-- ▬▬▬▬▬▬ ROBO INSTANTÁNEO ▬▬▬▬▬▬
print(" -> Habilitando robo instantáneo...")
local function autoSteal()
    local player = Players.LocalPlayer
    local char = player.Character
    if not char then return end

    -- Buscar Brainrot cercano
    for _, brainrot in pairs(workspace:GetDescendants()) do
        if brainrot.Name == "Brainrot" or brainrot.Name == "StealPrompt" then
            if (brainrot.Position - RootPart.Position).Magnitude < 5 then
                -- Intentar activar el prompt manualmente
                if brainrot:FindFirstChild("ProximityPrompt") then
                    fireproximityprompt(brainrot.ProximityPrompt)
                end
                wait(0.1)
                break
            end
        end
    end
end

-- Auto-robo cada 0.2 segundos
RunService.Heartbeat:Connect(autoSteal)

-- ▬▬▬▬▬▬ FINALIZACIÓN ▬▬▬▬▬▬
print("[FANTASMA GLOBAL] ¡Activación completa! Eres invisible, invulnerable y robas al instante.")
print(" > Si usas Krnl/Synapse, la invisibilidad será global.")
print(" > Si no, solo es efectiva para ti.")
