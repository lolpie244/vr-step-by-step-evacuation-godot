<p align="center">
  <h1 align="center">3D editor</h1>
</p>
<p align="center">
	VR STEP-BY-STEP Evacuation
</p>
<details>
<summary>Table of Contents</summary>
	<li><a href="#overview">Overview</a></li>
	<li><a href="#requirements">Requirements</a></li>
	<li><a href="#build">Build</a></li>
</details>

## Overview
https://github.com/user-attachments/assets/abec3222-f376-4e73-aec2-23d4c5b87ab4


STEP-BY-STEP Evacuation is a step-by-step VR game for Meta Quest 3/3s that teaches evacuation procedures. The game consist of three different game modes:

### Map Build
In this game mode, the user can create a map that will be used in other game modes

**Features**:
- The user can draw tiles on the map with pens on a 2D canvas
- The user can place items. To place an item on the map, the user grabs the item, moves their hand with the item over the desired tiles, rotates the hand so that the item faces the desired direction, and presses the trigger to place it
- If the user tries to place a tile where an item exists, the item is removed
- If the user tries to place an item in an unsupported position, the item is not placed
- The user can move or scale the 2D canvas using the provided controls
- The user can also scan a real-life apartment using the Meta Spatial Scanner:
    - Several rooms can be scanned independently. If they are located side by side, all of them are added to the map
    - The scan includes both tiles and furniture items
    - The user can edit the scan in the same way as when creating a map

### Strategic mode
In strategic mode, the user sees the map from above and can move active characters. A character becomes active when:
- a tile in flames is visible
- they are visible to another active character (i.e., an active character informs another one about the fire)
- the fire alarm has been activated

**Features**
- Flames and smoke spread according to the simulation rules:
    - If tile durability < 0, the tile state becomes BURNED and any item placed on that tile is removed
    - If flames spread to a tile with a character, that character dies
    - If any tile of an item starts burning, all tiles of that item start burning
- The user can poke an active character to select it and highlight all reachable tiles
- The user can grab active characters to move them to a reachable tile
- The user can switch to first-person mode for the selected character
- The user can place a character on a tile with an extinguisher to pick it up


### First person
In first-person mode, the user plays as the selected character and sees the map from that character’s point of view

**Extinguish fire**: the user can extinguish fire
Condition: The user is near a tile that is on fire

Steps:
- All fire extinguishers from the character’s inventory are lowered from above on ropes
- The user must tear off a suitable fire extinguisher
- All other extinguishers are lifted back up
- The user must pull out the safety pin, point the hose at the fire, and press the trigger

Edge cases:
- If the user uses an incorrect extinguisher type, the fire strength increases. If fire strength > 1, the fire spreads to all neighboring tiles
- - -

**Open the door**: the user can open the door
Condition: The user is near a closed door

Steps:
- The user must place the back of their hand on the door handle. If the controller vibrates, opening the door is unsafe: there is fire on the other side
- If the controller does not vibrate, the user can safely open the door and immediately leaves first-person mode

Edge cases:
- If the controller vibrates and the user still opens the door, flames spread to the user’s tile
- - -

**Use fire alarm**: the user can use the fire alarm
Condition: The user is near a fire alarm that has not been activated

Steps:
- The user must lift the cover and press the button to activate the fire alarm
- The user leaves first-person mode as soon as the alarm is activated
- After the alarm is activated, all characters on the map become active

## Requirements
* Meta Quest 2/3/3s/Pro
* Godot 4.4+
* Git LFS

## Build
To setup development environment use command:
```bash
make setup
```

To run app use Godot editor - on PC or VR headset directly. To build `.apk` file, follow [official guide](https://docs.godotengine.org/en/4.4/contributing/development/compiling/compiling_for_android.html)
