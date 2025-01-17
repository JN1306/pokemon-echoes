
# List of Pokemon that don't have their sprites sunk into the water
OVERWORLD_WATER_ABOVE = [
  :SURSKIT, :MASQUERAIN,
  :WINGULL, :PELIPPER
]

# List of Pokemon that are lowered less into the water than normal
OVERWORLD_WATER_FLOAT = [
  :PSYDUCK,
  :DUCKLETT, :SWANNA
]

# List of Pokemon to never mirror
OVERWORLD_NO_MIRROR = [
  :UNOWN
]

class OverworldPokemon
  attr_accessor :species
  attr_accessor :map_x
  attr_accessor :map_y
  attr_accessor :new_x
  attr_accessor :new_y
  attr_reader   :time
  attr_reader   :lifetime
  attr_reader   :dead
  
  def initialize(viewport,map,species,lvl,form,x,y,terrain,list,area)
    @list = list
    @time = 0
    @map_x = x
    @map_y = y
    @new_x = x
    @new_y = y
    @area = area
    if terrain == -1
      @terrain = 1
    elsif terrain.can_surf
      @terrain = 2
    elsif $PokemonEncounters.has_cave_encounters?
      @terrain = 1
    else
      @terrain = 0
    end
    @moving = false
    @viewport = viewport
    @map = map
    @species = species
    @form = form ? form : 0
    @lvl = lvl
    @sprite = IconSprite.new(0,0,@viewport)
    if @form > 0
      @sprite.setBitmap(sprintf("Graphics/Pokemon/Icons/%s_%d",species,@form))
    else
      @sprite.setBitmap(sprintf("Graphics/Pokemon/Icons/%s",species))
    end
    pbDayNightTint(@sprite)
    if @terrain == 0 # Grass
      @sprite.bitmap.fill_rect(0,50,128,14,Color.new(0,0,0,0))
      for y in 44...50
        for x in 0...128
          pixel = @sprite.bitmap.get_pixel(x,y)
          if pixel.alpha >= 250
            pixel.alpha *= 0.75
            pixel.alpha *= 0.75 if y >= 46
            pixel.alpha *= 0.75 if y >= 48
            @sprite.bitmap.set_pixel(x,y,pixel)
          end
        end
      end
    elsif @terrain == 1 # Cave
      shadow = Color.new(12,12,12,100)
      for y in 50...64
        min = y < 52 ? 24 :
             (y < 54 ? 20 :
             (y < 60 ? 18 :
             (y < 62 ? 20 : 22)))
        max = y < 52 ? 40 :
             (y < 54 ? 44 :
             (y < 60 ? 46 :
             (y < 62 ? 44 : 42)))
        for x in min...max
          if @sprite.bitmap.get_pixel(x,y).alpha < 10
            @sprite.bitmap.set_pixel(x,y,shadow)
          end
          if @sprite.bitmap.get_pixel(x+64,y).alpha < 10
            @sprite.bitmap.set_pixel(x+64,y,shadow)
          end
        end
      end
    elsif @terrain == 2 # Water
      if !OVERWORLD_WATER_ABOVE.include?(@species)
        if OVERWORLD_WATER_FLOAT.include?(@species)
          @sprite.bitmap.fill_rect(0,54,128,10,Color.new(0,0,0,0))
          for y in 50...54
            for x in 0...128
              pixel = @sprite.bitmap.get_pixel(x,y)
              if pixel.alpha >= 250
                pixel.alpha *= 0.6
                pixel.alpha *= 0.6 if y >= 42
                @sprite.bitmap.set_pixel(x,y,pixel)
              end
            end
          end
        else
          @sprite.bitmap.fill_rect(0,44,128,20,Color.new(0,0,0,0))
          for y in 40...44
            for x in 0...128
              pixel = @sprite.bitmap.get_pixel(x,y)
              if pixel.alpha >= 250
                pixel.alpha *= 0.6
                pixel.alpha *= 0.6 if y >= 42
                @sprite.bitmap.set_pixel(x,y,pixel)
              end
            end
          end
        end
      end
    end
    @sprite.src_rect = Rect.new(0,0,64,64)
    @sprite.ox = 32
    @sprite.oy = 32
    @mirror = rand(2)==0
    @mirror = false if OVERWORLD_NO_MIRROR.include?(@species)
    @lifetime = 600 + rand(300)
    @dead = false
    update
  end
  
  def encounter
    pbModifier.form = @form
    pbWildBattle(@species,@lvl)
  end
  
  def updateStill
    return if !@sprite || @sprite.disposed?
    @sprite.x = @map_x * 32 - (@map.display_x / 4) + 16
    @sprite.y = @map_y * 32 - (@map.display_y / 4)
    @sprite.y += 10 if @terrain == 2 # Water
    @sprite.mirror = @mirror
    @sprite.update
  end
  
  def update(willmove=true)
    @time += 1
    return if !@sprite || @sprite.disposed?
    @sprite.src_rect.x = ((@time % 30 < 15) ? 0 : 64)
    @sprite.x = @map_x * 32 - (@map.display_x / 4) + 16
    @sprite.y = @map_y * 32 - (@map.display_y / 4)
    @sprite.y += 10 if @terrain == 2 # Water
    @sprite.mirror = @mirror
    @sprite.z = screen_y_ground
    if !@moving
      @map_x = @new_x.round
      @map_y = @new_y.round
    end
    if @lifetime + 40 < @time
      @dead = true
    elsif @time <= 30
      @sprite.zoom_x = [@time / 30.0, 1].min
      @sprite.zoom_y = [@time / 30.0, 1].min
      @sprite.y += 20 - 20 * @time / 30
    elsif @lifetime < @time
      zoom = @time - @lifetime
      @sprite.zoom_x = [1.0 - zoom / 30.0, 0].max
      @sprite.zoom_y = [1.0 - zoom / 30.0, 0].max
      @sprite.y += 20 * zoom / 30
    elsif @moving && willmove && @lifetime - 30 > @time
      speed = 0.1
      if @new_x > @map_x
        @map_x += speed
        @moving = false if @map_x > @new_x
      elsif @new_x < @map_x
        @map_x -= speed
        @moving = false if @map_x < @new_x
      elsif @new_y > @map_y
        @map_y += speed
        @moving = false if @map_y > @new_y
      elsif @new_y < @map_y
        @map_y -= speed
        @moving = false if @map_y < @new_y
      end
    elsif willmove && (rand(60)==0) # will move
      dirs = []
      if @terrain==0 # Grass
        dirs.push(0) if @map.terrain_tag(@map_x,@map_y+1).shows_grass_rustle && !tileOccupied(@map_x,@map_y+1)
        dirs.push(1) if @map.terrain_tag(@map_x-1,@map_y).shows_grass_rustle && !tileOccupied(@map_x-1,@map_y)
        dirs.push(2) if @map.terrain_tag(@map_x+1,@map_y).shows_grass_rustle && !tileOccupied(@map_x+1,@map_y)
        dirs.push(3) if @map.terrain_tag(@map_x,@map_y-1).shows_grass_rustle && !tileOccupied(@map_x,@map_y-1)
      elsif @terrain==1 # Cave
        dirs.push(0) if @map.passable?(@map_x,map_y+1,8) && !tileOccupied(@map_x,@map_y+1)
        dirs.push(1) if @map.passable?(@map_x-1,map_y,6) && !tileOccupied(@map_x-1,@map_y)
        dirs.push(2) if @map.passable?(@map_x+1,map_y,4) && !tileOccupied(@map_x+1,@map_y)
        dirs.push(3) if @map.passable?(@map_x,map_y-1,2) && !tileOccupied(@map_x,@map_y-1)
      elsif @terrain==2 # Water
        dirs.push(0) if @map.terrain_tag(@map_x,@map_y+1).can_surf_freely && !tileOccupied(@map_x,@map_y+1)
        dirs.push(1) if @map.terrain_tag(@map_x-1,@map_y).can_surf_freely && !tileOccupied(@map_x-1,@map_y)
        dirs.push(2) if @map.terrain_tag(@map_x+1,@map_y).can_surf_freely && !tileOccupied(@map_x+1,@map_y)
        dirs.push(3) if @map.terrain_tag(@map_x,@map_y-1).can_surf_freely && !tileOccupied(@map_x,@map_y-1)
      end
      if dirs.length > 0
        dir = dirs[rand(dirs.length)]
        if dir == 0
          @new_x = @map_x
          @new_y = @map_y + 1
          @mirror = rand(2)==0 if !OVERWORLD_NO_MIRROR.include?(@species)
        elsif dir == 1
          @new_x = @map_x - 1
          @new_y = @map_y
          @mirror = false if !OVERWORLD_NO_MIRROR.include?(@species)
        elsif dir == 2
          @new_x = @map_x + 1
          @new_y = @map_y
          @mirror = true if !OVERWORLD_NO_MIRROR.include?(@species)
        elsif dir == 3
          @new_x = @map_x
          @new_y = @map_y - 1
          @mirror = rand(2)==0 if !OVERWORLD_NO_MIRROR.include?(@species)
        end
        @moving = true
      end
    end
    @sprite.update
  end
  
  def tileOccupied(x,y)
    for pkmn in @list
      if (pkmn.map_x.round == x && pkmn.map_y.round == y) ||
         (pkmn.new_x.round == x && pkmn.new_y.round == y)
        return true
      end
    end
    return false
  end

  def dispose
    @sprite.dispose
  end

  def screen_y_ground
    return @sprite.y + Game_Map::TILE_HEIGHT
  end
  
end

class SpawnArea
  
  attr_reader :map
  attr_reader :tiles
  attr_reader :x
  attr_reader :y
  attr_reader :width
  attr_reader :height
  attr_reader :pokemon
  attr_reader :terrain
  attr_reader :max_pkmn
  
  def initialize(viewport,map,terrain,x,y)
    @viewport= viewport
    @map     = map
    @terrain = terrain
    @pokemon = []
    @tiles   = []
    @x       = x
    @y       = y
    @width   = 1
    @height  = 1
    self.DFS(x,y)
    maxX=@x
    maxY=@y
    for tile in @tiles
      @x = tile[0] if @x > tile[0]
      @y = tile[1] if @y > tile[1]
      maxX = tile[0] if maxX < tile[0]
      maxY = tile[1] if maxY < tile[1]
    end
    @width = maxX - @x
    @height = maxY - @y
    divisor = 16.0
    if terrain == -1 || terrain.can_surf
      divisor = 24.0
    end
    @max_pkmn = (@tiles.length / divisor).ceil
  end
  
  def DFS(x,y)
    @tiles.push([x,y])
    for coord in [[x-1,y],[x+1,y],[x,y-1],[x,y+1]]
      x2 = coord[0]
      y2 = coord[1]
      next if x2 < 0 || x2 >= @map.width || y2 < 0 || y2 >= @map.height
      if (@terrain == -1 ?
          (@map.passable?(x2,y2,2) &&
           @map.passable?(x2,y2,4) &&
           @map.passable?(x2,y2,6) &&
           @map.passable?(x2,y2,8)) :
          @map.terrain_tag(x2,y2)==@terrain) &&
          !self.include?(x2,y2)
        self.DFS(x2,y2)
      end
    end
  end
  
  def include?(x,y)
    for tile in @tiles
      return true if tile[0]==x && tile[1]==y
    end
    return false
  end
  
  def inRange(x,y,xmax,ymax)
    xdist = 0
    ydist = 0
    if x < @x
      xdist = @x - x
    elsif x > @x + @width
      xdist = x - (@x + @width)
    end
    if y < @y
      ydist = @y - y
    elsif y > @y + @height
      ydist = y - (@y + @height)
    end
    return (xdist.abs <= xmax && ydist.abs <= ymax)
  end
  
  def updateSpawns
    return if !$Trainer || $Trainer.party.length <= 0
    if Graphics.frame_count % 6 == 0 && @pokemon.length < @max_pkmn
      tile = @tiles[rand(@tiles.length)]
      x = tile[0]
      y = tile[1]
      return if ($game_player.x - x).abs <= 1 && ($game_player.y - y).abs <= 1
      for pkmn in @pokemon
        if (pkmn.map_x.round == x && pkmn.map_y.round == y) ||
           (pkmn.new_x.round == x && pkmn.new_y.round == y)
          return
        end
      end
      encounterType = $PokemonEncounters.pbSpawnType(@terrain)
      return if encounterType == :None
      return if !$PokemonEncounters.has_encounter_type?(encounterType)
      encounter = $PokemonEncounters.choose_wild_pokemon(encounterType)
      return if !encounter
      if encounter[0] == :UNOWN && $game_variables[WILD_UNOWN_FORM].is_a?(Array)
        encounter[2] = $game_variables[WILD_UNOWN_FORM].shuffle[0]
      end
      pkmn = OverworldPokemon.new(@viewport,@map,encounter[0],encounter[1],encounter[2],
        x,y,@terrain,@pokemon,self)
      @pokemon.push(pkmn)
    end
  end
  
  def updateMovements(willmove)
    for i in 0...@pokemon.length
      pkmn = @pokemon[i]
      next if !pkmn
      pkmn.update(willmove)
      if pkmn.dead
        pkmn.dispose
        @pokemon.delete(pkmn)
      elsif (pkmn.map_x-$game_player.x)**2 + (pkmn.map_y-$game_player.y)**2 < 0.5
        return false if $DEBUG && Input.press?(Input::CTRL)
        return pkmn
      end
    end
    return false
  end
  
  def updateStill
    for i in 0...@pokemon.length
      @pokemon[i].updateStill
    end
  end
  
  def despawnPokemon
    for p in @pokemon
      p.dispose
    end
    @pokemon = []
  end
  
end

class Spriteset_Map
  
  def despawnPokemon
    for area in @spawn_areas
      area.despawnPokemon
    end
  end

  def initSpawnAreas
    $PokemonEncounters.setup(@map.map_id)
    count=0
    for y in 0...@map.height
      for x in 0...@map.width
        visited = false
        for area in @spawn_areas
          if area.include?(x,y)
            visited = true
            break
          end
        end
        if !visited
          tag = @map.terrain_tag(x,y,true)
          if tag.can_surf_freely && $PokemonEncounters.has_water_encounters?
            count+=1
            area = SpawnArea.new(@@viewport1,@map,tag,x,y)
            if area.tiles.length > 3
              @spawn_areas.push(area)
            end
          elsif $PokemonEncounters.has_cave_encounters? &&
              @map.passable?(x,y,2) &&
              @map.passable?(x,y,4) &&
              @map.passable?(x,y,6) &&
              @map.passable?(x,y,8)
            count+=1
            area = SpawnArea.new(@@viewport1,@map,-1,x,y)
            if area.tiles.length > 6
              @spawn_areas.push(area)
            end
          elsif tag.land_wild_encounters && $PokemonEncounters.has_land_encounters?
            count+=1
            area = SpawnArea.new(@@viewport1,@map,tag,x,y)
            if area.tiles.length > 3
              @spawn_areas.push(area)
            end
          elsif tag.land2_wild_encounters && $PokemonEncounters.has_land2_encounters?
            count+=1
            area = SpawnArea.new(@@viewport1,@map,tag,x,y)
            if area.tiles.length > 3
              @spawn_areas.push(area)
            end
          elsif tag.land3_wild_encounters && $PokemonEncounters.has_land3_encounters?
            count+=1
            area = SpawnArea.new(@@viewport1,@map,tag,x,y)
            if area.tiles.length > 3
              @spawn_areas.push(area)
            end
          elsif tag.land4_wild_encounters && $PokemonEncounters.has_land4_encounters?
            count+=1
            area = SpawnArea.new(@@viewport1,@map,tag,x,y)
            if area.tiles.length > 3
              @spawn_areas.push(area)
            end
          elsif tag.flower_wild_encounters && $PokemonEncounters.has_flower_encounters?
            count+=1
            area = SpawnArea.new(@@viewport1,@map,tag,x,y)
            if area.tiles.length > 3
              @spawn_areas.push(area)
            end
          end
        end
      end
    end
  end
  
  def updateOverworldPokemon
    return if $game_temp.in_menu
    if $game_system.map_interpreter.running? ||
           $game_player.move_route_forcing ||
           $game_temp.message_window_showing ||
           $PokemonTemp.miniupdate
      for area in @spawn_areas
        area.updateStill
      end
      return
    end
    for area in @spawn_areas
      if area.inRange($game_player.x,$game_player.y,13,11)
        area.updateSpawns
        if area.inRange($game_player.x,$game_player.y,9,7)
          pkmn=area.updateMovements(!@wild_battle_pending)
          @wild_battle_pkmn.update(false) if @wild_battle_pkmn
          if pkmn && !@wild_battle_pending
            @wild_battle_pending = true
            @wild_battle_pkmn = pkmn
          elsif @wild_battle_pending && @wild_battle_pkmn
            if !@in_wild_battle && !$game_player.moving?
              @in_wild_battle = true
              @wild_battle_pkmn.encounter
              @wild_battle_pending = false
              @in_wild_battle = false
              @wild_battle_pkmn = false
            end
          else
            @wild_battle_pending = false
            @in_wild_battle = false
            @wild_battle_pkmn = false
          end
        else
          area.updateMovements(false)
        end
      else
        area.despawnPokemon
      end
    end
  end
end

class PokemonEncounters

  def pbSpawnType(terrain)
    if self.has_water_encounters? && terrain.can_surf_freely
      return :Water
    elsif self.has_cave_encounters?
      return :Cave
    elsif self.has_land_encounters? && terrain.land_wild_encounters && terrain.shows_dust_particle
      return :Land
    elsif self.has_land_encounters? && terrain.land_wild_encounters
      return :Land
    elsif self.has_land2_encounters? && terrain.land2_wild_encounters
      return :Land2
    elsif self.has_land3_encounters? && terrain.land3_wild_encounters
      return :Land3
    elsif self.has_land4_encounters? && terrain.land4_wild_encounters
      return :Land4
    elsif self.has_flower_encounters? && terrain.flower_wild_encounters
      return :Flowers
    elsif self.has_swamp_encounters? && terrain.swamp_wild_encounters
      return :Swamp
    end
    return :None
  end

  def isSpawnPossibleHere?(terrain)
    if $PokemonGlobal && $PokemonGlobal.surfing
      return true
    elsif terrain.ice
      return false
    elsif self.has_cave_encounters?
      return true
    elsif self.has_land_encounters? && terrain.land_wild_encounters && terrain.shows_dust_particle
      return true
    elsif self.has_land_encounters? && terrain.land_wild_encounters
      return true
    elsif self.has_land2_encounters? && terrain.land2_wild_encounters
      return true
    elsif self.has_land3_encounters? && terrain.land3_wild_encounters
      return true
    elsif self.has_land4_encounters? && terrain.land4_wild_encounters
      return true
    elsif self.has_flower_encounters? && terrain.flower_wild_encounters
      return true
    elsif self.has_swamp_encounters? && terrain.swamp_wild_encounters
      return true
    end
    return false
  end

  def has_land2_encounters?
    GameData::EncounterType.each do |enc_type|
      next if ![:land2].include?(enc_type.type)
      return true if has_encounter_type?(enc_type.id)
    end
    return false
  end

  def has_land3_encounters?
    GameData::EncounterType.each do |enc_type|
      next if ![:land3].include?(enc_type.type)
      return true if has_encounter_type?(enc_type.id)
    end
    return false
  end

  def has_land4_encounters?
    GameData::EncounterType.each do |enc_type|
      next if ![:land4].include?(enc_type.type)
      return true if has_encounter_type?(enc_type.id)
    end
    return false
  end

  def has_swamp_encounters?
    GameData::EncounterType.each do |enc_type|
      next if ![:swamp].include?(enc_type.type)
      return true if has_encounter_type?(enc_type.id)
    end
    return false
  end

  def has_flower_encounters?
    GameData::EncounterType.each do |enc_type|
      next if ![:flower].include?(enc_type.type)
      return true if has_encounter_type?(enc_type.id)
    end
    return false
  end

end