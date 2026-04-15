# Session 2 — Player Movement + Crewmates + The Kill
### *Building an Among Us clone — Part 2 of 4*
**Duration:** ~75 minutes | **Prerequisites:** Session 1 complete

---

## What we're building today 🎮
- Understand how the player's movement code works
- Add a **camera** that follows the player around the ship
- Add **wandering crewmates** to the level
- Add the **kill mechanic** — press `E` near a crewmate to eliminate them
- Display a kill counter on screen

---

## Schedule

| Time | Activity |
|------|----------|
| 0:00 – 0:05 | Quick recap of Session 1 |
| 0:05 – 0:20 | How the player code works |
| 0:20 – 0:35 | Add a camera that follows the player |
| 0:35 – 0:50 | Add crewmates + understand their AI |
| 0:50 – 0:70 | Code the kill mechanic |
| 0:70 – 0:75 | Test your game! |

---

## Part 1 — Quick Recap (5 min)

Last session you:
- Set up GameMaker and loaded the project
- Added the spaceship background and wall layers to Room1
- Placed the player object (`JackVenomTank`) in the room

Quick questions to check:
- What are the four types of assets in GameMaker? *(Sprite, Object, Room, Tileset)*
- What layer do walls go on? *(`mur` — a Tile Layer)*

---

## Part 2 — How the Player Code Works (15 min)

Open the **Asset Browser** → double-click **JackVenomTank** → double-click the **Step event**.

You'll see this code:

```gml
// Read keyboard input (-1, 0 or +1 for each axis)
var _hor = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var _ver = keyboard_check(ord("S")) - keyboard_check(ord("W"));

// Move the player, stopping at walls
move_and_collide(move_speed * _hor, move_speed * _ver, mur);
```

### Let's break it down

**`keyboard_check(ord("D"))`** → returns `1` if D is held, `0` if not.

So `keyboard_check(ord("D")) - keyboard_check(ord("A"))` gives us:
- `1` if only D is pressed (move right)
- `-1` if only A is pressed (move left)
- `0` if both or neither are pressed (stay still)

**`move_and_collide(speedX, speedY, tilemap)`** → moves the player by that amount AND stops if it hits a wall tile in the `mur` layer.

### Sprite changing (directional animations)
The code also switches the player's picture depending on which way they're moving:

```gml
if (_ver > 0) sprite_index = spr_player_walk_down;
else if (_ver < 0) sprite_index = spr_player_walk_up;
else if (_hor > 0) sprite_index = spr_player_walk_right;
else if (_hor < 0) sprite_index = spr_player_walk_left;
```

> **Discussion:** What real games can you think of that change the character's sprite based on direction?

### Try it: Change the speed!
Open `JackVenomTank`'s **Create event**. Find this line:
```gml
move_speed = 2;
```
Change `2` to `4`. Press Play. What happens? Try `1`. What about `8`?

---

## Part 3 — Add a Camera That Follows the Player (15 min)

Right now the view doesn't move — if you walk to the edge of the room you disappear off screen. Let's fix that!

### Step 3.1 — Enable views in the room
1. Open **Room1** in the Room Editor
2. In the Inspector, find **Viewports and Cameras**
3. Turn on **Enable Viewports**
4. Turn on **Viewport 0** — tick **Visible**
5. Set Viewport 0 size to match your room: Width `1280`, Height `720`

### Step 3.2 — Make the camera follow the player
Open **JackVenomTank** → **Create event**. Add these lines at the bottom:

```gml
// Set up the camera to follow this object
var _cam = camera_create_view(0, 0, 1280, 720);
camera_set_view_target(_cam, id);
view_camera[0] = _cam;
```

What this does:
- `camera_create_view(x, y, width, height)` — creates a camera window
- `camera_set_view_target(camera, object_id)` — locks the camera onto THIS object
- `view_camera[0] = _cam` — assigns it to Viewport 0

Press **Play** and walk around — the camera should now follow you! 🎥

### Step 3.3 — Clamp camera to room edges (bonus, 3 min)
Without clamping, the camera can show black space outside the room. Add this inside the **Step event**:

```gml
// Keep camera inside the room
camera_set_view_pos(view_camera[0],
    clamp(x - 640, 0, room_width  - 1280),
    clamp(y - 360, 0, room_height - 720));
```

---

## Part 4 — Add Crewmates + Their AI (15 min)

The project already has a crewmate object called **`fjenne_far`**. Let's put some in the room and understand how they work.

### Step 4.1 — Place crewmates in the room
1. Open **Room1**
2. Make sure you're on the **Instances layer**
3. In the Asset Browser, find **`fjenne_far`**
4. Drag **3 or 4 copies** onto different parts of the ship map

Press Play — you'll see the crewmates wandering around!

### Step 4.2 — How the crewmate AI works
Open **`fjenne_far`** → **Alarm 0 event**:

```gml
// If the player is close, chase them. Otherwise, wander.
if (instance_exists(JackVenomTank) && distance_to_object(JackVenomTank) < afstand)
{
    target_x = JackVenomTank.x;
    target_y = JackVenomTank.y;
}
else
{
    // Pick a random nearby spot to walk to
    target_x = random_range(xstart - 100, xstart + 100);
    target_y = random_range(ystart - 100, ystart + 100);
}

alarm[0] = 60; // Run this alarm again in 60 steps (1 second)
```

And in the **Step event**, the crewmate moves toward its target:

```gml
var _hor = clamp(target_x - x, -1, 1);
var _ver = clamp(target_y - y, -1, 1);
move_and_collide(_hor * move_speed, _ver * move_speed, [tilemap, fjenne_far]);
```

> **Key concept:** An **Alarm** is like a timer. `alarm[0] = 60` means "after 60 game steps (= 1 second at 60fps), run the Alarm 0 event."

> **Discussion:** What would happen if you changed `afstand` to be very large? The crewmates would chase you from across the whole map!

---

## Part 5 — Code the Kill Mechanic (20 min)

In Among Us, the impostor can silently eliminate crewmates by pressing a button when standing next to them. Let's build that!

> **Design decision:** The player will press **E** to kill. It only works when they're within 50 pixels of a crewmate.

### Step 5.1 — Add kills_done variable
Open **JackVenomTank** → **Create event**. Add this line:

```gml
kills_done = 0;      // count how many we've eliminated
kill_cooldown = 0;   // prevents killing twice per second
```

### Step 5.2 — Add the kill code
Open **JackVenomTank** → **Step event**. At the bottom, add:

```gml
// --- KILL MECHANIC ---
// Count down the cooldown (stops it going below zero)
if (kill_cooldown > 0) kill_cooldown--;

// Check if player presses E
if (keyboard_check_pressed(ord("E")) && kill_cooldown == 0)
{
    // Look for the nearest crewmate within 50 pixels
    var _target = instance_nearest(x, y, fjenne_far);
    
    if (_target != noone && distance_to_object(_target) < 50)
    {
        instance_destroy(_target);   // eliminate the crewmate!
        kills_done++;
        kill_cooldown = 120;         // 2 second cooldown (120 steps)
    }
}
```

### Step 5.3 — Show the kill count on screen
We want to draw text on screen. GameMaker uses a special event called **Draw GUI** for this — it draws on top of everything, always in the same spot on the screen.

Open **JackVenomTank** → click **Add Event** → **Draw** → **Draw GUI**.

Add this code:

```gml
// Set text size and colour
draw_set_font(-1);          // use default font
draw_set_colour(c_red);

// Draw kill count in top-right corner
draw_text(room_width - 200, 20, "Kills: " + string(kills_done));

// Draw kill cooldown bar
var _bar_width = 150 * (kill_cooldown / 120);
draw_set_colour(c_orange);
draw_rectangle(room_width - 200, 50, room_width - 200 + _bar_width, 65, false);
draw_set_colour(c_white);
draw_rectangle(room_width - 200, 50, room_width - 50, 65, true);  // outline
```

> **Note:** `draw_text(x, y, text)` — x and y are positions on the **screen**, not the room. That's why we use `room_width - 200` to pin it to the top-right.

### Step 5.4 — Test it!
Press **Play**. Walk up to a crewmate, press **E** — they should disappear and your kill count goes up! The orange bar shows the cooldown draining.

> **Troubleshooting:**
> - Nothing happens? Check the object name is exactly `fjenne_far` (lowercase, underscore).
> - Error about `afstand`? Open `fjenne_far` Create event and make sure `afstand` is defined there.

---

## Extra Challenges 🌟

**Easy:**  Change the kill range from `50` to `80`. Does it feel better or worse?

**Medium:** Add an idle animation — if the player is NOT moving, change their sprite to the correct idle direction. (Hint: look at the existing `else` block in the Step event — it might already be there!)

**Hard:** Make it so dead crewmates leave a **body** behind. Instead of `instance_destroy(_target)`, change their sprite to something grey/dead and set a variable `is_dead = true`. Then modify the AI so dead crewmates don't move.

---

## Summary — What you built today ✅
- [x] Understood WASD movement code and variables
- [x] Added a camera that follows the player
- [x] Added crewmates and understood their wandering AI
- [x] Built a proximity kill mechanic with cooldown
- [x] Drew a HUD (kill count + cooldown bar) on screen

---

## Coming up in Session 3...
The crewmates are running tasks around the ship. You'll build **3 mini-game puzzles** that the crewmates (and maybe YOU) have to complete:
- ⛽ Fuel the reactor (hold a button)
- 🔌 Fix the wires (click in the right order)
- ☄️ Shoot asteroids (click on moving targets)
