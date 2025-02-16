extends Control

onready var labScore = get_node("Score")
onready var lablabHigh = get_node("High")
var score = 0
var high = 0
var savegame = File.new()
var savedata = {"highscore" : 0}
var savepath = "user://savegame.save"
func _ready():
	if not savegame.file_exists(savepath):
		save()
	read()
	high = savedata["highscore"]
	labScore.set_text(str(score))
	lablabHigh.set_text(str(high))
func save():
	savegame.open(savepath, File.WRITE)
	savegame.store_var(savedata)
	savegame.close()
func read():
	savegame.open(savepath, File.READ)
	savedata = savegame.get_var()
	savegame.close()
func add_score(add):
	score += add
	labScore.set_text(str(score))
	if score > high:
		high = score
		lablabHigh.set_text(str(high))
func save_high():
	savedata["highscore"]= high
	save()
