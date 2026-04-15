# Session 4 — Win Conditions, Sound & Polish
### *Building an Among Us clone — Part 4 of 4*
**Duration:** ~75 minutes | **Prerequisites:** Sessions 1–3 complete

---

## What we're building today 🏆

| Feature | What it does |
|---------|-------------|
| **Task progress bar** | Shows how close crewmates are to winning |
| **Win / Lose screen** | Game ends with a result screen |
| **Sound effects** | Kill sound, task complete ding, win/lose music |
| **Polish pass** | Small tweaks to make it feel nicer |
| **Show & tell** | Play each other's games! |

---

## Schedule

| Time | Activity |
|------|----------|
| 0:00 – 0:05 | Quick recap |
| 0:05 – 0:25 | Task progress bar |
| 0:25 – 0:45 | Win / Lose condition + result screen |
| 0:45 – 0:58 | Sound effects |
| 0:58 – 0:75 | Polish suggestions + play each other's games |

---

## Part 1 — Quick Recap (5 min)

Last session you built 3 task objects and tracked progress with `global.tasks_done`.

Quick check:
- What does `global.` do? *(Shares a variable across ALL objects)*
- How does the asteroid task know you clicked an asteroid? *(Left Released mouse event on `obj_asteroid`)*

---

## Part 2 — Task Progress Bar (20 min)

We want a big bar at the top of the screen showing how many tasks are done. This is one of the most iconic Among Us UI elements!

### Step 2.1 — Create a HUD controller object

We'll make a single "manager" object that handles all on-screen text and win/lose logic.

Right-click in Asset Browser → **Create** → **Object** → name it **`obj_hud`**.
**No sprite needed.**

> **Important:** This object only needs to be placed **once** in Room1. It won't draw in the game world, only on the HUD.

### Step 2.2 — Create event

```gml
game_over       = false;
crew_wins       = false;
result_timer    = 0;    // counts down before returning to start

// We need at least 1 crewmate alive at game start — counted here
crewmates_start = instance_count(fjenne_far);
```

### Step 2.3 — Step event

```gml
if (game_over) {
    result_timer++;
    // After 5 seconds on result screen, restart the game
    if (result_timer > 300)
        game_restart();
    exit;
}

// --- CHECK WIN CONDITIONS ---

// Crew wins: all tasks done
if (global.tasks_done >= global.tasks_total)
{
    game_over  = true;
    crew_wins  = true;
    exit;
}

// Impostor wins: no crewmates left alive
if (instance_count(fjenne_far) == 0 && crewmates_start > 0)
{
    game_over = true;
    crew_wins = false;
}
```

### Step 2.4 — Draw GUI event

```gml
// ---- RESULT SCREEN ----
if (game_over)
{
    // Semi-transparent dark overlay
    draw_set_alpha(0.7);
    draw_set_colour(c_black);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);
    
    if (crew_wins)
    {
        draw_set_colour(c_lime);
        draw_set_font(-1);
        draw_text_transformed(display_get_gui_width() / 2 - 150, display_get_gui_height() / 2 - 30,
            "CREWMATES WIN!", 1, 1, 0);
        draw_set_colour(c_white);
        draw_text(display_get_gui_width() / 2 - 120, display_get_gui_height() / 2 + 30,
            "All tasks complete!");
    }
    else
    {
        draw_set_colour(c_red);
        draw_text_transformed(display_get_gui_width() / 2 - 150, display_get_gui_height() / 2 - 30,
            "IMPOSTOR WINS!", 1, 1, 0);
        draw_set_colour(c_white);
        draw_text(display_get_gui_width() / 2 - 100, display_get_gui_height() / 2 + 30,
            "All crewmates eliminated!");
    }
    exit;
}

// ---- TASK PROGRESS BAR (top of screen) ----
var _bar_x      = 20;
var _bar_y      = 10;
var _bar_length = display_get_gui_width() - 40;
var _bar_h      = 18;
var _progress   = global.tasks_done / global.tasks_total;

// Background
draw_set_colour(c_black);
draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_length, _bar_y + _bar_h, false);

// Fill
draw_set_colour(c_lime);
draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_length * _progress, _bar_y + _bar_h, false);

// Outline
draw_set_colour(c_white);
draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_length, _bar_y + _bar_h, true);

// Label
draw_set_colour(c_white);
draw_text(_bar_x + 5, _bar_y + 1,
    "Tasks: " + string(global.tasks_done) + " / " + string(global.tasks_total));
```

### Step 2.5 — Place in room
Drag **one copy** of `obj_hud` anywhere in Room1 (its position doesn't matter since everything is drawn on the GUI layer).

Press **Play** — you should see the progress bar at the top. Complete tasks to see it fill up!

---

## Part 3 — Win / Lose Screens (20 min)

The win/lose screen is already in the Draw GUI code above. Let's make it look better and test both outcomes.

### Step 3.1 — Test Crew Win
Press Play and complete all 3 tasks. The green "CREWMATES WIN!" screen should appear.

### Step 3.2 — Test Impostor Win
Press Play and kill all the crewmates (press **E** near each one). When the last crewmate is gone, the red screen appears.

> **Tip:** If you only have 2 crewmates in the room right now, killling is too easy. Add more `fjenne_far` objects in Room1 to make it harder.

### Step 3.3 — Add a countdown text (optional)
In the result screen section of Draw GUI, add below the win/lose message:

```gml
var _seconds_left = 5 - (result_timer div 60);
draw_set_colour(c_ltgrey);
draw_text(display_get_gui_width() / 2 - 80, display_get_gui_height() / 2 + 70,
    "Restarting in " + string(_seconds_left) + "...");
```

---

## Part 4 — Sound Effects (13 min)

Sound makes games feel alive. Let's add:
1. A **kill sound** when you eliminate a crewmate
2. A **task complete sound** when a task is finished
3. A **win/lose sound** on the result screen

### Step 4.1 — Import a sound

GameMaker comes with no built-in sounds, but you can use free sound effects:

1. Go to **freesound.org** (or your teacher has pre-downloaded some `.wav` / `.mp3` files)
2. Drag a sound file onto the **Asset Browser** in GameMaker
3. It appears under **Sounds** — rename it to something like `snd_kill`, `snd_task_done`, `snd_crew_win`, `snd_imp_win`

### Step 4.2 — Play kill sound
Open **`JackVenomTank`** → **Step event**. Find the kill mechanic code (the `instance_destroy(_target)` line). After it, add:

```gml
instance_destroy(_target);
kills_done++;
kill_cooldown = 120;
audio_play_sound(snd_kill, 10, false); // sound, priority, loop
```

### Step 4.3 — Play task complete sound
Open `obj_task_fuel` → **Step event**. Find where `is_complete = true` is set. Add:

```gml
is_complete = true;
global.tasks_done++;
audio_play_sound(snd_task_done, 10, false);
```

Do the same in `obj_task_wires` and `obj_task_asteroids`.

### Step 4.4 — Play win/lose music
Open `obj_hud` → **Step event**. Where `game_over = true` is set, add:

```gml
game_over = true;
crew_wins = true;
audio_play_sound(snd_crew_win, 5, false);
```

And for the impostor win:
```gml
game_over = true;
crew_wins = false;
audio_play_sound(snd_imp_win, 5, false);
```

---

## Part 5 — Polish Suggestions (choose your own!) (17 min)

You have ~17 minutes. Pick whichever of these sounds most fun to you:

---

### 🟢 Easy — Change the kill range
In **`JackVenomTank`** Step event, find `distance_to_object(_target) < 50`. Change `50` to a smaller number (e.g. `35`) to make the kill harder, or bigger (`70`) to make it easier.

---

### 🟡 Medium — Show remaining crewmates count
In **`obj_hud`** Draw GUI, add:

```gml
var _alive = instance_count(fjenne_far);
draw_set_colour(c_white);
draw_text(display_get_gui_width() - 150, 35, "Crew alive: " + string(_alive));
```

---

### 🟡 Medium — Kill cooldown displayed as a circle
In **`JackVenomTank`** Draw GUI, replace the cooldown bar rectangle with a circle arc. Clear the existing bar code and add:

```gml
var _angle = 360 * (1 - kill_cooldown / 120);
draw_set_colour(c_red);
draw_healthbar(display_get_gui_width() - 60, display_get_gui_height() - 30,
               display_get_gui_width() - 10, display_get_gui_height() - 10,
               _angle, c_red, c_lime, 0, true, true);
```

---

### 🔴 Hard — Body reporting
When you kill a crewmate, instead of deleting it, change it to a "body" that other crewmates can step on and "report". This requires:

1. In `obj_hud` Step event, detect when a living `fjenne_far` overlaps with a dead one  
2. Trigger a "MEETING CALLED" overlay

This is complex — ask your teacher for help!

---

### 🔴 Hard — Vent system
Add invisible `obj_vent` objects at two locations. When the player stands on one and presses **V**, they are `move_to_point()` teleported to the other vent. Real Among Us impostors use vents to move fast!

```gml
// In obj_vent Step event:
var _player = instance_nearest(x, y, JackVenomTank);
if (distance_to_object(_player) < 40 && keyboard_check_pressed(ord("V")))
{
    // Teleport to the linked vent
    with (JackVenomTank)
    {
        x = other.exit_x;
        y = other.exit_y;
    }
}
```
You'd need to set `exit_x` and `exit_y` in the vent's Create event as the coordinates of the OTHER vent.

---

## Part 6 — Show & Tell (15 min)

Everyone takes a turn pressing **Play** and showing their game to the group. Things to notice:

- How many crewmates did you add?
- Did you change the speed?
- Did you add any of the bonus features?
- What would you add if you had another session?

---

## Summary — What the whole project covers ✅

Over 4 sessions you built:

| Session | What you learned | What you coded |
|---------|-----------------|----------------|
| 1 | IDE navigation, rooms, layers, sprites | Loaded project, set up room, placed player |
| 2 | Variables, movement, camera, AI, events | WASD move, camera follow, crewmate AI, kill mechanic |
| 3 | Arrays, loops, global vars, `with()` | 3 task puzzles (fuel, wires, asteroids) |
| 4 | Win conditions, Draw GUI, audio | Progress bar, result screen, sounds, polish |

---

## Where to go from here 🚀

If you want to keep building, here are ideas roughly in order of difficulty:

1. **More tasks** — add a 4th and 5th puzzle
2. **Lobby screen** — a "start game" room before Room1
3. **Multiple rooms** — connect two sections of the ship
4. **Local multiplayer** — a second player controlling a crewmate (`keyboard_check(vk_up)` etc.)
5. **Timer** — crewmates must finish all tasks within 2 minutes
6. **Save scores** — use `ini_open()` to save your best game to a file
7. **Mini-map** — draw a tiny version of the room in the corner
8. **Proper Among Us clone** — add voting, ghosts, discussion phase...

---

## Recommended Learning Resources

- **Official GameMaker Docs:** https://manual.gamemaker.io
- **GameMaker tutorials on YouTube:** search "Shaun Spalding GameMaker" or "GMLscripts"
- **r/gamemaker** on Reddit — friendly community
- **itch.io** — publish your game for free and share with friends!

---

*You made a game. That's actually awesome. 🎮*
