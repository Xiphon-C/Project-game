class_name DocViewer
extends RichTextLabel

func _ready() -> void:
	bbcode_enabled = true
	meta_underlined = true
	meta_clicked.connect(func(meta): Gamestate.discover(str(meta)))
	meta_hover_started.connect(func(_m): mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND)
	meta_hover_ended.connect(func(_m): mouse_default_cursor_shape = Control.CURSOR_ARROW)

func show_doc(doc: Dictionary) -> void:
	var rx := RegEx.create_from_string("\\{\\{(\\w+)\\|([^}]+)\\}\\}")
	text = rx.sub(doc.body, "[url=$1]$2[/url]", true)
