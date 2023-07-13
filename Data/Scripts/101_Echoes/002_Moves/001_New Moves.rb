#===============================================================================
# User loses their Ice type. Fails if user is not Electric-type. (Absolute Zero)
#===============================================================================
class Battle::Move::UserLosesIceType < Battle::Move
  def pbMoveFailed?(user, targets)
    if !user.pbHasType?(:ICE)
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectAfterAllHits(user, target)
    if !user.effects[PBEffects::AbsoluteZero]
      user.effects[PBEffects::AbsoluteZero] = true
      @battle.pbDisplay(_INTL("{1} tired itself out!", user.pbThis))
    end
  end
end

#===============================================================================
# Reduces the user's HP by half of max, Sharply Increases Sp.Def and 
# raises Special Attack and Speed during Mystic Terrain (Alagaesia)
#===============================================================================
class Battle::Move::HistoricSpAtkAtkSpeed < Battle::Move
  def canSnatch?; return true; end
  
  def initialize(battle, move)
    @statUp = [:SPECIAL_ATTACK, 2, :ATTACK, 1, :SPEED,1]
  end

  def pbMoveFailed?(user, targets)
    if @battle.field.terrain != :Mystic
      if user.hasActiveItem?(:MEMORYIDOL)
        @battle.pbCommonAnimation("UseItem", user)
        @battle.pbDisplay(_INTL("The {1} triggered {2}'s memories!",user.itemName,user.pbThis))
        user.pbConsumeItem
        return false
      else
        @battle.pbDisplay(_INTL("The Memory failed to Trigger"))
        return true
      end
    end
    hpLoss = [user.totalhp / 2, 1].max
    if user.hp <= hpLoss
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if !user.pbCanRaiseStatStage?(:SPECIAL_ATTACK, user, self) &&
       !user.pbCanRaiseStatStage?(:ATTACK, user, self) &&
       !user.pbCanRaiseStatStage?(:SPEED, user, self)
       @battle.pbDisplay(_INTL("{1}'s stats won't go any higher!", user.pbThis))
       return true
    end
    return false
  end

  def pbEffectGeneral(user)
    hpLoss = [user.totalhp / 2, 1].max
    user.pbReduceHP(hpLoss, false, false)
    showAnim = true
    (@statUp.length / 2).times do |i|
      next if !user.pbCanRaiseStatStage?(@statUp[i * 2], user, self)
      if user.pbRaiseStatStage(@statUp[i * 2], @statUp[(i * 2) + 1], user, showAnim)
        showAnim = false
      end
    end
    user.pbItemHPHealCheck
  end
end

#===============================================================================
# Attacks first turn, skips second turn. (if successful). 
# May sharply lower target's Special Defense (Amethyst Ray)
#===============================================================================
class Battle::Move::HyperBeamLowerSpDef2 < Battle::Move
end

#===============================================================================
# Reduces the user's HP by half of max, Sharply Increases Defense and 
# Special Defense (Angkor)
#===============================================================================
class Battle::Move::HistoricDefSpDef < Battle::Move
  def canSnatch?; return true; end
  def initialize(battle, move)
    super
    @statUp = [:DEFENSE, 2, :SPECIAL_DEFENSE, 2]
  end

  def pbMoveFailed?(user, targets)
    if @battle.field.terrain != :Jungle
      if user.hasActiveItem?(:MEMORYIDOL)
        @battle.pbCommonAnimation("UseItem", user)
        @battle.pbDisplay(_INTL("The {1} triggered {2}'s memories!",user.itemName,user.pbThis))
        user.pbConsumeItem
        return false
      else
        @battle.pbDisplay(_INTL("The Memory failed to Trigger"))
        return true
      end
    end
    hpLoss = [user.totalhp / 2, 1].max
    if user.hp <= hpLoss
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if !user.pbCanRaiseStatStage?(:DEFENSE, user, self) &&
       !user.pbCanRaiseStatStage?(:SPECIAL_DEFENSE, user, self)
       @battle.pbDisplay(_INTL("{1}'s stats won't go any higher!", user.pbThis))
       return true
    end
    return false
  end

  def pbEffectGeneral(user)
    hpLoss = [user.totalhp / 2, 1].max
    user.pbReduceHP(hpLoss, false, false)
    showAnim = true
    (@statUp.length / 2).times do |i|
      next if !user.pbCanRaiseStatStage?(@statUp[i * 2], user, self)
      if user.pbRaiseStatStage(@statUp[i * 2], @statUp[(i * 2) + 1], user, showAnim)
        showAnim = false
      end
    end
    user.pbItemHPHealCheck
  end
end

#===============================================================================
# Lowers Target's Speed. May cause the target to flinch. (Aqua Fang)
#===============================================================================
class Battle::Move::LowerSpeedFlinchTarget < Battle::Move
  def flinchingMove?; return true; end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    chance = pbAdditionalEffectChance(user, target, 10)
    return if chance == 0
    if target.pbCanLowerStatStage?(:SPEED, user, self, true) && @battle.pbRandom(100) < chance
      target.pbLowerStatStage(:SPEED,2,user)
    end
    target.pbFlinch(user) if @battle.pbRandom(100) < chance
  end
end

#===============================================================================
# Heals user by an amount depending on the weather. (Aurora Heal)
#===============================================================================
class Battle::Move::HealUserDependingOnWeatherAurora < Battle::Move::HealingMove
  def pbOnStartUse(user, targets)
    if @battle.field.terrain == :Aurora
      case user.effectiveWeather
      when :Hail
        @healAmount = (user.totalhp * 3/4).round
      else
        @healAmount = (user.totalhp * 1/2).round
      end  
    else
      case user.effectiveWeather
      when :Hail
        @healAmount = (user.totalhp * 2 / 3.0).round
      when :None, :StrongWinds
        @healAmount = (user.totalhp / 2.0).round
      else
        @healAmount = (user.totalhp / 4.0).round
      end
    end
  end

  def pbHealAmount(user)
    return @healAmount
  end
end

#===============================================================================
# For 5 rounds, creates an a field of northern lights (Aurora Terrain)
#===============================================================================
class Battle::Move::StartAuroraTerrain < Battle::Move
  def pbMoveFailed?(user, targets)
    if @battle.field.terrain == :Aurora
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    @battle.pbStartTerrain(user, :Aurora)
  end
end

#===============================================================================
# Reduces the user's HP by half of max, Sharply Increases Defense and 
# raises Attack and Speed during Misty Terrain (Avalon)
#===============================================================================
class Battle::Move::HistoricAtkDefSpeed < Battle::Move
  def canSnatch?; return true; end
  def initialize(battle, move)
    super
    @statUp = [:DEFENSE, 2, :SPEED, 1, :ATTACK,1]
  end

  def pbMoveFailed?(user, targets)
    if @battle.field.terrain != :Misty
      if user.hasActiveItem?(:MEMORYIDOL)
        @battle.pbCommonAnimation("UseItem", user)
        @battle.pbDisplay(_INTL("The {1} triggered {2}'s memories!",user.itemName,user.pbThis))
        user.pbConsumeItem
        return false
      else
        @battle.pbDisplay(_INTL("The Memory failed to Trigger"))
        return true
      end
    end
    hpLoss = [user.totalhp / 2, 1].max
    if user.hp <= hpLoss
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if !user.pbCanRaiseStatStage?(:DEFENSE, user, self) &&
       !user.pbCanRaiseStatStage?(:SPEED, user, self) &&
       !user.pbCanRaiseStatStage?(:ATTACK, user, self)
       @battle.pbDisplay(_INTL("{1}'s stats won't go any higher!", user.pbThis))
       return true
    end
    return false
  end

  def pbEffectGeneral(user)
    hpLoss = [user.totalhp / 2, 1].max
    user.pbReduceHP(hpLoss, false, false)
    (@statUp.length / 2).times do |i|
      next if !user.pbCanRaiseStatStage?(@statUp[i * 2], user, self)
      if user.pbRaiseStatStage(@statUp[i * 2], @statUp[(i * 2) + 1], user, showAnim)
        showAnim = false
      end
    end
    user.pbItemHPHealCheck
  end
end

#===============================================================================
# In wild battles, makes target flee. Fails if target is a higher level than the user.
# In trainer battles, target switches out if target's weight is less then double that of the user 
# (Beetle Flip)
#===============================================================================
class Battle::Move::SwitchOutTargetWeight < Battle::Move
  def pbEffectAgainstTarget(user, target)
    if @battle.wildBattle? && target.level <= user.level && @battle.canRun &&
       (target.effects[PBEffects::Substitute] == 0 || ignoresSubstitute?(user))
      @battle.decision = 3
    end
  end

  def pbSwitchOutTargetEffect(user, targets, numHits, switched_battlers)
    return if @battle.wildBattle? || !switched_battlers.empty?
    return if user.fainted? || numHits == 0
    targets.each do |b|
      next if b.fainted? || b.damageState.unaffected || b.damageState.substitute
      next if b.effects[PBEffects::Ingrain]
      next if b.hasActiveAbility?(:SUCTIONCUPS) && !@battle.moldBreaker
      next if b.weight >= (user.weight*2)
      newPkmn = @battle.pbGetReplacementPokemonIndex(b.index, true)   # Random
      next if newPkmn < 0
      if b.hasActiveItem?(:GREENCARD)
        @battle.pbCommonAnimation("UseItem", b)
        @battle.pbDisplay(_INTL("{1}'s {2} prevents them from being switched out!", b.pbThis,"Green Card"))
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
end

#===============================================================================
# Decreases the target's Attack by 1 stage. Heals user by an amount equal to the
# target's Attack stat (after applying stat stages, before this move decreases
# it). (Brain Drain)
#===============================================================================
class Battle::Move::HealUserByTargetSpAtkLowerTargetSpAtk1 < Battle::Move
  def healingMove?;  return true; end
  def canMagicCoat?; return true; end

  def pbFailsAgainstTarget?(user, target, show_message)
    if !@battle.moldBreaker && target.hasActiveAbility?(:CONTRARY) &&
       target.statStageAtMax?(:SPECIAL_ATTACK)
      @battle.pbDisplay(_INTL("But it failed!")) if show_message
      return true
    elsif target.statStageAtMin?(:SPECIAL_ATTACK)
      @battle.pbDisplay(_INTL("But it failed!")) if show_message
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user, target)
    # Calculate target's effective special attack value
    stageMul = [2, 2, 2, 2, 2, 2, 2, 3, 4, 5, 6, 7, 8]
    stageDiv = [8, 7, 6, 5, 4, 3, 2, 2, 2, 2, 2, 2, 2]
    spatk      = target.spatk
    spAtkStage = target.stages[:SPECIAL_ATTACK] + 6
    healAmt = (spatk.to_f * stageMul[spAtkStage] / stageDiv[spAtkStage]).floor
    # Reduce target's Special Attack stat
    if target.pbCanLowerStatStage?(:SPECIAL_ATTACK, user, self)
      target.pbLowerStatStage(:SPECIAL_ATTACK, 1, user)
    end
    # Heal user
    user.pbRecoverHPFromDrain(healAmt, target, true, false, true)
  end
end

#===============================================================================
# (Breakdown)
#===============================================================================
class Battle::Move::Hp1DropSpAtk < Battle::Move::FixedDamageMove
  def pbAccuracyCheck(user, target)
    acc = 30
    return @battle.pbRandom(100) < acc
  end

  def pbFixedDamage(user, target)
     dmg = ((target.totalhp * 0.9) - (target.totalhp - target.hp)).round
     dmg = 1 if dmg < 1
    return dmg
  end

  def pbEffectAfterAllHits(user, target)
    return if !target.pbCanLowerStatStage?(:SPECIAL_ATTACK, user, self, true)
    target.stages[:SPECIAL_ATTACK] =-6
    target.statsLoweredThisRound = true
    @battle.pbCommonAnimation("StatDown", target)
    @battle.pbDisplay(_INTL("{1}'s attack minimized {2}'s Special Attack!", user.pbThis,target.pbThis))
    user.pbItemHPHealCheck
  end
end

#===============================================================================
# Power increases the heavier the target is. Damage is doubled during Gravity 
# (Black Hole)
#===============================================================================
class Battle::Move::PowerHigherWithTargetWeight < Battle::Move
  def pbBaseDamage(baseDmg, user, target)
    ret = 20
    weight = target.pbWeight
    ret *=6 if weight >= 2000 
    ret *=5 if weight < 2000 && weight > 1000
    ret *=4 if weight <= 1000 && weight > 500
    ret *=3 if weight <= 500 && weight > 250
    ret *=2 if weight <= 250 && weight > 100
    ret *=1.5 if weight <= 100 && weight > 20

    ret *=2 if @battle.field.effects[PBEffects::Gravity] > 0
    return ret
  end
end

#===============================================================================
# Entry hazard. Burns Pokémon that enters the battlefield. (Burning Ground)
#===============================================================================
class Battle::Move::AddBurningGroundToFoeSide < Battle::Move
  def canMagicCoat?; return true; end

  def pbMoveFailed?(user, targets)
    if user.pbOpposingSide.effects[PBEffects::BurningGround]
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    if user.pbOpposingSide.effects[PBEffects::StickyWeb] 
       user.pbOpposingSide.effects[PBEffects::StickyWeb] = false
      @battle.pbDisplay(_INTL("The Sticky Web surrounding {1} burned up!",
      user.pbOpposingTeam(true)))
    end
    user.pbOpposingSide.effects[PBEffects::BurningGround] = true
    @battle.pbDisplay(_INTL("The ground underneath {1}'s feet became superheated!",user.pbOpposingTeam(true)))
  end
end

#===============================================================================
# Increases the user's Sp.Atk and Speed by 1 stage each. (Celestial Dance)
#===============================================================================
class Battle::Move::RaiseUserSpAtkSpeed1 < Battle::Move::MultiStatUpMove
  def initialize(battle, move)
    super
    @statUp = [:SPATK, 1, :SPEED, 1]
  end
end

#===============================================================================
# (Combat Trial)
#===============================================================================
class Battle::Move::CompareUserPartyAtkwithTargetPartyDef < Battle::Move
  def pbCritialOverride(user, target); return 1 if @win; end
  def ignoresReflect?; return true if @win; end 
  
  def initialize(battle, move) 
    @win=false; @lose=false 
  end
  
  def pbBaseDamage(baseDmg, user, target)
    return baseDmg / 2 if @lose
  end

  def pbOnStartUse(user, targets)
    atk = 0; dfn = 0
    @battle.pbDisplay(_INTL("{1} is judging {2}'s party!",
    user.pbThis,target.pbThis))
    party = @battle.pbParty(user.index)
    t_party = @battle.pbParty(target.index)
    for pokemon in party
      atk += pokemon.atk
    end
    for pokemon in t_party
      dfn += pokemon.def
    end
    if atk > dfn
      @win = true
      @battle.pbDisplay(_INTL("{1}'s combat abilities are too great to be fought",
      user.pbThis))
    elsif spa < spd
      @lose=true
      @battle.pbDisplay(_INTL("{2} managed to surpass {1}'s combat abilities!",
      user.pbThis,target.pbThis))
    else
      @battle.pbDisplay(_INTL("Both teams are equal in combat!"))
    end
  end

  def pbEffectGeneral(user)
    return if !@win
    if user.pbOpposingSide.effects[PBEffects::LightScreen] > 0
      user.pbOpposingSide.effects[PBEffects::LightScreen] = 0
      @battle.pbDisplay(_INTL("{1}'s Light Screen wore off!", user.pbOpposingTeam))
    end
    if user.pbOpposingSide.effects[PBEffects::Reflect] > 0
      user.pbOpposingSide.effects[PBEffects::Reflect] = 0
      @battle.pbDisplay(_INTL("{1}'s Reflect wore off!", user.pbOpposingTeam))
    end
    if user.pbOpposingSide.effects[PBEffects::AuroraVeil] > 0
      user.pbOpposingSide.effects[PBEffects::AuroraVeil] = 0
      @battle.pbDisplay(_INTL("{1}'s Aurora Veil wore off!", user.pbOpposingTeam))
    end
    if user.pbOpposingSide.effects[PBEffects::BastionShell] > 0
      user.pbOpposingSide.effects[PBEffects::BastionShell] = 0
      @battle.pbDisplay(_INTL("{1}'s Bastion Shell broke!", user.pbOpposingTeam))
    end
  end

  def pbShowAnimation(id, user, targets, hitNum = 0, showAnimation = true)
    return if !@win
    if user.pbOpposingSide.effects[PBEffects::LightScreen] > 0 ||
       user.pbOpposingSide.effects[PBEffects::Reflect] > 0 ||
       user.pbOpposingSide.effects[PBEffects::AuroraVeil] > 0 ||
       user.pbOpposingSide.effects[PBEffects::BastionShell] 
      hitNum = 1   # Wall-breaking anim
    end
    super
  end

  def pbEffectAfterAllHits(user, target)
    return if !@lose
    return if !user.pbCanLowerStatStage?(:ATTACK, user, self, true)
    user.pbLowerStatStage(:ATTACK, 1, user)
  end
end

#===============================================================================
# (Cruel Ruin)
#===============================================================================
class Battle::Move::AttackAndSkipNextTurnRecoil < Battle::Move::AttackAndSkipNextTurn
  def pbBaseDamage(baseDmg, user, target)
    baseDmg += (target.hp * 0.4).round
    baseDmg = (baseDmg * 0.7).round if user.hasActiveItem?(:SHIMMERMANE)
    baseDmg = [baseDmg , 200].min
    return baseDmg
  end

  def pbRecoilDamage(user, target)
    return if user.fainted? || target.damageState.unaffected
    return (user.hp / 2.0).round
  end

  def pbEffectAfterAllHits(user, target)
    return if target.damageState.unaffected
    return if !user.takesIndirectDamage?
    return if user.hasActiveAbility?(:ROCKHEAD)
    amt = pbRecoilDamage(user, target)
    amt = 1 if amt < 1
    if user.hasActiveItem?(:SHIMMERMANE) && user.hp < user.totalhp
      @battle.pbCommonAnimation("UseItem", user)
      @battle.pbDisplay(_INTL("{1}'s {2} turned the recoil damage into healing!", 
                        user.pbThis, user.itemName))
      user.pbRecoverHP(amt, false)
      user.pbConsumeItem 
    else
      user.pbReduceHP(amt, false)
      @battle.pbDisplay(_INTL("{1} is damaged by recoil!", user.pbThis))
      user.pbItemHPHealCheck
    end
  end
end

#===============================================================================
# Paralyzes the target. Effectiveness against Psychic-type is 2x. (Darkbolt)
#===============================================================================
class Battle::Move::ParalyzeTargetSuperEffectiveAgainstPsychic < Battle::Move::ParalyzeTarget
  def pbCalcTypeModSingle(moveType, defType, user, target)
    return Effectiveness::SUPER_EFFECTIVE_ONE if defType == :PSYCHIC
    return super
  end
end

#===============================================================================
# For 5 rounds, creates a vast desert
# (Desert Terrain)
#===============================================================================
class Battle::Move::StartDesertTerrain < Battle::Move
  def pbMoveFailed?(user, targets)
    if @battle.field.terrain == :Desert
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    @battle.pbStartTerrain(user, :Desert)
  end
end



#===============================================================================
# Gives target the Dragon type. (Dragon Soul)
#===============================================================================
class Battle::Move::AddDragonTypeToTarget < Battle::Move
  def canMagicCoat?; return true; end

  def pbFailsAgainstTarget?(user, target, show_message)
    if !GameData::Type.exists?(:DRAGON) || target.pbHasType?(:DRAGON) || !target.canChangeType?
      @battle.pbDisplay(_INTL("But it failed!")) if show_message
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user, target)
    target.effects[PBEffects::Type3] = :DRAGON
    typeName = GameData::Type.get(:DRAGON).name
    @battle.pbDisplay(_INTL("{1} attained the {2} type!", target.pbThis, typeName))
  end
end

#===============================================================================
# Recovers 50% of the user's HP (Druidic Circle)
#===============================================================================
class Battle::Move::HitRecoverHalfofMaxHP < Battle::Move
  def pbEffectAfterAllHits(user, target)
    hpGain = (user.totalhp * 0.5).round
    user.pbRecoverHP(hpGain)
  end
end

#===============================================================================
# (Dust Storm)
#===============================================================================
class Battle::Move::SuperEffectiveFlyinginDesert < Battle::Move
  def hitsFlyingTargets?; return true; end
  
  def pbCalcTypeModSingle(moveType, defType, user, target)
    if defType == :FLYING && @battle.field.terrain == :Desert
      return Effectiveness::SUPER_EFFECTIVE_ONE
      return super
    end
  end
end

#===============================================================================
# Reduces the user's HP by half of max, Sharply Increases Speed and 
# raises Attack and Special Attack during Grassy Terrain (Elysium)
#===============================================================================
class Battle::Move::HistoricSpeedAtkSpA < Battle::Move
  def canSnatch?; return true; end
  def initialize(battle, move)
    super
    @statUp = [:SPEED, 2, :ATTACK, 1, :SPECIAL_ATTACK,1]
  end

  def pbMoveFailed?(user, targets)
    if @battle.field.terrain != :Grassy
      if user.hasActiveItem?(:MEMORYIDOL)
        @battle.pbCommonAnimation("UseItem", user)
        @battle.pbDisplay(_INTL("The {1} allowed {2}'s memories to trigger!",user.itemName,user.pbThis))
        user.pbConsumeItem
        return false
      else
        @battle.pbDisplay(_INTL("The Memory failed to Trigger"))
        return true
      end
    end
    hpLoss = [user.totalhp / 2, 1].max
    if user.hp <= hpLoss
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if !user.pbCanRaiseStatStage?(:SPEED, user, self) &&
       !user.pbCanRaiseStatStage?(:ATTACK, user, self) &&
       !user.pbCanRaiseStatStage?(:SPECIAL_ATTACK, user, self)
       @battle.pbDisplay(_INTL("{1}'s stats won't go any higher!", user.pbThis))
       return true
    end
    return false
  end

  def pbEffectGeneral(user)
    hpLoss = [user.totalhp / 2, 1].max
    user.pbReduceHP(hpLoss, false, false)
    (@statUp.length / 2).times do |i|
      next if !user.pbCanRaiseStatStage?(@statUp[i * 2], user, self)
      if user.pbRaiseStatStage(@statUp[i * 2], @statUp[(i * 2) + 1], user, showAnim)
        showAnim = false
      end
    end
    user.pbItemHPHealCheck
  end
end

#===============================================================================
# Target's ability becomes Energy Burst. (Energy Conversion)
#===============================================================================
class Battle::Move::SetTargetAbilityToEnergyBurst < Battle::Move
  def canMagicCoat?; return true; end

  def pbMoveFailed?(user, targets)
    if !GameData::Ability.exists?(:ENERGYBURST)
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbFailsAgainstTarget?(user, target, show_message)
    if target.unstoppableAbility? || target.unstoppableAbilityEchoes? || 
      [:TRUANT, :UNICORN].include?(target.ability_id)
      @battle.pbDisplay(_INTL("But it failed!")) if show_message
      return true
    end
    if user.hp <= (traget.totalhp / 4)
      @battle.pbDisplay(_INTL("{1} does not have enough HP to change their ability",
      target.pbThis)) if show_message
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user, target)
    user.pbReduceHP(target.totalhp / 4).round
    @battle.pbShowAbilitySplash(target, true, false)
    oldAbil = target.ability
    target.ability = :ENERGYBURST
    @battle.pbReplaceAbilitySplash(target)
    @battle.pbDisplay(_INTL("{1} converted some of it's HP into energy and acquired the ability {2}!", 
    target.pbThis, target.abilityName))
    @battle.pbHideAbilitySplash(target)
    target.pbOnLosingAbility(oldAbil)
    target.pbTriggerAbilityOnGainingIt
  end
end

#===============================================================================
# Target drops its item. It regains the item at the end of the battle. 
# Traps target in an infestaion (Famine)
#===============================================================================
class Battle::Move::RemoveTargetItemInfestation < Battle::Move
  def pbEffectAfterAllHits(user, target)
    return if user.wild?   # Wild Pokémon can't knock off
    return if user.fainted?
    return if target.damageState.unaffected || target.damageState.substitute
    return if !target.item || target.unlosableItem?(target.item)
    return if target.hasActiveAbility?(:STICKYHOLD) && !@battle.moldBreaker
    itemName = target.itemName
    target.pbRemoveItem(false)
    @battle.pbDisplay(_INTL("{1} dropped its {2}!", target.pbThis, itemName))
  end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    return if target.effects[PBEffects::Trapping] > 0
    # Set trapping effect duration and info
    if user.hasActiveItem?(:GRIPCLAW)
      target.effects[PBEffects::Trapping] = (Settings::MECHANICS_GENERATION >= 5) ? 8 : 6
    else
      target.effects[PBEffects::Trapping] = 5 + @battle.pbRandom(2)
    end
    target.effects[PBEffects::TrappingMove] = :INFESTATION
    target.effects[PBEffects::TrappingUser] = user.index
    # Message
    msg = _INTL("{1} has been afflicted with an infestation by {2}!", target.pbThis, user.pbThis(true))
    @battle.pbDisplay(msg)
  end
end

#===============================================================================
# For 5 rounds, creates an a field of meditative energy 
# (Focus Terrain)
#===============================================================================
class Battle::Move::StartFocusTerrain < Battle::Move
  def pbMoveFailed?(user, targets)
    if @battle.field.terrain == :Focus
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    @battle.pbStartTerrain(user, :Focus)
  end
end

#===============================================================================
# All current battlers will be frozen after 3 turns. (Frost Elegy)
#===============================================================================
class Battle::Move::StartFrostCountsForAllBattlers < Battle::Move
  def pbMoveFailed?(user, targets)
    failed = true
    targets.each do |b|
      next if b.effects[PBEffects::FrostElegy] > 0   # Heard it before
      failed = false
      break
    end
    if failed
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user, target)
    target.effects[PBEffects::FrostElegy]     = 4
    target.effects[PBEffects::FrostElegyUser] = user.index
  end

  def pbShowAnimation(id, user, targets, hitNum = 0, showAnimation = true)
    super
    @battle.pbDisplay(_INTL("All Pokémon that hear the song will be frozen in three turns!"))
  end
end

#===============================================================================
# User gains half the HP it inflicts as damage even in Desert Terrain.
# (Gaia Drain)
#===============================================================================
class Battle::Move::HealUserByHalfOfDamageDoneDesert < Battle::Move
  def healingMove?; return Settings::MECHANICS_GENERATION >= 6; end

  def pbEffectAgainstTarget(user, target)
    return if target.damageState.hpLost <= 0
    hpGain = (target.damageState.hpLost / 2.0).round
    user.pbRecoverHPFromDrain(hpGain, target, true)
  end
end

#===============================================================================
# Attacks first turn, skips second turn. (if successful). 
# May sharply lower target's Special Defense (Gaia Force)
#===============================================================================
class Battle::Move::HyperBeamSpDef2 < Battle::Move
end


#===============================================================================
# Two turn attack. Skips first turn, Summons a 3 turn Sea of fire 
# in the second turn. (Gehenna)
#===============================================================================
class Battle::Move::TwoTurnAttackSeaOfFire < Battle::Move::TwoTurnMove
  def pbMoveFailed?(user, targets)
    return false if user.effects[PBEffects::TwoTurnAttack]   # Charging turn
    if user.pbOpposingSide.effect[PBEffects::SeaOfFire] > 0
      @battle.pbDisplay(_INTL("There is already a sea of fire covering {1}'s field", target.pbThis))
      return true
    end
    return false
  end

  def pbChargingTurnMessage(user, targets)
    @battle.pbDisplay(_INTL("{1} is absorbing power!", user.pbThis))
  end

  def pbEffectGeneral(user)
    return if !@damagingTurn
    user.pbOpposingSide.effects[PBEffects::SeaOfFire] = 4
    msg = _INTL("A sea of fire enveloped {1}'s field!", user.pbOpposingTeam(true))
    animName = (user.opposes?) ? "SeaOfFire" : "SeaOfFireOpp"
  end
end

#===============================================================================
# Inflicts a random status condition on the target (Glitterspore)
# May inflict Poison,Paralysis,Burn or Confusion
#===============================================================================
class Battle::Move::RandomStatusPowder < Battle::Move
  def powderMove?;  return true; end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    r = battle.pbRandom(4)
    return if r == 0 && target.poisoned?
    return if r == 1 && target.paralyzed?
    return if r == 2 && target.burned?
    return if r == 3 && target.confused?
    case r
    when 0
      if target.pbCanPoison?(target)
        target.pbPoison(target)
      end
    when 1
      if target.pbCanParalyze?(target)
        target.pbParalyze(target)
      end
    when 2
      if target.pbCanBurn?(target)
        target.pbBurn(target)
      end
    when 3
      if target.pbCanConfuse?
        target.pbConfuse
      end
    end
  end
end

#===============================================================================
# User is protected against damaging moves this round. Decreases the Attack of
# the user of a stopped special move by 2 stages. (Heat Flash)
#===============================================================================
class Battle::Move::ProtectUserFromDamagingMovesHeatFlash < Battle::Move::ProtectMove
  def initialize(battle, move)
    super
    @effect = PBEffects::HeatFlash
  end
end

#===============================================================================
# Interrupts a foe switching out or using U-turn/Volt Switch/Parting Shot. Power
# is doubled in that case. (Hollow Passage)
# (Handled in Battle's pbAttackPhase): Makes this attack happen before switching.
# The switched in Pokémon will be Poisoned and confused.
# If the switched in Pokémon is Asleep it will give them a nightmare
#===============================================================================
class Battle::Move::PursueSwitchingFoePoisonConfuse < Battle::Move::PursueSwitchingFoe
  def pbEffectAgainstTarget(user, target)
    return if !@battle.switching
    target.pbOwnSide.effect[PBEffects::HollowPassage] = true
  end
end

#===============================================================================
# Entry hazard. Lays Icicle Rain around the opposing field (Icicle Rain)
#===============================================================================
class Battle::Move::AddIcicleRainToFoeSide < Battle::Move
  def canMagicCoat?; return true; end

  def pbMoveFailed?(user, targets)
    if user.pbOpposingSide.effects[PBEffects::IcicleRain]
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    if user.pbOpposingSide.effects[PBEffects::StealthRock] 
       user.pbOpposingSide.effects[PBEffects::StealthRock] = false
      @battle.pbDisplay(_INTL("The pointed stones surrounding {1} disappeared!",
      user.pbOpposingTeam(true)))
    end
    user.pbOpposingSide.effects[PBEffects::IcicleRain] = true
    @battle.pbDisplay(_INTL("Sharp Icicles float in the air around {1}!",user.pbOpposingTeam(true)))
  end
end

#===============================================================================
# Reduces the user's HP by half of max, Sharply Increases Special Defense and 
# raises Defense and Special Defense during Spirit Terrain (Irkalla)
#===============================================================================
class Battle::Move::HistoricAttackDefenseAccuracy < Battle::Move
  def canSnatch?; return true; end
  
  def initialize(battle, move)
    @statUp = [:ATTACK, 2, :DEFENSE, 1, :ACCURACY , 1]
  end

  def pbMoveFailed?(user, targets)
    if @battle.field.terrain != :Spirit
      if user.hasActiveItem?(:MEMORYIDOL)
        @battle.pbCommonAnimation("UseItem", user)
        @battle.pbDisplay(_INTL("The {1} triggered {2}'s memories!",user.itemName,user.pbThis))
        user.pbConsumeItem
        return false
      else
        @battle.pbDisplay(_INTL("The Memory failed to Trigger"))
        return true
      end
    end
    hpLoss = [user.totalhp / 2, 1].max
    if user.hp <= hpLoss
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if !user.pbCanRaiseStatStage?(:ATTACK, user, self) &&
       !user.pbCanRaiseStatStage?(:DEFENSE, user, self) &&
       !user.pbCanRaiseStatStage?(:ACCURACY, user, self) 
       @battle.pbDisplay(_INTL("{1}'s stats won't go any higher!", user.pbThis))
       return true
    end
    return false
  end

  def pbEffectGeneral(user)
    hpLoss = [user.totalhp / 2, 1].max
    user.pbReduceHP(hpLoss, false, false)
    showAnim = true
    (@statUp.length / 2).times do |i|
      next if !user.pbCanRaiseStatStage?(@statUp[i * 2], user, self)
      if user.pbRaiseStatStage(@statUp[i * 2], @statUp[(i * 2) + 1], user, showAnim)
        showAnim = false
      end
    end
    user.pbItemHPHealCheck
  end
end

#===============================================================================
# (Judge & Jury)
#===============================================================================
class Battle::Move::CompareUserPartySpAtkwithTargetPartySpDef < Battle::Move
  def pbCritialOverride(user, target); return 1 if @win; end 
  def initialize(battle, move); @win=false; @lose=false; end
    
  def pbBaseDamage(baseDmg, user, target)
    return baseDmg / 2 if @lose
  end

  def pbOnStartUse(user, targets)
    spa=0; spd=0
    @battle.pbDisplay(_INTL("{1} is judging {2}'s party!",
    user.pbThis,target.pbThis))
    party = @battle.pbParty(user.index)
    t_party = @battle.pbParty(target.index)
    for pokemon in party
      spa+=pokemon.spatk
    end
    for pokemon in t_party
      spd+=pokemon.spdef
    end
    if spa > spd
      @win = true
      @battle.pbDisplay(_INTL("{1}'s arguments are too persuasive to be argued agianst!",
      user.pbThis))
    elsif spa < spd
      @lose = true
      @battle.pbDisplay(_INTL("{2} managed to argue their way out of {1}'s verdict!",
      user.pbThis,target.pbThis))
    else
      @battle.pbDisplay(_INTL("No veridct was cast!"))
    end
  end

  def pbEffectAgainstTarget(user, target)
    return if target.damageState.hpLost <= 0
    return if !@win
    hpGain = (target.damageState.hpLost / 2.0).round
    user.pbRecoverHPFromDrain(hpGain, target)
  end

  def pbEffectAfterAllHits(user, target)
    return if !@lose
    return if !user.pbCanLowerStatStage?(:SPECIAL_ATTACK, user, self, true)
    user.pbLowerStatStage(:SPECIAL_ATTACK, 1, user)
  end
end

#===============================================================================
# Reduces the user's HP by half of max, Sharply Increases Accuracy and 
# raises Speed and Special Attack during Lunar Terrain (Kamui)
#===============================================================================
class Battle::Move::HistoricAccuracySpeedSpatk < Battle::Move
  def canSnatch?; return true; end
  
  def initialize(battle, move)
    @statUp = [:ACCURACY, 2, :SPEED, 1, :SPECIAL_ATTACK , 1]
  end

  def pbMoveFailed?(user, targets)
    if @battle.field.terrain != :Lunar
      if user.hasActiveItem?(:MEMORYIDOL)
        @battle.pbCommonAnimation("UseItem", user)
        @battle.pbDisplay(_INTL("The {1} triggered {2}'s memories!",user.itemName,user.pbThis))
        user.pbConsumeItem
        return false
      else
        @battle.pbDisplay(_INTL("The Memory failed to Trigger"))
        return true
      end
    end
    hpLoss = [user.totalhp / 2, 1].max
    if user.hp <= hpLoss
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if !user.pbCanRaiseStatStage?(:ACCURACY, user, self) &&
       !user.pbCanRaiseStatStage?(:SPEED, user, self) &&
       !user.pbCanRaiseStatStage?(:SPECIAL_ATTACK, user, self) 
       @battle.pbDisplay(_INTL("{1}'s stats won't go any higher!", user.pbThis))
       return true
    end
    return false
  end

  def pbEffectGeneral(user)
    hpLoss = [user.totalhp / 2, 1].max
    user.pbReduceHP(hpLoss, false, false)
    showAnim = true
    (@statUp.length / 2).times do |i|
      next if !user.pbCanRaiseStatStage?(@statUp[i * 2], user, self)
      if user.pbRaiseStatStage(@statUp[i * 2], @statUp[(i * 2) + 1], user, showAnim)
        showAnim = false
      end
    end
    user.pbItemHPHealCheck
  end
end

#===============================================================================
# Reduces the HP of all opponents by 3/4 of their current HP (Landslide)
#===============================================================================
class Battle::Move::FixedDamageHPThreeFourthsAll < Battle::Move::FixedDamageHalfTargetHP
  def pbFixedDamage(user, target)
    return (target.hp * 3/4).round 
  end
end

#===============================================================================
# Increases the user's Sp.Defense and Defense by 1 stage each. (Lotus Dance)
# Adds extra effect for Magikarp (> Lv 20)
#===============================================================================
class Battle::Move::RaiseUserDefSpDef1 < Battle::Move::MultiStatUpMove
  def initialize(battle, move)
    super
    @statUp = [:SPDEF, 1, :DEFENSE, 1]
  end
end

#===============================================================================
# For 5 rounds, creates a vast moonscape. (Lunar Terrain) 
# Increases the power of the DARK and FAIRY attacks of grounded Pokémon by 30%
# + 1 Priority to Gravity, Gravity will last for 8 turns instead of 5
#===============================================================================
class Battle::Move::StartLunarTerrain < Battle::Move
  def pbMoveFailed?(user, targets)
    if @battle.field.terrain == :Lunar
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    @battle.pbStartTerrain(user, :Lunar)
  end
end

#===============================================================================
# Reduces the user's HP by half of max, Sharply Increases Defense and 
# raises Attack and Critical hit rate during Focus Terrain (Mahakali)
#===============================================================================
class Battle::Move::HistoricSpDefDefCritical < Battle::Move
  def canSnatch?; return true; end
  
  def initialize(battle, move)
    @statUp = [:DEFENSE, 2, :ATTACK, 1]
  end

  def pbMoveFailed?(user, targets)
    if @battle.field.terrain != :Focus
      if user.hasActiveItem?(:MEMORYIDOL)
        @battle.pbCommonAnimation("UseItem", user)
        @battle.pbDisplay(_INTL("The {1} triggered {2}'s memories!",user.itemName,user.pbThis))
        user.pbConsumeItem
        return false
      else
        @battle.pbDisplay(_INTL("The Memory failed to Trigger"))
        return true
      end
    end
    hpLoss = [user.totalhp / 2, 1].max
    if user.hp <= hpLoss
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if !user.pbCanRaiseStatStage?(:DEFENSE, user, self) &&
       !user.pbCanRaiseStatStage?(:ATTACK, user, self) &&
       user.effects[PBEffects::FocusEnergy] >= 2
       @battle.pbDisplay(_INTL("{1}'s stats won't go any higher!", user.pbThis))
       return true
    end
    return false
  end

  def pbEffectGeneral(user)
    hpLoss = [user.totalhp / 2, 1].max
    user.pbReduceHP(hpLoss, false, false)
    showAnim = true
    (@statUp.length / 2).times do |i|
      next if !user.pbCanRaiseStatStage?(@statUp[i * 2], user, self)
      if user.pbRaiseStatStage(@statUp[i * 2], @statUp[(i * 2) + 1], user, showAnim)
        showAnim = false
      end
    end
    @battle.pbCommonAnimation("StatUp", user)
    user.effects[PBEffects::FocusEnergy] += 1
    @battle.pbDisplay(_INTL("{1} critical hit rate increased!", user.pbThis))
    user.pbItemHPHealCheck
  end
end

#===============================================================================
# (Magnetic Stream)
#===============================================================================
class Battle::Move::SuperEffectiveGroundinElectric < Battle::Move  
  def hitsDiggingTargets?; return true; end

  def pbCalcTypeModSingle(moveType, defType, user, target)
    if defType == :GROUND && @battle.field.terrain == :Electric
      return Effectiveness::SUPER_EFFECTIVE_ONE
    end
    return super
  end
end

#===============================================================================
# Two turn attack. Skips first turn, Summons a 3 turn Swamp the next turn 
# (Marshland)
#===============================================================================
class Battle::Move::TwoTurnAttackSwamp < Battle::Move::TwoTurnMove
  def pbMoveFailed?(user, targets)
    return false if user.effects[PBEffects::TwoTurnAttack]   # Charging turn
    if user.pbOpposingSide.effect[PBEffects::Swamp] > 0
      @battle.pbDisplay(_INTL("There is already a swamp covering {1}'s field", target.pbThis))
      return true
    end
    return false
  end

  def pbChargingTurnMessage(user, targets)
    @battle.pbDisplay(_INTL("{1} is absorbing power!", user.pbThis))
  end

  def pbEffectGeneral(user)
    return if !@damagingTurn
    user.pbOpposingSide.effects[PBEffects::Swamp] = 4
    msg = _INTL("A swamp enveloped {1}'s field!", user.pbOpposingTeam(true))
    animName = (user.opposes?) ? "Swamp" : "SwampOpp"
  end
end

#===============================================================================
# Raises user's Attack. May cause the target to flinch. (Metal Fangs)
#===============================================================================
class Battle::Move::RaisesAttackFlinchTarget < Battle::Move
  def flinchingMove?; return true; end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    chance = pbAdditionalEffectChance(user, target, 10)
    return if chance == 0
    if user.pbCanRaiseStatStage?(:ATTACK, user, self, true) && @battle.pbRandom(100) < chance
      user.pbRaiseStatStage(:ATTACK,1,user)
    end
    target.pbFlinch(user) if @battle.pbRandom(100) < chance
  end
end


#===============================================================================
# Attacks 3 rounds in the future. Burns Target.
# Type effectiveness is multiplied by the Fire-type's effectiveness against the target.
# Creates a 2-turn Sea of fire on the target's field and removes Entry Hazards and Terrains.
# (Meteor Impact)
#===============================================================================
class Battle::Move::AttackThreeTurnsLaterBurnRemoveHazardandTerrain < Battle::Move
  def targetsPosition?; return true; end

  def pbDamagingMove?   # Stops damage being dealt in the setting-up turn
    return false if !@battle.futureSight
    return super
  end

  def pbAccuracyCheck(user, target)
    return true if !@battle.futureSight
    return super
  end

  def pbDisplayUseMessage(user)
    super if !@battle.futureSight
  end

  def pbFailsAgainstTarget?(user, target, show_message)
    if !@battle.futureSight &&
       @battle.positions[target.index].effects[PBEffects::FutureSightCounter] > 0
      @battle.pbDisplay(_INTL("But it failed!")) if show_message
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user, target)
    return if @battle.futureSight   # Attack is hitting
    effects = @battle.positions[target.index].effects
    effects[PBEffects::FutureSightCounter]        = 4
    effects[PBEffects::FutureSightMove]           = @id
    effects[PBEffects::FutureSightUserIndex]      = user.index
    effects[PBEffects::FutureSightUserPartyIndex] = user.pokemonIndex
    @battle.pbDisplay(_INTL("{1} foresaw a Meteor Impact", user.pbThis))
    if user.hasActiveAbility?(:PREMONITION) 
      @battle.pbShowAbilitySplash(self)
      if Battle::Scene::USE_ABILITY_SPLASH
        @battle.pbDisplay(_INTL("{1} reduced the time to the meteor strikes!", upbThis))
      else
        @battle.pbDisplay(_INTL("{1}'s {2} reduced the time to the meteor strikes!.", 
        user.pbThis, user.abilityName))
      end
      effects[PBEffects::FutureSightCounter] -= 1
      @battle.pbHideAbilitySplash(self)
    end
  end

  def pbShowAnimation(id, user, targets, hitNum = 0, showAnimation = true)
    hitNum = 1 if !@battle.futureSight   # Charging anim
    super
  end

  def pbCalcTypeModSingle(moveType, defType, user, target)
    return if !@battle.futureSight
    ret = super
    if GameData::Type.exists?(:FIRE)
      dragonEff = Effectiveness.calculate_one(:FIRE, defType)
      ret *= dragonEff.to_f / Effectiveness::NORMAL_EFFECTIVE_ONE
    end
    return ret
  end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    return if !@battle.futureSight
    target.pbBurn(user) if target.pbCanBurn?(user, false, self)
  end

  def pbEffectAfterAllHits(user, target)
    if @battle.field.terrain != :None
        @battle.pbDisplay(_INTL("The terrain was removed due to the impact"))
        @battle.field.terrain = :None
    end
    if user.pbOwnSide.effects[PBEffects::StealthRock]
      user.pbOwnSide.effects[PBEffects::StealthRock] = false
      @battle.pbDisplay(_INTL("{1} melted the stealth rocks!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::IcicleRain]
      user.pbOwnSide.effects[PBEffects::IcicleRain] = false
      @battle.pbDisplay(_INTL("{1} melted the ring of icicles!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::Spikes] > 0
      user.pbOwnSide.effects[PBEffects::Spikes] = 0
      @battle.pbDisplay(_INTL("{1} melted the spikes!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::ToxicSpikes] > 0
      user.pbOwnSide.effects[PBEffects::ToxicSpikes] = 0
      @battle.pbDisplay(_INTL("{1} melted the poison spikes!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::StickyWeb]
      user.pbOwnSide.effects[PBEffects::StickyWeb] = false
      @battle.pbDisplay(_INTL("{1} blew away sticky webs!", user.pbThis))
    end
    if target.pbOwnSide.effects[PBEffects::StealthRock]
      target.pbOwnSide.effects[PBEffects::StealthRock] = false
      @battle.pbDisplay(_INTL("{1} melted the stealth rocks!", user.pbThis))
    end
    if target.pbOwnSide.effects[PBEffects::IcicleRain]
      target.pbOwnSide.effects[PBEffects::IcicleRain] = false
      @battle.pbDisplay(_INTL("{1} melted the ring of icicles!", user.pbThis))
    end
    if target.pbOwnSide.effects[PBEffects::Spikes] > 0
      target.pbOwnSide.effects[PBEffects::Spikes] = 0
      @battle.pbDisplay(_INTL("{1} melted the spikes!", user.pbThis))
    end
    if target.pbOwnSide.effects[PBEffects::ToxicSpikes] > 0
      target.pbOwnSide.effects[PBEffects::ToxicSpikes] = 0
      @battle.pbDisplay(_INTL("{1} melted the poison spikes!", user.pbThis))
    end
    if target.pbOwnSide.effects[PBEffects::StickyWeb]
      target.pbOwnSide.effects[PBEffects::StickyWeb] = false
      @battle.pbDisplay(_INTL("{1} blew away sticky webs!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::SeaOfFire] <= 0
      user.pbOwnSide.effects[PBEffects::SeaOfFire] = 3
      @battle.pbDisplay(_INTL("A sea of fire enveloped {1}!", user.pbThis(true)))
      animName = (user.opposes?) ? "SeaOfFire" : "SeaOfFireOpp"
    end
    if target.pbOwnSide.effects[PBEffects::SeaOfFire] <= 0
      target.pbOwnSide.effects[PBEffects::SeaOfFire] = 3
      @battle.pbDisplay(_INTL("A sea of fire enveloped {1}!", target.pbThis(true)))
      animName = (user.opposes?) ? "SeaOfFire" : "SeaOfFireOpp"
    end 
  end
end

#===============================================================================
# Swaps the user's Attack and Defense stats. (Mind Trick)
#===============================================================================
class Battle::Move::UserSwapBaseSpAtkSpDef < Battle::Move
  def canSnatch?; return true; end

  def pbEffectGeneral(user)
    user.spatk, user.spdef = user.spdef, user.spatk
    user.effects[PBEffects::MindTrick] = !user.effects[PBEffects::MindTrick]
    @battle.pbDisplay(_INTL("{1} switched its Special Attack and Special Defense!", user.pbThis))
  end
end

#===============================================================================
# For 3 rounds, user's and ally's stat stages cannot be lowered by foes. 
# (Mist Breath)
#===============================================================================
class Battle::Move::StartUserSideImmunityToStatStageLoweringDamage < Battle::Move
  def pbAdditionalEffect(user)
    return if target.damageState.substitute
    return if user.pbOwnSide.effects[PBEffects::Mist] > 0
    user.pbOwnSide.effects[PBEffects::Mist] = 3
    @battle.pbDisplay(_INTL("{1}'s field became shrouded in mist!", user.pbTeam))
  end
end

#===============================================================================
# For 5 rounds, creates an a field of mystic energy
# (Mystic Terrain)
#===============================================================================
class Battle::Move::StartMysticTerrain < Battle::Move
  def pbMoveFailed?(user, targets)
    if @battle.field.terrain == :Mystic
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    @battle.pbStartTerrain(user, :Mystic)
  end
end

#===============================================================================
# Reduces the user's HP by half of max, Sharply Increases Sp.Def and 
# raises Special Attack and Critical hit rate during Psychic Terrain (Nirvana)
#===============================================================================
class Battle::Move::HistoricSpDefDefCritical < Battle::Move
  def canSnatch?; return true; end
  
  def initialize(battle, move)
    @statUp = [:SPECIAL_DEFENSE, 2, :DEFENSE, 1]
  end

  def pbMoveFailed?(user, targets)
    if @battle.field.terrain != :Psychic
      if user.hasActiveItem?(:MEMORYIDOL)
        @battle.pbCommonAnimation("UseItem", user)
        @battle.pbDisplay(_INTL("The {1} triggered {2}'s memories!",user.itemName,user.pbThis))
        user.pbConsumeItem
        return false
      else
        @battle.pbDisplay(_INTL("The Memory failed to Trigger"))
        return true
      end
    end
    hpLoss = [user.totalhp / 2, 1].max
    if user.hp <= hpLoss
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if !user.pbCanRaiseStatStage?(:SPECIAL_ATTACK, user, self) &&
       !user.pbCanRaiseStatStage?(:ATTACK, user, self) &&
       user.effects[PBEffects::FocusEnergy] >= 2
       @battle.pbDisplay(_INTL("{1}'s stats won't go any higher!", user.pbThis))
       return true
    end
    return false
  end

  def pbEffectGeneral(user)
    hpLoss = [user.totalhp / 2, 1].max
    user.pbReduceHP(hpLoss, false, false)
    showAnim = true
    (@statUp.length / 2).times do |i|
      next if !user.pbCanRaiseStatStage?(@statUp[i * 2], user, self)
      if user.pbRaiseStatStage(@statUp[i * 2], @statUp[(i * 2) + 1], user, showAnim)
        showAnim = false
      end
    end
    @battle.pbCommonAnimation("StatUp", user)
    user.effects[PBEffects::FocusEnergy] += 1
    @battle.pbDisplay(_INTL("{1} critical hit rate increased!", user.pbThis))
    user.pbItemHPHealCheck
  end
end

#===============================================================================
# User loses their Fire type. Fails if user is not Electric-type. (Overload)
#===============================================================================
class Battle::Move::UserLosesElectricType < Battle::Move
  def pbMoveFailed?(user, targets)
    if !user.pbHasType?(:ELECTRIC)
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectAfterAllHits(user, target)
    if !user.effects[PBEffects::Overload]
      user.effects[PBEffects::Overload] = true
      @battle.pbDisplay(_INTL("{1} tired itself out!", user.pbThis))
    end
  end
end

#===============================================================================
# Confuses Target (Panic Powder)
#===============================================================================
class Battle::Move::ConfuseTargetPowder < Battle::Move::ConfuseTarget
  def powderMove?;  return true; end
end

#===============================================================================
# For 5 rounds, swaps the category of all physical and special moves.
# (Paradox Room)
#===============================================================================
class Battle::Move::StartSwapPhysicalSpecialMoveCategory < Battle::Move
  def pbEffectGeneral(user)
    if @battle.field.effects[PBEffects::ParadoxRoom] > 0
      @battle.field.effects[PBEffects::ParadoxRoom] = 0
      @battle.pbDisplay(_INTL("Paradox Room wore off, and the move categories returned to normal!"))
    else
      @battle.field.effects[PBEffects::ParadoxRoom] = 5
      @battle.pbDisplay(_INTL("It created a paradoxical area where physical and special move have categories swapped"))
    end
  end

  def pbShowAnimation(id, user, targets, hitNum = 0, showAnimation = true)
    return if @battle.field.effects[PBEffects::ParadoxRoom] > 0   # No animation
    super
  end
end

#===============================================================================
# (Paranoia)
#===============================================================================
class Battle::Move::SuperEffectiveNormalinSpirit < Battle::Move    
  def pbCalcTypeModSingle(moveType, defType, user, target)
    if defType == :Normal && @battle.field.terrain == :Spirit
      return Effectiveness::SUPER_EFFECTIVE_ONE
    end
    return super
  end
end

#===============================================================================
# May Poison the target. Effectiveness against Bug-type is 2x. (Pesticide)
#===============================================================================
class Battle::Move::PoisonTargetSuperEffectiveAgainstBug < Battle::Move::PoisonTarget
  def pbCalcTypeModSingle(moveType, defType, user, target)
    return Effectiveness::SUPER_EFFECTIVE_ONE if defType == :BUG
    return super
  end
end

#===============================================================================
# Two turn attack. Skips first turn, Summons a 3 turn Rainbow the next (Radiance)
#===============================================================================
class Battle::Move::TwoTurnAttackRainbow < Battle::Move::TwoTurnMove
  def pbMoveFailed?(user, targets)
    return false if user.effects[PBEffects::TwoTurnAttack]   # Charging turn
    if user.pbOwnSide.effect[PBEffects::Rainbow] > 0
      @battle.pbDisplay(_INTL("There is already a rainbow over {1}'s field", user.pbThis))
      return true
    end
    return false
  end

  def pbChargingTurnMessage(user, targets)
    @battle.pbDisplay(_INTL("{1} is absorbing power!", user.pbThis))
  end

  def pbEffectGeneral(user)
    return if !@damagingTurn
    user.pbOwnSide.effect[PBEffects::Rainbow] = 4
    msg = _INTL("A rainbow spans over {1}'s field!", user.pbTeam(true))
    animName = (user.opposes?) ? "RainbowOpp" : "Rainbow"
  end
end

#===============================================================================
# (Reverse Wave)
#===============================================================================
class Battle::Move::SuperEffectiveDarkinPsychic < Battle::Move    
  def pbCalcTypeModSingle(moveType, defType, user, target)
    if defType == :DARK && @battle.field.terrain == :Psychic
      return Effectiveness::SUPER_EFFECTIVE_ONE
    end
    return super
  end
end

#===============================================================================
# User faints. The Pokémon that replaces the user is fully healed (HP, PP and
# status). Fails if user won't be replaced. (Lunar Dance)
#===============================================================================
class Battle::Move::UserFaintsHealAndCureReplacementRestorePP < Battle::Move
  def healingMove?; return true; end
  def canSnatch?;   return true; end

  def pbMoveFailed?(user, targets)
    if !@battle.pbCanChooseNonActive?(user.index)
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbSelfKO(user)
    return if user.fainted?
    user.pbReduceHP(user.hp, false)
    user.pbItemHPHealCheck
    @battle.positions[user.index].effects[PBEffects::LunarDance] = true
  end
end

#===============================================================================
# All current battlers will be fully healed after 3 turns. (Revival Hymn)
#===============================================================================
class Battle::Move::StartHealingCountsForAllBattlers < Battle::Move
  def pbMoveFailed?(user, targets)
    failed = true
    targets.each do |b|
      next if b.effects[PBEffects::RevivalHymn] > 0   # Heard it before
      failed = false
      break
    end
    if failed
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user, target)
    target.effects[PBEffects::RevivalHymn]     = 4
    target.effects[PBEffects::RevivalHymnUser] = user.index
  end

  def pbShowAnimation(id, user, targets, hitNum = 0, showAnimation = true)
    super
    @battle.pbDisplay(_INTL("All Pokémon that hear the song will be fully healed in three turns!"))
  end
end

#===============================================================================
# Two turn attack. Skips first turn, attacks second turn. (Trinity Wing)
# May burn, paralyze or freeze target (30%)
# If the user is is Ice, Fire or Electric type it will deal damage of the user's primary type. 
# If user's is not Ice, Electric or Fire type, it will do one of them at random.
#===============================================================================
class Battle::Move::TwoTurnAttackFreezeParalyzeBurnTarget < Battle::Move::TwoTurnMove
  def pbBaseType(user)
    userTypes = user.pbTypes(true)
    if userTypes[0] == :ICE || userTypes[0] == :ELECTRIC || userTypes[0] == :FIRE
      return userTypes[0] || @type
    end
    return super
  end

  def pbChargingTurnMessage(user, targets)
    @battle.pbDisplay(_INTL("{1} became cloaked in a revelatory light!", user.pbThis))
  end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    userTypes = user.pbTypes(true)
    if userTypes[0] == :ICE
      target.pbFreeze if target.pbCanFreeze?(user, false, self)
    elsif userTypes[0] == :ELECTRIC
      target.pbParalyze(user) if target.pbCanParalyze?(user, false, self) 
    elsif userTypes[0] == :FIRE
      target.pbBurn(user) if target.pbCanBurn?(user, false, self)
    else
      case @battle.pbRandom(3) 
      when 0
        target.pbFreeze if target.pbCanFreeze?(user, false, self)
      when 1
        target.pbParalyze(user) if target.pbCanParalyze?(user, false, self) 
      when 2
        target.pbBurn(user) if target.pbCanBurn?(user, false, self)
      end
    end
  end
end

#===============================================================================
# Reduces the user's HP by half of max, Sharply Increases Defense and 
# Special Defense during Aurora Terrain (Revontuli)
#===============================================================================
class Battle::Move::HistoricDefSpDef2 < Battle::Move
  def canSnatch?; return true; end

  def initialize(battle, move)
    super
    @statUp = [:DEFENSE, 2, :SPECIAL_DEFENSE, 2]
  end

  def pbMoveFailed?(user, targets)
    if @battle.field.terrain != :Aurora
      if user.hasActiveItem?(:MEMORYIDOL)
        @battle.pbCommonAnimation("UseItem", user)
        @battle.pbDisplay(_INTL("The {1} allowed {2}'s memories to trigger!",user.itemName,user.pbThis))
        user.pbConsumeItem
        return false
      else
        @battle.pbDisplay(_INTL("The Memory failed to Trigger"))
        return true
      end
    end
    hpLoss = [user.totalhp / 2, 1].max
    if user.hp <= hpLoss
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if !user.pbCanRaiseStatStage?(:DEFENSE, user, self) &&
       !user.pbCanRaiseStatStage?(:SPECIAL_DEFENSE, user, self)
       @battle.pbDisplay(_INTL("{1}'s stats won't go any higher!", user.pbThis))
       return true
    end
    return false
  end

  def pbEffectGeneral(user)
    hpLoss = [user.totalhp / 2, 1].max
    user.pbReduceHP(hpLoss, false, false)
    (@statUp.length / 2).times do |i|
      next if !user.pbCanRaiseStatStage?(@statUp[i * 2], user, self)
      if user.pbRaiseStatStage(@statUp[i * 2], @statUp[(i * 2) + 1], user, showAnim)
        showAnim = false
      end
    end
    user.pbItemHPHealCheck
  end
end

#===============================================================================
# (Rusting Rain)
#===============================================================================
class Battle::Move::SuperEffectiveSteelinJungle < Battle::Move    
  def pbCalcTypeModSingle(moveType, defType, user, target)
    if defType == :POISON && @battle.field.terrain == :Jungle
      return Effectiveness::SUPER_EFFECTIVE_ONE
    end
    return super
  end
end

#===============================================================================
# Heals the status conditions in the user's party (Sacrament)
#===============================================================================
class Battle::Move::HealsPartyStatusDamage < Battle::Move
  def pbAromatherapyHeal(pkmn, battler = nil)
    oldStatus = (battler) ? battler.status : pkmn.status
    curedName = (battler) ? battler.pbThis : pkmn.name
    if battler
      battler.pbCureStatus(false)
    else
      pkmn.status      = :NONE
      pkmn.statusCount = 0
    end
    case oldStatus
    when :SLEEP
      @battle.pbDisplay(_INTL("{1} was woke up.", curedName))
    when :POISON
      @battle.pbDisplay(_INTL("{1} was cured of their poisoning.", curedName))
    when :BURN
      @battle.pbDisplay(_INTL("{1}'s burn was healed.", curedName))
    when :PARALYSIS
      @battle.pbDisplay(_INTL("{1} was cured of paralysis.", curedName))
    when :FROZEN
      @battle.pbDisplay(_INTL("{1} was thawed out.", curedName))
    end
  end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    if pbTarget(user) == :UserSide
      @battle.allSameSideBattlers(user).each do |b|
        pbAromatherapyHeal(b.pokemon, b) if b.status != :NONE
      end
    end
    @battle.pbParty(user.index).each_with_index do |pkmn, i|
      next if !pkmn || !pkmn.able? || pkmn.status == :NONE
      next if @battle.pbFindBattler(i, user)   # Skip Pokémon in battle
      pbAromatherapyHeal(pkmn)
    end
  end
end

#===============================================================================
# (Savage Bite)
#===============================================================================
class Battle::Move::SuperEffectiveFairyinMystic < Battle::Move    
  def pbCalcTypeModSingle(moveType, defType, user, target)
    if defType == :Fairy && @battle.field.terrain == :Mystic
      return Effectiveness::SUPER_EFFECTIVE_ONE
    end
    return super
  end
end

#===============================================================================
# Burns Target (Searing Spore)
#===============================================================================
class Battle::Move::BurnTargetPowder < Battle::Move::BurnTarget
  def powderMove?;  return true; end
end

#===============================================================================
# Safeguards the user's side from being inflicted with status problems for 2 turns.
# (Shining Breath)
#===============================================================================
class Battle::Move::StartUserSideImmunityToInflictedStatusDamage < Battle::Move
  def pbAdditionalEffect(user)
    return if target.damageState.substitute
    return if user.pbOwnSide.effects[PBEffects::Safeguard] > 0
    user.pbOwnSide.effects[PBEffects::Safeguard] = 3
    @battle.pbDisplay(_INTL("{1}'s field cloaked in a mystical light!", user.pbTeam))
  end
end

#===============================================================================
# Averages the user's and target's Speed (Speed Split)
#===============================================================================
class Battle::Move::UserTargetAverageBaseSpeed < Battle::Move
  def pbEffectAgainstTarget(user, target)
    newspeed   = ((user.speed + target.speed) / 2).floor
    user.speed = target.speed = newspeed
    @battle.pbDisplay(_INTL("{1} spilt their speed with {2}!", user.pbThis,target.pbThis))
  end
end

#===============================================================================
# Decreases the target's Spped by 1 stage. Heals user by an amount equal to the
# target's Spped stat (after applying stat stages, before this move decreases
# it). (Speed Steal)
#===============================================================================
class Battle::Move::HealUserByTargetSpeedLowerTargetSpeed1 < Battle::Move
  def healingMove?;  return true; end
  def canMagicCoat?; return true; end

  def pbFailsAgainstTarget?(user, target, show_message)
    if !@battle.moldBreaker && target.hasActiveAbility?(:CONTRARY) &&
       target.statStageAtMax?(:SPEED)
      @battle.pbDisplay(_INTL("But it failed!")) if show_message
      return true
    elsif target.statStageAtMin?(:SPEED)
      @battle.pbDisplay(_INTL("But it failed!")) if show_message
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user, target)
    # Calculate target's effective attack value
    stageMul = [2, 2, 2, 2, 2, 2, 2, 3, 4, 5, 6, 7, 8]
    stageDiv = [8, 7, 6, 5, 4, 3, 2, 2, 2, 2, 2, 2, 2]
    speed      = target.speed
    speedStage = target.stages[:SPEED] + 6
    healAmt = (speed.to_f * stageMul[speedStage] / stageDiv[speedStage]).floor
    # Reduce target's Attack stat
    if target.pbCanLowerStatStage?(:SPEED, user, self)
      target.pbLowerStatStage(:SPEED, 1, user)
    end
    # Heal user
    user.pbRecoverHPFromDrain(healAmt, target, true, false, true)
  end
end

#===============================================================================
# (Tai-Chi Strike)
#===============================================================================
class Battle::Move::SuperEffectiveGhostinFocus < Battle::Move    
  def pbCalcTypeModSingle(moveType, defType, user, target)
    if defType == :Ghost && @battle.field.terrain == :Focus
      return Effectiveness::SUPER_EFFECTIVE_ONE
    end
    return super
  end
end

#===============================================================================
# Removes trapping moves, entry hazards and Leech Seed on user/user's side (Tornado)
#===============================================================================
class Battle::Move::RemoveUserBindingAndEntryHazardsTornado < Battle::Move
  def pbEffectAfterAllHits(user, target)
    return if user.fainted? || target.damageState.unaffected
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
    if target.effects[PBEffects::LeechSeed] >= 0
      target.effects[PBEffects::LeechSeed] = -1
      @battle.pbDisplay(_INTL("{1} shed Leech Seed!", target.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::StealthRock] ||
      user.pbOwnSide.effects[PBEffects::IcicleRain] ||
      user.pbOwnSide.effects[PBEffects::Spikes] > 0 ||
      user.pbOwnSide.effects[PBEffects::ToxicSpikes] > 0 ||
      user.pbOwnSide.effects[PBEffects::StickyWeb] ||
      user.pbOwnSide.effects[PBEffects::BurningGround] ||
      user.pbOpposingSide.effects[PBEffects::StealthRock] ||
      user.pbOpposingSide.effects[PBEffects::IcicleRain] ||
      user.pbOpposingSide.effects[PBEffects::Spikes] > 0 ||
      user.pbOpposingSide.effects[PBEffects::ToxicSpikes] > 0 ||
      user.pbOpposingSide.effects[PBEffects::StickyWeb] ||
      user.pbOpposingSide.effects[PBEffects::BurningGround] 
      @battle.pbDisplay(_INTL("All entry hazard were removed", user.pbThis))
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
    if user.pbOpposingSide.effects[PBEffects::StealthRock]
      user.pbOpposingSide.effects[PBEffects::StealthRock] = false
    end
    if user.pbOpposingSide.effects[PBEffects::IcicleRain]
      user.pbOpposingSide.effects[PBEffects::IcicleRain] = false
    end
    if user.pbOpposingSide.effects[PBEffects::Spikes] > 0
      user.pbOpposingSide.effects[PBEffects::Spikes] = 0
    end
    if user.pbOpposingSide.effects[PBEffects::ToxicSpikes] > 0
      user.pbOpposingSide.effects[PBEffects::ToxicSpikes] = 0
    end
    if user.pbOpposingSide.effects[PBEffects::StickyWeb]
      user.pbOpposingSide.effects[PBEffects::StickyWeb] = false
    end
    if user.pbOpposingSide.effects[PBEffects::BurningGround]
      user.pbOpposingSide.effects[PBEffects::BurningGround] = false
    end
  end
end

#===============================================================================
# Target's ability becomes Unicorn. (Unicorn Charm)
#===============================================================================
class Battle::Move::SetTargetAbilityToUnicorn < Battle::Move
  def canMagicCoat?; return true; end

  def pbMoveFailed?(user, targets)
    if !GameData::Ability.exists?(:UNICORN)
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbFailsAgainstTarget?(user, target, show_message)
    if target.unstoppableAbility? || target.unstoppableAbilityEchoes? ||
      [:TRUANT, :UNICORN].include?(target.ability_id)
      @battle.pbDisplay(_INTL("But it failed!")) if show_message
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user, target)
    @battle.pbShowAbilitySplash(target, true, false)
    oldAbil = target.ability
    target.ability = :UNICORN
    @battle.pbReplaceAbilitySplash(target)
    @battle.pbDisplay(_INTL("{1} acquired the ability {2}!", target.pbThis, target.abilityName))
    @battle.pbHideAbilitySplash(target)
    target.pbOnLosingAbility(oldAbil)
    target.pbTriggerAbilityOnGainingIt
  end
end

#===============================================================================
# Reduces the user's HP by half of max, Sharply Increases Speed and 
# raises Attack and Special Attack during Electric Terrain (Yushan)
#===============================================================================
class Battle::Move::HistoricSpeedAttackSpAtk < Battle::Move
  def canSnatch?; return true; end
  
  def initialize(battle, move)
    @statUp = [:SPEED, 2, :ATTACK, 1, :SPECIAL_ATTACK , 1]
  end

  def pbMoveFailed?(user, targets)
    if @battle.field.terrain != :Electric
      if user.hasActiveItem?(:MEMORYIDOL)
        @battle.pbCommonAnimation("UseItem", user)
        @battle.pbDisplay(_INTL("The {1} triggered {2}'s memories!",user.itemName,user.pbThis))
        user.pbConsumeItem
        return false
      else
        @battle.pbDisplay(_INTL("The Memory failed to Trigger"))
        return true
      end
    end
    hpLoss = [user.totalhp / 2, 1].max
    if user.hp <= hpLoss
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if !user.pbCanRaiseStatStage?(:SPEED, user, self) &&
       !user.pbCanRaiseStatStage?(:ATTACK, user, self) &&
       !user.pbCanRaiseStatStage?(:SPECIAL_ATTACK, user, self) 
       @battle.pbDisplay(_INTL("{1}'s stats won't go any higher!", user.pbThis))
       return true
    end
    return false
  end

  def pbEffectGeneral(user)
    hpLoss = [user.totalhp / 2, 1].max
    user.pbReduceHP(hpLoss, false, false)
    showAnim = true
    (@statUp.length / 2).times do |i|
      next if !user.pbCanRaiseStatStage?(@statUp[i * 2], user, self)
      if user.pbRaiseStatStage(@statUp[i * 2], @statUp[(i * 2) + 1], user, showAnim)
        showAnim = false
      end
    end
    user.pbItemHPHealCheck
  end
end

#===============================================================================
# Attacks first turn, skips second turn (if successful).
# Halves target's (current) HP and the PP of all the their moves (???)
# Exclusive to: Cognitree
#===============================================================================
class Battle::Move::HalveHPandPPAllmoves < Battle::Move
  def pbFixedDamage(user, target)
    return (target.hp * 1/2).round 
  end

  def pbEffectGeneral(user)
    user.effects[PBEffects::HyperBeam] = 2
    user.currentMove = @id
  end

  def pbEffectAgainstTarget(user, target)
    target.eachMove do |m|
      next if m.total_pp == 0
      next if m.pp == 0 && m.total_pp > 0
      drain = (m.pp / 2).ceil
      drain += 1 if user.hasActiveItem?(:GRUDGEDOLL)
      drain = [drain , m.pp].min
      m.pp -= drain
      @battle.pbDisplay(_INTL("{1}'s PP was drained by {2}.", m.id,drain))
    end
  end
end