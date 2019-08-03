extends Node2D


func _ready():
	$GameWindow/Bounds/DeathZone.connect("body_entered", self, "_on_death_zone")
	$GameWindow/Goal.connect("body_entered", self, "_on_goal_reached")

func _on_death_zone(other):
	if other.is_in_group("PLAYER"):
		$Menu.show()
		$Menu/Tween.interpolate_property($Menu/Node2D/CameraWhiteNoise.material, "shader_param/cutoff", 0.0, 1.1, 2.0, Tween.TRANS_CIRC, Tween.EASE_IN)
		$Menu/Tween.start()

func _on_goal_reached(other):
	if other.is_in_group("PLAYER"):
		print("QUEUE CUTSCENE GODDAMIT")
