extends Node2D


func _ready():
	$GameWindow/DeathZone.connect("body_entered", self, "_on_death_zone")
	$GameWindow/Goal.connect("body_entered", self, "_on_goal_reached")

func _on_death_zone(other):
	if other.is_in_group("PLAYER"):
		print("ded")

func _on_goal_reached(other):
	if other.is_in_group("PLAYER"):
		print("QUEUE CUTSCENE GODDAMIT")
