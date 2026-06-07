--[[
    =====================================================
    SISTEMA DE SALVAMENTO DE DADOS
    =====================================================
    Salva e carrega dados dos jogadores usando DataStore
]]

local DataSaveSystem = {}

--[[
    Inicializa o sistema de salvamento
]]
function DataSaveSystem:Initialize()
    print("\n╔════════════════════════════════════════╗")
    print("║  💾 SISTEMA DE SALVAMENTO INICIADO   ║")
    print("╚════════════════════════════════════════╝\n")
    
    local success, err = pcall(function()
        local DataStoreService = game:GetService("DataStoreService")
        self.PlayerDataStore = DataStoreService:GetDataStore("PlayerData")
        self.ProgressionStore = DataStoreService:GetDataStore("Progression")
        self.InventoryStore = DataStoreService:GetDataStore("Inventory")
    end)
    
    if not success then
        print("[DataSaveSystem] ⚠️ Aviso: DataStore pode não estar disponível em teste local")
        print("[DataSaveSystem] Dados não serão persistidos neste modo")
        return
    end
    
    local Players = game:GetService("Players")
    
    -- Carrega dados quando jogador entra
    Players.PlayerAdded:Connect(function(player)
        self:LoadPlayerData(player)
    end)
    
    -- Salva dados quando jogador sai
    Players.PlayerRemoving:Connect(function(player)
        self:SavePlayerData(player)
    end)
    
    -- Auto-salva a cada 5 minutos
    task.spawn(function()
        while true do
            wait(300)
            for _, player in pairs(Players:GetPlayers()) do
                self:SavePlayerData(player)
            end
            print("[DataSaveSystem] 💾 Auto-save realizado " .. os.date("%H:%M:%S"))
        end
    end)
end

--[[
    Salva dados de um jogador
]]
function DataSaveSystem:SavePlayerData(player)
    print("[DataSaveSystem] 💾 Salvando dados de " .. player.Name .. "...")
    
    local progressionSys = _G.ProgressionSystem
    local inventorySys = _G.InventorySystem
    
    if not progressionSys or not inventorySys then
        print("[DataSaveSystem] ⚠️ Sistemas não carregados!")
        return
    end
    
    local progressionStats = progressionSys:GetPlayerStats(player.UserId)
    local inventory = inventorySys:GetInventory(player.UserId)
    
    if not progressionStats or not inventory then return end
    
    if not self.ProgressionStore then
        print("[DataSaveSystem] ⚠️ DataStore não disponível (modo teste local)")
        return
    end
    
    local success, err
    
    -- Salva dados de progressão
    success, err = pcall(function()
        self.ProgressionStore:SetAsync("Player_" .. player.UserId, {
            Level = progressionStats.Level,
            Experience = progressionStats.Experience,
            StatPoints = progressionStats.StatPoints,
            SkillPoints = progressionStats.SkillPoints,
            Strength = progressionStats.Strength,
            Agility = progressionStats.Agility,
            Endurance = progressionStats.Endurance,
            Intelligence = progressionStats.Intelligence,
            Defense = progressionStats.Defense,
            MaxHealth = progressionStats.MaxHealth,
            MaxMana = progressionStats.MaxMana,
            KillCount = progressionStats.KillCount,
            BossesDefeated = progressionStats.BossesDefeated,
            AreasExplored = progressionStats.AreasExplored,
            PlayTime = progressionStats.PlayTime,
            LastSave = os.time()
        })
    end)
    
    if not success then
        print("[DataSaveSystem] ❌ Erro ao salvar progressão: " .. tostring(err))
        return
    end
    
    -- Salva inventário
    success, err = pcall(function()
        self.InventoryStore:SetAsync("Player_" .. player.UserId, {
            Gold = inventory.Gold,
            EquippedSpear = inventory.EquippedSpear,
            EquippedArmor = inventory.EquippedArmor,
            Items = inventory.Items
        })
    end)
    
    if not success then
        print("[DataSaveSystem] ❌ Erro ao salvar inventário: " .. tostring(err))
        return
    end
    
    print("[DataSaveSystem] ✅ Dados salvos com sucesso para " .. player.Name)
end

--[[
    Carrega dados de um jogador
]]
function DataSaveSystem:LoadPlayerData(player)
    print("[DataSaveSystem] 📂 Carregando dados de " .. player.Name .. "...")
    
    local progressionSys = _G.ProgressionSystem
    local inventorySys = _G.InventorySystem
    
    if not progressionSys or not inventorySys then
        print("[DataSaveSystem] ⚠️ Aguardando sistemas...")
        wait(2)
        if not _G.ProgressionSystem or not _G.InventorySystem then
            print("[DataSaveSystem] ❌ Sistemas não carregados!")
            return
        end
        progressionSys = _G.ProgressionSystem
        inventorySys = _G.InventorySystem
    end
    
    -- Cria stats padrão
    progressionSys:CreatePlayerStats(player)
    inventorySys:CreateInventory(player)
    
    local progressionStats = progressionSys:GetPlayerStats(player.UserId)
    local inventory = inventorySys:GetInventory(player.UserId)
    
    if not self.ProgressionStore then
        print("[DataSaveSystem] ⚠️ DataStore não disponível (modo teste local)")
        print("[DataSaveSystem] ℹ️ Novo jogador! Dados padrão criados.")
        return
    end
    
    -- Tenta carregar progressão salva
    local success, progressionData = pcall(function()
        return self.ProgressionStore:GetAsync("Player_" .. player.UserId)
    end)
    
    if success and progressionData then
        progressionStats.Level = progressionData.Level
        progressionStats.Experience = progressionData.Experience
        progressionStats.StatPoints = progressionData.StatPoints
        progressionStats.SkillPoints = progressionData.SkillPoints
        progressionStats.Strength = progressionData.Strength
        progressionStats.Agility = progressionData.Agility
        progressionStats.Endurance = progressionData.Endurance
        progressionStats.Intelligence = progressionData.Intelligence
        progressionStats.Defense = progressionData.Defense
        progressionStats.MaxHealth = progressionData.MaxHealth
        progressionStats.MaxMana = progressionData.MaxMana
        progressionStats.KillCount = progressionData.KillCount
        progressionStats.BossesDefeated = progressionData.BossesDefeated
        progressionStats.AreasExplored = progressionData.AreasExplored
        
        print("[DataSaveSystem] ✅ Progressão carregada! Level: " .. progressionStats.Level)
    else
        print("[DataSaveSystem] ℹ️ Novo jogador! Dados padrão criados.")
    end
    
    -- Tenta carregar inventário salvo
    local success2, inventoryData = pcall(function()
        return self.InventoryStore:GetAsync("Player_" .. player.UserId)
    end)
    
    if success2 and inventoryData then
        inventory.Gold = inventoryData.Gold
        inventory.EquippedSpear = inventoryData.EquippedSpear
        inventory.EquippedArmor = inventoryData.EquippedArmor
        inventory.Items = inventoryData.Items
        
        print("[DataSaveSystem] ✅ Inventário carregado! Ouro: " .. inventory.Gold)
    end
end

--[[
    DEBUG - Mostra info de salvamento
]]
function DataSaveSystem:DebugSaveInfo()
    print("\n╔════════════════════════════════════════╗")
    print("║    💾 SISTEMA DE SALVAMENTO           ║")
    print("╚════════════════════════════════════════╝")
    print("DataStore: PlayerData")
    print("ProgressionStore: Progression")
    print("InventoryStore: Inventory")
    print("Auto-save: A cada 5 minutos")
    print("════════════════════════════════════════\n")
end

-- Inicializa
DataSaveSystem:Initialize()
DataSaveSystem:DebugSaveInfo()

_G.DataSaveSystem = DataSaveSystem
