--yes this is hardcoded, yes i hate it too
ven_curse_table = {
        "ven_blinded",
        "ven_bleeding",
        "ven_slippery",
        "ven_voided",
        "ven_disconnected",
    }

--Blinded

SMODS.Shader{
    key = "blinded",
    path = "blinded.fs",
    send_vars = function (sprite, card)
        return {
            time_but_works = G.TIMERS.REAL
        }
    end,
}

SMODS.Sticker{
    key = "ven_blinded",
    atlas = "ven_curse_atlas",
    pos = {x=0,y=0},
    rate = 0,
    no_collection = true,
    config = {},
    draw = function(self, card)
		G.shared_stickers[self.key].role.draw_major = card
		G.shared_stickers[self.key]:draw_shader("dissolve", nil, nil, nil, card.children.center)
        G.shared_stickers[self.key]:draw_shader("ven_blinded", nil, nil, nil, card.children.center)
	end,
    apply = function(self, card, val)
        if val then
            for i, v in pairs(ven_curse_table) do
                if card.ability[v] and v ~= self.key then
                    card.ability[v] = nil
                end
            end
            card.ability[self.key] = self.config
        else
            card.ability[self.key] = val
        end
    end,
}

local ven_oldgen = Card.generate_UIBox_ability_table
Card.generate_UIBox_ability_table = function(self)
    if self.ability.ven_blinded then
        return generate_card_ui({key = 'ven_blinded', set = 'Other'}, nil)
    else
        return ven_oldgen(self)
    end
end

--Bleeding

SMODS.Shader{
    key = "bleeding",
    path = "bleeding.fs",
    send_vars = function (sprite, card)
        return {
            time_but_works = G.TIMERS.REAL
        }
    end,
}

SMODS.Sticker{
    key = "ven_bleeding",
    atlas = "ven_curse_atlas",
    pos = {x=1,y=0},
    rate = 0,
    no_collection = true,
    config = {},
    badge_colour = HEX("a02000"),
    draw = function(self, card)
		G.shared_stickers[self.key].role.draw_major = card
        G.shared_stickers[self.key]:draw_shader("ven_bleeding", nil, nil, nil, card.children.center)
	end,
    apply = function(self, card, val)
        if val then
            for i, v in pairs(ven_curse_table) do
                if card.ability[v] and v ~= self.key then
                    card.ability[v] = nil
                end
            end
            card.ability[self.key] = self.config
        else
            card.ability[self.key] = val
        end
    end,
}

local ven_oldget_cb = Card.get_chip_bonus
Card.get_chip_bonus = function(self)
    local ret = ven_oldget_cb(self)
    if self.ability.ven_bleeding then
        ret = -2*ret
    end
    return ret
end

--Slippery

SMODS.Shader{
    key = "slippery",
    path = "slippery.fs",
    send_vars = function (sprite, card)
        return {
            time_but_works = G.TIMERS.REAL
        }
    end,
}

SMODS.Sticker{
    key = "ven_slippery",
    atlas = "ven_curse_atlas",
    pos = {x=2,y=0},
    rate = 0,
    no_collection = true,
    config = {odds = 5},
    badge_colour = HEX("eef4a7"),
    draw = function(self, card)
		G.shared_stickers[self.key].role.draw_major = card
        G.shared_stickers[self.key]:draw_shader("ven_slippery", nil, nil, nil, card.children.center)
	end,
    loc_vars = function(self)
        local aaa, bbb = SMODS.get_probability_vars(self, 1, self.config.odds, "ven_slippery")
        return {vars = {aaa,bbb}}
    end,
    apply = function(self, card, val)
        if val then
            for i, v in pairs(ven_curse_table) do
                if card.ability[v] and v ~= self.key then
                    card.ability[v] = nil
                end
            end
            card.ability[self.key] = self.config
        else
            card.ability[self.key] = val
        end
    end,
}

local ven_oldplay_from_hilight = G.FUNCS.play_cards_from_highlighted
G.FUNCS.play_cards_from_highlighted = function(self,e)
    if G.play and G.play.cards[1] then return end
    local mark_for_remove = {}
    for i=1, #G.hand.highlighted do
        if G.hand.highlighted[i].ability.ven_slippery then
            if SMODS.pseudorandom_probability(G.hand.highlighted[i], "ven_slippery", 1, G.hand.highlighted[i].ability.ven_slippery.odds) then
                mark_for_remove[#mark_for_remove+1]=(G.hand.highlighted[i])
            end
        end
    end
    for i=1, #mark_for_remove do
        G.hand:remove_from_highlighted(mark_for_remove[i])
    end
    local ret = ven_oldplay_from_hilight(self,e)
    return ret
end

local ven_olddisc_from_hilight = G.FUNCS.discard_cards_from_highlighted
G.FUNCS.discard_cards_from_highlighted = function(self,e,hook)
    local mark_for_remove = {}
    for i=1, #G.hand.highlighted do
        if G.hand.highlighted[i].ability.ven_slippery then
            if SMODS.pseudorandom_probability(G.hand.highlighted[i], "ven_slippery", 1, G.hand.highlighted[i].ability.ven_slippery.odds) then
                mark_for_remove[#mark_for_remove+1]=(G.hand.highlighted[i])
            end
        end
    end
    for i=1, #mark_for_remove do
        G.hand:remove_from_highlighted(mark_for_remove[i])
    end
    local ret = ven_olddisc_from_hilight(self,e,hook)
    return ret
end

--Voided

SMODS.Shader{
    key = "voided",
    path = "voided.fs",
    send_vars = function (sprite, card)
        return {
            time_but_works = G.TIMERS.REAL
        }
    end,
}

SMODS.Sticker{
    key = "ven_voided",
    atlas = "ven_curse_atlas",
    pos = {x=3,y=0},
    rate = 0,
    no_collection = true,
    config = {},
    badge_colour = HEX("2b0d41"),
    draw = function(self, card)
		G.shared_stickers[self.key].role.draw_major = card
        G.shared_stickers[self.key]:draw_shader("ven_voided", nil, nil, nil, card.children.center)
	end,
    apply = function(self, card, val)
        if val then
            for i, v in pairs(ven_curse_table) do
                if card.ability[v] and v ~= self.key then
                    card.ability[v] = nil
                end
            end
            card.ability[self.key] = self.config
        else
            card.ability[self.key] = val
        end
    end,
}

--Disconnected

SMODS.Shader{
    key = "disconnected",
    path = "disconnected.fs",
    send_vars = function (sprite, card)
        return {
            time_but_works = G.TIMERS.REAL
        }
    end,
}

SMODS.Sticker{
    key = "ven_disconnected",
    atlas = "ven_curse_atlas",
    pos = {x=4,y=0},
    rate = 0,
    no_collection = true,
    config = {count = 2},
    badge_colour = HEX("918fad"),
    draw = function(self, card)
		G.shared_stickers[self.key].role.draw_major = card
        G.shared_stickers[self.key]:draw_shader("ven_disconnected", nil, nil, nil, card.children.center)
	end,
    loc_vars = function(self)
        return {vars = {self.config.count}}
    end,
    apply = function(self, card, val)
        if val then
            for i, v in pairs(ven_curse_table) do
                if card.ability[v] and v ~= self.key then
                    card.ability[v] = nil
                end
            end
            card.ability[self.key] = self.config
        else
            card.ability[self.key] = val
        end
    end,
}

local ven_oldcan_highlight = CardArea.can_highlight
CardArea.can_highlight = function(self, card)
    local other_disconnected = 0
    if self.config.type == "hand" then
        if card.ability.ven_disconnected then
            for i, v in pairs (G.hand.highlighted) do
                if v.ability.ven_disconnected and v ~= card then
                    other_disconnected = other_disconnected+1
                end
            end
            if other_disconnected >= card.ability.ven_disconnected.count then
                return false
            end
        end
    end
    return ven_oldcan_highlight(self,card)
end

--The Eye (Cleansing Tarot)

SMODS.Consumable{
    key = "the_eye",
    atlas = "ven_curse_atlas",
    pos = {x=0,y=1},
    set = "Tarot",
    config = {},
    use = function(self, card, area, copier)
        for i=1, #G.hand.cards do
            local percent = 1.15 - (i-0.999)/(#G.hand.cards-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.cards[i]:flip();play_sound('card1', percent);G.hand.cards[i]:juice_up(0.3, 0.3);return true end }))
        end
        delay(0.2)
        for i=1, #G.hand.cards do
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() 
                    for _, v in pairs (ven_curse_table) do
                        G.hand.cards[i]:remove_sticker(v,false)
                    end
                    return true end }))
        end

        for i=1, #G.hand.cards do
            local percent = 0.85 + (i-0.999)/(#G.hand.cards-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.cards[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.cards[i]:juice_up(0.3, 0.3);return true end }))
        end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                if G.consumeables.config.card_limit > #G.consumeables.cards then
                    play_sound('timpani')
                    local _card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'ven_eye')
                    _card:add_to_deck()
                    G.consumeables:emplace(_card)
                    card:juice_up(0.3, 0.5)
                end
                return true end }))
    end,
    can_use = function(self,card)
        if G.STATE ~= G.STATES.HAND_PLAYED and G.STATE ~= G.STATES.DRAW_TO_HAND and G.STATE ~= G.STATES.PLAY_TAROT or any_state then
            if #G.hand.cards > 1 then
                return true
            end
        end
        return false
    end
}
