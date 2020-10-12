extends Node

onready var plrBtl = $Player

var result = {}
var turn = 0

func Start(dat):
	result["type"] = dat.type
	plrBtl.Set(dat.chara)
	DrawCard(5)
	refresh()
	for e in dat.get("enm",[]):
		$BattleGround.AddEnm(GlbDb.enmDict[e])

	$UI/Hands.visible = true
	$UI/EndTurn.visible = true
	$BattleGround.NewTurn(turn)

func Stop():
	$UI/Hands.visible = false
	$UI/EndTurn.visible = false

func refresh():
	$UI.Refresh(plrBtl)
	$Player.refresh()

func DrawCard(cnt = 1):
	for i in cnt:
		var card = plrBtl.Draw()

func _on_EndTurn_pressed():
	$Player.EndTurn()
	$BattleGround.EnemyPhase(turn)
	yield($BattleGround,"enemy_finish")
	turn += 1
	$BattleGround.NewTurn(turn)
	$Player.StartNewTurn()

func _on_Player_refresh_card():
	refresh()

func _on_Player_discard(card):
	$UI/Hands.Discard(card)
	refresh()

func _on_Player_exhaust(card):
	$UI/Hands.Exhaust(card)
	refresh()

func _on_Player_play(card):
	$UI/Hands.Refresh()

func _on_Player_draw_card(card):
	$UI/Hands.Draw(card)
	refresh()
	
func _on_Player_invoke(card):
	$UI/Hands.Invoke(card)

func _on_Player_hurt(attacker, dmg):
	var text = preload("res://EnlargeText.tscn").instance()
	$UI.add_child(text)
	text.Set(str(-dmg))
	$Camera2D/Shake.Shake(dmg)

func _on_discardCount_pressed():
	GlbUi.OpenView(plrBtl.discard)
