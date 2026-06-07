--[[
    =====================================================
    SISTEMA DE VISUAIS DAS ÁREAS
    =====================================================
    Efeitos visuais épicos em cada área!
]]

local AreaVisuals = {}

--[[
    Inicializa visuais
]]
function AreaVisuals:Initialize()
    print("\n╔════════════════════════════════════════════════════════╗")
    print("║  ✨ ADICIONANDO EFEITOS VISUAIS ÉPICOS               ║")
    print("╚════════════════════════════════════════════════════════╝")
    
    wait(2)
    
    local mapGen = _G.MapGeneratorPetSim
    if not mapGen then return end
    
    for _, area in pairs(mapGen.Areas) do
        self:AddAreaEffects(area)
    end
    
    print("\n✅ EFEITOS ADICIONADOS!\n")
end

--[[
    Adiciona efeitos visuais a uma área
]]
function AreaVisuals:AddAreaEffects(area)
    local visualFolder = Instance.new("Folder")
    visualFolder.Name = "AreaEffects"
    visualFolder.Parent = area.Folder
    
    -- Adiciona partículas de ambiente
    self:CreateParticles(area, visualFolder)
    
    -- Adiciona cristais flutuantes
    self:CreateFloatingCrystals(area, visualFolder)
    
    -- Adiciona aura de proteção
    self:CreateAreaAura(area, visualFolder)
end

--[[
    Cria partículas ambientes
]]
function AreaVisuals:CreateParticles(area, parent)
    local particleEmitter = Instance.new("Part")
    particleEmitter.Name = "ParticleEmitter"
    particleEmitter.Shape = Enum.PartType.Ball
    particleEmitter.Size = Vector3.new(1, 1, 1)
    particleEmitter.CanCollide = false
    particleEmitter.Anchored = true
    particleEmitter.Transparency = 1
    particleEmitter.CFrame = CFrame.new(area.Position + Vector3.new(0, 50, 0))
    particleEmitter.Parent = parent
    
    local particles = Instance.new("ParticleEmitter")
    particles.Parent = particleEmitter
    particles.Rate = 20
    particles.Lifetime = NumberRange.new(2, 3)
    particles.Speed = NumberRange.new(5, 10)
    particles.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(1, 1)}
    particles.Rotation = NumberRange.new(0, 360)
    particles.RotSpeed = NumberRange.new(-360, 360)
    particles.Color = ColorSequence.new(Color3.fromRGB(100, 200, 255))
end

--[[
    Cria cristais flutuantes
]]
function AreaVisuals:CreateFloatingCrystals(area, parent)
    local crystalCount = math.random(3, 5)
    
    for i = 1, crystalCount do
        local crystal = Instance.new("Part")
        crystal.Name = "Crystal_" .. i
        crystal.Shape = Enum.PartType.Ball
        crystal.Size = Vector3.new(3, 3, 3)
        crystal.Color = Color3.fromRGB(100, 200, 255)
        crystal.Material = Enum.Material.Neon
        crystal.CanCollide = false
        crystal.Anchored = true
        
        local offsetX = math.random(-50, 50)
        local offsetY = math.random(20, 60)
        local offsetZ = math.random(-50, 50)
        
        crystal.CFrame = CFrame.new(area.Position + Vector3.new(offsetX, offsetY, offsetZ))
        crystal.Parent = parent
        
        -- Glow do cristal
        local glow = Instance.new("PointLight")
        glow.Color = Color3.fromRGB(100, 200, 255)
        glow.Brightness = 1.5
        glow.Range = 20
        glow.Parent = crystal
        
        -- Script de flutuação
        local floatScript = Instance.new("Script")
        floatScript.Parent = crystal
        floatScript.Source = [[
            local part = script.Parent
            local startPos = part.Position
            local time = 0
            local speed = 0.01
            local height = 2
            
            while true do
                time = time + speed
                part.CFrame = CFrame.new(startPos + Vector3.new(0, math.sin(time) * height, 0)) * CFrame.Angles(time, time * 0.5, time * 0.3)
                wait()
            end
        ]]
    end
end

--[[
    Cria aura de proteção da área
]]
function AreaVisuals:CreateAreaAura(area, parent)
    local aura = Instance.new("Part")
    aura.Name = "AreaAura"
    aura.Shape = Enum.PartType.Block
    aura.Size = Vector3.new(250, 0.5, 250)
    aura.Color = Color3.fromRGB(200, 200, 255)
    aura.Material = Enum.Material.Neon
    aura.CanCollide = false
    aura.Anchored = true
    aura.Transparency = 0.7
    aura.CFrame = CFrame.new(area.Position + Vector3.new(0, 2, 0))
    aura.Parent = parent
    
    -- Script de pulso
    local pulseScript = Instance.new("Script")
    pulseScript.Parent = aura
    pulseScript.Source = [[
        local part = script.Parent
        local time = 0
        
        while true do
            time = time + 0.05
            part.Transparency = 0.7 + math.sin(time) * 0.2
            wait()
        end
    ]]
end

-- Inicializa
wait(4)
AreaVisuals:Initialize()

_G.AreaVisuals = AreaVisuals
