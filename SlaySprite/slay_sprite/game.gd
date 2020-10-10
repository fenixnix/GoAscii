extends Node

func _ready():
	randomize()
	GlbDat.chara = Chara.new()
	GlbDat.chara.Set(GlbDb.LoadDat("warrior_default"))
	$UI/MainMenu.Refresh()
	
	GlbDat.cur_floor = 0
	GlbDat.map = FileRW.LoadJsonFile("res://data/map/map01.json")
	
	GlbAct.EnterSite()
