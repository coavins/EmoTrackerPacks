--[[
===================
===== GLOBALS =====
===================

This file defines most global variables and functions used in the autotracking scripts

]]

function autotracker_started()
  -- Invoked when the auto-tracker is activated/connected
end

function autotracker_debug(str, level)
  if level == nil then level = DBG_NORMAL end
  if AUTOTRACKER_DEBUG_LEVEL >= level then
    print(str)
  end
end

function InvalidateReadCaches()
  U8_READ_CACHE_ADDRESS = 0
  U16_READ_CACHE_ADDRESS = 0
  U32_READ_CACHE_ADDRESS = 0
end

-- The standard read functions should be used whenever possible, to read from the cached
-- memory space supplied during the memory watch callback function
function ReadU8(segment, address)
  if U8_READ_CACHE_ADDRESS ~= address then
    U8_READ_CACHE = segment:ReadUInt8(address)
    U8_READ_CACHE_ADDRESS = address
  end

  return U8_READ_CACHE
end

function ReadU16(segment, address)
  if U16_READ_CACHE_ADDRESS ~= address then
    local cache = segment:ReadUInt16(address) -- returns little endian
    -- put it in big endian
    U16_READ_CACHE = 0
    U16_READ_CACHE = U16_READ_CACHE + ((cache & 0x00FF) << 8);
    U16_READ_CACHE = U16_READ_CACHE + ((cache & 0xFF00) >> 8);
    U16_READ_CACHE_ADDRESS = address
  end

  return U16_READ_CACHE
end

function ReadU32(segment, address)
  if U32_READ_CACHE_ADDRESS ~= address then
    local cache = segment:ReadUInt16(address+0x2) * 0x10000 + segment:ReadUInt16(address) -- returns little endian
    -- put it in big endian
    U32_READ_CACHE = 0
    U32_READ_CACHE = U32_READ_CACHE + ((cache & 0x000000FF) << 24);
    U32_READ_CACHE = U32_READ_CACHE + ((cache & 0xFF000000) >> 24);
    U32_READ_CACHE = U32_READ_CACHE + ((cache & 0x0000FF00) << 8);
    U32_READ_CACHE = U32_READ_CACHE + ((cache & 0x00FF0000) >> 8);
    U32_READ_CACHE_ADDRESS = address
  end

  return U32_READ_CACHE
end

-- The live read functions should be used only when absolutely necessary, when you have
-- to read some memory address outside of what is provided by the memory watch
function LiveReadU8(address)
  return AutoTracker:ReadU8(address)
end

function LiveReadU16(address)
  return AutoTracker:ReadU16(address) -- returns big endian
end

-- WARNING: this operation is not atomic
function LiveReadU32(address)
  return LiveReadU16(address) * 0x10000 + LiveReadU16(address+0x2)
end

-- Should return true if the information currently stored in RAM should be used
-- to update the tracker. Return false on title screen, etc.
function isInGame()
  --[[ 8011B92C is game mode:     8011A5EC is validation string:
      0 is normal gameplay        reads ZELDAZ if a file is loaded
      1 is title screen
      2 is file select
      3 is horseback game     ]]
  local gameMode = AutoTracker:ReadU8(0x8011B92F)
  -- game mode indicates normal play
  if gameMode ~= 0 and gameMode ~= 3 then
    return false
  -- validation string is not present, no file is loaded
  elseif AutoTracker:ReadU8(0x8011A5EC) == 0 then
    return false
  -- we must be in game, so RAM is safe to read
  else
    return true
  end
end

function getMedallionStageForDungeonReward(value)
  local stage = 1
  if (value < 3) then
    stage = 2
  elseif (value == 3) then
    stage = 3
  elseif (value == 4 or value == 5) then
    stage = 4
  elseif (value == 6 or value == 7) then
    stage = 5
  elseif (value == 8) then
    stage = 6
  end
  return stage
end

function getIntForDungeonRewardCode(code)
  local currentStage = 1
  if     code == "deku"     then currentStage = 1 
  elseif code == "dodongo"  then currentStage = 2
  elseif code == "jabu"     then currentStage = 3
  elseif code == "forest"   then currentStage = 4
  elseif code == "fire"     then currentStage = 5
  elseif code == "water"    then currentStage = 6
  elseif code == "shadow"   then currentStage = 8
  elseif code == "spirit"   then currentStage = 7
  elseif code == "botw"     then currentStage = 9
  elseif code == "ice"      then currentStage = 10
  elseif code == "free"     then currentStage = 11
  elseif code == "hideout"  then currentStage = 12
  elseif code == "gtg"      then currentStage = 13
  elseif code == "ganon"    then currentStage = 14
  end
  return currentStage
end

function getIntForSceneIndex(scene_index)
  local currentStage = 1
  if     scene_index == 0x00  then currentStage = 1 
  elseif scene_index == 0x01  then currentStage = 2
  elseif scene_index == 0x02  then currentStage = 3
  elseif scene_index == 0x03  then currentStage = 4
  elseif scene_index == 0x04  then currentStage = 5
  elseif scene_index == 0x05  then currentStage = 6
  elseif scene_index == 0x06  then currentStage = 7
  elseif scene_index == 0x07  then currentStage = 8
  elseif scene_index == 0x08  then currentStage = 9
  elseif scene_index == 0x09  then currentStage = 10
  elseif scene_index == 0x0A  then currentStage = 11
  elseif scene_index == 0x0B  then currentStage = 12
  elseif scene_index == 0x0C  then currentStage = 13
  elseif scene_index == 0x0D  then currentStage = 14
  end
  return currentStage
end

function resetGlobalVariables()
  DBG_ERROR  = 0
  DBG_NORMAL = 1
  DBG_DETAIL = 2
  AUTOTRACKER_DEBUG_LEVEL = DBG_ERROR

  U8_READ_CACHE = 0
  U8_READ_CACHE_ADDRESS = 0

  U16_READ_CACHE = 0
  U16_READ_CACHE_ADDRESS = 0

  U32_READ_CACHE = 0
  U32_READ_CACHE_ADDRESS = 0

  SCENE_SIZE = 0x1C

  -- Global context addresses
  ADDR_CURRENT_SCENE_INDEX      = 0x801C8544 -- u16
  ADDR_CURRENT_SWITCH_FLAGS     = 0x801CA1C8 -- u32
  ADDR_CURRENT_CHEST_FLAGS      = 0x801CA1D8 -- u32
  ADDR_CURRENT_COLLECTION_FLAGS = 0x801CA1E4 -- u32

  -- Save context addresses
  ADDR_SAVE_CONTEXT = 0x8011A5D0
  ADDR_BIGGORON_SAVED  = ADDR_SAVE_CONTEXT + 0x072 --0x11A642
  ADDR_SCENE_FLAGS     = ADDR_SAVE_CONTEXT + 0x0D4 --0x11A6A4
  ADDR_SHOP_CONTEXT    = ADDR_SAVE_CONTEXT + 0x5B4 --0x11AB84
  ADDR_TRIFORCE_PIECES = ADDR_SCENE_FLAGS  + SCENE_SIZE * 0x48 + 0x10 -- 0x11AE94
  ADDR_SKULLTULA_FLAGS = ADDR_SAVE_CONTEXT + 0xE9C --0x11B46C
  ADDR_BIGPOE_POINTS   = ADDR_SAVE_CONTEXT + 0xEBC --0x11B48C
  ADDR_FISHING_CONTEXT = ADDR_SAVE_CONTEXT + 0xEC0 --0x11B490
  ADDR_EVENT_CONTEXT   = ADDR_SAVE_CONTEXT + 0xED4 --0x11B4A4
  ADDR_ITEM_GET_INF    = ADDR_SAVE_CONTEXT + 0xEF0 --0x11B4C0
  ADDR_INF_TABLE       = ADDR_SAVE_CONTEXT + 0xEF8 --0x11B4C8

  -- Autotracker context address
  -- This address is discovered during runtime at address 0x8040000C
  ADDR_AUTOTRACKER_CONTEXT = 0x0

  -- State variables to help keep track of some things
  KING_ZORA_MOVED = false
  HAS_RUTO_BOTTLE = false

  CHICKEN_SHOWN_TO_TALON = false
  LETTER_SHOWN_TO_GUARD  = false
  SOLD_MASK_KEATON     = false
  SOLD_MASK_SKULL      = false
  SOLD_MASK_SPOOKY     = false
  SOLD_MASK_BUNNY      = false
  EARNED_MASK_OF_TRUTH = false

  -- cache for held key and unlocked door counts, used to ensure accurate key count for keysanity
  KEY_CACHE = {}
  KEY_CACHE['forestsmall'] = {held=0, used=0}
  KEY_CACHE['firesmall']   = {held=0, used=0}
  KEY_CACHE['watersmall']  = {held=0, used=0}
  KEY_CACHE['shadowsmall'] = {held=0, used=0}
  KEY_CACHE['spiritsmall'] = {held=0, used=0}
  KEY_CACHE['gcsmall']     = {held=0, used=0}
  KEY_CACHE['gtgsmall']    = {held=0, used=0}
  KEY_CACHE['thsmall']     = {held=0, used=0}
  KEY_CACHE['botwsmall']   = {held=0, used=0}

  -- array of beans that were planted, used to ensure accurate bean count in inventory
  BEANS_USED = {}

  CFG_DUNGEON_REWARDS= {
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  14,
  }

  CFG_DUNGEON_IS_MQ= {
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  }

end

resetGlobalVariables()
