-- Petrified Joker: Gains X Mult from conservative discarding
-- Builds up power when you discard conservatively (1-2 cards)
-- Resets to base when you discard aggressively (3+ cards)

SMODS.Joker({
    key = "petrified_joker", 
    name = "Petrified Joker",
    atlas = 'petrified_joker',
    pos = { x = 0, y = 0 },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = { extra = { x_mult = 1, growth_rate = 0.1, reset_threshold = 3 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult, card.ability.extra.growth_rate, card.ability.extra.reset_threshold } }
    end,
    
    calculate = function(self, card, context)
        -- Track discards once per discard action
        if context.pre_discard and not context.blueprint then
            local discarded_count = #context.full_hand or 0
            if discarded_count >= card.ability.extra.reset_threshold then
                card.ability.extra.x_mult = 1
                return { message = "Reset!", colour = G.C.RED, card = card, no_retrigger = true }
            elseif discarded_count > 0 and discarded_count < card.ability.extra.reset_threshold then
                card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.growth_rate
                return { message = "Growing...", colour = G.C.MULT, card = card, no_retrigger = true }
            end
        end
        
        -- Apply the multiplier during scoring
        if context.joker_main and context.cardarea == G.jokers and card.ability.extra.x_mult > 1 then
            return {
                colour = G.C.MULT,
                x_mult = card.ability.extra.x_mult,
                no_retrigger = true
            }
        end
    end
})
