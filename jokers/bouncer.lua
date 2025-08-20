-- Bouncer: On blind select, for each Joker to the left of this card, roll a 1/2 chance
-- to destroy it. For each destroyed Joker, add its sell value as X mult bonus
-- (e.g., $2 -> +0.2x). Stacks permanently.


local function get_sell_value(j)
    if not j then return 0 end
    if type(j.sell_cost) == 'number' and j.sell_cost >= 0 then return j.sell_cost end
    local base = (j.cost or 0)
    local extra = (j.ability and j.ability.extra_value) or 0
    return math.max(1, math.floor(base/2)) + extra
end

SMODS.Joker({
    key = "bouncer",
    name = "Bouncer",
    atlas = 'bouncer',
    pos = { x = 0, y = 0 },
    rarity = 3,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    config = { extra = { x_mult = 1 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult } }
    end,

    calculate = function(self, card, context)
        -- Trigger when selecting/setting the blind
        if context.setting_blind and not context.blueprint then
            local jokers = (G and G.jokers and G.jokers.cards) or {}
            -- Find this card's index
            local index_of_self = nil
            for i, j in ipairs(jokers) do
                if j == card then index_of_self = i; break end
            end
            if index_of_self and index_of_self > 1 then
                local probability = (G.GAME and G.GAME.probabilities and (G.GAME.probabilities.normal/2)) or (1/2)
                local destroyed_any = false
                -- Snapshot left-of-self to avoid modifying while iterating
                local left_cards = {}
                for i = 1, index_of_self - 1 do table.insert(left_cards, jokers[i]) end
                for i, target in ipairs(left_cards) do
                    if target and target ~= card then
                        local seed_id = (type(target.get_id) == 'function') and target:get_id() or i
                        if pseudorandom('bouncer_left_' .. tostring(seed_id)) < probability then
                            local sv = get_sell_value(target)
                            local add = (sv or 0)/10
                            if add > 0 then
                                card.ability.extra.x_mult = (card.ability.extra.x_mult or 1) + add
                            end
                            destroyed_any = true
                            if target.area and target.area.remove_card then target.area:remove_card(target) end
                            if target.start_dissolve then target:start_dissolve() end
                        end
                    end
                end
                if destroyed_any then
                    return { message = localize{type='variable', key='a_xmult', vars={card.ability.extra.x_mult}}, colour = G.C.MULT, no_retrigger = true, card = card }
                end
            end
        end

        -- Apply total X mult during scoring
        if context.joker_main and context.cardarea == G.jokers and (card.ability.extra.x_mult or 1) > 1 then
            return { colour = G.C.MULT, x_mult = card.ability.extra.x_mult, no_retrigger = true }
        end
    end
})


