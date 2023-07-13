#===============================================================================
# AccuracyCalcFromTarget handlers
#===============================================================================
Battle::AbilityEffects::AccuracyCalcFromTarget.add(:ELECTROMAGNETISM,
  proc { |ability, mods, user, target, move, type|
    mods[:base_accuracy] = 0 if type == :STEEL
  }
)

Battle::AbilityEffects::AccuracyCalcFromTarget.add(:JUNGLECLOAK,
  proc { |ability, mods, user, target, move, type|
    mods[:evasion_multiplier] *= 1.25 if battle.field.terrain == :Jungle
  }
)

Battle::AbilityEffects::AccuracyCalcFromTarget.add(:SOULREAD,
  proc { |ability, mods, user, target, move, type|
    if user.opposes?(target) && (mods[:base_accuracy] == 100 || mods[:base_accuracy] == 0)
      mods[:base_accuracy] = 85
    end
  }
)

Battle::AbilityEffects::AccuracyCalcFromTarget.add(:UNICORN,
  proc { |ability, mods, user, target, move, type|
    mods[:base_accuracy] = 0 if type == :POISON
  }
)

#===============================================================================
# AfterMoveUsefomTarget handlers
#===============================================================================
Battle::AbilityEffects::AfterMoveUseFromTarget.add(:NEURALNETWORK,
proc { |ability, target, user, move, switched_battlers, battle|
    next if !user.canChangeType?
    next if target.damageState.calcDamage == 0 || target.damageState.substitute
    battle.pbShowAbilitySplash(user)
    battle.pbHideAbilitySplash(user)
  }
)

#===============================================================================
# DamageCalcFromUser handlers
#===============================================================================
Battle::AbilityEffects::DamageCalcFromUser.add(:ARCSPHERE,
  proc { |ability, user, target, move, mults, baseDmg, type|
    arc =  user.effects[PBEffects::ArcSphere]
    case arc
    when 2 # Attack and Special Attack
      mults[:final_damage_multiplier] *= 3 
    when 3 # Speed and Attack
      mults[:final_damage_multiplier] *= 3 if move.physicallMove?
    when 4 # Speed and Sp.Atk
      mults[:final_damage_multiplier] *= 3 if move.specialMove?
    when 6 # All stats
      mults[:final_damage_multiplier] *= 2
    end
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:ASHURA,
  proc { |ability, user, target, move, mults, baseDmg, type|
    mults[:base_damage_multiplier] /= 4 if move.punchingMove?
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:DRAMATURGE,
  proc { |ability, user, target, move, mults, baseDmg, type|
    if user.poisoned? && move.physicalMove? || user.burned? && move.specialMove?
      mults[:base_damage_multiplier] *= 1.3
    end
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:FOSSILIZE,
  proc { |ability, user, target, move, mults, baseDmg, type|
    mults[:base_damage_multiplier] *= 1.2 if move.powerBoost
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:MEDIUM,
  proc { |ability, user, target, move, mults, baseDmg, type|
    mults[:attack_multiplier] *= 1.5 if type == :GHOST
  }
)


Battle::AbilityEffects::DamageCalcFromUser.add(:NATURESALLY,
  proc { |ability, user, target, move, mults, baseDmg, type|
      mults[:attack_multiplier] *= 1.3 if move.pledgeMove?
  }
)


Battle::AbilityEffects::DamageCalcFromUser.add(:SUPERCHARGE,
  proc { |ability, user, target, move, mults, baseDmg, type|
    if user.hp <= user.totalhp / 3 && type == :ELECTRIC
      mults[:attack_multiplier] *= 1.5
    end
  }
)

#===============================================================================
# DamageCalcFromTarget handlers
#===============================================================================
Battle::AbilityEffects::DamageCalcFromTarget.add(:ARCSPHERE,
  proc { |ability, user, target, move, mults, baseDmg, type|
    arc =  target.effects[PBEffects::ArcSphere]
    case arc
    when 1 # Defense and Sp.Def
      mults[:final_damage_multiplier] /= 3 
    when 6 # All stats
      mults[:final_damage_multiplier] /= 2
    end
  }
)

Battle::AbilityEffects::DamageCalcFromTarget.add(:GLASSSKIN,
  proc { |ability, user, target, move, mults, baseDmg, type|
    mults[:base_damage_multiplier] /= 2 if [:WATER, :ICE].include?(type)
  }
)

Battle::AbilityEffects::DamageCalcFromTarget.add(:REPELLANT,
  proc { |ability, user, target, move, mults, baseDmg, type|
    mults[:base_damage_multiplier] /= 2 if [:BUG, :WATER].include?(type)
  }
)

Battle::AbilityEffects::DamageCalcFromTarget.add(:SERAPHRING,
  proc { |ability, user, target, move, mults, baseDmg, type|
    mults[:final_damage_multiplier] *= 2 if move.calcType == :DARK
    mults[:final_damage_multiplier] /= 2 if move.specialMove?
  }
)

Battle::AbilityEffects::DamageCalcFromTarget.add(:SHROUDINGDEW,
  proc { |ability, user, target, move, mults, baseDmg, type|
    mults[:base_damage_multiplier] /= 2 if move.specialMove && target.status == 0
  }
)

#===============================================================================
# SpeedCalc handlers
#===============================================================================
Battle::AbilityEffects::SpeedCalc.add(:DRAMATURGE,
  proc { |ability, battler, mult|
    next mult * 1.3 if battler.status == :FROZEN
  }
)

#===============================================================================
# OnEndOfUsingMove handlers
#===============================================================================
Battle::AbilityEffects::OnEndOfUsingMove.add(:OVERCHARGE,
  proc { |ability, user, targets, move, battle|
    next if user.fainted?
    next if !user.takesIndirectDamage
    next if !move.calcType(:ELECTRIC)
    next if target.damageState.hpLost <= 0
    battle.pbShowAbilitySplash(user)
    if !Battle::Scene::USE_ABILITY_SPLASH
      battle.pbDisplay(_INTL("{1} is hurt by their own {2}!",user.pbThis,user.abilityName))
    end
    amt = (target.damageState.hpLost / 3.0).round
    battle.scene.pbDamageAnimation(user)
    user.pbReduceHP(amt, false)
    battle.pbHideAbilitySplash(user)
  }
)

#===============================================================================
# EndOfRoundEffect handlers
#===============================================================================
Battle::AbilityEffects::EndOfRoundEffect.add(:ARCSPHERE,
  proc { |ability, battler, battle|
    next if battler.effects[PBEffects::ArcSphere] <= 0
    battle.pbShowAbilitySplash(battler)
    battler.effects[PBEffects::ArcSphere] += 1
    arc =  battler.effects[PBEffects::ArcSphere]
    case arc
    when 1
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1} became cloaked in a brilliant red light",))
      else
        battle.pbDisplay(_INTL("The {1}'s {2} cloaked them in a brilliant red light!", 
        battler.pbThis,battler.abilityName))
      end
      battle.pbDisplay(_INTL("The next turn {1}'s Defense and Special Defense are tripled!", 
      battler.pbThis))
    when 2
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1} became cloaked in a brilliant orange light"))
      else
        battle.pbDisplay(_INTL("The {1}'s {2} cloaked them in a brilliant orange light!", 
        battler.pbThis,battler.abilityName))
      end
      battle.pbDisplay(_INTL("The next turn {1}'s Attack and Special Attack are tripled!", 
      battler.pbThis))
    when 3
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1} became cloaked in a brilliant yellow light"))
      else
        battle.pbDisplay(_INTL("The {1}'s {2} cloaked them in a brilliant yellow light!", 
        battler.pbThis,battler.abilityName))
      end
      battle.pbDisplay(_INTL("The next turn {1}'s Speed and Attack are tripled!", 
      battler.pbThis))
    when 4
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1} became cloaked in a brilliant green light"))
      else
        battle.pbDisplay(_INTL("The {1}'s {2} cloaked them in a brilliant green light!", 
        battler.pbThis,battler.abilityName))
      end
      battle.pbDisplay(_INTL("The next turn {1}'s Speed and Soecial Attack are tripled!", 
      battler.pbThis))
    when 5
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1} became cloaked in a brilliant blue light"))
      else
        battle.pbDisplay(_INTL("The {1}'s {2} cloaked them in a brilliant blue light!", 
        battler.pbThis,battler.abilityName))
      end
      battler.pbRecoverHP((battler.totalhp*0.75).round)
      if battler.status != 0 || battler.effects[PBEffects::Confusion] > 0 ||
        battler.effects[PBEffects::Attract] >= 0
        @battle.pbDisplay(_INTL("The blue light cured {1}'s status problems ", battler.pbThis))
      end
      battler.pbCureStatus(false) if battler.status != 0
      battler.pbCureConfusion if battler.effects[PBEffects::Confusion] > 0
      battler.pbCureAttract if battler.effects[PBEffects::Attract] >= 0
    when 6
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1} became cloaked in a brilliant indigo light"))
      else
        battle.pbDisplay(_INTL("The {1}'s {2} cloaked them in a brilliant indigo light!", 
        battler.pbThis,battler.abilityName))
      end
      battle.pbDisplay(_INTL("The next turn all {1}'s stats are doubled!",battler.pbThis))
    when 7
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1} became cloaked in a brilliant violet light"))
      else
        battle.pbDisplay(_INTL("The {1}'s {2} cloaked them in a brilliant violet light!", 
        battler.pbThis,battler.abilityName))
      end
      battler.pbOwnSide.effect[PBEffects::Rainbow] = 8
      battle.pbDisplay(_INTL("A massive rainbow spans over {1}'s field!", user.pbTeam(true)))
    end
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::EndOfRoundEffect.add(:CIRCUMVOLUTION,
  proc { |ability, battler, battle|
    next unless @battle.pbRandom(100) < 20
    next if !user.pbOwnSide.effects[PBEffects::StealthRock] &&
            !user.pbOwnSide.effects[PBEffects::IcicleRain] &&
            user.pbOwnSide.effects[PBEffects::Spikes] == 0 &&
            user.pbOwnSide.effects[PBEffects::ToxicSpikes] == 0 &&
            !user.pbOwnSide.effects[PBEffects::StickyWeb] &&
            !user.pbOwnSide.effects[PBEffects::BurningGround] &&
            user.effects[PBEffects::Trapping] == 0 &&
            user.effects[PBEffects::LeechSeed] < 0
    
    battle.pbShowAbilitySplash(battler)
    if user.effects[PBEffects::Trapping] > 0
      trapMove = GameData::Move.get(user.effects[PBEffects::TrappingMove]).name
      trapUser = @battle.battlers[user.effects[PBEffects::TrappingUser]]
      @battle.pbDisplay(_INTL("{1} got free of {2}'s {3}!", user.pbThis, trapUser.pbThis(true), trapMove))
      user.effects[PBEffects::Trapping]     = 0
      user.effects[PBEffects::TrappingMove] = nil
      user.effects[PBEffects::TrappingUser] = -1
    end
    if user.effects[PBEffects::LeechSeed] >= 0
      user.effects[PBEffects::LeechSeed] = -1
      @battle.pbDisplay(_INTL("{1} shed Leech Seed!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::StealthRock] ||
       user.pbOwnSide.effects[PBEffects::IcicleRain] ||
       user.pbOwnSide.effects[PBEffects::Spikes] > 0 ||
       user.pbOwnSide.effects[PBEffects::ToxicSpikes] > 0 ||
       user.pbOwnSide.effects[PBEffects::StickyWeb] ||
       user.pbOwnSide.effects[PBEffects::BurningGround]
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1} removed all entry hazards on their field!", 
        battler.pbThis, battler.abilityName))
      else
        battle.pbDisplay(_INTL("{1}'s {2} removed all entry hazards on their field!", 
        battler.pbThis, battler.abilityName))
      end
    end
    if user.pbOwnSide.effects[PBEffects::StealthRock]
      user.pbOwnSide.effects[PBEffects::StealthRock] = false
    end
    if user.pbOwnSide.effects[PBEffects::IcicleRain]
      user.pbOwnSide.effects[PBEffects::IcicleRain] = false
    end
    if user.pbOwnSide.effects[PBEffects::Spikes] > 0
      user.pbOwnSide.effects[PBEffects::Spikes] = 0
    end
    if user.pbOwnSide.effects[PBEffects::ToxicSpikes] > 0
      user.pbOwnSide.effects[PBEffects::ToxicSpikes] = 0
    end
    if user.pbOwnSide.effects[PBEffects::StickyWeb]
      user.pbOwnSide.effects[PBEffects::StickyWeb] = false
    end
    if user.pbOwnSide.effects[PBEffects::BurningGround]
      user.pbOwnSide.effects[PBEffects::BurningGround] = false
    end
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::EndOfRoundEffect.add(:PARASTICHOST,
  proc { |ability, battler, battle|
    if battler.turnCount > 0 && battle.choices[battler.index][0] != :Run &&
      battle.pbShowAbilitySplash(battler)
      if !Battle::Scene::USE_ABILITY_SPLASH
        msg = _INTL("{1}'s {2} boosted their stats!", battler.pbThis, battler.abilityName)
      end
      showAnim = true
      for s in [:DEFENSE, :SPECIAL_DEFENSE]
        if battler.pbCanRaiseStatStage?(s, battler, self)
          battler.pbRaiseStatStage(s, 2, battler, showAnim)
        end
      end
      showAnim = false
      if !battler.takesIndirectDamage?
        battle.pbHideAbilitySplash(user)
        next 
      end
      if !Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1}'s {2} fed off their victim!", battler.pbThis, battler.abilityName))
      end
      battle.scene.pbDamageAnimation(battler)
      battler.pbTakeEffectDamage(battler.totalhp / 8, false)
      battle.pbHideAbilitySplash(battler)
    end
  }
)

Battle::AbilityEffects::EndOfRoundEffect.add(:PHANTASMAGORIA,
  proc { |ability, battler, battle|
    battle.allOtherSideBattlers(battler.index).each do |b|
      next if !b.near?(battler) || !b.asleep?
      next if !b.pbCanLowerStatStage?(:SPECIAL_DEFENSE)
      battle.pbShowAbilitySplash(battler)
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1} is suffering from delusions!", b.pbThis))
      else
        battle.pbDisplay(_INTL("{1} is deluded by {2}'s {3}!",
            b.pbThis, battler.pbThis(true), battler.abilityName))
      end
      b.pbLowerStatStage(:SPECIAL_DEFENSE,1,battler)
      battle.pbHideAbilitySplash(battler)
    end
  }
)

Battle::AbilityEffects::EndOfRoundEffect.add(:STORMWHEEL,
  proc { |ability, battler, battle|
    next if battler.effectiveWeather != :Rain && battler.effectiveWeather != :HeavyRain 
    next if battler.effectiveWeather != :Hail
    next unless @battle.pbRandom(100) < 30
    battle.pbShowAbilitySplash(battler)
    if Battle::Scene::USE_ABILITY_SPLASH
      battle.pbDisplay(_INTL("{1} got charged with electricity!", battler.pbThis))
    else
      battle.pbDisplay(_INTL("{1}'s {2} charged them electricity!",
          battler.pbThis, battler.abilityName))
    end
    battler.effects[PBEffects::Charge] = 2
    battle.pbHideAbilitySplash(battler)
  }
)

#===============================================================================
# EndOfRoundGainItem handlers
#===============================================================================
Battle::AbilityEffects::EndOfRoundGainItem.add(:CORECYCLE,
  proc { |ability, battler, battle|
    next if battler.item
    next unless battle.pbRandom(100) < 30 && battle.field.terrain != 0
    battle.pbShowAbilitySplash(battler)
    terrainGem = nil
    case battle.field.terrain
    when :Electric
      terrainGem = :ELECTRICGEM
    when :Grassy
      terrainGem = :GRASSGEM
    when :Psychic
      terrainGem = :PSYCHICGEM
    when :Misty
      terrainGem = :MISTYGEM
    when :Mystic
      terrainGem = :DRAGONGEM
    when :Focus
      terrainGem = :FIGHTINGGEM
    when :Spirit
      terrainGem = :GHOSTGEM
    when :Aurora
      terrainGem = :ICEGEM
    when :Lunar
      terrainGem = :DARKGEM
    when :Jungle
      terrainGem = :BUGGEM
    when :Desert
      terrainGem = :GROUNDGEM
    #when :Shadow
    #  terrainGem = :SHADOWGEM
    #when :Time
    #  terrainGem = :TIMEGEM
    end

    battler.item = terrainGem
    if Battle::Scene::USE_ABILITY_SPLASH
      battle.pbDisplay(_INTL("{1} produced a {2}!", target.pbThis, battler.itemName))
    else
      battle.pbDisplay(_INTL("{1}'s {2} produced a {3}!",
         battler.pbThis, battler.abilityName, battler.itemName))
    end
    battle.pbHideAbilitySplash(battler)
    battler.pbHeldItemTriggerCheck
  }
)

Battle::AbilityEffects::EndOfRoundGainItem.add(:RELICHUNTER,
  proc { |ability, battler, battle|
    next if battler.item
    next if !battler.recycleItem || !GameData::Item.get(battler.recycleItem).is_gem?
    next unless battle.pbRandom(100) < 30 && battle.field.terrain != :Desert
    battle.pbShowAbilitySplash(battler)
    battler.item = battler.recycleItem
    battler.setRecycleItem(nil)
    battler.setInitialItem(battler.item) if !battler.initialItem
    battle.pbDisplay(_INTL("{1} recovered a lost {2}!", battler.pbThis, battler.itemName))
    battle.pbHideAbilitySplash(battler)
    battler.pbHeldItemTriggerCheck
  }
)

#===============================================================================
# MoveImmunity handlers
#===============================================================================
Battle::AbilityEffects::MoveImmunity.add(:ELECTROMAGNETISM,
  proc { |ability, user, target, move, type, battle, show_message|
    next target.pbMoveImmunityStatRaisingAbility(user, move, type,
       :STEEL, :SPECIAL_DEFENSE, 1, show_message)
  }
)


Battle::AbilityEffects::MoveImmunity.add(:UNICORN,
  proc { |ability, user, target, move, type, battle, show_message|
    next target.pbMoveImmunityStatRaisingAbility(user, move, type,
       :POISON, :SPECIAL_ATTACK, 1, show_message)
  }
)

#===============================================================================
# ModifyMoveBaseType handlers
#===============================================================================
Battle::AbilityEffects::ModifyMoveBaseType.add(:FOSSILIZE,
  proc { |ability, user, move, type|
    next if type != :NORMAL || !GameData::Type.exists?(:ROCK)
    move.powerBoost = true
    next :ROCK
  }
)

#===============================================================================
# OnDealingHit handlers
#===============================================================================
Battle::AbilityEffects::OnDealingHit.add(:ECHOLOCATION,
  proc { |ability, user, target, move, battle|
    next if !move.soundMove?
    battle.pbShowAbilitySplash(user)
    if !Battle::Scene::USE_ABILITY_SPLASH
      msg = _INTL("{1}'s {2} boosted their stats!", target.pbThis, target.abilityName)
    end
    showAnim = true
    for s in [:ATTACK, :SPEED]
      if target.pbCanRaiseStatStage?(s, target, self)
        target.pbRaiseStatStage(s, 1, target, showAnim)
      end
    end
    showAnim = false
    battle.pbHideAbilitySplash(user)
  }
)

#===============================================================================
# OnBeingHit handlers
#===============================================================================
Battle::AbilityEffects::OnBeingHit.add(:CRYSTALIZATION,
  proc { |ability, user, target, move, battle|
    next if !move.specialMove?
    next if !target.pbCanLowerStatStage?(:SPEED, target) &&
            !target.pbCanLowerStatStage?(:ATTACK, target) &&
            !target.pbCanLowerStatStage?(:SPECIAL_ATTACK, target) &&
            !target.pbCanRaiseStatStage?(:SPEED, target)
    battle.pbShowAbilitySplash(target)
    target.pbLowerStatStageByAbility(:DEFENSE, 1, target, false)
    target.pbRaiseStatStageByAbility(:DEFENSE,
       (Settings::MECHANICS_GENERATION >= 7) ? 2 : 1, target, false)
    battle.pbHideAbilitySplash(target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:GENESIS,
  proc { |ability, user, target, move, battle|
    next if !target.fainted?
    battle.pbShowAbilitySplash(target)
    if !battle.moldBreaker
      dampBattler = battle.pbCheckGlobalAbility(:DAMP)
      if dampBattler
        battle.pbShowAbilitySplash(dampBattler)
        if Battle::Scene::USE_ABILITY_SPLASH
          battle.pbDisplay(_INTL("{1}'s {2} failed to trigger!", target.pbThis, target.abilityName))
        else
          battle.pbDisplay(_INTL("{1}'s {2} failed to trigger due to  {3}'s {4}!",
             target.pbThis, target.abilityName, dampBattler.pbThis(true), dampBattler.abilityName))
        end
        battle.pbHideAbilitySplash(dampBattler)
        battle.pbHideAbilitySplash(target)
        next
      end
    end
    msg = false
    for s in [:ATTACK, :DEFENSE, :SPEED, :SPECIAL_ATTACK, :SPECIAL_DEFENSE]
      user.stages[s] = 0; msg = true if user.stages[s] > 0 
    end
    if msg
      battle.pbCommonAnimation("StatDown", user)
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1}'s positive stat changes were reset!",user.pbThis))
      else
        battle.pbDisplay(_INTL("{1}'s {2} reset {3}'s positive stat changes!", 
        user.pbThis,user.abilityName,user.pbThis))
      end
    end
    low = 999
    for l in [user.attack, user.defense, user.speed, user.spatk, user.spdef]
      low = l if l < low
    end
    if user.hp > low
      battle.scene.pbDamageAnimation(user)
      if !Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1}'s {2} brought {3} closer to providence!",
        target.pbThis, target.abilityName,user.pbThis))
      else
        battle.pbDisplay(_INTL("{1} is brought closer to providence!",user.pbThis))
      end
      user.pbReduceHP(user.hp - low)
    end
    battle.pbHideAbilitySplash(target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:MALICETOUCH,
  proc { |ability, user, target, move, battle|
    next if !move.contactMove?
    next unless battle.pbRandom(100) < 30
    battle.pbShowAbilitySplash(user)
    if target.hasActiveAbility?(:SHIELDDUST) && !battle.moldBreaker
      battle.pbShowAbilitySplash(target)
      if !Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1} is unaffected!", target.pbThis))
      end
      battle.pbHideAbilitySplash(target)
    elsif !target.pbHasType?(:GHOST) && !target.effects[PBEffects::Curse]
      msg = nil
      if Battle::Scene::USE_ABILITY_SPLASH
        msg = _INTL("{1}'s was curseed!", user.pbThis)
      else
        msg = _INTL("{1}'s {2} cursed {3}!", user.pbThis, user.abilityName, target.pbThis(true))
      end
      target.effects[PBEffects::Curse] = true
    end
    battle.pbHideAbilitySplash(user)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:MEMORYDRAIN,
  proc { |ability, user, target, move, battle|
    last_move = user.pbGetMoveWithID(user.lastRegularMoveUsed)
    next if !last_move || last_move.pp == 0 || last_move.total_pp <= 0  
    battle.pbShowAbilitySplash(target)
    if user.hasActiveAbility?(:SHIELDDUST) && !battle.moldBreaker
      battle.pbShowAbilitySplash(user)
      if !Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1} is unaffected!", user.pbThis))
      end
      battle.pbHideAbilitySplash(user)
    else 
      reduction = 3
      reduction += 1 if target.hasActiveItem?(:GRUDGEDOLL)
      reduction = [reduction,last_move.pp].min
      target.pbSetPP(last_move, last_move.pp - reduction)
      if Battle::Scene::USE_ABILITY_SPLASH
        msg = _INTL("The PP of {1}'s {2} was drained by {3}", user.pbThis)
      else
        msg = _INTL("{1}'s {2} drained the PP of {3}'s {4} by {5}!", 
        target.pbThis, target.abilityName, user.pbThis(true),reduction)
      end
    end
    battle.pbHideAbilitySplash(target)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:MERMAID,
  proc { |ability, user, target, move, battle|
    next if !move.statusMove?
    next if battle.pbRandom(100) >= 30 && !user.hasActiveItem?(:DESTINYKNOT)
    battle.pbShowAbilitySplash(user)
    if target.hasActiveAbility?(:SHIELDDUST) && !battle.moldBreaker
      battle.pbShowAbilitySplash(target)
      if !Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1} is unaffected!", target.pbThis))
      end
      battle.pbHideAbilitySplash(target)
    elsif target.pbCanAttract?(user, false)
      msg = nil
      if user.hasActiveItem?(:DESTINYKNOT)
        @battle.pbCommonAnimation("UseItem", user)
        user.pbConsumeItem
      end 
      if Battle::Scene::USE_ABILITY_SPLASH
        msg = _INTL("{1}'s fell in love with {2}!", user.pbThis, target.pbThis(true))
      else
        msg = _INTL("{1}'s {2} made {3} fall in love!", user.pbThis, user.abilityName, target.pbThis(true))
      end
      target.pbAttract(user) 
    end
    battle.pbHideAbilitySplash(user)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:SEEDEDBODY,
  proc { |ability, user, target, move, battle|
    next if !move.contactMove?
    next unless battle.pbRandom(100) < 30
    battle.pbShowAbilitySplash(user)
    if target.hasActiveAbility?(:SHIELDDUST) && !battle.moldBreaker
      battle.pbShowAbilitySplash(target)
      if !Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1} is unaffected!", target.pbThis))
      end
      battle.pbHideAbilitySplash(target)
    elsif !user.pbHasType?(:GRASS) && user.effects[PBEffects::LeechSeed] == 0 &&
          !user.hasActiveAbility?(:SEEDEDBODY)
      msg = nil
      if Battle::Scene::USE_ABILITY_SPLASH
        msg = _INTL("{1}'s was seeded!", user.pbThis)
      else
        msg = _INTL("{1}'s {2} seeded {3}!", user.pbThis, user.abilityName, target.pbThis(true))
      end
      user.effects[PBEffects::LeechSeed] = target.index
    end
    battle.pbHideAbilitySplash(user)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:WHITEOUT,
  proc { |ability, user, target, move, battle|
    next if user.pbHasType?(:ICE)
    next if user.effects[PBEffects::Disable] > 0 
    next if !user.lastRegularMoveUsed
    next unless battle.pbRandom(100) < 30
    canDisable = false
    user.eachMove do |m|
      next if m.id != user.lastRegularMoveUsed
      next if m.pp == 0 && m.total_pp > 0
      canDisable = true
      break
    end
    next if !canDisable
    battle.pbShowAbilitySplash(user)
    if target.hasActiveAbility?(:SHIELDDUST) && !battle.moldBreaker
      battle.pbShowAbilitySplash(target)
      if !Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1} is unaffected!", target.pbThis))
      end
      battle.pbHideAbilitySplash(target)
    else
      if Battle::Scene::USE_ABILITY_SPLASH
        msg = _INTL("{1}'s {2} was disabled!", user.pbThis,
        GameData::Move.get(user.lastRegularMoveUsed).name)
      else
        msg = _INTL("{1}'s {2} disabled {3}'s {4}!", 
        target.pbThis, target.abilityName, user.pbThis(true),
        GameData::Move.get(user.lastRegularMoveUsed).name)
      end
      user.effects[PBEffects::Disable]     = 5
      user.effects[PBEffects::DisableMove] = user.lastRegularMoveUsed
      battle.pbHideAbilitySplash(user)
    end
  }
)

Battle::AbilityEffects::OnBeingHit.add(:CORONAPORTAL,
  proc { |ability, user, target, move, battle|
    portal = target.effects[PBEffects::PortalDrive]
    trigger = false
    if move.physicallMove? && portal < 3
      target.effects[PBEffects::PortalDrive] += 1
      if target.effects[PBEffects::PortalDrive] < 3
        battle.pbDisplay(_INTL("{1}'s portal is charging!", target.pbThis))
      else
        battle.pbDisplay(_INTL("{1}'s portal is fully charged!", target.pbThis))
      end
    end
    battle.pbShowAbilitySplash(target)
    case target.effects[PBEffects::PortalDrive]
    when 1
      if target.pbCanRaiseStatStage?(:SPEED, target, self)
        target.pbRaiseStatStage(:SPEED, 1, target, showAnim)
      end
    when 2
      if user.hasActiveAbility?(:SHIELDDUST) && !battle.moldBreaker
        battle.pbShowAbilitySplash(target)
        if !Battle::Scene::USE_ABILITY_SPLASH
          @battle.pbDisplay(_INTL("{1} is unaffected!", target.pbThis))
        end
        battle.pbHideAbilitySplash(target)
      else
        target.pbBurn(user) if target.pbCanBurn?(user, false, self)
      end
    when 3
      if user.hasActiveAbility?(:SHIELDDUST) && !battle.moldBreaker
        battle.pbShowAbilitySplash(target)
        if !Battle::Scene::USE_ABILITY_SPLASH
          @battle.pbDisplay(_INTL("{1} is unaffected!", target.pbThis))
        end
        battle.pbHideAbilitySplash(target)
      elsif target.hasActiveAbility?(:SUCTIONCUPS) && !@battle.moldBreaker
        @battle.pbShowAbilitySplash(target)
        if Battle::Scene::USE_ABILITY_SPLASH
          @battle.pbDisplay(_INTL("{1} anchors themself!", user.pbThis))
        else
          @battle.pbDisplay(_INTL("{1} anchors themself with {2}!", 
          user.pbThis, user.abilityName))
        end
        @battle.pbHideAbilitySplash(target)
      elsif user.effects[PBEffects::Ingrain]
        @battle.pbDisplay(_INTL("{1} anchored itself with their roots!", target.pbThis)) if show_message
      else
        next if target.fainted? 
        newPkmn = @battle.pbGetReplacementPokemonIndex(user.index, true)   # Rando
        next if newPkmn < 0
        if user.hasActiveItem?(:GREENCARD)
          @battle.pbCommonAnimation("UseItem", user)
          @battle.pbDisplay(_INTL("{1}'s {2} prevents them from being switched out!", 
          user.pbThis, user.itemName))
          user.pbConsumeItem
        else
          user.pbOwnSide.effects[PBEffects::CoronaPortal] = true
          @battle.pbRecallAndReplace(user.index, newPkmn, true)
          @battle.pbDisplay(_INTL("{1} was dragged out!", user.pbThis))
          @battle.pbClearChoice(user.index)  
          @battle.pbOnBattlerEnteringBattle(user.index)
          switched_battlers.push(user.index)
        end
      end
      target.effects[PBEffects::PortalDrive] = 0
      @battle.pbDisplay(_INTL("{1}'s portal spent all its energy!", target.pbThis))
    end
    battle.pbHideAbilitySplash(user)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:RIPPLEPORTAL,
  proc { |ability, user, target, move, battle|
    portal = target.effects[PBEffects::PortalDrive]
    trigger = false
    if move.specialMove? && portal < 3
      target.effects[PBEffects::PortalDrive] += 1
      if target.effects[PBEffects::PortalDrive] < 3
        battle.pbDisplay(_INTL("{1}'s portal is charging!", target.pbThis))
      else
        battle.pbDisplay(_INTL("{1}'s portal is fully charged!", target.pbThis))
      end
    end
    battle.pbShowAbilitySplash(target)
    case target.effects[PBEffects::PortalDrive]
    when 1
      target.pbRecoverHP(user.totalhp / 4) if target.hp < target.totalhp
    when 2
      showAnim = true
      for s in [:DEFENSE, :SPECIAL_DEFENSE]
        if target.pbCanRaiseStatStage?(s, target, self)
          target.pbRaiseStatStage(s, 1, target, showAnim)
        end
      end
      showAnim = false
    when 3
      if user.hasActiveAbility?(:SHIELDDUST) && !battle.moldBreaker
        battle.pbShowAbilitySplash(target)
        if !Battle::Scene::USE_ABILITY_SPLASH
          @battle.pbDisplay(_INTL("{1} is unaffected!", target.pbThis))
        end
        battle.pbHideAbilitySplash(target)
      elsif target.hasActiveAbility?(:SUCTIONCUPS) && !@battle.moldBreaker
        @battle.pbShowAbilitySplash(target)
        if Battle::Scene::USE_ABILITY_SPLASH
          @battle.pbDisplay(_INTL("{1} anchors themself!", user.pbThis))
        else
          @battle.pbDisplay(_INTL("{1} anchors themself with {2}!", 
          user.pbThis, user.abilityName))
        end
        @battle.pbHideAbilitySplash(target)
      elsif user.effects[PBEffects::Ingrain]
        @battle.pbDisplay(_INTL("{1} anchored itself with their roots!", target.pbThis)) if show_message
      else
        next if target.fainted? 
        newPkmn = @battle.pbGetReplacementPokemonIndex(user.index, true)   # Rando
        next if newPkmn < 0
        if user.hasActiveItem?(:GREENCARD)
          @battle.pbCommonAnimation("UseItem", user)
          @battle.pbDisplay(_INTL("{1}'s {2} prevents them from being switched out!", 
          user.pbThis, user.itemName))
          user.pbConsumeItem
        else
          user.pbOwnSide.effects[PBEffects::RipplePortal] = true
          @battle.pbRecallAndReplace(user.index, newPkmn, true)
          @battle.pbDisplay(_INTL("{1} was dragged out!", user.pbThis))
          @battle.pbClearChoice(user.index)  
          @battle.pbOnBattlerEnteringBattle(user.index)
          switched_battlers.push(user.index)
        end
      end
      target.effects[PBEffects::PortalDrive] = 0
      @battle.pbDisplay(_INTL("{1}'s portal spent all its energy!", target.pbThis))
    end
    battle.pbHideAbilitySplash(user)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:TESTAMENT,
  proc { |ability, user, target, move, battle|
    next if !target.fainted?
    battle.pbShowAbilitySplash(target)
    if !battle.moldBreaker
      dampBattler = battle.pbCheckGlobalAbility(:DAMP)
      if dampBattler
        battle.pbShowAbilitySplash(dampBattler)
        if Battle::Scene::USE_ABILITY_SPLASH
          battle.pbDisplay(_INTL("{1}'s {2} failed to trigger!", target.pbThis, target.abilityName))
        else
          battle.pbDisplay(_INTL("{1}'s {2} failed to trigger due to  {3}'s {4}!",
             target.pbThis, target.abilityName, dampBattler.pbThis(true), dampBattler.abilityName))
        end
        battle.pbHideAbilitySplash(dampBattler)
        battle.pbHideAbilitySplash(target)
        next
      end
    end
    if !Battle::Scene::USE_ABILITY_SPLASH
      battle.pbDisplay(_INTL("{1}'s {2} weakened all opponents!",target.pbThis, target.abilityName))
    end
    showAnim = true
    for s in [:ATTACK, :SPECIAL_ATTACK]
      if user.pbCanLowerStatStage?(s, target, self)
        user.pbLowerStatStage(s, 1, target, showAnim)
      end
      if user.allAllies.length > 0
        user.eachAlly do |b|
          if b.pbCanLowerStatStage?(s, target, self)
            b.pbLowerStatStage(s, 1, target, showAnim)
          end
        end
      end
    end
    showAnim = false
    battle.pbHideAbilitySplash(target)
  }
)

#===============================================================================
# OnSwitchIn handlers
#===============================================================================
Battle::AbilityEffects::OnSwitchIn.add(:MYSTICSURGE,
  proc { |ability, battler, battle, switch_in|
    next if battle.field.terrain == :Mystic
    battle.pbShowAbilitySplash(battler)
    battle.pbStartTerrain(battler, :Mystic)
    # NOTE: The ability splash is hidden again in def pbStartTerrain.
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:FOCUSSURGE,
  proc { |ability, battler, battle, switch_in|
    next if battle.field.terrain == :Focus
    battle.pbShowAbilitySplash(battler)
    battle.pbStartTerrain(battler, :Focus)
    # NOTE: The ability splash is hidden again in def pbStartTerrain.
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:SPIRITSURGE,
  proc { |ability, battler, battle, switch_in|
    next if battle.field.terrain == :Spirit
    battle.pbShowAbilitySplash(battler)
    battle.pbStartTerrain(battler, :Spirit)
    # NOTE: The ability splash is hidden again in def pbStartTerrain.
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:AURORASURGE,
  proc { |ability, battler, battle, switch_in|
    next if battle.field.terrain == :Aurora
    battle.pbShowAbilitySplash(battler)
    battle.pbStartTerrain(battler, :Aurora)
    # NOTE: The ability splash is hidden again in def pbStartTerrain.
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:LUNARSURGE,
  proc { |ability, battler, battle, switch_in|
    next if battle.field.terrain == :Lunar
    battle.pbShowAbilitySplash(battler)
    battle.pbStartTerrain(battler, :Lunar)
    # NOTE: The ability splash is hidden again in def pbStartTerrain.
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:JUNGLESURGE,
  proc { |ability, battler, battle, switch_in|
    next if battle.field.terrain == :Jungle
    battle.pbShowAbilitySplash(battler)
    battle.pbStartTerrain(battler, :Jungle)
    # NOTE: The ability splash is hidden again in def pbStartTerrain.
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:DESERTSURGE,
  proc { |ability, battler, battle, switch_in|
    next if battle.field.terrain == :Desert
    battle.pbShowAbilitySplash(battler)
    battle.pbStartTerrain(battler, :Desert)
    # NOTE: The ability splash is hidden again in def pbStartTerrain.
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:ARCSPHERE,
  proc { |ability, battler, battle, switch_in|
    next if battler.effects[PBEffects::ArcSphere] > 0 
    battle.pbShowAbilitySplash(battler)
    if Battle::Scene::USE_ABILITY_SPLASH
      battle.pbDisplay(_INTL("{1} became cloaked in a brilliant red light",))
    else
      battle.pbDisplay(_INTL("The {1}'s {2} cloaked them in a brilliant red light!", 
      battler.pbThis,battler.abilityName))
    end
    battle.pbDisplay(_INTL("{1}'s Defense and Special Defense are tripled!", battler.pbThis))
    battler.effects[PBEffects::ArcSphere] = 1 
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:CHIVALRY,
  proc { |ability, battler, battle, switch_in|
    low = false, high = false, atk = battler.attack
    battle.allBattlers.each do |b|
      if b.attack < atk
          high = true
      elsif b.attack > atk
          low = true
      end
    end
    battle.pbShowAbilitySplash(battler)
    if low && !high
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1}'s assumed an attacking stance!", battler.pbThis))
      else
        battle.pbDisplay(_INTL("{1}'s {2} made them take a attacking stance!", 
        battler.pbThis, battler.abilityName))
      end
      battler.pbRaiseStatStageByAbility(:ATTACK, 1, battler)
    elsif !low && high
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1}'s assumed an defensive stance!", battler.pbThis))
      else
        battle.pbDisplay(_INTL("{1}'s {2} made them take a defensive stance!", 
        battler.pbThis, battler.abilityName))
      end
      battler.pbRaiseStatStageByAbility(:SPECIAL_DEFENSE, 1, battler)
    end
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:EVENTHORIZON,
  proc { |ability, battler, battle, switch_in|
    next if @battle.field.effects[PBEffects::Gravity] > 0
    battle.pbShowAbilitySplash(battler)
    @battle.field.effects[PBEffects::Gravity] = 5
    @battle.field.effects[PBEffects::Gravity] += 3 if battle.field.terrain == :Lunar
    if Battle::Scene::USE_ABILITY_SPLASH
      battle.pbDisplay(_INTL("{1} intensified Gravity!", battler.pbThis))
    else
      battle.pbDisplay(_INTL("{1}'s {2} made gravity intensify!", 
      battler.pbThis, battler.abilityName))
    end
    battle.pbHideAbilitySplash(battler)
  }
)


Battle::AbilityEffects::OnSwitchIn.add(:KARMAGEAR,
  proc { |ability, battler, battle, switch_in|
    next if battler.pbOpposingSide.effects[PBEffects::KarmaGearUsed]
    karma = 0
    @battle.eachInTeamFromBattlerIndex(battler.index) do |pkmn|
      next if !pkmn.fainted?
      karma += 1
    end
    next if karma == 0
    battle.pbShowAbilitySplash(battler)
    if Battle::Scene::USE_ABILITY_SPLASH
      @battle.pbDisplay(_INTL("{1} gained the power to change fate {2}", 
      battler.pbThis,karma))
    else
      msg = _INTL("The {1}'s {2} gave them power to change fate {3} times!", 
      battler.pbThis,battler.abilityName,karma)
    end
    battler.pbOpposingSide.effects[PBEffects::KarmaGear] = karma
    battler.pbOpposingSide.effects[PBEffects::KarmaGearUsed] = true
    battle.pbHideAbilitySplash(battler)
  }
)


Battle::AbilityEffects::OnSwitchIn.add(:LAVALANDS,
  proc { |ability, battler, battle, switch_in|
    next if battler.pbOpposingSide.effects[PBEffects::BurningGround] 
    battle.pbShowAbilitySplash(battler)
     if battler.pbOpposingSide.effects[PBEffects::StickyWeb]
      if Battle::Scene::USE_ABILITY_SPLASH
        msg = _INTL("The Sticky Web around {1} burned up!", 
        battler.pbThis,battler.abilityName,battler.pbOpposingTeam(true))
      else
        msg = _INTL("The {1}'s {2} burned up the Sticky Web around {3}!", 
        battler.pbThis,battler.abilityName,battler.pbOpposingTeam(true))
      end
      battler.pbOpposingSide.effects[PBEffects::StickyWeb] = false
    end 
    if Battle::Scene::USE_ABILITY_SPLASH
      msg = _INTL("The ground around {1} became superheated!", battler.pbOpposingTeam(true))
    else
      msg = _INTL("The {1}'s {2} superheated the ground around {3}!", 
      battler.pbThis,battler.abilityName,battler.pbOpposingTeam(true))
    end
    battler.pbOpposingSide.effects[PBEffects::BurningGround] = true
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:QUAGMIRE,
  proc { |ability, battler, battle, switch_in|
    next if battler.pbOpposingSide.effects[PBEffects::Swamp] > 0
    battle.pbShowAbilitySplash(battler)
    battler.pbOpposingSide.effects[PBEffects::Swamp] = 4
    msg = _INTL("A swamp enveloped {1}'s field!", user.pbOpposingTeam(true)) if !Battle::Scene::USE_ABILITY_SPLASH
    animName = (battler.opposes?) ? "Swamp" : "SwampOpp"
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:REQUIEM,
  proc { |ability, battler, battle, switch_in|
    battle.pbShowAbilitySplash(battler)
    allBattlers.each do |b|
      next if b.hasActiveAbility?(:SOUNDPROOF)
      next if b.hp > b.totalhp
      next if b.effects[PBEffects::PerishSong] > 0   # Heard it before
      target.effects[PBEffects::PerishSong]     = 8
      target.effects[PBEffects::PerishSongUser] = battler.index
      @battle.pbDisplay(_INTL("{1} will faint in seven turns!".b.pnThis))
    end
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:SHIRANUI,
  proc { |ability, battler, battle, switch_in|
    next if battler.pbOpposingSide.effects[PBEffects::SeaOfFire] > 0
    battle.pbShowAbilitySplash(battler)
    battler.pbOpposingSide.effects[PBEffects::SeaOfFire] = 4
    msg = _INTL("A sea of fire enveloped {1}!", battler.pbOpposingTeam(true)) if !Battle::Scene::USE_ABILITY_SPLASH
    animName = (battler.opposes?) ? "SeaOfFire" : "SeaOfFireOpp"
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:SILKSPINNER,
  proc { |ability, battler, battle, switch_in|
    next if battler.pbOpposingSide.effects[PBEffects::StickyWeb] 
    battle.pbShowAbilitySplash(battler)
     if battler.pbOpposingSide.effects[PBEffects::BurningGround]
      if Battle::Scene::USE_ABILITY_SPLASH
        msg = _INTL("The ground around {1} cooled down!", battler.pbOpposingTeam(true))
      else
        msg = _INTL("The {1}'s {2} cooled the ground around {3}!", 
        battler.pbThis,battler.abilityName,battler.pbOpposingTeam(true))

      end
      battler.pbOpposingSide.effects[PBEffects::BurningGrounds] = false
    end 
    if Battle::Scene::USE_ABILITY_SPLASH
      msg = _INTL("A Sticky Web was spun around {1}!", battler.pbOpposingTeam(true))
    else
      msg = _INTL("The {1}'s {2} spun a Stick Web around {3}!", 
      battler.pbThis,battler.abilityName,battler.pbOpposingTeam(true))

    end
    battler.pbOpposingSide.effects[PBEffects::StickyWeb] = true
    battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:SINISTEREYES,
  proc { |ability, battler, battle, switch_in|
    battle.pbShowAbilitySplash(battler)
    battle.allOtherSideBattlers(battler.index).each do |b|
      next if !b.near?(battler)
      check_item = true
      if b.hasActiveAbility?(:CONTRARY)
        check_item = false if b.statStageAtMax?(:SPECIAL_ATTACK)
      elsif b.statStageAtMin?(:SPECIAL_ATTACK)
        check_item = false
      end
      check_ability = b.pbLowerSpAtkStatStageIntimidate(battler)
      b.pbAbilitiesOnIntimidated if check_ability
      b.pbItemOnIntimidatedCheck if check_item
    end
    battle.pbHideAbilitySplash(battler)
  }
)

#===============================================================================
# SpeedCalc handlers
#===============================================================================
Battle::AbilityEffects::SpeedCalc.add(:ARCSPHERE,
  proc { |ability, battler, mult|
    arc =  battler.effects[PBEffects::ArcSphere]
    next mult * 3 if arc == 3 || arc == 4
    next mult * 2 if arc == 6
  }
)

#===============================================================================
# StatusImmunity handlers
#===============================================================================
Battle::AbilityEffects::StatusImmunity.add(:BRIGHTVEIL,
  proc { |ability, battler, status|
    next true if battler.pbHasType?(:ICE)
  }
)

#===============================================================================
# StatusImmunityFromAlly handlers
#===============================================================================
Battle::AbilityEffects::StatusImmunityFromAlly.add(:BRIGHTVEIL,
  proc { |ability, battler, status|
    next true if battler.pbHasType?(:ICE)
  }
)

#===============================================================================
# StatLossImmunity handlers
#===============================================================================
Battle::AbilityEffects::StatLossImmunity.add(:BRIGHTVEIL,
  proc { |ability, battler, stat, battle, showMessages|
    next false if !battler.pbHasType?(:ICE)
    if showMessages
      battle.pbShowAbilitySplash(battler)
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1}'s stats cannot be lowered!",battler.pbThis))
      else
        battle.pbDisplay(_INTL("{1}'s {2} prevents stat loss!", battler.pbThis, battler.abilityName))
      end
      battle.pbHideAbilitySplash(battler)
    end
    next true
  }
)

#===============================================================================
# StatLossImmunityFromAlly handlers
#===============================================================================
Battle::AbilityEffects::StatLossImmunityFromAlly.add(:BRIGHTVEIL,
  proc { |ability, bearer, battler, stat, battle, showMessages|
    next false if !battler.pbHasType?(:ICE)
    if showMessages
      battle.pbShowAbilitySplash(bearer)
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1}'s stats cannot be lowered!",bearer.pbThis))
      else
        battle.pbDisplay(_INTL("{1}'s {2} prevents {3}'s stat loss!",
          bearer.pbThis, bearer.abilityName, battler.pbThis(true)))
      end
      battle.pbHideAbilitySplash(bearer)
    end
    next true
  }
)



