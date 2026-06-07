--[[
    =====================================================
    GERADOR DE DECORAÇÕES
    =====================================================
    Adiciona árvores, rochas, estruturas em cada área
]]

local DecorationsGenerator = {}

--[[
    Inicializa as decorações
]]
function DecorationsGenerator:Initialize()
    print("\n╔════════════════════════════════════════╗")
    print("║  🌳 INICIANDO DECORAÇÕES             ║")
    print("╚════════════════════════════════════════╝\n")
    
    local mapGen = _G.MapGenerator
    if mapGen then
        for _, area in pairs(mapGen.Areas) do
            self:AddDecorationsToArea(area)
        end
    end
    
    print("\n✅ DECORAÇÕES ADICIONADAS!\n")
end

--[[
    Adiciona decorações em uma área
]]
function DecorationsGenerator:AddDecorationsToArea(area)
    local decorFolder = Instance.new("Folder")
    decorFolder.Name = "Decorations"
    decorFolder.Parent = area.Folder
    
    local areaPos = area.Position
    
    -- Adiciona árvores aleatórias
    if area.Theme:find("Floresta") or area.Theme:find("Pântano") or area.Theme:find("Mágica") then
        for i = 1, math.random(3, 6) do
            self:CreateTree(areaPos, i, decorFolder)
        end
    end
    
    -- Adiciona rochas
    if area.Theme:find("Montanha") or area.Theme:find("Caverna") or area.Theme:find("Deserto") then
        for i = 1, math.random(4, 8) do
            self:CreateRock(areaPos, i, decorFolder)
        end
    end
    
    -- Adiciona estruturas
    if area.Theme:find("Castelo") or area.Theme:find("Torre") then
        self:CreateTower(areaPos, decorFolder)
    end
    
    -- Adiciona vulcão
    if area.Theme:find("Vulcão") then
        self:CreateVolcano(areaPos, decorFolder)
    end
    
    -- Adiciona neve
    if area.Theme:find("Tundra") then
        for i = 1, math.random(3, 5) do
            self:CreateSnowPile(areaPos, i, decorFolder)
        end
    end
end

--[[
    Cria uma árvore
]]
function DecorationsGenerator:CreateTree(areaPos, index, parent)
    local randX = math.random(-60, 60)
    local randZ = math.random(-60, 60)
    local treePos = areaPos + Vector3.new(randX, 0, randZ)
    
    -- Tronco
    local trunk = Instance.new("Part")
    trunk.Name = "Tree_Trunk"
    trunk.Shape = Enum.PartType.Block
    trunk.Size = Vector3.new(2, 10, 2)
    trunk.BrickColor = BrickColor.new("Dark wood")
    trunk.CanCollide = true
    trunk.CFrame = CFrame.new(treePos + Vector3.new(0, 5, 0))
    trunk.TopSurface = Enum.SurfaceType.Smooth
    trunk.Parent = parent
    
    -- Folhagem
    local leaves = Instance.new("Part")
    leaves.Name = "Tree_Leaves"
    leaves.Shape = Enum.PartType.Ball
    leaves.Size = Vector3.new(12, 12, 12)
    leaves.BrickColor = BrickColor.new("Dark green")
    leaves.CanCollide = true
    leaves.CFrame = CFrame.new(treePos + Vector3.new(0, 12, 0))
    leaves.TopSurface = Enum.SurfaceType.Smooth
    leaves.Parent = parent
end

--[[
    Cria uma rocha
]]
function DecorationsGenerator:CreateRock(areaPos, index, parent)
    local randX = math.random(-60, 60)
    local randZ = math.random(-60, 60)
    local rockPos = areaPos + Vector3.new(randX, 0, randZ)
    
    local rock = Instance.new("Part")
    rock.Name = "Rock_" .. index
    rock.Shape = Enum.PartType.Ball
    rock.Size = Vector3.new(math.random(4, 8), math.random(4, 8), math.random(4, 8))
    rock.BrickColor = BrickColor.new("Medium stone grey")
    rock.CanCollide = true
    rock.CFrame = CFrame.new(rockPos + Vector3.new(0, 2, 0))
    rock.TopSurface = Enum.SurfaceType.Smooth
    rock.Parent = parent
end

--[[
    Cria uma torre
]]
function DecorationsGenerator:CreateTower(areaPos, parent)
    local towerPos = areaPos + Vector3.new(0, 0, 0)
    
    -- Base
    local base = Instance.new("Part")
    base.Name = "Tower_Base"
    base.Shape = Enum.PartType.Block
    base.Size = Vector3.new(15, 3, 15)
    base.BrickColor = BrickColor.new("Dark stone grey")
    base.CanCollide = true
    base.CFrame = CFrame.new(towerPos + Vector3.new(0, 1.5, 0))
    base.Parent = parent
    
    -- Corpo
    for i = 1, 4 do
        local bodyPart = Instance.new("Part")
        bodyPart.Name = "Tower_Body_" .. i
        bodyPart.Shape = Enum.PartType.Block
        bodyPart.Size = Vector3.new(12, 5, 12)
        bodyPart.BrickColor = BrickColor.new("Medium stone grey")
        bodyPart.CanCollide = true
        bodyPart.CFrame = CFrame.new(towerPos + Vector3.new(0, 5 + (i * 5), 0))
        bodyPart.Parent = parent
    end
    
    -- Topo (pico)
    local top = Instance.new("Part")
    top.Name = "Tower_Top"
    top.Shape = Enum.PartType.Block
    top.Size = Vector3.new(8, 8, 8)
    top.BrickColor = BrickColor.new("Gold")
    top.CanCollide = true
    top.CFrame = CFrame.new(towerPos + Vector3.new(0, 30, 0))
    top.Parent = parent
end

--[[
    Cria um vulcão
]]
function DecorationsGenerator:CreateVolcano(areaPos, parent)
    local volcanoPos = areaPos + Vector3.new(0, 0, 0)
    
    -- Cone do vulcão
    for i = 1, 5 do
        local cone = Instance.new("Part")
        cone.Name = "Volcano_Cone_" .. i
        cone.Shape = Enum.PartType.Block
        cone.Size = Vector3.new(30 - (i * 4), 4, 30 - (i * 4))
        cone.BrickColor = BrickColor.new("Brick red")
        cone.CanCollide = true
        cone.CFrame = CFrame.new(volcanoPos + Vector3.new(0, 2 + (i * 4), 0))
        cone.Parent = parent
    end
    
    -- Lava no topo
    local lava = Instance.new("Part")
    lava.Name = "Volcano_Lava"
    lava.Shape = Enum.PartType.Ball
    lava.Size = Vector3.new(8, 8, 8)
    lava.BrickColor = BrickColor.new("Bright red")
    lava.CanCollide = true
    lava.CFrame = CFrame.new(volcanoPos + Vector3.new(0, 25, 0))
    lava.Parent = parent
end

--[[
    Cria uma pilha de neve
]]
function DecorationsGenerator:CreateSnowPile(areaPos, index, parent)
    local randX = math.random(-60, 60)
    local randZ = math.random(-60, 60)
    local snowPos = areaPos + Vector3.new(randX, 0, randZ)
    
    local snow = Instance.new("Part")
    snow.Name = "Snow_Pile_" .. index
    snow.Shape = Enum.PartType.Block
    snow.Size = Vector3.new(math.random(5, 10), math.random(5, 10), math.random(5, 10))
    snow.BrickColor = BrickColor.new("Institutional white")
    snow.CanCollide = true
    snow.CFrame = CFrame.new(snowPos + Vector3.new(0, 2, 0))
    snow.TopSurface = Enum.SurfaceType.Smooth
    snow.Parent = parent
end

-- Inicializa
wait(3) -- Aguarda MapGenerator
DecorationsGenerator:Initialize()

_G.DecorationsGenerator = DecorationsGenerator
