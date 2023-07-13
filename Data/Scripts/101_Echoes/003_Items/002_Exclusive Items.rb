#===============================================================================
# Echoes: Pokémon Exclusive Items
#===============================================================================
Battle::ItemEffects::DamageCalcFromTarget.add(:AGGRESSIONPOWDER,
  proc { |item, user, target, move, mults, baseDmg, type|
    if user.isSpecies?(:DITTO) && !user.effects[PBEffects::Transform] && move.specialMove?
      mults[:attack_multiplier] *= 2
    end
  }
)

Battle::ItemEffects::DamageCalcFromUser.add(:MASKOFQUILLA,
  proc { |item, user, target, move, mults, baseDmg, type|
    if user.isSpecies?(:LUNATONE) && [:DARK, :ICE].include?(type)
      mults[:attack_multiplier] *= 1.5
    end
  }
)

Battle::ItemEffects::DamageCalcFromUser.add(:MASKOFINTI,
  proc { |item, user, target, move, mults, baseDmg, type|
    if user.isSpecies?(:SOLROCK) && [:FIRE, :GRASS].include?(type)
      mults[:attack_multiplier] *= 1.5
    end
  }
)

Battle::ItemEffects::DamageCalcFromTarget.add(:STRIKEPOWDER,
  proc { |item, user, target, move, mults, baseDmg, type|
    if user.isSpecies?(:DITTO) && !user.effects[PBEffects::Transform] && move.physicalMove?
      mults[:attack_multiplier] *= 2
    end
  }
)

Battle::ItemEffects::DamageCalcFromUser.add(:TIMEPUZZLE,
  proc { |item, user, target, move, mults, baseDmg, type|
    mults[:base_damage_multiplier] *= 1.2 if type == :QMARKS
  }
)
Battle::ItemEffects::DamageCalcFromUser.copy(:TIMEPUZZLE, :CHRONOSPLATE)

#===============================================================================
# DamageCalcFromTarget handlers
#===============================================================================
Battle::ItemEffects::DamageCalcFromTarget.add(:LUMOSPOWDER,
 proc { |item, user, target, move, mults, baseDmg, type|
    if user.isSpecies?(:DITTO) && !user.effects[PBEffects::Transform]
      mults[:defense_multiplier] *= 2 if move.specialMove?
    end
  }
)

Battle::ItemEffects::DamageCalcFromTarget.add(:PANGOLINPLATE,
  proc { |item, user, target, move, mults, baseDmg, type|
    if user.isSpecies?(:SANDSLASH)
      if move.specialMove?
        mults[:defense_multiplier] *= 2
      else 
        mults[:defense_multiplier] *= 1.1
      end
    end
  }
)