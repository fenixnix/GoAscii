extends Control

var data
var tmp_goal = Vector2.ZERO

var is_thumbnail = false

onready var panel = $Control/CardPanel

func Set(card):
	data = card
	panel.Set(card)
	if is_thumbnail:
		if typeof(card.cost) == typeof("X"):
			SetActive(true)
		else:
			SetActive(card.cost<=GlbAct.GetChara().en)
		$Control.rect_scale = Vector2.ONE*0.7

func Refresh():
	Set(data)

func AnimMove(_goal):
	if (tmp_goal-_goal).length_squared()>1:
		tmp_goal = _goal
		$Tween.interpolate_property(self,"rect_position",rect_position,tmp_goal,
		0.5,Tween.TRANS_QUAD,Tween.EASE_IN)
		$Tween.start()

func Exhaust():
	$Control.rect_scale = Vector2.ONE
	$Control.rect_position += Vector2.UP*100
	$Tween.interpolate_property(self,"modulate",Color.white,Color(1,1,1,0),1)
	$Tween.start()
	yield($Tween,"tween_all_completed")
	queue_free()

func Discard():
	$Tween.interpolate_property(self,"rect_scale",Vector2.ONE,Vector2.ZERO,1)
	$Tween.start()
	yield($Tween,"tween_all_completed")
	queue_free()

func SetActive(val):
	if is_thumbnail:
		if val:
			$Control/CardPanel/Cost/Cost.modulate = Color.green
		else:
			$Control/CardPanel/Cost/Cost.modulate = Color.red
		$HotArea.active = val

var prePos

func _on_HotArea_mouse_entered():
	if is_thumbnail:
		$Control.rect_scale = Vector2.ONE
		$Control.rect_position += Vector2.UP*100
		prePos = get_index()
		get_parent().move_child(self,get_parent().get_child_count())

func _on_HotArea_mouse_exited():
	if is_thumbnail:
		$Control.rect_scale = Vector2.ONE*0.7
		$Control.rect_position -= Vector2.UP*100
		get_parent().move_child(self,prePos)
