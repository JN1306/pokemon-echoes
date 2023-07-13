#===============================================================================
# Echoes Exclusive PokéBalls
#===============================================================================
Battle::PokeBallEffects::ModifyCatchRate.add(:VISIONBALL, proc { |ball, catchRate, battle, battler|
  multiplier = (Settings::NEW_POKE_BALL_CATCH_RATES) ? 3.5 : 3
  catchRate *= multiplier if battler.pbHasType?(:NORMAL) || battler.pbHasType?(:PSYCHIC)
  next catchRate
})

Battle::PokeBallEffects::ModifyCatchRate.add(:SOLARBALL, proc { |ball, catchRate, battle, battler|
  multiplier = (Settings::NEW_POKE_BALL_CATCH_RATES) ? 3.5 : 3
  catchRate *= multiplier if battler.pbHasType?(:FIRE) || battler.pbHasType?(:GRASS)
  next catchRate
})

Battle::PokeBallEffects::ModifyCatchRate.add(:NETBALL, proc { |ball, catchRate, battle, battler|
  multiplier = (Settings::NEW_POKE_BALL_CATCH_RATES) ? 3.5 : 3
  catchRate *= multiplier if battler.pbHasType?(:BUG) || battler.pbHasType?(:WATER)
  next catchRate
})

Battle::PokeBallEffects::ModifyCatchRate.add(:STORMBALL, proc { |ball, catchRate, battle, battler|
  multiplier = (Settings::NEW_POKE_BALL_CATCH_RATES) ? 3.5 : 3
  catchRate *= multiplier if battler.pbHasType?(:ELECTRIC) || battler.pbHasType?(:FLYING)
  next catchRate
})

Battle::PokeBallEffects::ModifyCatchRate.add(:INDUSTRYBALL, proc { |ball, catchRate, battle, battler|
  multiplier = (Settings::NEW_POKE_BALL_CATCH_RATES) ? 3.5 : 3
  catchRate *= multiplier if battler.pbHasType?(:STEEL) || battler.pbHasType?(:GROUND)
  next catchRate
})

Battle::PokeBallEffects::ModifyCatchRate.add(:HAZARDBALL, proc { |ball, catchRate, battle, battler|
  multiplier = (Settings::NEW_POKE_BALL_CATCH_RATES) ? 3.5 : 3
  catchRate *= multiplier if battler.pbHasType?(:POISON) || battler.pbHasType?(:ROCK)
  next catchRate
})

Battle::PokeBallEffects::ModifyCatchRate.add(:SPIRITBALL, proc { |ball, catchRate, battle, battler|
  multiplier = (Settings::NEW_POKE_BALL_CATCH_RATES) ? 3.5 : 3
  catchRate *= multiplier if battler.pbHasType?(:FIGHTING) || battler.pbHasType?(:GHOST)
  next catchRate
})

Battle::PokeBallEffects::ModifyCatchRate.add(:EOSBALL, proc { |ball, catchRate, battle, battler|
  multiplier = (Settings::NEW_POKE_BALL_CATCH_RATES) ? 3.5 : 3
  catchRate *= multiplier if battler.pbHasType?(:ICE) || battler.pbHasType?(:FAIRY)
  next catchRate
})

Battle::PokeBallEffects::ModifyCatchRate.add(:HUNTINGBALL, proc { |ball, catchRate, battle, battler|
  multiplier = (Settings::NEW_POKE_BALL_CATCH_RATES) ? 3.5 : 3
  catchRate *= multiplier if battler.pbHasType?(:DARK) || battler.pbHasType?(:DRAGON)
  next catchRate
})

Battle::PokeBallEffects::ModifyCatchRate.add(:DIMENSIONBALL, proc { |ball, catchRate, battle, battler|
  multiplier = (Settings::NEW_POKE_BALL_CATCH_RATES) ? 3.5 : 3
  catchRate *= multiplier if @battle.field.effects[PBEffects::TrickRoom] > 0 ||
                             @battle.field.effects[PBEffects::MagicRoom] > 0 ||
                             @battle.field.effects[PBEffects::WonderRoom] > 0 ||
                             @battle.field.effects[PBEffects::ParadoxRoom] > 0 
  next catchRate
})

Battle::PokeBallEffects::ModifyCatchRate.add(:PETALBALL, proc { |ball, catchRate, battle, battler|
  # NOTE: Moon Ball cares about whether any species in the target's evolutionary
  #       family can evolve with the Leaf Stone, not whether the target itself
  #       can immediately evolve with the Leaf Stone.
  leaf_stone = GameData::Item.try_get(:LEAFSTONE)
  if leaf_stone && battler.pokemon.species_data.family_item_evolutions_use_item?(leaf_stone.id)
    catchRate *= 4
  end
  next [catchRate, 255].min
})

Battle::PokeBallEffects::ModifyCatchRate.add(:VAPORBALL, proc { |ball, catchRate, battle, battler|
  # NOTE: Moon Ball cares about whether any species in the target's evolutionary
  #       family can evolve with the Water Stone, not whether the target itself
  #       can immediately evolve with the Moon Stone.
  water_stone = GameData::Item.try_get(:WATERSTONE)
  if water_stone && battler.pokemon.species_data.family_item_evolutions_use_item?(water_stone.id)
    catchRate *= 4
  end
  next [catchRate, 255].min
})

Battle::PokeBallEffects::ModifyCatchRate.add(:FLAREBALL, proc { |ball, catchRate, battle, battler|
  # NOTE: Moon Ball cares about whether any species in the target's evolutionary
  #       family can evolve with the Flare Stone, not whether the target itself
  #       can immediately evolve with the Moon Stone.
  fire_stone = GameData::Item.try_get(:FIRESTONE)
  if fire_stone && battler.pokemon.species_data.family_item_evolutions_use_item?(fire_stone.id)
    catchRate *= 4
  end
  next [catchRate, 255].min
})

Battle::PokeBallEffects::ModifyCatchRate.add(:JOLTBALL, proc { |ball, catchRate, battle, battler|
  # NOTE: Moon Ball cares about whether any species in the target's evolutionary
  #       family can evolve with the Thunder Stone, not whether the target itself
  #       can immediately evolve with the Moon Stone.
  thunder_stone = GameData::Item.try_get(:THUNDERSTONE)
  if thunder_stone && battler.pokemon.species_data.family_item_evolutions_use_item?(thunder_stone.id)
    catchRate *= 4
  end
  next [catchRate, 255].min
})

Battle::PokeBallEffects::ModifyCatchRate.add(:MORNINGBALL, proc { |ball, catchRate, battle, battler|
  # NOTE: Moon Ball cares about whether any species in the target's evolutionary
  #       family can evolve with the Sun Stone, not whether the target itself
  #       can immediately evolve with the Moon Stone.
  sun_stone = GameData::Item.try_get(:SUNSTONE)
  if sun_stone && battler.pokemon.species_data.family_item_evolutions_use_item?(sun_stone.id)
    catchRate *= 4
  end
  next [catchRate, 255].min
})

Battle::PokeBallEffects::ModifyCatchRate.add(:TWILIGHTBALL, proc { |ball, catchRate, battle, battler|
  # NOTE: Moon Ball cares about whether any species in the target's evolutionary
  #       family can evolve with the Dusk or Dawn Stone, not whether the target itself
  #       can immediately evolve with the Moon Stone.
  dusk_stone = GameData::Item.try_get(:DUSKSTONE)
  dawn_stone = GameData::Item.try_get(:DAWNSTONE)
  if (dusk_stone && battler.pokemon.species_data.family_item_evolutions_use_item?(dusk_stone.id) ||
      dawn_stone && battler.pokemon.species_data.family_item_evolutions_use_item?(dawn_stone.id))
    catchRate *= 4
  end
  next [catchRate, 255].min
})

Battle::PokeBallEffects::ModifyCatchRate.add(:CRYSTALBALL, proc { |ball, catchRate, battle, battler|
  # NOTE: Moon Ball cares about whether any species in the target's evolutionary
  #       family can evolve with the Shiny or Ice Stone, not whether the target itself
  #       can immediately evolve with the Moon Stone.
  ice_stone = GameData::Item.try_get(:ICESTONE)
  shiny_stone = GameData::Item.try_get(:SHINYSTONE)
  if (ice_stone && battler.pokemon.species_data.family_item_evolutions_use_item?(ice_stone.id) ||
      shiny_stone && battler.pokemon.species_data.family_item_evolutions_use_item?(shiny_stone.id))
    catchRate *= 4
  end
  next [catchRate, 255].min
})

Battle::PokeBallEffects::ModifyCatchRate.add(:TRANSMUTEBALL, proc { |ball, catchRate, battle, battler|
  catchRate *= 4 if battler.pokemon.species_data.has_flag?("Alchemy")
  next [catchRate, 255].min
})

Battle::PokeBallEffects::ModifyCatchRate.add(:GAMBLEBALL, proc { |ball, catchRate, battle, battler|
  tier = [1,1,1,1,2,2,2,3,3,4].shuffle[0]
  mult1 = 0; mult2 = 0; final = 0.0
  case tier
  when 1
    mult1 = [0,1,1,1,2].shuffle[0]
  when 2
    mult1 = [1,1,2,2,3].shuffle[0]
  when 3
    mult1 = [2,2,3,3,4].shuffle[0]
  when 4
    mult1 = [3,3,4,4,5].shuffle[0]
  end
  mult2 = (@battle.pbRandom(11) / 10.0)
  final = (mult1 + mult2)
  catchRate *= final
  next [catchRate, 255].min
})

Battle::PokeBallEffects::ModifyCatchRate.add(:JACKPOTBALL, proc { |ball, catchRate, battle, battler|
  total = 0; slot1 = 0; slot2 = 0; slot3 = 0
  slot1 += (@battle.pbRandom(7)+1)
  slot2 += (@battle.pbRandom(7)+1)
  slot3 += (@battle.pbRandom(7)+1)
  total = (slot1 + slot2 + slot3)
  if total == 21
    next true
  elsif total > 3
    catchRate *= (total / 4.0)
    next [catchRate, 255].min
  else
    catchRate *= 0.1
    next [catchRate, 255].min 
  end
})

Battle::PokeBallEffects::ModifyCatchRate.add(:WEALTHBALL, proc { |ball, catchRate, battle, battler|
  money = $player.money
  moneymult
  if money >= 1000000
    mult = 6
  elsif money >= 500000
    mult = 5
  elsif money >= 200000
    mult = 4
  elsif money >= 100000
    mult = 3
  elsif money >= 50000
    mult = 2
  elsif money >= 20000
    mult = 1.5
  elsif money >= 10000 
    mult = 1
  elsif money >= 5000
    mult = 0.5
  else
    mult = 0.1
  end
  $player.money = [($player.money * 0.85).round , 1].max
  catchRate *= mult 
  next [catchRate, 255].min
})


Battle::PokeBallEffects::ModifyCatchRate.add(:RELICBALL, proc { |ball, catchRate, battle, battler|
  if battler.pokemon.species_data.has_flag?("Fossil")
    catchRate *= 5
  else
    catchRate /= 10
  end
  next catchRate
})

Battle::PokeBallEffects::ModifyCatchRate.add(:GLYPHBALL, proc { |ball, catchRate, battle, battler|
  if battler.pokemon.species(:UNOWN)
    catchRate *= 5
  else
    catchRate /= 10
  end
  next catchRate
})

Battle::PokeBallEffects::ModifyCatchRate.add(:QUANTUMBALL, proc { |ball, catchRate, battle, battler|
  if battler.pokemon.species_data.has_flag?("Quantum Beast")
    catchRate *= 5
  else
    catchRate /= 10
  end
  next catchRate
})



