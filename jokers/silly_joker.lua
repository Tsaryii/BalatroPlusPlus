-- Silly Joker: Gives X2 Mult if this Joker is in the leftmost Joker slot

SMODS.Joker({
	key = "silly_joker",
	name = "Silly Joker",
	atlas = 'silly_joker',
	pos = { x = 0, y = 0 },
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = { extra = { x_mult = 1.75 } },

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.x_mult } }
	end,

	calculate = function(self, card, context)
		if context.joker_main and context.cardarea == G.jokers then
			-- Check if this Joker is currently in the leftmost slot
			if G.jokers and G.jokers.cards and G.jokers.cards[1] == card then
				return {
					colour = G.C.MULT,
					x_mult = card.ability.extra.x_mult,
					no_retrigger = true
				}
			end
		end
	end
})


