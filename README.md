# Hamsda's OOT pack + Autotracking

### [Download latest version](https://github.com/coavins/EmoTrackerPacks/releases)

![Base version](https://img.shields.io/badge/base-v3.7.2.0-blue)
![Autotracker version](https://img.shields.io/badge/auto-v2-red)
![Test Status](https://github.com/coavins/EmoTrackerPacks/workflows/tests/badge.svg)

## About this fork

This fork adds autotracking functionality to [Hamsda's EmoTracker pack](https://github.com/Hamsda/EmoTrackerPacks) for OOT Randomizer. Please refer to the [upstream repository](https://github.com/Hamsda/EmoTrackerPacks) or [pack README](ootrando_overworldmap_hamsda/README.md) if you have any questions regarding the usage or behavior of the standard tracker features.

There is an **[active pull request](https://github.com/Hamsda/EmoTrackerPacks/pull/123)** to officially merge this work into Hamsda's pack. Please show support by giving it a 👍 if you want to see this happen!

This repo accepts pull requests! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for more information.

Huge thanks to [RiptideSage](https://github.com/RiptideSage) for making this project possible.

## Supported versions

This pack was tested and known to work with the following software:

- EmoTracker 2.3.8.16
- BizHawk 2.3 through 2.8
- BizHawk Connector: https://github.com/coavins/bizhawk-connector
- Compatible with Archipelago (Ocarina of Time Client 0.3.1)

## Contact

If you encounter a problem with the autotracker, please create an issue in this repository or reach out to me via email or Matrix chat with the addresses on my profile.

If you're having trouble with basic use of the tracker in general, you might want to check out the [upstream repository](https://github.com/Hamsda/EmoTrackerPacks).

# Usage

When starting a new game, you should make sure that your tracker settings are configured correctly _before_ you connect to the emulator, as the autotracker will immediately start making changes based on your active settings. The autotracker can also be used with a file you already started playing; it will catch up and mark off all items and cleared checks.

## Things that are autotracked:

### Checks

- Inventory items
- Quest items
- Locations checked
- Dungeon bosses defeated
- Trade sequence progress
- Keys found (for keysanity variants)
- Beans planted

### Settings

- Free scarecrow's song

## Things that are NOT yet tracked:

- Master Quest dungeon checks
- Which prize is awarded by each dungeon
- Whether the scarecrow's song is available
- Captures for spawn and entrance randomizer
- At which song location each song was received

# Install

To manually install or update this pack, download [the latest release](https://github.com/coavins/EmoTrackerPacks/releases) and put the zip file into your EmoTracker packs directory:

`C:\Users\coavins\Documents\EmoTracker\packs`

You don't have to extract the zip. When EmoTracker is reloaded, this pack should appear under "Installed Packages" with (Autotracker) in the name.

# Connect to Bizhawk

## Activate autotracker in EmoTracker

To activate the autotracker, right-click the robot icon in the lower right corner of EmoTracker and choose "SNES", then "Lua". When the robot turns red or yellow, it is ready.

* Note: You should make sure that your tracker settings are configured correctly before you connect to the emulator.

## Load connector script in BizHawk

Download the [bizhawk-connector](https://github.com/coavins/bizhawk-connector/releases) script and extract it anywhere. In BizHawk, after your ROM is loaded, go to `Tools > Lua Console`. In the new window, go to `Script > Open Script` and navigate to the `connector.lua` file where you downloaded it.

EmoTracker also includes an older copy of this file under the following path:

`C:\Program Files (x86)\EmoTracker\Connectors\bizhawk\connector.lua`

When the connector.lua script is started, the connection should be established and you should see the robot icon in EmoTracker turn green. After a short delay, autotracking will begin. Items and checks will be marked as soon as you receive them in-game.

## Racing

The autotracker will only function when racing mode is disabled.

![Casual](ootrando_overworldmap_hamsda/images/setting_racemode_off.png "Casual") When this setting is displayed, the autotracker will operate normally.

**Please be mindful of the rules when joining races.** Using an autotracker in a race where they are not permitted would be cheating. Always remember to check the rules to confirm that your tracker is allowed before using it in any race, even if you don't intend to use autotracking.

This pack can only mark off items after they are received, and checks after they have been checked. It cannot be used to reveal information that is not already known to the player, including where items are hidden or what random settings have been applied.

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
