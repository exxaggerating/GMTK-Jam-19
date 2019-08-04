extends Node2D


func _ready():
	$GameWindow/Bounds/DeathZone.connect("body_entered", self, "_on_death_zone")
	$GameWindow/Goal.connect("body_entered", self, "_on_goal_reached")
	
	for node in get_tree().get_nodes_in_group("TRAP"):
		node.connect("body_entered", self, "_on_death_zone")

func _on_death_zone(other):
	if other.is_in_group("PLAYER"):
		$Menu.show()
		$Menu/Tween.interpolate_property($Menu/Node2D/CameraWhiteNoise.material, "shader_param/cutoff", 0.0, 1.1, 2.0, Tween.TRANS_CIRC, Tween.EASE_IN)
		$Menu/Tween.start()
		InputController.disconnect("morse", $GameWindow/Curiosity, "_on_morse")
		$GameWindow/Curiosity.disconnect("acceleration", $Legend, "_on_Curiosity_acceleration")
		$GameWindow.remove_child($GameWindow/Curiosity)

func _on_goal_reached(other):
	if other.is_in_group("PLAYER"):
		print("QUEUE CUTSCENE GODDAMIT")
