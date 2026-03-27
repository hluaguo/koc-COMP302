
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

