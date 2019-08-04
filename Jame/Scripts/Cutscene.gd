extends Node2D


var initial = Vector2(0, 900)
var final = Vector2(0, -3200)

func _ready():
	$AnimationPlayer.play("CUTSCENE")


func _on_AnimationPlayer_animation_finished(anim_name):
	$Credits.show()
	$Tween.interpolate_property($Credits, "rect_position", initial, final, 22.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	


func _on_Credit_tween_completed(object, key):
	$Memory.show()
	var t = Timer.new()
	t.set_wait_time(8)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	queue_free()
	SceneSwitcher.main_menu()
