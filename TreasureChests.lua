--[[
    =====================================================
    SISTEMA DE BAÚS DE TESOURO
    =====================================================
    Baús com rewards quando inimigos são derrotados
]]

local TreasureChests = {}
TreasureChests.ChestRewards = {}

--[[
    Inicializa baús em áreas
]]
function TreasureChests:Initialize()
    print("\n╔════════════════════════════════════════╗")
    print("║  💎 COLOCANDO BAÚS DE TESOURO        ║")
    print("╚════════════════════════════════════════╝\n")
    
    local mapGen = _G.MapGenerator
    if mapGen then
        for _, area in pairs(mapGen.Areas) do
            self:CreateChestInArea(area)
        end
    end
    
    print("\n✅ BAÚS CRIADOS!\n")
end

--[[
    Cria um baú em uma área
]]
function TreasureChests:CreateChestInArea(area)
    local chestFolder = Instance.new("Folder")
    chestFolder.Name = "TreasureChest"
    chestFolder.Parent = area.Folder
    
    local areaPos = area.Position
    local chestPos = areaPos + Vector3.new(0, 5, -60)
    
    -- Corpo do baú
    local chest = Instance.new("Part")
    chest.Name = "ChestBody"
    chest.Shape = Enum.PartType.Block
    chest.Size = Vector3.new(8, 6, 6)
    chest.BrickColor = BrickColor.new("Dark wood")
    chest.CanCollide = true
    chest.CFrame = CFrame.new(chestPos)
    chest.TopSurface = Enum.SurfaceType.Smooth
    chest.Parent = chestFolder
    
    -- Tampa do baú (ouro)
    local lid = Instance.new("Part")
    lid.Name = "ChestLid"
    lid.Shape = Enum.PartType.Block
    lid.Size = Vector3.new(8, 2, 6)
    lid.BrickColor = BrickColor.new("Bright yellow")
    lid.CanCollide = true
    lid.CFrame = CFrame.new(chestPos + Vector3.new(0, 4, 0))
    lid.TopSurface = Enum.SurfaceType.Smooth
    lid.Parent = chestFolder
    
    -- Fechadura (brilhante)
    local lock = Instance.new("Part")
    lock.Name = "Lock"
    lock.Shape = Enum.PartType.Ball
    lock.Size = Vector3.new(2, 2, 1)
    lock.BrickColor = BrickColor.new("Bright yellow")
    lock.CanCollide = false
    lock.CFrame = CFrame.new(chestPos + Vector3.new(0, 2, 3.5))
    lock.TopSurface = Enum.SurfaceType.Smooth
    lock.Parent = chestFolder
    
    -- Moedas dentro (decoração)
    for i = 1, 5 do
        local coin = Instance.new("Part")
        coin.Name = "Coin_" .. i
        coin.Shape = Enum.PartType.Cylinder
        coin.Size = Vector3.new(1, 0.5, 1)
        coin.BrickColor = BrickColor.new("Bright yellow")
        coin.CanCollide = false
        coin.CFrame = CFrame.new(chestPos + Vector3.new(math.random(-2, 2), 1, math.random(-1, 1)))
        coin.TopSurface = Enum.SurfaceType.Smooth
        coin.Parent = chestFolder
    end
    
    -- Tags de recompensa
    local rewardTag = Instance.new("StringValue")
    rewardTag.Name = "Reward"
    rewardTag.Value = "Gold:" .. (area.Level * 50) .. "|XP:" .. (area.Level * 100) .. "|Loot:0.3"
    rewardTag.Parent = chestFolder
    
    local levelTag = Instance.new("IntValue")
    levelTag.Name = "AreaLevel"
    levelTag.Value = area.Level
    levelTag.Parent = chestFolder
    
    -- Billboard com "Tesouro!"
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(6, 0, 2, 0)
    billboard.MaxDistance = 100
    billboard.Parent = chest
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 0.5
    textLabel.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    textLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.TextScaled = true
    textLabel.Text = "💎 TESOURO 💎"
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Parent = billboard
    
    table.insert(self.ChestRewards, chestFolder)
end

-- Inicializa
wait(5) -- Aguarda todos os sistemas
TreasureChests:Initialize()

_G.TreasureChests = TreasureChests
