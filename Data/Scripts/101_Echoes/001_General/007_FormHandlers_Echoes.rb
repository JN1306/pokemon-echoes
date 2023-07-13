#===============================================================================
# Echoes Specific Evolution Methods
#===============================================================================
GameData::Evolution.register({
  :id                   => :StarterOrb,
  :parameter            => :Item,
  :minimum_level        => 30,  
  :level_up_proc        => proc { |pkmn, parameter|
    next pkmn.item == parameter && pkmn.level >= minimum_level 
  }
})

GameData::Evolution.register({
  :id                   => :MiracleOrb,
  :parameter            => Integer, 
  :level_up_proc        => proc { |pkmn, parameter|
    next pkmn.item == :MIRACLEORB && pkmn.level >= parameter
  }
})

GameData::Evolution.register({
  :id            => :Irisphere,
  :parameter     => :Item,
  :use_item_proc => proc { |pkmn, parameter|
  next item == parameter && pkmn.level >= 50
  }
})


#===============================================================================
# Echoes Specific "GetForm" entries
#===============================================================================
MultipleForms.register(:PIKACHU, {
  "getForm" => proc { |pkmn|
    next 1 if pkmn.hasItem?(:PSYCHICELEMENT)
    next 0
  }
})

MultipleForms.register(:EXEGGCUTE, {
  "getForm" => proc { |pkmn|
    next 1 if pkmn.hasItem?(:DRAGONELEMENT)
    next 0
  }
})

MultipleForms.register(:CUBONE, {
  "getForm" => proc { |pkmn|
    next 1 if pkmn.hasItem?(:GHOSTELEMENT)
    next 0
  }
})

MultipleForms.register(:KOFFING, {
  "getForm" => proc { |pkmn|
    next 1 if pkmn.hasItem?(:FAIRYELEMENT)
    next 0
  }
})

MultipleForms.register(:MIMEJR, {
  "getForm" => proc { |pkmn|
    next 1 if pkmn.hasItem?(:ICEELEMENT)
    next 0
  }
})

MultipleForms.register(:MILCERY, {
  "getForm" => proc { |pkmn|
    next 1 if pkmn.hasItem?(:YELLOWAPRICORN)
    next 2 if pkmn.hasItem?(:BLUEAPRICORN)
    next 3 if pkmn.hasItem?(:GREENAPRICORN)
    next 4 if pkmn.hasItem?(:PINKAPRICORN)
    next 5 if pkmn.hasItem?(:WHITEAPRICORN)
    next 6 if pkmn.hasItem?(:REDAPRICORN)
    next 7 if pkmn.hasItem?(:BLACKAPRICORN)
    next 0
  }
})

MultipleForms.register(:KUBFU, {
  "getForm" => proc { |pkmn|
    next 1 if pkmn.hasItem?(:DARKELEMENT)
    next 2 if pkmn.hasItem?(:WATERELEMENT)
    next 0
  }
})

#MultipleForms.register(:CHARCADET, {
#  "getForm" => proc { |pkmn|
#    next 1 if pkmn.hasItem?(:PSYCHICELEMENT)
#    next 2 if pkmn.hasItem?(:GHOSTELEMENT)
#    next 0
#  }
#})


MultipleForms.register(:INLYS, {
  "getForm" => proc { |pkmn|
    next 1 if pkmn.hasItem?(:KNOWLEDGEORB)
    next 2 if pkmn.hasItem?(:LOVEORB)
    next 3 if pkmn.hasItem?(:PURITYORB)
    next 0
  }
})

MultipleForms.register(:LICIT, {
  "getForm" => proc { |pkmn|
    next 1 if pkmn.hasItem?(:COURAGEORB)
    next 2 if pkmn.hasItem?(:FRIENDSHIPORB)
    next 3 if pkmn.hasItem?(:KINDNESSORB)
    next 0
  }
})

MultipleForms.register(:VINETTE, {
  "getForm" => proc { |pkmn|
    next 1 if pkmn.hasItem?(:SINCERITYORB)
    next 2 if pkmn.hasItem?(:HOPEORB)
    next 3 if pkmn.hasItem?(:LIGHTORB)
    next 0
  }
})

MultipleForms.register(:MAGPLAY, {
  "getForm" => proc { |pkmn|
    next 1 if pkmn.hasItem?(:LIFEORB)
    next 2 if pkmn.hasItem?(:FLAMEORB)
    next 3 if pkmn.hasItem?(:TOXICORB)
    next 0
  }
})

MultipleForms.register(:ALBEEM, {
  "getForm" => proc { |pkmn|
    next nil if !pkmn.hasAbility?(:INHERITANCE)
    #next 1 if pkmn.hasItem?(:RELICCHALICE)
    #next 2 if pkmn.hasItem?(:RELICARMOR)
    #next 3 if pkmn.hasItem?(:RELICSHIELD)
    #next 4 if pkmn.hasItem?(:RELICLANCE)
    next 5 if pkmn.hasItem?(:RELICCROWN)
    #next 6 if pkmn.hasItem?(:RELICWAND)
    #next 7 if pkmn.hasItem?(:RELICARK)
    next 0
  }
})

MultipleForms.copy(:ALBEEM, :AUVRANEY, :ECCLURGEIA)