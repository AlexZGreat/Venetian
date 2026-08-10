--create atlases
--credit to Lapsem for futhark blind textures
SMODS.Atlas{
    key = "ven_blind_atlas",
    px = 34,
    py = 34,
    path = "blind_atlas.png",
    atlas_table = "ANIMATION_ATLAS",
    frames = 20,
}

SMODS.Atlas{
    key = "ven_curse_atlas",
    px = 71,
    py = 95,
    path = "curse_atlas.png",
}

--create sounds
--all sounds sourced from freesound
SMODS.Sound{
    key = "blinded_apply",
    path = "blinded_apply.ogg",
}

SMODS.Sound{
    key = "bleeding_apply",
    path = "bleeding_apply.ogg",
}

SMODS.Sound{
    key = "slippery_apply",
    path = "slippery_apply.ogg",
}

SMODS.Sound{
    key = "voided_apply",
    path = "voided_apply.ogg",
}

SMODS.Sound{
    key = "disconnected_apply",
    path = "disconnected_apply.ogg",
}

SMODS.Sound{
    key = "parry",
    path = "parry.ogg",
}

--load listed files
local lua_files = {
    "Items/blinds.lua",
    "Items/curses.lua"
}

for i, v in pairs (lua_files) do
    print("[Venetian] Loading " .. v)
            local f, err = SMODS.load_file(v)
	        if err then
		        error(err)
	        end
	        f()
end