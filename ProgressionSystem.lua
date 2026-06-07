--[[
    =====================================================
    SISTEMA DE PROGRESSÃO E LEVEL
    =====================================================
    Gerencia leveling, experiência e skills do jogador
]]

local ProgressionSystem = {}
ProgressionSystem.PlayerStats = {}

-- Tabela de experiência por level
local ExperienceTable = {}
for level = 1, 100 do
    ExperienceTable[level] = level * 100 + (level ^ 2) * 10
end

--[[
    Inicializa o sistema de progressão
]]
function ProgressionSystem:Initialize()
    print("\n╔════════════════════════════════════════╗")
    print("║  ⭐ SISTEMA DE PROGRESSÃO INICIADO   ║")
    print("╚════════════════════════════════════════╝\n")
    
    -- Conecta a jogadores
    local Players = game:GetService("Players")
    Players.PlayerAdded:Connect(function(player)
        self:CreatePlayerStats(player)
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        self.PlayerStats[player.UserId] = nil
    end)
end

--[[
    Cria stats de progressão para um jogador
]]
function ProgressionSystem:CreatePlayerStats(player)
    print("[ProgressionSystem] ⭐ Criando stats para " .. player.Name)
    
    self.PlayerStats[player.UserId] = {
        UserId = player.UserId,
        Level = 1,
        Experience = 0,
        ExperienceToNextLevel = ExperienceTable[1],
        StatPoints = 0,
        SkillPoints = 0,
        
        -- Atributos
        Strength = 10,      -- Força (dano)
        Agility = 10,       -- Agilidade (ataque rápido)
        Endurance = 10,     -- Resistência (HP)
        Intelligence = 10,  -- Inteligência (Mana/skills)
        Defense = 10,       -- Defesa (reduz dano)
        
        -- Stats derivados
        MaxHealth = 100,
        MaxMana = 50,
        CurrentHealth = 100,
        CurrentMana = 50,
        
        -- Habilidades desbloqueadas
        UnlockedSkills = {1},
        
        -- Conquistas
        KillCount = 0,
        BossesDefeated = 0,
        AreasExplored = 0,
        
        -- Tempo
        PlayTime = 0,
        CreatedAt = os.time()
    }
    
    print("[ProgressionSystem] ✅ Stats criados para " .. player.Name)
end

--[[
    Adiciona experiência ao jogador
]]
function ProgressionSystem:AddExperience(userId, amount)
    local stats = self.PlayerStats[userId]
    if not stats then return end
    
    stats.Experience = stats.Experience + amount
    
    -- Verifica se levou up
    while stats.Experience >= stats.ExperienceToNextLevel and stats.Level < 100 do
        self:LevelUp(userId)
    end
    
    return stats.Experience
end

--[[
    Aumenta de level
]]
function ProgressionSystem:LevelUp(userId)
    local stats = self.PlayerStats[userId]
    if not stats or stats.Level >= 100 then return end
    
    stats.Level = stats.Level + 1
    stats.Experience = 0
    stats.ExperienceToNextLevel = ExperienceTable[stats.Level] or 999999
    stats.StatPoints = stats.StatPoints + 5
    stats.SkillPoints = stats.SkillPoints + 1
    
    -- Aumenta stats base
    stats.MaxHealth = stats.MaxHealth + 10
    stats.MaxMana = stats.MaxMana + 5
    stats.CurrentHealth = stats.MaxHealth
    stats.CurrentMana = stats.MaxMana
    
    print("\n🎉 LEVEL UP! 🎉")
    print("Jogador Level: " .. stats.Level)
    print("Stats Points: +5 | Skill Points: +1")
    print("Max Health: " .. stats.MaxHealth .. " | Max Mana: " .. stats.MaxMana .. "\n")
    
    -- Desbloqueia skills
    if stats.Level % 10 == 0 and stats.Level <= 50 then
        local skillToUnlock = math.floor(stats.Level / 10) + 1
        if skillToUnlock <= 5 then
            table.insert(stats.UnlockedSkills, skillToUnlock)
            print("🔓 Nova habilidade desbloqueada: Habilidade " .. skillToUnlock .. "!\n")
        end
    end
    
    return stats.Level
end

--[[
    Distribui pontos de atributo
]]
function ProgressionSystem:AddStatPoint(userId, attribute, points)
    local stats = self.PlayerStats[userId]
    if not stats or stats.StatPoints < points then return false end
    
    if stats[attribute] then
        stats[attribute] = stats[attribute] + points
        stats.StatPoints = stats.StatPoints - points
        
        -- Recalcula stats derivados
        if attribute == "Endurance" then
            stats.MaxHealth = 100 + (stats.Endurance * 5)
            stats.CurrentHealth = stats.MaxHealth
        elseif attribute == "Intelligence" then
            stats.MaxMana = 50 + (stats.Intelligence * 2)
            stats.CurrentMana = stats.MaxMana
        end
        
        print("[ProgressionSystem] +" .. points .. " em " .. attribute)
        return true
    end
    
    return false
end

--[[
    Aplica dano ao jogador
]]
function ProgressionSystem:TakeDamage(userId, damage)
    local stats = self.PlayerStats[userId]
    if not stats then return end
    
    -- Reduz dano pela defesa
    local actualDamage = math.floor(damage * (1 - (stats.Defense / 100)))
    stats.CurrentHealth = math.max(0, stats.CurrentHealth - actualDamage)
    
    return stats.CurrentHealth
end

--[[
    Cura o jogador
]]
function ProgressionSystem:Heal(userId, amount)
    local stats = self.PlayerStats[userId]
    if not stats then return end
    
    stats.CurrentHealth = math.min(stats.MaxHealth, stats.CurrentHealth + amount)
    return stats.CurrentHealth
end

--[[
    Restaura mana
]]
function ProgressionSystem:RestoreMana(userId, amount)
    local stats = self.PlayerStats[userId]
    if not stats then return end
    
    stats.CurrentMana = math.min(stats.MaxMana, stats.CurrentMana + amount)
    return stats.CurrentMana
end

--[[
    Retorna stats do jogador
]]
function ProgressionSystem:GetPlayerStats(userId)
    return self.PlayerStats[userId]
end

--[[
    DEBUG - Mostra stats de um jogador
]]
function ProgressionSystem:DebugStats(userId)
    local stats = self.PlayerStats[userId]
    if not stats then return end
    
    print("\n╔════════════════════════════════════════╗")
    print("║    📊 STATS DO JOGADOR                ║")
    print("╚════════════════════════════════════════╝")
    print("Level: " .. stats.Level)
    print("Experience: " .. stats.Experience .. " / " .. stats.ExperienceToNextLevel)
    print("\n⚔️  ATRIBUTOS:")
    print("├─ Força: " .. stats.Strength .. " (Dano)")
    print("├─ Agilidade: " .. stats.Agility .. " (Velocidade)")
    print("├─ Resistência: " .. stats.Endurance .. " (HP: " .. stats.MaxHealth .. ")")
    print("├─ Inteligência: " .. stats.Intelligence .. " (Mana: " .. stats.MaxMana .. ")")
    print("└─ Defesa: " .. stats.Defense .. " (Reduz dano)")
    print("\n💰 RECURSOS:")
    print("├─ Pontos de Atributo: " .. stats.StatPoints)
    print("└─ Pontos de Skill: " .. stats.SkillPoints)
    print("\n🎯 CONQUISTAS:")
    print("├─ Inimigos Mortos: " .. stats.KillCount)
    print("├─ Chefes Derrotados: " .. stats.BossesDefeated)
    print("└─ Áreas Exploradas: " .. stats.AreasExplored)
    print("════════════════════════════════════════\n")
end

-- Inicializa
ProgressionSystem:Initialize()

_G.ProgressionSystem = ProgressionSystem
