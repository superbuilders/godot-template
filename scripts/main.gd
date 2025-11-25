extends Control

## Main scene controller - connects UI elements to UIManager.

@onready var main_menu: Control = $MainMenu
@onready var game: Control = $Game

@onready var version_label: Label = $MainMenu/Version

@onready var button_play: Button = $MainMenu/ButtonPlay
@onready var button_quit: Button = $MainMenu/ButtonQuit
@onready var button_back: Button = $Game/ButtonBack


func _ready() -> void:
	# Register UI elements with UIManager
	UIManager.main_menu = main_menu
	UIManager.game = game
	UIManager.version_label = version_label
	
	# Connect button signals
	button_play.pressed.connect(_on_play_pressed)
	button_quit.pressed.connect(_on_quit_pressed)
	button_back.pressed.connect(_on_back_pressed)


func _on_play_pressed() -> void:
	UIManager.show_game()


func _on_quit_pressed() -> void:
	UIManager.quit_game()


func _on_back_pressed() -> void:
	UIManager.show_main_menu()
