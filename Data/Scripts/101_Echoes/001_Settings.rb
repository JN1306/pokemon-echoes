# ----------------------------------------------------------------------
# General
# ----------------------------------------------------------------------
TELEPORT_MAP    = false
MAX_BONUS_LEVEL = true

# ----------------------------------------------------------------------
# Game Switches
# ----------------------------------------------------------------------
ANTISAVE	            = 299
GHOST_ENCOUNTERS      = 300
SHADOWSWITCH          = 301
CUSTOM_WILD	          = 302
TAKEN_STEP	          = 303
CATCH_BLOCK	          = 304
LETHAL_LOSSES	        = 306
QUEST_TUTORIAL	      = 308
BEING_CHALLENGED      = 310
DISABLE_EXP	          = 311
CAN_SURF	            = 312
CHOSEN_POKEMON	      = 313
GPO_CARD	            = 314
BICYCLE_UPGRADE       = 315
PERMA_SLEEP	          = 316
SOFT_PARALYSIS	      = 317
NO_TELEPORT	          = 320
FORCE_NIGHT           = 321
SHADOW_STORM          = 322
NO_TRAINER_CARD       = 334
NO_SAVE_OPTION        = 335
AURA_CATCH            = 336
AI_CONTROL            = 351
MG_SWAP_USED          = 352
MG_5050_USED          = 353
MG_Q_LOCK             = 354
MG_LIFELINE           = 355
MG_PRE_QUESTION       = 356
MG_CORRECT            = 357
MG_FINAL_ANSWER       = 358
MG_WALK_AWAY          = 359
MG_HARD_MODE          = 360
MG_GAMBLE             = 361
MG_GAMBLE_USED        = 362
MG_PRESSURE           = 363
##################################STORY SWITCHES################################
CS_DEBUG              = 1000
NO_TUTORIALS          = 1001
NO_SHOW_AREA          = 1002
SECOND_PLAYER         = 1003
AURA_PKMN_DISCOVERED  = 1004
ITEM_ORBS_DISCOVERED  = 1005
GROTTOS_DISCOVERED    = 1006
NO_ENCOUNTERS         = 1007
# ------------------------------------------------------------------------------
# OTHER SWITCHES
# ------------------------------------------------------------------------------
GROTTO_WARP           = 1102
GROTTO_EGG            = 1103
GROTTO_SHADOW         = 1104
GROTTO_ECHO           = 1105
GROTTO_SHINY          = 1106
# ------------------------------------------------------------------------------
# TUTORIAL AND SPECIAL ENCOUNTER SWITCHES
# ------------------------------------------------------------------------------
SHADOW_ENCOUNTERS     = 2001
ECHO_ENCOUNTERS       = 2002
# ------------------------------------------------------------------------------
# Random Fun Switches
# ------------------------------------------------------------------------------
FORTUNE_FIN           = 3001
HIDDEN_PKMN           = 3002


################################################################################
# VARIABLES
################################################################################
STARTER_CHOICE      = 7
PLAYER_TEAM         = 26
PLAYER_BAG          = 27
EEVEELUTION         = 32
BATTLE_SIM_AI	      = 36
PLAYER_ROTATION	    = 37
BGM_OVERRIDE	      = 40
TELEPORT_LIST       = 41
TRAINER_ARRAY       = 49
LAST_QUEST	        = 54
LAST_PAGE	          = 55
UNIQUE_LIST         = 56
BONUS_EXP           = 57
SPLASH_SCREEN       = 58
LV_DISPLAY          = 59
EXP_MODIFIER	      = 63
RKS_MEMORY_TYPE	    = 66
LAST_BATTLE_OPTION  = 67
GROTTO_SEEDS        = 86
GROTTO_ENCOUNTER    = 87
AURA_POKEMON        = 99
GLOBAL_TIMER        = 113
MOVEMENT_SPEED      = 114
UNIQUE_POKEMON      = 115
DEBUG_VAR           = 151
QUEST_REW_ID        = 152
CHAPTER_SKIP        = 198
DATA_CHIP_MOVES     = 199
SETUP               = 203
PKMN_STORAGE        = 204         
#-------------------------------------------------------------------------------
# GROTTO / ITEM ORB VARIABLES
#-------------------------------------------------------------------------------
ORB_RARITY            = 502
GROTTO_POKEPOOL       = 503
GROTTO_POKESLOT       = 504
#-------------------------------------------------------------------------------
# Collection Variables
#-------------------------------------------------------------------------------
GROTTOS_FOUND       = 1007
LANDMARKS_FOUND     = 1008
LANDMARK_ID         = 1009
TRADES_DONE         = 1010
TRADE_ID            = 1011
SIDEQUESTS          = 1013
ACHIEVEMENTS        = 1014
MIRACLE_FACTOR      = 1015

#-------------------------------------------------------------------------------
# STORAGE VARIABLES
#-------------------------------------------------------------------------------
CURRENT_CHAPTER   = 2000
CS_TEMP           = 2001
WEATHER_MOD       = 2002
########## PLAYER ###########
STORE_PARTY       = 2003
STORE_BAG         = 2004 
STORE_NAME        = 2005
########## PLAYER 2 ##############
STORE_PARTY_2     = 2006 
STORE_BAG_2       = 2007
PLAYER_CHOSEN     = 2008
PLAYER2_CHOSEN    = 2009
########## MT.BATTLE ##############
MTB_AREAS         = 2501
SINGLETEAM        = 2502
MTB_PUZZLE        = 2503
########## MINI-GAME ##############
MG_Q_ID           = 3001
MG_5050           = 3002
MG_SWAP           = 3003
MG_BET            = 3004
MG_GM             = 3005
MG_Q_LAST         = 3006
QUESTION          = 3007
GAME_STATE        = 3009
ROUND_STATE       = 3010
# ------------------------------------------------------------------------------
# Random Fun Variables
# ------------------------------------------------------------------------------
SHOP_DONATION      = 4001
JOKE_SHOP_STATE    = 4002
################################################################################
#                                 LISTS
################################################################################
SHADOW_SKY_IMMUNE = [
  [772,1]
]

def pbAirbornePokemon
  return [
    PBSpecies::BEEDRILL,
    PBSpecies::IGGLYBUFF,
    PBSpecies::JIGGLYPUFF,
    PBSpecies::WIGGLYTUFF,
    PBSpecies::VENOMOTH,
    PBSpecies::PORYGON,
    PBSpecies::PORYGON2,
    PBSpecies::PORYGONZ,
    PBSpecies::GASTLY,
    PBSpecies::HAUNTER,
    PBSpecies::KOFFING,
    PBSpecies::WEEZING,
    PBSpecies::MEW,
    PBSpecies::MISDREAVUS,
    PBSpecies::UNOWN,
    PBSpecies::CELEBI,
    PBSpecies::DUSTOX,
    PBSpecies::VIBRAVA,
    PBSpecies::FLYGON,
    PBSpecies::LUNATONE,
    PBSpecies::SOLROCK,
    PBSpecies::BALTOY,
    PBSpecies::CLAYDOL,
    PBSpecies::CHIMECHO,
    PBSpecies::LATIAS,
    PBSpecies::LATIOS,
    PBSpecies::JIRACHI,
    PBSpecies::MISMAGIUS,
    PBSpecies::CHINGLING,
    PBSpecies::VESPIQUEN,
    PBSpecies::BRONZOR,
    PBSpecies::BRONZONG,
    PBSpecies::ROTOM,
    PBSpecies::UXIE,
    PBSpecies::MESPRIT,
    PBSpecies::AZELF,
    PBSpecies::CRESSELIA,
    PBSpecies::CRYOGONAL,
    PBSpecies::VICTINI,
    PBSpecies::CUTIEFLY,
    PBSpecies::RIBOMBEE,
    PBSpecies::COSMOG,
    PBSpecies::COSMOEM,
    PBSpecies::LUNALA
    #PBSpecies::PURGALLOS
  ]
end


def pbAirborneEchoForms
  return if !self.pokemon.echo
  return [
    PBSpecies::BUTTERFREE,
    PBSpecies::VENOMOTH,
    PBSpecies::DELIBRD,
    PBSpecies::DUSTOX
  ]
end

def pbRateSharers
  return  [
     0xE8,   # Endure
     0x10C,  # Substitute
     0x809,  # Protection Moves
     0x816,  # Pale Halo
     0x826,  # Don't Shatter
     0x82B,  # Blinded
    ]
end

# ----------------------------------------------------------------------
# Modules
# ----------------------------------------------------------------------
module PBMessages
  
 SurfConfirm       = "The water is a deep blue...\nWould you like to go for a swim?"
 SurfStart         = "You changed to the swimsuit!"
  
  SleepMoveStopped  = "...your anguished cries...find no resonance here..."
  AntiSave        = "The game can't be saved now."
  GhostFight      = "Attacking is futile..."
  GhostSwitch     = "Do you want your friends to suffer?"
  GhostBag        = "Items are useless..."
  GhostAppear     = "A sinister presence approaches..."
  
  ShadowPokemon   = "{1} exudes an unettling aura."
  ShadowPokemon2  = "It is an ??? Pokémon"
  
  # Use {1} to diplay the Pokémon's name
  UniquePokemon   = "{1} is radiating with a strong aura." 
  LevitationTrait = "{1} is levitating!"
end

# TEMPORARY FIX THAT MAKES UNKNOWN POKEMON INTO PORYGON
# REMOVE ONCE PBS FILES ARE UPDATED

module GameData
  module ClassMethods
    # @param other [Symbol, self, String, Integer]
    # @return [self]
    def get(other)
      validate other => [Symbol, self, String, Integer]
      return other if other.is_a?(self)
      other = other.to_sym if other.is_a?(String)
      return get(:PORYGON) unless self::DATA.has_key?(other)
      return self::DATA[other]
    end
  end
  
  module ClassMethodsSymbols
    # @param other [Symbol, self, String]
    # @return [self]
    def get(other)
      validate other => [Symbol, self, String]
      return other if other.is_a?(self)
      other = other.to_sym if other.is_a?(String)
      return get(:PORYGON) unless self::DATA.has_key?(other)
      return self::DATA[other]
    end
  end
end

# TEMPORARY FIX SO pbSpeech DOES NOT CRASH
# NO NAME IS DISPLAYED, THIS SHOULD BE REMOVED

def pbSpeech(a, b=nil, c=nil)
  if c
    pbTalk(c)
  else
    pbTalk(a)
  end
end


class TalkMessageWindows

  alias tmp_display display

  def display(text, idx = -1)
    tmp_display("", idx)
  end

end