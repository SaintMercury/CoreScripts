-------------------------------------------------------------------------------
--- SaintEspToRecord
--- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--- Creates records from reading esp's
--- Ref: https://www.mwmythicmods.com/tutorials/MorrowindESPFormat.html
--- Ref: https://en.uesp.net/wiki/Morrowind_Mod:Mod_File_Format
-------------------------------------------------------------------------------

---TODO: Find way to be more performant and memory efficient.
---TODO: There's a lot of string copying that ideally should be avoided

local io                    = require('io')
local config                = require('config')
local SaintLogger           = require('custom.saint.common.logger.main')
local SaintScriptSave       = require('custom.saint.common.data.main')
local SaintUtilities        = require('custom.saint.common.utilities.main')
local BinaryStringReader    = require('custom.saint.io.main')
local TES3Parser            = require('custom.saint.record.parser.TES3Parser')
local ACTIParser            = require('custom.saint.record.parser.ACTIParser')
local ALCHParser            = require('custom.saint.record.parser.ALCHParser')
local APPAParser            = require('custom.saint.record.parser.APPAParser')
local ARMOParser            = require('custom.saint.record.parser.ARMOParser')
local BODYParser            = require('custom.saint.record.parser.BODYParser')
local BOOKParser            = require('custom.saint.record.parser.BOOKParser')
local BSGNParser            = require('custom.saint.record.parser.BSGNParser')
local CELLParser            = require('custom.saint.record.parser.CELLParser')
local CLASParser            = require('custom.saint.record.parser.CLASParser')
local CLOTParser            = require('custom.saint.record.parser.CLOTParser')
local CONTParser            = require('custom.saint.record.parser.CONTParser')
local CREAParser            = require('custom.saint.record.parser.CREAParser')
local DIALParser            = require('custom.saint.record.parser.DIALParser')
local DOORParser            = require('custom.saint.record.parser.DOORParser')
local ENCHParser            = require('custom.saint.record.parser.ENCHParser')
local FACTParser            = require('custom.saint.record.parser.FACTParser')
local GLOBParser            = require('custom.saint.record.parser.GLOBParser')
local GMSTParser            = require('custom.saint.record.parser.GMSTParser')
local INFOParser            = require('custom.saint.record.parser.INFOParser')
local INGRParser            = require('custom.saint.record.parser.INGRParser')
local LANDParser            = require('custom.saint.record.parser.LANDParser')
local LEVCParser            = require('custom.saint.record.parser.LEVCParser')
local LEVIParser            = require('custom.saint.record.parser.LEVIParser')
local LIGHParser            = require('custom.saint.record.parser.LIGHParser')
local LOCKParser            = require('custom.saint.record.parser.LOCKParser')
local LTEXParser            = require('custom.saint.record.parser.LTEXParser')
local MGEFParser            = require('custom.saint.record.parser.MGEFParser')
local MISCParser            = require('custom.saint.record.parser.MISCParser')
local NPC_Parser            = require('custom.saint.record.parser.NPC_Parser')
local PGRDParser            = require('custom.saint.record.parser.PGRDParser')
local PROBParser            = require('custom.saint.record.parser.PROBParser')
local RACEParser            = require('custom.saint.record.parser.RACEParser')
local REGNParser            = require('custom.saint.record.parser.REGNParser')
local REPAParser            = require('custom.saint.record.parser.REPAParser')
local SCPTParser            = require('custom.saint.record.parser.SCPTParser')
local SKILParser            = require('custom.saint.record.parser.SKILParser')
local SNDGParser            = require('custom.saint.record.parser.SNDGParser')
local SOUNParser            = require('custom.saint.record.parser.SOUNParser')
local SPELParser            = require('custom.saint.record.parser.SPELParser')
local SSCRParser            = require('custom.saint.record.parser.SSCRParser')
local STATParser            = require('custom.saint.record.parser.STATParser')
local WEAPParser            = require('custom.saint.record.parser.WEAPParser')
local Size                  = require('custom.saint.record.parser.primitive.Size')
local SupportedRecordStores = require('custom.saint.record.SupportedRecordStores')

local logger = SaintLogger:CreateLogger('SaintEspToRecord')
local loadOrderSSS = SaintScriptSave('SaintEspToRecordLoadOrder')

---@alias BINARY string

---@class SaintEspToRecord
local SaintEspToRecord = {}

local Parsers = {
    ['ACTI'] = ACTIParser,
    ['ALCH'] = ALCHParser,
    ['APPA'] = APPAParser,
    ['ARMO'] = ARMOParser,
    ['BODY'] = BODYParser,
    ['BOOK'] = BOOKParser,
    ['BSGN'] = BSGNParser,
    ['CELL'] = CELLParser,
    ['CLAS'] = CLASParser,
    ['CLOT'] = CLOTParser,
    ['CONT'] = CONTParser,
    ['CREA'] = CREAParser,
    ['DIAL'] = DIALParser,
    ['DOOR'] = DOORParser,
    ['ENCH'] = ENCHParser,
    ['FACT'] = FACTParser,
    ['GLOB'] = GLOBParser,
    ['GMST'] = GMSTParser,
    ['INFO'] = INFOParser,
    ['INGR'] = INGRParser,
    ['LAND'] = LANDParser,
    ['LEVC'] = LEVCParser,
    ['LEVI'] = LEVIParser,
    ['LIGH'] = LIGHParser,
    ['LOCK'] = LOCKParser,
    ['LTEX'] = LTEXParser,
    ['MGEF'] = MGEFParser,
    ['MISC'] = MISCParser,
    ['NPC_'] = NPC_Parser,
    ['PGRD'] = PGRDParser,
    ['PROB'] = PROBParser,
    ['RACE'] = RACEParser,
    ['REGN'] = REGNParser,
    ['REPA'] = REPAParser,
    ['SCPT'] = SCPTParser,
    ['SKIL'] = SKILParser,
    ['SNDG'] = SNDGParser,
    ['SOUN'] = SOUNParser,
    ['SPEL'] = SPELParser,
    ['SSCR'] = SSCRParser,
    ['STAT'] = STATParser,
    ['WEAP'] = WEAPParser,

    ['TES3'] = TES3Parser,
}

SaintEspToRecord.ReadEsp = function(filePath, recordHandler)
    local dataFile, err = io.open(filePath, 'rb')
    if err then
        error(err)
    end
    assert(dataFile)
    local binaryData = dataFile:read('*a')
    dataFile:close()
    local binaryStringReader = BinaryStringReader(binaryData);
    while binaryStringReader:HasData() do
        local nextRecordType = binaryStringReader:Peak(Size.INTEGER)
        if not SupportedRecordStores[nextRecordType] then
            logger:Warn('Unsupported record parsed: ( ' .. nextRecordType .. ' )! Will not use data!')
        end
        local record = Parsers[nextRecordType](binaryStringReader)
        recordHandler(record)
    end
end

SaintEspToRecord.GetEspsInFolder = function()
    local fileNames = SaintUtilities.GetFileNamesInFolder(config.dataPath .. '/esp')
    local filteredFileNames = {}
    for _, fileName in pairs(fileNames) do
        if string.match(string.lower(fileName), "%.es[mp]") then
            table.insert(filteredFileNames, fileName)
        end
    end
    return filteredFileNames
end

SaintEspToRecord.CreateLoadOrderForFiles = function()
    local filteredDataFiles = {}
    local dataFiles = SaintEspToRecord.GetEspsInFolder()
    local loadOrder = loadOrderSSS:GetData().loadOrder
    for _, loadOrderFile in ipairs(loadOrder) do
        local foundFile = false

        for _, dataFile in pairs(dataFiles) do
            if string.lower(dataFile) == string.lower(loadOrderFile) then
                foundFile = true
                table.insert(filteredDataFiles, dataFile)
                break
            end
        end

        if foundFile == false then
            error('Failed to find specified data file in load order: ' .. loadOrderFile)
        end
    end
    return filteredDataFiles
end

SaintEspToRecord.Execute = function(handler)
    local fileNames = SaintEspToRecord.CreateLoadOrderForFiles()
    for _, fileName in pairs(fileNames) do
        logger:Verbose('Reading: ' .. fileName)
        SaintEspToRecord.ReadEsp(config.dataPath .. '/esp/' .. fileName, handler)
    end
end

-- SaintEspToRecord.Execute(function(record)
--     print(record.name, record.flags)
-- end)

return SaintEspToRecord
