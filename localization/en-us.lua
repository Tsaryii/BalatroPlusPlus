return {
    descriptions = {
        Joker = {
            j_tbc_whiteboard = {
                name = "Whiteboard",
                text = {
                    "{X:red,C:white}X#1#{} Mult if hand contains",
                    "no {C:spades}Spades{} or {C:clubs}Clubs{}",
                    "{C:inactive}(Can mix {C:hearts}Hearts{} and {C:diamonds}Diamonds{})"
                }
            },
            j_tbc_eques = {
                name = "Eques", 
                text = {
                    "All played {C:attention}face cards{}",
                    "count as {C:attention}Kings{}",
                    "{C:inactive}(Knights become Kings)"
                }
            },
            j_tbc_petrified_joker = {
                name = "Petrified Joker",
                text = {
                    "This Joker Gains {X:mult,C:white}+#2#X{} mult per",
                    "{C:attention}consecutive{} discard of",
                    "two or less cards",
                    "{C:inactive}(Currently {X:mult,C:white}X#1#)"
                }
            }
            ,
            j_tbc_cracked_mirror = {
                name = "Cracked Mirror",
                text = {
                    "{X:mult,C:white}X#2#{} Mult if played hand",
                    "is exactly {C:attention}#1#{}",
                    "{C:inactive}(Picks a feasible hand each round)"
                }
            }
            ,
            j_tbc_lighthouse = {
                name = "Lighthouse",
                text = {
                    "Gains {C:chips}+10{} Chips",
                    "if played hand contains",
                    "your {C:attention}lowest ranked card{}",
                    "{C:inactive} (Currently: {C:chips}#1#{C:inactive} Chips)"
                }
            }
            ,
            j_tbc_silly_joker = {
                name = "Silly Joker",
                text = {
                    "{X:mult,C:white}X#1#{} Mult if this Joker",
                    "is in the {C:attention}leftmost{} Joker slot"
                }
            }
            ,
            j_tbc_bouncer = {
                name = "Bouncer",
                text = {
                    "When blind is selected: {C:attention}1/2 chance{} to destroy the",
                    "{C:attention}youngest Joker{} and gain {X:mult,C:white}+0.1x{}",
                    "per {C:money}$1{} of its sell value.",
                    "{C:inactive}(Currently: {X:mult,C:white}X#1#)"
                }
            }
            ,
            j_tbc_tax_collector = {
                name = "Tax Collector",
                text = {
                    "Permanently gains {C:mult}+2{} Mult for",
                    "each {C:money}$5{} of interest at end of round;",
                    "subtracts {C:money}$1{} from each $5 of interest.",
                    "{C:inactive}(Currently {C:mult}+#1#{})"
                }
            }
        }
    },
    misc = {
        dictionary = {
            k_tbc_knight = "Knight!",
            k_tbc_growing = "Growing...",
            k_tbc_reset = "Reset!",
            k_tbc_red_suit = "All Red!"
        }
    }
}
