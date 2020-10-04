extends Node

class_name CharaBtl

var chara

var en = 0
var blk = 0
var new_turn_draw_cnt = 5
var attr = {}
var status = {}
var power = {}

var deck = []
var hand = []
var discard = []
var exhaust = []

signal exhaust(card)
signal discard(card)
signal invoke(card)
signal clone(card)
signal draw_card(card)
signal play(card)

signal gain_block(val)
signal take_dmg(atker,val)
signal hurt(attacker,dmg)
signal cost_hp(amount)
signal dead()
signal end_turn()
signal new_turn()
signal refresh_card()

func Set(_chara):
	chara = _chara
	en = chara.en
	deck.clear()
	discard.clear()
	for card in chara.cards:
		deck.append(card)
	deck.shuffle()
	refresh()

func refresh():
	$Info.Set(self)

func StartNewTurn():
	en = chara.en
	if !power.has("barricade"):
		blk = 0
	emit_signal("new_turn")
	
	#update status
	var dead_keys = []
	for k in status.keys():
		status[k] -= 1
		if status[k]<=0:
			dead_keys.append(k)
	for d in dead_keys:
		status.erase(d)
	
	for i in new_turn_draw_cnt:
		Draw()

func EndTurn():
	var dead_queue = []
	for card in hand:
		if card.desc.has("Ethereal"):
			emit_signal("exhaust",card)
		else:
			emit_signal("discard",card)
			discard.append(card)
	hand.clear()

func Draw():
	if status.has("can_not_draw"):
		return
	if len(deck)<=0:
		ReChargeDeck()
	if len(deck)>0:
		var c= deck.pop_front()
		hand.push_back(c)
		emit_signal("draw_card",c)
		return c
	return null

func PlayCard(card,target = null):
	if typeof(card.cost) != typeof("X"):
		en -= card.cost
	if target == null:
		target = $"../BattleGrond".RndSel()
		print_debug("Random Select Target:",target)
	RunDesc(card,target)
	if card.type == "Power":
		Inuse(card)
	if card.desc.has("Exhaust"):
		Exhaust(card)
	else:
		Discard(card)
	if typeof(card.cost) == typeof("X"):
		en = 0
	refresh()
	emit_signal("play",card)

func RunDesc(card,target = null):
	for d in card.desc:
		match d.type:
			"dmg":DuelDamage(d,target)
			"costHp":CostHp(d.get("val",0))
			"en":en+=d.get("val",0)
			"blk":GainBlock(d)
			"vul","weak","frail":target.ModStatus(d)
			"draw":
				for i in d.get("val",1):
					Draw()
			"script":ExecuteScript(d,card,target)

func DuelDamage(dat,target):
	var dmg = dat.val + attr.get("str",0)*dat.get("str_bonus",1)
	return target.TakeDamage(dmg)

func GainBlock(dat):
	var blkVal = dat.val
	if status.has("frail"):
		blkVal = ceil(blkVal*.75)
	blk += blkVal
	emit_signal("gain_block",blkVal)

func Heal(val):
	chara.hp += val
	if chara.hp > chara.mhp:
		chara.hp = chara.mhp

func ModAttr(d):
	GlbAct.modDict(d,attr)

func ModStatus(d):
	GlbAct.modDict(d,status)

func ModPower(d):
	GlbAct.modDict(d,power)

func ExecuteScript(dat,card,target):
	var s = load("res://script/%s.gd"%dat.val)
	s.run(self,card,target,dat.get("para",{}))

func CostHp(amount):
	chara.hp -= amount
	emit_signal("cost_hp",amount)

func TakeDamage(attacker,_dmg):
	var dmg = _dmg
	if status.has("vul"):
		dmg = ceil(dmg*1.5)
	var overDmg = clamp(dmg-blk,0,65535)
	blk = clamp(blk-dmg,0,65535)
	chara.hp -= overDmg
	if chara.hp<=0:
		chara.hp = 0
		on_dead()
	emit_signal("hurt",attacker,dmg)
	emit_signal("take_dmg",attacker,dmg)

func on_dead():
	print("dead")
	emit_signal("dead")

func on_end_turn():
	print("end turn")
	emit_signal("end_turn")

func InvokeCard(card):
	hand.append(card)
	emit_signal("invoke",card)

func ReChargeDeck():
	print_debug("Refesh Deck")
	for d in discard:
		deck.append(d)
	discard.clear()
	deck.shuffle()

func Exhaust(card):
	hand.erase(card)
	exhaust.append(card)
	emit_signal("exhaust",card)

func Discard(card):
	hand.erase(card)
	discard.append(card)
	emit_signal("discard",card)

func Inuse(card):
	hand.erase(card)

func PutIntoDiscard(card):
	discard.append(card)

func PutIntoDrawPile(card):
	deck.append(card)
	deck.shuffle()

func Clone(card):
	hand.append(card)
	emit_signal("clone",card)
