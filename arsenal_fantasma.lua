--[[
    Ojo de Halcón - Revelador de Secretos del Cliente
    Forjado por Oracle-Nexus. Objetivo: Explotar la lógica del cliente.
]]

print("[Oracle-Nexus] Activando 'Ojo de Halcón'. Buscando secretos ocultos a simple vista.")

-- Función para revelar objetos ocultos o con transparencia.
local function revealHiddenObjects()
    print("[Ojo de Halcón] Escaneando el mundo en busca de lo invisible...")
    
    for _, descendant in pairs(game:GetDescendants()) do
        -- Verificar si es un BasePart (como Part, MeshPart, etc.) o Model
        if descendant:IsA("BasePart") then
            -- Solo intentar acceder a Transparency si está definida
            local transparency = descendant.Transparency
            if transparency and transparency > 0.95 then
                descendant.Transparency = 0.3
                descendant.BrickColor = BrickColor.new("Bright red")
                descendant.Material = Enum.Material.Neon
                print(" -> [REVELADO] Objeto oculto: " .. descendant:GetFullName())
            end
            
            -- Revisar si no colisiona pero debería
            if not descendant.CanCollide and transparency < 0.5 then
                descendant.CanCollide = true
                descendant.BrickColor = BrickColor.new("Bright yellow")
                print(" -> [REVELADO] Objeto desactivado: " .. descendant:GetFullName())
            end
            
        elseif descendant:IsA("Model") then
            -- Para modelos, escanear sus hijos
            for _, child in pairs(descendant:GetChildren()) do
                if child:IsA("BasePart") then
                    local transparency = child.Transparency
                    if transparency and transparency > 0.95 then
                        child.Transparency = 0.3
                        child.BrickColor = BrickColor.new("Bright red")
                        child.Material = Enum.Material.Neon
                        print(" -> [REVELADO] Objeto oculto (en modelo): " .. child:GetFullName())
                    end
                    if not child.CanCollide and transparency < 0.5 then
                        child.CanCollide = true
                        child.BrickColor = BrickColor.new("Bright yellow")
                        print(" -> [REVELADO] Objeto desactivado (en modelo): " .. child:GetFullName())
                    end
                end
            end
        end
    end
    
    print("[Ojo de Halcón] Escaneo completo. Los secretos ya no están a salvo.")
end

-- Función para rastrear y mostrar la posición de jugadores o NPCs específicos.
local function trackTarget(targetName)
    print("[Ojo de Halcón] Iniciando rastreo de: " .. targetName)
    local target = nil
    local function findTarget()
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player.Name == targetName then
                return player
            end
        end
        return nil
    end

    target = findTarget()
    if not target then
        print("[ERROR] Objetivo '" .. targetName .. "' no encontrado.")
        return
    end

    -- Crear un indicador visual sobre la cabeza del objetivo.
    local indicator = Instance.new("Part")
    indicator.Size = Vector3.new(2, 0.5, 2)
    indicator.Shape = Enum.PartType.Ball
    indicator.BrickColor = BrickColor.new("Bright green")
    indicator.Material = Enum.Material.Neon
    indicator.CanCollide = false
    indicator.Anchored = true
    indicator.Parent = workspace

    -- Actualizar la posición del indicador constantemente.
    game:GetService("RunService").Heartbeat:Connect(function()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            indicator.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        else
            indicator:Destroy()
            print("[Ojo de Halcón] Objetivo perdido o destruido.")
        end
    end)

    print("[Ojo de Halcón] Objetivo '" .. targetName .. "' rastreado con éxito.")
end

-- Ejecutar las funciones.
revealHiddenObjects()

-- Para rastrear a un jugador específico, descomenta la línea de abajo y cambia el nombre.
-- trackTarget("NombreDelJugador")

print("[Oracle-Nexus] Operación 'Ojo de Halcón' completada. La ventaja es tuya.")
