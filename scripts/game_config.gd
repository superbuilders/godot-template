# ============================================================================
# GAME CONFIG - Your Single Source of Truth
# ============================================================================
#
# PURPOSE:
# This file stores ALL global constants and variables for your game in one
# centralized location. Think of it as your game's "settings file."
#
# USAGE EXAMPLE:
# In any other script, you can now write:
#     var speed = GameConfig.PLAYER_SPEED
#     GameConfig.current_score += 10
#
# ============================================================================

extends Node

# -----------------------------------------------------------------------------
# CONSTANTS (values that never change during gameplay)
# -----------------------------------------------------------------------------

# Use UPPER_SNAKE_CASE for constants
# Use := for type inference

# Example player constants:
# const PLAYER_SPEED := 200.0
# const PLAYER_JUMP_FORCE := 400.0
# const PLAYER_MAX_HEALTH := 100

# Example physics constants:
# const GRAVITY := 980.0
# const TILE_SIZE := 16

# Example game constants:
# const MAX_ENEMIES := 50
# const RESPAWN_TIME := 3.0

# Screen positions for UI panels (fly in/out animations)
const SCREEN_POS_CENTER := Vector2(0, 0)
const SCREEN_POS_ABOVE := Vector2(0, -1080)
const SCREEN_POS_BELOW := Vector2(0, 1080)

# UI animation settings
const UI_ANIMATION_DURATION := 0.25
const UI_ANIMATION_EASE := Tween.EASE_OUT
const UI_ANIMATION_TRANS := Tween.TRANS_CUBIC

# -----------------------------------------------------------------------------
# VARIABLES (values that CAN change during gameplay)
# -----------------------------------------------------------------------------

# Use lower_snake_case for variables

# Example runtime variables:
# var current_score := 0
# var is_paused := false
# var player_health := PLAYER_MAX_HEALTH
# var current_level := 1

