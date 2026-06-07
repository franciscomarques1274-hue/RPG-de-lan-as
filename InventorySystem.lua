--[[
    =====================================================
    SISTEMA DE INVENTÁRIO
    =====================================================
    Gerencia itens, armas e equipamentos do jogador
]]

local InventorySystem = {}
InventorySystem.PlayerInventories = {}

-- Tipos de itens disponíveis
local ItemDatabase = {
    -- Lanças
    Spears = {
        {id = 1, name = "⚪ Lança Comum", rarity = "Comum", damage = 15, price = 100},
        {id = 2, name = "🔥 Lança de Fogo", rarity = "Raro", damage = 25, price = 500},
        {id = 3, name = "❄️ Lança de Gelo", rarity = "Raro", damage = 20, price = 500},
        {id = 4, name = "⚡ Lança Relâmpago", rarity = "Épico", damage = 22, price = 1500},
        {id = 5, name = "🖤 Lança Escura", rarity = "Lendário", damage = 30, price = 5000},
        {id = 6, name = "✨ Lança da Divindade", rarity = "Divino", damage = 40, price = 15000},
    },
    
    -- Armaduras
    Armor = {
        {id = 1, name = "🟤 Couro Leve", rarity = "Comum", defense = 5, price = 100},
        {id = 2, name = "⚙️ Armadura de Ferro", rarity = "Raro", defense = 15, price = 500},
        {id = 3, name = "👑 Armadura de Ouro", rarity = "Épico", defense = 25, price = 2000},
        {id = 4, name = "💎 Armadura de Diamante", rarity = "Lendário", defense = 35, price = 8000},
    },
    
    -- Poções
    Potions = {
        {id = 1, name = "🔴 Poção de Vida Pequena", type = "HP", effect = 25, price = 50},
        {id = 2, name = "❤️ Poção de Vida Grande", type = "HP", effect = 100, price = 200},
        {id = 3, name = "🔵 Poção de Mana Pequena", type = "MANA", effect = 25, price = 50},
        {id = 4, name = "💙 Poção de Mana Grande", type = "MANA", effect = 100, price = 200},
        {id = 5, name = "⭐ Poção de Força", type = "BUFF", effect = 10, duration = 60, price = 300},
    },
    
    -- Recursos
    Resources = {
        {id = 1, name = "🪨 Pedra", type = "Crafting", price = 10},
        {id = 2, name = "🌳 Madeira", type = "Crafting", price = 15},
        {id = 3, name = "⚡ Cristal Mágico", type = "Crafting", price = 100},
        {id = 4, name = "💎 Diamante", type = "Crafting", price = 500},
    }
}

--[[
    Inicializa o sistema de inventário
]]
function InventorySystem:Initialize()
    print("\n╔════════════════════════════════════════╗")
    print("║  🎒 SISTEMA DE INVENTÁRIO INICIADO   ║")
    print("╚════════════════════════════════════════╝\n")
    
    local Players = game:GetService("Players")
    Players.PlayerAdded:Connect(function(player)
        self:CreateInventory(player)
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        self.PlayerInventories[player.UserId] = nil
    end)
end

--[[
    Cria inventário para um jogador
]]
function InventorySystem:CreateInventory(player)
    print("[InventorySystem] 🎒 Criando inventário para " .. player.Name)
    
    self.PlayerInventories[player.UserId] = {
        UserId = player.UserId,
        MaxSlots = 30,
        Items = {},
        Gold = 1000,
        EquippedSpear = 1,
        EquippedArmor = 1,
    }
    
    -- Adiciona items iniciais
    self:AddItem(player.UserId, "Spears", 1, 1)  -- 1x Lança Comum
    self:AddItem(player.UserId, "Armor", 1, 1)   -- 1x Couro Leve
    self:AddItem(player.UserId, "Potions", 1, 3) -- 3x Poção de Vida Pequena
    
    print("[InventorySystem] ✅ Inventário criado para " .. player.Name)
end

--[[
    Adiciona item ao inventário
]]
function InventorySystem:AddItem(userId, category, itemId, quantity)
    local inventory = self.PlayerInventories[userId]
    if not inventory then return false end
    
    local itemData = ItemDatabase[category][itemId]
    if not itemData then return false end
    
    -- Procura por item existente
    for _, item in pairs(inventory.Items) do
        if item.category == category and item.id == itemId then
            item.quantity = (item.quantity or 1) + (quantity or 1)
            return true
        end
    end
    
    -- Cria novo item
    if #inventory.Items < inventory.MaxSlots then
        table.insert(inventory.Items, {
            category = category,
            id = itemId,
            name = itemData.name,
            quantity = quantity or 1,
            rarity = itemData.rarity
        })
        return true
    end
    
    return false -- Inventário cheio
end

--[[
    Remove item do inventário
]]
function InventorySystem:RemoveItem(userId, category, itemId, quantity)
    local inventory = self.PlayerInventories[userId]
    if not inventory then return false end
    
    for i, item in pairs(inventory.Items) do
        if item.category == category and item.id == itemId then
            item.quantity = item.quantity - (quantity or 1)
            if item.quantity <= 0 then
                table.remove(inventory.Items, i)
            end
            return true
        end
    end
    
    return false
end

--[[
    Equipa uma arma
]]
function InventorySystem:EquipSpear(userId, spearId)
    local inventory = self.PlayerInventories[userId]
    if not inventory then return false end
    
    -- Verifica se tem no inventário
    for _, item in pairs(inventory.Items) do
        if item.category == "Spears" and item.id == spearId then
            inventory.EquippedSpear = spearId
            print("[InventorySystem] ⚔️ Lança equipada: " .. item.name)
            return true
        end
    end
    
    return false
end

--[[
    Equipa armadura
]]
function InventorySystem:EquipArmor(userId, armorId)
    local inventory = self.PlayerInventories[userId]
    if not inventory then return false end
    
    for _, item in pairs(inventory.Items) do
        if item.category == "Armor" and item.id == armorId then
            inventory.EquippedArmor = armorId
            print("[InventorySystem] 🛡️ Armadura equipada: " .. item.name)
            return true
        end
    end
    
    return false
end

--[[
    Usa uma poção
]]
function InventorySystem:UsePotion(userId, potionId)
    if not self:RemoveItem(userId, "Potions", potionId, 1) then
        return false
    end
    
    local potionData = ItemDatabase.Potions[potionId]
    print("[InventorySystem] ✨ Poção usada: " .. potionData.name .. " (Efeito: " .. potionData.effect .. ")")
    
    return potionData
end

--[[
    Adiciona ouro
]]
function InventorySystem:AddGold(userId, amount)
    local inventory = self.PlayerInventories[userId]
    if not inventory then return end
    
    inventory.Gold = inventory.Gold + amount
    return inventory.Gold
end

--[[
    Remove ouro
]]
function InventorySystem:RemoveGold(userId, amount)
    local inventory = self.PlayerInventories[userId]
    if not inventory or inventory.Gold < amount then return false end
    
    inventory.Gold = inventory.Gold - amount
    return true
end

--[[
    Retorna o inventário
]]
function InventorySystem:GetInventory(userId)
    return self.PlayerInventories[userId]
end

--[[
    DEBUG - Mostra inventário
]]
function InventorySystem:DebugInventory(userId)
    local inventory = self.PlayerInventories[userId]
    if not inventory then return end
    
    print("\n╔════════════════════════════════════════╗")
    print("║    🎒 INVENTÁRIO DO JOGADOR           ║")
    print("╚════════════════════════════════════════╝")
    print("Slots: " .. #inventory.Items .. " / " .. inventory.MaxSlots)
    print("Ouro: 💰 " .. inventory.Gold)
    print("\n📦 ITENS:")
    
    for _, item in pairs(inventory.Items) do
        print("├─ " .. item.name .. " x" .. item.quantity .. " (" .. item.rarity .. ")")
    end
    
    print("\n⚔️ EQUIPADO:")
    print("├─ Lança: " .. ItemDatabase.Spears[inventory.EquippedSpear].name)
    print("└─ Armadura: " .. ItemDatabase.Armor[inventory.EquippedArmor].name)
    print("════════════════════════════════════════\n")
end

-- Inicializa
InventorySystem:Initialize()

_G.InventorySystem = InventorySystem
