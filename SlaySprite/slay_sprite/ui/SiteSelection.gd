extends Control

signal select(type)

#func _ready():
#	Set(["enm","?","rest"])

func Set(list):
	for c in $ItemList.get_children():
		c.queue_free()
	for l in list:
		var btn = Button.new()
		match l:
			"enm":btn.icon = mapIcon("monster")
			"enmX":btn.icon = mapIcon("elite")
			"?":btn.icon = mapIcon("unknown")
			"shop":btn.icon = mapIcon("shop")
			"chest":btn.icon = mapIcon("chest")
			"forge":btn.icon = mapIcon("vintage")
			"rest":btn.icon = mapIcon("rest")
			"boss":btn.icon = mapIcon("boss")
		$ItemList.add_child(btn)
		btn.connect("pressed",self,"on_select",[l])

func on_select(type):
	emit_signal("select",type)
	queue_free()

func mapIcon(icon):
	return load("res://image/icon/%s.png"%icon)
