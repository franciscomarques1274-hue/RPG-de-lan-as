--[[
    =====================================================
    SISTEMA DE SPAWN DE INIMIGOS
    =====================================================
    Gera bonecos com lanças em cada área
]]

local EnemySpawner = {}
EnemySpawner.SpawnedEnemies = {}

-- Tipos de inimigos
local EnemyTypes = {
    {name = "🗡️ Guerreiro", health = 30, damage = 8, spearColor = Color3.fromRGB(192, 192, 192)},
    {name = "🏹 Arqueiro", health = 25, damage = 10, spearColor = Color3.fromRGB(139, 69, 19)},
    {name = "🛡️ Paladino", health = 50, damage = 6, spearColor = Color3.fromRGB(255, 215, 0)},
    {name = "👹 Troll", health = 60, damage = 12, spearColor = Color3.fromRGB(128, 0, 0)},
    {name = "🧙 Mago", health = 20, damage = 15, spearColor = Color3.fromRGB(138, 43, 226)},
    {name = "💀 Esqueleto", health = 35, damage = 9, spearColor = Color3.fromRGB(200, 200, 200)}
}

--[[
    Inicializa o sistema de spawn
]]
function EnemySpawner:Initialize()
    print("\n╔════════════════════════════════════════╗")
    print("║  👹 INICIANDO SPAWN DE INIMIGOS      ║")
    print("╚════════════════════════════════════════╝\n")
    
    -- Spawn inimigos em todas as áreas
    local mapGen = _G.MapGenerator
    if mapGen then
        for _, area in pairs(mapGen.Areas) do
            self:SpawnEnemiesInArea(area)
        end
    end
    
    print("\n✅ INIMIGOS SPAWNEADOS COM SUCESSO!\n")
end

--[[
    Spawna inimigos em uma área específica
]]
function EnemySpawner:SpawnEnemiesInArea(area)
    print("Spawning inimigos em " .. area.Theme .. "...")
    
    local enemyCount = 3 + area.ID
    local areaPos = area.Position
    
    -- Pasta para guardar inimigos
    local enemiesFolder = Instance.new("Folder")
    enemiesFolder.Name = "Enemies"
    enemiesFolder.Parent = area.Folder
    
    for i = 1, enemyCount do
        local enemyType = EnemyTypes[math.random(1, #EnemyTypes)]
        self:CreateEnemy(enemyType, areaPos, i, enemiesFolder, area)
    end
end

--[[
    Cria um inimigo visual com lança
]]
function EnemySpawner:CreateEnemy(enemyType, areaPos, index, parent, areaInfo)
    -- Corpo do inimigo (boneco)
    local character = Instance.new("Model")
    character.Name = enemyType.name .. " #" .. index
    character.Parent = parent
    
    -- Posição aleatória dentro da área
    local randX = math.random(-50, 50)
    local randZ = math.random(-50, 50)
    local spawnPos = areaPos + Vector3.new(randX, 10, randZ)
    
    -- Cabeça do boneco
    local head = Instance.new("Part")
    head.Name = "Head"
    head.Shape = Enum.PartType.Ball
    head.Size = Vector3.new(3, 3, 3)
    head.BrickColor = BrickColor.new("Tan")
    head.CanCollide = true
    head.CFrame = CFrame.new(spawnPos + Vector3.new(0, 5, 0))
    head.TopSurface = Enum.SurfaceType.Smooth
    head.Parent = character
    
    -- Corpo
    local torso = Instance.new("Part")
    torso.Name = "Torso"
    torso.Shape = Enum.PartType.Block
    torso.Size = Vector3.new(3, 5, 2)
    torso.BrickColor = BrickColor.new("Reddish brown")
    torso.CanCollide = true
    torso.CFrame = CFrame.new(spawnPos + Vector3.new(0, 0, 0))
    torso.TopSurface = Enum.SurfaceType.Smooth
    torso.Parent = character
    
    -- Braço direito (com lança)
    local armRight = Instance.new("Part")
    armRight.Name = "ArmRight"
    armRight.Shape = Enum.PartType.Block
    armRight.Size = Vector3.new(1.5, 4, 1.5)
    armRight.BrickColor = BrickColor.new("Tan")
    armRight.CanCollide = true
    armRight.CFrame = CFrame.new(spawnPos + Vector3.new(2.5, 0, 0))
    armRight.TopSurface = Enum.SurfaceType.Smooth
    armRight.Parent = character
    
    -- Braço esquerdo
    local armLeft = Instance.new("Part")
    armLeft.Name = "ArmLeft"
    armLeft.Shape = Enum.PartType.Block
    armLeft.Size = Vector3.new(1.5, 4, 1.5)
    armLeft.BrickColor = BrickColor.new("Tan")
    armLeft.CanCollide = true
    armLeft.CFrame = CFrame.new(spawnPos + Vector3.new(-2.5, 0, 0))
    armLeft.TopSurface = Enum.SurfaceType.Smooth
    armLeft.Parent = character
    
    -- Perna direita
    local legRight = Instance.new("Part")
    legRight.Name = "LegRight"
    legRight.Shape = Enum.PartType.Block
    legRight.Size = Vector3.new(1.5, 4, 1.5)
    legRight.BrickColor = BrickColor.new("Dark stone grey")
    legRight.CanCollide = true
    legRight.CFrame = CFrame.new(spawnPos + Vector3.new(1, -5, 0))
    legRight.TopSurface = Enum.SurfaceType.Smooth
    legRight.Parent = character
    
    -- Perna esquerda
    local legLeft = Instance.new("Part")
    legLeft.Name = "LegLeft"
    legLeft.Shape = Enum.PartType.Block
    legLeft.Size = Vector3.new(1.5, 4, 1.5)
    legLeft.BrickColor = BrickColor.new("Dark stone grey")
    legLeft.CanCollide = true
    legLeft.CFrame = CFrame.new(spawnPos + Vector3.new(-1, -5, 0))
    legLeft.TopSurface = Enum.SurfaceType.Smooth
    legLeft.Parent = character
    
    -- LANÇA DO INIMIGO!
    local spear = Instance.new("Part")
    spear.Name = "Spear"
    spear.Shape = Enum.PartType.Block
    spear.Size = Vector3.new(0.5, 8, 0.5)
    spear.BrickColor = BrickColor.new(enemyType.spearColor)
    spear.CanCollide = true
    spear.CFrame = CFrame.new(spawnPos + Vector3.new(3.5, 1, 0)) * CFrame.Angles(0, 0, math.rad(45))
    spear.TopSurface = Enum.SurfaceType.Smooth
    spear.Parent = character
    
    -- Tags do inimigo
    local enemyTag = Instance.new("StringValue")
    enemyTag.Name = "EnemyType"
    enemyTag.Value = enemyType.name
    enemyTag.Parent = character
    
    local healthTag = Instance.new("IntValue")
    healthTag.Name = "Health"
    healthTag.Value = enemyType.health
    healthTag.Parent = character
    
    local damageTag = Instance.new("IntValue")
    damageTag.Name = "Damage"
    damageTag.Value = enemyType.damage
    damageTag.Parent = character
    
    local levelTag = Instance.new("IntValue")
    levelTag.Name = "Level"
    levelTag.Value = areaInfo.Level
    levelTag.Parent = character
    
    -- BillBoard com nome e HP
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(8, 0, 2, 0)
    billboard.MaxDistance = 100
    billboard.Parent = head
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 0.3
    textLabel.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.Text = enemyType.name .. " [HP: " .. enemyType.health .. "]"
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Parent = billboard
    
    table.insert(self.SpawnedEnemies, character)
end

--[[
    DEBUG
]]
function EnemySpawner:DebugEnemies()
    print("\n╔════════════════════════════════════════╗")
    print("║    👹 INIMIGOS SPAWNEADOS              ║")
    print("╚════════════════════════════════════════╝")
    print("Total de inimigos: " .. #self.SpawnedEnemies)
    print("═════════════════════════════════════════\n")
end

-- Inicializa
wait(2) -- Aguarda o MapGenerator
EnemySpawner:Initialize()
EnemySpawner:DebugEnemies()

_G.EnemySpawner = EnemySpawner
