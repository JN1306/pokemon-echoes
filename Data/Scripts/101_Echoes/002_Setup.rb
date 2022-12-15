def pbStarter
  return $game_variables[SETUP] 
end

def pbDifficulty
  return pbStarter[0]
end

def pbStyle
  return pbStarter[1]
end

def pbType
  return pbStarter[2]
end

def pbSt_Pkmn
  return pbStarter[3]
end

def pbChapter
  return $game_variables[CURRENT_CHAPTER]
end

def pbAnswer
  return $game_variables[500]
end

def pbSetup(style=1,type=1,dfc=0)
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
  # Style Select (Starter Choice)
  loop do
    pbText("\\l[3]Which battle style do you prefer? (This will determine the moves of your starter Eevee as well as various trainer teams)\\ch[500,0,Offensive,Defensive,Balanced]")
    style += pbAnswer
    pbText("Are you sure?\\ch[500,0,Yes,No]")
    break if pbAnswer==0
  end
  # Type Select
  Kernel.pbMessage("Which is your favorite type?\\ch[500,0,Normal,Grass, Fire,Water,Bug,Electric,Rock,Gouund,Steel,Fighting,Flying,Poison,Ice,Fairy,Psychic,Dark,Ghost,Dragon]")
  type += pbAnswer
  $game_variables[SETUP].push(dfc,style,type,-1)
  if  $DEBUG && Input.press?(Input::CTRL)
    pbText("Whuch chapter would like to skip to?\\ch[500,0,Intro,Ch 1,Ch 2, Ch 3,Ch 4,Ch 5,Ch 6,Ch 7]")
    $game_variables[CURRENT_CHAPTER] =  pbAnswer
    if $game_variables[CURRENT_CHAPTER] > 2
      pbTrainerName("Lawrence")
      pbInitUniquePokemon
      $player.has_pokedex=true
      $player.has_running_shoes=true
    else
      pbChapterSkip
    end
  else
    pbTrainerName("Lawrence")
    pbInitUniquePokemon
    $player.has_pokedex=true
    $player.has_running_shoes=true
  end
end

def pbChapterSkip(ch=pbChapter,st=pbType,lv=5,p1=false,p2=false,p3=false,p4=false,p5=false,p6=false,sp1=false,sp2=false,sp3=false,sp4=false,sp5=false,sp6=false)
  pbTrainerName("Debug")
  pbInitUniquePokemon
  pbUnlockDex
  $player.has_pokedex=true
  $player.seen_storage_creator=true
  $player.has_running_shoes=true
  $quests.enabled=true if ch > 0
  if ch >= 2
    pbText("Second Starter?\\ch[500,0,Inlys,Licit,Vinette]")
    # Ice - Electric, Fire - Ice, Electric - Fire
    pbStarterItems
    case st
    when 1; sp1=:TRANSLUCEON # Normal
    end
    sp2 = pbCreateStarter(2)
    case ch
    when 2
      lv += 4
      case pbAnswer
      when 0 # Ice
        $game_variables[SETUP][3]="Inlys"
        sp3 = [:POOCHYENA,:DUCKLETT,:STARLY].shuffle[0]
      when 1 # Electric
        $game_variables[SETUP][3]="Licit"
        sp3 = [:POOCHYENA,:BIDOOF,:PICHU].shuffle[0]
      when 2 # Fire
        $game_variables[SETUP][3]="Vinette"
        sp3 = [:POOCHYENA,:SPINARAK,:TAILLOW].shuffle[0]
      end
    end
    p1=Pokemon.new(sp1,lv,$Trainer)     if sp1
    p2=Pokemon.new(sp2,(lv-1),$Trainer) if sp2
    p3=Pokemon.new(sp3,(lv-2),$Trainer) if sp3
    p4=Pokemon.new(sp4,(lv-3),$Trainer) if sp4
    p5=Pokemon.new(sp5,(lv-4),$Trainer) if sp5
    p6=Pokemon.new(sp6,(lv-5),$Trainer) if sp6
    for p in [p1,p2,p3,p4,p5,p6]
      if p
        $Trainer.party.push(p)
        for s in [sp1,sp2,sp3,sp4,sp5,sp6]
          if s
            $Trainer.setSeen(s); $Trainer.setOwned(s)
          end
        end
      end
    end
    ####### Chapter 2 ##############
    ####### In-Game stats, Items etc... ##############
    # Teleport Locations
    pbRegisterDestination(42,19,14,0,0)   # Furkuri Outskirts (Home)
    pbRegisterDestination(132,10,13,0,0)  # Furkuri Town
    # Manditory Quests
    pbFinishChapter(:FamilyOuting,true)
    pbFinishQuest(:BattlePractice,true)
    pbFinishChapter(:Remedy,true)
    # Landmarks (Set Switches of Relevant events)
    # Fukuri Stone Monument
    $game_variables[LANDMARK_ID] = "Fukuri Stone Monument"
    $game_self_switches[[75,20,"A"]]=true
    $game_self_switches[[75,21,"A"]]=true
    pbLandmarks(true)
    # Secluded Grove
    $game_variables[LANDMARK_ID] = "Secluded Grove"
    $game_self_switches[[135,7,"B"]]=true
    pbLandmarks(true,true)
    # Manditory Items
    $PokemonBag.pbStoreItem(PBItems::TM54,1)
    # Achievement Quests / Other (note in parantheses)
    $game_variables[AURA_PKMN_ID] = "Striding Gerid"
    pbRegisterUniquePokemonSeen("Striding Gerid")
    pbItemOrb("Striding Gerid",true,true)
    $game_switches[AURA_PKMN_DISCOVERED]=true
    $game_switches[ITEM_ORBS_DISCOVERED]=true
  end
  if ch >= 3
  ###### Chapter 3 ######
  end
end

def pbStarterItems(dfc=pbDifficulty,money=(3 - dfc)*1000)
  pbSEPlay("ItemGet.ogg")
  $Trainer.setSeen(:EEVEE); $Trainer.setOwned(:EEVEE)
  if money > 0
    $Trainer.money += money 
    pbDisplaySmall(_INTL("You got $ {1}",number_with_delimiter(money)))
  end
  Kernel.pbReceiveItem(PBItems::GREATBALL,1,false) if dfc == 0
  Kernel.pbReceiveItem(PBItems::POKEBALL,5,false)
  Kernel.pbReceiveItem(PBItems::POTION,[(3-dfc),1].max,false)
  Kernel.pbReceiveItem(PBItems::DATACHIP,1,false)
end

def pbCreateStarter(mode=1,lvl=5,dfc=pbStarter[0],st=pbStarter[1],pc=pbStarter[3])
######### Starter #############################
  case mode
  when 1 # Starter Eevee
    $Trainer.setSeen(:EEVEE); $Trainer.setOwned(:EEVEE)
    case st
    when 1 # Offensive Style
      case dfc
      when 0 # Easy
        poke=Pokemon.new(:EEVEE,lvl,$Trainer)
        poke.abilityflag = 2
        poke.genderflag = 0
        poke.moves=[
        PBMove.new(PBMoves::TACKLE),
        PBMove.new(PBMoves::BITE),
        PBMove.new(PBMoves::ROUND),
        PBMove.new(PBMoves::TAILWHIP)]
        poke.iv = [31,31,31,31,31,31]
        poke.calcStats
      when 1 # Normal
        poke=Pokemon.new(:EEVEE,lvl,$Trainer)
        poke.abilityflag = 1
        poke.genderflag = 0
        poke.moves=[
        PBMove.new(PBMoves::TACKLE),
        PBMove.new(PBMoves::BITE),
        PBMove.new(PBMoves::ROUND),
        PBMove.new(PBMoves::TAILWHIP)]
        poke.iv = [31,31,
                  (15..31).to_a.shuffle[0],
                  (15..31).to_a.shuffle[0],
                  (10..31).to_a.shuffle[0],
                  (10..31).to_a.shuffle[0]].shuffle
        poke.calcStats
      when 2 # Hard
        poke=Pokemon.new(:EEVEE,lvl,$Trainer)
        poke.abilityflag = 1
        poke.genderflag = 0
        poke.moves=[
        PBMove.new(PBMoves::TACKLE),
        PBMove.new(PBMoves::BITE),
        PBMove.new(PBMoves::ROUND),
        PBMove.new(PBMoves::TAILWHIP)]
        poke.iv = [31,
                  (15..31).to_a.shuffle[0],
                  (10..31).to_a.shuffle[0],
                  (10..31).to_a.shuffle[0],
                  (5..31).to_a.shuffle[0],
                  (0..31).to_a.shuffle[0]].shuffle
        poke.calcStats
      when 3 # V-Hard
        poke=Pokemon.new(:EEVEE,lvl,$Trainer)
        poke.abilityflag = 1
        poke.genderflag = 0
        poke.moves=[
        PBMove.new(PBMoves::TACKLE),
        PBMove.new(PBMoves::BITE),
        PBMove.new(PBMoves::ROUND),
        PBMove.new(PBMoves::TAILWHIP)]
        poke.calcStats
      end
    #### DEFENSE STYLE ################
    when 2
      case dfc
      when 0 # Easy
        poke=Pokemon.new(:EEVEE,lvl,$Trainer)
        poke.abilityflag = 1
        poke.genderflag = 0
        poke.moves=[
        PBMove.new(PBMoves::TACKLE),
        PBMove.new(PBMoves::BITE),
        PBMove.new(PBMoves::BABYDOLLEYES),
        PBMove.new(PBMoves::SANDATTACK)]
        poke.iv = [31,31,31,31,31,31]
        poke.calcStats
      when 1 # Normal
        poke=Pokemon.new(:EEVEE,lvl,$Trainer)
        poke.abilityflag = 1
        poke.genderflag = 0
        poke.moves=[
        PBMove.new(PBMoves::TACKLE),
        PBMove.new(PBMoves::BITE),
        PBMove.new(PBMoves::BABYDOLLEYES),
        PBMove.new(PBMoves::SANDATTACK)]
        poke.iv = [31,31,
                  (15..31).to_a.shuffle[0],
                  (15..31).to_a.shuffle[0],
                  (10..31).to_a.shuffle[0],
                  (10..31).to_a.shuffle[0]].shuffle
        poke.calcStats
      when 2 # Hard
        poke=Pokemon.new(:EEVEE,lvl,$Trainer)
        poke.abilityflag = 1
        poke.genderflag = 0
        poke.moves=[
        PBMove.new(PBMoves::TACKLE),
        PBMove.new(PBMoves::BITE),
        PBMove.new(PBMoves::BABYDOLLEYES),
        PBMove.new(PBMoves::SANDATTACK)]
        poke.iv = [31,
                  (15..31).to_a.shuffle[0],
                  (10..31).to_a.shuffle[0],
                  (10..31).to_a.shuffle[0],
                  (5..31).to_a.shuffle[0],
                  (0..31).to_a.shuffle[0]].shuffle
        poke.calcStats
      when 3 # V-Hard
        poke=Pokemon.new(:EEVEE,lvl,$Trainer)
        poke.abilityflag = 1
        poke.genderflag = 0
        poke.moves=[
        PBMove.new(PBMoves::TACKLE),
        PBMove.new(PBMoves::BITE),
        PBMove.new(PBMoves::ROUND),
        PBMove.new(PBMoves::TAILWHIP)]
        poke.calcStats
      end
    ### BALANCED STYLE ################
    when 3 # Balanced Style
      case dfc
      when 0 # Easy
        poke=Pokemon.new(:EEVEE,lvl,$Trainer)
        poke.abilityflag = 1
        poke.genderflag = 0
        poke.moves=[
        PBMove.new(PBMoves::TACKLE),
        PBMove.new(PBMoves::BITE),
        PBMove.new(PBMoves::TICKLE),
        PBMove.new(PBMoves::COPYCAT)]
        poke.iv = [31,31,31,31,31,31]
        poke.calcStats
      when 1 # Normal
        poke=Pokemon.new(:EEVEE,5,$Trainer)
        poke.abilityflag = 1
        poke.genderflag = 0
        poke.moves=[
        PBMove.new(PBMoves::TACKLE),
        PBMove.new(PBMoves::BITE),
        PBMove.new(PBMoves::TICKLE),
        PBMove.new(PBMoves::COPYCAT)]
        poke.iv = [31,31,
        (15..31).to_a.shuffle[0],
        (15..31).to_a.shuffle[0],
        (10..31).to_a.shuffle[0],
        (10..31).to_a.shuffle[0]].shuffle
        poke.calcStats
      when 2 # Hard
        poke=Pokemon.new(:EEVEE,lvl,$Trainer)
        poke.abilityflag = 1
        poke.genderflag = 0
        poke.moves=[
        PBMove.new(PBMoves::TACKLE),
        PBMove.new(PBMoves::BITE),
        PBMove.new(PBMoves::TICKLE),
        PBMove.new(PBMoves::COPYCAT)]
        poke.iv = [31,
                  (15..31).to_a.shuffle[0],
                  (10..31).to_a.shuffle[0],
                  (10..31).to_a.shuffle[0],
                  (5..31).to_a.shuffle[0],
                  (0..31).to_a.shuffle[0]].shuffle
        poke.calcStats
      when 3 # V-Hard
        poke=Pokemon.new(:EEVEE,lvl,$Trainer)
        poke.abilityflag = 1
        poke.genderflag = 0
        poke.moves=[
        PBMove.new(PBMoves::TACKLE),
        PBMove.new(PBMoves::BITE),
        PBMove.new(PBMoves::TICKLE),
        PBMove.new(PBMoves::COPYCAT)]
        poke.calcStats
      end
    end
  when 2 # Elemental Starter
    case pc
    when "Inlys"
      case dfc
      when 0 # Easy
        poke=Pokemon.new(:INLYS,lvl,$Trainer)
        poke.iv = [31,31,31,31,31,31]
        poke.calcStats
      when 1 # Normal
        poke=Pokemon.new(:INLYS,lvl,$Trainer)
        poke.iv = [31,31,
        (15..31).to_a.shuffle[0],
        (15..31).to_a.shuffle[0],
        (10..31).to_a.shuffle[0],
        (10..31).to_a.shuffle[0]].shuffle
        poke.calcStats
      when 2 # Hard
        poke=Pokemon.new(:INLYS,lvl,$Trainer)
        poke.iv = [31,
                  (15..31).to_a.shuffle[0],
                  (10..31).to_a.shuffle[0],
                  (10..31).to_a.shuffle[0],
                  (5..31).to_a.shuffle[0],
                  (0..31).to_a.shuffle[0]].shuffle
        poke.calcStats
      when 3 # V-Hard
        poke=Pokemon.new(:INLYS,lvl,$Trainer)
      end
    when "Licit" # Licit
      case dfc
      when 0 # Easy
        poke=Pokemon.new(:LICIT,lvl,$Trainer)
        poke.iv = [31,31,31,31,31,31]
        poke.calcStats
      when 1 # Normal
        poke=Pokemon.new(:LICIT,lvl,$Trainer)
        poke.iv = [31,31,
        (15..31).to_a.shuffle[0],
        (15..31).to_a.shuffle[0],
        (10..31).to_a.shuffle[0],
        (10..31).to_a.shuffle[0]].shuffle
        poke.calcStats
      when 2 # Hard
        poke=Pokemon.new(:LICIT,lvl,$Trainer)
        poke.iv = [31,
                  (15..31).to_a.shuffle[0],
                  (10..31).to_a.shuffle[0],
                  (10..31).to_a.shuffle[0],
                  (5..31).to_a.shuffle[0],
                  (0..31).to_a.shuffle[0]].shuffle
        poke.calcStats
      when 3 # V-Hard
        poke=Pokemon.new(:LICIT,lvl,$Trainer)
      end
    when "Vinette" # Vinette
      case dfc
      when 0 # Easy
        poke=Pokemon.new(:VINETTE,lvl,$Trainer)
        poke.iv = [31,31,31,31,31,31]
        poke.calcStats
      when 1 # Normal
        poke=Pokemon.new(:VINETTE,lvl,$Trainer)
        poke.iv = [31,31,
        (15..31).to_a.shuffle[0],
        (15..31).to_a.shuffle[0],
        (10..31).to_a.shuffle[0],
        (10..31).to_a.shuffle[0]].shuffle
        poke.calcStats
      when 2 # Hard
        poke=Pokemon.new(:VINETTE,lvl,$Trainer)
        poke.iv = [31,
                  (15..31).to_a.shuffle[0],
                  (10..31).to_a.shuffle[0],
                  (10..31).to_a.shuffle[0],
                  (5..31).to_a.shuffle[0],
                  (0..31).to_a.shuffle[0]].shuffle
        poke.calcStats
        $Trainer.party.push(poke)
      when 3 # V-Hard
        poke=Pokemon.new(:VINETTE,lvl,$Trainer)
      end
    end
  end
  $Trainer.party.push(poke)
end
