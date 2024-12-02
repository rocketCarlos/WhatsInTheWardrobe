extends Sprite2D

@onready var big_hand = $BigHand
@onready var small_hand = $SmallHand

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var total_time = Globals.day_durations[Globals.current_day]
	var time_left = Globals.scene_manager.day_timer.time_left

	# interpolation starting point in seconds
	var clock_starting_hour = 9 * 3600

	var target_hour = (total_time - time_left) * clock_starting_hour / total_time

	# Convertir segundos del día en horas y minutos
	var minutos = (int(target_hour) % 3600) / 60
	var horas = int(target_hour / 3600) % 12

	# Ángulo de la manecilla de las horas (0-12 horas = 0-2π radianes)
	small_hand.rotation  = (horas + minutos / 60) * (2 * PI / 12)

	# Ángulo de la manecilla de los minutos (0-60 minutos = 0-2π radianes)
	big_hand.rotation = minutos * (2 * PI / 60)

	

	
