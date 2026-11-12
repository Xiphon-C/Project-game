extends Node

signal fact_found(id: String)
signal day_changed(day: int)
signal ending_reached(ending: String)

const TOTAL_DAYS := 5
const TELLS_NEEDED := 3
const KILLER := "mc"

var day := 1
var found: Dictionary = {}
var facts: Dictionary = {}
var docs: Array = []

func _ready() -> void:
	facts = {
		"murder_place": {"kind": "quota", "day": 1, "note": "Where it happened"},
		"murder_time":  {"kind": "quota", "day": 1, "note": "When it happened"},
		"torn_sleeve":  {"kind": "tell",  "day": 1, "note": "Detail that points at you"}
	}
	docs = [
		{"id": "report_01", "title": "case_report.txt", "day": 1,
		 "body": "Victim found in the {{murder_place|warehouse on Dock Street}} around {{murder_time|11:40 PM}}. Witness mentions the attacker's coat was {{torn_sleeve|missing a sleeve button}}. Same as the one in the closet."},
		{"id": "memo_01", "title": "memo_chris.txt", "day": 1,
		 "body": "Chris was seen near the docks. Unconfirmed."}
	]

func corruption() -> float:
	return float(day - 1) / float(TOTAL_DAYS - 1)

func docs_today() -> Array:
	return docs.filter(func(d): return d.day <= day)

func discover(id: String) -> void:
	if not facts.has(id) or found.has(id):
		return
	found[id] = true
	fact_found.emit(id)

func quota_ids() -> Array:
	return facts.keys().filter(func(k): return facts[k].kind == "quota" and facts[k].day == day)

func quota_done() -> bool:
	return quota_ids().all(func(k): return found.has(k))

func tells_found() -> int:
	return facts.keys().filter(func(k): return facts[k].kind == "tell" and found.has(k)).size()

func sleep() -> void:
	if not quota_done() or day >= TOTAL_DAYS:
		return
	day += 1
	day_changed.emit(day)

func submit_name(guess: String) -> void:
	guess = guess.to_lower().strip_edges()
	var ending := "bad_wrong"
	if guess == "chris":
		ending = "bad_chris"
	elif guess == KILLER and tells_found() >= TELLS_NEEDED:
		ending = "good"
	ending_reached.emit(ending)
