extends KinematicBody

const projectile_speed = 50

var ammo_types = []

func _enter_tree():
	ammo_types = File_Grabber.get_files("res://Scenes/Ammo/Ammo_Models/")
	randomize()

func fire():
	var rand_bullet = ammo_types[randi() % ammo_types.size()]
	var bullet = load(rand_bullet).instance()
	add_child(bullet)
	bullet.set_as_toplevel(true)
	bullet.global_transform = $Forward.global_transform
	var character_forward = get_global_transform().basis[2].normalized()
	bullet.set_linear_velocity(character_forward * projectile_speed)
	bullet.add_collision_exception_with(self)
