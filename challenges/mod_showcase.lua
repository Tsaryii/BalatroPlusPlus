-- Vanilla+ Challenge: Guarantees one Vanilla+ Joker to start,
-- and forces 4 other Vanilla+ Jokers to appear in shops before Ante 6

local challenge = SMODS.Challenge({
	key = "mod_showcase",
	loc_txt = { name = "Vanilla+ Showcase" },
	-- Start with one Joker from this mod
	jokers = {
		{ id = "j_tbc_lighthouse" },
	},
	-- No special restrictions or rules required for now
	rules = { custom = {}, modifiers = {} },
	unlocked = function(self) return true end,
})

-- Force 4 Vanilla+ Jokers to appear before Ante 6 using the forced_shop mechanism.
-- We seed a list of our Joker IDs; `create_card_for_shop` consumes them in order.
G.SETTINGS = G.SETTINGS or {}
G.SETTINGS.tutorial_progress = G.SETTINGS.tutorial_progress or {}
local forced = G.SETTINGS.tutorial_progress.forced_shop or {}
local to_force = {
	'j_tbc_petrified_joker',
	'j_tbc_lighthouse',
	'j_tbc_silly_joker',
	'j_tbc_bouncer',
	'j_tbc_tax_collector',
}
-- Push up to 4 unique VanillaPlus jokers, avoiding duplicates already scheduled
local have = {}
for _, k in ipairs(forced) do have[k] = true end
local added = 0
for _, k in ipairs(to_force) do
	if not have[k] and added < 4 then
		forced[#forced+1] = k
		have[k] = true
		added = added + 1
	end
end
G.SETTINGS.tutorial_progress.forced_shop = forced



