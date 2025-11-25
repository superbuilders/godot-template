@tool
extends Button

## Modular button with inspector-configurable properties.

@export_multiline var button_text: String = "":
	set(value):
		button_text = value
		_apply_button_text()

@export var button_size: Vector2 = Vector2(96, 96):
	set(value):
		button_size = value
		_apply_size()

@export var button_color: Color = Color.WHITE:
	set(value):
		button_color = value
		_apply_button_color()

@export var text_color: Color = Color.WHITE:
	set(value):
		text_color = value
		_apply_text_color()

@export var label_settings: LabelSettings:
	set(value):
		label_settings = value
		_apply_label_settings()

@export var text_offset: Vector2 = Vector2.ZERO:
	set(value):
		text_offset = value
		_apply_text_offset()

@onready var _text_label: Label = $Text


func _ready() -> void:
	_apply_all_properties()
	
	# Connect button signals for audio feedback (only in game, not in editor)
	if not Engine.is_editor_hint():
		mouse_entered.connect(_on_mouse_entered)
		pressed.connect(_on_pressed)


func _on_mouse_entered() -> void:
	AudioManager.play_hover()


func _on_pressed() -> void:
	AudioManager.play_select()


func _apply_all_properties() -> void:
	_apply_size()
	_apply_button_color()
	_apply_text_color()
	_apply_label_settings()
	_apply_text_offset()
	_apply_button_text()


func _apply_size() -> void:
	custom_minimum_size = button_size
	size = button_size
	
	var text_label := _get_text_label()
	if text_label:
		# Set anchors to fill parent (full rect)
		text_label.anchor_left = 0.0
		text_label.anchor_top = 0.0
		text_label.anchor_right = 1.0
		text_label.anchor_bottom = 1.0
		# Reset offsets (text_offset is applied separately)
		text_label.offset_left = 0.0
		text_label.offset_top = 0.0
		text_label.offset_right = 0.0
		text_label.offset_bottom = 0.0
		# Re-apply text offset after resetting
		_apply_text_offset()


func _apply_button_color() -> void:
	self_modulate = button_color


func _apply_text_color() -> void:
	var text_label := _get_text_label()
	if text_label:
		text_label.self_modulate = text_color


func _apply_label_settings() -> void:
	var text_label := _get_text_label()
	if text_label:
		text_label.label_settings = label_settings


func _apply_text_offset() -> void:
	var text_label := _get_text_label()
	if text_label:
		# Apply offset via the anchor offsets
		text_label.offset_left = text_offset.x
		text_label.offset_top = text_offset.y
		text_label.offset_right = text_offset.x
		text_label.offset_bottom = text_offset.y


func _apply_button_text() -> void:
	var text_label := _get_text_label()
	if text_label:
		text_label.text = button_text


func _get_text_label() -> Label:
	# In editor, @onready hasn't run yet, so we need to get the node directly
	if Engine.is_editor_hint():
		if has_node("Text"):
			return get_node("Text") as Label
		return null
	return _text_label
