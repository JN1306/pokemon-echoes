#---------------------------------------------------------
# Add more "pbAddUniquePokemon" scripts to the "pbInitUniquePokemon" section
# to add more unique pokemon to the unique dex.
#
# COMMANDS
# - pbRegisterUniquePokemonSeen(name) Register that the pokemon has been
#   encountered, but not yet defeated
# - pbRegisterUniquePokemonDefeated(name) Register that a the player
#   have beaten a unique pokemon
# - pbUniquePokemonSeen(name) Used in conditional branches
#   to check if a unique pokemon is seen yet.
# - pbUniquePokemonDefeated(name) Used in conditional branches
#   to check if a unique pokemon is defeated yet.
#---------------------------------------------------------

def pbInitUniquePokemon
  
  if !pbGet(UNIQUE_LIST).is_a?(Hash)
    pbSet(UNIQUE_LIST, {})
  end
  
  # Adds a unique pokemon with one description page
  #pbAddUniquePokemon("name", :SPECIES, "location",[
  #  "description"])
  
  # Adds a unique pokemon with more description pages
  #pbAddUniquePokemon("name", :SPECIES, "location",[
  #  "description page 1",
  #  "page 2",
  #  "page 3",
  #  "etc."])
  pbAddUniquePokemon("Tester Test", :DITTO, "Debug",[
    "For debugging purposes only"])
  #=============================================================================
  # Story Required
   #============================================================================
  pbAddUniquePokemon("Striding Gerid", :SURSKIT, "Secluded Grove",[
  "Surskit are usually a passive species. Striding Gerid is an exception as it grew much stronger than other Surskit and became the protector in the Secluded Grove.",
  "LV: 4 Boost: Speed + 1 HP: 63 ATK: 11 DEF: 11 Sp.ATK: 12 Sp.DEF: 12 Speed: 13.",
  "Skill: Rainmaker. Summon rain for 5 turns at the start of the battle."])    
  #=============================================================================
  # Non-Story Required
  #=============================================================================
  pbAddUniquePokemon("Hill-arious Juko", :TREECKO, "Fukuri Outskirts",[
  "Ususally seen on Mirin Road. Its aura makes the sun shine bright."])
  
  pbAddUniquePokemon("Slender Surumaya", :TANGELA, "Mirin Road",[
  "Ususally seen on Mirin Road. Their aura makes the sun shine bright."])

  pbAddUniquePokemon("Rainbow-Core Prismallon", :STARMIE, "???",[
  "...",
  ])
  
  pbAddUniquePokemon("Peppy Liella", :PICHU, "Iphondria City",[
  "A peppy little tyke that loves to roam about in Iphondria City. They are quite affectionate.",
  "LV: 14 Boost: Sp.Atk + 1 HP: 63 ATK: 11 DEF: 11 Sp.ATK: 12 Sp.DEF: 12 Speed: 13.",])

  pbAddUniquePokemon("Uncertain Dolly", :FLAAFFY, "Pharoday Island",[
  "A strange Flaaffy that make their living on Pharoden Island. Rumor has it they were subjected to cloning experiments."])
    
  pbAddUniquePokemon("Dragon-Singer Hymaria", :ALTARIA, "???",[
  "...",
  "Phases: II (Stats)",
  "Skill: Double Attack: Uses a random move from their moveset at the end of each turn",
  "Skill 2 : Dragon Song: Raises user's Sp.Atk and Speed every 4 turns.",
  "Phase II Skill: Power Hymn: Deals 20 damage to a non-soundproofed target every turn" 
  ])
  
  pbAddUniquePokemon("Operative Chulon", :SHELLOS, "Iphondria Park",[
  "..."])
  
  pbAddUniquePokemon("Territorial Rotmian", :DARMANITAN, "Crossroads",[
  "A wandering Pokémon who has terrified many first-time visitor to the Crossroads"])

  pbAddUniquePokemon("Combative Adalegh", :CARBINK, "Caeli Caves",[
  "One of the seven envoys of the lost kingdom of Insilmira."])
  
  pbAddUniquePokemon("Smoke-Tail Micador", :REVAGLO, "Caeli Caves",[
  "A playful little critter living in Caeli Caves. Sometimes the monks comes to feed them."])
  
  pbAddUniquePokemon("Flame-Tail Micador", :REVULTRE, "Caeli Caves",[
  "Having experienced many battles. Micador evolved and is now a proud protector of Caeli Caves aiding the Ignis Caely in their efforts."])
  #=============================================================================
  pbAddUniquePokemon("Loyal Jikuden", :MAGNEMNITE, "Power Plant",[
  "An important asset to the Western Sea Power Plant."])

  pbAddUniquePokemon("Silent Irys", :AXEW, "Irys' Tomb",[
  "The trusted partner of the Solrin Sage Irys, now long deceased."])
  
  pbAddUniquePokemon("Radiant Solmir", :LARVESTA, "Shinra Ruins",[
  "Remnant of the Solrin civilization."])
  
  pbAddUniquePokemon("Reticent Yumen", :YAMASK, "Prayer Chamber.",[
  "Manifestation of the lingering regret of one of the Solrin Sage Yumen."])
  
  pbAddUniquePokemon("Channeling Condusei", :STARYU, "Conduit Rock",[
  "Occasionally appears at Conduit Rock."])

  pbAddUniquePokemon("Dizzying Razmin", :SPINDA, "Crossroads",[
  "Guards the tomb of the Solrin Sage Razmin"])
  
  pbAddUniquePokemon("Glorious Vulcan", :TALONFLAME, "Caeli Desert",[
  "A Pokémon reverred by the Ignis Caeli."])
  
  pbAddUniquePokemon("Primordial Laia", :MANTINE, "???",[
  "???"])
  
  pbAddUniquePokemon("Ceslestial Dreamia", :RAPIDASH, "Cedarwyn Forest",[
  "A guardian of the ancient Cedarwyn Forest"])
  
  pbAddUniquePokemon("Accidental Mika", :VULPIX, "Cedarwyn Forest",[
  "A Pokémon reverred by the Ignis Caeli."])

  pbAddUniquePokemon("Valorous Remystrum", :VIRIZION, "Aravalor Altar",[
  "One of three sacred paladins sworn to prorect the Cedaria Kingdom."])
  
  pbAddUniquePokemon("Honorable Eldtigrus", :COBALION, "Arahonos Altar",[
  "One of three sacred paladins sworn to prorect the Cedaria Kingdom."])
  
    pbAddUniquePokemon("Vengeful Tenestrum", :BARBARACLE, "Cedaria Castle",[
  "???"])
  
end

def pbAddUniquePokemon(name, species, location, description)
  pkmn = UniquePokemon.new(name, species, location, description)
  
  if !pbGet(UNIQUE_LIST)[name]
    $game_variables[UNIQUE_LIST][name]=pkmn
  else
    $game_variables[UNIQUE_LIST][name].name        = name
    $game_variables[UNIQUE_LIST][name].species     = species
    $game_variables[UNIQUE_LIST][name].location    = location
    $game_variables[UNIQUE_LIST][name].description = description
  end
  
end

def pbUniquePokemon(name)
  return pbGet(UNIQUE_LIST)[name]
end

def pbRegisterUniquePokemonSeen(name)
  $game_variables[UNIQUE_LIST][name].status=1
end

def pbRegisterUniquePokemonDefeated(name)
  $game_variables[UNIQUE_LIST][name].status=2
end

def pbUniquePokemonSeen(name)
  return $game_variables[UNIQUE_LIST][name].status>=1
end

def pbUniquePokemonDefeated(name)
  return $game_variables[UNIQUE_LIST][name].status>=2
end

def pbUniquePokemonSeenCount
  count = 0
  for pkmn in $game_variables[UNIQUE_LIST]
    count += 1 if pkmn[1].status>=1
  end
  return count
end

def pbUniquePokemonDefeatedCount
  count = 0
  for pkmn in $game_variables[UNIQUE_LIST]
    count += 1 if pkmn[1].status>=2
  end
  return count
end

# Add any other changes to the standard below where this function is run
def pbAuraMods(id=0,lvd=0,ai=25+(pbDifficulty * 25))
  if id == 0
    pbModifier.name    = "Tester Test"
  else
    pbModifier.name    = id
  end
  pbModifier.hpmult  = 2.00
  pbModifier.gender  = 2
  pbModifier.form    = 0
  pbModifier.ability = 0
  pbModifier.nature  =:SERIOUS
  pbModifier.item    = 0 
  pbModifier.iv      =[31,31,31,31,31,31]
  pbModifier.ev      =[252,252,252,252,252,252]
  pbModifier.shadow  = false
  pbModifier.echo    = true # Change ability with boss scripts
  $game_variables[LV_DISPLAY] = lvd
  $game_variables[WILD_AI_LEVEL] = ai
end

def pbAbsolBattle
  species = :ABSOL
  lvl     = 20
  pbModifier.hpmult  = 0.12
  pbModifier.gender  = 1
  pbModifier.nature  =:LONELY
  pbModifier.shiny   = false
  $game_variables[LV_DISPLAY] = "??"
  pbModifier.moves=[:FALSESWIPE,:LEER,0,0]
  #========================BOSS FIGHT SCRITPT=================================
    pbBoss.add([:Sturdy,8])
    pbBoss.add([:Sturdy,4])
    pbBoss.add([:Sturdy,2])
    pbBoss.add([:Timed,3],[:Message,"Absol, please stop! We don't want to hurt you! I promise"],
    [:Wait,20],[:WinBattle])
  #===========================================================================
  pbWildBattle(species,lvl,0,false)
end

def pbKanaiBattle
  tbattle(:STRANGEMAN,"???")
  tbattle.canlose=true
  tbattle.levelmod=false
  tbattle.double=true
  tbattle.party=0
  tbattle.speech="..."
  $game_variables[LV_DISPLAY] = "??"
  #========================BOSS FIGHT SCRITPT=================================
    pbBoss.add([:Sturdy,50])
    pbBoss.add([:Start],[:UseMove,:SHADOWTERRAIN])
    pbBoss.add([:HP,50],[:Message,"Enough!"],
    [:Wait,20],[:WinBattle])
  #===========================================================================
 tbattle.start
end


def pbAuraPkmn(id=0,species=:DITTO,lvl=1,special=false,mode=0)
  register=true
  pbAuraMods(id)
  case id
  when 0
    pbAddUniquePokemonBoost(:HP,1)
    pbModifier.moves=[:SPLASH,0,0,0]
    #========================BOSS FIGHT SCRITPT=================================
    pbBoss.add([:Start],
    [:Message, "Battle Generation Successful"],
    [:Wait,20],
    [:WinBattle])
    #===========================================================================
########################### MANDITORY BOSS FIGHTS ##############################
  when "Striding Gerid" # Surskit (Secluded Grove  Lv 5)
    pbAddUniquePokemonBoost(:SPEED,1)
    pbModifier.moves=[:BUBBLE,:STRUGGLEBUG,0,0]
    #========================BOSS FIGHT SCRITPT=================================
    pbBoss.addGauge(:Long,"Rainmaker",40, "blue",0)
    pbBoss.add([:Start],[:Ability,:SWIFTSWIM],[:Type1,:BUG],[:Type2,:WATER])
    pbBoss.add([:Start],[:Gauge,0,+40],
    [:Message, "Skill: *Rainmaker*"],[:Wait,12],
    [:CommonAnim,"Rain"], [:Message, "Rain began to fall!"],
    [:Weather,:RAINDANCE,3])
    pbBoss.add([:Interval,1],[:Gauge,0,-10])
    pbBoss.addGaugeEffect(0,0,[:RemoveGauge,0])
    #===========================================================================
################################################################################
  when "Slender Surumaya" # Tangela (Mirin Road LV 26)
    pbModifier.item    = :HEATPROOFGEM
    pbAddUniquePokemonBoost(:SPDEF,1)
    pbModifier.moves=[:MEGADRAIN,:LEECHSEED,:INGRAIN,:GROWTH]
    #========================BOSS FIGHT SCRITPT=================================
    pbBoss.addGauge(:Long,"Sundancer",10, "green")
    pbBoss.addGauge(:Long,"Vine Wall",10, "red",0)
    pbBoss.add([:Start],[:Ability,:CHLOROPHYLL],[:Type1,:GRASS],[:Type2,:GRASS])
    pbBoss.add([:Start],[:Message, "NAME created a wall of vines."])
    pbBoss.add([:Start],[:Message, "Skill: *Sundancer*"],[:Wait,12],
    [:Message, "NAME's summoned bright sunlight"],[:Weather,:SUNNYDAY,-1],
    [:Gauge,0,-10])
    pbBoss.add([:Type,:FIRE],[:Wait,12],[:RemoveGauge,1])
    pbBoss.add([:Category,1],[:Gauge,1,+10])
    pbBoss.addGaugeEffect(0,1,
    [:Message, "Skill: *Sundancer*"],[:Wait,12],
    [:Message, "NAME's summoned bright sunlight"],
    [:Weather,:SUNNYDAY,-1],[:Gauge,0,-10])
    pbBoss.addGaugeEffect(1,1,[:Message, "Skill: *Vine Wall*"],[:Wait,12],
    [:Message, "NAME's vines lashed out!"],
    [:MoveAnim,:VINEWHIP],[:DealDamage,0.125],[:Gauge,1,-10])
    #===========================================================================
  when "Rainbow-Core Prismallon" # Starmie
    # Location: Mirin Road
    pbModifier.hpmult  = 7.00
    pbAddUniquePokemonBoost(:HP,1)
    pbModifier.moves=[:ICYWIND,:THUNDERWAVE,:REFLECTTYPE,0]
    #========================BOSS FIGHT SCRITPT=================================
    pbBoss.addGauge(:Long,"Rainboow Core", 1 , "none")
    # Start
    pbBoss.add([:Start],
    [:Message, "NAME's core surronded them woth a multi-colored wall"],
    [:Wait,20],
    [:Message, "NAME is cloaked in a rainbow veil. They are protected from Stat reductions and Status Conditions"],
    [:Custom,:"boss.pbOwnSide.effects[PBEffects::Mist]=9999"],
    [:Custom,:"boss.pbOwnSide.effects[PBEffects::Safeguard]=9999"],
    [:Custom,:"boss.effects[PBEffects::NoDamage]=true"],
    [:Wait,20],
    [:Message, "NAME's core is flashing RED"],
    [:Message, "FIRE attacks may harm them."])
    # Layer I - RED
    #===========================================================================
  when "Peppy Liella" # Pichu
    # Location: Iphondria City
    # Mode 1: Shadow Pokémon encounter
    case mode
    when 0
      pbModifier.item    = :RINDOBERRY 
      pbAddUniquePokemonBoost(:SPATK,1)
      pbModifier.moves=[:NUZZLE,:NATURALGIFT,:NASTYPLOT,:CHARGE]
    when 1
      register=false
      pbAuraMods(id,"??")
      pbModifier.name    = "Anxious Liella?"
      pbModifier.shadow  = true
      pbModifier.echo    = false
      pbModifier.item    = :CHAOSCRYSTAL 
      pbAddUniquePokemonBoost(:SPATK,2)
      pbAddUniquePokemonBoost(:SPDEF,-2)
    end
    #========================BOSS FIGHT SCRITPT=================================
    case mode
    when 0
      pbBoss.addGauge(:Full,"Berry Finder",20, "green")
      pbBoss.add([:Interval,1],[:If,"boss.item == 0"], [:Gauge,0,-10])
      pbBoss.addGaugeEffect(0,0,[:Message, "Skill: *Berry Finder*"],
      [:Wait,20],
      [:CommonAnim,"HealthUp"], 
      [:Message, "NAME found a Rindo Berry."],[:Item,:RINDOBERRY],[:Gauge,0,20])
    when 1
      pbBoss.add([:Start],[:Message, "Skill: *Chaos Rain*"],
      [:Wait,20],[:CommonAnim,"ShadowSky"],[:Weather,:ShadowSky,-1],
      [:Message, "NAME caused eerie lights to blot out the sky!"])
    end
    #===========================================================================
  when "Uncertain Dolly" # Flaaffy
    # Location: Pharoday Island
    pbModifier.hpmult  = 2.20
    pbAddUniquePokemonBoost(:SPDEF,1)
    pbModifier.moves=[:SHOCKWAVE,:COTTONSPORE,:FLATTER,:AGILITY]
    #========================BOSS FIGHT SCRITPT=================================
    pbBoss.addGauge(:Long,"Cloning Flash",1,"none")
    #pbBoss.add([:Sturdy,50])
    pbBoss.add([:Category,2],[:If,"rand(4)==0"], 
    [:Message, "Skill : *Cloning Flash*"],
    [:Wait,20],[:MoveAnim,:FLASH],[:Custom,"boss.effects[PBEffects::DoubleTeam]=true"])
    #===========================================================================
  when "Hill-arious Juko" # Treecko (Twin-Tree Hill)
    pbModifier.item    = :GRASSYSEED
    pbAddUniquePokemonBoost(:SPEED,1)
    pbModifier.moves=[:ABSORB,:DRAGONSOUL,:GRASSYTERRAIN,0] if mode == 0
    pbModifier.moves=[:MEGADRAIN,:DRAGONBREATH,:DRAGONSOUL,:GRASSYTERRAIN] if mode == 1
    #========================BOSS FIGHT SCRITPT=================================
    case mode
    when 0
      pbBoss.addGauge(:Long,"Tail Smack",30, "red",0)
      pbBoss.add([:Start],[:Ability,:OVERGROW],[:Type1,:GRASS],[:Type2,:GRASS])
      pbBoss.add([:Category,0],[:Gauge,0,+10])
      pbBoss.addGaugeEffect(0,1,
      [:Message, "Skill: *Tail Smack*"],[:Wait,20],
      [:Message, "NAME lashed out with their tail"],
      [:DealDamage,20],[:Gauge,0,-30])
    when 1
      pbBoss.addGauge(:Long,"Tail Smack",30, "red",0)
      pbBoss.add([:Start],[:Ability,:OVERGROW],[:Type1,:GRASS],[:Type2,:GRASS])
      pbBoss.add([:Category,0],[:Gauge,0,+15])
      pbBoss.addGaugeEffect(0,1,
      [:Message, "Skill: *Tail Smack*"],[:Wait,20],
      [:Message, "NAME lashed out with their tail"],
      [:DealDamage,30],[:Gauge,0,-30])
    end
    #===========================================================================
  when "Dragon-Singer Hymaria" # Altaria
    # Location: (none)
    pbAddUniquePokemonBoost(:HP,2); pbAddUniquePokemonBoost(:DEFENSE,1)
    pbModifier.hpmult  = 4.00
    pbModifier.ability = 0
    pbModifier.nature  =:CALM
    pbModifier.item    =:ACCIDENTPOLICY
    pbModifier.moves=[:DRAGONPULSE,:MOONBLAST,:COTTONGUARD,:CELESTIALDANCE]
    #========================BOSS FIGHT SCRITPT=================================
    pbBoss.add([:Sturdy,200])
    pbBoss.addGauge(:Full,"Double Attack",10,"red",0)
    pbBoss.addGauge(:Full,"Dragon Song",40,"green",0)
    pbBoss.add([:Interval,1],[:Gauge,1,+10])
    pbBoss.add([:Interval,1],[:If,"rand(4)==0"],[:Gauge,0,+10])
    pbBoss.addGaugeEffect(0,1,
    [:Message, "Skill: *Double Attack"],[:Wait,20],
    [:UseMove,:COTTONGUARD],[:Gauge,1,-10])
    pbBoss.add([:If,"boss.hp == boss.hp*2"],[:RemoveGauge,1],[:Phase])
    pbBoss.addGaugeEffect(1,1,
    [:Message, "Skill: *Dragon Song"],[:Wait,20],
    [:Message, "NAME's inspiring melody empowered them"],
    [:StatChange,:SPDEF,1],[:StatChange,:SPEED,1],[:Gauge,1,-40])
    
    # Phase II
    pbBoss.phase.addGauge(:Half,"Power Hymn",10, "red",0)
    pbBoss.phase.add([:HP,200],[:PlayBGM,"battle_ub.ogg"])
    pbBoss.phase.add([:Interval,1],[:If,"!player.hasWorkingAbility(:SOUNDPROOF)"],
    [:Gauge,1,+10])
    pbBoss.phase.addGaugeEffect(1,1,
    [:Message, "Skill: *Power Hymn*"],[:Wait,20],
    [:Message, "NAME's powerful song emitted damaging waves."],
    [:DealDamage,0.4],[:Gauge,1,-10])
    #===========================================================================
  when "Operative Chulon"  # Shellos
    # Location: Iphondria Park
    pbModifier.form    = 1
    pbModifier.nature  = :BOLD
    pbModifier.item    = :EVIOLITE 
    pbAddUniquePokemonBoost(:DEFENSE,1); pbAddUniquePokemonBoost(:SPDEF,1)
    pbModifier.moves=[:WATERPULSE,:ICYWIND,:TOXIC,:RECOVER]
    #========================BOSS FIGHT SCRITPT=================================
    pbBoss.addGauge(:Long,"Gelatinous Touch",1, "none")
    pbBoss.add([:Sturdy,100])
    pbBoss.add([:Contact],
    [:Message, "Skill : *Gelatinous Touch*"],
    [:Wait,20],[:MoveAnim,:CONSTRICT],[:PlayerStat,:SPEED,-1])
    pbBoss.add([:Interval,1],[:If,"boss.hp<=boss.totalhp"],
    [:Message,"NAME will recover 12 HP each turn"],[:Phase])
    # Phase II
    pbBoss.phase.addGauge(:Long,"Regeneration",1,"none")
    pbBoss.phase.add([:Interval,1],[:If,"boss.hp<boss.totalhp"],
    [:Message, "Skill : *Regeneration*"],[:Wait,20],
    [:CommonAnim,"HealthUp"],[:Heal,12])
    #===========================================================================
  when "Territorial Rotmian" # Darmanitan (Crossroads - LV 81)
    pbModifier.hpmult  = 3.00
    pbModifier.item    = :MUSCLEBAND
    pbAddUniquePokemonBoost(:ATTACK,1)
    pbModifier.moves=[:FIREPUNCH,:THUNDERPUNCH,:HEADBUTT,:TAUNT]
    #========================BOSS FIGHT SCRITPT=================================
    pbBoss.addGauge(:Full,"Threatening Roar",30,"red")
    pbBoss.add([:Interval,1], [:Gauge,0,-15])
    pbBoss.addGaugeEffect(0,0,[:Message, "Skill: *Threatening Roar*"],
    [:Wait,20],
    [:Message, "NAME roared at your Pokémon."],
    [:Wait,20],
    [:PlayerStat,:DEFENSE,-2],
    [:PlayerStat,:SPDEF,-2],
    [:Gauge,0,30])
    #===========================================================================
  when "Combative Adalegh" 
    # Carbink (Ruby) Caeli Caves - LV 43)
    pbModifier.hpmult  = 2.50
    pbModifier.form    = 2
    pbModifier.item    = :RUBY
    pbAddUniquePokemonBoost(:SPEED,-1)
    pbModifier.moves=[:LIGHTSCREEN,:REFLECT,:POWERGEM,:FLASHCANNON]
    #========================BOSS FIGHT SCRITPT=================================
    pbBoss.addGauge(:Full,"Ruby Mirror",30,"green")
    pbBoss.addGauge(:Full,"Ruby Flare",60, "red")
    pbBoss.add([:Start],[:Gauge,1,-60])
    pbBoss.add([:Start],[:Ability,:CLEARBODY],[:Type1,:ROCK],[:Type2,:FAIRY])
    pbBoss.add([:Sturdy,75])
    
    pbBoss.add([:Interval,1],[:If,"boss.item==PBItems::RUBY"],
    [:Gauge,0,-15])
        
    pbBoss.add([:Type,:FIRE],[:Damaged,2],[:If,"boss.item==PBItems::RUBY"],
    [:CommonAnim,:"HealthUp"],
    [:Message, "NAME's absorbed some of the Fire Damage."],
    [:Gauge,1,-15])
    
    pbBoss.addGaugeEffect(0,0,[:Wait,12],
    [:Message, "Skill: *Ruby Mirror*"],[:Wait,12],[:CommonAnim,:POWERTRICK],
    [:Message, "NAME's offensive and defensive stats were flipped"],[:Wait,12],
    [:Custom,"boss.attack,boss.defense=boss.defense,boss.attack"],
    [:Custom,"boss.spatk,boss.spdef=boss.spdef,boss.spatk"],
    [:Gauge,0,30])
    
    pbBoss.addGaugeEffect(1,0,[:Wait,12],
    [:Message, "Skill: *Ruby Flare*"],[:Wait,12],
    [:Message, "NAME's ruby aura flared to life!"],[:Wait,12],
    [:DealStatus,:BURN],[:Wait,12],
    [:Message,"Your Party's HP was halved!"],[:Wait,12],
    [:DamageParty,0.5],[:RemoveGauge,1])
    #===========================================================================
  when "Smoke-Tail Micador"
    # Location: Caeli Caverns
    pbModifier.hpmult  = 3.00
    pbModifier.item    = :CHARCOAL 
    pbAddUniquePokemonBoost(:ATTACK,1); pbAddUniquePokemonBoost(:SPDEF,1)
    pbModifier.moves=[:FIREFANG,:WILLOWISP,:SMOKESCREEN,:BABYDOLLEYES]
    #========================BOSS FIGHT SCRITPT=================================
    pbBoss.add([:Sturdy,200])
    pbBoss.add([:Start],[:Ability,:WHITESMOKE],[:Type1,:FIRE],[:Type2,:FIRE])
    pbBoss.add([:Start],[:Custom,"$game_variables[4000]=40"])
    pbBoss.addGauge(:Full,"Healing Coals",40,"green")
        
    pbBoss.add([:Interval,1],[:If,"boss.item==PBItems::CHARCOAL"],
    [:If,"$game_variables[4000]>0"],[:Custom,"$game_variables[4000]-=10"],
    [:Gauge,0,-10],
    [:Message, "Skill: *Healing Coals*"],[:Wait,12],
    [:Message, "NAME ate Charcoal and healed themselves."],[:Wait,12],
    [:CommonAnim,"HealthUp"],[:Wait,12],
    [:Custom,"boss.pbRecoverHP((boss.totalhp*$game_variables[4000]/100))"])
    
    pbBoss.add([:HP,201],
    [:Message, "NAME levelled up!"],[:Level,1],[:Wait,12],[:Phase])
    
    pbBoss.addGaugeEffect(0,0,[:Wait,12],
    [:Message, "NAME ran out of Charcoal."],[:Wait,12],
    [:RemoveGauge,0],[:Item,0])
    
    ################################ PHASE II ##################################
    pbBoss.phase.addGauge(:Long,"Fiery Evolution",1, "none")
    pbBoss.phase.add([:Sturdy,100])
    pbBoss.phase.add([:HP,101],
    [:Message, "Skill: *Fiery Evolution*"],[:Wait,12],[:RemoveGauge,0],
    [:Level,1],[:Wait,12], [:Message, "NAME's Fire Element made them evolve!"],
    [:Wait,12],[:Species,:REVULTRE],[:Name,"Flame-Tail Micador"],[:Wait,12],    
    [:Custom,"$game_variables[4000]=40"],
    [:Message,"The Aura around NAME changed"],[:Wait,12],
    [:StatChange,:ATTACK,-1],[:StatChange,:SPDEF,-1],
    [:StatChange,:SPATK,1],[:Wait,12],
    [:Message,"NAME's ability became Ruthless"],[:Wait,12],
    [:Ability,:RUTHLESS],[:Type1,:FIRE],[:Type2,:DARK],
    [:Message,"NAME's moves changed"],[:Wait,12],
    [:Moves,:MYSTICALFIRE,:BITE,:AGILITY,:NASTYPLOT],
    [:Message,"NAME found a Charcoal!"],[:Wait,12],
    [:Item,:CHARCOAL],[:Phase])
    ################################ PHASE III #################################
    pbBoss.phase.phase.addGauge(:Full,"Ash Rain",50, "Red")    
    pbBoss.phase.phase.add([:Interval,1],[:If,"boss.item==PBItems::CHARCOAL"],
    [:If,"$game_variables[4000]>0"],[:If,"!player.pbHasType?(:FIRE)"],
    [:Gauge,0,-10],
    [:Custom,"$game_variables[4000]-=10"],
    [:Message, "Skill: *Ash Rain*"],[:Wait,12],
    [:Message, "NAME spread charred ashes around your field."],[:Wait,12],
    [:Custom,"player.pbReduceHP((player.totalhp*$game_variables[4000]/100))"])
        
    pbBoss.addGaugeEffect(0,0,[:Wait,12],
    [:Message, "NAME ran out of Charcoal."],[:Wait,12],
    [:RemoveGauge,0])
    #===========================================================================
  when "Flame-Tail Micador"
    # Location: Caeli Caverns
    pbModifier.hpmult  = 3.00
    pbModifier.item    = :CHARCOAL 
    pbAddUniquePokemonBoost(:SPATK,1)
    pbModifier.moves=[:FIREFANG,:WILLOWISP,:SMOKESCREEN,:BABYDOLLEYES]
    #========================BOSS FIGHT SCRITPT=================================
    pbBoss.addGauge(:Long,"Ash Rain",50, "Red")
    pbBoss.add([:Start],[:Ability,:RUTHLESS],[:Type1,:FIRE],[:Type2,:DARK])
    
    pbBoss.add([:Start],[:Custom,"$game_variables[4000]=50"])
    pbBoss.phase.phase.add([:Interval,1],[:If,"boss.item==PBItems::CHARCOAL"],
    [:If,"$game_variables[4000]>0"],[:If,"!player.pbHasType?(:FIRE)"],
    [:Gauge,0,-10],
    [:Custom,"$game_variables[4000]-=10"],
    [:Message, "Skill: *Ash Rain*"],[:Wait,12],
    [:Message, "NAME spread charred ashes around your field."],[:Wait,12],
    [:Custom,"player.pbReduceHP((player.totalhp*$game_variables[4000]/100))"])
        
    pbBoss.phase.phase.addGaugeEffect(0,0,[:Wait,12],
    [:Message, "NAME ran out of Charcoal."],[:Wait,12],
    [:RemoveGauge,0])
  end
  name = pbModifier.name
  pbRegisterUniquePokemonSeen(name) if register
  if pbUniquePokemonBattle(species,lvl,0,false)
    if !special
      pbWait(12)
      #pbFadeOutAndHide(12)
      pbWait(12)
      pbPlayCry(species,100,75)
      pbWait(12)
      #pbFadeOutIn(12)
      pbWait(12)
      pbMoveRoute($game_map.events[@event_id],[
      PBMoveRoute::Graphic,"Object ball_rainbow",260,2,0])
      pbWait(12)
      if !$game_self_switches[[$game_map.map_id,@event_id,"B"]]
        pbItemOrb(id,true)
      else
        pbItemOrb(id)
      end
      pbSetEventTime
    end
  # Special Requirements will be listed in the event itself.
  else
    $game_variables[LV_DISPLAY] = 0
    $game_variables[WILD_AI_LEVEL] = 0
  end
end

class UniquePokemon
  attr_accessor(:name)
  attr_accessor(:title)
  attr_accessor(:species)
  attr_accessor(:location)
  attr_accessor(:description)
  attr_accessor(:status)
  
  def initialize(name, species, location, description)
    self.name         = name
    self.species      = species
    self.location     = location
    self.description  = description
    self.status       = 0
  end
  
end











