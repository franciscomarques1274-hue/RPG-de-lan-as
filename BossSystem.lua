--[[
    =====================================================
    SISTEMA DE CHEFES (BOSSES)
    =====================================================
    Cria chefes especiais a cada 4 áreas
]]

local BossSystem = {}
BossSystem.SpawnedBosses = {}

-- Tipos de chefes
local BossTypes = {
    {name = "👑 Rei Guerreiro", health = 200, damage = 25, spearColor = Color3.fromRGB(255, 215, 0)},
    {name = "🐉 Dragão de Lança", health = 300, damage = 35, spearColor = Color3.fromRGB(255, 0, 0)},
    {name = "⚡ Titã Relâmpago", health = 250, damage = 30, spearColor = Color3.fromRGB(255, 255, 0)},
    {name = "🌑 Lorde Sombrio", health = 280, damage = 32, spearColor = Color3.fromRGB(75, 0, 130)},
    {name = "✨ Deus das Lanças", health = 350, damage = 40, spearColor = Color3.fromRGB(255, 255, 255)}
}

--[[
    Inicializa bosses
]]
function BossSystem:Initialize()
    print("\n╔════════════════════════════════════════╗")
    print("║  👑 SPAWNING BOSSES                  ║")
    print("╚════════════════════════════════════════╝\n")
    
    local mapGen = _G.MapGenerator
    if mapGen then
        for _, area in pairs(mapGen.Areas) do
            if area.ID % 4 == 0 then -- Boss a cada 4 áreas
                self:SpawnBossInArea(area)
            end
        end
    end
    
    print("\n✅ BOSSES SPAWNEADOS!\n")
end

--[[
    Spawna um boss em uma área
]]
function BossSystem:SpawnBossInArea(area)
    print("👑 Boss spawning em " .. area.Theme .. "...")
    
    local bossFolder = Instance.new("Folder")
    bossFolder.Name = "Boss"
    bossFolder.Parent = area.Folder
    
    local bossType = BossTypes[math.random(1, #BossTypes)]
    self:CreateBoss(bossType, area.Position, bossFolder, area.Level)
end

--[[
    Cria um boss visual
]]
function BossSystem:CreateBoss(bossType, areaPos, parent, areaLevel)
    local boss = Instance.new("Model")
    boss.Name = bossType.name
    boss.Parent = parent
    
    -- Cabeça (maior)
    local head = Instance.new("Part")
    head.Name = "Head"
    head.Shape = Enum.PartType.Ball
    head.Size = Vector3.new(5, 5, 5)
    head.BrickColor = BrickColor.new("Bright red")
    head.CanCollide = true
    head.CFrame = CFrame.new(areaPos + Vector3.new(0, 10, 0))
    head.TopSurface = Enum.SurfaceType.Smooth
    head.Parent = boss
    
    -- Corpo (bem maior)
    local torso = Instance.new("Part")
    torso.Name = "Torso"
    torso.Shape = Enum.PartType.Block
    torso.Size = Vector3.new(6, 10, 4)
    torso.BrickColor = BrickColor.new("Maroon")
    torso.CanCollide = true
    torso.CFrame = CFrame.new(areaPos + Vector3.new(0, 0, 0))
    torso.TopSurface = Enum.SurfaceType.Smooth
    torso.Parent = boss
    
    -- Braços gigantes
    for offset = -1, 1, 2 do
        local arm = Instance.new("Part")
        arm.Name = "Arm"
        arm.Shape = Enum.PartType.Block
        arm.Size = Vector3.new(3, 8, 3)
        arm.BrickColor = BrickColor.new("Dark red")
        arm.CanCollide = true
        arm.CFrame = CFrame.new(areaPos + Vector3.new(4 * offset, 0, 0))
        arm.TopSurface = Enum.SurfaceType.Smooth
        arm.Parent = boss
    end
    
    -- Pernas gigantes
    for offset = -1, 1, 2 do
        local leg = Instance.new("Part")
        leg.Name = "Leg"
        leg.Shape = Enum.PartType.Block
        leg.Size = Vector3.new(3, 8, 3)
        leg.BrickColor = BrickColor.new("Black")
        leg.CanCollide = true
        leg.CFrame = CFrame.new(areaPos + Vector3.new(2 * offset, -8, 0))
        leg.TopSurface = Enum.SurfaceType.Smooth
        leg.Parent = boss
    end
    
    -- LANÇA GIGANTE!
    local spear = Instance.new("Part")
    spear.Name = "BossSpear"
    spear.Shape = Enum.PartType.Block
    spear.Size = Vector3.new(1, 15, 1)
    spear.BrickColor = BrickColor.new(bossType.spearColor)
    spear.CanCollide = true
    spear.CFrame = CFrame.new(areaPos + Vector3.new(5, 5, 0)) * CFrame.Angles(0, 0, math.rad(45))
    spear.TopSurface = Enum.SurfaceType.Smooth
    spear.Parent = boss
    
    -- Tags
    local bossTag = Instance.new("StringValue")
    bossTag.Name = "BossType"
    bossTag.Value = bossType.name
    bossTag.Parent = boss
    
    local healthTag = Instance.new("IntValue")
    healthTag.Name = "Health"
    healthTag.Value = bossType.health
    healthTag.Parent = boss
    
    local damageTag = Instance.new("IntValue")
    damageTag.Name = "Damage"
    damageTag.Value = bossType.damage
    damageTag.Parent = boss
    
    local levelTag = Instance.new("IntValue")
    levelTag.Name = "Level"
    levelTag.Value = areaLevel + 5
    levelTag.Parent = boss
    
    -- Billboard com nome e HP
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(10, 0, 3, 0)
    billboard.MaxDistance = 150
    billboard.Parent = head
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 0.2
    textLabel.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    textLabel.TextScaled = true
    textLabel.Text = bossType.name .. " [HP: " .. bossType.health .. "]"
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Parent = billboard
    
    table.insert(self.SpawnedBosses, boss)
end

-- Inicializa
wait(4) -- Aguarda os sistemas anteriores
BossSystem:Initialize()

_G.BossSystem = BossSystem
