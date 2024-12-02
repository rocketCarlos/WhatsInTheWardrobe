extends Sprite2D

@onready var big_hand = $BigHand
@onready var small_hand = $SmallHand

var small_hand_step
var big_hand_step

func _ready() -> void:
	var initial_hour = 9
	var final_hour = 13 if Globals.current_day == 2 else 17
	var total_hours = float(final_hour - initial_hour)
	var duration_seconds = float(Globals.day_durations[Globals.current_day])
	
	# we want to show that total_hours hours go by in the clock in duration_seconds seconds
	
	var total_rotation_minutes = 2 * PI * total_hours # big hand loops once per hour
	var total_rotation_hours = total_rotation_minutes / 12.0 # small hand makes 12th of a loop per hour
	
	small_hand_step = total_rotation_hours / duration_seconds
	big_hand_step = total_rotation_minutes / duration_seconds
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	big_hand.rotation += big_hand_step * delta
	small_hand.rotation += small_hand_step * delta
