-- ============================================
-- Project Zomboid - Sandbox Vars (PVE Público)
-- Build 42 Unstable
-- ============================================
-- Configuração balanceada para servidor público PVE
-- com sono ativado, progressão justa e zombies desafiadores.
-- ============================================

SandboxVars = {
    VERSION = 5,

    -- =====================
    -- TEMPO E MUNDO
    -- =====================
    -- DayLength: 1=15min, 2=30min, 3=1h, 4=2h, 5=3h, 6=4h, 7=5h, 8=12h, 9=real-time
    DayLength = 4,              -- 2 horas por dia (bom ritmo para PVE público)
    StartYear = 1,
    StartMonth = 7,             -- Julho (verão, mais luz do dia para começar)
    StartDay = 9,
    -- StartTime: 1=7AM, 2=9AM, 3=12PM, 4=2PM, 5=5PM, 6=9PM, 7=12AM, 8=2AM, 9=5AM
    StartTime = 2,              -- 9h da manhã
    NightDarkness = 3,          -- 1=muito escuro, 4=mais claro
    NightLength = 3,            -- 1=curta, 4=longa (normal)

    -- =====================
    -- UTILIDADES
    -- =====================
    -- WaterShut: 1=instant, 2=0-30 dias, 3=0-60 dias, 4=0-120 dias, 5=0-180 dias, 6=0-360 dias, 7=nunca
    WaterShut = 3,              -- 0-60 dias (desafio gradual)
    WaterShutModifier = 45,     -- dia exato do corte
    -- ElecShut: mesma escala
    ElecShut = 3,
    ElecShutModifier = 30,      -- eletricidade cai primeiro

    -- =====================
    -- LOOT E RECURSOS
    -- =====================
    -- 1=extremamente raro, 2=raro, 3=normal, 4=comum, 5=abundante
    FoodLoot = 3,               -- Normal
    WeaponLoot = 3,             -- Normal
    OtherLoot = 3,              -- Normal
    -- Respawn de loot: 1=nenhum, 2=todo dia, 3=toda semana, 4=todo mês, 5=a cada 2 meses
    LootRespawn = 3,            -- Toda semana (mantém o servidor vivo)

    -- =====================
    -- EXPERIÊNCIA E PROGRESSÃO
    -- =====================
    XpMultiplier = 2.5,         -- 2.5x (público precisa ser mais rápido)
    -- StatsDecrease: 1=muito rápido, 2=rápido, 3=normal, 4=lento, 5=muito lento
    StatsDecrease = 4,          -- Lento (mais perdoador para PVE)
    -- EndRegen: 1=muito rápido, 2=rápido, 3=normal, 4=lento, 5=muito lento
    EndRegen = 2,               -- Rápido (mais confortável)
    Nutrition = true,           -- Sistema de nutrição ativo

    -- =====================
    -- NATUREZA E FARMING
    -- =====================
    -- NatureAbundance: 1=muito pobre, 2=pobre, 3=normal, 4=abundante, 5=muito abundante
    NatureAbundance = 4,        -- Abundante (foraging rewarding)
    -- Farming: 1=muito rápido, 2=rápido, 3=normal, 4=lento, 5=muito lento
    Farming = 2,                -- Rápido (incentiva agricultura)
    -- PlantResilience: 1=muito baixa, 2=baixa, 3=normal, 4=alta, 5=muito alta
    PlantResilience = 4,        -- Alta (plantas resistentes)
    -- PlantAbundance: 1=muito pobre, 2=pobre, 3=normal, 4=abundante, 5=muito abundante
    PlantAbundance = 4,         -- Abundante

    -- =====================
    -- COMIDA
    -- =====================
    -- FoodRotSpeed: 1=muito rápido, 2=rápido, 3=normal, 4=lento, 5=muito lento
    FoodRotSpeed = 4,           -- Lento (mais tempo para usar comida)
    -- FridgeFactor: 1=muito baixo, 2=baixo, 3=normal, 4=alto, 5=muito alto
    FridgeFactor = 4,           -- Alto (geladeiras mais eficientes)
    -- Cooking: 1=muito rápido, 5=muito lento
    CookingSpeed = 2,

    -- =====================
    -- CLIMA
    -- =====================
    -- Temperature: 1=muito frio, 2=frio, 3=normal, 4=quente, 5=muito quente
    Temperature = 3,            -- Normal
    -- Rain: 1=muito seco, 2=seco, 3=normal, 4=chuvoso, 5=muito chuvoso
    Rain = 3,                   -- Normal
    -- ErosionSpeed: 1=muito rápido (20 dias), 2=rápido (50), 3=normal (100), 4=lento (200), 5=muito lento (500)
    ErosionSpeed = 4,           -- Lento (mundo mantém aparência por mais tempo)

    -- =====================
    -- CASAS E ALARMES
    -- =====================
    -- LockedHouses: 1=nunca, 2=extremamente raro, 3=raro, 4=às vezes, 5=frequente, 6=muito frequente
    LockedHouses = 5,           -- Frequente
    -- Alarm: 1=nunca, 2=extremamente raro, 3=raro, 4=às vezes, 5=frequente, 6=muito frequente
    Alarm = 4,                  -- Às vezes

    -- =====================
    -- OUTROS
    -- =====================
    StarterKit = false,
    TimeSinceApo = 1,           -- Início da epidemia
    -- Zombies: 1=urbana focada, 2=uniforme
    Distribution = 1,           -- Urbana (mais realista)

    -- =====================
    -- ZOMBIE LORE
    -- =====================
    ZombieLore = {
        -- Speed: 1=sprinters, 2=fast shamblers, 3=shamblers
        Speed = 3,              -- Shamblers (clássico, justo para PVE)
        -- Strength: 1=super-humano, 2=normal, 3=fraco
        Strength = 2,           -- Normal
        -- Toughness: 1=resistente, 2=normal, 3=frágil
        Toughness = 2,          -- Normal
        -- Transmission: 1=sangue+saliva, 2=só saliva, 3=todos infectados, 4=sem transmissão
        Transmission = 1,       -- Sangue + Saliva (clássico)
        -- Mortality: 1=instant, 2=0-30seg, 3=0-1min, 4=0-12h, 5=2-3 dias, 6=1-2 semanas
        Mortality = 5,          -- 2-3 dias (tempo para despedidas e preparação)
        -- Reanimate: 1=instant, 2=0-30seg, 3=0-1min, 4=0-12h, 5=2-3 dias, 6=1-2 semanas
        Reanimate = 3,          -- 0-1 min
        -- Cognition: 1=navigate+use doors, 2=navigate+basic doors, 3=basic navigation
        Cognition = 2,          -- Navigate + basic doors (desafiador mas justo)
        -- Memory: 1=longa, 2=normal, 3=curta, 4=nenhuma
        Memory = 3,             -- Curta (perdoador)
        -- Decomp: 1=enfraquece, 2=leve, 3=sem efeito, 4=fortalece
        Decomp = 1,             -- Decompõe e enfraquece (reward por sobreviver)
        -- Sight: 1=eagle, 2=normal, 3=fraca
        Sight = 2,              -- Normal
        -- Hearing: 1=pinpoint, 2=normal, 3=fraca
        Hearing = 2,            -- Normal
        -- Smell: 1=bloodhound, 2=normal, 3=fraca
        Smell = 2,              -- Normal
        ThumpNoChasing = false,
        ThumpOnConstruction = true,
        ActiveOnly = 1,         -- Dia e noite (24h)
        TriggerHouseAlarm = true,
        ZombiesDragDown = true,
        ZombiesFenceLunge = true,
    },

    -- =====================
    -- ZOMBIE CONFIG (População)
    -- =====================
    ZombieConfig = {
        -- PopulationMultiplier: 0.0-4.0 (0=nenhum, 0.35=baixo, 1.0=normal, 2.0=alto, 4.0=insano)
        PopulationMultiplier = 1.0,         -- Normal
        PopulationStartMultiplier = 0.75,   -- Início mais leve (dar chance aos novatos)
        PopulationPeakMultiplier = 1.5,     -- Pico moderado
        PopulationPeakDay = 42,             -- Pico em 42 dias (mais tempo para preparar)
        RespawnHours = 96.0,                -- Respawn a cada 96h (4 dias - mais raro)
        RespawnUnseenHours = 24.0,          -- Precisa estar fora da área por 24h
        RespawnMultiplier = 0.05,           -- 5% respawn (lento e controlado)
        RedistributeHours = 18.0,           -- Migração a cada 18h
        FollowSoundDistance = 100,
        RallyGroupSize = 15,                -- Grupos menores que padrão
        RallyTravelDistance = 20,
        RallyGroupSeparation = 15,
        RallyGroupRadius = 3,
    },
}
