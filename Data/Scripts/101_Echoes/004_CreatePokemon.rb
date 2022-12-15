################################################################################re

def pbCreateSylveon
  poke=Pokemon.new(:SYLVEON,17,$player)
  poke.owner.name="Amy"
  poke.moves=[
  Pokemon::Move.new(:FAIRYWIND),
  Pokemon::Move.new(:SWIFT),
  Pokemon::Move.new(:BABYDOLLEYES),
  Pokemon::Move.new(:WISH)]
  poke.gender = 1
  poke.ability_index = 0
  poke.nature = :MODEST
  #poke.poke_ball = 26
  poke.iv = pbStatArrayToHash([15,15,15,15,15,15])
  poke.calc_stats
  $player.party.push(poke)
end

def pbCreateSylveonHard
  poke=Pokemon.new(:SYLVEON,17,$player)
  poke.owner.name="Amy"
  poke.moves=[
  Pokemon::Move.new(:FAIRYWIND),
  Pokemon::Move.new(:SWIFT),
  Pokemon::Move.new(:BABYDOLLEYES),
  Pokemon::Move.new(:WISH)]
  poke.gender = 1
  poke.ability_index = 2
  poke.nature = :MODEST
  #poke.poke_ball = 26
  poke.iv = pbStatArrayToHash([31,31,31,31,31,31])
  poke.calc_stats
  $player.party.push(poke)
end
  
def pbCreateSylveonShadow
  poke=Pokemon.new(:SYLVEON,24,$player)
  poke.owner.name="Amy"
  poke.moves=[
  Pokemon::Move.new(:SHADOWRUSH),
  Pokemon::Move.new(:SHADOWSKY)]
  poke.gender = 1
  poke.ability_index = 2
  poke.nature = :CALM
  poke.shadow = true
  #poke.poke_ball = 26
  poke.iv = pbStatArrayToHash([31,31,31,31,31,31])
  poke.calc_stats
  $player.party.push(poke)
end

def pbCreateAbsol
  poke=Pokemon.new(:ABSOL,16,$player)
  poke.owner.name="Amy"
  poke.moves=[
  Pokemon::Move.new(:FUTURESIGHT)]
  poke.gender = 1
  poke.ability_index = 2
  poke.nature = :LONELY
  #poke.poke_ball = 26
  poke.iv = pbStatArrayToHash([31,31,31,31,31,31])
  poke.calc_stats
  $player.party.push(poke)
end

def pbCreateAbsol2
  poke=Pokemon.new(:ABSOL,16,$player)
  poke.owner.name="Amy"
  poke.moves=[
  Pokemon::Move.new(:FUTURESIGHT),
  Pokemon::Move.new(:WISH),
  Pokemon::Move.new(:PROTECT)]
  poke.gender = 1
  poke.ability_index = 2
  poke.nature = :LONELY
  #poke.poke_ball = 26
  poke.iv = pbStatArrayToHash([31,31,31,31,31,31])
  poke.calc_stats
  $player.party.push(poke)
end
################################################################################
def pbLawrenceParty
  poke=Pokemon.new(:INLYS,3,$player)
  poke.owner.name="Lawrence"
  poke.name="???"
  poke.moves=[
  Pokemon::Move.new(:BITE),
  Pokemon::Move.new(:FACADE),
  Pokemon::Move.new(:MIST)]
  poke.iv = pbStatArrayToHash([31,31,31,31,31,31])
  poke.calc_stats
  
  poke2=Pokemon.new(:LICIT,3,$player)
  poke2.owner.name="Lawrence"
  poke2.name="???"
  poke2.moves=[
  Pokemon::Move.new(:BITE),
  Pokemon::Move.new(:FACADE),
  Pokemon::Move.new(:CHARGE)]
  poke2.iv = pbStatArrayToHash([31,31,31,31,31,31])
  poke2.calc_stats  
  
  poke3=Pokemon.new(:VINETTE,3,$player)
  poke3.owner.name="Lawrence"
  poke3.name="???"
  poke3.moves=[
  Pokemon::Move.new(:BITE),
  Pokemon::Move.new(:FACADE),
  Pokemon::Move.new(:SUNNYDAY)]
  poke3.iv = pbStatArrayToHash([31,31,31,31,31,31])
  poke3.calc_stats  
  $player.party.push(poke,poke2,poke3)
end


#################################################################################
def pbExxyParty
  poke=Pokemon.new(:RAPIDASH,40,$player)
  poke.owner.name="Exxy"
  poke.name="Celestial"
  #poke.poke_ball 	  = 12
  poke.form  		    = 1
  poke.gender 	= 1
  poke.ability_index 	= 1
  poke.shiny   	= false
  poke.nature  	= :JOLLY
  poke.item        	= :TWISTEDSPOON
  poke.moves=[
  Pokemon::Move.new(:PSYCHOCUT),
  Pokemon::Move.new(:HEALINGHORN),
  Pokemon::Move.new(:MEGAHORN),
  Pokemon::Move.new(:AGILITY)]
  poke.ev = pbStatArrayToHash([4,128,0,128,0,0])
  poke.iv = pbStatArrayToHash([31,31,31,31,31,31])
  poke.calc_stats
  $player.party.push(poke)

  poke=Pokemon.new(:MUDSDALE,42,$player)
  poke.owner.name="Exxy"
  poke.name="Big Horsey"
  #poke.poke_ball 	  = 0
  poke.form  		    = 0
  poke.gender 	= 0
  poke.ability_index 	= 1
  poke.shiny   	= false
  poke.nature  	= :CAREFUL
  poke.item        	= :ASSAULTVEST
  poke.moves=[
  Pokemon::Move.new(:HIGHHORSEPOWER),
  Pokemon::Move.new(:HEAVYSLAM),
  Pokemon::Move.new(:BODYSLAM),
  Pokemon::Move.new(:CLOSECOMBAT)]
  poke.ev = pbStatArrayToHash([170,170,170,0,0,0])
  poke.iv = pbStatArrayToHash([31,31,31,31,31,31])
  poke.calc_stats
  $player.party.push(poke)

  poke=Pokemon.new(:CHARMANDER,43,$player)
  poke.owner.name="Exxy"
  poke.name="Taco"
  #poke.poke_ball 	  = 0
  poke.form  		    = 0
  poke.gender 	= 0
  poke.ability_index 	= 0
  poke.shiny   	= true
  poke.nature  	= :BRAVE
  poke.item        	= :EVIOLITE
  poke.moves=[
  Pokemon::Move.new(:FLAREBLITZ),
  Pokemon::Move.new(:THUNDERPUNCH),
  Pokemon::Move.new(:DRAGONCLAW),
  Pokemon::Move.new(:PROTECT)]
  poke.ev = pbStatArrayToHash([4,252,0,252,0,0])
  poke.iv = pbStatArrayToHash([31,31,31,31,31,31])
  poke.calc_stats
  party=[poke1,poke2,poke3]
  $player.party.push([party].shuffle)
end
#################################################################################
#################################################################################
def pbExxyParty_2
  if $game_variables[EXXY_CHOSEN] == "Morpheon"
    poke=Pokemon.new(:MORPHEON,42,$player)
    poke.owner.name="Exxy"
    poke.name="Fluffbucket"
    #poke.poke_ball 	  = 13
    poke.form  		    = 0
    poke.gender 	= 0
    poke.ability_index 	= 1
    poke.shiny   	= false
    poke.nature  	= :BOLD
    poke.item        	= :BUGELEMENT
    poke.moves=[
    Pokemon::Move.new(:EMERALDSTORM),
    Pokemon::Move.new(:SLEEPPOWDER),
    Pokemon::Move.new(:STRINGSHOT),
    Pokemon::Move.new(:BABYDOLLEYES)]
    poke.ev = pbStatArrayToHash([0,0,4,0,252,252])
    poke.iv = pbStatArrayToHash([31,31,31,31,31,31])
    poke.calc_stats
    $player.party.push(poke)
    
  elsif $game_variables[EXXY_CHOSEN] == "Zephyreon"
    poke=Pokemon.new(:ZEPHYREON,42,$player)
    poke.owner.name="Exxy"
    poke.name="Jack"
    #poke.poke_ball 	  = 18
    poke.form  		    = 0
    poke.gender 	= 0
    poke.ability_index 	= 1
    poke.shiny   	= false
    poke.nature  	= :BOLD
    poke.item        	= :DRAGONSTONE
    poke.moves=[
    Pokemon::Move.new(:AIRSLASH),
    Pokemon::Move.new(:SPARKLINGARIA),
    Pokemon::Move.new(:SING),
    Pokemon::Move.new(:TAILWIND)]
    poke.ev = pbStatArrayToHash([0,0,4,0,252,252])
    poke.iv = pbStatArrayToHash([31,31,31,31,31,31])
    poke.calc_stats
    $player.party.push(poke)
  end
    
  poke=Pokemon.new(:RAPIDASH,41,$player)
  poke.owner.name="Exxy"
  poke.name="Celestial"
  #poke.poke_ball 	  = 9
  poke.form  		    = 1
  poke.gender 	= 1
  poke.ability_index 	= 1
  poke.shiny   	= false
  poke.nature  	= :HASTY
  poke.item        	= :SCOPELENS
  poke.moves=[
  Pokemon::Move.new(:PSYCHOCUT),
  Pokemon::Move.new(:MEGAHORN),
  Pokemon::Move.new(:SMARTSTRIKE),
  Pokemon::Move.new(:MYSTICALFIRE)]
  poke.ev = pbStatArrayToHash([0,252,0,252,4,0])
  poke.iv = pbStatArrayToHash([31,31,31,31,31,31])
  poke.calc_stats
  $player.party.push(poke)

  poke=Pokemon.new(:MUDSDALE,43,$player)
  poke.owner.name="Exxy"
  poke.name="Big Horsey"
  #poke.poke_ball 	  = 1
  poke.form  		    = 0
  poke.gender 	= 0
  poke.ability_index 	= 1
  poke.shiny   	= false
  poke.nature  	= :CAREFUL
  poke.item        	= :ASSAULTVEST
  poke.moves=[
  Pokemon::Move.new(:HIGHHORSEPOWER),
  Pokemon::Move.new(:HEAVYSLAM),
  Pokemon::Move.new(:BODYSLAM),
  Pokemon::Move.new(:CLOSECOMBAT)]
  poke.ev = pbStatArrayToHash([170,170,170,0,0,0])
  poke.iv = pbStatArrayToHash([31,31,31,31,31,31])
  poke.calc_stats
  $player.party.push(poke)

  poke=Pokemon.new(:CHARMANDER,44,$player)
  poke.owner.name="Exxy"
  poke.name="Taco"
  #poke.poke_ball 	  = 0
  poke.form  		    = 0
  poke.gender 	= 0
  poke.ability_index 	= 0
  poke.shiny   	= true
  poke.nature  	= :ADAMANT
  poke.item        	= :EVIOLITE
  poke.moves=[
  Pokemon::Move.new(:FLAREBLITZ),
  Pokemon::Move.new(:THUNDERPUNCH),
  Pokemon::Move.new(:DRAGONCLAW),
  Pokemon::Move.new(:PROTECT)]
  poke.ev = pbStatArrayToHash([4,252,0,252,0,0])
  poke.iv = pbStatArrayToHash([31,31,31,31,31,31])
  poke.calc_stats
  $player.party.push(poke)
end
#################################################################################
def pbVictiniEgg
  poke              =Pokemon.new(:VICTINI,1,$player)
  #poke.owner.name          ="TRAINER"
  poke.name        ="Egg"
  #poke.poke_ball 	  = 36
  poke.form  		    = 0
  poke.gender 	= 2
  poke.ability_index  = [0,0,0,0,1,1,1,2,2,2].shuffle[0]
  poke.moves=[
  Pokemon::Move.new(:VCREATE),
  Pokemon::Move.new(:FUSIONBOLT),
  Pokemon::Move.new(:FUSIONFLARE),
  Pokemon::Move.new(:GLACIATE)]
  poke.steps_to_hatch = 65535
  poke.calc_stats
  $player.party.push(poke)
end
    
def pbKeldeoEgg
  poke              =Pokemon.new(:KELDEO,1,$player)
  #poke.owner.name          ="TRAINER"
  poke.name        ="Egg"
  #poke.poke_ball 	  = 0
  poke.form  		    = 0
  poke.gender 	= 2
  poke.ability_index  = [0,0,0,0,1,1,1,2,2,2].shuffle[0]
  #poke.shiny   = false
  #poke.nature  = :NATURE
  #poke.item        = :ITEM
  #poke.ev          = [0,0,0,0,0,0]
  poke.iv          = pbStatArrayToHash([31,31,31,
  [15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31].shuffle[0],
  [15,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31].shuffle[0],
  [10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31].shuffle[0]].shuffle)
  poke.moves=[
  Pokemon::Move.new(:SECRETSWORD),
  Pokemon::Move.new(:AQUAJET),
  Pokemon::Move.new(:BOUNCE),
  Pokemon::Move.new(:ICYWIND)]
  poke.steps_to_hatch = 1
  poke.calc_stats
  $player.party.push(poke)
end
################################################################################