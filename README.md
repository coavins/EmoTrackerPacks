# Hamsda's OOT pack + Autotracking

![Hamsda version](https://img.shields.io/badge/base-3.6.0.0-blue)
![Test Status](https://github.com/coavins/EmoTrackerPacks/workflows/tests/badge.svg)

This fork introduces autotracking functionality to the OOT map and item tracker maintained by [Hamsda](https://github.com/Hamsda) for [EmoTracker](https://emotracker.net/). Please refer to the [upstream repository](https://github.com/Hamsda/EmoTrackerPacks) or [pack README](ootrando_overworldmap_hamsda/README.md) for any questions regarding the usage or behavior of the standard tracker features.

There is an **[active pull request](https://github.com/Hamsda/EmoTrackerPacks/pull/123)** to officially merge this work into Hamsda's pack. Please show support by giving it a 👍 if you want to see this happen!

Huge thanks to [RiptideSage](https://github.com/RiptideSage) for making this project possible.

## Contact

If you encounter a problem with the autotracker, please create an issue in this repository or reach out to me via email or Matrix chat with the addresses on my profile.

If you are having trouble with basic use of the tracker in general, you might want to check out the [upstream repository](https://github.com/Hamsda/EmoTrackerPacks).

# Usage

When starting a new game, you should make sure that your tracker settings are configured correctly _before_ you connect to the emulator, as the autotracker will immediately start making changes based on your active settings. The autotracker can also be used with a file you already started playing; it will catch up and mark off all items and cleared checks.

### Things that are currently autotracked:

- Inventory items
- Quest items
- Locations checked
- Dungeon bosses defeated
- Trade sequence progress
- Keys received (for keysanity variants)
- Beans planted

### Things that are NOT autotracked:

- Master Quest dungeon checks
- Which prize is awarded by each dungeon
- Whether the scarecrow's song is available
- Captures for spawn and entrance randomizer
- At which song location each song was received

## Manual install

To manually install or update this pack, simply copy [the zip file](https://github.com/coavins/EmoTrackerPacks/raw/master/ootrando_overworldmap_hamsda_coavins.zip) into your EmoTracker packs directory. For me, this was in my Users folder:

`C:\Users\coavins\Documents\EmoTracker\packs`

When EmoTracker is reloaded, it should appear under "Installed Packages" alongside Hamsda's pack, with (Autotracker) in the name.

## Connect to Bizhawk

In order to use the autotracker, you will first need to turn off race mode in the settings.

![Fun](ootrando_overworldmap_hamsda/images/setting_racemode_off.png "Fun"): When this setting is used, the autotracker will operate normally.

![Race](ootrando_overworldmap_hamsda/images/setting_racemode_on.png "Race"): When this setting is used, the autotracker will not take any action even after it's connected.

To activate the autotracker, right-click the robot icon in the lower right corner and choose "SNES", then "Lua". When the robot turns red or yellow, it is ready and waiting for you to start the connector.lua script in Bizhawk. For me, this was under Program files:

`C:\Program Files (x86)\EmoTracker\Connectors\bizhawk\connector.lua`

When the connector.lua script is started, the connection should be established and you should see the robot icon in EmoTracker turn green. After a short delay, autotracking will begin. Items and checks will be marked off as soon as you receive them in-game.

## Racing

**Please be mindful of the rules when joining races.** If you use an autotracker in a race where they are not permitted, even by accident, you would be cheating. Always remember to double check the rules to ensure autotracking is allowed before using it in a race. Race mode is enabled by default in the tracker to help remind you of this.

This pack can only mark off items after they are received, and checks after they have been checked. It cannot be used to reveal information that is not already known to the player, including where items are hidden or what random settings have been applied.

## Supported versions

This pack was tested and known to work with the following software:

- EmoTracker 2.3.8.14
- The connector.lua included with EmoTracker 2.3.8.14
- BizHawk 2.3.0 (x64) commit af9d1db
- Archipelago 0.1.9
- Archipelago Z5Client 0.12.0

## Special thanks

Thanks to [RiptideSage](https://github.com/RiptideSage/OoT-CompletedChecks) who saved me weeks of hunting down scene flags. This project was only possible because I could follow in your footsteps.

Thanks to [codemann8](https://github.com/codemann8/alttpr_codetracker_codemann8), whose LTTP pack showed me how to write scripts for EmoTracker.

I also heavily referenced the following OOT resources during development. Maybe they will be useful to you too.

- https://docs.google.com/spreadsheets/d/1lh8JcUcuXg7GR4DTWMhmfk42Y0H6nJvUg-zRn8-8bPk
- https://tcrf.net/Proto:The_Legend_of_Zelda:_Ocarina_of_Time_Master_Quest/Event_Editor
- https://wiki.cloudmodding.com/oot/Save_Format
- https://wiki.cloudmodding.com/oot/Scene_Table/NTSC_1.0
- https://github.com/aliblong/zootr-autotracker
- https://cloudmodding.com/zelda/oot
- https://wiki.ootrandomizer.com/index.php?title=Editing_RAM
