################################################################################re

def pbCreateSylveon
  poke=Pokemon.new(:SYLVEON,17,$player)
  poke.ot="Amy"
  poke.moves=[
  Move.new(:FAIRYWIND),
  Move.new(:SWIFT),
  Move.new(:BABYDOLLEYES),
  Move.new(:WISH)]
  poke.gender = 1
  poke.ability_index = 0
  poke.nature = :MODEST
  #poke.poke_ball = 26
  poke.iv = [15,15,15,15,15,15]
  poke.calc_stats
  $player.party.push(poke)
end

def pbCreateSylveonHard
  poke=Pokemon.new(:SYLVEON,17,$player)
  poke.ot="Amy"
  poke.moves=[
  Move.new(:FAIRYWIND),
  Move.new(:SWIFT),
  Move.new(:BABYDOLLEYES),
  Move.new(:WISH)]
  poke.gender = 1
  poke.ability_index = 2
  poke.nature = :MODEST
  #poke.poke_ball = 26
  poke.iv = [31,31,31,31,31,31]
  poke.calc_stats
  $player.party.push(poke)
end
  
def pbCreateSylveonShadow
  poke=Pokemon.new(:SYLVEON,24,$player)
  poke.ot="Amy"
  poke.moves=[
  Move.new(:SHADOWRUSH),
  Move.new(:SHADOWSKY),
  Move.new(0),
  Move.new(0)]
  poke.gender = 1
  poke.ability_index = 2
  poke.nature = :CALM
  poke.shadow = true
  #poke.poke_ball = 26
  poke.iv = [31,31,31,31,31,31]
  poke.calc_stats
  $player.party.push(poke)
end

def pbCreateAbsol
  poke=Pokemon.new(:ABSOL,16,$player)
  poke.ot="Amy"
  poke.moves=[
  Move.new(:FUTURESIGHT),
  Move.new(0),
  Move.new(0),
  Move.new(0)]
  poke.gender = 1
  poke.ability_index = 2
  poke.nature = :LONELY
  #poke.poke_ball = 26
  poke.iv = [31,31,31,31,31,31]
  poke.calc_stats
  $player.party.push(poke)
end

def pbCreateAbsol2
  poke=Pokemon.new(:ABSOL,16,$player)
  poke.ot="Amy"
  poke.moves=[
  Move.new(:FUTURESIGHT),
  Move.new(:WISH),
  Move.new(:PROTECT),
  Move.new(0)]
  poke.gender = 1
  poke.ability_index = 2
  poke.nature = :LONELY
  #poke.poke_ball = 26
  poke.iv = [31,31,31,31,31,31]
  poke.calc_stats
  $player.party.push(poke)
end
################################################################################
def pbLawrenceParty
  poke=Pokemon.new(:INLYS,3,$player)
  poke.ot="Lawrence"
  poke.name="???"
  poke.moves=[
  Move.new(:BITE),
  Move.new(:FACADE),
  Move.new(:MIST),
  Move.new(0)]
  poke.iv = [31,31,31,31,31,31]
  poke.calc_stats
  
  poke2=Pokemon.new(:LICIT,3,$player)
  poke2.ot="Lawrence"
  poke2.name="???"
  poke2.moves=[
  Move.new(:BITE),
  Move.new(:FACADE),
  Move.new(:CHARGE),
  Move.new(0)]
  poke2.iv = [31,31,31,31,31,31]
  poke2.calc_stats  
  
  poke3=Pokemon.new(:VINETTE,3,$player)
  poke3.ot="Lawrence"
  poke3.name="???"
  poke3.moves=[
  Move.new(:BITE),
  Move.new(:FACADE),
  Move.new(:SUNNYDAY),
  Move.new(0)]
  $player.party.push(poke,poke2,poke3)
end


#################################################################################
def pbExxyParty
  poke=Pokemon.new(:RAPIDASH,40,$player)
  poke.ot="Exxy"
  poke.name="Celestial"
  #poke.poke_ball 	  = 12
  poke.form  		    = 1
  poke.gender 	= 1
  poke.ability_index 	= 1
  poke.shiny   	= false
  poke.nature  	= :JOLLY
  poke.item        	= :TWISTEDSPOON
  poke.moves=[
  Move.new(:PSYCHOCUT),
  Move.new(:HEALINGHORN),
  Move.new(:MEGAHORN),
  Move.new(:AGILITY)]
  poke.ev = [4,128,0,128,0,0]
  poke.iv = [31,31,31,31,31,31]
  poke.calc_stats
  $player.party.push(poke)

  poke=Pokemon.new(:MUDSDALE,42,$player)
  poke.ot="Exxy"
  poke.name="Big Horsey"
  #poke.poke_ball 	  = 0
  poke.form  		    = 0
  poke.gender 	= 0
  poke.ability_index 	= 1
  poke.shiny   	= false
  poke.nature  	= :CAREFUL
  poke.item        	= :ASSAULTVEST
  poke.moves=[
  Move.new(:HIGHHORSEPOWER),
  Move.new(:HEAVYSLAM),
  Move.new(:BODYSLAM),
  Move.new(:CLOSECOMBAT)]
  poke.ev = [170,170,170,0,0,0]
  poke.iv = [31,31,31,31,31,31]
  poke.calc_stats
  $player.party.push(poke)

  poke=Pokemon.new(:CHARMANDER,43,$player)
  poke.ot="Exxy"
  poke.name="Taco"
  #poke.poke_ball 	  = 0
  poke.form  		    = 0
  poke.gender 	= 0
  poke.ability_index 	= 0
  poke.shiny   	= true
  poke.nature  	= :BRAVE
  poke.item        	= :EVIOLITE
  poke.moves=[
  Move.new(:FLAREBLITZ),
  Move.new(:THUNDERPUNCH),
  Move.new(:DRAGONCLAW),
  Move.new(:PROTECT)]
  poke.ev = [4,252,0,252,0,0]
  poke.iv = [31,31,31,31,31,31]
  poke.calc_stats
  party=[poke1,poke2,poke3]
  $player.party.push([party].shuffle)
end
#################################################################################
#################################################################################
def pbExxyParty_2
  if $game_variables[EXXY_CHOSEN] == "Morpheon"
    poke=Pokemon.new(:MORPHEON,42,$player)
    poke.ot="Exxy"
    poke.name="Fluffbucket"
    #poke.poke_ball 	  = 13
    poke.form  		    = 0
    poke.gender 	= 0
    poke.ability_index 	= 1
    poke.shiny   	= false
    poke.nature  	= :BOLD
    poke.item        	= :BUGELEMENT
    poke.moves=[
    Move.new(:EMERALDSTORM),
    Move.new(:SLEEPPOWDER),
    Move.new(:STRINGSHOT),
    Move.new(:BABYDOLLEYES)]
    poke.ev = [0,0,4,0,252,252]
    poke.iv = [31,31,31,31,31,31]
    poke.calc_stats
    $player.party.push(poke)
    
  elsif $game_variables[EXXY_CHOSEN] == "Zephyreon"
    poke=Pokemon.new(:ZEPHYREON,42,$player)
    poke.ot="Exxy"
    poke.name="Jack"
    #poke.poke_ball 	  = 18
    poke.form  		    = 0
    poke.gender 	= 0
    poke.ability_index 	= 1
    poke.shiny   	= false
    poke.nature  	= :BOLD
    poke.item        	= :DRAGONSTONE
    poke.moves=[
    Move.new(:AIRSLASH),
    Move.new(:SPARKLINGARIA),
    Move.new(:SING),
    Move.new(:TAILWIND)]
    poke.ev = [0,0,4,0,252,252]
    poke.iv = [31,31,31,31,31,31]
    poke.calc_stats
    $player.party.push(poke)
  end
    
  poke=Pokemon.new(:RAPIDASH,41,$player)
  poke.ot="Exxy"
  poke.name="Celestial"
  #poke.poke_ball 	  = 9
  poke.form  		    = 1
  poke.gender 	= 1
  poke.ability_index 	= 1
  poke.shiny   	= false
  poke.nature  	= :HASTY
  poke.item        	= :SCOPELENS
  poke.moves=[
  Move.new(:PSYCHOCUT),
  Move.new(:MEGAHORN),
  Move.new(:SMARTSTRIKE),
  Move.new(:MYSTICALFIRE)]
  poke.ev = [0,252,0,252,4,0]
  poke.iv = [31,31,31,31,31,31]
  poke.calc_stats
  $player.party.push(poke)

  poke=Pokemon.new(:MUDSDALE,43,$player)
  poke.ot="Exxy"
  poke.name="Big Horsey"
  #poke.poke_ball 	  = 1
  poke.form  		    = 0
  poke.gender 	= 0
  poke.ability_index 	= 1
  poke.shiny   	= false
  poke.nature  	= :CAREFUL
  poke.item        	= :ASSAULTVEST
  poke.moves=[
  Move.new(:HIGHHORSEPOWER),
  Move.new(:HEAVYSLAM),
  Move.new(:BODYSLAM),
  Move.new(:CLOSECOMBAT)]
  poke.ev = [170,170,170,0,0,0]
  poke.iv = [31,31,31,31,31,31]
  poke.calc_stats
  $player.party.push(poke)

  poke=Pokemon.new(:CHARMANDER,44,$player)
  poke.ot="Exxy"
  poke.name="Taco"
  #poke.poke_ball 	  = 0
  poke.form  		    = 0
  poke.gender 	= 0
  poke.ability_index 	= 0
  poke.shiny   	= true
  poke.nature  	= :ADAMANT
  poke.item        	= :EVIOLITE
  poke.moves=[
  Move.new(:FLAREBLITZ),
  Move.new(:THUNDERPUNCH),
  Move.new(:DRAGONCLAW),
  Move.new(:PROTECT)]
  poke.ev = [4,252,0,252,0,0]
  poke.iv = [31,31,31,31,31,31]
  poke.calc_stats
  $player.party.push(poke)
end
#################################################################################
def pbVictiniEgg
  poke              =Pokemon.new(:VICTINI,1,$player)
  #poke.ot          ="TRAINER"
  poke.name        ="Egg"
  #poke.poke_ball 	  = 36
  poke.form  		    = 0
  poke.gender 	= 2
  poke.ability_index  = [0,0,0,0,1,1,1,2,2,2].shuffle[0]
  poke.moves=[
  Move.new(:VCREATE),
  Move.new(:FUSIONBOLT),
  Move.new(:FUSIONFLARE),
  Move.new(:GLACIATE)]
  poke.steps_to_hatch = 65535
  poke.calc_stats
  $player.party.push(poke)
end
    
def pbKeldeoEgg
  poke              =Pokemon.new(:KELDEO,1,$player)
  #poke.ot          ="TRAINER"
  poke.name        ="Egg"
  #poke.poke_ball 	  = 0
  poke.form  		    = 0
  poke.gender 	= 2
  poke.ability_index  = [0,0,0,0,1,1,1,2,2,2].shuffle[0]
  #poke.shiny   = false
  #poke.nature  = :NATURE
  #poke.item        = :ITEM
  #poke.ev          = [0,0,0,0,0,0]
  poke.iv          = [31,31,31,
  [15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31].shuffle[0],
  [15,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31].shuffle[0],
  [10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31].shuffle[0]].shuffle
  poke.moves=[
  Move.new(:SECRETSWORD),
  Move.new(:AQUAJET),
  Move.new(:BOUNCE),
  Move.new(:ICYWIND)]
  poke.steps_to_hatch = 1
  poke.calc_stats
  $player.party.push(poke)
end
################################################################################