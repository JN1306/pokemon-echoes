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
  poke=Pokemon.new(:MENYIGNA,50,$player)
  poke.owner.name="Lawrence"
  poke.name="???"
  poke.moves=[
  Pokemon::Move.new(:ICEBEAM),
  Pokemon::Move.new(:FACADE)]
  poke.iv = pbStatArrayToHash([31,31,31,31,31,31])
  poke.calc_stats
  
  poke2=Pokemon.new(:SERGEVAUL,50,$player)
  poke2.owner.name="Lawrence"
  poke2.name="???"
  poke2.moves=[
  Pokemon::Move.new(:THUNDERBOLT),
  Pokemon::Move.new(:FACADE)]
  poke2.iv = pbStatArrayToHash([31,31,31,31,31,31])
  poke2.calc_stats  
  
  poke3=Pokemon.new(:EUDRAMINA,50,$player)
  poke3.owner.name="Lawrence"
  poke3.name="???"
  poke3.moves=[
  Pokemon::Move.new(:FLAMETHROWER),
  Pokemon::Move.new(:FACADE)]
  poke3.iv = pbStatArrayToHash([31,31,31,31,31,31])
  poke3.calc_stats  
  $player.party.push(poke,poke2,poke3)
end
#################################################################################