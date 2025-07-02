# 🐉 Dragon Dungeon — Swift Console Game

A text-based dungeon crawler built in Swift, where you explore a labyrinth, collect items, and search for the Holy Grail — all before your steps run out.

---

## 🚀 Features (MVP)

✅ Procedural maze generation with doors and rooms  
✅ Guaranteed path to key and chest (maze validator)  
✅ Inventory and item interaction: get, drop, eat  
✅ Victory and defeat conditions  
✅ Step counter as life system  
✅ Colorized console output for better UX  
✅ Dark rooms requiring torchlight  
✅ Monsters with reaction-based combat  
✅ Sword and fight mechanic  

---

## 🎮 Console Commands

- `n`, `s`, `e`, `w` — Move North, South, East, West  
- `get [item]` — Pick up an item in the current room  
- `drop [item]` — Drop an item from inventory  
- `eat [item]` — Consume food to restore steps  
- `open` — Open the chest (requires a key)  
- `fight` — Fight a monster (requires a sword)  
- `help` — Display available commands  
- `exit` — Quit the game manually  

> ℹ️ Use `help` at any time to view commands.  
> ⚠️ During monster encounters, act quickly or risk being thrown back and losing steps.

---

## 📂 Project Structure

DragonDungeon/
- ├── Core/ # Low-level types (Position, Direction)
- ├── Domain/ # Models (Player, Room, Items)
- │ └── Items/ # Item implementations: Sword, Food, Torchlight, etc.
- ├── Services/ # MazeValidator and related logic
- ├── Engine/ # Main controller logic (GameEngine, CommandParser)
- ├── UI/ # (Reserved for future CLI improvements)
- └── main.swift # Entry point



---

## 🔧 Tech Stack

- **Language**: Swift 5  
- **Platform**: macOS Terminal  
- **Architecture**: MVC (Model–View–Controller)  
  - `Model`: Player, Room, Items  
  - `View`: Console output  
  - `Controller`: GameEngine  
- **Dependencies**: None

---

## ✨ Possible Next Steps

- 💾 Game saving/loading  
- 🧠 Smarter monster AI  
- 🧪 Unit tests  
- 🎨 ASCII-based map preview

---

## 👨‍💻 Author

Made with ❤️ by [@kanaevbaytik](https://github.com/kanaevbaytik)
