# Godot Beginner's Guide & Template

## Table of Contents

- [Godot IDE Settings](#godot-ide-settings)
- [Project Structure](#project-structure)
- [Recommended Workflow](#recommended-workflow)
- [Tips & Tricks](#tips--tricks)
- [Included In This Template](#included-in-this-template)

---

## Godot IDE Settings
### 🤖 If working with another editor (like Cursor), these settings are recommended:

* **Editor Settings > Text Editor > Behavior > Files > Auto Reload Scripts on External Change**
* **Editor Settings > Interface > Editor > Save on Focus Loss**
* **Editor Settings > Interface > Editor > Import Resources When Unfocused**

These settings help update both editors without a confirmation window.

### ⚙️ Recommended project settings

* **Project Settings > Display > Window:**
    * **Viewport Width: 1920**
    * **Viewport Height: 1080**
    By default, the resolution is 1152x648, so you ought to change this to match your desired resolution.
    * **Mode: viewport**
    * **Aspect: expand**
* **Project Settings > Rendering > Textures > Default Texture Filter > Nearest**
The `nearest` filter is borderline ESSENTIAL for games that include pixel art.



## Project Structure

The following are some guidelines on how I prefer to structure my projects after much experience LLM-coding with Cursor and Godot.

**Here is an example of a project:**

```
project_root/
├── assets/                    # All your game's media files
│   ├── sprites/               # Images, textures, pixel art
│   ├── audio/                 # Music and sound effects
│   ├── fonts/                 # Custom fonts
│   └── ...
│
├── scenes/                    # Your .tscn scene files
│   ├── main.tscn              # Main game scene
│   ├── ui/                    # UI-related scenes
│   ├── levels/                # Level scenes
│   └── ...
│
├── scripts/                   # All your .gd script files
│   ├── game_config.gd         # Global constants & variables
│   ├── managers/              # Manager singletons
│   │   ├── ui_manager.gd
│   │   ├── audio_manager.gd
│   │   ├── particle_manager.gd
│   │   └── ...
│   └── ...
│
└── project.godot              # Godot project file
```

---

### 📁 Folders Explained

| Folder | Purpose |
|--------|---------|
| `assets/` | Store all non-code files here—sprites, audio, fonts, etc. Keeping media separate from code makes your project easy to navigate. |
| `scenes/` | Contains `.tscn` files (Godot scenes). Think of scenes as "prefabs" or reusable building blocks—a player, an enemy, a UI menu, a whole level. |
| `scripts/` | All your GDScript `.gd` files live here. Scripts define behavior and logic for your game. |

---

### 📄 The `game_config.gd` File

This is your **single source of truth** for game-wide constants and variables.

**Example config:**

```gdscript
# scripts/game_config.gd
extends Node

# Player settings
const PLAYER_SPEED := 200.0
const PLAYER_MAX_HEALTH := 100

# Game settings
const GRAVITY := 980.0
const TILE_SIZE := 16

# Runtime variables (can change during gameplay)
var current_score := 0
var is_paused := false
```

**Why do this?**
- ✅ Change a value in ONE place, and it updates everywhere
- ✅ No magic numbers scattered throughout your code
- ✅ Easy to tweak and balance your game
- ✅ Other scripts can access values via `GameConfig.PLAYER_SPEED`

---

### 🎛️ Manager Scripts

Managers are scripts that handle **one specific responsibility** in your game. They act as centralized controllers.

| Manager | Responsibility |
|---------|----------------|
| `ui_manager.gd` | Show/hide menus, update HUD, handle UI transitions |
| `audio_manager.gd` | Play music, sound effects, control volume |
| `particle_manager.gd` | Spawn particle effects (explosions, dust, sparkles) |
| `save_manager.gd` | Save/load game data to disk |
| `scene_manager.gd` | Handle scene transitions and loading screens |

**Example manager:**

```gdscript
# scripts/managers/audio_manager.gd
extends Node

@onready var music_player := $MusicPlayer
@onready var sfx_player := $SFXPlayer

func play_music(track: AudioStream) -> void:
	music_player.stream = track
	music_player.play()

func play_sfx(sound: AudioStream) -> void:
	sfx_player.stream = sound
	sfx_player.play()

func stop_music() -> void:
	music_player.stop()
```

---

### ⚡ Autoload Singletons (The Glue)

**What is an Autoload?**
An Autoload is a script (or scene) that Godot loads **automatically** when your game starts. It stays in memory for the entire game session and can be accessed from **any** script.

**How to set up Autoloads:**
1. Go to **Project → Project Settings → Globals (Autoload tab)**
2. Add your script and give it a name (e.g., `GameConfig`, `AudioManager`)
3. Make sure "Enable" is checked

**Example Autoload setup:**

| Path | Node Name |
|------|-----------|
| `res://scripts/game_config.gd` | `GameConfig` |
| `res://scripts/managers/ui_manager.gd` | `UIManager` |
| `res://scripts/managers/audio_manager.gd` | `AudioManager` |
| `res://scripts/managers/particle_manager.gd` | `ParticleManager` |

**Why use Autoloads?**
- ✅ Access from anywhere: `AudioManager.play_sfx(explosion_sound)`
- ✅ Managers can call each other: `UIManager` can tell `AudioManager` to play a click sound
- ✅ Persist across scene changes (perfect for scores, player data, settings)
- ✅ No need to pass references or use `get_node()` chains

**Example usage in any script:**

```gdscript
func _on_coin_collected() -> void:
	GameConfig.current_score += 10
	AudioManager.play_sfx(coin_sound)
	UIManager.update_score_display()
	ParticleManager.spawn_sparkles(global_position)
```

---

### 🧠 The Big Picture

```
┌─────────────────────────────────────────────────────────┐
│                    YOUR GAME                            │
├─────────────────────────────────────────────────────────┤
│                                                         │
│   ┌──────────────┐    ┌──────────────┐                  │
│   │  GameConfig  │◄───│  Any Script  │                  │
│   │  (constants) │    │  in your     │                  │
│   └──────────────┘    │  game can    │                  │
│                       │  access      │                  │
│   ┌──────────────┐    │  these       │                  │
│   │ AudioManager │◄───│  Autoloads!  │                  │
│   └──────────────┘    └──────────────┘                  │
│                                                         │
│   ┌──────────────┐    ┌──────────────┐                  │
│   │  UIManager   │◄──►│ParticleManager│                 │
│   └──────────────┘    └──────────────┘                  │
│         ▲                    ▲                          │
│         │    Managers can    │                          │
│         └────call each other─┘                          │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

This architecture keeps your code **organized**, **modular**, and **easy to debug**. When something goes wrong with audio, you know exactly where to look: `audio_manager.gd`.



## Recommended Workflow

As a general rule, I edit the scenes and let my LLM edit the scripts. In other words, I make it look pretty and Claude makes it work. While LLMs _can_ do it and have gotten better, I find that they struggle to edit scenes and scene structure to my liking. It is *IMPORTANT* to note that I, personally, prefer tweaking UI with extreme granularity. Therefore, this rule may not be as pressing for most people. However, given that scene configuration lays at the foundation of any Godot game (especially for building at scale), it is important to at least understand it.

Typically, if you are creating any sort of game asset or level (tileset, UI element, menu, etc.), I would recommend doing this manually. This will likely be the primary learning curve for Godot beginners and vibecoders.

**If you're new to Godot and would like a walkthrough to familiarize yourself with its IDE, Brackeys' tutorial is a great place to start:**

https://www.youtube.com/watch?v=LOhfqjmasi0

### Example Of My Workflow

Let's say I wanted to create a main menu for my game. My workflow would look something like this:

**1. Create a main menu scene or node**

Standard, simpler practice is to create a separate scene `main_menu.tscn` for a main menu and then transition between scenes. However, I often prefer simply adding a Control node to my `main.tscn` and toggling its visibility/position for a smoother UX.

**2. Place UI elements**

I then create scenes as children of the main menu for the title, buttons and any other information I want. I will also place my background.

**3. Make tweaks**

I will run the game to test whether or not the UI looks and feels right, ensuring I avoid excessive amounts of open space and center the player's focus on important information.

**4. Make it work**

I will give Claude specific instructions (citing specific nodes as needed) on making the main menu function, such as making clicking the play button go to `main.tscn` (or trigger the desired animation/visibility) and making the quit button quit.

**Conclusion**

I make the menu look and feel how I want, then I have Claude plug in functionality to my elements. To make a web development analogy: I do the "front end" and Claude handles the "back end".



## Tips & Tricks

### Functional

* **When creating something in-game via script (like a node, scene, particles, etc.), create them as children of a pre-created node in your scene.**

The purpose of this is to avoid unintended z-index issues and foster better organization in general. The lazy way to solve this is to set the z index property of something every time it is created (this is how Claude likes to do it). However, this can QUICKLY become unmanageable, especially for code-created things. Creating aptly named Node2D nodes in your scene and telling Claude to create whatever it's creating as children of this node is much more manageable.

This way, you can easily handle the z index of everything in your game, solving a common nuisance for developers.

* **When making a custom, multinode element (like a UI element), it is usually better to create a scene.**

For example, let's say I wanted to create a series of panels in my UI. Instead of creating a node in my scene for each panel (each with all of their children), I would create a scene for a single, modular panel and customize them in the parent scene as needed.

This way, you can make tweaks to the scene itself without needing to change a specific child of each node for that re-used element.

Generally speaking, if you find yourself making multiple nested nodes for the same thing, you should probably make it a scene.



### Aesthetic

* **Use Godot's Tweens to create smooth animations.**

I use Godot's Tween.EASE_OUT a _LOT_. It is very useful for creating smooth position change animations and is highly configurable as you can set the duration of the animation. It is very common for my projects to have many "duration" variables in `game_config.gd` that control the timespan of various animations throughout my game.

These animations give the game a smooth and professional feel.



## Included In This Template

### 🎬 Scenes

| Scene | What It Is |
|-------|------------|
| `main.tscn` | The main scene that runs when your game starts. Contains a **MainMenu** panel (with title, play/quit buttons, version label) and a **Game** panel (placeholder for your game content). These panels slide in/out with smooth animations. Think of it as a "two-page app" where clicking Play slides you from page 1 to page 2. |
| `button_modular.tscn` | A reusable, customizable button component. This addresses a common pain point I run into of button text not working how I want without sufficient padding options. |

---

### 📜 Scripts

| Script | What It Does |
|--------|--------------|
| `main.gd` | The "controller" for the main scene. It connects buttons to actions—when you click Play, it tells `UIManager` to show the game; when you click Quit, it closes the app. Think of it as the wiring that makes your buttons actually do something. |
| `game_config.gd` | Your game's "settings file." Stores constants like screen positions (`SCREEN_POS_CENTER`, `SCREEN_POS_ABOVE`) and animation settings (`UI_ANIMATION_DURATION`). Change a value here, and it updates everywhere—no hunting through multiple files. |
| `button_modular.gd` | The brains behind the modular button. Uses `@export` variables so you can customize each button instance directly in the Inspector (no code needed). The `@tool` annotation means changes appear live in the editor—you see your button update as you tweak it. |

---

### 🎛️ Manager Scripts (Autoloads)

These are "always-on" scripts that Godot loads automatically at startup. Access them from anywhere using their name (e.g., `AudioManager.play_hover()`).

| Manager | Responsibility |
|---------|----------------|
| `ui_manager.gd` | Handles UI transitions. When you call `UIManager.show_game()`, it animates the MainMenu sliding down and the Game panel sliding in from above using Tweens. All animation settings come from `GameConfig`. |
| `audio_manager.gd` | Plays sound effects. Uses an **audio pool** (8 audio players) so multiple sounds can play simultaneously without cutting each other off. Preloads the hover and select sounds so there's no delay when playing them. |

---

### 🎨 Assets

#### Fonts
| File | Description |
|------|-------------|
| `m6x11.ttf` | A crisp pixel art font. Perfect for retro-style games where you want that classic 8-bit text look. |

#### Label Settings
Pre-configured text styles that combine the font with specific sizes and outlines. Apply them to any Label node for instant, consistent text styling.

| Setting | Font Size | Use Case |
|---------|-----------|----------|
| `Small.tres` | 32px | Version numbers, fine print |
| `Medium.tres` | 64px | General UI text |
| `Big.tres` | 128px | Button text, subtitles |
| `Huge.tres` | 256px | Main titles |

#### Sounds
| Sound | When It Plays |
|-------|---------------|
| `Hover.wav` | Mouse enters a button (gives feedback that it's clickable) |
| `Select.wav` | Button is clicked (confirms the action) |

#### Sprites
| Sprite | Purpose |
|--------|---------|
| `Space Background.png` | A space backdrop used in `main.tscn` |
| `Button 9slice.png` | A texture for buttons that scales without distortion. "9-slice" means Godot stretches the middle but keeps corners crisp—like stretching a picture frame without warping the corners. |

#### Theme
| File | What It Does |
|------|--------------|
| `Classic.tres` | A Theme resource that applies the 9-slice button texture to all buttons. Defines how buttons look in 4 states: normal, hover, pressed, and disabled. Apply this theme to a parent node, and all child buttons inherit the style automatically. |

---

### ⚙️ Project Configuration

The `project.godot` file comes pre-configured with:

- **Resolution:** 1920×1080 (Full HD)
- **Stretch Mode:** `viewport` with `expand` aspect (scales cleanly on different screen sizes)
- **Texture Filter:** `Nearest` (keeps pixel art sharp instead of blurry)
- **Autoloads:** `GameConfig`, `UIManager`, and `AudioManager` are already registered and ready to use
- **Custom Splash Screen:** A branded loading image (`splashscreen.png`)

---

### 🔄 How It All Works Together

1. **Game starts** → Godot loads the autoloads (`GameConfig`, `UIManager`, `AudioManager`)
2. **`main.tscn` loads** → `main.gd` registers the UI panels with `UIManager` and connects button signals
3. **Player hovers a button** → `button_modular.gd` calls `AudioManager.play_hover()`
4. **Player clicks Play** → `main.gd` calls `UIManager.show_game()` → `UIManager` animates both panels using settings from `GameConfig`
5. **Player clicks Back** → Same flow, but `UIManager.show_main_menu()` reverses the animation

This separation keeps your code organized: UI logic in `UIManager`, audio logic in `AudioManager`, constants in `GameConfig`, and wiring in `main.gd`.
