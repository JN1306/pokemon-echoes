def pbStarter
  return $game_variables[SETUP] 
end

def pbDifficulty
  return pbStarter[0]
end

def pbType
  return pbStarter[1]
end

def pbSt_Pkmn
  return pbStarter[2]
end

def pbChapter
  return $game_variables[CURRENT_HAPTER]
end

def pbAnswer
  return $game_variables[500]
end

def pbSetup(type=1,dfc=0)
  $game_variables[SETUP] = []
  # Difficulty Choice
  loop do
    pbText("Which difficulty would you like to play?\\ch[500,0,Easy,Normal,Hard,Very Hard]")
    dfc = pbAnswer
    case dfc
    when 0 
      pbText("Do you want to play on [B]Easy Mode[/]\\ch[500,0,Yes,No]")
    when 1
      pbText("Do you want to play on [Y]Normal Mode[/]\\ch[500,0,Yes,No]")
    when 2
      pbText("Do you want to play on [R]Hard Mode[/]\\ch[500,0,Yes,No]")
    when 3
      pbText("Do you want to play on [P]Very Hard Mode[/]\\ch[500,0,Yes,No]")
    end
    break if pbAnswer == 0
  end
  # Type Select
  pbMessage("Which is your favorite type?\\ch[500,0,Normal,Grass, Fire,Water,Bug,Electric,Rock,Gouund,Steel,Fighting,Flying,Poison,Ice,Fairy,Psychic,Dark,Ghost,Dragon]")
  type += pbAnswer
  $game_variables[SETUP].push(dfc,type,-1)
  pbTrainerName("Lawrence")
  pbInitUniquePokemon
  $player.has_pokedex=true
  $player.has_running_shoes=true
end

def pbStarterItems(dfc=pbDifficulty,money=(3 - dfc)*1000)
  pbSEPlay("ItemGet.ogg")
  if money > 0
    $player.money += money 
    pbDisplaySmall(_INTL("You got $ {1}",number_with_delimiter(money)))
  end
  pbReceiveItem(:GREATBALL,1,false) if dfc == 0
  pbReceiveItem(:POKEBALL,5,false)
  pbReceiveItem(:POTION,[(3-dfc),1].max,false)
  pbReceiveItem(:DATACHIP,1,false)
end

def pbCreateStarter(mode=1,lvl=5,dfc=pbStarter[0])
######### Starter #############################
  case mode
  when 1 # Starter Eevee
    case dfc
    when 0 # Easy
      poke=Pokemon.new(:EEVEE,lvl,$player)
      poke.ability_index = 2
      poke.gender = 0
      poke.moves=[
      Pokemon::Move.new(:TACKLE),
      Pokemon::Move.new(:BITE),
      Pokemon::Move.new(:ROUND),
      Pokemon::Move.new(:TAILWHIP)]
      poke.iv = pbStatArrayToHash([31,31,31,31,31,31])
      poke.calc_stats
    when 1 # Normal
      poke=Pokemon.new(:EEVEE,lvl,$player)
      poke.ability_index = 1
      poke.gender = 0
      poke.moves=[
      Pokemon::Move.new(:TACKLE),
      Pokemon::Move.new(:BITE),
      Pokemon::Move.new(:ROUND),
      Pokemon::Move.new(:TAILWHIP)]
      poke.iv = pbStatArrayToHash([31,31,
                (15..31).to_a.shuffle[0],
                (15..31).to_a.shuffle[0],
                (10..31).to_a.shuffle[0],
                (10..31).to_a.shuffle[0]].shuffle)
      poke.calc_stats
    when 2 # Hard
      poke=Pokemon.new(:EEVEE,lvl,$player)
      poke.ability_index = 1
      poke.gender = 0
      poke.moves=[
      Pokemon::Move.new(:TACKLE),
      Pokemon::Move.new(:BITE),
      Pokemon::Move.new(:ROUND),
      Pokemon::Move.new(:TAILWHIP)]
      poke.iv = pbStatArrayToHash([31,
                (15..31).to_a.shuffle[0],
                (10..31).to_a.shuffle[0],
                (10..31).to_a.shuffle[0],
                (5..31).to_a.shuffle[0],
                (0..31).to_a.shuffle[0]].shuffle)
      poke.calc_stats
    when 3 # V-Hard
      poke=Pokemon.new(:EEVEE,lvl,$player)
      poke.ability_index = 1
      poke.gender = 0
      poke.moves=[
      Pokemon::Move.new(:TACKLE),
      Pokemon::Move.new(:BITE),
      Pokemon::Move.new(:ROUND),
      Pokemon::Move.new(:TAILWHIP)]
      poke.calc_stats
    end
  when 2 # Elemental Starter
    case pc
    when "Inlys"
      case dfc
      when 0 # Easy
        poke=Pokemon.new(:INLYS,lvl,$player)
        poke.iv = pbStatArrayToHash([31,31,31,31,31,31])
        poke.calc_stats
      when 1 # Normal
        poke=Pokemon.new(:INLYS,lvl,$player)
        poke.iv = pbStatArrayToHash([31,31,
        (15..31).to_a.shuffle[0],
        (15..31).to_a.shuffle[0],
        (10..31).to_a.shuffle[0],
        (10..31).to_a.shuffle[0]].shuffle)
        poke.calc_stats
      when 2 # Hard
        poke=Pokemon.new(:INLYS,lvl,$player)
        poke.iv = pbStatArrayToHash([31,
                  (15..31).to_a.shuffle[0],
                  (10..31).to_a.shuffle[0],
                  (10..31).to_a.shuffle[0],
                  (5..31).to_a.shuffle[0],
                  (0..31).to_a.shuffle[0]].shuffle)
        poke.calc_stats
      when 3 # V-Hard
        poke=Pokemon.new(:INLYS,lvl,$player)
      end
    when "Licit" # Licit
      case dfc
      when 0 # Easy
        poke=Pokemon.new(:LICIT,lvl,$player)
        poke.iv = pbStatArrayToHash([31,31,31,31,31,31])
        poke.calc_stats
      when 1 # Normal
        poke=Pokemon.new(:LICIT,lvl,$player)
        poke.iv = pbStatArrayToHash([31,31,
        (15..31).to_a.shuffle[0],
        (15..31).to_a.shuffle[0],
        (10..31).to_a.shuffle[0],
        (10..31).to_a.shuffle[0]].shuffle)
        poke.calc_stats
      when 2 # Hard
        poke=Pokemon.new(:LICIT,lvl,$player)
        poke.iv = pbStatArrayToHash([31,
                  (15..31).to_a.shuffle[0],
                  (10..31).to_a.shuffle[0],
                  (10..31).to_a.shuffle[0],
                  (5..31).to_a.shuffle[0],
                  (0..31).to_a.shuffle[0]].shuffle)
        poke.calc_stats
      when 3 # V-Hard
        poke=Pokemon.new(:LICIT,lvl,$player)
      end
    when "Vinette" # Vinette
      case dfc
      when 0 # Easy
        poke=Pokemon.new(:VINETTE,lvl,$player)
        poke.iv = pbStatArrayToHash([31,31,31,31,31,31])
        poke.calc_stats
      when 1 # Normal
        poke=Pokemon.new(:VINETTE,lvl,$player)
        poke.iv = pbStatArrayToHash([31,31,
        (15..31).to_a.shuffle[0],
        (15..31).to_a.shuffle[0],
        (10..31).to_a.shuffle[0],
        (10..31).to_a.shuffle[0]].shuffle)
        poke.calc_stats
      when 2 # Hard
        poke=Pokemon.new(:VINETTE,lvl,$player)
        poke.iv = pbStatArrayToHash([31,
                  (15..31).to_a.shuffle[0],
                  (10..31).to_a.shuffle[0],
                  (10..31).to_a.shuffle[0],
                  (5..31).to_a.shuffle[0],
                  (0..31).to_a.shuffle[0]].shuffle)
        poke.calc_stats
        $player.party.push(poke)
      when 3 # V-Hard
        poke=Pokemon.new(:VINETTE,lvl,$player)
      end
    end
  end
  $player.party.push(poke)
end
