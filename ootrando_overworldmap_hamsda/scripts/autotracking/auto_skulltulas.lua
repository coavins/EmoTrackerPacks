--[[
======================
===== SKULLTULAS =====
======================

This file handles the killed state of skulltulas, which is stored in its own location in RAM

]]

--Helper method to resolve skulltula lookup location
local function skulltula_scene_to_array_index(i)
  return  (i + 3) - 2 * (i % 4)
end

--NOTE: The Rando LocationList offsets are bit masks not locations, so 0x1 -> 0 offset, 0x2 -> 1 offset, 0x4 -> 2 offset, 0x8 -> 3 offset, etc.
--NOTE:  8-bit array, scene_offsets are filled on [0x00,0x15] but use a lookup array above
local function updateSkulltulaCheck(segment, code, scene_index, bit_index)
  local location = Tracker:FindObjectForCode(code)

  if not location then
    autotracker_debug(string.format('Unable to find location by code: %s', code), DBG_ERROR)
    return
  end

  --For some reason the skulltula array isn't a straight mapping from the scene ID
  local scene_offset = skulltula_scene_to_array_index(scene_index)
  local local_skulltula_offset = ADDR_SKULLTULA_FLAGS + (scene_offset);
  local data = ReadU8(segment, local_skulltula_offset)
  local bitmask = 0x1 << bit_index
  local checked = (data & bitmask ~= 0)

  -- we don't unmark skulltula locations here even though there are no competing reads
  -- this is just to be consistent with the way other checks work
  if checked and not (location.AvailableChestCount == 0) then
    autotracker_debug(string.format('Checked %s', code))
    location.AvailableChestCount = 0
  end
end

local function updateSkulltulaCheckMaybeMQ(segment, dungeonCode, code, codeMQ, scene_index, bit_index)
  if CFG_DUNGEON_IS_MQ[getIntForDungeonRewardCode(dungeonCode)] then
    updateSkulltulaCheck(segment, codeMQ, scene_index, bit_index)
  else
    updateSkulltulaCheck(segment, code, scene_index, bit_index)
  end
end

-- called by memory watch
function updateSkulltulasFromMemorySegment(segment)
  if not HAS_MAP then return true end
  if has('setting_racemode_on') or not AUTOTRACKER_ENABLE_LOCATION_TRACKING or not isInGame() then
    return true
  end

  autotracker_debug('read skulltula data', DBG_DETAIL)

  InvalidateReadCaches()

  -- deku
  updateSkulltulaCheckMaybeMQ(segment, 'deku', '@Deku Tree/GS Basement Back Room' , '@Deku Tree MQ/GS Basement Back Room'   , 0x00,0x0)
  updateSkulltulaCheckMaybeMQ(segment, 'deku', '@Deku Tree/GS Basement Gate'      , '@Deku Tree MQ/GS Lobby'                , 0x00,0x1)
  updateSkulltulaCheckMaybeMQ(segment, 'deku', '@Deku Tree/GS Basement Vines'     , '@Deku Tree MQ/GS Basement Graves Room' , 0x00,0x2)
  updateSkulltulaCheckMaybeMQ(segment, 'deku', '@Deku Tree/GS Compass Room'       , '@Deku Tree MQ/GS Compass Room'         , 0x00,0x3)
  -- dodongos
  updateSkulltulaCheckMaybeMQ(segment, 'dodongo', '@Dodongos Cavern/GS Vines Above Stairs'            , '@Dodongos Cavern MQ/GS Back Area'                , 0x01, 0x0)
  updateSkulltulaCheckMaybeMQ(segment, 'dodongo', '@Dodongos Cavern/GS Scarecrow'                     , '@Dodongos Cavern MQ/GS Scrub Room'               , 0x01, 0x1)
  updateSkulltulaCheckMaybeMQ(segment, 'dodongo', '@Dodongos Cavern/GS Alcove Above Stairs'           , '@Dodongos Cavern MQ/GS Lizalfos Room'            , 0x01, 0x2)
  updateSkulltulaCheckMaybeMQ(segment, 'dodongo', '@Dodongos Cavern/GS Back Room'                     , '@Dodongos Cavern MQ/GS Song of Time Block Room'  , 0x01, 0x3)
  updateSkulltulaCheckMaybeMQ(segment, 'dodongo', '@Dodongos Cavern/GS Side Room Near Lower Lizalfos' , '@Dodongos Cavern MQ/GS Larvae Room'              , 0x01, 0x4)
  -- jabu
  updateSkulltulaCheckMaybeMQ(segment, 'jabu', '@Jabu Jabus Belly/GS Lobby Basement Lower'  , '@Jabu Jabus Belly MQ/GS Boomerang Chest Room'    , 0x02, 0x0)
  updateSkulltulaCheckMaybeMQ(segment, 'jabu', '@Jabu Jabus Belly/GS Lobby Basement Upper'  , '@Jabu Jabus Belly MQ/GS Near Boss'               , 0x02, 0x1)
  updateSkulltulaCheckMaybeMQ(segment, 'jabu', '@Jabu Jabus Belly/GS Near Boss'             , '@Jabu Jabus Belly MQ/GS Tailpasaran Room'        , 0x02, 0x2)
  updateSkulltulaCheckMaybeMQ(segment, 'jabu', '@Jabu Jabus Belly/GS Water Switch Room'     , '@Jabu Jabus Belly MQ/GS Invisible Enemies Room'  , 0x02, 0x3)
  -- forest temple
  updateSkulltulaCheckMaybeMQ(segment, 'forest', '@Forest Temple/GS Raised Island Courtyard'  , '@Forest Temple MQ/GS Raised Island Courtyard'  , 0x03, 0x0)
  updateSkulltulaCheckMaybeMQ(segment, 'forest', '@Forest Temple/GS First Room'               , '@Forest Temple MQ/GS First Hallway'            , 0x03, 0x1)
  updateSkulltulaCheckMaybeMQ(segment, 'forest', '@Forest Temple/GS Level Island Courtyard'   , '@Forest Temple MQ/GS Level Island Courtyard'   , 0x03, 0x2)
  updateSkulltulaCheckMaybeMQ(segment, 'forest', '@Forest Temple/GS Lobby'                    , '@Forest Temple MQ/GS Well'                     , 0x03, 0x3)
  updateSkulltulaCheckMaybeMQ(segment, 'forest', '@Forest Temple/GS Basement'                 , '@Forest Temple MQ/GS Block Push Room'          , 0x03, 0x4)
  -- fire temple
  updateSkulltulaCheckMaybeMQ(segment, 'fire', '@Fire Temple/GS Song of Time Room'  , '@Fire Temple MQ/GS Big Lava Room Open Door'  , 0x04, 0x0)
  updateSkulltulaCheckMaybeMQ(segment, 'fire', '@Fire Temple/GS Boss Key Loop'      , '@Fire Temple MQ/GS Above Fire Wall Maze'     , 0x04, 0x1)
  updateSkulltulaCheckMaybeMQ(segment, 'fire', '@Fire Temple/GS Boulder Maze'       , '@Fire Temple MQ/GS Skull On Fire'            , 0x04, 0x2)
  updateSkulltulaCheckMaybeMQ(segment, 'fire', '@Fire Temple/GS Scarecrow Top'      , '@Fire Temple MQ/GS Fire Wall Maze Center'    , 0x04, 0x3)
  updateSkulltulaCheckMaybeMQ(segment, 'fire', '@Fire Temple/GS Scarecrow Climb'    , '@Fire Temple MQ/GS Fire Wall Maze Side Room' , 0x04, 0x4)
  -- water temple
  updateSkulltulaCheckMaybeMQ(segment, 'water', '@Water Temple/GS Behind Gate'            , '@Water Temple MQ/GS Lizalfos Hallway'          , 0x05, 0x0)
  updateSkulltulaCheckMaybeMQ(segment, 'water', '@Water Temple/GS Falling Platform Room'  , '@Water Temple MQ/GS River'                     , 0x05, 0x1)
  updateSkulltulaCheckMaybeMQ(segment, 'water', '@Water Temple/GS Central Pillar'         , '@Water Temple MQ/GS Before Upper Water Switch' , 0x05, 0x2)
  updateSkulltulaCheckMaybeMQ(segment, 'water', '@Water Temple/GS Near Boss Key Chest'    , '@Water Temple MQ/GS Freestanding Key Area'     , 0x05, 0x3)
  updateSkulltulaCheckMaybeMQ(segment, 'water', '@Water Temple/GS River'                  , '@Water Temple MQ/GS Triple Wall Torch'         , 0x05, 0x4)
  -- spirit temple
  updateSkulltulaCheckMaybeMQ(segment, 'spirit', '@Spirit Temple/GS Hall After Sun Block Room'  , '@Spirit Temple MQ/GS Sun Block Room'               , 0x06, 0x0)
  updateSkulltulaCheckMaybeMQ(segment, 'spirit', '@Spirit Temple/GS Boulder Room'               , '@Spirit Temple MQ/GS Leever Room'                  , 0x06, 0x1)
  updateSkulltulaCheckMaybeMQ(segment, 'spirit', '@Spirit Temple/GS Lobby'                      , '@Spirit Temple MQ/GS Nine Thrones Room West'       , 0x06, 0x2)
  updateSkulltulaCheckMaybeMQ(segment, 'spirit', '@Spirit Temple/GS Sun on Floor Room'          , '@Spirit Temple MQ/GS Symphony Room'                , 0x06, 0x3)
  updateSkulltulaCheckMaybeMQ(segment, 'spirit', '@Spirit Temple/GS Metal Fence'                , '@Spirit Temple MQ/GS Nine Thrones Room North' , 0x06, 0x4)
  -- shadow temple
  updateSkulltulaCheckMaybeMQ(segment, 'shadow', "@Shadow Temple/GS Single Giant Pot"     , "@Shadow Temple MQ/GS Wind Hint Room"       , 0x07, 0x0)
  updateSkulltulaCheckMaybeMQ(segment, 'shadow', "@Shadow Temple/GS Falling Spikes Room"  , "@Shadow Temple MQ/GS Falling Spikes Room"  , 0x07, 0x1)
  updateSkulltulaCheckMaybeMQ(segment, 'shadow', "@Shadow Temple/GS Triple Giant Pot"     , "@Shadow Temple MQ/GS Near Boss"            , 0x07, 0x2)
  updateSkulltulaCheckMaybeMQ(segment, 'shadow', "@Shadow Temple/GS Like Like Room"       , "@Shadow Temple MQ/GS After Wind"           , 0x07, 0x3)
  updateSkulltulaCheckMaybeMQ(segment, 'shadow', "@Shadow Temple/GS Near Ship"            , "@Shadow Temple MQ/GS After Ship"           , 0x07, 0x4)
  -- botw
  updateSkulltulaCheckMaybeMQ(segment, 'botw', '@Bottom of the Well/GS Like Like Cage'  , '@Bottom of the Well MQ/GS Basement'        , 0x08, 0x0)
  updateSkulltulaCheckMaybeMQ(segment, 'botw', '@Bottom of the Well/GS East Inner Room' , '@Bottom of the Well MQ/GS West Inner Room' , 0x08, 0x1)
  updateSkulltulaCheckMaybeMQ(segment, 'botw', '@Bottom of the Well/GS West Inner Room' , '@Bottom of the Well MQ/GS Coffin Room'     , 0x08, 0x2)
  -- ice cavern
  updateSkulltulaCheckMaybeMQ(segment, 'ice', '@Ice Cavern/GS Push Block Room'      , '@Ice Cavern MQ/GS Scarecrow', 0x09, 0x0)
  updateSkulltulaCheckMaybeMQ(segment, 'ice', '@Ice Cavern/GS Spinning Scythe Room' , '@Ice Cavern MQ/GS Red Ice', 0x09, 0x1)
  updateSkulltulaCheckMaybeMQ(segment, 'ice', '@Ice Cavern/GS Heart Piece Room'     , '@Ice Cavern MQ/GS Ice Block', 0x09, 0x2)
  -- hyrule field
  updateSkulltulaCheck(segment, '@HF Cow Grotto/HF GS Cow Grotto'     , 0x0A, 0x0)
  updateSkulltulaCheck(segment, '@HF Near Kak Grotto/HF GS Near Kak Grotto', 0x0A, 0x1)
  -- lon lon ranch
  updateSkulltulaCheck(segment, '@LLR GS/LLR GS Back Wall (N)'   , 0x0B, 0x0)
  updateSkulltulaCheck(segment, '@LLR GS/LLR GS Rain Shed (N)'   , 0x0B, 0x1)
  updateSkulltulaCheck(segment, '@LLR GS/LLR GS House Window (N)', 0x0B, 0x2)
  updateSkulltulaCheck(segment, '@LLR GS/LLR GS Tree'            , 0x0B, 0x3)
  -- kokiri
  updateSkulltulaCheck(segment, '@KF Bean Patch/KF GS Bean Patch'                  , 0x0C, 0x0)
  updateSkulltulaCheck(segment, '@KF Know It All House/KF GS Know It All House (N)', 0x0C, 0x1)
  updateSkulltulaCheck(segment, '@KF House of Twins/KF GS House of Twins (N)'      , 0x0C, 0x2)
  -- lost woods
  updateSkulltulaCheck(segment, '@LW Bean Patch Near Bridge/LW GS Bean Patch Near Bridge'  , 0x0D,0x0)
  updateSkulltulaCheck(segment, '@LW Bean Patch Near Theater/LW GS Bean Patch Near Theater', 0x0D,0x1)
  updateSkulltulaCheck(segment, '@LW Above Theater/LW GS Above Theater (N)'                , 0x0D,0x2)
  -- sacred forest meadow
  updateSkulltulaCheck(segment, '@SFM Maze/SFM GS (N)', 0x0D, 0x3)
  -- market
  updateSkulltulaCheck(segment, '@Market Guard House/Market GS Guard House', 0x0E, 0x3)
  -- castle
  updateSkulltulaCheck(segment, '@HC Storms Grotto/HC GS Storms Grotto', 0x0E, 0x1)
  updateSkulltulaCheck(segment, '@HC Tree/HC GS Tree'                  , 0x0E, 0x2)
  -- ganons castle
  updateSkulltulaCheck(segment, '@OGC/OGC GS', 0x0E, 0x0)
  -- dmt
  updateSkulltulaCheck(segment, "@DMT Bean Patch/DMT GS Bean Patch"                          , 0x0F, 0x1)
  updateSkulltulaCheck(segment, "@DMT Near Kak/DMT GS Near Kak"                              , 0x0F, 0x2)
  updateSkulltulaCheck(segment, "@DMT Above Dodongos Cavern/DMT GS Above Dodongos Cavern (N)", 0x0F, 0x3)
  updateSkulltulaCheck(segment, "@DMT Falling Rocks Path/DMT GS Falling Rocks Path (N)"      , 0x0F, 0x4)
  -- goron city
  updateSkulltulaCheck(segment, '@GC Center Platform/GC GS Center Platform', 0x0F, 0x5)
  updateSkulltulaCheck(segment, "@GC Maze/GC GS Boulder Maze"              , 0x0F, 0x6)
  -- death mountain crater
  updateSkulltulaCheck(segment, '@DMC Bean Patch/DMC GS Bean Patch', 0x0F, 0x0)
  updateSkulltulaCheck(segment, '@DMC Crate/DMC GS Crate'          , 0x0F, 0x7)
  -- kakariko
  updateSkulltulaCheck(segment, '@Kak Child GS/Kak GS Guards House (N)'              , 0x10, 0x1)
  updateSkulltulaCheck(segment, '@Kak Child GS/Kak GS Watchtower (N)'                , 0x10, 0x2)
  updateSkulltulaCheck(segment, '@Kak Child GS/Kak GS House Under Construction (N)'  , 0x10, 0x3)
  updateSkulltulaCheck(segment, '@Kak Child GS/Kak GS Skulltula House (N)'           , 0x10, 0x4)
  updateSkulltulaCheck(segment, '@Kak Child GS/Kak GS Tree (N)'                      , 0x10, 0x5)
  updateSkulltulaCheck(segment, '@Kak Above Impas House/Kak GS Above Impas House (N)', 0x10, 0x6)
  -- graveyard
  updateSkulltulaCheck(segment, '@Graveyard Bean Patch/Graveyard GS Bean Patch', 0x10, 0x0)
  updateSkulltulaCheck(segment, '@Graveyard Wall/Graveyard GS Wall (N)'        , 0x10, 0x7)
  -- river
  updateSkulltulaCheck(segment, '@ZR Ladder/ZR GS Ladder (N)'                          , 0x11, 0x0)
  updateSkulltulaCheck(segment, '@ZR Tree/ZR GS Tree'                                  , 0x11, 0x1)
  updateSkulltulaCheck(segment, '@ZR Above Bridge/ZR GS Above Bridge (N)'              , 0x11, 0x3)
  updateSkulltulaCheck(segment, '@ZR Near Raised Grottos/ZR GS Near Raised Grottos (N)', 0x11, 0x4)
  -- domain
  updateSkulltulaCheck(segment, '@ZD Frozen Waterfall/ZD GS Frozen Waterfall (N)', 0x11, 0x6)
  -- fountain
  updateSkulltulaCheck(segment, '@ZF Above the Log/ZF GS Above the Log (N)', 0x11, 0x2)
  updateSkulltulaCheck(segment, '@ZF Hidden Cave/ZF GS Hidden Cave (N)'    , 0x11, 0x5)
  updateSkulltulaCheck(segment, '@ZF Tree/ZF GS Tree'                      , 0x11, 0x7)
  -- lake hylia
  updateSkulltulaCheck(segment, '@LH Bean Patch/LH GS Bean Patch'        , 0x12, 0x0)
  updateSkulltulaCheck(segment, '@LH Small Island/LH GS Small Island (N)', 0x12, 0x1)
  updateSkulltulaCheck(segment, '@LH Lab Wall/LH GS Lab Wall (N)'        , 0x12, 0x2)
  updateSkulltulaCheck(segment, '@LH Lab/LH GS Lab Crate'                , 0x12, 0x3)
  updateSkulltulaCheck(segment, '@LH Tree/LH GS Tree (N)'                , 0x12, 0x4)
  -- gerudo valley
  updateSkulltulaCheck(segment, '@GV Bean Patch/GV GS Bean Patch'        , 0x13, 0x0)
  updateSkulltulaCheck(segment, '@GV Small Bridge/GV GS Small Bridge (N)', 0x13, 0x1)
  updateSkulltulaCheck(segment, '@GV Pillar/GV GS Pillar (N)'            , 0x13, 0x2)
  updateSkulltulaCheck(segment, '@GV Behind Tent/GV GS Behind Tent (N)'  , 0x13, 0x3)
  -- gerudo fortress
  updateSkulltulaCheck(segment, '@GF Archery Range/GF GS Archery Range (N)', 0x14, 0x0)
  updateSkulltulaCheck(segment, '@GF Top Floor/GF GS Top Floor (N)'        , 0x14, 0x1)
  -- haunted wasteland
  updateSkulltulaCheck(segment, '@Wasteland Structure/Wasteland GS', 0x15, 0x1)
  -- desert colossus
  updateSkulltulaCheck(segment, '@Colossus Bean Patch/Colossus GS Bean Patch', 0x15, 0x0)
  updateSkulltulaCheck(segment, '@Colossus Hill/Colossus GS Hill (N)'        , 0x15, 0x2)
  updateSkulltulaCheck(segment, '@Colossus Tree/Colossus GS Tree (N)'        , 0x15, 0x3)
end
