# 🐉 Dragon Dungeon — Swift Console Game

A text-based dungeon crawler built entirely in Swift using clean MVVM architecture. You explore a labyrinth, collect items, and search for the Holy Grail — all before your steps run out.

---

## 🚀 Features (MVP)

* ✅ Procedural maze generation with doors and rooms
* ✅ Guaranteed path to key and chest (maze validator)
* ✅ Item interaction: get, drop, eat
* ✅ Inventory management
* ✅ Victory and defeat conditions
* ✅ Step counter as "life system"
* ✅ Clean MVVM architecture + SOLID principles

---

## 🎮 Commands (via console input)

* `n`, `s`, `e`, `w` — move North, South, East, West
* `get [item]` — pick up item in the current room
* `drop [item]` — remove item from inventory into the room
* `eat [item]` — consume food to restore steps
* `open` — open the chest (only if you have the key)
* `help` — display the list of available commands

---

## 📂 Project Structure

```
DragonDungeon/
├── Core/                # Low-level types (Position, Direction)
├── Domain/              # Models (Player, Room, Items)
│   └── Items/           # Individual item types
├── Services/            # MazeValidator, etc.
├── Engine/              # Game logic (GameEngine, CommandParser)
├── UI/                  # Console IO layer (coming soon)
└── main.swift           # Entry point
```

---

## 🔧 Tech

* Language: **Swift 5**
* Platform: **Console (macOS Terminal)**
* Architecture: **MVVM**
* Dependencies: **Zero external libraries**

---

## 📌 Upcoming Features

* [ ] 🧟 Monsters and fight logic
* [ ] 🔦 Dark rooms and torchlight
* [ ] ⏱ Timer-based enemy reactions
* [ ] 🎨 Colorized console output (ANSI)
* [ ] ⚔️ Sword and `fight` command
* [ ] 💾 Game saving (stretch goal)

---

## 👨‍💻 Author

Made with ❤️ by [@kanaevbaytik](https://github.com/kanaevbaytik)
