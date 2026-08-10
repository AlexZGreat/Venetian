SMODS.Blind{
    key = "wheat",
    atlas = "ven_blind_atlas",
    pos = {x=0,y=0},
    config = {extra = {h_size = 2, h_minus = 1}},
    boss = {min = 3, max = 10},
    boss_colour = HEX("B1BA95"),
    loc_vars = function(self)
        return {vars = {self.config.extra.h_size,self.config.extra.h_minus}}
    end,
    collection_loc_vars = function(self)
        return {vars = {self.config.extra.h_size,self.config.extra.h_minus}}
    end,
    set_blind = function(self)
        G.hand:change_size(self.config.extra.h_size)
    end,
    disable = function(self)
        G.hand:change_size(-self.config.extra.h_size)
    end,
    defeat = function(self)
        G.hand:change_size(-self.config.extra.h_size)
    end,
    calculate = function(self,blind,context)
        if context.before or context.pre_discard then
            G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.8, func = function() 
                self.config.extra.h_size = self.config.extra.h_size - self.config.extra.h_minus
                G.hand:change_size(-self.config.extra.h_minus)
                play_sound('tarot2', 1+0.1, 0.4)
                blind:juice_up(0.3, 0.5)
                return true 
                end
            })) 
        end
    end,
}

SMODS.Blind{
    key = "slope",
    atlas = "ven_blind_atlas",
    pos = {x=0,y=1},
    config = {extra = {}},
    boss = {min = 2, max = 10},
    boss_colour = HEX("A8A898"),
    loc_vars = function(self)
    end,
    collection_loc_vars = function(self)
    end,
    calculate = function(self,blind,context)
        if context.after then
            for i, v in pairs (context.full_hand) do
                local adjacent_rank = false
                for j, w in pairs(context.full_hand) do
                    local rank_data = SMODS.Ranks[w.base.value]
                    local behavior = rank_data.strength_effect or { fixed = 1, ignore = false, random = false }
                    if behavior.ignore or not next(rank_data.next) then
                        break
                    elseif behavior.random then
                    local rank_key = pseudorandom_element(
                        rank_data.next,
                        pseudoseed('strength'),
                        { in_pool = function(key) return SMODS.add_to_pool(SMODS.Ranks[key], { suit = card.base.suit }) end }
                    )
                    else
                        local i = (behavior.fixed and rank_data.next[behavior.fixed]) and behavior.fixed or 1
                        rank_key = rank_data.next[i]
                    end
                    if SMODS.Ranks[rank_key] == SMODS.Ranks[v.base.value] then
                        adjacent_rank = true
                    end
                    
                    if not next(rank_data.prev) or behavior.ignore then
                        break
                    elseif behavior.random then
                    rank_key = pseudorandom_element(
                        rank_data.prev,
                        pseudoseed('weakness'),
                        { in_pool = function(key) return SMODS.add_to_pool(SMODS.Ranks[key], { suit = card.base.suit }) end }
                    )
                    else
                        local i = (behavior.fixed and rank_data.prev[behavior.fixed]) and behavior.fixed or 1
                        rank_key = rank_data.prev[i]
                    end
                    if SMODS.Ranks[rank_key] == SMODS.Ranks[v.base.value] then
                        adjacent_rank = true
                    end
                end
                if adjacent_rank then
                G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.8, func = function() 
                        v:add_sticker("ven_slippery",true)
                        v:juice_up(0.3, 0.5)
                        play_sound('ven_slippery_apply', 1+0.1*i, 0.4)
                        blind:juice_up(0.3, 0.5)
                        return true 
                    end
                    })) 
                end
            end
        end
    end,
}

SMODS.Blind{
    key = "thorn",
    atlas = "ven_blind_atlas",
    pos = {x=0,y=2},
    config = {extra = {}},
    boss = {min = 2, max = 10},
    boss_colour = HEX("4E9D52"),
    loc_vars = function(self)
    end,
    collection_loc_vars = function(self)
    end,
    calculate = function(self,blind,context)
        if context.after then
            for i, v in pairs (context.full_hand) do
                if v:is_face() then
                G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.8, func = function() 
                        v:add_sticker("ven_bleeding",true)
                        v:juice_up(0.3, 0.5)
                        play_sound('ven_bleeding_apply', 1+0.1*i, 0.4)
                        blind:juice_up(0.3, 0.5)
                        return true 
                    end
                    })) 
                end
            end
        end
    end,
}

SMODS.Blind{
    key = "comb",
    atlas = "ven_blind_atlas",
    pos = {x=0,y=3},
    config = {extra = {}},
    boss = {min = 3, max = 10},
    boss_colour = HEX("3C1457"),
    loc_vars = function(self)
    end,
    collection_loc_vars = function(self)
    end,
    calculate = function(self,blind,context)
        if context.setting_blind then
            local cards_to_discard = {}
            for i,v in pairs (G.deck.cards) do
                if #cards_to_discard < #G.deck.cards*(2/3) then
                    cards_to_discard[i] = v
                end
            end
            for i,v in pairs (cards_to_discard) do
                draw_card(G.deck,G.discard, 100,'down', false, G.deck.cards[i])
            end
        end
    end,
}

SMODS.Blind{
    key = "pin",
    atlas = "ven_blind_atlas",
    pos = {x=0,y=4},
    config = {extra = {}},
    boss = {min = 2, max = 10},
    boss_colour = HEX("D77D7D"),
    loc_vars = function(self)
    end,
    collection_loc_vars = function(self)
    end,
    calculate = function(self,blind,context)
        if context.after then
            for i, v in pairs (context.full_hand) do
                if i == 1 or i == #context.full_hand then

                else
                G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.8, func = function() 
                        v:add_sticker("ven_bleeding",true)
                        v:juice_up(0.3, 0.5)
                        play_sound('ven_bleeding_apply', 1+0.1*i, 0.4)
                        blind:juice_up(0.3, 0.5)
                        return true 
                    end
                    })) 
                end
            end
        end
    end,
}

SMODS.Blind{
    key = "crescent",
    atlas = "ven_blind_atlas",
    pos = {x=0,y=5},
    config = {extra = {}},
    boss = {min = 2, max = 10},
    boss_colour = HEX("100742"),
    loc_vars = function(self)
    end,
    collection_loc_vars = function(self)
    end,
    calculate = function(self,blind,context)
        if context.after then
            for i, v in pairs (context.full_hand) do
                if v:is_suit("Spades") or v:is_suit("Clubs") then
                    G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.8, func = function() 
                        v:add_sticker("ven_voided",true)
                        v:juice_up(0.3, 0.5)
                        play_sound('ven_voided_apply', 1+0.1*i, 0.4)
                        blind:juice_up(0.3, 0.5)
                        return true
                    end
                    })) 
                else

                end
            end
        end
    end,
}

SMODS.Blind{
    key = "cross",
    atlas = "ven_blind_atlas",
    pos = {x=0,y=6},
    config = {extra = {}},
    boss = {min = 5, max = 10},
    boss_colour = HEX("6A1212"),
    loc_vars = function(self)
    end,
    collection_loc_vars = function(self)
    end,
    recalc_debuff = function(self, card, from_blind)
        if card.ability.ven_has_been_debuffed then
            return true
        end
    end
}

SMODS.Blind{
    key = "axe",
    atlas = "ven_blind_atlas",
    pos = {x=0,y=7},
    config = {extra = {}},
    boss = {min = 4, max = 10},
    boss_colour = HEX("5C8E7F"),
    loc_vars = function(self)
    end,
    collection_loc_vars = function(self)
    end,
    calculate = function(self,blind,context)
        if context.destroy_card and context.cardarea == G.play then
            if context.destroy_card.ability.set == "Enhanced" then
                return {remove = true}
            end
        end
    end,
}

SMODS.Blind{
    key = "fence",
    atlas = "ven_blind_atlas",
    pos = {x=0,y=8},
    config = {extra = {}},
    boss = {min = 2, max = 10},
    boss_colour = HEX("75624B"),
    loc_vars = function(self)
    end,
    collection_loc_vars = function(self)
    end,
    calculate = function(self,blind,context)
        if context.after then
            for i, v in pairs (context.full_hand) do
                if i == 1 or i == #context.full_hand then
                    G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.8, func = function() 
                        v:add_sticker("ven_disconnected",true)
                        v:juice_up(0.3, 0.5)
                        play_sound('ven_disconnected_apply', 1+0.1*i, 0.4)
                        blind:juice_up(0.3, 0.5)
                        return true 
                    end
                    })) 
                else

                end
            end
        end
    end,
}

SMODS.Blind{
    key = "scratch",
    atlas = "ven_blind_atlas",
    pos = {x=0,y=9},
    config = {extra = {}},
    boss = {min = 2, max = 10},
    boss_colour = HEX("515062"),
    loc_vars = function(self)
    end,
    collection_loc_vars = function(self)
    end,
    calculate = function(self,blind,context)
        if context.after then
            for i, v in pairs (context.full_hand) do
                if v:is_suit("Hearts") or v:is_suit("Diamonds") then
                    G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.8, func = function() 
                        v:add_sticker("ven_disconnected",true)
                        v:juice_up(0.3, 0.5)
                        play_sound('ven_disconnected_apply', 1+0.1*i, 0.4)
                        blind:juice_up(0.3, 0.5)
                        return true 
                    end
                    })) 
                else

                end
            end
        end
    end,
}

SMODS.Blind{
    key = "pole",
    atlas = "ven_blind_atlas",
    pos = {x=0,y=10},
    config = {extra = {}},
    boss = {min = 1, max = 10},
    boss_colour = HEX("8E5672"),
    loc_vars = function(self)
    end,
    collection_loc_vars = function(self)
    end,
    debuff_hand = function(self, cards, hand, handname, check)
        for i,v in pairs (cards) do
            if v:get_id() == 2 or v:get_id() == 14 then
                return false
            end
        end
        return true
    end,
}

SMODS.Blind{
    key = "whirlpool",
    atlas = "ven_blind_atlas",
    pos = {x=0,y=11},
    config = {extra = {odds = 2}},
    boss = {min = 2, max = 10},
    boss_colour = HEX("0369A4"),
    loc_vars = function(self)
        local aaa, bbb = SMODS.get_probability_vars(blind, 1, self.config.extra.odds, "ven_whirlpool")
        return {vars = {aaa,bbb}}
    end,
    collection_loc_vars = function(self)
        local aaa, bbb = SMODS.get_probability_vars(blind, 1, self.config.extra.odds, "ven_whirlpool")
        return {vars = {aaa,bbb}}
    end,
    calculate = function(self,blind,context)
        if context.pre_discard then
            for i, v in pairs (context.full_hand) do
                if SMODS.pseudorandom_probability(blind, "ven_whirlpool", 1, self.config.extra.odds) then
                G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.8, func = function() 
                        v:add_sticker("ven_slippery",true)
                        v:juice_up(0.3, 0.5)
                        play_sound('ven_slippery_apply', 1+0.1*i, 0.4)
                        blind:juice_up(0.3, 0.5)
                        return true 
                    end
                    })) 
                end
            end
        end
    end,
}

SMODS.Blind{
    key = "crowbar",
    atlas = "ven_blind_atlas",
    pos = {x=0,y=12},
    config = {extra = {}},
    boss = {min = 1, max = 10},
    boss_colour = HEX("5B5B5B"),
    loc_vars = function(self)
        return {vars = {}}
    end,
    collection_loc_vars = function(self)
        return {vars = {}}
    end,
    calculate = function(self,blind,context)
        if context.pre_discard and G.GAME.chips > 0 then
            ven_parry()
        end
    end,
}

SMODS.Blind{
    key = "door",
    atlas = "ven_blind_atlas",
    pos = {x=0,y=13},
    config = {extra = {}},
    boss = {min = 2, max = 10},
    boss_colour = HEX("5AB629"),
    loc_vars = function(self)
        return {vars = {}}
    end,
    collection_loc_vars = function(self)
        return {vars = {}}
    end,
    set_blind = function(self)
        G.GAME.modifiers.ven_only_high_card_scores = true
    end,
    disable = function(self)
        G.GAME.modifiers.ven_only_high_card_scores = true
    end,
    defeat = function(self)
        G.GAME.modifiers.ven_only_high_card_scores = true
    end,
}

SMODS.Blind{
    key = "trident",
    atlas = "ven_blind_atlas",
    pos = {x=0,y=14},
    config = {extra = {}},
    boss = {min = 4, max = 10},
    boss_colour = HEX("10ABBA"),
    loc_vars = function(self)
    end,
    collection_loc_vars = function(self)
    end,
    calculate = function(self,blind,context)
        if context.evaluate_poker_hand then
            return {replace_scoring_name = "Three of a Kind"}
        end
    end,
}

SMODS.Blind{
    key = "bolt",
    atlas = "ven_blind_atlas",
    pos = {x=0,y=15},
    config = {extra = {}},
    boss = {min = 2, max = 10},
    boss_colour = HEX("EDB356"),
    loc_vars = function(self)
    end,
    collection_loc_vars = function(self)
    end,
    calculate = function(self,blind,context)
        if context.after then
            for i, v in pairs (G.hand.cards) do
                G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.8, func = function() 
                        v:add_sticker("ven_blinded",true)
                        v:juice_up(0.3, 0.5)
                        play_sound('ven_blinded_apply', 1+0.1*i, 0.4)
                        blind:juice_up(0.3, 0.5)
                        return true 
                    end
                    })) 
            end
        end
    end,
}

SMODS.Blind{
    key = "arrow",
    atlas = "ven_blind_atlas",
    pos = {x=0,y=16},
    config = {extra = {odds = 2}},
    boss = {min = 2, max = 10},
    boss_colour = HEX("726899"),
    loc_vars = function(self)
        local aaa, bbb = SMODS.get_probability_vars(blind, 1, self.config.extra.odds, "ven_arrow")
        return {vars = {aaa,bbb}}
    end,
    collection_loc_vars = function(self)
        local aaa, bbb = SMODS.get_probability_vars(blind, 1, self.config.extra.odds, "ven_arrow")
        return {vars = {aaa,bbb}}
    end,
    calculate = function(self,blind,context)
        if context.after then
            for i, v in pairs (context.full_hand) do
                if SMODS.pseudorandom_probability(blind, "ven_arrow", 1, self.config.extra.odds) then
                G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.8, func = function() 
                        v:add_sticker("ven_blinded",true)
                        v:juice_up(0.3, 0.5)
                        play_sound('ven_blinded_apply', 1+0.1*i, 0.4)
                        blind:juice_up(0.3, 0.5)
                        return true 
                    end
                    })) 
                end
            end
        end
    end,
}

SMODS.Blind{
    key = "knuckle",
    atlas = "ven_blind_atlas",
    pos = {x=0,y=17},
    config = {extra = {}},
    boss = {min = 3, max = 10},
    boss_colour = HEX("DE66D9"),
    mult = 2,
    loc_vars = function(self)
        return {vars = {}}
    end,
    collection_loc_vars = function(self)
        return {vars = {}}
    end,
    set_blind = function(self)
        G.GAME.modifiers.ven_no_retriggers = true
    end,
    disable = function(self)
        G.GAME.modifiers.ven_no_retriggers = false
    end,
    defeat = function(self)
        G.GAME.modifiers.ven_no_retriggers = false
    end,
}

SMODS.Blind{
    key = "cat",
    atlas = "ven_blind_atlas",
    pos = {x=0,y=18},
    config = {extra = {}},
    boss = {min = 3, max = 10},
    boss_colour = HEX("5F4627"),
    mult = 2,
    loc_vars = function(self)
        return {vars = {}}
    end,
    collection_loc_vars = function(self)
        return {vars = {}}
    end,
    set_blind = function(self)
        G.GAME.modifiers.ven_all_cards_in_hand = true
    end,
    disable = function(self)
        G.GAME.modifiers.ven_all_cards_in_hand = false
    end,
    defeat = function(self)
        G.GAME.modifiers.ven_all_cards_in_hand = false
    end,
}

SMODS.Blind{
    key = "gate",
    atlas = "ven_blind_atlas",
    pos = {x=0,y=19},
    config = {extra = {}},
    boss = {min = 2, max = 10},
    boss_colour = HEX("AAAAAA"),
    mult = 1.5,
    loc_vars = function(self)
        return {vars = {}}
    end,
    collection_loc_vars = function(self)
        return {vars = {}}
    end,
    set_blind = function(self)
        G.GAME.modifiers.ven_parry_after_hand_enabled = true
    end,
    disable = function(self)
        G.GAME.modifiers.ven_parry_after_hand_enabled = false
    end,
    defeat = function(self)
        G.GAME.modifiers.ven_parry_after_hand_enabled = false
    end,
}

SMODS.Blind{
    key = "cane",
    atlas = "ven_blind_atlas",
    pos = {x=0,y=20},
    config = {extra = {}},
    boss = {min = 5, max = 10},
    boss_colour = HEX("7C6464"),
    loc_vars = function(self)
    end,
    collection_loc_vars = function(self)
    end,
    recalc_debuff = function(self, card, from_blind)
        for i, v in pairs(ven_curse_table) do
            if card.ability[v] then
                return true
            end
        end
        return false
    end
}

SMODS.Blind{
    key = "helix",
    atlas = "ven_blind_atlas",
    pos = {x=0,y=21},
    config = {extra = {suit_requirement = 3}},
    boss = {min = 1, max = 10},
    boss_colour = HEX("836000"),
    loc_vars = function(self)
        return {vars = {self.config.extra.suit_requirement}}
    end,
    collection_loc_vars = function(self)
        return {vars = {self.config.extra.suit_requirement}}
    end,
    debuff_hand = function(self, cards, hand, handname, check)
        local suit_count = 0
        for i,v in pairs ({"Spades","Diamonds","Hearts","Clubs"}) do
            for j,w in pairs (cards) do
                if w:is_suit(v) then
                    suit_count = suit_count+1
                    break
                end
            end
        end
        if suit_count >= self.config.extra.suit_requirement then
            return false
        end
        return true
    end,
}

SMODS.Blind{
    key = "hourglass",
    atlas = "ven_blind_atlas",
    pos = {x=0,y=22},
    config = {extra = {}},
    boss = {min = 2, max = 10},
    boss_colour = HEX("C8B789"),
    loc_vars = function(self)
    end,
    collection_loc_vars = function(self)
    end,
    calculate = function(self,blind,context)
        if context.after then
            if G.GAME.round_resets.hands < G.GAME.hands then
                for i, v in pairs (context.full_hand) do
                    G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.8, func = function() 
                        v:add_sticker("ven_voided",true)
                        v:juice_up(0.3, 0.5)
                        play_sound('ven_voided_apply', 1+0.1*i, 0.4)
                        blind:juice_up(0.3, 0.5)
                        return true 
                    end
                    })) 
                end
            end
        end
        if context.pre_discard then
            if G.GAME.round_resets.discards < G.GAME.discards then
                for i, v in pairs (context.full_hand) do
                    G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.8, func = function() 
                        v:add_sticker("ven_voided",true)
                        v:juice_up(0.3, 0.5)
                        play_sound('ven_voided_apply', 1+0.1*i, 0.4)
                        blind:juice_up(0.3, 0.5)
                        return true 
                    end
                    })) 
                end
            end
        end
    end,
}


SMODS.Blind{
    key = "twist",
    atlas = "ven_blind_atlas",
    pos = {x=0,y=23},
    config = {extra = {x_scale = 3}},
    boss = {min = 3, max = 10},
    boss_colour = HEX("ED1280"),
    loc_vars = function(self)
        return {vars = {self.config.extra.x_scale}}
    end,
    collection_loc_vars = function(self)
        return {vars = {self.config.extra.x_scale}}
    end,
    calc_scaling = function(self, card, other_card, initial_value, scalar_value, args)
	    return {
	        override_scalar_value = {
		        value = -scalar_value*self.config.extra.x_scale,
	        },
        }
    end, 
}

SMODS.Blind{
    key = "the_blind",
    atlas = "ven_blind_atlas",
    pos = {x=0,y=24},
    config = {extra = {}},
    boss = {min = 2, max = 10},
    boss_colour = HEX("999999"),
    ven_secret_boss = true,
    loc_vars = function(self)
        return {vars = {self.config.extra.x_scale}}
    end,
    collection_loc_vars = function(self)
        return {vars = {self.config.extra.x_scale}}
    end,
    in_pool = function(self)
        if SMODS.pseudorandom_probability(self, "ven_secret_blind", 1, 5) then
            return true
        end
        return false
    end,
}

SMODS.Blind{
    key = "copper_coin",
    atlas = "ven_blind_atlas",
    pos = {x=0,y=25},
    config = {extra = {a_hands = 1}},
    boss = {showdown = true},
    boss_colour = HEX("926A19"),
    mult = 8,
    dollars = 8,
    loc_vars = function(self)
        return{vars = {self.config.extra.a_hands}}
    end,
    collection_loc_vars = function(self)
        return{vars = {self.config.extra.a_hands}}
    end,
    set_blind = function(self)
        ease_hands_played(self.config.extra.a_hands)
    end,
}

SMODS.Blind{
    key = "silver_sword",
    atlas = "ven_blind_atlas",
    pos = {x=0,y=26},
    config = {extra = {}},
    boss = {showdown = true},
    boss_colour = HEX("AAAAAA"),
    dollars = 8,
    loc_vars = function(self)
    end,
    collection_loc_vars = function(self)
    end,
    set_blind = function(self)
        G.GAME.modifiers.ven_parry_enabled = true
    end,
    disable = function(self)
        G.GAME.modifiers.ven_parry_enabled = false
    end,
    defeat = function(self)
        G.GAME.modifiers.ven_parry_enabled = false
    end,
}

function ven_parry()
    G.E_MANAGER:add_event(Event({trigger = "immediate", func = function() 
        G.GAME.chips = 0
        G.GAME.modifiers.ven_parry_enabled = false
        return true 
    end
    })) 
    card_eval_status_text(G.GAME.blind, 'extra', nil, nil, nil, {message = "Reset!", colour = HEX("AAAAAA"), sound = 'ven_parry', })
end

SMODS.Blind{
    key = "ebony_wand",
    atlas = "ven_blind_atlas",
    pos = {x=0,y=27},
    config = {extra = {max_curse = 20, curses = 0}},
    boss = {showdown = true},
    boss_colour = HEX("6A5234"),
    dollars = 8,
    loc_vars = function(self)
        return{vars = {self.config.extra.max_curse}}
    end,
    collection_loc_vars = function(self)
        return{vars = {self.config.extra.max_curse}}
    end,
    set_blind = function(self)
        self.config.extra.curses = 0
    end,
    calculate = function(self,blind,context)
        if context.hand_drawn then
            for i, v in pairs (context.hand_drawn) do
                if self.config.extra.max_curse > self.config.extra.curses then
                    self.config.extra.curses = self.config.extra.curses + 1
                G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.8, func = function() 
                        local curse = pseudorandom_element(ven_curse_table,pseudoseed("ven_ebony_wand"))
                        v:add_sticker(curse,true)
                        v:juice_up(0.3, 0.5)
                        play_sound(curse .. "_apply", 1+0.1*i, 0.4)
                        blind:juice_up(0.3, 0.5)
                        return true 
                    end
                    }))  
                end
            end
        end
    end,
}

SMODS.Blind{
    key = "azure_rose",
    atlas = "ven_blind_atlas",
    pos = {x=0,y=28},
    config = {extra = {x_blindsize = 1.25}},
    boss = {showdown = true},
    boss_colour = HEX("160FDE"),
    dollars = 8,
    loc_vars = function(self)
        return{vars = {self.config.extra.x_blindsize}}
    end,
    collection_loc_vars = function(self)
        return{vars = {self.config.extra.x_blindsize}}
    end,
    calculate = function(self,blind,context)
        if context.hand_drawn and not context.first_hand_drawn then
            return{xblindsize = self.config.extra.x_blindsize}
        end
    end,
}

SMODS.Blind{
    key = "ivory_shield",
    atlas = "ven_blind_atlas",
    pos = {x=0,y=29},
    config = {extra = {old_deck = {}}},
    boss = {showdown = true},
    boss_colour = HEX("D2D324"),
    dollars = 8,
    loc_vars = function(self)
    end,
    collection_loc_vars = function(self)
    end,
    set_blind = function(self)
        for i, v in pairs({"2","3","4","5","6","7","8","9","T","J","K","Q","A"}) do
            for j, w in pairs({"S","H","D","C"}) do
                local _card = create_playing_card({
                            front = G.P_CARDS[w .. "_" .. v],
                            center = G.P_CENTERS.c_base}, G.deck, true, nil, {G.C.SECONDARY_SET.Enhanced})
                _card.ability.ven_temporary = true
            end
        end
    end,
    disable = function(self)
        local destroy_table = {}
        for i, v in pairs(G.playing_cards) do
            if v.ability.ven_temporary then
                destroy_table[#destroy_table+1] = v
            end
        end
        SMODS.destroy_cards(destroy_table,{immediate = true})
    end,
    defeat = function(self) 
        local destroy_table = {}
        for i, v in pairs(G.playing_cards) do
            if v.ability.ven_temporary then
                destroy_table[#destroy_table+1] = v
            end
        end
        SMODS.destroy_cards(destroy_table,{immediate = true})
    end,
}