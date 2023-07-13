#===============================================================================
# Lowers Attack,Defense,Speed and Special Attack, Maximizes Special defense
# (A doof Aloof)
# Exclusive to: Bibarel
#===============================================================================
class Battle::Move::MaxUserSpDefLowerOthers < Battle::Move
  def canSnatch?; return true; end

  def pbMoveFailed?(user, targets)
    if !user.pbCanRaiseStatStage?(:SPECIAL_DEFENSE, user, self, true) &&
        !user.pbCanLowerStatStage?(:ATTACK, user, self, true) &&
        !user.pbCanLowerStatStage?(:DEFENSE, user, self, true) &&
        !user.pbCanLowerStatStage?(:SPEED, user, self, true) &&
        !user.pbCanLowerStatStage?(:SPECIAL_ATTACK, user, self, true)
      return true 
    end
    return false
  end
  
  def pbEffectGeneral(user)
    if user.hasActiveAbility?(:CONTRARY)
      user.stages[:SPECIAL_DEFENSE] = -6
      user.statsLoweredThisRound = true
      user.statsDropped = true
      @battle.pbCommonAnimation("StatDown", user)
      @battle.pbDisplay(_INTL("{1} Raised their other stats and minimized their Special Defense!", user.pbThis))
    else
      user.stages[:SPECIAL_DEFENSE] = 6
      user.statsRaisedThisRound = true
      @battle.pbCommonAnimation("StatUp", user)
      @battle.pbDisplay(_INTL("{1} lowered their other stats and maximize their Special Defense!", user.pbThis))
    end
    user.pbItemHPHealCheck
  end
end

#===============================================================================
# High Critical hit rate. May lower target's Defense and Sp.Def- (Aeroblast)
# Edited, Exclusive to Lugia
#===============================================================================
class Battle::Move::HighCritLowerDefSpDef1 < Battle::Move::TargetMultiStatDownMove
  def initialize(battle, move)
    super
    @statDown = [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
  end
end

#===============================================================================
# Two turn attack. Skips first turn, and increases the user's Special Attack,
# Special Defense and Speed by 2 stages each in the second turn. (Auramancy)
# Exclusive to: Lucario
#===============================================================================
class Battle::Move::TwoTurnAttackRaiseUserAtkDefSpd2 < Battle::Move::TwoTurnMove
  def pbMoveFailed?(user, targets)
    return false if user.effects[PBEffects::TwoTurnAttack]   # Charging turn
    if !user.pbCanRaiseStatStage?(:ATTACK, user, self) &&
        !user.pbCanRaiseStatStage?(:DEFENSE, user, self) &&
        !user.pbCanRaiseStatStage?(:SPEED, user, self)
      @battle.pbDisplay(_INTL("{1}'s stats won't go any higher!", user.pbThis))
      return true
    end
    return false
  end

  def pbChargingTurnMessage(user, targets)
    @battle.pbDisplay(_INTL("{1} is absorbing power!", user.pbThis))
  end

  def pbEffectGeneral(user)
    return if !@damagingTurn
    showAnim = true
    [:ATTACK, :DEFENSE, :SPEED].each do |s|
      next if !user.pbCanRaiseStatStage?(s, user, self)
      if user.pbRaiseStatStage(s, 2, user, showAnim)
        showAnim = false
      end
    end
  end
end

#===============================================================================
# Sets Aurora Veil on the field during Hail or Aurora Terrain (Aurora Melody)
# May put target to sleep
# Exclusive to: Lapras
#===============================================================================
class Battle::Move::AuroraVeilSleep < Battle::Move::SleepTarget
  def pbEffectGeneral(user)
    if (user.effectiveWeather == :Hail || @battle.field.terrain == :Aurora) &&
      user.pbOwnSide.effects[PBEffects::AuroraVeil] == 0
      user.pbOwnSide.effects[PBEffects::AuroraVeil] = 3
      user.pbOwnSide.effects[PBEffects::AuroraVeil] = 6 if user.hasActiveItem?(:LIGHTCLAY)
      @battle.pbDisplay(_INTL("{1} made {2} stronger against physical and special moves!",
                          @name, user.pbTeam(true)))
    end
  end
end

#===============================================================================
# May burn or badly poison taget (Balefire Stream)
# Exclusive to: Houndoom
#===============================================================================
class Battle::Move::BurnToxicTarget < Battle::Move
  def initialize(battle, move)
    @toxic = true
  end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    chance = pbAdditionalEffectChance(user, target, 20)
    return if chance == 0
    if target.pbCanBurn?(user, false, self) && @battle.pbRandom(100) < chance
      target.pbBurn(user)
    end
    if target.pbCanPoison?(user, false, self) && @battle.pbRandom(100) < chance
      target.pbPoison(user, nil, @toxic)
    end 
  end
end

#===============================================================================
# For 5 rounds, Halves the damage of Bullet and Bomb moves against the user's team. 
# (Bastion Shell)
# Exclusive to: Blastoise
#===============================================================================
class Battle::Move::StartWeakenBulletandBombMovesAgainstUserSide < Battle::Move
  def canSnatch?; return true; end

  def pbMoveFailed?(user, targets)
    if user.pbOwnSide.effects[PBEffects::BastionShell] > 0
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.pbOwnSide.effects[PBEffects::BastionShell] = 5
    @battle.pbDisplay(_INTL("{1}'s {2}'s will reduce the damage from bullet, bomb and beam moves!", 
    @name, user.pbTeam(true)))
  end
end

#===============================================================================
# May Confuse or Attract target (Black Pearl)
# May Raise user's Special Attack if used on a confused or attracted target
# Exclusive to: Grumpig
#===============================================================================
class Battle::Move::ConfuseAttractTargetRaiseSpAtk1 < Battle::Move
  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    chance = pbAdditionalEffectChance(user, target, 20)
    return if chance == 0
    if target.effects[PBEffects::Attract] > 0 || target.effects[PBEffects::Confusion] > 0
      chance = pbAdditionalEffectChance(user, target, 50)
      if user.pbCanRaiseStatStage?(:SPECIAL_ATTACK, user, self, true) && @battle.pbRandom(100) < chance
        user.pbRaiseStatStage(:SPECIAL_ATTACK,1,user)
      end
    else 
      case @battle.pbRandom(2)
      when 0
        if target.pbCanConfuse?(user, false, self) && @battle.pbRandom(100) < chance
          target.pbConfuse
        end
      when 1
        if target.pbCanAttract?(user, false) && @battle.pbRandom(100) < chance
          target.pbAttract(user) 
        end
      end
    end
  end
end

#===============================================================================
# User gains 3/4 the HP it inflicts as damage. (Bubble Drain)
# User gains all of the inflicted damage if holding a water element.
# Exclusive to: Vaporeon
#===============================================================================
class Battle::Move::HealUserby75or100Element < Battle::Move
  def healingMove?; return Settings::MECHANICS_GENERATION >= 6; end
  
  def pbEffectAgainstTarget(user, target)
    return if target.damageState.hpLost <= 0
    if user.hasActiveItem?(:WATERELEMENT) 
      @battle.pbCommonAnimation("UseItem", user)
      @battle.pbDisplay(_INTL("{1}'s {2} increased the draining power!", user.pbThis,user.itemName))
      hpGain = target.damageState.hpLost
      user.pbConsumeItem 
    else
      hpGain = (target.damageState.hpLost * 0.75).round
    end
    user.pbRecoverHPFromDrain(hpGain, target)
  end
end

#===============================================================================
# (Body Treatement)
# Exclusive to: Delcatty
#===============================================================================
class Battle::Move::SetTargetAbilityToWonderSkinAllStatUp  < Battle::Move
  def pbAdditionalEffect(user, target)
  return if target.damageState.substitute
  showAnim = true
    for s in [:ATTACK, :DEFENSE, :SPEED, :SPECIAL_ATTACK, :SPECIAL_DEFENSE]
      if user.pbCanRaiseStatStage?(s, user, self)
        user.pbRaiseStatStage(s, 1, user, showAnim)
      end
    end
    showAnim = false
  end

  def pbEffectAfterAllHits(user, target)
    if !user.hasActiveAbility?(:WONDERSKIN)
      @battle.pbShowAbilitySplash(user, true, false)
      oldAbil = user.ability
      user.ability = :WONDERSKIN
      @battle.pbReplaceAbilitySplash(user)
      @battle.pbDisplay(_INTL("{1} acquired the ability {2}!", user.pbThis, user.abilityName))
      @battle.pbHideAbilitySplash(user)
      user.pbOnLosingAbility(oldAbil)
      user.pbTriggerAbilityOnGainingIt
    end
  end
end

#===============================================================================
# (Caledfwich)
# Exclusive to: Kirineon
#===============================================================================
class Battle::Move::CaledfwichElement < Battle::Move
  def pbCritialOverride(user, target); return 1 if user.hasActiveItem?(:DRAGONELEMENT); end  
  def pbOnStartUse(user, targets)
    if user.hasActiveItem?(:DRAGONELEMENT) 
      @battle.pbCommonAnimation("UseItem", user)
      @battle.pbDisplay(_INTL("{1}'s {2} sharpened their attack!", user.pbThis,user.itemName)) 
    end 
  end

  def pbBaseAccuracy(user, target)
    return 0 if user.hasActiveItem?(:DRAGONELEMENT)
    return super
  end

  def pbEffectAgainstTarget(user, target)
    return if !target.isFainted?
    if user.pbCanRaiseStatStage?(:SPECIAL_DEFENSE, user, self, true) 
      user.pbRaiseStatStage(:SPECIAL_DEFENSE,2,user)
    end 
  end

  def pbEffectAfterAllHits(user, target)
      user.pbConsumeItem if user.hasActiveItem?(:DRAGONELEMENT) 
  end
end

#===============================================================================
# Drains the PP of all the target's moves by 2
# Deals 10 damage to the target for each PP drained (Cognito Blizzard)
# Exclusive to: Bastillox
#===============================================================================
class Battle::Move::FrostbitePPdrain2All < Battle::Move
  def pbFixedDamage(user, target)
    fixDmg = 0
    target.eachMove do |m|
      next if m.pp == 0 && m.total_pp > 0
      drain = 2
      drain += 1 if user.hasActiveItem?(:GRUDGEDOLL)
      drain = [drain, m.pp].min
      m.pp -= drain
      fixDmg += (drain * 10)
    end
    fixDmg = [fixDmg , 1].max
    return fixDmg
  end
end

def pbAdditionalEffect(user, target)
  return if target.damageState.substitute
  return if target.damageState.hpLost <= 1
  target.pbFreeze if target.pbCanFreeze?(user, false, self)
end

#===============================================================================
# Turns target into Normal type, heals 25% with a Normal Element (Crystal Tide)
# Exclusive to: Transluceon
#===============================================================================
class Battle::Move::SetTargetTypesToNormalElement < Battle::Move
  def pbEffectAgainstTarget(user, target)
    if target.canChangeType? && GameData::Type.exists?(:NORMAL) &&
      !target.pbHasOtherType?(:NORMAL)
      target.pbChangeTypes(:NORMAL)
      typeName = GameData::Type.get(:NORMAL).name
      @battle.pbDisplay(_INTL("{1}'s type changed to {2}!", target.pbThis, typeName))
    end
  end

  def pbEffectAfterAllHits(user, target)
    return if target.damageState.hpLost <= 0
    if user.hasActiveItem?(:NORMALELEMENT) 
      @battle.pbCommonAnimation("UseItem", user)
      @battle.pbDisplay(_INTL("{1}'s {2} surged with healing energy!", user.pbThis,user.itemName))
      hpGain = (user.totalhp*0.25).round
      user.pbRecoverHP(hpGain)
      user.pbConsumeItem 
    end 
  end
end

#===============================================================================
# (Demiurgear)
# Exclusive to: Auvraney / Ecclurgeia
#===============================================================================
class Battle::Move::Demiurgear < Battle::Move
  def ignoresSubstitute?(user); return true if user.form == 1; end  # Chalice From
  def highCriticalRate?;        return true if user.form == 4; end  # Lance Form
  def ignoresReflect?;          return true if user.form == 6; end  # Wand From
  
  def pbBaseType(user)
    case user.form
    when 1 # Chalice Form
      ret = :FAIRY
    when 2 # Armor Form
      ret = :BUG
    when 3 # Shield Form
      ret = :PSYCHIC
    when 4 # Lance Form
      ret = :DARK
    when 5 # Crown Form
      ret = :POISON
    when 6 # Wand Form
      ret = :STEEL
    when 7 # Ark Form
      ret = :WATER
    end
    return ret
  end

  def pbBaseDamage(baseDmg, user, target)
    baseDmg *= 1.5 if user.form > 0
    return baseDmg
  end

  def pbGetAttackStats(user, target)
    if user.attack > user.spatk
      return user.attack, user.stages[:ATTACK] + 6
    end
    return user.spatk, user.stages[:SPECIAL_ATTACK] + 6
  end

  def pbChangeUsageCounters(user, specialUsage)
    super
    @battle.moldBreaker = true if !specialUsage && user.form != 7 # Ark Form
  end

  def pbCalcTypeModSingle(moveType, defType, user, target)
    if (defType == :DARK && user.form == 3) ||  # Shield Form
       (defType == :STEEL && user.form == 5)    # Crown Form
      return Effectiveness::NORMAL_EFFECTIVE_ONE 
    end
    return super
  end

  def pbEffectAfterAllHits(user, target)
    return if user.wild?   # Wild Pokémon can't knock off
    return if user.fainted?
    return if user.form != 2 # Armor form
    return if target.damageState.unaffected || target.damageState.substitute
    return if !target.item || target.unlosableItem?(target.item)
    return if target.hasActiveAbility?(:STICKYHOLD) && !@battle.moldBreaker
    itemName = target.itemName
    target.pbRemoveItem(false)
    @battle.pbDisplay(_INTL("{1} dropped its {2}!", target.pbThis, itemName))
  end
end

#===============================================================================
# For 3 rounds, Halves all Battler's HP at the end of each turn (Divide by Zero)
# Exclusive to: Neurignity
#===============================================================================
class Battle::Move::StartHalveBattlerHPeachTurn < Battle::Move
  def pbMoveFailed?(user, targets)
    if @battle.field.effects[PBEffects::DivideByZero] > 0
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if user.hp < user.totalhp
      @battle.pbDisplay(_INTL("{1}'s HP is too high!"))
      return true
    end
    return false
  end

  def pbSelfKO(user)
    return if user.fainted?
    user.pbReduceHP(user.hp, false)
    user.pbItemHPHealCheck
    user.pbFaint if user.fainted?
  end

  def pbEffectGeneral(user)
    @battle.field.effects[PBEffects::DivideByZero] = 4
    @battle.pbDisplay(_INTL("A strange anomaly in which the HP of all battlers will be halved each turn"))
    allBattlers.each do |b|
      next if b.fainted?
      @scene.pbDamageAnimation(b)
      b.pbReduceHP(b.hp / 2).round
    end
  end

  #def pbShowAnimation(id, user, targets, hitNum = 0, showAnimation = true)
  #  return if @battle.field.effects[PBEffects::WonderRoom] > 0   # No animation
  #  super
  #end
end

#===============================================================================
# Burns Target. Type effectiveness is multiplied by the Dragon-type's effectiveness against
# the target. Burn chance is doubled against ROCK-Type Targets.
# Damage is 2 x against ROCK-Type Pokémon (Dragon Flare)
# Exclusive to: Charizard
#===============================================================================
class Battle::Move::BurnsTargetEffectivenessIncludesDragonType < Battle::Move::BurnTarget
  def pbCalcTypeModSingle(moveType, defType, user, target)
    ret = super
    if GameData::Type.exists?(:DRAGON)
      dragonEff = Effectiveness.calculate_one(:DRAGON, defType)
      ret *= dragonEff.to_f / Effectiveness::NORMAL_EFFECTIVE_ONE
    end
    return ret
  end

  def pbCalcTypeModSingle(moveType, defType, user, target)
    return Effectiveness::SUPER_EFFECTIVE_ONE if defType == :ROCK
    return super
  end
end

#===============================================================================
# User takes recoil damage equal to 1/2 of its current HP. (Dreadnought)
# Exclusive to: Chesnaught
#===============================================================================
class Battle::Move::UserLosesHalfHPDreadnaught < Battle::Move::RecoilMove
  def pbBaseDamage(baseDmg, user, target)
    baseDmg /= 2 if user.hp <= (user.totalhp/2)
    return baseDmg
  end

  def pbRecoilDamage(user, target)
    return if user.fainted? || target.damageState.unaffected
    return (user.hp / 2.0).round
  end

  def pbEffectAfterAllHits(user, target)
    return if user.fainted? || target.damageState.unaffected
    amt = pbRecoilDamage(user, target)
    amt = 1 if amt < 1
    user.pbReduceHP(amt, false)
    @battle.pbDisplay(_INTL("{1} is damaged by recoil!", user.pbThis))
    user.pbItemHPHealCheck
  end
end

#===============================================================================
# Prevents target from escaping and makes them Drowsy
# Higher Priority during Jungle Terrain (Dreaweaver)
# Exclusive to: Ariados
#===============================================================================
class Battle::Move::TrapTargetInBattleYawn < Battle::Move::TrapTargetInBattle
  def pbPriority(user)
    ret = super
    ret += 1 if @battle.field.terrain == :Jungle && user.affectedByTerrain?
    return ret
  end

  def pbAdditionalEffect(user, target)
    return if target.fainted? || target.damageState.substitute
    return if target.effects[PBEffects::MeanLook] >= 0 && target.effects[PBEffects::Yawn] > 0
    if target.effects[PBEffects::MeanLook] == 0 
      target.effects[PBEffects::MeanLook] = user.index
      @battle.pbDisplay(_INTL("{1} can no longer escape!", target.pbThis))
    end
    if target.effects[PBEffects::Yawn] == 0
      target.effects[PBEffects::Yawn] = 2
      @battle.pbDisplay(_INTL("{1}'s web made {2} drowsy!", user.pbThis, target.pbThis(true)))
    end
  end
end

#===============================================================================
# (Eden's Lament).
# Exclusive to: Noctaphem
#===============================================================================
class Battle::Move::DrainHalfLastTurnFaint < Battle::Move
  def initialize(battle, move)
    @lament = false 
  end
  
  def pbBaseDamage(baseDmg, user, target)
     lrf = user.pbOwnSide.effects[PBEffects::LastRoundFainted]
     @lament = true if lrf >= 0 && lrf == @battle.turnCount - 1 && user.effect[PBEffects::HealBlock] == 0 && 
     user.hp < user.totalhp
    baseDmg = 1 if @lament 
    return baseDmg
  end

  def pbEffectAgainstTarget(user, target) 
    return if !@lament
    steal = 0
    t_hp = (taget.hp / 2).round 
    target.pbReduceHP(t_hp)
    steal += t_hp
    if target.effects[PBEffects::MeanLook] == 0  && !target.pbHasType?(:GHOST)
      target.effects[PBEffects::MeanLook] = user.index
      @battle.pbDisplay(_INTL("{1} can no longer escape!", target.pbThis))
    end
    if target.allAllies.length > 0
      target.eachAlly do |b|
        s = (b.hp / 2).round
        b.pbReduceHP(s)
        steal += s
        if b.effects[PBEffects::MeanLook] == 0  && !b.pbHasType?(:GHOST)
          b.effects[PBEffects::MeanLook] = user.index
          @battle.pbDisplay(_INTL("{1} can no longer escape!", b.pbThis))
        end
      end
    end
    user.pbRecoverHPFromDrain((steal*0.75), target)
  end
end

#===============================================================================
# May burn of freeze target. Deals Ice and Fire Damage.
# Deals only Ice damage during Hail, Becomes Fire type during Sunlight.
# Chance is doubled during Hail or Sun.
# Damage ignores barriers during Aurora Terrain (Eosflare)
# Exclusive to: Norildys
#===============================================================================
class Battle::Move::BurnFreezeTargetWeatherTypeChange < Battle::Move
  def ignoresReflect?; return true if @battle.field.terrain == :Aurora; end 
  
  def pbBaseType(user)
    ret = :FIRE if user.effectiveWeather == :Sun || user.effectiveWeather == :HarshSun
    return ret
  end

  def pbCalcTypeModSingle(moveType, defType, user, target)
    ret = super
    if target.effectiveWeather != :Sun || target.effectiveWeather != :HarshSun ||
       target.effectiveWeather != :Hail 
      if GameData::Type.exists?(:FIRE)
        fireEff = Effectiveness.calculate_one(:FIRE, defType)
        ret *= fireEff.to_f / Effectiveness::NORMAL_EFFECTIVE_ONE
      end
    end
    return ret
  end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    ch = 10
    ch *= 2 if (target.effectiveWeather == :Sun || 
                target.effectiveWeather == :HarshSun || 
                target.effectiveWeather == :Hail) 
    chance = pbAdditionalEffectChance(user, target, ch)
    return if chance == 0
    if target.effectiveWeather != :Hail 
      if target.pbCanBurn?(user, false, self) && @battle.pbRandom(100) < chance
        target.pbBurn(user)
      end
    end
    if target.effectiveWeather != :Sun || target.effectiveWeather != :HarshSun
      if target.pbCanFreeze?(user, false, self) && @battle.pbRandom(100) < chance
        target.pbFreeze 
      end
    end
  end
end

#===============================================================================
# (Excalibur)
# Exclusive to: Valoreon
#===============================================================================
class Battle::Move::ExcaliburElement < Battle::Move
  def pbCritialOverride(user, target); return 1 if user.hasActiveItem?(:STEELELEMENT); end
  
  def pbOnStartUse(user, targets)
    if user.hasActiveItem?(:STEELELEMENT) 
      @battle.pbCommonAnimation("UseItem", user)
      @battle.pbDisplay(_INTL("{1}'s {2} sharpened their attack!", user.pbThis,user.itemName)) 
    end 
  end

  def pbBaseAccuracy(user, target)
    return 0 if user.hasActiveItem?(:STEELELEMENT)
    return super
  end

  def pbEffectAgainstTarget(user, target)
    return if !target.isFainted?
    if user.pbCanRaiseStatStage?(:ATTACK, user, self, true) 
      user.pbRaiseStatStage(:ATTACK,2,user)
    end 
  end

  def pbEffectAfterAllHits(user, target)
    if user.hasActiveItem?(:STEELELEMENT) 
      user.pbConsumeItem  
    end
  end
end

#===============================================================================
# (Fate Reconstruct)
# Exclusive to: Avrinaath
#===============================================================================
class Battle::Move::RecoverHP50percentPP3 < Battle::Move
  def healingMove?;       return true; end

  def pbMoveFailed?(user, targets)
    if !user.hasActiveAbility?(:KARMAGEAR) 
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if user.pbOwnSide.effects[PBEffects::KarmaGear] < 2
      @battle.pbDisplay(_INTL("{1} does not have enough power over fate",user.pbThis))
      return true
    end
    if user.hp >= user.totalhp && user.status == :NONE
      user.eachMove do |m|
        next if m.id == @id
        next if m.pp != m.total_pp
        @battle.pbDisplay(_INTL("But it failed!"))
        return true
      end
    end
    return false
  end

  def pbEffectGeneral(user)
    hp_restored = false; pp_restored = false
    user.pbOwnSide.effects[PBEffects::KarmaGear] -= 2
    @battle.pbDisplay(_INTL("{1} spent some some their power over fate.",user.pbThis))
    if user.hp < user.totalhp
      user.pbRecoverHP((user.totalhp / 2.0).round)
      hp_restored = true
    end
    user.eachMove do |m|
      next if m.id == @id
      next if m.pp >= m.total_pp && m.total_pp > 0
      next if m.total_pp == 0 
      gain = 5
      m.pp += gain
      m.pp = m.total_pp if m.pp > m.total_pp
      pp_restored = true
    end
    if hp_restored && pp_restored
      @battle.pbDisplay(_INTL("{1}'s power over fate restored their HP and PP",user.pbThis))
    elsif hp_restored && !pp_restored
      @battle.pbDisplay(_INTL("{1}'s power over fate restored their HP",user.pbThis))
    else
      @battle.pbDisplay(_INTL("{1}'s power over fate restored their PP",user.pbThis))
    end
    old_status = user.status
    user.pbCureStatus(false)
    case old_status
    when :BURN
      @battle.pbDisplay(_INTL("{1} healed their burn!", user.pbThis))
    when :POISON
      @battle.pbDisplay(_INTL("{1} cured their poisoning!", user.pbThis))
    when :PARALYSIS
      @battle.pbDisplay(_INTL("{1} cured their paralysis!", user.pbThis))
    end
  end
end

#===============================================================================
# Heals the status conditions in the user's party (Fated Apocalypse)
#===============================================================================
class Battle::Move::HalvesTargetPartyHP < Battle::Move
  def pbMoveFailed?(user, targets)
    if !user.hasActiveAbility?(:KARMAGEAR) 
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if user.pbOwnSide.effects[PBEffects::KarmaGear] < 4
      @battle.pbDisplay(_INTL("{1} does not have enough power over fate",user.pbThis))
      return true
    end
    return false
  end

  def pbEffectAfterAllHits(user, target)
    user.pbOwnSide.effects[PBEffects::KarmaGear] -= 4
    @battle.pbParty(target.index).each_with_index do |pkmn, i|
      next if !pkmn || pkmn.fainted?
      next if @battle.pbFindBattler(i, target)   # Skip Pokémon in battle
      hpLoss = [pkmn.hp / 2, 1].max
      pkmn.pbReduceHP(hpLoss, false, false)
    end
  end
end

#===============================================================================
# (Fear Pendulum)
# Exclusive to: Hypno
#===============================================================================
class Battle::Move::LowerSleepingTargetSpDefNightmare < Battle::Move
  def pbFailsAgainstTarget?(user, target, show_message)
    return true if !target.asleep?
    return false
  end

  def pbEffectAgainstTarget(user, target)
    stages = target.pbSleepDuration
    if user.pbCanRaiseStatStage?(:SPECIAL_DEFENSE, user, self, true) 
      user.pbRaiseStatStage(:SPECIAL_DEFENSE,stages,user)
      if stages >= 2 && !target.effects[PBEffects::Nightmare]
        target.effects[PBEffects::Nightmare] = true
        @battle.pbDisplay(_INTL("{1} began having a nightmare!", target.pbThis))
      end
    end 
  end
end

#===============================================================================
# Causes the target to flinch. Fails if this isn't the user's first turn.
# Sets Aqua ring around the user (Flash Freeze)
# Exclusive to: Glaceon
#===============================================================================
class Battle::Move::FirstTurnFlinchAquaRingElement < Battle::Move
  def pbMoveFailed?(user, targets)
    if user.turnCount > 1
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    target.pbFlinch(user)
    if !user.effects[PBEffects::AquaRing]
      user.effects[PBEffects::AquaRing] = true
      @battle.pbDisplay(_INTL("{1} surrounded themself with a veil of water!", user.pbThis))
    end
  end

  def pbEffectAfterAllHits(user, target)
    if user.hasActiveItem?(:ICEELEMENT) && user.pbCanRaiseStatStage?(:SPEED, user, self, true) 
      user.pbConsumeItem  
      @battle.pbCommonAnimation("UseItem", user)
      @battle.pbDisplay(_INTL("{1}'s {2} powered up the attack!", user.pbThis,user.itemName))
      if user.pbCanRaiseStatStage?(:SPEED, user, self, true) 
        user.pbRaiseStatStage(:SPEED,1,user)
      end
    end
  end
end

#===============================================================================
# (Focus Flurry)
#===============================================================================
class Battle::Move::Hits3TimesEffectHitDependant < Battle::Move
  def multiHitMove?;                   return true; end
  def pbNumHits(user, targets);        return 3;    end

  def pbEffectGeneral(user)
    user.effects[PBEffects::HitNumber] += 1
  end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    case user.effects[PBEffects::HitNumber]
    when 1
      target.pbFlinch(user)
    when 2
      target.pbParalyze(user) if target.pbCanParalyze?(user, false, self) 
    when 3
      if target.pbCanLowerStatStage(:DEFENSE, user, self) 
        target.pbLowerStatStage(:DEFENSE , 2, user)
      end
    end
  end
end

#===============================================================================
# Hits 9 times. Burns Target, deals damage equal to user's primary type
# (Fox-Tail Flare)
# Exclusive to: Ninetales
#===============================================================================
class Battle::Move::HitNineTimesBurnFireorIce < Battle::Move::BurnTarget
  def multiHitMove?; return true; end
  def pbNumHits(user, targets); return 9; end

  def pbBaseType(user)
    userTypes = user.pbTypes(true)
    return userTypes[0] || @type
  end
end

#===============================================================================
# (Frog Chorus)
# Exclusive to: Politoed
#===============================================================================
class Battle::Move::EchoedVoiceSpDef < Battle::Move::PowerHigherWithConsecutiveUseOnUserSide
  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    if @battle.field.terrain == :Jungle
      chance = pbAdditionalEffectChance(user, target, 100)
    else
      chance = pbAdditionalEffectChance(user, target, 30)
    end
    if target.pbCanLowerStatStage(:SPECIAL_DEFENSE, user, self) && @battle.pbRandom(100) < chance
      target.pbLowerStatStage(:SPECIAL_DEFENSE , 1, user)
    end
  end
end

#===============================================================================
# (Glimmervein)
# Exclusive to: Adamanteon
#===============================================================================
class Battle::Move::BurnFreezeTargetWeatherTypeChange < Battle::Move
  def initialize(battle, move) 
    @consume = false; @type = false
  end

  def pbCalcTypeModSingle(moveType, defType, user, target)
    ret = super
    if user.item.is_type_gem?
      @battle.pbCommonAnimation("UseItem", user)
      @battle.pbDisplay(_INTL("{1}'s {2} changed the property of the attack!", 
      user.pbThis,user.itemName))
      @consume=true
    end 
    case user.item
    when :MODGEM
      @type = :NORMAL
    when :GRASSGEM
      @type = :GRASS
    when :FIREGEM
      @type = :FIRE
    when :WATERGEM
      @type = :WATER
    when :ELECTRICGEM
      @type = :ELECTRIC
    when :BUGGEM
      @type = :BUG
    when :GROUNDGEM
      @type = :GROUND
    when :STEELGEM
      @type = :STEEL
    when :FIGHTINGGEM
      @type = :FIGHTING
    when :FLYINGGEM
      @type = :FLYING
    when :POISONGEM
      @type = :POISON
    when :ICEGEM
      @type = :ICE
    when :FAIRYGEM
      @type = :FAIRY
    when :PSYCHICGEM
      @type = :PSYCHIC
    when :GHOSTGEM
      @type = :GHOST
    when :DARKGEM
      @type = :DARK
    when :DRAGONGEM
      @type = :DRAGON
    end
    if GameData::Type.exists?(@type) && @type
      typeEff = Effectiveness.calculate_one(@type, defType)
      ret *= typeEff.to_f / Effectiveness::NORMAL_EFFECTIVE_ONE
    end
    return ret
  end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    return if !@type
    return if @type == :FIRE && target.burned?
    return if @type == :ELECTRIC && target.paralyzed?
    return if @type == :STEEL && !user.pbCanRaiseStatStage?(:ATTACK, user, self)
    return if @type == :POISON && target.poisoned?
    return if @type == :ICE && target.frozen?
    return if @type == :PSYCHIC && target.confused?
 
    case @type
    when :NORMAL
    when :GRASS
    when :FIRE
      target.pbBurn(user) if target.pbCanBurn?(user, false, self)
    when :WATER
    when :ELECTRIC
      target.pbParalyze(user) if target.pbCanParalyze?(user, false, self) 
    when :BUG
    when :GROUND
    when :STEEL
      user.pbRaiseStatStage(:ATTACK, 1, user)
    when :FIGHTING
    when :FLYING
    when :POISON
    when :ICE
      target.pbFreeze if target.pbCanFreeze?(user, false, self)
    when :FAIRY
    when :PSYCHIC
      target.pbConfuse if target.pbCanConfuse?(user, false, self)
    when :GHOST
    when :DARK
    when :DRAGON
    end
  end
end

#===============================================================================
# May Heal the status conditions in the user's party (Healing Horn)
# Becomes the same type as the user's Primary Type
# Exclusive to Rapidash
#===============================================================================
class Battle::Move::HealsPartyStatusDamagePrimaryType < Battle::Move::HealsPartyStatusDamage
  def pbBaseType(user)
    userTypes = user.pbTypes(true)
    return userTypes[0] || @type
  end
end

#===============================================================================
# Causes the target to flinch. Fails if this isn't the user's first turn.
# (Howling Hunt)
# Exclusive to: Mightyena
#===============================================================================
class Battle::Move::FirstTurnFlinchAtk1Speed2 < Battle::Move::FlinchTargetFailsIfNotUserFirstTurn
  def pbOnStartUse(user, targets)
    showAnim = true
    if user.pbCanRaiseStatStage?(:ATTACK, user, self, true) 
      user.pbRaiseStatStage(:ATTACK,1, user , showAnim)
    end 
    if user.pbCanRaiseStatStage?(:SPEED, user, self, true) 
      user.pbRaiseStatStage(:SPEED,2, user , showAnim)
    end
    showAnim = false 
  end
end
#===============================================================================
# Burns targets (Infernal Void)
# Exclusive to: Flareon
#===============================================================================
class Battle::Move::BurnAllFireElement < Battle::Move::BurnTarget
  def pbEffectAfterAllHits(user, target)
    if user.hasActiveItem?(:FIREELEMENT) && target.pbOwnSide.effects[PBEffects::SeaOfFire] <= 0  
      user.pbConsumeItem  
      @battle.pbCommonAnimation("UseItem", user)
      @battle.pbDisplay(_INTL("{1}'s Fire Element intensified the flames!", user.pbThis))
      target.pbOwnSide.effects[PBEffects::SeaOfFire] = 5
      @battle.pbDisplay(_INTL("A sea of fire enveloped {1}!", target.pbThis(true)))
      animName = (user.opposes?) ? "SeaOfFire" : "SeaOfFireOpp"
    end
  end
end

#===============================================================================
# In wild battles, makes target flee. Fails if target is a higher level than the
# user.In trainer battles, target switches out.
# Switch out cannot be stooped during rain. (Levia Stream)
# Exclusive to: Levyana
#===============================================================================
class Battle::Move::SwitchOutTargetLeviaStream < Battle::Move
  def initialize(battle, move)
    @force = false
  end

  def pbSwitchOutTargetEffect(user, targets, numHits, switched_battlers)
    return if @battle.wildBattle? || !switched_battlers.empty?
    return if user.fainted? || numHits == 0
    @force = true if user.effectiveWeather == :Rain || user.effectiveWeather == :HeavyRain
    targets.each do |b|
      next if b.fainted? || b.damageState.unaffected || b.damageState.substitute
      if !@force
        next if b.effects[PBEffects::Ingrain] 
        next if b.hasActiveAbility?(:SUCTIONCUPS) && !@battle.moldBreaker
        newPkmn = @battle.pbGetReplacementPokemonIndex(b.index, true)   # Random
        if b.hasActiveItem?(:GREENCARD)
          @battle.pbCommonAnimation("UseItem", b)
          @battle.pbDisplay(_INTL("{1}'s {2} prevents them from being switched out!", b.pbThis, b.itemName))
          b.pbConsumeItem
          next
        end
      end
      next if newPkmn < 0
      @battle.pbRecallAndReplace(b.index, newPkmn, true)
      @battle.pbDisplay(_INTL("{1} was dragged out!", b.pbThis))
      @battle.pbClearChoice(b.index)   # Replacement Pokémon does nothing this round
      @battle.pbOnBattlerEnteringBattle(b.index)
      switched_battlers.push(b.index)
      break
    end
  end
end

#===============================================================================
# (Lucid Dream)
# Exclusive to: Musharna
#===============================================================================
class Battle::Move::LucidDream < Battle::Move::HealAllyOrDamageFoe
  def usableWhenAsleep?; return true; end
end

#===============================================================================
# Raises user's Attack. May cause the target to flinch. (Mausoleum)
# Exclusive to: Antiqueon
#===============================================================================
class Battle::Move::SwitchOutTargetDamagingMoveElement < Battle::Move::SwitchOutTargetDamagingMove
  def pbBaseDamage(baseDmg, user, target)
    baseDmg *= 1.5 if user.pbOpposingSide.effect[PBEffects::Spikes] > 0 ||
                      user.pbOpposingSide.effect[PBEffects::ToxicSpikes] > 0 ||
                      user.pbOpposingSide.effect[PBEffects::StealthRock] ||
                      user.pbOpposingSide.effect[PBEffects::IcicleRain] ||
                      user.pbOpposingSide.effect[PBEffects::StickyWeb] ||
                      user.pbOpposingSide.effect[PBEffects::BurningGround]  
    return baseDmg
  end


  def pbSwitchOutTargetEffect(user, targets, numHits, switched_battlers)
    return if @battle.wildBattle? || !switched_battlers.empty?
    return if user.fainted? || numHits == 0
    targets.each do |b|
      next if b.fainted? || b.damageState.unaffected || b.damageState.substitute
      next if b.effects[PBEffects::Ingrain]
      next if b.hasActiveAbility?(:SUCTIONCUPS) && !@battle.moldBreaker
      newPkmn = @battle.pbGetReplacementPokemonIndex(b.index, true)   # Random
      next if newPkmn < 0
      if b.hasActiveItem?(:GREENCARD)
        @battle.pbCommonAnimation("UseItem", b)
        @battle.pbDisplay(_INTL("{1}'s {2} prevents them from being switched out!", b.pbThis, b.itemName))
        b.pbConsumeItem
        next
      end
      @battle.pbRecallAndReplace(b.index, newPkmn, true)
      @battle.pbDisplay(_INTL("{1} was dragged out!", b.pbThis))
      @battle.pbClearChoice(b.index)   # Replacement Pokémon does nothing this round
      @battle.pbOnBattlerEnteringBattle(b.index)
      switched_battlers.push(b.index)
      break
    end
  end

  def pbEffectAfterAllHits(user, target)
    if user.hasActiveItem?(:GROUNDELEMENT) 
      if user.pbCanRaiseStatStage?(:SPEED, user, self, true)
        @battle.pbCommonAnimation("UseItem", user)
        @battle.pbDisplay(_INTL("{1}'s {2} powered them up!", user.pbThis))
          user.pbRaiseStatStage(:SPEED,1,user)
          user.pbConsumeItem 
      end
    end
  end
end

#===============================================================================
# (Mermaid Horn)
# Exclusive to: Dewgong
#===============================================================================
class Battle::Move::AttractsTargetTripleAuroraMisty < Battle::Move
  def initialize(battle, move)
    @boost = false
  end

  def pbInitialEffect(user, targets, hitNum)
    if user.hasActiveItem?(:DESTINYKNOT) && target.pbCanAttract?(user, false) && 
      !(target.hasActiveAbility(:SHIELDDUST) && target.hasActiveAbility(:SHEERFORCE)) && !@boost
      @battle.pbCommonAnimation("UseItem", user)
      user.pbConsumeItem
      @boost = true
    end 
  end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    ch = 10
    ch *= 3 if @battle.field.terrain == :Misty || @battle.field.terrain == :Aurora
    ch = 100 if @boost
    chance = pbAdditionalEffectChance(user, target, ch)
    return if chance == 0
    target.pbAttract(user) if target.pbCanAttract?(user, false) && @battle.pbRandom(100) < chance
  end
end

#===============================================================================
# Increases the user's Attack, Defense and Speed by 1 stage.
# Raises  Hit Rate with a Fighting Element (Mind Mantra)
# Exclusive to: Harmoneon
#===============================================================================
class Battle::Move::RaiseUserAtkDefSpd1Element < Battle::Move
  def initialize(battle, move)
    super
    @statUp = [:ATTACK,1, :DEFENSE,1, :SPEED,1]
  end
end

def pbEffectGeneral(user)
  showAnim = true
  (@statUp.length / 2).times do |i|
    next if !user.pbCanRaiseStatStage?(@statUp[i * 2], user, self)
    if user.pbRaiseStatStage(@statUp[i * 2], @statUp[(i * 2) + 1], user, showAnim)
      showAnim = false
    end
  end

  if user.hasActiveItem?(:FIGHTIINGELEMENT) && target.effects[PBEffects::FocusEnergy] < 2  
    @battle.pbCommonAnimation("UseItem", user)
    @battle.pbDisplay(_INTL("{1}'s {2} sharpened their sense!", user.pbThis,user.itemName))
    target.effects[PBEffects::FocusEnergy] += 1
    user.pbConsumeItem
  end 
end

#===============================================================================
# Hits 2 times (Mind Rays)
# Exclusive to Girafarig / Farigiraf
#==============================================================================
class Battle::Move::Hits2Times1stPsychic2ndDark < Battle::Move
  def multiHitMove?; return true; end
  def pbNumHits(user, targets); return 2; end
  
  def pbInitialEffect(user, targets, hitNum)
    user.effects[PBEffects::HitNumber] += 1
  end
  
  def pbBaseType(user)
    ret = :DARK if user.effects[PBEffects::HitNumber] == 2
    return ret
  end
  
  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    hit = user.effects[PBEffects::HitNumber]
    case hit
    when 1
      if target.pbCanLowerStatStage?(:SPECIAL_ATTACK, user, self, true) 
        target.pbLowerStatStage(:SPECIAL_ATTACK,1,user)
      end
    when 2
      if target.pbCanLowerStatStage?(:ATTACK, user, self, true) 
        target.pbLowerStatStage(:ATTACK,1,user)
      end
    end
  end
end

#===============================================================================
# Raises Speed by stages equal to number of Combee in the party + 1 (Move Order)
# Exclusive to: Vespiquen
#===============================================================================
class Battle::Move::RaiseSpeedCombee < Battle::Move
  def pbMoveFailed?(user, targets)
    if !user.pbCanRaiseStatStage?(:SPEED, user, self)
      @battle.pbDisplay(_INTL("{1}'s stats won't go any higher!", user.pbThis))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    party = @battle.pbParty(user.index)
    stages = 1
    for p in party
      if p.pokemon.species == :COMBEE
        stages += 1
      end
    end
    if user.pbCanRaiseStatStage?(:SPEED, user, self)
      user.pbRaiseStatStage(:SPEED, stages, user)
    end
  end
end

#===============================================================================
# May put target to sleep (Mystic Melody)
# Chance is doubled during Mystic Terrain or Sandstorm 
# Exclusive to: Flygon
#===============================================================================
class Battle::Move::SleepMysticTerrainSandstorm < Battle::Move
  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    ch = 10
    ch *= 2 if  user.effectiveWeather == :Sandstorm || 
                @battle.field.terrain == :Mystic
    chance = pbAdditionalEffectChance(user, target, ch)
    return if chance == 0
    target.pbSleep if target.pbCanSleep?(user, false, self) && @battle.pbRandom(100) < chance
  end
end

#===============================================================================
# (Pale Halo)
# Exclusive to: Shedinja
#===============================================================================
class Battle::Move::UserMakeSubstitute < Battle::Move
  def pbMoveFailed?(user, targets)
    if user.pbOwnSide.effects[PBEffects::PaleHalo]
      @battle.pbDisplay(_INTL("Pale Halo cannot be used again!", user.pbThis))
      return true
    end
    if user.effects[PBEffects::Substitute] > 0
      @battle.pbDisplay(_INTL("{1} already has a substitute!", user.pbThis))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    sublifemult = 1.0
    if @battle.field.terrain == :Spirit
      @battle.pbDisplay(_INTL("The spiritual energies gave the halo life"))
      sublifemult += 0.2 
    end
    if user.item != 0 
      user.pbConsumeItem  
      @battle.pbCommonAnimation("UseItem", user)
      @battle.pbDisplay(_INTL("{1}'s item was consumed to give the halo life!", user.pbThis))
      sublifemult += 0.2 
    end
    user.pbOwnSide.effects[PBEffects::PaleHalo]     = true
    user.effects[PBEffects::Trapping]     = 0
    user.effects[PBEffects::TrappingMove] = nil
    user.effects[PBEffects::Substitute]   = @subLife
    @battle.pbDisplay(_INTL("A pale halo surrounds {1}!", user.pbThis))
  end
end


#===============================================================================
# Poisons the target, may also confuse target (Papillon Pulse)
# Exclusive to: Butterfree
#===============================================================================
class Battle::Move::PoisonConfuseTargetPowder < Battle::Move
  def powderMove?;  return true; end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    chance = pbAdditionalEffectChance(user, target, 10)
    return if chance == 0
    if target.pbCanPoison?(user, false, self) && @battle.pbRandom(100) < chance
      target.pbPoison(user)
    end
    if !target.pbCanConfuse?(user, false, self) && @battle.pbRandom(100) < chance
      target.pbConfuse 
    end
  end
end

#===============================================================================
# (Passage of Fate)
# Exclusive to: Avrinaath
#===============================================================================
class Battle::Move::SetPassageOfFate < Battle::Move
  def pbMoveFailed?(user, targets)
    if !user.hasActiveAbility?(:KARMAGEAR) || 
       user.effects[PBEffects::PassageOfFate] 
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if user.pbOwnSide.effects[PBEffects::KarmaGear] < 1
      @battle.pbDisplay(_INTL("{1} does not have enough power over fate",user.pbThis))
      return true
    end
    hpLoss = [user.totalhp / 4, 1].max
    if user.hp <= hpLoss
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    hpLoss = [user.totalhp / 4, 1].max
    karma = user.pbOwnSide.effects[PBEffects::KarmaGear]
    user.pbReduceHP(hpLoss, false, false)
    user.pbOwnSide.effects[PBEffects::KarmaGear] -= 1
    user.effects[PBEffects::PassageOfFate] = true
    @battle.pbDisplay(_INTL("{1}'s Karma counter reduced to {2} .",user.pbThis,karma))
    @battle.pbDisplay(_INTL("{1}'s Attack and Special Attack will raise when they change fate.",user.pbThis))
  end
end

#===============================================================================
# Hits 3 times. Power is multiplied by the hit number. (Pecking Order)
# An accuracy check is performed for each hit. may Lower target's Defense 
# Exclusive to: Dodrio
#===============================================================================
class Battle::Move::TripleKickLowerDef1 < Battle::Move::HitThreeTimesPowersUpWithEachHit
  def pbEffectGeneral(user)
    user.effects[PBEffects::HitNumber] += 1
  end
  
  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    hit = user.effects[PBEffects::HitNumber]
    chance = pbAdditionalEffectChance(user, target, (hit*10))
    return if chance == 0
    if target.pbCanLowerStatStage?(:DEFENSE, user, self, true) && @battle.pbRandom(100) < chance
        target.pbLowerStatStage(:DEFENSE,1,user)
    end
  end
end  

#===============================================================================
# Burns, Confuses and plants a Leech Seed ont the target (Pollen Hazard).
# Exclusive to: Venusaur
#===============================================================================
class Battle::Move::BurnConfuseSeedTarget < Battle::Move
  def canMagicCoat?; return true; end
  def powderMove?;  return true; end
  
  def pbEffectAgainstTarget(user, target)
    if target.pbCanBurn?(user, false, self)
      target.pbBurn(user)
    end
    if target.pbCanConfuse?(user, false, self)
      target.pbConfuse
    end 
    if !target.pbHasType?(:GRASS)
      target.effects[PBEffects::LeechSeed] = user.index
      @battle.pbDisplay(_INTL("{1} was seeded!", target.pbThis))
    end
  end
end

#===============================================================================
# May put the target to sleep. (Power Ballad)
# Accuracy is 100% against a sleeping target.
# Raises user's Attack and Special attack if used on a sleeping target
#===============================================================================
class Battle::Move::SleepTargetAtkSpAtk1AgainstSleepingTarget < Battle::Move
  def pbBaseAccuracy(user, target)
    return 100 if target.asleep?
    return super
  end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    chance = pbAdditionalEffectChance(user, target, 20)
    chance = pbAdditionalEffectChance(user, target, 100) if target.asleep?
    return if chance == 0
    if target.asleep?
      showAnim = true
      for s in [:ATTACK, :SPECIAL_ATTACK]
        if user.pbCanRaiseStatStage?(s, user, self)
          user.pbRaiseStatStage(s, 1, user, showAnim)
        end
      end
      showAnim = false
    else
      target.pbSleep if target.pbCanSleep?(user, false, self) 
    end
  end
end

#===============================================================================
# (Pylon Tail)
# Exclusive to: Sceptile
#===============================================================================
class Battle::Move::SetTargetAbilityToLightningRod  < Battle::Move
  def pbBaseDamage(baseDmg, user, target)
    baseDmg = 120 if @battle.field.terrain == :Jungle
    return baseDmg
  end
  
  def pbEffectAfterAllHits(user, target)
    if !user.hasActiveAbility?(:LIGHTINGROD)
      @battle.pbShowAbilitySplash(user, true, false)
      oldAbil = user.ability
      user.ability = :LIGHTINGROD
      @battle.pbReplaceAbilitySplash(user)
      @battle.pbDisplay(_INTL("{1} acquired the ability {2}!", user.pbThis, user.abilityName))
      @battle.pbHideAbilitySplash(user)
      user.pbOnLosingAbility(oldAbil)
      user.pbTriggerAbilityOnGainingIt
    end
  end
end

#===============================================================================
# User must use this move for 4 more rounds. Power doubles each round.
# Power is also doubled if user has curled up. 
# Each hit may lay a layer of spikes around the opposing field (Spike Ball)
# Move becomes the same type as user's Primary Type
# Exclusive to: Sandslash
#===============================================================================
class Battle::Move::MultiTurnAttackPowersUpEachTurnSpikes < Battle::Move::MultiTurnAttackPowersUpEachTurn
  def pbBaseType(user)
    userTypes = user.pbTypes(true)
    return userTypes[0] || @type
  end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    return if user.pbOpposingSide.effects[PBEffects::Spikes] >= 3
    return if user.pbOpposingSide.effects[PBEffects::ToxicSpikes] >= 0
    user.pbOpposingSide.effects[PBEffects::Spikes] += 1
    @battle.pbDisplay(_INTL("Spikes were scattered around {1}'s feet!",user.pbOpposingTeam(true)))
  end
end

#===============================================================================
# User is protected against damaging moves this round. (Spore Shield)
# Puts any target that uses a super-effective move against the target to sleep.
# Exclusive to: Parasect
#===============================================================================
class Battle::Move::ProtectUserFromDamagingMovesSpreShield < Battle::Move::ProtectMove
  def initialize(battle, move)
    super
    @effect = PBEffects::SporeShield
  end
end

#===============================================================================
# User is protected against damaging moves this round. (Tachyon Shield)
# 
# Exclusive to: Euphyon, Eumantlyon, Eurityon
#===============================================================================
class Battle::Move::ProtectUserFromMovesTachyonShield < Battle::Move::ProtectMove
  def initialize(battle, move)
    super
    @effect = PBEffects::TachyonShield
  end

  def pbMoveFailed?(user, targets)
    if !user.hasActiveAbility?(:RIPPLEPORTAL) &&
      !user.hasActiveAbility?(:CORONAPORTAL) &&
      !user.hasActiveAbility?(:GRAVITONPORTAL)
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end
end

#===============================================================================
# After Doing damage the user will call on the last move used.
# Can call on itself but will deplete PP to 0 (Time Paradox)
# Exclusive to: Celebi
#===============================================================================
class Battle::Move::TimeParadox < Battle::Move
  def pbEffectAfterAllHits(user, target)
    if !target.isFainted? && user.lastMoveUsed.pp > 0
      @battle.pbDisplay(_INTL("{1} reversed the flow of time!",user.pbThis))
      for i in 0...user.moves.length
        if user.moves[i].id==@id
          newmove=PBMove.new(user.lastMoveUsed)
          instructmove = PokeBattle_Move.pbFromPBMove(@battle,newmove)
          choices = [1, i, instructmove, -1]
          user.pbUseMove(choices, false, true)
        end
      end
    end
  end
end
  
#===============================================================================
# Hits 2-5 times. 
# May raise user's Attack, chance is multiplied by the number of hits.
# Chance is higher when user's HP is less than 50% (Tooth and Nail)
# Exclusive to: Feraligatr
#===============================================================================
class Battle::Move::HitTwoToFiveTimesRaiseAtk14th5thCritical < Battle::Move::HitTwoToFiveTimes
  def multiHitMove?; return true; end
  def pbCritialOverride(user, target); return 1 if user.effect[PBEffects::HitNumber] >= 4 ; end

  def pbEffectAfterAllHits(user, target)
    hit = user.effects[PBEffects::HitNumber]
    chance = pbAdditionalEffectChance(user, target, (hit*10))
    return if chance == 0
    if user.pbCanRaiseStatStage(:ATTACK, user, self, true) && @battle.pbRandom(100) < chance
        user.pbRaiseStatStage(:ATTACK,1,user)
    end
  end
end



#===============================================================================
# Badly poisons targets (Venom Void)
# Exclusive to: Pandemeon
#===============================================================================
class Battle::Move::BadPoisonAllPoisonElement < Battle::Move::BadPoisonTarget 
  def pbEffectAgainstTarget(user, target)
    if user.hasActiveItem?(:POISONELEMENT) 
      @battle.pbCommonAnimation("UseItem", user)
      @battle.pbDisplay(_INTL("{1}'s Poison Element intensified their poison!", user.pbThis))
      user.pbEffects[PBEffects::HyperVenom]=true
      user.pbConsumeItem 
    end
    target.effects[PBEffects::Toxic] += 3 if user.pbEffects[PBEffects::HyperVenom]
  end
end

#===============================================================================
# Causes the target to flinch. Fails if this isn't the user's first turn.
# Ingrains the user (Verdant Flash)
# Exclusive to: Leafeon
#===============================================================================
class Battle::Move::FirstTurnFlinchIngrainElement < Battle::Move
  def pbMoveFailed?(user, targets)
    if user.turnCount > 1
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    target.pbFlinch(user)
    if !user.effects[PBEffects::Ingrain]
      user.effects[PBEffects::Ingrain] = true
      @battle.pbDisplay(_INTL("{1} planted its roots!", user.pbThis))
    end
  end

  def pbEffectAfterAllHits(user, target)
    if user.hasActiveItem?(:GRASSELEMENT) && user.pbCanRaiseStatStage?(:SPEED, user, self, true) 
      user.pbConsumeItem  
      @battle.pbCommonAnimation("UseItem", user)
      @battle.pbDisplay(_INTL("{1}'s Grass Element powered up the attack!", user.pbThis))
      if user.pbCanRaiseStatStage?(:SPEED, user, self, true) 
        user.pbRaiseStatStage(:SPEED,1,user)
      end
    end
  end
end

#===============================================================================
# (Volt Needles)
# Exclusive to: Jolteon
#===============================================================================
class Battle::Move::HitTwoToFiveTimesParalyzeElement < Battle::Move::HitTwoToFiveTimes
  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    target.pbParalyze(user) if target.pbCanParalyze?(user, false, self)
  end

  def pbEffectAfterAllHits(user, target)
    if user.hasActiveItem?(:ELECTRICELEMENT) && @battle.field.terrain != :Electric
      user.pbConsumeItem  
      @battle.pbCommonAnimation("UseItem", user)
      @battle.pbDisplay(_INTL("{1}'s {2} reacted with the electrified fut!", user.pbThis,user.itemName))
      @battle.pbStartTerrain(user, :Electric)
    end
  end
end

#===============================================================================
# May set a 3-turn tailwind around the user's team (Wind Serenade)
# May put the target to sleep, guaranteed if the user is holding a Flying Element.
# Exclusive to: Zephyreon
#===============================================================================
class Battle::Move::TailwindSleepElement < Battle::Move
  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    chance = pbAdditionalEffectChance(user, target, 30)
    chance2 = pbAdditionalEffectChance(user, target, 10)
    return if chance == 0
    if user.pbOwnSide.effects[PBEffects::Tailwind] == 0 && @battle.pbRandom(100) < chance
      user.pbOwnSide.effects[PBEffects::Tailwind] = 4
      @battle.pbDisplay(_INTL("The Tailwind blew from behind {1}!", user.pbTeam(true)))
    end
    if user.hasActiveItem?(:FLYINGELEMENT) && target.pbCanSleep?(user, false, self)
      user.pbConsumeItem  
      @battle.pbCommonAnimation("UseItem", user)
      @battle.pbDisplay(_INTL("{1}'s {2} strengthened the melody!", user.pbThis,user.itemName))
      chance2 = pbAdditionalEffectChance(user, target, 100)
    end
    target.pbSleep if target.pbCanSleep?(user, false, self) && @battle.pbRandom(100) < chance2
  end
end