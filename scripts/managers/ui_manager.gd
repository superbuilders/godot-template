# ============================================================================
# UI MANAGER - Centralized UI Controller
# ============================================================================
#
# PURPOSE:
# Manager scripts handle ONE specific responsibility in your game. This manager
# controls everything related to the User Interface (UI).
#
# USAGE EXAMPLE:
# From any script in your game:
#     UIManager.show_pause_menu()
#     UIManager.update_health_bar(50)
#     UIManager.display_message("Level Complete!")
#
# COMMON MANAGER TYPES:
# - ui_manager.gd      → Menus, HUD, popups, transitions
# - audio_manager.gd   → Music, sound effects, volume control
# - scene_manager.gd   → Loading scenes, transitions between levels
# - save_manager.gd    → Saving/loading game data to disk
# - particle_manager.gd → Spawning visual effects (explosions, dust, etc.)
# - input_manager.gd   → Custom input handling, rebinding keys
#
# ============================================================================

extends Node

# -----------------------------------------------------------------------------
# REFERENCES
# -----------------------------------------------------------------------------

# UI panel references (set by main.gd)
var main_menu: Control
var game: Control
var version_label: Label:
	set(value):
		version_label = value
		_update_version_label()

# -----------------------------------------------------------------------------
# METHODS
# -----------------------------------------------------------------------------

## Transitions from main menu to game screen.
## MainMenu flies down off screen, Game flies in from above.
func show_game() -> void:
	_animate_panel(main_menu, GameConfig.SCREEN_POS_BELOW)
	_animate_panel(game, GameConfig.SCREEN_POS_CENTER)


## Transitions from game screen back to main menu.
## Game flies up off screen, MainMenu flies back in from below.
func show_main_menu() -> void:
	_animate_panel(main_menu, GameConfig.SCREEN_POS_CENTER)
	_animate_panel(game, GameConfig.SCREEN_POS_ABOVE)


## Quits the game.
func quit_game() -> void:
	get_tree().quit()


## Animates a Control panel to a target position using configured easing.
func _animate_panel(panel: Control, target_pos: Vector2) -> void:
	if not panel:
		return
	
	var tween := create_tween()
	tween.tween_property(
		panel,
		"position",
		target_pos,
		GameConfig.UI_ANIMATION_DURATION
	).set_ease(GameConfig.UI_ANIMATION_EASE).set_trans(GameConfig.UI_ANIMATION_TRANS)


## Updates the version label with the version from project settings.
func _update_version_label() -> void:
	if not version_label:
		return
	
	var version: String = ProjectSettings.get_setting("application/config/version", "0.0")
	version_label.text = version

