def pbAllDataChipMoves
  moves = [
    [:HELPINGHAND,1],
  ]
  if $game_variables[CURRENT_CHAPTER] > 1
    # General Moves
    moves += [
      [PBMoves::HAZE,1],
      [PBMoves::MUDSLAP,1],
      [PBMoves::MEGADRAIN,1],
      [PBMoves::SELFDESTRUCT,1],
      [PBMoves::SNATCH,1],
      [PBMoves::STRINGSHOT,1]
    ]
    # Esper Disc
    if $bag.quantity(:ESPERDISC)>0
      moves += [
        [PBMoves::MEDITATE,1],
        [PBMoves::TELEKINESIS,1]
      ]
    end
  end
  if $game_variables[CURRENT_CHAPTER] > 2
  # General Moves
    moves += [
    [PBMoves::ACUPRESSURE,2],
    [PBMoves::ENDEAVOR,2],
    [PBMoves::ENDURE,2],
    [PBMoves::ICYWIND,2],
    [PBMoves::NATURALGIFT,2],
    [PBMoves::PAYDAY,2],
    [PBMoves::SANDATTACK,2],
    [PBMoves::TAKEDOWN,2],
    ]
    # Psychic Disc
    if $bag.quantity(:ESPERDISC)>0
      moves += [
      [PBMoves::DISABLE,2],
      [PBMoves::GUARDSPLIT,2],
      [PBMoves::GUARDSWAP,2],
      [PBMoves::POWERSPLIT,2],
      [PBMoves::SPEEDSWAP,2],
      ]
    end
  end
  return moves
end

def pbAddDataChipMove(move)
  pbSet(DATA_CHIP_MOVES,[]) if !pbGet(DATA_CHIP_MOVES).is_a?(Array)
  if !$game_variables[DATA_CHIP_MOVES].include?(move)
    $game_variables[DATA_CHIP_MOVES].push(move)
  end
end

def pbHasDataChipMove(move)
  pbSet(DATA_CHIP_MOVES,[]) if !pbGet(DATA_CHIP_MOVES).is_a?(Array)
  return $game_variables[DATA_CHIP_MOVES].include?(move)
end

def pbGetDataChipMoves(pokemon)
  return [] if !pokemon || pokemon.egg? || (pokemon.isShadow? rescue false)
  allMoves = pbAllDataChipMoves
  chipMoves=[]
  # First add unlocked moves
  for i in allMoves
    if pbHasDataChipMove(i[0])
      chipMoves.push(i)
    end
  end
  # Then add locked moves
  for i in allMoves
    if !chipMoves.include?(i)
      chipMoves.push(i)
    end
  end
  # Finally, add a compatability value to each move
  # Sort compatible moves first in list
  for i in chipMoves
    i[2] = pokemon.compatible_with_move?(i[0])
  end
  moves = []
  for i in chipMoves
    moves.push(i) if i[2]
  end
  for i in chipMoves
    moves.push(i) if !i[2]
  end
  return moves|[] # remove duplicates
end

def pbGetTMMoves(pokemon)
  return [] if !pokemon || pokemon.egg? || (pokemon.isShadow? rescue false)
  moves=[]
  GameData::Item.each { |i|
    if i.is_TM? && $bag.quantity(i) > 0
      if pokemon.compatible_with_move?(i.move)
        moves.push([i.move, i.name])
      end
    end
  }
  return moves | [] # remove duplicates
end

def pbGiveAllTMs
  for i in 0...$ItemData.length
    if $ItemData[i][ITEMUSE]==3 && $bag.quantity(i)<=0
      $bag.pbStoreItem(i,1)
    end
  end
  Kernel.pbMessage("Got all TMs")
end

def pbGetLevelUpMoves(pokemon)
  return [] if !pokemon || pokemon.egg? || pokemon.shadowPokemon?
  moves = []
  level_moves = []
  pokemon.getMoveList.each do |m|
    if !moves.include?(m[1])
      level_moves.push([m[1], m[0]])
      moves.push(m[1])
    end
  end
  if pokemon.first_moves
    for i in pokemon.first_moves
      if !moves.include?(i)
        level_moves.push([i, 0])
        moves.push(i)
      end
    end
  end
  level_moves.sort! {|a,b| a[1]<=>b[1]}
  return level_moves
end 