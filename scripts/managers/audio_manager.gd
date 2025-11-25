# ============================================================================
# AUDIO MANAGER - Centralized Audio Controller
# ============================================================================
#
# PURPOSE:
# Manager scripts handle ONE specific responsibility in your game. This manager
# controls everything related to Audio (music, sound effects, volume).
#
# USAGE EXAMPLE:
# From any script in your game:
#     AudioManager.play_hover()
#     AudioManager.play_select()
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
# CONSTANTS
# -----------------------------------------------------------------------------

const SFX_BUS := &"SFX"
const MUSIC_BUS := &"Music"

# Preload sound effects
const HOVER_SOUND := preload("res://assets/sounds/Hover.wav")
const SELECT_SOUND := preload("res://assets/sounds/Select.wav")

# Number of audio players in the pool (allows this many simultaneous sounds)
const SFX_POOL_SIZE := 8

# -----------------------------------------------------------------------------
# REFERENCES
# -----------------------------------------------------------------------------

var _sfx_pool: Array[AudioStreamPlayer] = []
var _sfx_pool_index: int = 0

# -----------------------------------------------------------------------------
# LIFECYCLE
# -----------------------------------------------------------------------------

func _ready() -> void:
	_create_sfx_pool()


func _create_sfx_pool() -> void:
	for i in SFX_POOL_SIZE:
		var player := AudioStreamPlayer.new()
		player.bus = SFX_BUS
		add_child(player)
		_sfx_pool.append(player)

# -----------------------------------------------------------------------------
# METHODS
# -----------------------------------------------------------------------------

## Plays the hover sound effect.
func play_hover() -> void:
	_play_sfx(HOVER_SOUND)


## Plays the select/click sound effect.
func play_select() -> void:
	_play_sfx(SELECT_SOUND)


## Internal method to play a sound effect using the pool.
## Uses round-robin to cycle through players, allowing multiple simultaneous sounds.
func _play_sfx(sound: AudioStream) -> void:
	var player := _sfx_pool[_sfx_pool_index]
	player.stream = sound
	player.play()
	_sfx_pool_index = (_sfx_pool_index + 1) % SFX_POOL_SIZE
