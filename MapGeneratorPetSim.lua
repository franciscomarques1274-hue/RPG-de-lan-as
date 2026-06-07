--[[
    =====================================================
    GERADOR DE MAPA - PET SIMULATOR X STYLE
    =====================================================
    Mapa épico estilo Pet Simulator X com áreas temáticas
    Tudo anchored, sem destruir, muito bonitão!
]]

local MapGeneratorPetSim = {}
MapGeneratorPetSim.Worlds = {}
MapGeneratorPetSim.Areas = {}

-- Temas de áreas com cores e estilos
local AreaThemes = {
    -- MUNDO 1: Reino das Lanças Sagradas
    {name = "🌲 Floresta Sagrada", baseColor = Color3.fromRGB(34, 139, 34), platformColor = Color3.fromRGB(76, 175, 80), particles = true},
    {name = "💎 Caverna Cristalina", baseColor = Color3.fromRGB(100, 150, 200), platformColor = Color3.fromRGB(135, 206, 250), particles = true},
    {name = "🏜️ Deserto Dourado", baseColor = Color3.fromRGB(238, 214, 175), platformColor = Color3.fromRGB(255, 215, 0), particles = true},
    {name = "⛰️ Montanha Nevado", baseColor = Color3.fromRGB(192, 192, 192), platformColor = Color3.fromRGB(230, 230, 250), particles = true},
    {name = "🏰 Castelo Real", baseColor = Color3.fromRGB(128, 128, 128), platformColor = Color3.fromRGB(184, 134, 11), particles = false},
    {name = "🏛️ Templo Antigo", baseColor = Color3.fromRGB(184, 134, 11), platformColor = Color3.fromRGB(218, 165, 32), particles = true},
    {name = "🌿 Pântano Místico", baseColor = Color3.fromRGB(85, 107, 47), platformColor = Color3.fromRGB(107, 142, 35), particles = true},
    {name = "💀 Vale Sombrio", baseColor = Color3.fromRGB(47, 79, 79), platformColor = Color3.fromRGB(72, 109, 137), particles = true},
    {name = "🌋 Vulcão Ativo", baseColor = Color3.fromRGB(205, 92, 92), platformColor = Color3.fromRGB(255, 69, 0), particles = true},
    {name = "❄️ Tundra Gelada", baseColor = Color3.fromRGB(176, 224, 230), platformColor = Color3.fromRGB(200, 240, 255), particles = true},
    {name = "🗼 Torre Infinita", baseColor = Color3.fromRGB(139, 69, 19), platformColor = Color3.fromRGB(205, 133, 63), particles = false},
    {name = "🏚️ Ruínas Perdidas", baseColor = Color3.fromRGB(160, 82, 45), platformColor = Color3.fromRGB(188, 143, 143), particles = true},
    {name = "🕳️ Abismo Profundo", baseColor = Color3.fromRGB(25, 25, 112), platformColor = Color3.fromRGB(65, 105, 225), particles = true},
    {name = "✨ Floresta Mágica", baseColor = Color3.fromRGB(138, 43, 226), platformColor = Color3.fromRGB(186, 85, 211), particles = true},
    {name = "🌟 Cidade Celestial", baseColor = Color3.fromRGB(218, 165, 32), platformColor = Color3.fromRGB(255, 255, 0), particles = true},
    {name = "🌀 Dimensão Final", baseColor = Color3.fromRGB(75, 0, 130), platformColor = Color3.fromRGB(138, 43, 226), particles = true},
}

--[[
    Inicializa a geração do mapa Pet Sim Style
]]
function MapGeneratorPetSim:Initialize()
    print("\n╔════════════════════════════════════════════════════════╗")
    print("║  🗺️  GERANDO MAPA PET SIMULATOR X STYLE              ║")
    print("║       Com NPCs que dão Lanças!                        ║")
    print("╚════════════════════════════════════════════════════════╝")
    
    -- Cria os 2 mundos
    self:CreateWorld(1, "🏰 Reino das Lanças Sagradas")
    self:CreateWorld(2, "🌑 Dimensão Sombria das Lanças")
    
    print("\n✅ MAPA GERADO COM SUCESSO!\n")
end

--[[
    Cria um mundo com suas 16 áreas
]]
function MapGeneratorPetSim:CreateWorld(worldID, worldName)
    print("\n🌍 Criando " .. worldName .. "...")
    
    local world = Instance.new("Folder")
    world.Name = worldName
    world.Parent = workspace
    
    self.Worlds[worldID] = world
    
    -- Cria as 16 áreas
    for areaNum = 1, 16 do
        self:CreateArea(worldID, areaNum, world)
    end
    
    print("✓ " .. worldName .. " criado com 16 áreas!")
end

--[[
    Cria uma área visual estilo Pet Sim X
]]
function MapGeneratorPetSim:CreateArea(worldID, areaNum, parentWorld)
    local theme = AreaThemes[areaNum]
    local level = (worldID - 1) * 50 + areaNum * 3
    
    -- Pasta da área
    local areaFolder = Instance.new("Folder")
    areaFolder.Name = theme.name .. " (Nível " .. level .. ")"
    areaFolder.Parent = parentWorld
    
    -- Posicionamento em grid
    local gridX = ((areaNum - 1) % 4) * 300
    local gridZ = math.floor((areaNum - 1) / 4) * 300
    
    -- ===== PARTE 1: PLATAFORMA BASE =====
    local basePlatform = Instance.new("Part")
    basePlatform.Name = "BasePlatform"
    basePlatform.Shape = Enum.PartType.Block
    basePlatform.Size = Vector3.new(250, 15, 250)
    basePlatform.TopSurface = Enum.SurfaceType.Smooth
    basePlatform.BottomSurface = Enum.SurfaceType.Smooth
    basePlatform.Color = theme.baseColor
    basePlatform.Material = Enum.Material.SmoothPlastic
    basePlatform.CanCollide = true
    basePlatform.Anchored = true
    basePlatform.CFrame = CFrame.new(gridX, 0, gridZ)
    basePlatform.Parent = areaFolder
    
    -- ===== PARTE 2: PLATAFORMAS FLUTUANTES =====
    local platformCount = math.random(4, 6)
    for i = 1, platformCount do
        local platformX = gridX + math.random(-80, 80)
        local platformZ = gridZ + math.random(-80, 80)
        local platformY = 30 + (i * 25)
        
        local platform = Instance.new("Part")
        platform.Name = "FloatingPlatform_" .. i
        platform.Shape = Enum.PartType.Block
        platform.Size = Vector3.new(60, 8, 60)
        platform.TopSurface = Enum.SurfaceType.Smooth
        platform.BottomSurface = Enum.SurfaceType.Smooth
        platform.Color = theme.platformColor
        platform.Material = Enum.Material.SmoothPlastic
        platform.CanCollide = true
        platform.Anchored = true
        platform.CFrame = CFrame.new(platformX, platformY, platformZ)
        platform.Parent = areaFolder
        
        -- Adiciona brilho
        local glow = Instance.new("PointLight")
        glow.Color = theme.platformColor
        glow.Brightness = 2
        glow.Range = 30
        glow.Parent = platform
    end
    
    -- ===== PARTE 3: DECORAÇÕES TEMÁTICAS =====
    self:AddDecorationsToArea(areaFolder, gridX, gridZ, theme)
    
    -- ===== PARTE 4: IDENTIFICADOR DA ÁREA =====
    local areaSign = Instance.new("Part")
    areaSign.Name = "AreaSign"
    areaSign.Shape = Enum.PartType.Block
    areaSign.Size = Vector3.new(15, 8, 3)
    areaSign.Color = Color3.fromRGB(0, 0, 0)
    areaSign.Material = Enum.Material.SmoothPlastic
    areaSign.CanCollide = false
    areaSign.Anchored = true
    areaSign.CFrame = CFrame.new(gridX, 40, gridZ + 110)
    areaSign.Parent = areaFolder
    
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(6, 0, 2, 0)
    billboard.MaxDistance = 200
    billboard.Parent = areaSign
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 0.2
    textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.Text = theme.name .. "\n[Nível " .. level .. "]"
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Parent = billboard
    
    -- Tags
    local tag = Instance.new("StringValue")
    tag.Name = "AreaTag"
    tag.Value = worldID .. "-" .. areaNum
    tag.Parent = areaFolder
    
    local levelTag = Instance.new("IntValue")
    levelTag.Name = "AreaLevel"
    levelTag.Value = level
    levelTag.Parent = areaFolder
    
    table.insert(self.Areas, {
        ID = areaNum,
        WorldID = worldID,
        Folder = areaFolder,
        Position = Vector3.new(gridX, 0, gridZ),
        Theme = theme.name,
        Level = level
    })
    
    print("  ✓ " .. theme.name .. " | Nível " .. level)
end

--[[
    Adiciona decorações temáticas às áreas
]]
function MapGeneratorPetSim:AddDecorationsToArea(areaFolder, centerX, centerZ, theme)
    local decorFolder = Instance.new("Folder")
    decorFolder.Name = "Decorations"
    decorFolder.Parent = areaFolder
    
    -- Decorações por tema
    if theme.name:find("Floresta") then
        for i = 1, 3 do
            local tree = self:CreateTree(centerX + math.random(-70, 70), 20, centerZ + math.random(-70, 70))
            tree.Parent = decorFolder
        end
    elseif theme.name:find("Caverna") then
        for i = 1, 5 do
            local rock = self:CreateRock(centerX + math.random(-80, 80), 20, centerZ + math.random(-80, 80))
            rock.Parent = decorFolder
        end
    elseif theme.name:find("Vulcão") then
        local volcano = self:CreateVolcano(centerX, centerZ)
        volcano.Parent = decorFolder
    elseif theme.name:find("Castelo") then
        local castle = self:CreateCastle(centerX, centerZ)
        castle.Parent = decorFolder
    elseif theme.name:find("Tundra") then
        for i = 1, 4 do
            local snow = self:CreateSnow(centerX + math.random(-70, 70), 20, centerZ + math.random(-70, 70))
            snow.Parent = decorFolder
        end
    end
end

function MapGeneratorPetSim:CreateTree(x, y, z)
    local tree = Instance.new("Model")
    tree.Name = "Tree"
    
    local trunk = Instance.new("Part")
    trunk.Shape = Enum.PartType.Block
    trunk.Size = Vector3.new(6, 25, 6)
    trunk.Color = Color3.fromRGB(139, 69, 19)
    trunk.Material = Enum.Material.Wood
    trunk.CanCollide = true
    trunk.Anchored = true
    trunk.CFrame = CFrame.new(x, y + 12.5, z)
    trunk.Parent = tree
    
    local leaves = Instance.new("Part")
    leaves.Shape = Enum.PartType.Ball
    leaves.Size = Vector3.new(40, 40, 40)
    leaves.Color = Color3.fromRGB(34, 139, 34)
    leaves.Material = Enum.Material.SmoothPlastic
    leaves.CanCollide = false
    leaves.Anchored = true
    leaves.CFrame = CFrame.new(x, y + 40, z)
    leaves.Parent = tree
    
    return tree
end

function MapGeneratorPetSim:CreateRock(x, y, z)
    local rock = Instance.new("Part")
    rock.Name = "Rock"
    rock.Shape = Enum.PartType.Ball
    rock.Size = Vector3.new(math.random(10, 25), math.random(10, 25), math.random(10, 25))
    rock.Color = Color3.fromRGB(128, 128, 128)
    rock.Material = Enum.Material.Slate
    rock.CanCollide = true
    rock.Anchored = true
    rock.CFrame = CFrame.new(x, y, z)
    return rock
end

function MapGeneratorPetSim:CreateVolcano(x, z)
    local volcano = Instance.new("Model")
    volcano.Name = "Volcano"
    
    for i = 1, 5 do
        local cone = Instance.new("Part")
        cone.Shape = Enum.PartType.Block
        cone.Size = Vector3.new(80 - (i * 12), 15, 80 - (i * 12))
        cone.Color = Color3.fromRGB(205, 92, 92)
        cone.Material = Enum.Material.SmoothPlastic
        cone.CanCollide = true
        cone.Anchored = true
        cone.CFrame = CFrame.new(x, 10 + (i * 15), z)
        cone.Parent = volcano
    end
    
    local lava = Instance.new("Part")
    lava.Shape = Enum.PartType.Ball
    lava.Size = Vector3.new(25, 25, 25)
    lava.Color = Color3.fromRGB(255, 69, 0)
    lava.Material = Enum.Material.SmoothPlastic
    lava.CanCollide = false
    lava.Anchored = true
    lava.CFrame = CFrame.new(x, 85, z)
    
    local lavaglow = Instance.new("PointLight")
    lavaglow.Color = Color3.fromRGB(255, 69, 0)
    lavaglow.Brightness = 3
    lavaglow.Range = 50
    lavaglow.Parent = lava
    
    lava.Parent = volcano
    return volcano
end

function MapGeneratorPetSim:CreateCastle(x, z)
    local castle = Instance.new("Model")
    castle.Name = "Castle"
    
    -- Torre principal
    local tower = Instance.new("Part")
    tower.Shape = Enum.PartType.Block
    tower.Size = Vector3.new(40, 80, 40)
    tower.Color = Color3.fromRGB(128, 128, 128)
    tower.Material = Enum.Material.Concrete
    tower.CanCollide = true
    tower.Anchored = true
    tower.CFrame = CFrame.new(x, 40, z)
    tower.Parent = castle
    
    -- Topo com cor ouro
    local top = Instance.new("Part")
    top.Shape = Enum.PartType.Block
    top.Size = Vector3.new(45, 15, 45)
    top.Color = Color3.fromRGB(255, 215, 0)
    top.Material = Enum.Material.SmoothPlastic
    top.CanCollide = false
    top.Anchored = true
    top.CFrame = CFrame.new(x, 87.5, z)
    top.Parent = castle
    
    return castle
end

function MapGeneratorPetSim:CreateSnow(x, y, z)
    local snow = Instance.new("Part")
    snow.Name = "Snow"
    snow.Shape = Enum.PartType.Block
    snow.Size = Vector3.new(math.random(8, 15), math.random(8, 15), math.random(8, 15))
    snow.Color = Color3.fromRGB(240, 248, 255)
    snow.Material = Enum.Material.SmoothPlastic
    snow.CanCollide = true
    snow.Anchored = true
    snow.CFrame = CFrame.new(x, y, z)
    return snow
end

-- Inicializa
MapGeneratorPetSim:Initialize()

_G.MapGeneratorPetSim = MapGeneratorPetSim
