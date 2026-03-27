#set page(paper: "a4", margin: (x: 2cm, y: 2.5cm))
#set text(font: "PT Sans", size: 11pt)
#set par(justify: true)
#set heading(numbering: "1.1.")
#show raw.where(block: false): it => box(fill: luma(240), inset: (x: 3pt, y: 0pt), outset: (y: 3pt), radius: 2pt)[#it]

#align(center)[
  #text(17pt, weight: "bold")[Phase I Design Document] \
  #v(1em)
  *Course:* COMP 302 - Software Engineering \
  *Group:* International group
]
#v(2em)

= Vision

The vision for *Dungeon KUrawler* is to build a robust, extensible, object-oriented 2D game engine that supports a grid-based dungeon crawler. The primary game mode focuses on exploring randomly generated dungeons, puzzle-solving, combat, and resource management to find a specific hidden "Target Item." Crucially, the system will also feature a secondary "Build Mode" allowing players to design custom levels, emphasizing a modular architecture and high cohesion within the game's mechanics.

= Functional Requirements

== UML Use Case Diagram (Actors & Use Cases)

#figure(
  image("pngs/use_case.png", width: 100%, height: 14cm, fit: "contain"),
  caption: [UML Use Case Diagram],
)

*Primary Actor:* Player \
*Secondary Actor:* Game Loop/Time (System)

- *Session & Level Management:* Start Random Game, Start Custom Game, Load Map, Save Map, Clear Map, Pause/Resume Game, Exit to Main Menu.
- *Editor/Build Mode:* Enter Build Mode, Place Object, Populate Random Items.
- *Hero Actions & Exploration:* Move Hero, Take Item, Search Location, Open Container, Discard Item.
- *Combat & Stats:* View Character Sheet, Equip Weapon, Attack Enemy (Melee), Cast Spell (Ranged), Consume Item.

== Use Case Narratives

*(Below are 10 detailed use case narratives representing the most complex interactions in the system).*

*UC-01: Place Object (Build Mode)*
- *Actor:* Player
- *Precondition:* Player is in Build Mode and the map grid is visible.
- *Main Success Scenario:*
  + Player selects an object (e.g., crate, wall, monster) from the top item palette.
  + Player drags the object over a specific (x, y) tile on the map.
  + Player releases the mouse button to drop the object.
  + System validates that the target tile is empty and passable.
  + System updates the Map data structure to include the new object at (x, y).
  + System renders the object on the grid.
- *Alternative Scenarios:*
  - *4a. Target tile is occupied:* System displays a visual warning (e.g., red highlight) and cancels the placement; the dragged object snaps back to the palette.

*UC-02: Start Random Game (Target Item Objective)*
- *Actor:* Player
- *Precondition:* Player is at the Main Menu.
- *Main Success Scenario:*
  + Player clicks "Start Random Game".
  + System generates a random map layout consisting of static objects (walls, columns).
  + System spawns a fixed number of random items (weapons, potions) on empty floor tiles.
  + System randomly selects a valuable item (e.g., Diamond, Crystal Orb) to act as the Target Item.
  + System selects a random container (e.g., chest) or searchable location (e.g., fountain) on the map.
  + System hides the Target Item inside the selected container/location.
  + System displays a UI prompt showing the Target Item to the player and asks them to find it.
  + Player clicks "Acknowledge" and gameplay begins.

*UC-03: Move Hero*
- *Actor:* Player
- *Precondition:* Game is in Play Mode, Hero is alive.
- *Main Success Scenario:*
  + Player presses a directional arrow key (e.g., North).
  + System calculates the target coordinates (x, y+1).
  + System verifies the target tile is within map bounds and not blocked by a static impassable object (e.g., Wall).
  + System updates the Hero's (x, y) coordinates.
  + System deducts the required movement Energy cost from Hero's stats.
  + System updates the UI to reflect the new position and Energy level.
- *Alternative Scenarios:*
  - *5a. Hero lacks sufficient Energy:* System plays an error sound and Hero remains in place.

*UC-04: Take Item*
- *Actor:* Player
- *Precondition:* Hero is located in the 3x3 grid adjacent to a collectible item.
- *Main Success Scenario:*
  + Player clicks on the collectible item on the ground.
  + System displays an action menu for the item.
  + Player selects "Take [Item Name]".
  + System checks if the Hero's 2x4 Inventory has at least one empty slot.
  + System removes the item from the Map grid.
  + System adds the item to the first available Inventory slot.
  + System closes the action menu and updates the UI.
- *Alternative Scenarios:*
  - *4a. Inventory is full:* System displays the "Take" option as grayed out with a "[Inventory Full]" tag. The action cannot be clicked.

*UC-05: Attack Enemy (Melee)*
- *Actor:* Player
- *Precondition:* Hero has a melee weapon equipped and is adjacent to an Enemy.
- *Main Success Scenario:*
  + Player clicks on an adjacent Enemy (Knight or Sorcerer).
  + System retrieves Hero's STR stat and equipped Weapon's ATK value to compute Base Damage.
  + System retrieves Enemy's DEF stat (including armor modifiers).
  + System calculates Final Damage = Base Damage - Enemy DEF.
  + System reduces Enemy HP by Final Damage.
  + System deducts Energy from the Hero.
  + If Enemy HP <= 0, System removes the Enemy from the Map and rolls for loot drop.

*UC-06: Cast Ranged Spell*
- *Actor:* Player
- *Precondition:* Hero has a Spell Book in inventory and sufficient Mana.
- *Main Success Scenario:*
  + Player opens inventory and clicks the Spell Book.
  + Player selects "READ".
  + System verifies Hero has enough Mana (e.g., >= 10).
  + System deducts Mana and instantiates a magical projectile traveling in the direction the Hero is facing.
  + Projectile travels cell by cell on a timer.
  + Projectile intersects with an Enemy tile.
  + System applies magical damage to the Enemy and destroys the projectile.

*UC-07: Equip Weapon/Armor*
- *Actor:* Player
- *Precondition:* Hero has a weapon/armor item in their Inventory.
- *Main Success Scenario:*
  + Player clicks an equippable item in their Inventory.
  + Player selects "EQUIP" from the action menu.
  + System checks if an item of the same type (Weapon or Armor) is currently equipped.
  + If yes, System automatically unequips the old item (it remains in inventory, status updated).
  + System marks the new item as "Equipped".
  + System recalculates Hero's total ATK or DEF stats and updates the Character Sheet UI.

*UC-08: Open Container with Key*
- *Actor:* Player
- *Precondition:* Hero is adjacent to a locked Chest and possesses the correct Key.
- *Main Success Scenario:*
  + Player clicks the locked Chest.
  + System checks the Hero's inventory for the specific Key associated with this Chest.
  + System displays the action "Open Chest with Key".
  + Player selects the action.
  + System removes the Key from the inventory (if it is a single-use key).
  + System changes Chest state to "Open" and displays its contents in a UI window.
  + Player can click items in the Chest window to move them to the Hero's Inventory.
  + If the Target Item is inside, System triggers the "Game Won" sequence.

*UC-09: Search Hidden Location*
- *Actor:* Player
- *Precondition:* Hero is adjacent to a searchable static object (e.g., fountain, crack in wall).
- *Main Success Scenario:*
  + Player clicks the static object.
  + Player selects "SEARCH" from the action menu.
  + System checks the object's hidden inventory.
  + System deducts Energy for the physical effort of searching.
  + System finds a hidden item.
  + System displays message: "You have found a [Item Name]."
  + System automatically transfers the item to the Hero's inventory (if space permits).
  + If the item is the Target Item, System triggers the "Game Won" sequence.

*UC-10: Enemy AI Turn (Spawn & Move)*
- *Actor:* Game Loop (System)
- *Precondition:* 9 seconds have passed since the last spawn cycle.
- *Main Success Scenario:*
  + System timer triggers the Spawn Event.
  + System checks current total enemy count (must be < 5).
  + System selects a random empty edge tile next to a wall.
  + System generates an enemy (60% Knight, 30% Sorcerer).
  + System places the new enemy on the tile.
  + (Sub-flow Move) For Knights within 5 tiles of the Hero, System calculates pathfinding to the Hero's tile and updates the Knight's (x,y) coordinates by 1 cell.

= Domain Model (Classes)

#figure(
  image("pngs/domain_model.png", width: 100%, height: 12cm, fit: "contain"),
  caption: [Domain Model Class Diagram],
)

+ *GameEngine:* The root controller managing game states (Build/Play), timers, the render loop, map generation, and objective tracking.
+ *Map:* Represents the current dungeon level. Contains a 2D array/grid of `Tile` objects. Handles pathfinding and bounds checking.
+ *Tile:* A single (x, y) coordinate cell on the Map. Can hold a list of `Entity` objects (e.g., one Static Object, multiple Items, one Character).
+ *Character (Abstract):* Base class for `Hero` and `Enemy`. Contains common attributes: `HP`, `STR`, `DEF`, `x_pos`, `y_pos`.
+ *Hero:* Extends `Character`. Adds specific stats (`Mana`, `Energy`) and holds a reference to an `Inventory` object.
+ *Enemy:* Extends `Character`. Subclassed into `Knight` (melee, moves) and `Sorcerer` (ranged, teleports). Contains AI logic methods.
+ *Item (Abstract):* Represents any interactable object. Possesses an `ActionList` and a `Name`.
+ *Weapon:* Extends `Item`. Contains an `ATK` value and an `isEquipped` boolean flag.
+ *Container:* Extends `Item` (or StaticObject). Contains a list of `Item` objects and a boolean `isLocked`.
+ *Action:* Represents interactions (e.g., TakeAction, EatAction, BreakAction). Executes an `Effect` (e.g., HealthRestoreEffect, DamageEffect, WinGameEffect) upon the target or user.

= System Sequence Diagrams (SSDs)

#figure(
  image("pngs/ssd1.png", width: 100%, height: 10cm, fit: "contain"),
  caption: [SSD-1: Place Object (Build Mode)],
)

#figure(
  image("pngs/ssd2.png", width: 100%, height: 10cm, fit: "contain"),
  caption: [SSD-2: Start Random Game],
)

#figure(
  image("pngs/ssd3.png", width: 100%, height: 10cm, fit: "contain"),
  caption: [SSD-3: Move Hero],
)

#figure(
  image("pngs/ssd4.png", width: 100%, height: 10cm, fit: "contain"),
  caption: [SSD-4: Take Item],
)

#figure(
  image("pngs/ssd5.png", width: 100%, height: 10cm, fit: "contain"),
  caption: [SSD-5: Attack Enemy],
)

#figure(
  image("pngs/ssd6.png", width: 100%, height: 10cm, fit: "contain"),
  caption: [SSD-6: Cast Spell],
)

#figure(
  image("pngs/ssd7.png", width: 100%, height: 10cm, fit: "contain"),
  caption: [SSD-7: Equip Weapon],
)

#figure(
  image("pngs/ssd8.png", width: 100%, height: 10cm, fit: "contain"),
  caption: [SSD-8: Open Container],
)

#figure(
  image("pngs/ssd9.png", width: 100%, height: 10cm, fit: "contain"),
  caption: [SSD-9: Search Location],
)

#figure(
  image("pngs/ssd10.png", width: 100%, height: 10cm, fit: "contain"),
  caption: [SSD-10: Enemy Turn (Spawn)],
)
