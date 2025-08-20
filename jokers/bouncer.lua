-- Bouncer: On blind select, 50% chance to destroy the youngest (rightmost) Joker
-- and add its sell value as X mult bonus (e.g., $2 -> +0.2x). Stacks permanently.

local function get_youngest_other_joker(self_card)
    if not (G and G.jokers and G.jokers.cards) then return nil end
    local youngest, max_id = nil, -math.huge
    for _, v in ipairs(G.jokers.cards) do
        if v ~= self_card then
            local vid = (type(v.get_id) == 'function') and v:get_id() or 0
            if vid > max_id then
                youngest, max_id = v, vid
            end
        end
    end
    return youngest
end

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
            if pseudorandom('bouncer_blind') < (G.GAME and G.GAME.probabilities and (G.GAME.probabilities.normal/2) or (1/2)) then
                local target = get_youngest_other_joker(card)
                if target then
                    local sv = get_sell_value(target)
                    local add = (sv or 0)/10
                    if add > 0 then
                        card.ability.extra.x_mult = (card.ability.extra.x_mult or 1) + add
                    end
                    -- dissolve the target joker
                    if target.area and target.area.remove_card then target.area:remove_card(target) end
                    target:start_dissolve()
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


