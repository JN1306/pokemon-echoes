#===============================================================================
# OnSwitchIn handlers
#===============================================================================
Battle::ItemEffects::OnSwitchIn.add(:BERSERKERGLOVE,
  proc { |item, battler, battle|
    next if !battler.pbCanRaiseStatStage?(:ATTACK)
    battle.pbCommonAnimation("UseItem", battler)
    battle.pbDisplay(_INTL("{1}'s {2} glowed with power!", battler.pbThis, battler.itemName))
    battler.pbRaiseStatStage(:ATTACK, 1, nil)
    battler.pbHeldItemTriggered(item)
    battler.pbConsumeItem
  }
)

Battle::ItemEffects::OnSwitchIn.add(:JADEGUARD,
  proc { |item, battler, battle|
    next if !battler.pbCanRaiseStatStage?(:DEFENSE)
    battle.pbCommonAnimation("UseItem", battler)
    battle.pbDisplay(_INTL("{1}'s {2} glows with shielding energy!", battler.pbThis, battler.itemName))
    battler.pbRaiseStatStage(:DEFENSE, 1, nil)
    battler.pbHeldItemTriggered(item)
    battler.pbConsumeItem
  }
)

Battle::ItemEffects::OnSwitchIn.add(:AMPLIFYAMULET,
  proc { |item, battler, battle|
    next if !battler.pbCanRaiseStatStage?(:SPECIAL_ATTACK)
    battle.pbCommonAnimation("UseItem", battler)
    battle.pbDisplay(_INTL("{1}'s {2} glows forcefully!", battler.pbThis, battler.itemName))
    battler.pbRaiseStatStage(:SPECIAL_ATTACK, 1, nil)
    battler.pbHeldItemTriggered(item)
    battler.pbConsumeItem
  }
)

Battle::ItemEffects::OnSwitchIn.add(:FRAGILEWARD,
  proc { |item, battler, battle|
    next if !battler.pbCanRaiseStatStage?(:SPECIAL_DEFENSE)
    battle.pbCommonAnimation("UseItem", battler)
    battle.pbDisplay(_INTL("{1}'s {2} glows protectively!", battler.pbThis, battler.itemName))
    battler.pbRaiseStatStage(:SPECIAL_DEFENSE, 1, nil)
    battler.pbHeldItemTriggered(item)
    battler.pbConsumeItem
  }
)

Battle::ItemEffects::OnSwitchIn.add(:KNOWLEDGEORB,
  proc { |item, battler, battle|
    next if battler.effects[PBEffects::Imprison]
    battle.pbCommonAnimation("UseItem", battler)
    battle.effects[PBEffects::Imprison] = true
    battle.pbDisplay(_INTL("{1} sealed any moves opponent may share with it!", battler.pbThis))
    battler.pbHeldItemTriggered(item)
  }
)

#===============================================================================
# DamageCalcFromTarget handlers
#===============================================================================
Battle::ItemEffects::DamageCalcFromTarget.add(:ASSAULTARMOR,
  proc { |item, user, target, move, mults, baseDmg, type|
    mults[:defense_multiplier] *= 1.5 if move.physicalMove?
  }
)

Battle::ItemEffects::DamageCalcFromTarget.add(:FRIENDSHIPORB,
  proc { |item, user, target, move, mults, baseDmg, type|
  mults[:defense_multiplier] *= 1.5
  }
)

Battle::ItemEffects::DamageCalcFromTarget.add(:SINCERITYORB,
  proc { |item, user, target, move, mults, baseDmg, type|
  mults[:defense_multiplier] *= 2  if move.physicalMove?
  }
)

Battle::ItemEffects::DamageCalcFromTarget.add(:LIGHTORB,
  proc { |item, user, target, move, mults, baseDmg, type|
    mults[:defense_multiplier] /= 2 if move.specialMove?
  }
)

Battle::ItemEffects::DamageCalcFromTarget.add(:ANGELWARD,
  proc { |ability, user, target, move, mults, baseDmg, type|
  mults[:final_damage_multiplier] *= 2 if move.calcType == :DARK
  mults[:final_damage_multiplier] /= 2 if move.specialMove?
  if move.calcType == :DARK && !target.hasActiveAbility(:SERAPHRING)
    battle.pbCommonAnimation("UseItem", target)
    battle.pbDisplay(_INTL("{1}'s {2} sahttered!", target.pbThis, target.itemName))
    target.pbHeldItemTriggered(item)
    target.pbConsumeItem
  end
  } 
)



Battle::ItemEffects::DamageCalcFromTarget.add(:FLEECECOAT,
  proc { |item, user, target, move, mults, baseDmg, type|
  mults[:final_damage_multiplier] *= 2 if move.calcType == :FIRE
  mults[:final_damage_multiplier] /= 2 if move.pbContactMove?(user)
  if move.calcType == :FIRE && !target.hasActiveAbility(:FLUFFY)
    battle.pbCommonAnimation("UseItem", target)
    battle.pbDisplay(_INTL("{1}'s {2} burned up!", target.pbThis, target.itemName))
    target.pbHeldItemTriggered(item)
  end
  }
)

Battle::ItemEffects::DamageCalcFromTarget.add(:RUBYLOCKET,
  proc { |item, user, target, move, mults, baseDmg, type|
  if type == :FIRE && move.damagingMove?
    if user.effect[PBEffects::Armament] < 0.5
      battle.pbCommonAnimation("UseItem", user)
      battle.pbDisplay(_INTL("{1}'s {2} absorbed some of the Fire damage!", target.pbThis, target.itemName))
      target.effect[PBEffects::Armament] += 0.1
      target.pbHeldItemTriggered(item)
    end
   arms =  target.effect[PBEffects::Armament]
   mults[:final_damage_multiplier] *= (1.0 - arms)
  end
  }
)

Battle::ItemEffects::DamageCalcFromTarget.add(:AMBERCIRCLET,
  proc { |item, user, target, move, mults, baseDmg, type|
  if type == :POISON && move.damagingMove?
    if user.effect[PBEffects::Armament] < 0.5
      battle.pbCommonAnimation("UseItem", user)
      battle.pbDisplay(_INTL("{1}'s {2} absorbed some of the Poison damage!", target.pbThis, target.itemName))
      target.effect[PBEffects::Armament] += 0.1
      target.pbHeldItemTriggered(item)
    end
   arms =  target.effect[PBEffects::Armament]
   mults[:final_damage_multiplier] *= (1.0 - arms)
  end
  }
)

Battle::ItemEffects::DamageCalcFromTarget.add(:TOPAZRING,
  proc { |item, user, target, move, mults, baseDmg, type|
  if type == :ELECTRIC && move.damagingMove?
    if user.effect[PBEffects::Armament] < 0.5
      battle.pbCommonAnimation("UseItem", user)
      battle.pbDisplay(_INTL("{1}'s {2} absorbed some of the Electric damage!", target.pbThis, target.itemName))
      target.effect[PBEffects::Armament] += 0.1
      target.pbHeldItemTriggered(item)
    end
   arms =  target.effect[PBEffects::Armament]
   mults[:final_damage_multiplier] *= (1.0 - arms)
  end
  }
)

Battle::ItemEffects::DamageCalcFromTarget.add(:EMERALDARMLET,
  proc { |item, user, target, move, mults, baseDmg, type|
  if type == :GRASS && move.damagingMove?
    if user.effect[PBEffects::Armament] < 0.5
      battle.pbCommonAnimation("UseItem", user)
      battle.pbDisplay(_INTL("{1}'s {2} absorbed some of the Grass damage!", target.pbThis, target.itemName))
      target.effect[PBEffects::Armament] += 0.1
      target.pbHeldItemTriggered(item)
    end
   arms =  target.effect[PBEffects::Armament]
   mults[:final_damage_multiplier] *= (1.0 - arms)
  end
  }
)

Battle::ItemEffects::DamageCalcFromTarget.add(:SAPPHIREBROOCH,
  proc { |item, user, target, move, mults, baseDmg, type|
  if type == :WATER && move.damagingMove?
    if user.effect[PBEffects::Armament] < 0.5
      battle.pbCommonAnimation("UseItem", user)
      battle.pbDisplay(_INTL("{1}'s {2} absorbed some of the Water damage!", target.pbThis, target.itemName))
      target.effect[PBEffects::Armament] += 0.1
      target.pbHeldItemTriggered(item)
    end
   arms =  target.effect[PBEffects::Armament]
   mults[:final_damage_multiplier] *= (1.0 - arms)
  end
  }
)

Battle::ItemEffects::DamageCalcFromTarget.add(:COBALTCHOKER,
  proc { |item, user, target, move, mults, baseDmg, type|
  if type == :ICE && move.damagingMove?
    if user.effect[PBEffects::Armament] < 0.5
      battle.pbCommonAnimation("UseItem", user)
      battle.pbDisplay(_INTL("{1}'s {2} absorbed some of the Ice damage!", target.pbThis, target.itemName))
      target.effect[PBEffects::Armament] += 0.1
      target.pbHeldItemTriggered(item)
    end
   arms =  target.effect[PBEffects::Armament]
   mults[:final_damage_multiplier] *= (1.0 - arms)
  end
  }
)

Battle::ItemEffects::DamageCalcFromTarget.add(:AMETHYSTPLATE,
  proc { |item, user, target, move, mults, baseDmg, type|
  if type == :PSYCHIC && move.damagingMove?
    if user.effect[PBEffects::Armament] < 0.5
      battle.pbCommonAnimation("UseItem", user)
      battle.pbDisplay(_INTL("{1}'s {2} absorbed some of the Psychic damage!", target.pbThis, target.itemName))
      target.effect[PBEffects::Armament] += 0.1
      target.pbHeldItemTriggered(item)
    end
   arms =  target.effect[PBEffects::Armament]
   mults[:final_damage_multiplier] *= (1.0 - arms)
  end
  }
)

Battle::ItemEffects::DamageCalcFromTarget.add(:DIAMONDMAIL,
  proc { |item, user, target, move, mults, baseDmg, type|
  if type == :STEEL && move.damagingMove?
    if target.effect[PBEffects::Armament] < 0.5
      battle.pbCommonAnimation("UseItem", user)
      battle.pbDisplay(_INTL("{1}'s {2} absorbed some of the Steel damage!", target.pbThis, target.itemName))
      target.effect[PBEffects::Armament] += 0.1
      target.pbHeldItemTriggered(item)
    end
   arms =  target.effect[PBEffects::Armament]
   mults[:final_damage_multiplier] *= (1.0 - arms)
  end
  }
)

#===============================================================================
# DamageCalcFromUser handlers
#===============================================================================
Battle::ItemEffects::DamageCalcFromUser.add(:RUBYLOCKET,
  proc { |item, user, target, move, mults, baseDmg, type|
    if type == :FIRE && move.damagingMove?
      if user.effect[PBEffects::Armament] < 0.5
        battle.pbCommonAnimation("UseItem", user)
        battle.pbDisplay(_INTL("{1}'s {2} increased the Fire damage!", user.pbThis, user.itemName))
        user.effect[PBEffects::Armament] += 0.1
        target.pbHeldItemTriggered(item)
      end
     arms =  user.effect[PBEffects::Armament]
     mults[:final_damage_multiplier] *= (1.0 + arms)
    end
  }
)

Battle::ItemEffects::DamageCalcFromUser.add(:AMBERCIRCLET,
  proc { |item, user, target, move, mults, baseDmg, type|
    if type == :POISON && move.damagingMove?
      if user.effect[PBEffects::Armament] < 0.5
        battle.pbCommonAnimation("UseItem", user)
        battle.pbDisplay(_INTL("{1}'s {2} increased the Poison damage!", user.pbThis, user.itemName))
        user.effect[PBEffects::Armament] += 0.1
        target.pbHeldItemTriggered(item)
      end
     arms =  user.effect[PBEffects::Armament]
     mults[:final_damage_multiplier] *= (1.0 + arms)
    end
  }
)

Battle::ItemEffects::DamageCalcFromUser.add(:TOPAZRING,
  proc { |item, user, target, move, mults, baseDmg, type|
    if type == :ELECTRIC && move.damagingMove?
      if user.effect[PBEffects::Armament] < 0.5
        battle.pbCommonAnimation("UseItem", user)
        battle.pbDisplay(_INTL("{1}'s {2} increased the Electric damage!", user.pbThis, user.itemName))
        user.effect[PBEffects::Armament] += 0.1
        target.pbHeldItemTriggered(item)
      end
     arms =  user.effect[PBEffects::Armament]
     mults[:final_damage_multiplier] *= (1.0 + arms)
    end
  }
)

Battle::ItemEffects::DamageCalcFromUser.add(:EMERALDARMLET,
  proc { |item, user, target, move, mults, baseDmg, type|
    if type == :GRASS && move.damagingMove?
      if user.effect[PBEffects::Armament] < 0.5
        battle.pbCommonAnimation("UseItem", user)
        battle.pbDisplay(_INTL("{1}'s {2} increased the Grass damage!", user.pbThis, user.itemName))
        user.effect[PBEffects::Armament] += 0.1
        target.pbHeldItemTriggered(item)
      end
     arms =  user.effect[PBEffects::Armament]
     mults[:final_damage_multiplier] *= (1.0 + arms)
    end
  }
)

Battle::ItemEffects::DamageCalcFromUser.add(:SAPPHIREBROOCH,
  proc { |item, user, target, move, mults, baseDmg, type|
    if type == :WATER && move.damagingMove?
      if user.effect[PBEffects::Armament] < 0.5
        battle.pbCommonAnimation("UseItem", user)
        battle.pbDisplay(_INTL("{1}'s {2} increased the Water damage!", user.pbThis, user.itemName))
        user.effect[PBEffects::Armament] += 0.1
        target.pbHeldItemTriggered(item)
      end
     arms =  user.effect[PBEffects::Armament]
     mults[:final_damage_multiplier] *= (1.0 + arms)
    end
  }
)

Battle::ItemEffects::DamageCalcFromUser.add(:COBALTCHOKER,
  proc { |item, user, target, move, mults, baseDmg, type|
    if type == :ICE && move.damagingMove?
      if user.effect[PBEffects::Armament] < 0.5
        battle.pbCommonAnimation("UseItem", user)
        battle.pbDisplay(_INTL("{1}'s {2} increased the Ice damage!", user.pbThis, user.itemName))
        user.effect[PBEffects::Armament] += 0.1
        target.pbHeldItemTriggered(item)
      end
     arms =  user.effect[PBEffects::Armament]
     mults[:final_damage_multiplier] *= (1.0 + arms)
    end
  }
)

Battle::ItemEffects::DamageCalcFromUser.add(:AMETHYSTPLATE,
  proc { |item, user, target, move, mults, baseDmg, type|
    if type == :PSYCHIC && move.damagingMove?
      if user.effect[PBEffects::Armament] < 0.5
        battle.pbCommonAnimation("UseItem", user)
        battle.pbDisplay(_INTL("{1}'s {2} increased the Psychic damage!", user.pbThis, user.itemName))
        user.effect[PBEffects::Armament] += 0.1
        target.pbHeldItemTriggered(item)
      end
     arms =  user.effect[PBEffects::Armament]
     mults[:final_damage_multiplier] *= (1.0 + arms)
    end
  }
)

Battle::ItemEffects::DamageCalcFromUser.add(:DIAMONDMAIL,
  proc { |item, user, target, move, mults, baseDmg, type|
    if type == :PSYCHIC && move.damagingMove?
      if user.effect[PBEffects::Armament] < 0.5
        battle.pbCommonAnimation("UseItem", user)
        battle.pbDisplay(_INTL("{1}'s {2} increased the Steel damage!", user.pbThis, user.itemName))
        user.effect[PBEffects::Armament] += 0.1
        target.pbHeldItemTriggered(item)
      end
     arms =  user.effect[PBEffects::Armament]
     mults[:final_damage_multiplier] *= (1.0 + arms)
    end
  }
)

Battle::ItemEffects::DamageCalcFromUser.add(:COURAGEORB,
  proc { |item, user, target, move, mults, baseDmg, type|
    if !move.is_a?(Battle::Move::Confusion)
      if @battle.field.effects[PBEffects::ParadoxRoom] > 0
        mults[:final_damage_multiplier] *= 1.5 if move.specialMove? && user.attack < target.attack
        mults[:final_damage_multiplier] *= 1.5 if move.physicalMove? && user.spatk < target.spatk
      else
        mults[:final_damage_multiplier] *= 1.5 if move.physicalMove? && user.attack < target.attack
        mults[:final_damage_multiplier] *= 1.5 if move.specialMove? && user.spatk < target.spatk
      end
    end
  }
)

Battle::ItemEffects::DamageCalcFromTarget.add(:NUTPEABERRY,
  proc { |item, user, target, move, mults, baseDmg, type|
    target.pbMoveTypeStrengtheningBerry(:NORMAL, type, mults)
  }
)

Battle::ItemEffects::DamageCalcFromTarget.add(:CHIPELIBERRY,
  proc { |item, user, target, move, mults, baseDmg, type|
    target.pbMoveTypeStrengtheningBerry(:FIRE, type, mults)
  }
)

Battle::ItemEffects::DamageCalcFromTarget.add(:EGGPANTBERRY,
  proc { |item, user, target, move, mults, baseDmg, type|
    target.pbMoveTypeStrengtheningBerry(:WATER, type, mults)
  }
)

Battle::ItemEffects::DamageCalcFromTarget.add(:STRIBBERRY,
  proc { |item, user, target, move, mults, baseDmg, type|
    target.pbMoveTypeStrengtheningBerry(:BUG, type, mults)
  }
)

Battle::ItemEffects::DamageCalcFromTarget.add(:PUMKINBERRY,
  proc { |item, user, target, move, mults, baseDmg, type|
    target.pbMoveTypeStrengtheningBerry(:ROCK, type, mults)
  }
)

Battle::ItemEffects::DamageCalcFromTarget.add(:NOIONBERRY,
  proc { |item, user, target, move, mults, baseDmg, type|
    target.pbMoveTypeStrengtheningBerry(:GROUND, type, mults)
  }
)

Battle::ItemEffects::DamageCalcFromTarget.add(:KUOBERRY,
  proc { |item, user, target, move, mults, baseDmg, type|
    target.pbMoveTypeStrengtheningBerry(:FLYING, type, mults)
  }
)

Battle::ItemEffects::DamageCalcFromTarget.add(:BELUEBERRY,
  proc { |item, user, target, move, mults, baseDmg, type|
    target.pbMoveTypeStrengtheningBerry(:POISON, type, mults)
  }
)

Battle::ItemEffects::DamageCalcFromTarget.add(:TOPOBERRY,
  proc { |item, user, target, move, mults, baseDmg, type|
    target.pbMoveTypeStrengtheningBerry(:FAIRY, type, mults)
  }
)

Battle::ItemEffects::DamageCalcFromTarget.add(:BRECANBERRY,
  proc { |item, user, target, move, mults, baseDmg, type|
    target.pbMoveTypeStrengtheningBerry(:ICE, type, mults)
  }
)

Battle::ItemEffects::DamageCalcFromTarget.add(:DRASHBERRY,
  proc { |item, user, target, move, mults, baseDmg, type|
    target.pbMoveTypeStrengtheningBerry(:PSYCHIC, type, mults)
  }
)

Battle::ItemEffects::DamageCalcFromUser.add(:GOSPERBERRY,
  proc { |item, user, target, move, mults, baseDmg, type|
    target.pbMoveTypeStrengtheningBerry(:GHOST, type, mults)
  }
)

Battle::ItemEffects::DamageCalcFromUser.add(:LAGRICBERRY,
  proc { |item, user, target, move, mults, baseDmg, type|
    target.pbMoveTypeStrengtheningBerry(:DRAGON, type, mults)
  }
)

#===============================================================================
# OnBeingHit handlers
#===============================================================================
Battle::ItemEffects::OnBeingHit.add(:ACCIDENTPOLICY,
  proc { |item, user, target, move, battle|
    next if target.damageState.disguise || target.damageState.iceFace
    next if !target.damageState.critical
    next if !target.pbCanRaiseStatStage?(:EVASION, target) 
    battle.pbCommonAnimation("UseItem", target)
    if target.pbCanRaiseStatStage?(:EVASION, target)
      target.pbRaiseStatStageByCause(:EVASION, 2, target, target.itemName, showAnim)
    end
    battle.pbDisplay(_INTL("The {1} was used up.", target.itemName))
    target.pbHeldItemTriggered(item)
  }
)

Battle::ItemEffects::OnBeingHit.add(:KAPPACARAPACE,
  proc { |item, user, target, move, battle|
    next if move.calcType != :WATER && move.calcType != :GRASS
    next if !target.pbOwnSide.effect[PBEffects::Swamp] > 0
    battle.pbCommonAnimation("UseItem", target)
    target.pbOwmSide.effects[PBEffects::Swamp] = 4
    msg = _INTL("A swamp enveloped {1}'s field!", target.pbTeam(true))
    animName = (user.opposes?) ? "Swamp" : "SwampOpp"
    target.pbHeldItemTriggered(item)
  }
)

Battle::ItemEffects::OnBeingHit.add(:KNOWLEDGEORB,
  proc { |item, user, target, move, battle|
    next if user.effects[PBEffects::Disable] > 0 || !target.lastRegularMoveUsed
    next if battle.pbRandom(2) > 0
    user.eachMove do |m|
      next if m.id != target.lastRegularMoveUsed
      next if m.pp == 0 && m.total_pp > 0
      break
    end
    user.effects[PBEffects::Disable]     = 5
    user.effects[PBEffects::DisableMove] = user.lastRegularMoveUsed
    @battle.pbDisplay(_INTL("{1}'s {2} was disabled!", user.pbThis,
                            GameData::Move.get(target.lastRegularMoveUsed).name))
    user.pbItemStatusCureCheck
    user.pbHeldItemTriggered(item)
  }
)

Battle::ItemEffects::OnBeingHit.add(:KITSUNETAIL,
  proc { |item, user, target, move, battle|
    next if move.calcType != :FIRE && move.calcType != :GRASS
    next if !target.pbOwnSide.effect[PBEffects::SeaOfFire] > 0
    battle.pbCommonAnimation("UseItem", target)
    target.pbOwnSide.effects[PBEffects::SeaOfFire] = 4
    msg = _INTL("A sea of fire enveloped {1}'s field!", target.pbTeam(true))
    animName = (user.opposes?) ? "SeaOfFire" : "SeaOfFireOpp"
    target.pbHeldItemTriggered(item)
  }
)

Battle::ItemEffects::OnBeingHit.add(:LEVIATHANSCALE,
  proc { |item, user, target, move, battle|
    next if move.calcType != :WATER
    next if !move.damagingMove?
    next if target.effects[PBEffects::Ingrain] 
    next if target..hasActiveAbility?(:SUCTIONCUPS) && !@battle.moldBreaker
    next unless @battle.pbRandom(10) < 1
    if target.hasActiveItem?(:GREENCARD)
      @battle.pbCommonAnimation("UseItem", target)
      @battle.pbDisplay(_INTL("{1}'s {2} prevents them from being switched out!", 
      target.pbThis,target.itemName))
      target.pbConsumeItem
      next
    end
    if @battle.wildBattle? && @battle.canRun
      @battle.decision = 3
    elsif !@battle.wildBattle?
      @battle.pbRecallAndReplace(target.index, newPkmn, true)
      @battle.pbDisplay(_INTL("{1} was dragged out!", target.pbThis))
      @battle.pbClearChoice(target.index)   # Replacement Pokémon does nothing this round
      @battle.pbOnBattlerEnteringBattle(target.index)
      switched_battlers.push(target.index)
    end
  }
)

#===============================================================================
# TerrainStatBoost handlers
#===============================================================================
Battle::ItemEffects::TerrainStatBoost.add(:MYSTICSEED,
  proc { |item, battler, battle|
    next false if battle.field.terrain != :Mystic
    next false if !battler.pbCanRaiseStatStage?(:DEFENSE, battler)
    itemName = GameData::Item.get(item).name
    battle.pbCommonAnimation("UseItem", battler)
    next battler.pbRaiseStatStageByCause(:DEFENSE, 1, battler, itemName)
  }
)

Battle::ItemEffects::TerrainStatBoost.add(:FOCUSSEED,
  proc { |item, battler, battle|
    next false if battle.field.terrain != :Focus
    next false if battler.effects[PBEffects::FocusEnergy] >= 2
    itemName = GameData::Item.get(item).name
    battle.pbCommonAnimation("UseItem", battler)
    battle.pbDisplay(_INTL("{1}'s {2} increased their chance of a critical hit!", 
    battler.pbThis, battler.itemName))
    next battler.effects[PBEffects::FocusEnergy] += 1
  }
)

Battle::ItemEffects::TerrainStatBoost.add(:SPIRITSEED,
  proc { |item, battler, battle|
    next false if battle.field.terrain != :Sprit
    next false if !battler.pbCanRaiseStatStage?(:SPECIAL_DEFENSE, battler)
    itemName = GameData::Item.get(item).name
    battle.pbCommonAnimation("UseItem", battler)
    next battler.pbRaiseStatStageByCause(:SPECIAL_DEFENSE, 1, battler, itemName)
  }
)

Battle::ItemEffects::TerrainStatBoost.add(:EOSSEED,
  proc { |item, battler, battle|
    next false if battle.field.terrain != :Aurora
    next false if !battler.pbCanRaiseStatStage?(:EVASION, battler)
    itemName = GameData::Item.get(item).name
    battle.pbCommonAnimation("UseItem", battler)
    next battler.pbRaiseStatStageByCause(:EVASION, 1, battler, itemName)
  }
)

Battle::ItemEffects::TerrainStatBoost.add(:LUNARSEED,
  proc { |item, battler, battle|
    next false if battle.field.terrain != :Lunar
    next false if !battler.pbCanRaiseStatStage?(:SPECIAL_ATTACK, battler)
    itemName = GameData::Item.get(item).name
    battle.pbCommonAnimation("UseItem", battler)
    next battler.pbRaiseStatStageByCause(:SPECIAL_ATTACK, 1, battler, itemName)
  }
)

Battle::ItemEffects::TerrainStatBoost.add(:JUNGLESEED,
  proc { |item, battler, battle|
    next false if battle.field.terrain != :Lunar
    next false if !battler.pbCanRaiseStatStage?(:ATTACK, battler)
    itemName = GameData::Item.get(item).name
    battle.pbCommonAnimation("UseItem", battler)
    next battler.pbRaiseStatStageByCause(:ATTACK, 1, battler, itemName)
  }
)

Battle::ItemEffects::TerrainStatBoost.add(:DESERTSEED,
  proc { |item, battler, battle|
    next false if battle.field.terrain != :Desert
    next false if !battler.pbCanRaiseStatStage?(:EVASION, battler)
    itemName = GameData::Item.get(item).name
    battle.pbCommonAnimation("UseItem", battler)
    next battler.pbRaiseStatStageByCause(:EVASION, 1, battler, itemName)
  }
)

Battle::ItemEffects::TerrainStatBoost.add(:CHRONOSSEED,
  proc { |item, battler, battle|
    next false if battle.field.terrain != :Time
    itemName = GameData::Item.get(item).name
    battle.pbCommonAnimation("UseItem", battler)
    battle.pbDisplay(_INTL("{1}'s {2} raised their Turn Count by 2!", 
    battler.pbThis, battler.itemName))
    next battler.turnCount += 2
  }
)

#===============================================================================
# AfterMoveUseFromUser handlers
#===============================================================================
Battle::ItemEffects::AfterMoveUseFromUser.add(:COURAGEORB,
  proc { |item, user, targets, move, numHits, battle|
    next if !user.takesIndirectDamage?
    next if !move.pbDamagingMove? || numHits == 0
    hitBattler = false
    targets.each do |b|
      hitBattler = true if !b.damageState.unaffected && !b.damageState.substitute
      break if hitBattler
    end
    next if !hitBattler
    PBDebug.log("[Item triggered] #{user.pbThis}'s #{user.itemName} (recoil)")
    user.pbReduceHP(user.totalhp / 10)
    battle.pbDisplay(_INTL("{1} lost some of its HP!", user.pbThis))
    user.pbItemHPHealCheck
    user.pbFaint if user.fainted?
  }
)

#===============================================================================
# UseOnPokemon handlers
#===============================================================================
ItemHandlers::UseOnPokemon.add(:DREAMCAPSULE, proc { |item, qty, pkmn, scene|
  if scene.pbConfirm(_INTL("Do you want to change {1}'s Ability?", pkmn.name))
    abils = pkmn.getAbilityList

    if !pkmn.hasHiddenAbility? || pkmn.isSpecies?(:ZYGARDE)
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    newabil = ablis[2]
    newabilname = GameData::Ability.get((newabil == 0) ? abil1 : abil2).name
    pkmn.ability_index = newabil
    pkmn.ability = nil
    scene.pbRefresh
    scene.pbDisplay(_INTL("{1}'s Ability changed! Its Ability is now {2}!", pkmn.name, newabilname))
    next true
  end
  next false
})

#===============================================================================
# EndOfRoundEffect handlers
#===============================================================================
Battle::ItemEffects::EndOfRoundEffect.add(:BERSERKERGLOVE,
  proc { |item, battler, battle|
    next if !battler.pbCanLowerStatStage?(:ATTACK)
    battle.pbCommonAnimation("UseItem", battler)
    battler.pbLowerStatStage(:ATTACK, 2, nil)
    battler.pbConsumeItem
  }
)

Battle::ItemEffects::EndOfRoundEffect.add(:JADEGUARD,
  proc { |item, battler, battle|
    next if !battler.pbCanLowerStatStage?(:DEFENSE)
    battle.pbCommonAnimation("UseItem", battler)
    battler.pbLowerStatStage(:DEFENSE, 2, nil)
    battler.pbConsumeItem
  }
)

Battle::ItemEffects::EndOfRoundEffect.add(:AMPLIFYAMULET,
  proc { |item, battler, battle|
    next if !battler.pbCanLowerStatStage?(:SPECIAL_ATTACK)
    battle.pbCommonAnimation("UseItem", battler)
    battler.pbLowerStatStage(:SPECIAL_ATTACK, 2, nil)
    battler.pbConsumeItem
  }
)

Battle::ItemEffects::EndOfRoundEffect.add(:FRAGILEWARD,
  proc { |item, battler, battle|
    next if !battler.pbCanLowerStatStage?(:SPECIAL_DEFENSE)
    battle.pbCommonAnimation("UseItem", battler)
    battler.pbLowerStatStage(:SPECIAL_DEFENSE, 2, nil)
    battler.pbConsumeItem
  }
)

Battle::ItemEffects::EndOfRoundEffect.add(:BERSERKERGLOVE,
  proc { |item, battler, battle|
    next if !battler.pbCanLowerStatStage?(:ATTACK)
    battle.pbCommonAnimation("UseItem", battler)
    battler.pbLowerStatStage(:ATTACK, 2, nil)
    battler.pbConsumeItem
  }
)

Battle::ItemEffects::EndOfRoundEffect.add(:FRIENDSHIPORB,
  proc { |item, user, targets, move, numHits, battle|
    next if !user.takesIndirectDamage?
    PBDebug.log("[Item triggered] #{user.pbThis}'s #{user.itemName} (recoil)")
    user.pbReduceHP(user.totalhp / 10)
    battle.pbDisplay(_INTL("{1} lost some of its HP because of their {2}!", user.pbThis,user.itemName))
    user.pbItemHPHealCheck
    user.pbFaint if user.fainted?
  }
)
Battle::ItemEffects::EndOfRoundEffect.copy(:FRIENDSHIPORB, :PURITYORB, :KNOWLEDGEORB, :SINCERITYORB, 
                                           :LIGHTORB, :MIRACLEORB)