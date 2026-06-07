--[[
    =====================================================
    GERADOR DE MAPA - RPG DE LANÇAS
    =====================================================
    Gera os 2 mundos com 16 áreas cada
    Cada área é uma zona separada com temas visuais
]]

local MapGenerator = {}
MapGenerator.Worlds = {}
MapGenerator.Areas = {}

-- Temas de cada área com cores
local AreaThemes = {
    {name = "🌲 Floresta", color = Color3.fromRGB(34, 139, 34), size = 150},
    {name = "⛰️ Caverna", color = Color3.fromRGB(105, 105, 105), size = 150},
    {name = "🏜️ Deserto", color = Color3.fromRGB(238, 214, 175), size = 150},
    {name = "⛏️ Montanha", color = Color3.fromRGB(169, 169, 169), size = 150},
    {name = "🏰 Castelo", color = Color3.fromRGB(128, 128, 128), size = 150},
    {name = "🏛️ Templo", color = Color3.fromRGB(184, 134, 11), size = 150},
    {name = "🌿 Pântano", color = Color3.fromRGB(85, 107, 47), size = 150},
    {name = "💀 Cemitério", color = Color3.fromRGB(47, 79, 79), size = 150},
    {name = "🌋 Vulcão", color = Color3.fromRGB(205, 92, 92), size = 150},
    {name = "❄️ Tundra", color = Color3.fromRGB(176, 224, 230), size = 150},
    {name = "🗼 Torre", color = Color3.fromRGB(139, 69, 19), size = 150},
    {name = "🏚️ Ruínas", color = Color3.fromRGB(160, 82, 45), size = 150},
    {name = "🕳️ Abismo", color = Color3.fromRGB(25, 25, 112), size = 150},
    {name = "✨ Floresta Mágica", color = Color3.fromRGB(138, 43, 226), size = 150},
    {name = "🏛️ Cidade Perdida", color = Color3.fromRGB(218, 165, 32), size = 150},
    {name = "🌀 Portão Dimensional", color = Color3.fromRGB(75, 0, 130), size = 150}
}

--[[
    Inicializa a geração do mapa
]]
function MapGenerator:Initialize()
    print("\n╔════════════════════════════════════════╗")
    print("║  🗺️  INICIANDO GERAÇÃO DE MAPA       ║")
    print("╚════════════════════════════════════════╝")
    
    -- Cria os 2 mundos
    self:CreateWorld(1, "🏰 Reino das Lanças Sagradas")
    self:CreateWorld(2, "🌑 Dimensão Sombria das Lanças")
    
    print("\n✅ MAPA GERADO COM SUCESSO!\n")
end

--[[
    Cria um mundo com suas 16 áreas
]]
function MapGenerator:CreateWorld(worldID, worldName)
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
    Cria uma área individual
]]
function MapGenerator:CreateArea(worldID, areaNum, parentWorld)
    local theme = AreaThemes[areaNum]
    local difficulty = worldID == 1 and "Fácil" or "Difícil"
    local level = (worldID - 1) * 50 + areaNum * 3
    
    -- Cria pasta da área
    local areaFolder = Instance.new("Folder")
    areaFolder.Name = theme.name .. " (Nível " .. level .. ")"
    areaFolder.Parent = parentWorld
    
    -- Posicionamento das áreas em grid
    local gridX = ((areaNum - 1) % 4) * 200
    local gridZ = math.floor((areaNum - 1) / 4) * 200
    
    -- Base da área (chão)
    local baseplate = Instance.new("Part")
    baseplate.Name = "Baseplate"
    baseplate.Shape = Enum.PartType.Block
    baseplate.Size = Vector3.new(theme.size, 5, theme.size)
    baseplate.TopSurface = Enum.SurfaceType.Smooth
    baseplate.BottomSurface = Enum.SurfaceType.Smooth
    baseplate.BrickColor = BrickColor.new(theme.color)
    baseplate.CanCollide = true
    baseplate.CFrame = CFrame.new(gridX, -5, gridZ)
    baseplate.Parent = areaFolder
    
    -- Cria identificador visual da área
    local areaSign = Instance.new("Part")
    areaSign.Name = "AreaSign"
    areaSign.Shape = Enum.PartType.Block
    areaSign.Size = Vector3.new(10, 5, 2)
    areaSign.BrickColor = BrickColor.new("Black")
    areaSign.CanCollide = false
    areaSign.CFrame = CFrame.new(gridX, 15, gridZ + 50)
    areaSign.Parent = areaFolder
    
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(4, 0, 2, 0)
    billboard.Parent = areaSign
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 0.5
    textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.Text = theme.name .. "\nNível " .. level
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Parent = billboard
    
    -- Adiciona tags para identificação
    local tag = Instance.new("StringValue")
    tag.Name = "AreaTag"
    tag.Value = worldID .. "-" .. areaNum
    tag.Parent = areaFolder
    
    table.insert(self.Areas, {
        ID = areaNum,
        WorldID = worldID,
        Folder = areaFolder,
        Position = Vector3.new(gridX, 0, gridZ),
        Theme = theme.name,
        Level = level,
        Difficulty = difficulty
    })
    
    print("  ✓ Área " .. areaNum .. ": " .. theme.name .. " (Nível " .. level .. ")")
end

--[[
    Retorna informações de uma área
]]
function MapGenerator:GetAreaInfo(worldID, areaID)
    for _, area in pairs(self.Areas) do
        if area.WorldID == worldID and area.ID == areaID then
            return area
        end
    end
    return nil
end

--[[
    DEBUG - Lista todas as áreas
]]
function MapGenerator:DebugAreas()
    print("\n╔════════════════════════════════════════╗")
    print("║    📍 ÁREAS GERADAS                   ║")
    print("╚════════════════════════════════════════╝")
    
    for worldID, world in pairs(self.Worlds) do
        print("\n" .. world.Name)
        local areas = world:GetChildren()
        for _, area in pairs(areas) do
            print("  ✓ " .. area.Name)
        end
    end
    print("\n═════════════════════════════════════════\n")
end

-- Inicializa
MapGenerator:Initialize()
MapGenerator:DebugAreas()

_G.MapGenerator = MapGenerator
