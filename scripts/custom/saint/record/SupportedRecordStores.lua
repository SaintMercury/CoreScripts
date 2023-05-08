local RecordTypesEnum = require('custom.saint.record.RecordTypesEnum')

local SupportedRecordStores = {
    [RecordTypesEnum.RECORD_TYPES.ACTIVATOR]          = true,
    [RecordTypesEnum.RECORD_TYPES.ALCHEMY_APPARATUS]  = true,
    [RecordTypesEnum.RECORD_TYPES.ARMOR]              = true,
    [RecordTypesEnum.RECORD_TYPES.BODY_PARTS]         = true,
    [RecordTypesEnum.RECORD_TYPES.BOOK]               = true,
    [RecordTypesEnum.RECORD_TYPES.BIRTHSIGN]          = false,
    [RecordTypesEnum.RECORD_TYPES.CELL]               = true,
    [RecordTypesEnum.RECORD_TYPES.CLASS]              = false,
    [RecordTypesEnum.RECORD_TYPES.CLOTHING]           = true,
    [RecordTypesEnum.RECORD_TYPES.CONTAINER]          = true,
    [RecordTypesEnum.RECORD_TYPES.CREATURE]           = true,
    [RecordTypesEnum.RECORD_TYPES.DIALOGUE]           = false,
    [RecordTypesEnum.RECORD_TYPES.DIALOGUE_RESPONSE]  = false,
    [RecordTypesEnum.RECORD_TYPES.DOOR]               = true,
    [RecordTypesEnum.RECORD_TYPES.ENCHANTMENT]        = true,
    [RecordTypesEnum.RECORD_TYPES.FACTION]            = false,
    [RecordTypesEnum.RECORD_TYPES.GLOBAL]             = false,
    [RecordTypesEnum.RECORD_TYPES.GAME_SETTING]       = true,
    [RecordTypesEnum.RECORD_TYPES.INGREDIENT]         = true,
    [RecordTypesEnum.RECORD_TYPES.LAND]               = false,
    [RecordTypesEnum.RECORD_TYPES.LAND_TEXTURE]       = false,
    [RecordTypesEnum.RECORD_TYPES.LEVELED_CREATURE]   = false,
    [RecordTypesEnum.RECORD_TYPES.LEVELED_ITEM]       = false,
    [RecordTypesEnum.RECORD_TYPES.LIGHT]              = true,
    [RecordTypesEnum.RECORD_TYPES.LOCKPICKING_ITEMS]  = true,
    [RecordTypesEnum.RECORD_TYPES.MAGIC_EFFECT]       = false,
    [RecordTypesEnum.RECORD_TYPES.MISCELLANEOUS_ITEM] = true,
    [RecordTypesEnum.RECORD_TYPES.NPC]                = true,
    [RecordTypesEnum.RECORD_TYPES.PATH_GRID]          = false,
    [RecordTypesEnum.RECORD_TYPES.POTION]             = true,
    [RecordTypesEnum.RECORD_TYPES.PROBE_ITEMS]        = true,
    [RecordTypesEnum.RECORD_TYPES.RACE]               = false,
    [RecordTypesEnum.RECORD_TYPES.REGION]             = false,
    [RecordTypesEnum.RECORD_TYPES.REPAIR_ITEMS]       = true,
    [RecordTypesEnum.RECORD_TYPES.SCRIPT]             = true,
    [RecordTypesEnum.RECORD_TYPES.SKILL]              = false,
    [RecordTypesEnum.RECORD_TYPES.SOUND]              = true,
    [RecordTypesEnum.RECORD_TYPES.SOUND_GENERATOR]    = false,
    [RecordTypesEnum.RECORD_TYPES.SPELL]              = true,
    [RecordTypesEnum.RECORD_TYPES.START_SCRIPT]       = false,
    [RecordTypesEnum.RECORD_TYPES.STATIC]             = true,
    [RecordTypesEnum.RECORD_TYPES.WEAPON]             = true,

    [RecordTypesEnum.RECORD_TYPES.TES3]               = false, -- "Supported"
    [RecordTypesEnum.RECORD_TYPES.MASTER]             = false, -- "Supported"
}

return SupportedRecordStores
