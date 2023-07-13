# These are in-battle terrain effects caused by moves like Electric Terrain.
module GameData
  class BattleTerrain
    attr_reader :id
    attr_reader :real_name
    attr_reader :animation

    DATA = {}

    extend ClassMethodsSymbols
    include InstanceMethods

    def self.load; end
    def self.save; end

    def initialize(hash)
      @id        = hash[:id]
      @real_name = hash[:name] || "Unnamed"
      @animation = hash[:animation]
    end

    # @return [String] the translated name of this battle terrain
    def name
      return _INTL(@real_name)
    end
  end
end

#===============================================================================

GameData::BattleTerrain.register({
  :id   => :None,
  :name => _INTL("None")
})

GameData::BattleTerrain.register({
  :id        => :Electric,
  :name      => _INTL("Electric"),
  :animation => "ElectricTerrain"
})

GameData::BattleTerrain.register({
  :id        => :Grassy,
  :name      => _INTL("Grassy"),
  :animation => "GrassyTerrain"
})

GameData::BattleTerrain.register({
  :id        => :Misty,
  :name      => _INTL("Misty"),
  :animation => "MistyTerrain"
})

GameData::BattleTerrain.register({
  :id        => :Psychic,
  :name      => _INTL("Psychic"),
  :animation => "PsychicTerrain"
})

GameData::BattleTerrain.register({
  :id        => :Mystic,
  :name      => _INTL("Mystic"),
  :animation => "MysticTerrain"
})

GameData::BattleTerrain.register({
  :id        => :Focus,
  :name      => _INTL("Focus"),
  :animation => "FocusTerrain"
})

GameData::BattleTerrain.register({
  :id        => :Spirit,
  :name      => _INTL("Spirit"),
  :animation => "SpiritTerrain"
})

GameData::BattleTerrain.register({
  :id        => :Aurora,
  :name      => _INTL("Aurora"),
  :animation => "AuroraTerrain"
})

GameData::BattleTerrain.register({
  :id        => :Lunar,
  :name      => _INTL("Lunar"),
  :animation => "LunarTerrain"
})

GameData::BattleTerrain.register({
  :id        => :Jungle,
  :name      => _INTL("Jungle"),
  :animation => "JungleTerrain"
})

GameData::BattleTerrain.register({
  :id        => :Desert,
  :name      => _INTL("Desert"),
  :animation => "DesertTerrain"
})

GameData::BattleTerrain.register({
  :id        => :Shadow,
  :name      => _INTL("Shadow"),
  :animation => "ShadowTerrain"
})

GameData::BattleTerrain.register({
  :id        => :Time,
  :name      => _INTL("Time"),
  :animation => "TimeTerrain"
})