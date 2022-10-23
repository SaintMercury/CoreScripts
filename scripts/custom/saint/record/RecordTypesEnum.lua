local RECORD_TYPES = {
    ACTIVATOR          = 'ACTI',
    POTION             = 'ALCH',
    ALCHEMY_APPARATUS  = 'APPA',
    ARMOR              = 'ARMO',
    BODY_PARTS         = 'BODY',
    BOOK               = 'BOOK',
    BIRTHSIGN          = 'BSGN',
    CELL               = 'CELL',
    CLASS              = 'CLASS',
    CLOTHING           = 'CLOT',
    CONTAINER          = 'CONT',
    CREATURE           = 'CREA',
    DIALOGUE           = 'DIAL',
    DOOR               = 'DOOR',
    ENCHANTMENT        = 'ENCH',
    FACTION            = 'FACT',
    GLOBAL             = 'GLOB',
    GAME_SETTING       = 'GMST',
    DIALOGUE_RESPONSE  = 'INFO',
    INGREDIENT         = 'INGR',
    LAND               = 'LAND',
    LEVELED_CREATURE   = 'LEVC',
    LEVELED_ITEM       = 'LEVI',
    LIGHT              = 'LIGH',
    LOCKPICKING_ITEMS  = 'LOCK',
    LAND_TEXTURE       = 'LTEX',
    MAGIC_EFFECT       = 'MGEF',
    MISCELLANEOUS_ITEM = 'MISC',
    NPC                = 'NPC_',
    PATH_GRID          = 'PGRD',
    PROBE_ITEMS        = 'PROB',
    RACE               = 'RACE',
    REGION             = 'REGN',
    REPAIR_ITEMS       = 'REPA',
    SCRIPT             = 'SCPT',
    SKILL              = 'SKIL',
    SOUND_GENERATOR    = 'SNDG',
    SOUND              = 'SOUN',
    SPELL              = 'SPEL',
    START_SCRIPT       = 'SSCR',
    STATIC             = 'STAT',
    TES3               = 'TES3',
    WEAPON             = 'WEAP',

    MASTER             = 'MAST',
}

local RECORD_TYPES_LOOKUP = {}
for k, v in pairs(RECORD_TYPES) do
    RECORD_TYPES_LOOKUP[v] = k
end

return {
    RECORD_TYPES = RECORD_TYPES,
    RECORD_TYPES_LOOKUP = RECORD_TYPES_LOOKUP
}