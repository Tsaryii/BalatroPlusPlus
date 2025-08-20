-- Lighthouse: Permanently gains +10 Chips whenever the played hand contains
-- the lowest rank currently present in your deck. Adds its stored Chips each hand.

local function iterate_deck_cards()
	local function yield_cards(area)
		if area and area.cards then
			for _, c in ipairs(area.cards) do coroutine.yield(c) end
		end
	end
	return coroutine.wrap(function()
		yield_cards(G and G.deck)
		yield_cards(G and G.hand)
		yield_cards(G and G.discard)
		yield_cards(G and G.play)
		if G and G.playing_cards and #G.playing_cards > 0 then
			for _, c in ipairs(G.playing_cards) do coroutine.yield(c) end
		end
	end)
end

local function get_lowest_rank_id_in_deck()
	local min_id
	for c in iterate_deck_cards() do
		if c then
			local cid = (type(c.get_id) == 'function') and c:get_id() or (c.base and c.base.value)
			if type(cid) == 'number' then
				if not min_id or cid < min_id then min_id = cid end
			end
		end
	end
	return min_id
end

local function value_to_rank_label(v)
	if not v then return '?' end
	if v == 14 or v == 1 then return 'A' end
	if v == 13 then return 'K' end
	if v == 12 then return 'Q' end
	if v == 11 then return 'J' end
	return tostring(v)
end

local function played_hand_contains_value(context, value)
	if not value then return false end
	local hand = context.full_hand or context.scoring_hand
	if not hand then return false end
	for _, c in ipairs(hand) do
		if c then
			local cid = (type(c.get_id) == 'function') and c:get_id() or (c.base and c.base.value)
			if cid == value then return true end
		end
	end
	return false
end

SMODS.Joker({
	key = "lighthouse",
	name = "Lighthouse",
	atlas = 'lighthouse',
	pos = { x = 0, y = 0 },
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = { extra = { stored_chips = 0 } },

	loc_vars = function(self, info_queue, card)
		local lowest = get_lowest_rank_id_in_deck()
		return { vars = { card.ability.extra.stored_chips or 0, value_to_rank_label(lowest) } }
	end,

	calculate = function(self, card, context)
		-- Reset per-hand increment guard before scoring starts; if condition met, increment and show +10 now
		if context.before and not context.blueprint then
			card.ability.extra._incremented_this_hand = false
			local lowest = get_lowest_rank_id_in_deck()
			if played_hand_contains_value(context, lowest) then
				card.ability.extra.stored_chips = (card.ability.extra.stored_chips or 0) + 10
				card.ability.extra._incremented_this_hand = true
				return { message = localize{type='variable', key='a_chips', vars={10}}, colour = G.C.CHIPS, no_retrigger = true, card = card }
			end
		end

		-- During main joker scoring, show and add the total stored chips exactly once
		if context.joker_main and context.cardarea == G.jokers then
			local total = card.ability.extra.stored_chips or 0
			if total > 0 then
				return { colour = G.C.CHIPS, chips = total, no_retrigger = true }
			else
				return { chips = 0, no_retrigger = true }
			end
		end
	end
})


