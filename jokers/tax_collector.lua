-- Tax Collector: +2 Mult; at end of round, if interest would be gained, lose $1

SMODS.Joker({
	key = "tax_collector",
	name = "Tax Collector",
	atlas = 'tax_collector',
	pos = { x = 0, y = 0 },
	rarity = 1,
	cost = 5,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = { extra = { mult = 0 } },

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,

	calculate = function(self, card, context)
		-- Permanent stacking: at end of round, for each $5 of INTEREST earned,
		-- add +2 Mult permanently to this Joker
		if context.end_of_round and not context.blueprint and not context.repetition and not context.individual and not context.other_card then
			if G and G.GAME and not (G.GAME.modifiers and G.GAME.modifiers.no_interest) then
				local dollars = math.max(0, G.GAME.dollars or 0)
				local bracket_count = math.min(math.floor(dollars / 5), math.floor((G.GAME.interest_cap or 25) / 5))
				local interest_amt = (G.GAME.interest_amount or 1)
				local interest_dollars = interest_amt * bracket_count
				local triggers = math.floor(interest_dollars / 5)
				if triggers > 0 then
					local gained = 2 * triggers
					card.ability.extra.mult = (card.ability.extra.mult or 0) + gained
					return { message = localize{ type = 'variable', key = 'a_mult', vars = { gained } }, colour = G.C.MULT }
				end
			end
		end
		if context.joker_main and context.cardarea == G.jokers then
			return {
				message = localize{ type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } },
				mult_mod = card.ability.extra.mult,
				colour = G.C.MULT
			}
		end
	end
})

-- Deduct $1 at round evaluation only if interest would be paid
SMODS.Centers = SMODS.Centers or {}
SMODS.Centers.j_tbc_tax_collector = SMODS.Centers.j_tbc_tax_collector or {}

SMODS.Centers.j_tbc_tax_collector.calc_dollar_bonus = function(self, card)
	if not G or not G.GAME then return nil end
	if G.GAME.modifiers and G.GAME.modifiers.no_interest then return nil end
	local dollars = math.max(0, G.GAME.dollars or 0)
	local cap_triggers = math.floor(((G.GAME.interest_cap or 25) / 5))
	local bracket_count = math.min(math.floor(dollars / 5), cap_triggers)
	local interest_dollars = (G.GAME.interest_amount or 1) * bracket_count
	local reduce = math.floor(interest_dollars / 5)
	if reduce > 0 then
		return -reduce
	end
	return nil
end


