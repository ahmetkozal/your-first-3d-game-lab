# Godot — Combo Sistemi: Sorun ve Çözüm
 
## Sorun
 
Mob öldürünce combo artıyor, ama mob öldürdükten sonra yere değince combo artmak yerine sıfırlanmıyor — zıplayınca sıfırlanıyordu.
 
Ayrıca `landed` sinyali her frame spam'leniyordu.
 
---
 
## Kök Nedenler
 
### 1. `landed` sinyali spam'leniyordu
 
```gdscript
# YANLIŞ — her frame yerdeyken emit eder
if is_on_floor():
	emit_signal("landed")
```
 
`_physics_process` her frame çalışır. Yerde durduğun sürece sinyal sürekli tetikleniyordu.
 
### 2. Mob collision'ı `is_on_floor()` ile karışıyordu
 
Mob'a bastığında `is_on_floor()` true dönüyordu. Bu yüzden:
- Mob öldür → zıpla → `is_on_floor()` mob yüzünden true → `landed` emit → combo sıfırla
- Sıralama: `squashed` → `landed` → `squashed` çıkıyordu
### 3. `was_on_floor = false` yanlış yerdeydi
 
`was_on_floor`'u zıplama bloğunda false yapınca, landed sinyali yere değince değil zıplayınca tetikleniyordu.
 
---
 
## Çözüm
 
### `was_landed` değişkeni ile spam'i önle
 
```gdscript
var was_landed: bool = false
```
 
### `landed`'ı sadece gerçek zemine değince tetikle
 
Collision döngüsünde collider'ın "world" grubunda olup olmadığını kontrol et:
 
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
 
Zemin node'unu "world" grubuna ekle (Godot Inspector → Groups).
 
### `was_landed`'ı havadayken sıfırla
 
```gdscript
# Vertical Velocity bloğu içinde
if not is_on_floor():
	target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	was_landed = false  # ← buraya
```
 
`was_landed = false`'u zıplama bloğuna değil, `not is_on_floor()` bloğuna koy. Zıplama bloğuna koyarsan sinyal yere değince değil zıplayınca tetiklenir.
 
---
 
## Öğrenilen Kavramlar
 
- `_physics_process` her frame çalışır — sinyal spam'ini önlemek için boolean flag kullan
- `is_in_group("group_name")` ile collision'ın kime ait olduğunu kontrol edebilirsin
- Mob collision'ı `is_on_floor()`'u etkileyebilir — zemin ve mob'u grup ile ayırt et
- `was_landed = false` nereye konulduğu kritik — mantığı frame sırasına göre düşün
