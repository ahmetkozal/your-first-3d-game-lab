# Godot — Combo System: Bug & Fix
 
## The Problem
 
Killing a mob increased the combo, but after killing a mob, landing on the ground wasn't resetting the combo — it was resetting on jump instead.
 
Also, the `landed` signal was being spammed every frame.
 
---
 
## Root Causes
 
### 1. `landed` signal was spamming
 
```gdscript
# WRONG — emits every frame while on the floor
if is_on_floor():
    emit_signal("landed")
```
 
`_physics_process` runs every frame. The signal was firing continuously as long as the player stood on the ground.
 
### 2. Mob collision was interfering with `is_on_floor()`
 
When jumping on a mob, `is_on_floor()` returned true. This caused:
- Kill mob → jump → `is_on_floor()` true because of mob → emit `landed` → reset combo
- The actual order was: `squashed` → `landed` → `squashed`
### 3. `was_on_floor = false` was in the wrong place
 
Setting `was_on_floor` to false inside the jump block meant the `landed` signal fired on jump, not on landing.
 
---
 
## Solution
 
### Use a `was_landed` boolean to prevent spam
 
```gdscript
var was_landed: bool = false
```
 
### Only emit `landed` when colliding with actual ground
 
Check if the collider belongs to the "world" group inside the collision loop:
 
```gdscript
for index in range(get_slide_collision_count()):
    var collision = get_slide_collision(index)
    if collision.get_collider() == null:
        continue
 
    if collision.get_collider().is_in_group("world"):
        if was_landed == false:
            emit_signal("landed")
        was_landed = true
```
 
Add the ground node to the "world" group in the Godot Inspector → Groups tab.
 
### Reset `was_landed` while in the air
 
```gdscript
# Inside the "not is_on_floor()" block
if not is_on_floor():
    target_velocity.y = target_velocity.y - (fall_acceleration * delta)
    was_landed = false  # ← here
```
 
Put `was_landed = false` inside the `not is_on_floor()` block, not the jump block. Putting it in the jump block causes the signal to fire on jump instead of on landing.
 
---
 
## What I Learned
 
- `_physics_process` runs every frame — use a boolean flag to prevent signal spam
- Use `is_in_group("group_name")` to identify what you're colliding with
- Mob collision can affect `is_on_floor()` — use groups to separate ground from mobs
- Where you place `was_landed = false` matters — think through the frame-by-frame order
