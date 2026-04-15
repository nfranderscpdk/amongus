# Session 3 — Three Puzzles (Tasks!)
### *Building an Among Us clone — Part 3 of 4*
**Duration:** ~75 minutes | **Prerequisites:** Sessions 1 & 2 complete

---

## What we're building today 🔧
Three task puzzles the crewmates need to complete:

| # | Task | How to solve |
|---|------|--------------|
| 1 | **Fuel Reactor** | Walk to the panel, hold `E` until bar fills |
| 2 | **Fix Wires** | Walk to panel, press Q / W / E / R in the right order |
| 3 | **Destroy Asteroids** | Click asteroids before they leave the screen |

Each task is its own **object** placed somewhere on the ship map.

---

## Schedule

| Time | Activity |
|------|----------|
| 0:00 – 0:05 | Quick recap |
| 0:05 – 0:30 | Puzzle 1 — Fuel the Reactor |
| 0:30 – 0:55 | Puzzle 2 — Fix the Wires |
| 0:55 – 0:75 | Puzzle 3 — Destroy Asteroids |

---

## Part 1 — Quick Recap (5 min)

Last session you:
- Added camera follow
- Added crewmates with wandering AI
- Built a kill mechanic (press E near a crewmate)

Quick check: What does `kill_cooldown = 120` mean? *(Wait 2 seconds before killing again — 120 steps at 60fps)*

---

## Part 2 — Puzzle 1: Fuel the Reactor (25 min)

The player walks up to a fuel panel, holds **E**, and a progress bar slowly fills. When it's full, the task is complete!

### Step 2.1 — Create the sprite

For now we'll draw the panel with code (no sprite needed). We'll add a sprite later if we have time.

### Step 2.2 — Create the object

In the Asset Browser:
1. Right-click → **Create** → **Object**
2. Name it **`obj_task_fuel`**
3. (Optional) Assign `spr_box` as its sprite so you can see it in the room

### Step 2.3 — Create event

Open `obj_task_fuel` → **Add Event** → **Create**:

```gml
task_progress = 0;    // goes from 0 to 100
is_complete    = false;
fill_speed     = 0.5; // how fast the bar fills per step
```

### Step 2.4 — Step event

Add Event → **Step** → **Step**:

```gml
// Only do anything if the task isn't complete yet
if (!is_complete)
{
    // Check if player is nearby AND holding E
    var _player = instance_nearest(x, y, JackVenomTank);
    var _close  = (distance_to_object(_player) < 60);
    
    if (_close && keyboard_check(ord("E")))
    {
        task_progress += fill_speed;
    }
    else
    {
        // Bar slowly drains if player lets go
        task_progress = max(0, task_progress - fill_speed * 0.3);
    }
    
    // Check for completion
    if (task_progress >= 100)
    {
        task_progress = 100;
        is_complete   = true;
        
        // Tell the game this task is done
        global.tasks_done++;
    }
}
```

> **New concept:** `global.tasks_done` — variables with `global.` in front are shared across ALL objects in the game. We need this so the game can track how many tasks are complete.

### Step 2.5 — Set up the global variable

Open **JackVenomTank** → **Create event**. Add near the top:

```gml
global.tasks_done  = 0;
global.tasks_total = 3;  // we'll have 3 tasks in total
```

### Step 2.6 — Draw GUI event (draw the progress bar)

Open `obj_task_fuel` → **Add Event** → **Draw** → **Draw GUI**.

```gml
// Only show the bar if the player is nearby
var _player = instance_nearest(x, y, JackVenomTank);
if (distance_to_object(_player) > 80) exit; // too far, don't draw

// Convert room position to screen position
var _sx = x - camera_get_view_x(view_camera[0]);
var _sy = y - camera_get_view_y(view_camera[0]);

// Draw background
draw_set_colour(c_dkgrey);
draw_rectangle(_sx - 30, _sy - 50, _sx + 30, _sy - 35, false);

// Draw filled portion
var _fill = 60 * (task_progress / 100);
if (is_complete)
    draw_set_colour(c_lime);
else
    draw_set_colour(c_yellow);
draw_rectangle(_sx - 30, _sy - 50, _sx - 30 + _fill, _sy - 35, false);

// Draw outline + label
draw_set_colour(c_white);
draw_rectangle(_sx - 30, _sy - 50, _sx + 30, _sy - 35, true);

if (is_complete)
    draw_text(_sx - 20, _sy - 70, "DONE!");
else
    draw_text(_sx - 25, _sy - 70, "Hold [E]");
```

### Step 2.7 — Place it in the room
Open **Room1** → drag `obj_task_fuel` onto a spot on the ship map (e.g. the engine room area).

Press **Play** and walk up to it — hold **E** to fill the bar!

---

## Part 3 — Puzzle 2: Fix the Wires (25 min)

Four coloured buttons appear. The player must press them in the right order: **Q → W → E → R**. Any wrong press resets the puzzle.

### Step 3.1 — Create the object

Right-click → **Create** → **Object** → name it **`obj_task_wires`**.
Assign `spr_box` as sprite.

### Step 3.2 — Create event

```gml
// The correct sequence the player must press
correct_sequence = ["Q", "W", "E", "R"];

// The colours shown on each button
button_colours   = [c_red, c_yellow, c_lime, c_aqua];

current_step     = 0;    // which button they need to press next
is_complete      = false;
flash_timer      = 0;    // short flash when a button is pressed
flash_correct    = true; // was the flash for a correct or wrong press?
```

> **New concept:** An **array** is a list of values. `correct_sequence[0]` is `"Q"`, `correct_sequence[1]` is `"W"`, etc.

### Step 3.3 — Step event

```gml
if (is_complete) exit;

// Only respond if player is close
var _player = instance_nearest(x, y, JackVenomTank);
if (distance_to_object(_player) > 70) exit;

// Count down flash timer
if (flash_timer > 0) flash_timer--;

// Check each of the 4 keys
var _keys = ["Q", "W", "E", "R"];
for (var i = 0; i < 4; i++)
{
    if (keyboard_check_pressed(ord(_keys[i])))
    {
        if (_keys[i] == correct_sequence[current_step])
        {
            // Correct!
            current_step++;
            flash_correct = true;
            flash_timer   = 20;
            
            if (current_step >= array_length(correct_sequence))
            {
                is_complete = true;
                global.tasks_done++;
            }
        }
        else
        {
            // Wrong — reset!
            current_step  = 0;
            flash_correct = false;
            flash_timer   = 30;
        }
    }
}
```

### Step 3.4 — Draw GUI event

```gml
var _player = instance_nearest(x, y, JackVenomTank);
if (distance_to_object(_player) > 80) exit;

var _sx = x - camera_get_view_x(view_camera[0]);
var _sy = y - camera_get_view_y(view_camera[0]);

if (is_complete)
{
    draw_set_colour(c_lime);
    draw_text(_sx - 25, _sy - 70, "WIRES FIXED!");
    exit;
}

// Draw label
draw_set_colour(c_white);
draw_text(_sx - 45, _sy - 80, "Fix wires: Q W E R");

// Draw the 4 coloured buttons
var _keys   = ["Q", "W", "E", "R"];
for (var i = 0; i < 4; i++)
{
    var _bx = _sx - 45 + i * 30;
    var _by = _sy - 60;
    
    // Highlight the NEXT button to press
    if (i == current_step)
        draw_set_colour(button_colours[i]);
    else if (i < current_step)
        draw_set_colour(c_dkgrey);   // already pressed
    else
        draw_set_colour(merge_colour(button_colours[i], c_black, 0.6)); // dimmed
    
    draw_rectangle(_bx, _by, _bx + 24, _by + 24, false);
    draw_set_colour(c_white);
    draw_rectangle(_bx, _by, _bx + 24, _by + 24, true);
    draw_text(_bx + 6, _by + 4, _keys[i]);
}

// Show feedback flash
if (flash_timer > 0)
{
    if (flash_correct)
    {
        draw_set_colour(c_lime);
        draw_text(_sx - 20, _sy - 100, "Good!");
    }
    else
    {
        draw_set_colour(c_red);
        draw_text(_sx - 20, _sy - 100, "Wrong! Reset.");
    }
}
```

### Step 3.5 — Place in room
Drag `obj_task_wires` somewhere different on the map (e.g. the navigation room).

Test it — walk up, press **Q W E R** in order. Try pressing a wrong key first!

---

## Part 4 — Puzzle 3: Destroy Asteroids (20 min)

A wave of asteroids flies across the screen. Click them before they escape! Pop 5 to complete the task.

### Step 4.1 — Create the asteroid object

Right-click → **Create** → **Object** → name it **`obj_asteroid`**.
Assign `spr_enemy1` or `spr_lava` as the sprite (whatever looks best).

**Create event:**
```gml
// Random speed across the screen
speed_x    = random_range(2, 5);
speed_y    = random_range(-1, 1);
is_target  = true; // this asteroid is clickable
```

**Step event:**
```gml
x += speed_x;

// Destroy self if it leaves the right side of the room
if (x > room_width + 50)
    instance_destroy();
```

**Left Released event** (Events → Mouse → Left Released):
```gml
// Player clicked this asteroid!
with (obj_task_asteroids)
{
    asteroids_popped++;
}
instance_destroy();
```

> **`with (object)`** — this runs the code *as if we were inside* `obj_task_asteroids`. It's how one object talks to another.

### Step 4.2 — Create the task spawner object

Right-click → **Create** → **Object** → name it **`obj_task_asteroids`**.
Assign `spr_box` as sprite.

**Create event:**
```gml
is_active       = false;  // task hasn't started yet
is_complete     = false;
asteroids_popped = 0;
target_count    = 5;      // need to pop 5
spawn_timer     = 0;
```

**Step event:**
```gml
if (is_complete) exit;

// Start the task when player walks close and presses E
if (!is_active)
{
    var _player = instance_nearest(x, y, JackVenomTank);
    if (distance_to_object(_player) < 60 && keyboard_check_pressed(ord("E")))
        is_active = true;
    exit;
}

// Spawn asteroids on a timer
spawn_timer--;
if (spawn_timer <= 0)
{
    spawn_timer = 40; // spawn one every 40 steps
    
    var _asteroid = instance_create_depth(
        camera_get_view_x(view_camera[0]) - 30,          // spawn off left edge of screen
        camera_get_view_y(view_camera[0]) + random(720), // random height
        depth,
        obj_asteroid
    );
}

// Check if enough asteroids popped
if (asteroids_popped >= target_count)
{
    is_complete = true;
    global.tasks_done++;
    
    // Destroy any remaining asteroids
    with (obj_asteroid) instance_destroy();
}
```

**Draw GUI event:**
```gml
var _player = instance_nearest(x, y, JackVenomTank);

if (!is_active && distance_to_object(_player) < 80)
{
    var _sx = x - camera_get_view_x(view_camera[0]);
    var _sy = y - camera_get_view_y(view_camera[0]);
    draw_set_colour(c_white);
    draw_text(_sx - 30, _sy - 60, "Press [E] to start");
}

if (is_active && !is_complete)
{
    draw_set_colour(c_orange);
    draw_text(20, 20, "Asteroids: " + string(asteroids_popped) + " / " + string(target_count));
}

if (is_complete)
{
    draw_set_colour(c_lime);
    draw_text(20, 20, "Asteroids CLEAR!");
}
```

### Step 4.3 — Place in room
Drag `obj_task_asteroids` to somewhere on the map (e.g. the weapons room / top of skeld).

Test it — walk up, press **E**, then click the asteroids flying past!

---

## Summary — What you built today ✅
- [x] Created `obj_task_fuel` — hold E to fill a progress bar
- [x] Created `obj_task_wires` — press keys in the right order
- [x] Created `obj_task_asteroids` — click moving targets
- [x] Used `global.tasks_done` to track progress
- [x] Learned: arrays, `with()`, `for` loops, and Draw GUI coordinates

---

## Extra Challenges 🌟

**Easy:** Change how many asteroids you need to pop (try `target_count = 10`).

**Medium:** The fuel task resets if you let go. Can you change it so it NEVER drains — once you fill it, it stays filled?

**Hard:** Add a **time limit** to the asteroid task. If you don't pop 5 in 10 seconds the task resets. (Hint: use `alarm[0] = 600` in the Create event.)

---

## Coming up in Session 4...
You have movement, kills, and tasks. Now it's time to **tie it all together**:
- A task progress bar showing how close the crew is to winning
- A **game over screen** (crewmates win if all tasks done, impostor wins if enough kills)
- Sound effects
- Play each other's games! 🎉
