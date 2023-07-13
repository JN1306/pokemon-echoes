#===============================================================================
# Attacks first turn, skips second turn (if successful).
# Updated to support the ability: Energy Burst
#===============================================================================
class Battle::Move::HyperBeamUpdated < Battle::Move
  def pbBaseDamage(baseDmg, user, target)
    energy = user.effects[PBEffects::EnergyBurst]
    baseDmg = (baseDmg / (energy + 1)).round if energy > 0 
    return baseDmg
  end

  def pbEffectGeneral(user)
    if user.hasActiveAbility?(:ENERYBURST)
      user.effects[PBEffects::EnergyBurst] += 1
    else
      user.effects[PBEffects::HyperBeam] = 2
      user.currentMove = @id
    end
  end

  def pbEffectAfterAllHits(user, target)
    return if !target.isFainted?
    return if user.effect[PBEffects::EnergyBurst] == 0
    user.effects[PBEffects::EnergyBurst] = 0
    user.effects[PBEffects::HyperBeam] = 2
    user.currentMove = @id
    @battle.pbDisplay(_INTL("{1}'s will be restored after recharge!", target.pbThis))
  end
end
