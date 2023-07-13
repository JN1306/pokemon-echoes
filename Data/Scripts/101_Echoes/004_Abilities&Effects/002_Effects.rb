class Battle::Battler
  #=============================================================================
  # Ability Effec
  #=============================================================================
  # Angolmir
  def pbEchoAbilityAngolmir
    if effects[PBEffects::GemConsumed] && hasActiveAbility?(:ANGOLMIR) &&
      pbCanRaiseStatStage?(:SPECIAL_ATTACK, user, self)
      pbShowAbilitySplash
      if Battle::Scene::USE_ABILITY_SPLASH
        pbDisplay(_INTL("{1}'s gem imbued them with wisdom!",pbThis))
      else
        pbDisplay(_INTL("{1}'s {2} imbued their gem with wisdom!",pbThis, abilityName))
      end
      pbHideAbilitySplash
    end
  end
end
#=============================================================================
# Unstoppable Echoes-Exclusive Abilities
#=============================================================================
def unstoppableAbilityEchoes?(abil = nil)
  abil = @ability_id if !abil
  abil = GameData::Ability.try_get(abil)
  return false if !abil
  ability_blacklist = [
    # Abilities intended to be inherent properties of a certain species
    :ARCSPHERE,
    :CORONAPORTAL,
    :GRAVITONPORTAL,
    :RIPPLEPORTAL,
    :INHERITANCE,
    :KARMAGEAR
  ]
  return ability_blacklist.include?(abil.id)
end

#=============================================================================
# Unstoppable Echoes-Exclusive Item (Combinations)
#=============================================================================
def unlosableEchoes?(species, ability)
  return false if (species == :ALBEEM || species == :HERINEY || species == :ECCLURGEIA) && 
                   ability != :INHERITANCE
  combos = {
    :SILVALLY  => [:FIGHTINGMEMORY],
    :ARCEUS    => [:FISTPLATE]
  }
  return combos[species]&.include?(@id)
end

#=============================================================================
# Changing Target of a move (Paladin)
#=============================================================================
def pbChangeTargetPaladin(drawingAbility,move, user, targets, priority, nearOnly)
  return targets if !move.damagingMove?
  return targets if targets[0].hasActiveAbility?(drawingAbility)
  priority.each do |b|
    next if b.index == user.index || b.index == targets[0].index
    next if !b.hasActiveAbility?(drawingAbility)
    next if nearOnly && !b.near?(user)
    next if b.allAllies.length == 0
    target.eachAlly do |a|
      next if a.hp > (a.totalhp / 4).round
    end
    @battle.pbShowAbilitySplash(b)
    targets.clear
    pbAddTarget(targets, user, b, move, nearOnly)
    if Battle::Scene::USE_ABILITY_SPLASH
      @battle.pbDisplay(_INTL("{1} defended their ally!", b.pbThis))
    else
      @battle.pbDisplay(_INTL("{1}'s {2} spirit defended their ally!", b.pbThis, b.abilityName))
    end
    @battle.pbHideAbilitySplash(b)
    break
  end
  return targets
end

#=============================================================================
# Echoes Specific Entry Hazards
# Icicle Rain, Burning Ground, Hollow Passage, Ripple Portal 
#=============================================================================
def pbEntryHazardsEchoes(battler)
  battler_side = battler.pbOwnSide
  # Burning Ground
  if battler_side.effects[PBEffects::BurningGround] && !battler.fainted? && !battler.airborne? &&
    !battler.hasActiveItem?(:HEAVYDUTYBOOTS)
    pbDisplay(_INTL("{1} got singed on the burning ground!", battler.pbThis))
    target.pbBurn(user) if target.pbCanBurn?(user, false, self)
      battler.pbItemStatRestoreCheck
  end
  # Icicle Rain
  if battler_side.effects[PBEffects::IcicleRain] && battler.takesIndirectDamage? &&
    GameData::Type.exists?(:ICE) && !battler.hasActiveItem?(:HEAVYDUTYBOOTS)
    bTypes = battler.pbTypes(true)
    eff = Effectiveness.calculate(:ICE, bTypes[0], bTypes[1], bTypes[2])
    if !Effectiveness.ineffective?(eff)
      eff = eff.to_f / Effectiveness::NORMAL_EFFECTIVE
      battler.pbReduceHP(battler.totalhp * eff / 8, false)
      pbDisplay(_INTL("Sharp Icicles flung themselves into {1}!", battler.pbThis))
      battler.pbItemHPHealCheck
    end
  end
  #=========================================================================
  # Pseudo Entry hazards that are only activated after a forced switch in.
  # Unaffected by moves, items and effects that interact with regular entry hazards.
  #=========================================================================
  # Corona Portal
  if battler_side.effects[PBEffects::CoronaPortal] && !battler.fainted?
    if battle.hasActiveAbility?(:SHIELDDUST) && !battle.moldBreaker
      battle.pbShowAbilitySplash(battler)
      if !Battle::Scene::USE_ABILITY_SPLASH
        @battle.pbDisplay(_INTL("{1} is unaffected!", target.pbThis))
      end
      battle.pbHideAbilitySplash(battler)
    else 
      batller.pbBurn(battler) if battler.pbCanBurn?(battler, false, self)
      battler.pbItemStatRestoreCheck
    end
    battler_side.effects[PBEffects::CoronaPortal] = false
  end
  # Event Horizon
  eh_Battler = battle.pbCheckGlobalAbility(:EVENTHORIZON)
  gravity = @battle.field.effects[PBEffects::Gravity]
  if eh_Battler && gravity > 0 &&  battler.takesIndirectDamage? && 
    !battler.hasActiveItem?(:HEAVYDUTYBOOTS) && !battler.pbHasType?(:PSYCHIC)
    battle.pbShowAbilitySplash(eh_Battler)
    if battler.hasActiveAbility?(:SHIELDDUST) && !battle.moldBreaker
      battle.pbShowAbilitySplash(battler)
      if !Battle::Scene::USE_ABILITY_SPLASH
        @battle.pbDisplay(_INTL("{1} is unaffected!", target.pbThis))
      end
      battle.pbHideAbilitySplash(battler)
    else
      if !Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1}'s {2} emitted harmful gravity waves",
        eh_Battler.pbThis(true), eh_Battler.abilityName))
      end
      eh_div = 0
      eh_div = 16 if gravity >= 5
      eh_div = 8 if gravity < 5 && gravity >= 3
      eh_div = 4 if gravity == 2
      eh_div = 2 if gravity == 1
      battler.pbReduceHP[(battler.hp / eh_div).round , 1].max
      battler.pbItemHPHealCheck
    end
    battle.pbHideAbilitySplash(eh_Battler)
  end
  # Hollow Passage
  if battler_side.effects[PBEffects::HollowPassage] && !battler.fainted? 
    if battler.hasActiveAbility?(:INNERFOCUS) && !battle.moldBreaker
      battle.pbShowAbilitySplash(battler)
      if !Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1} is unaffected!", target.pbThis))
      end
      battle.pbHideAbilitySplash(battler)
    else
      if (battler.status == :SLEEP || battler.hasActiveAbility(:COMATOSE)) && 
        !battler.effects[PBEffects::Nightmare] 
        battler.effects[PBEffects::Nightmare] = true
        pbDisplay(_INTL("The hollow passage gave {1} a nightmare!", battler.pbThis))
      else
        battler.pbPoison(battler, nil, false) if battler.pbCanPoison?(battler, false, self) 
        battler.pbConfuse if target.pbCanConfuse?(user, false, self)
      end
    end
    battler.pbItemStatRestoreCheck
    battler_side.effects[PBEffects::HollowPassage] = false
  end
  # Ripple Portal
  if battler_side.effects[PBEffects::RipplePortal] && !battler.fainted? 
    if battler.hasActiveAbility?(:SHIELDDUST) && !battle.moldBreaker
      battle.pbShowAbilitySplash(battler)
      if !Battle::Scene::USE_ABILITY_SPLASH
        @battle.pbDisplay(_INTL("{1} is unaffected!", target.pbThis))
      end
      battle.pbHideAbilitySplash(battler)
    else
      battler.pbReduceHP[(battler.hp / 2).round , 1].max
      battler.pbItemHPHealCheck
    end
    battler_side.effects[PBEffects::RipplePortal] = false
  end
end

#=============================================================================
# Initial success check against the target. Done once before the first hit.
# Includes move-specific failure conditions, protections and type immunities.
# (For Echoes exclusive moves)
#=============================================================================
def pbSuccessCheckAgainstTargetEchoes(move, user, target, targets)
  show_message = move.pbShowFailMessages?(targets)
  typeMod = move.pbCalcTypeMod(move.calcType, user, target)
  target.damageState.typeMod = typeMod
  # Tachyon Shield
  if target.effects[PBEffects::TachyonShield] 
    if show_message
      #@battle.pbCommonAnimation("KingsShield", target)
      @battle.pbDisplay(_INTL("{1} protected themself!", target.pbThis))
    end
    target.damageState.protected = true
    @battle.successStates[user.index].protected = true
    if target.effect[PBEffects::PortalDrive] < 3
      target.effect[PBEffects::PortalDrive] += 1
      @battle.pbDisplay(_INTL("{1} portal got charged by {2}'s attack!", 
      target.pbThis,user.pbThis))
    else
      target.effect[PBEffects::PortalDrive] = 0
      @battle.pbDisplay(_INTL("{1} portal got over-charged by {2}'s attack and lost its energy!", 
      target.pbThis,user.pbThis))
    end
    return false
  end
  if !(user.hasActiveAbility?(:UNSEENFIST) && move.contactMove?)
    # Heat Flash
    if target.effects[PBEffects::HeatFlash] && move.damagingMove?
      if show_message
        #@battle.pbCommonAnimation("KingsShield", target)
        @battle.pbDisplay(_INTL("{1} protected itself!", target.pbThis))
      end
      target.damageState.protected = true
      @battle.successStates[user.index].protected = true
      if move.pbSpecialMove?(user) &&
        user.pbCanLowerStatStage?(:SPECIAL_ATTACK, target)
        user.pbLowerStatStage(:SPECIAL_ATTACK, (Settings::MECHANICS_GENERATION >= 8) ? 1 : 2, target)
      end
      return false
    end
    # Spore Shield
    if target.effects[PBEffects::SporeShield] && move.damagingMove?
      if show_message
        #@battle.pbCommonAnimation("KingsShield", target)
        @battle.pbDisplay(_INTL("{1} protected itself!", target.pbThis))
      end
      target.damageState.protected = true
      @battle.successStates[user.index].protected = true
      target.pbSleep if Effectiveness.super_effective?(@damageState.typeMod) && 
      target.pbCanSleep?(user, false, self) 
      return false
    end
  end
end

class Battle
  #=============================================================================
  # EOR - Ending Echoes exclusive side effects
  #=============================================================================
  def pbEOREndSideEffectsEchoes(side, priority)
    # Bastion Shell
    pbEORCountDownSideEffect(side, PBEffects::BastionShell,
                            _INTL("{1}'s Bastion Shell broke!", @battlers[side].pbTeam))
  end

  #=============================================================================
  # End Of Round Divide by Zero damage
  #=============================================================================
  def pbEORDividebyZeroDamage(priority)
    2.times do |side|
      next if sides[side].effects[PBEffects::DivideByZero] == 0
      #pbCommonAnimation("SeaOfFire") if side == 0
      #pbCommonAnimation("SeaOfFireOpp") if side == 1
      priority.each do |battler|
        next if battler.opposes?(side)
        next if !battler.takesIndirectDamage? || battler.pbHasType?(:QMARKS)
        @scene.pbDamageAnimation(battler)
        battler.pbReduceHP(battler.hp / 2, false) { |hp_lost|
          pbDisplay(_INTL("{1} is hurt by the strange anomaly!", battler.pbThis))
        }
      end
    end
  end

  #=============================================================================
  # EOR - Ending Echoes exclusive field effects
  #=============================================================================
  def pbEOREndFieldEffectsEchoes(priority)
    # Divide By Zero
    pbEORCountDownFieldEffect(PBEffects::DivideByZero,
                              _INTL("The strage anomaly wore off, HP will no longer be halved"))
    # Paradox Room
    pbEORCountDownFieldEffect(PBEffects::ParadoxRoom,
                              _INTL("Paradox Room wore off, Move catergories returned to normal!"))
  end

  #=============================================================================
  # End Of Round end effects that apply to a battler (Ex)
  #=============================================================================
  def pbEOREndBattlerEffectsEchoes(priority)
    # Revival Hymn
    revivalHymnUsers = []
    priority.each do |battler|
      next if battler.fainted? || battler.effects[PBEffects::RevivalHymn] == 0
      battler.effects[PBEffects::RevivalHymn] -= 1
      pbDisplay(_INTL("{1}'s healing count  count fell to {2}!", battler.pbThis, battler.effects[PBEffects::RevivalHymn]))
      if battler.effects[PBEffects::RevivalHymn] == 0
        battler.pbRecoverHP(battler.hp)
        battler.pbCureStatus if battler.status != :NONE
        revivalHymnUsers.push(battler.effects[PBEffects::RevivalHymnUser])
      end
      battler.pbItemHPHealCheck
    end
    # Frost Elegy
    frostElegyUsers = []
    priority.each do |battler|
      next if battler.fainted? || battler.effects[PBEffects::FrostElegy] == 0
      battler.effects[PBEffects::FrostElegy] -= 1
      pbDisplay(_INTL("{1}'s elegy count fell to {2}!", battler.pbThis, battler.effects[PBEffects::FrostElegy]))
      if battler.effects[PBEffects::Frost] == 0
        battler.pbFreeze if battler.pbCanFreeze
        frostElegyUsers.push(battler.effects[PBEffects::FrostElegyUser])
      end
      battler.pbItemHPHealCheck
    end
  end

  #=============================================================================
  # Main End Of Round phase method (Echoes only)
  #=============================================================================
  def pbEndOfRoundPhaseEchoes
    # Effects that apply to a side that wear off after a number of rounds
    2.times { |side| pbEOREndSideEffectsEchoes(side, priority) }
    # Effects that apply to a battler that wear off after a number of rounds
    pbEOREndBattlerEffectsEchoes(priority)
    # Effects that apply to a side that wear off after a number of rounds
    2.times { |side| pbEOREndSideEffectsEchoes(side, priority) }
    # Effects that apply to the whole field that wear off after a number of rounds
    pbEOREndFieldEffectsEchoes(priority)
    # Reset/count down battler-specific effects (no messages)
    allBattlers.each do |battler|
      battler.effects[PBEffects::EnergyBurst]      = 0
      battler.effects[PBEffects::HeatFlash]        = false
      battler.effects[PBEffects::HitNumber]        = 0
      battler.effects[PBEffects::Overload]         = false
      #battler.effects[PBEffects::PortalDrive]      = 0
      battler.effects[PBEffects::SporeShield]      = false
      battler.effects[PBEffects::TachyonShield]    = false
    end
  end
end