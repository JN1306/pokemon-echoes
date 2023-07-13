#===============================================================================
# Does absolutely nothing. (Splash)
# Update: Added effect to support Fortune Fin
#===============================================================================
class Battle::Move::SplashUpdated < Battle::Move
  def unusableInGravity?; return true; end

  def pbEffectGeneral(user)
    @battle.pbDisplay(_INTL("But nothing happened!"))
    return if user.species != :MAGIKARP
    return if user.level <= 20
    return if !user.hasActiveItem?(:FORTUNEFIN)
    ch = (attack.level / 10).round

    chance = pbAdditionalEffectChance(user, target, ch)
    return if chance == 0
    if @battle.pbRandom(100) < chance
      @battle.pbDisplay(_INTL("{1}'s {2} felt like helping and activated!", user.pbThis))
      showAnim = true
      for s in [:ATTACK, :DEFENSE, :SPEED, :SPECIAL_ATTACK, :SPECIAL_DEFENSE]
        if user.pbCanRaiseStatStage?(s, user, self)
          user.pbRaiseStatStage(s, 3, user, showAnim)
        end
      end
      showAnim = false
      if user.hasActiveItem?(:FORTUNEFIN)
        @battle.pbDisplay(_INTL("Having fulfilled its purpose in life, the {1} gracfully disappeared.",
        user.itemName))
      end
    end
  end
end