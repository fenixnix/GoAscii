extends Node2D

onready var enm_prefab = preload("res://Enemy.tscn")

signal enemy_finish()

func Clear():
	for c in get_children():
		c.queue_free()

func RndSel():
	return get_child(randi()%get_child_count())

func RemapEnemy():
	var interval = 100
	var left_start_position = -(get_child_count()-1)*interval/2
	for i in get_child_count():
		get_child(i).position = Vector2(left_start_position + i*interval,0)

func AddEnm(_enm):
	var enm:Enemy = enm_prefab.instance()
	add_child(enm)
	enm.Set(_enm)
	RemapEnemy()

func NewTurn(turn):
	for c in get_children():
		c.NewTurn(turn)
		c.ShowAction()

func EnemyPhase(turn):
	for c in get_children():
		if c == null:
			return
		c.Action()
		yield(get_tree().create_timer(.5),"timeout")
	for c in get_children():
		c.EndTurn(turn)
	emit_signal("enemy_finish")

func EnemyAllDead():
	for c in get_children():
		if c.hp>0:
			return false
	return true
