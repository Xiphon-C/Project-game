extends Control
@onready var file_list: ItemList = $FileList
@onready var viewer: DocViewer = $Viewer
@onready var sleep_button: Button = $SleepButton
@onready var quota_label: Label = $QuotaLabel
func _ready() -> void:
	file_list.item_selected.connect(func(i): viewer.show_doc(Gamestate.docs_today()[i]))
	sleep_button.pressed.connect(Gamestate.sleep)
	Gamestate.fact_found.connect(func(_id): _refresh())
	Gamestate.day_changed.connect(func(_d): _new_day())
	_new_day()
func _new_day() -> void:
	file_list.clear()
	viewer.text = ""
	for d in Gamestate.docs_today():
		file_list.add_item(d.title)
	_refresh()
func _refresh() -> void:
	var done := Gamestate.quota_ids().filter(func(k): return Gamestate.found.has(k)).size()
	quota_label.text = "Facts: %d / %d" % [done, Gamestate.quota_ids().size()]
	sleep_button.disabled = not Gamestate.quota_done() or Gamestate.day >= Gamestate.TOTAL_DAYS
