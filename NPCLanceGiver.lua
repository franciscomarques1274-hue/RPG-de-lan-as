--[[
    =====================================================
    SISTEMA DE NPCs QUE DÃO LANÇAS
    =====================================================
    A cada 2 áreas um NPC que dá uma lança nova!
]]

local NPCLanceGiver = {}
NPCLanceGiver.SpawnedNPCs = {}

-- Lanças disponíveis
local Spears = {
    {id = 1, name = "⚪ Lança Comum", color = Color3.fromRGB(192, 192, 192)},
    {id = 2, name = "🔥 Lança de Fogo", color = Color3.fromRGB(255, 69, 0)},
    {id = 3, name = "❄️ Lança de Gelo", color = Color3.fromRGB(135, 206, 250)},
    {id = 4, name = "⚡ Lança Relâmpago", color = Color3.fromRGB(255, 255, 0)},
    {id = 5, name = "🖤 Lança Escura", color = Color3.fromRGB(75, 0, 130)},
    {id = 6, name = "✨ Lança da Divindade", color = Color3.fromRGB(255, 255, 255)},
    {id = 7, name = "💎 Lança de Gelo Absoluto", color = Color3.fromRGB(100, 200, 255)},
    {id = 8, name = "🌋 Lança Infernal", color = Color3.fromRGB(255, 100, 0)},
}

--[[
    Inicializa NPCs
]]
function NPCLanceGiver:Initialize()
    print("\n╔════════════════════════════════════════════════════════╗")
    print("║  🧙 COLOCANDO NPCs QUE DÃO LANÇAS                    ║")
    print("╚════════════════════════════════════════════════════════╝")
    
    wait(2)
    
    local mapGen = _G.MapGeneratorPetSim
    if not mapGen then
        print("[NPCLanceGiver] ❌ MapGeneratorPetSim não encontrado!")
        return
    end
    
    local spearIndex = 1
    
    -- Coloca NPC a cada 2 áreas
    for _, area in pairs(mapGen.Areas) do
        if area.ID % 2 == 0 then -- A cada 2 áreas
            self:SpawnNPCInArea(area, Spears[spearIndex])
            spearIndex = spearIndex + 1
            if spearIndex > #Spears then
                spearIndex = 1
            end
        end
    end
    
    print("\n✅ NPCs COLOCADOS COM SUCESSO!\n")
end

--[[
    Spawna um NPC em uma área
]]
function NPCLanceGiver:SpawnNPCInArea(area, spearData)
    print("🧙 Colocando NPC em " .. area.Theme .. " com " .. spearData.name)
    
    local npcFolder = Instance.new("Folder")
    npcFolder.Name = "NPC_" .. spearData.name
    npcFolder.Parent = area.Folder
    
    local npcPos = area.Position + Vector3.new(0, 50, 0)
    
    -- Criar NPC visual (mago/sábio)
    local npc = self:CreateNPCCharacter(npcPos, spearData, npcFolder)
    
    -- Adicionar lança flutuante ao lado do NPC
    local floatingSpear = self:CreateFloatingSpear(npcPos + Vector3.new(30, 0, 0), spearData)
    floatingSpear.Parent = npcFolder
    
    -- Adicionar rotação animada
    local rotationPart = Instance.new("Part")
    rotationPart.Name = "RotationCenter"
    rotationPart.Shape = Enum.PartType.Ball
    rotationPart.Size = Vector3.new(0.1, 0.1, 0.1)
    rotationPart.CanCollide = false
    rotationPart.Anchored = true
    rotationPart.Transparency = 1
    rotationPart.CFrame = CFrame.new(npcPos + Vector3.new(30, 0, 0))
    rotationPart.Parent = npcFolder
    
    -- Script de rotação da lança
    local rotationScript = Instance.new("Script")
    rotationScript.Parent = rotationPart
    rotationScript.Source = [[
        local part = script.Parent
        local spear = part.Parent:FindFirstChild("FloatingSpear")
        if spear then
            while true do
                spear.CFrame = part.CFrame * CFrame.Angles(0, math.rad(2), 0) * CFrame.new(0, 0, 5)
                wait()
            end
        end
    ]]
    
    table.insert(self.SpawnedNPCs, npc)
end

--[[
    Cria o visual do NPC (mago)
]]
function NPCLanceGiver:CreateNPCCharacter(pos, spearData, parent)
    local npc = Instance.new("Model")
    npc.Name = "NPC_Mago"
    npc.Parent = parent
    
    -- Cabeça
    local head = Instance.new("Part")
    head.Name = "Head"
    head.Shape = Enum.PartType.Ball
    head.Size = Vector3.new(4, 4, 4)
    head.Color = Color3.fromRGB(255, 220, 177)
    head.Material = Enum.Material.SmoothPlastic
    head.CanCollide = false
    head.Anchored = true
    head.CFrame = CFrame.new(pos + Vector3.new(0, 8, 0))
    head.Parent = npc
    
    -- Corpo (roupa)
    local body = Instance.new("Part")
    body.Name = "Body"
    body.Shape = Enum.PartType.Block
    body.Size = Vector3.new(5, 10, 3)
    body.Color = Color3.fromRGB(75, 0, 130) -- Roxo mágico
    body.Material = Enum.Material.SmoothPlastic
    body.CanCollide = false
    body.Anchored = true
    body.CFrame = CFrame.new(pos)
    body.Parent = npc
    
    -- Varinha mágica (com cor da lança)
    local staff = Instance.new("Part")
    staff.Name = "Staff"
    staff.Shape = Enum.PartType.Block
    staff.Size = Vector3.new(1, 20, 1)
    staff.Color = spearData.color
    staff.Material = Enum.Material.Neon
    staff.CanCollide = false
    staff.Anchored = true
    staff.CFrame = CFrame.new(pos + Vector3.new(3, 5, 0)) * CFrame.Angles(0, 0, math.rad(30))
    staff.Parent = npc
    
    -- Glow na varinha
    local glow = Instance.new("PointLight")
    glow.Color = spearData.color
    glow.Brightness = 2
    glow.Range = 25
    glow.Parent = staff
    
    -- Nome do NPC acima
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(8, 0, 2, 0)
    billboard.MaxDistance = 200
    billboard.Parent = head
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 0.3
    textLabel.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.Text = "🧙 Mago das Lanças\n" .. spearData.name
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Parent = billboard
    
    return npc
end

--[[
    Cria uma lança flutuante
]]
function NPCLanceGiver:CreateFloatingSpear(pos, spearData)
    local spear = Instance.new("Part")
    spear.Name = "FloatingSpear"
    spear.Shape = Enum.PartType.Block
    spear.Size = Vector3.new(1, 10, 1)
    spear.Color = spearData.color
    spear.Material = Enum.Material.Neon
    spear.CanCollide = false
    spear.Anchored = true
    spear.TopSurface = Enum.SurfaceType.Smooth
    spear.CFrame = CFrame.new(pos)
    
    -- Glow
    local spearGlow = Instance.new("PointLight")
    spearGlow.Color = spearData.color
    spearGlow.Brightness = 3
    spearGlow.Range = 30
    spearGlow.Parent = spear
    
    -- Ponta da lança
    local tip = Instance.new("Part")
    tip.Name = "Tip"
    tip.Shape = Enum.PartType.Ball
    tip.Size = Vector3.new(2, 2, 2)
    tip.Color = spearData.color
    tip.Material = Enum.Material.Neon
    tip.CanCollide = false
    tip.Anchored = true
    tip.CFrame = CFrame.new(pos + Vector3.new(0, 6, 0))
    tip.Parent = spear
    
    return spear
end

-- Inicializa
wait(3)
NPCLanceGiver:Initialize()

_G.NPCLanceGiver = NPCLanceGiver
