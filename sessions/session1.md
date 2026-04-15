# Session 1 — Welcome to GameMaker!
### *Building an Among Us clone — Part 1 of 4*
**Duration:** ~75 minutes | **Who:** Total beginners (age ~10)

---

## What we're making 🚀
You're going to build your own version of **Among Us** — a top-down game where you sneak around a spaceship, complete tasks, and eliminate the crew. By session 4 you'll have a playable game you made yourself!

---

## Schedule

| Time | Activity |
|------|----------|
| 0:00 – 0:10 | What is GameMaker? |
| 0:10 – 0:20 | Install GameMaker + create account |
| 0:20 – 0:30 | Create a new project + import sprites |
| 0:30 – 0:45 | Tour of the GameMaker IDE |
| 0:45 – 0:65 | Set up the room (ship + layers) |
| 0:65 – 0:75 | Press Play + celebrate |

---

## Part 1 — What is GameMaker? (10 min)

GameMaker is a game engine — a program that helps you make games. It uses a language called **GML (GameMaker Language)**.

Some games made with GameMaker you might know:
- **Undertale**
- **Hotline Miami**
- **Spelunky**

In GameMaker, everything is built from these basic pieces:

| Piece | What it is |
|-------|-----------|
| **Sprite** | A picture (like a character drawing) |
| **Object** | A "thing" in your game — it has code that makes it DO stuff |
| **Room** | A level or screen in your game |
| **Tileset** | A sheet of small tiles used to paint walls and floors |

---

## Part 2 — Install GameMaker (10 min)

1. Open a browser and go to: **https://gamemaker.io**
2. Click **Download** → choose the version for your OS (Windows or Mac)
3. Install it like any normal program
4. When it opens, **create a free account** (you can use a made-up email if you need to)
5. Log in — you're ready!

> **Note for the teacher:** The free tier of GameMaker 2024 is fully featured for 2D games. No purchase needed.

---

## Part 3 — Create a New Project + Import Sprites (10 min)

Instead of downloading a pre-made project, you'll build everything yourself. The teacher has uploaded all the artwork to GitHub so you can grab just the images you need.

### Step 3.1 — Create a new project
1. In GameMaker, click **New Project**
2. Choose **GameMaker Language (GML)**
3. Name it something like `AmongUs` and save it somewhere easy to find (e.g. your Desktop)

GameMaker creates an empty project with one blank room — perfect.

### Step 3.2 — Download the sprite images
1. Go to the GitHub link your teacher gives you
2. Open the **`sprites/`** folder — you'll see image files like `the_skeld.png`, `spr_player_idle_down.png`, etc.
3. Click each image you need → click the **Download raw file** button (or right-click → Save image as)
4. Save them all into one folder, e.g. `Desktop/AmongUsAssets/`

> **Sprite images to download for today:**
> - `the_skeld.png` — the spaceship background
> - `spr_player_idle_down.png`, `spr_player_idle_up.png`, `spr_player_idle_left.png`, `spr_player_idle_right.png`
> - `spr_player_walk_down.png`, `spr_player_walk_up.png`, `spr_player_walk_left.png`, `spr_player_walk_right.png`
> - `spr_tileset.png` — the wall tiles

### Step 3.3 — Import sprites into GameMaker
For each image file:
1. In the **Asset Browser**, right-click **Sprites** → **Create Sprite**
2. Click **Import** → find the PNG file → click Open
3. Rename the sprite to match the file name (e.g. `the_skeld`, `spr_player_idle_down`)

> **Tip:** Name them exactly as shown above — the code we write later will refer to them by name.

More sprites will be added in later sessions as we need them.

---

## Part 4 — Tour of the IDE (15 min)

When the project loads, you'll see lots of panels. Let's learn what they all do.

```
┌─────────────────────────────────────────────────────────┐
│  MENU BAR  (File, Edit, Build...)                       │
├──────────────┬──────────────────────────┬───────────────┤
│              │                          │               │
│  ASSET       │   WORKSPACE              │  INSPECTOR    │
│  BROWSER     │   (room editor /         │  (properties  │
│              │    code editor goes here)│   of selected │
│  All your    │                          │   thing)      │
│  sprites,    │                          │               │
│  objects,    │                          │               │
│  rooms...    │                          │               │
└──────────────┴──────────────────────────┴───────────────┘
```

### Key things to click on and explore:
- **Asset Browser** (left panel) — double-click `Room1` to open the room editor
- **Room Editor** — the big canvas where you lay out everything
- Double-click **`spr_player_idle_down`** in Asset Browser → see the player sprite you just imported!

> **Challenge:** Double-click the `the_skeld` sprite. What do you see? How big is it in pixels?

---

## Part 5 — Set Up the Room (20 min)

Now for the fun part — building the spaceship level!

### Step 5.1 — Open Room1
In the Asset Browser, double-click **Room1**. The Room Editor opens in the workspace.

### Step 5.2 — Set the room size
In the Inspector on the right, look for **Room Settings**:
- Set **Width** to `1280`
- Set **Height** to `720`

### Step 5.3 — Add the ship background
In the Room Editor, look at the **Layers** panel. You'll see a list of layers (like layers in Photoshop).

1. Click the **+** button to add a **Background layer**
2. Name it `Background`
3. In the Inspector, click **Sprite** and choose `the_skeld` (the Among Us ship image)
4. Make sure **Stretch** is turned ON so it fills the whole room

You should now see the spaceship map as your background! 🚀

### Step 5.4 — Check the wall tile layer
Layers are like transparent sheets stacked on top of each other. The collision walls need their own special layer.

In the Layers panel, look for a layer called **`mur`** (French for "wall" — don't worry about the name!).

- If it's there: great, click on it to select it
- If it's missing: click **+** → **Tile Layer** → name it `mur` → set the tileset to `TileSet1`

### Step 5.5 — Paint some walls (optional, but cool)
With the `mur` layer selected:
1. Select the **Tile Brush** tool (pencil icon)
2. Pick a wall tile from the tileset palette at the bottom
3. Paint over the walls of the ship in your background image

This tells GameMaker "these spots are solid walls — the player can't walk through them."

> **Tip:** You don't need to be pixel-perfect. Just block off the big walls.

### Step 5.6 — Add the player to the room
1. In the Layers panel, select the **Instances** layer (or create one with **+** → **Instance Layer**)
2. In the Asset Browser, find **JackVenomTank** (this is your player object)
3. Drag it from the Asset Browser into the middle of the room on the map

You should see a little character icon placed in your room!

---

## Part 6 — Press Play! (10 min)

Click the **▶ Play** button at the top (or press `F5`).

GameMaker will compile your project and a window should pop up. Try pressing:
- **W A S D** to move
- **Space** to attack

> If it doesn't work, check: Is the player object placed in the room? Is the `mur` layer named correctly?

---

## Summary — What you built today ✅

- [x] Installed GameMaker and created your own project from scratch
- [x] Downloaded sprite images from GitHub and imported them
- [x] Explored the IDE (Asset Browser, Room Editor, Inspector)
- [x] Set a spaceship background in Room1
- [x] Understood layers (background, tile walls, instances)
- [x] Placed the player and ran the game

## Homework / Bonus Challenge 🌟
- Try changing the **room size** to `2560 x 1440` and see what happens
- Download `spr_npc1.png` from GitHub and import it — what does it look like?
- Can you add a **second copy** of `JackVenomTank` to the room? What happens when you press Play?

---

## Coming up in Session 2...
You'll make the player move AND look in the right direction, add a camera that follows you, and add crewmates that wander around the ship. Then... you'll learn how to **eliminate them**. 😈
