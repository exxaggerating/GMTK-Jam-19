extends Node2D


func _ready():
	$GameWindow/DeathZone.connect("body_entered", self, "_on_death_zone")

func _on_death_zone(other):
	if other.is_in_group("PLAYER"):
		$Tween.interpolate_property($Menu/Node2D/CameraWhiteNoise.material, "shader_param/cutoff", 0.0, 1.1, 2.0, Tween.TRANS_CIRC, Tween.EASE_IN)
		$Tween.start()
