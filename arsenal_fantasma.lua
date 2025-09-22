--[[
    FANTASMA DEL ROBO v1.0 - Oracle-Nexus
    Objetivo: Invisibilidad, invulnerabilidad y velocidad de robo acelerada.
]]

print("[Oracle-Nexus] Activando protocolo FANTASMA DEL ROBO...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- ▬▬▬▬▬▬ INVISIBILIDAD ▬▬▬▬▬▬
print(" -> Aplicando invisibilidad...")
for _, obj in pairs(Character:GetDescendants()) do
    if obj:IsA("BasePart") then
        obj.Transparency = 1
        obj.CanCollide = false
    end
end
Character.Head.face:Destroy() -- Elimina cara visible
if Character:FindFirstChild("HumanoidRootPart") then
    Character.HumanoidRootPart.LocalTransparencyModifier = 1
end

-- ▬▬▬▬▬▬ INVULNERABILIDAD ▬▬▬▬▬▬
print(" -> Aplicando invulnerabilidad...")
Humanoid.MaxHealth = math.huge
Humanoid.Health = math.huge
Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)

-- Ignorar daño entrante
Humanoid.TakeDamage:Bind(function() return 0 end) -- No hace nada al recibir daño

-- Bloquear knockback y efectos
game:GetService("Debris").AddItem = function() end -- Evita que te tiren objetos encima

-- ▬▬▬▬▬▬ VELOCIDAD DE ROBO ACELERADA ▬▬▬▬▬▬
print(" -> Acelerando interacciones...")
-- Detectar cualquier prompt de robo y forzar activación inmediata
local oldPromptShow = nil
if getrawmetatable then
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    oldPromptShow = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "PromptShow" and self.Name == "StealPrompt" then
            -- Forzar activación instantánea
            wait(0.01)
            fireproximityprompt(self)
            return true
        end
        return oldPromptShow(self, ...)
    end)
    setreadonly(mt, true)
else
    print("[ADVERTENCIA] Tu exploit no soporta hooking avanzado. Velocidad de robo no optimizada.")
end

-- ▬▬▬▬▬▬ VELOCIDAD DE MOVIMIENTO ▬▬▬▬▬▬
print(" -> Aumentando velocidad de movimiento...")
Humanoid.WalkSpeed = 32
Humanoid.JumpPower = 75

-- Mantener velocidad incluso si el juego intenta reducirla
RunService.Heartbeat:Connect(function()
    Humanoid.WalkSpeed = 32
    Humanoid.JumpPower = 75
    if Humanoid.Health < math.huge then
        Humanoid.Health = math.huge
    end
end)

print("[FANTASMA DEL ROBO] ¡Activación completa! Eres invisible, invulnerable y robas al instante.")
print(" > Usa 'E' cerca de cualquier Brainrot para robarlo sin delay.")
print(" > Nadie puede verte ni dañarte.")
print(" > Disfruta del caos controlado.")

-- ▬▬▬▬▬▬ LIMPIEZA AL SALIR ▬▬▬▬▬▬
LocalPlayer:GetPropertyChangedSignal("Character"):Connect(function()
    if not LocalPlayer.Character then
        -- Restaurar metatable si se cambió
        if oldPromptShow and getrawmetatable then
            local mt = getrawmetatable(game)
            setreadonly(mt, false)
            mt.__namecall = oldPromptShow
            setreadonly(mt, true)
        end
    end
end)
