--- STEAMODDED HEADER
--- MOD_NAME: Vanilla+
--- MOD_ID: VanillaPlus
--- MOD_AUTHOR: [Tsar]
--- MOD_DESCRIPTION: A mod that aims to add content to the game without changing the core mechanics by following the current design philosophy of balatro.
--- PRIORITY: 0
--- PREFIX: tbc

----------------------------------------------
------------MOD CODE -------------------------

-- Register custom atlas for Petrified Joker art
SMODS.Atlas {
    key = 'petrified_joker',
    path = 'PetrifiedJoker.png',
    px = 71,
    py = 95,
}

SMODS.Atlas {
    key = 'lighthouse',
    path = 'LightHouse.png',
    px = 71,
    py = 95,
}

SMODS.Atlas {
    key = 'silly_joker',
    path = 'SillyJoker.png',
    px = 71,
    py = 95,
}

SMODS.Atlas {
    key = 'bouncer',
    path = 'Bouncer.png.png',
    px = 71,
    py = 95,
}

SMODS.Atlas {
    key = 'tax_collector',
    path = 'TaxCollector.png',
    px = 71,
    py = 95,
}

SMODS.current_mod.config_file = {
    synergy_bonus_mult = 1.0,  -- Multiplier for synergy bonuses
    debug_mode = false,        -- Enable debug messages
}

-- Helper function to check if a specific joker is present
local function has_joker(key)
    for _, joker_card in ipairs(G.jokers.cards) do
        if joker_card.ability.name == key then
            return joker_card
        end
    end
    return false
end

-- Helper function to count specific jokers
local function count_jokers(key)
    local count = 0
    for _, joker_card in ipairs(G.jokers.cards) do
        if joker_card.ability.name == key then
            count = count + 1
        end
    end
    return count
end

-- Helper function to count face cards in hand
local function count_face_cards(cards)
    local count = 0
    for _, card in ipairs(cards) do
        if card:is_face() then
            count = count + 1
        end
    end
    return count
end

-- Helper function to count enhancement types
local function count_enhancement(cards, enhancement)
    local count = 0
    for _, card in ipairs(cards) do
        if card.ability.effect == enhancement then
            count = count + 1
        end
    end
    return count
end

-- Helper function to check if all cards in hand have same suit
local function all_same_suit(cards)
    if #cards == 0 then return false end
    local suit = cards[1].base.suit
    for _, card in ipairs(cards) do
        if card.base.suit ~= suit then
            return false
        end
    end
    return true
end

-- Load all joker files
local joker_files = {
    'jokers/petrified_joker',
    'jokers/lighthouse',
    'jokers/silly_joker',
    'jokers/bouncer',
    'jokers/tax_collector'
}

for _, file in ipairs(joker_files) do
    local chunk = SMODS.load_file(file .. '.lua')
    if chunk then
        chunk()
    end
end

-- Load localization
local loc_chunk = SMODS.load_file('localization/en-us.lua')
if loc_chunk then
    loc_chunk()
end

-- Register challenge(s)
local challenge_files = {
	'challenges/mod_showcase',
}
for _, file in ipairs(challenge_files) do
	local chunk = SMODS.load_file(file .. '.lua')
	if chunk then chunk() end
end

-- Force our jokers into the next shop for testing
G.SETTINGS = G.SETTINGS or {}
G.SETTINGS.tutorial_progress = G.SETTINGS.tutorial_progress or {}
G.SETTINGS.tutorial_progress.forced_shop = {
    'j_tbc_petrified_joker',
    'j_tbc_lighthouse',
    'j_tbc_silly_joker',
    'j_tbc_bouncer',
    'j_tbc_tax_collector',
}

----------------------------------------------
------------MOD CODE END----------------------
