extends Node2D


func _ready():
	$GameWindow/DeathZone.connect("body_entered", self, "_on_death_zone")

func _on_death_zone(other):
	if other.is_in_group("PLAYER"):
		print("ded")
