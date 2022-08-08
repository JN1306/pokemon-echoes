module Supplementals

  #=============================================================================
  ### UI ###
  #=============================================================================

  # Pockets and additional info for the Supplementals Bag screen, featuring favorites
  def self.bag_pocket_names
    return [
      _INTL("Items"),
      _INTL("Medicine"),
      _INTL("Poké Balls"),
      _INTL("Held Items"),
      _INTL("Favorites"),
      _INTL("Battle Items"),
      _INTL("TMs & HMs"),
      _INTL("Berries"),
      _INTL("Key Items")
    ]
  end
  BAG_MAX_POCKET_SIZE = [0, -1, -1, -1, -1, -1, -1, -1, -1, -1]
  BAG_POCKET_AUTO_SORT = [0, false, false, false, false, false, false, true, false, false]

  #=============================================================================
  ### OVERWORLD OPTIONS ###
  #=============================================================================

  # Tweak certain ingame parameters to work best for 60fps
  # Graphics.frame_rate needs to be changed separately
  FRAME_RATE_60 = true

  # Whether to use an ingame time system instead of the real world clock
  USE_INGAME_TIME = true

  # Show player running animation slower. Certain overworld sprites are intended to take long leaps
  SLOWER_RUNNING_ANIMATION = true

  # Give drop shadows to all events with "NPC", "trainer", "pkmn" or "member" in their character sprite name
  CHARACTER_DROP_SHADOWS = true
  
  # Disable random encounters to instead have visible pokemon in the overworld using icons from the party screen
  OVERWORLD_POKEMON = true

  # Experimental. Currently very slow and incomplete. Do not enable
  COMPRESS_MAPS = false

  # How many pixels will be faded from the bottom of an event's sprite when submerged in bushes and swamps
  BUSH_DEPTH = 12
  SWAMP_DEPTH = 10
  
  # Whether the player will attempt to move down one tile when starting to surf or up one when stopping, to simulate a height difference
  HIGH_WATER_EDGES = true

  # Whether or not Essentials should automatically rewrite door events, which may make them incorrect in special cases
  REWRITE_DOOR_EVENTS = false

  #=============================================================================
  ### BATTLE OPTIONS ###
  #=============================================================================
  # Whether battles should use the double battle format by default instead of singles
  DEFAULT_DOUBLE_BATTLE = true

  # Whether to use new Supplementals battle AI that considers the combination of moves
  # as well as hitting the partner with beneficial moves.
  USE_NEW_BATTLE_AI = true

  # Whether to write battle logs to the Logs directory.
  # Only writes logs when using new battle AI, and for trainers and smart AI wild battles.
  WRITE_BATTLE_LOGS = true

  # Allows a Pokémon to have more than 100% HP
  # A Pokémon cannot heal up past their current HP layer
  ALLOW_HP_LAYERS = true
  # Whether a Pokémon can heal within it's current HP layer
  # e.g. heal from 120% to 170% with Recover, but cap at 200% when healing from 170%
  ALLOW_HEALING_WITHIN_LAYER = true
  # Whether a player can catch a Pokémon above 100% HP or not
  CAN_CATCH_POKEMON_ABOVE_MAX_HP = false

  # Write the percentage of the opponents' HP on their HP bars.
  # Should definitely be enabled if hp layers are enabled and in active use
  SHOW_OPPOSING_HP_PERCENT = true

  # Show a Fire Emblem inspires animation before a Pokémon attacks with a Critical Hit
  CRITICAL_ANIMATION = true
  # Show a splash on the target as they take damage to indicate critical hits and type effectiveness
  CRITICAL_SPLASH = true
  WEAKNESS_SPLASH = true
  RESISTED_SPLASH = true
  # Whether or not to show the regular message boxes telling the player about criticals and type effectiveness
  SHOW_CRITICAL_MESSAGE = !CRITICAL_SPLASH
  SHOW_WEAKNESS_MESSAGE = !WEAKNESS_SPLASH
  SHOW_RESISTED_MESSAGE = !RESISTED_SPLASH

  # Show the shadows for battlers even if they are grounded
  ALWAYS_SHOW_BATTLER_SHADOW = true

  ### MOVE, ABILITY AND ITEM CHANGES ###

  # Grass pelt doubles healing from Grassy Terrain
  GRASS_PELT_BUFF = true

  # Forecast buffs to have Castform not take damage from the weather that does not actually change its form
  FORECAST_BLOCKS_WEATHER_DAMAGE = true
  FORECAST_BLOCKS_SHADOW_SKY_DAMAGE = false

  # If Run Away should stop the Pokémon from being trapped.
  RUN_AWAY_CERTAIN_SWITCHING = true

  # If Illuminate should halve damage taken by Dark-type moves
  ILLUMINATE_DARK_RESIST = true

  ### Extra type effects akin to how Poions-types skip accuracy checks for Toxic
  # Electric-types skip accuracy checks for Thunder Wave
  PARALYZE_TYPE_EFFECT = true
  # Fire-types skip accuracy checks for Will-o-Wisp (and other burn status moves if added)
  BURN_TYPE_EFFECT = true
  # Grass-types skip accuracy checks for Leech Seed
  LEECH_SEED_TYPE_EFFECT = true

  # Whether or not regular wild Pokemon should be scaled to the player level
  SCALE_WILD_POKEMON = false
  # How many levels below the player level a wild Pokémon must be before scaling is applied
  WILD_POKEMON_LEVEL_DIFFERENCE = 5
  # The maximum levels a wild Pokémon's level can increase from scaling
  WILD_POKEMON_MAX_SCALING = 10
  # The change for a Pokémon to evolve when scaled to a level where it could have evolved
  # Can make the Pokémon evolve multiple times
  WILD_POKEMON_EVOLVE_CHANCE = 0.5
  # How many levels a wild Pokémon must be above its required evolution level to evolve during scaling
  WILD_POKEMON_EVOLVE_EXTRA_LEVELS = 0

  # Whether or not to evolve trainer Pokémon during level scaling
  TRAINER_POKEMON_EVOLVE = false
  # How many levels a trainer Pokémon must be above its required evolution level to evolve during scaling
  TRAINER_POKEMON_EVOLVE_EXTRA_LEVELS = 4
  # How many recent scaled trainer levels to remember before disposing old ones.
  # Used to make a trainer not suddenly change levels if you do a battle or two before rechallenging them
  MAX_RECENT_TRAINERS = 16

  #=============================================================================
  ### MESSAGES ###
  #=============================================================================

  # The width of the standard message windows from pbMessage
  MESSAGE_WINDOW_WIDTH = 512

  # Use a hard-coded font with drawing instructions rather than the regular font
  USE_HARD_CODED_FONT = true

  # Whether you can hold cancel to automatically close messages as they finish
  TEXT_SKIP_WITH_CANCEL = true

  # When using pbDialog, the amount of frames to wait between each message showing up
  DIALOG_WAIT_BETWEEN_MESSAGES = 0
  # When using pbDialog, the amount of frames to wait between messages when the speaker changes
  DIALOG_WAIT_BETWEEN_SPEAKERS = 4

  #=============================================================================
  ### GAME SWITCHES ###
  #=============================================================================

  MAP_UPDATE            = 67  # Used for a common event to check quest updates and such
  HIDE_REFLECTIONS      = 117 # Toggle when a map has unwanted reflections
  HIDE_MARKERS          = 68

  #=============================================================================
  ### GAME VARIABLES ###
  #=============================================================================

  WILD_MODIFIER         = 80  # Used for pbModifier to tweak the next upcoming wild battle
  BOSS_BATTLE           = 85  # Used for pbBoss to create custom scripted boss battles
  TIME_AND_DAY          = 90  # Used to store the in-game time (if using in-game time is enabled)
  BOSSES_DEFEATED       = 87  # Dictionary of all defeated bosses
  SAVED_CHOICES         = 59  # A dictionary of saved choice from pbDialog
  PLAYER_LEVEL          = 48  # An exponentially weighted moving average, used in Battle/ScaleLevel
  RECENT_TRAINERS       = 113 # List of the level scaling for recently battled trainers
  GUIDE_LIST            = 114
  NEW_GUIDE             = 115
  LAST_GUIDE            = 116

end