class Window_CustomFrame < Window_DrawableCommand
  def initialize(x,y,width,height,viewport)
    @commands = []
    super(x,y,width,height,viewport)
    @selarrow     = AnimatedBitmap.new("Graphics/Pictures/CustomPokemon/cursor_list")
    @icon_on  = AnimatedBitmap.new("Graphics/Pictures/CustomPokemon/icon_on")
    self.baseColor   = Color.new(88,88,80)
    self.shadowColor = Color.new(168,184,184)
    self.windowskin  = nil
  end

  def commands=(value)
    @commands = value
    refresh
  end

  def dispose
    @icon_on.dispose
    super
  end

  def item
    return (@commands.length==0) ? 0 : @commands[self.index]
  end

  def itemCount
    return @commands.length
  end

  def drawItem(index,_count,rect)
    return if index>=self.top_row+self.page_item_max
    rect = Rect.new(rect.x+16,rect.y,rect.width-16,rect.height)
    if @commands[index] == pbCustomPokemon.frame
      pbCopyBitmap(self.contents,@icon_on.bitmap,rect.x-6,rect.y+8)
    end
    text = _INTL("{1} Frame", PBFrame.getName(@commands[index]))
    pbDrawShadowText(self.contents,rect.x+32,rect.y+6,rect.width,rect.height,
       text,self.baseColor,self.shadowColor)
  end

  def refresh
    @item_max = itemCount
    dwidth  = self.width-self.borderX
    dheight = self.height-self.borderY
    self.contents = pbDoEnsureBitmap(self.contents,dwidth,dheight)
    self.contents.clear
    for i in 0...@item_max
      next if i<self.top_item || i>self.top_item+self.page_item_max
      drawItem(i,@item_max,itemRect(i))
    end
    drawCursor(self.index,itemRect(self.index))
  end

  def update
    super
    @uparrow.visible   = false
    @downarrow.visible = false
  end
end

class Window_CustomMemory < Window_DrawableCommand
  def initialize(x,y,width,height,viewport)
    @commands = []
    super(x,y,width,height,viewport)
    @selarrow        = AnimatedBitmap.new("Graphics/Pictures/CustomPokemon/cursor_list")
    @icon_on         = AnimatedBitmap.new("Graphics/Pictures/CustomPokemon/icon_on")
    @typebitmap      = AnimatedBitmap.new(_INTL("Graphics/Pictures/types"))
    self.baseColor   = Color.new(88,88,80)
    self.shadowColor = Color.new(168,184,184)
    self.windowskin  = nil
  end

  def commands=(value)
    @commands = value
    refresh
  end

  def dispose
    @icon_on.dispose
    @typebitmap.dispose
    super
  end

  def item
    return (@commands.length==0) ? 0 : @commands[self.index]
  end

  def itemCount
    return @commands.length
  end

  def drawItem(index,_count,rect)
    return if index>=self.top_row+self.page_item_max
    rect = Rect.new(rect.x+16,rect.y,rect.width-16,rect.height)
    if @commands[index] == pbCustomPokemon.type
      pbCopyBitmap(self.contents,@icon_on.bitmap,rect.x-6,rect.y+8)
    end
    type_number = GameData::Type.get(@commands[index]).id_number
    type_rect = Rect.new(0, type_number * 28, 64, 28)
    self.contents.blt(rect.x + 22, rect.y+8, @typebitmap.bitmap, type_rect)
    text = "Memory"
    pbDrawShadowText(self.contents,rect.x+92,rect.y+6,rect.width,rect.height,
       text,self.baseColor,self.shadowColor)
  end

  def refresh
    @item_max = itemCount
    dwidth  = self.width-self.borderX
    dheight = self.height-self.borderY
    self.contents = pbDoEnsureBitmap(self.contents,dwidth,dheight)
    self.contents.clear
    for i in 0...@item_max
      next if i<self.top_item || i>self.top_item+self.page_item_max
      drawItem(i,@item_max,itemRect(i))
    end
    drawCursor(self.index,itemRect(self.index))
  end

  def update
    super
    @uparrow.visible   = false
    @downarrow.visible = false
  end
end

class Window_CustomChips < Window_DrawableCommand
  attr_accessor :in_submenu

  def initialize(x,y,width,height,viewport)
    @commands = []
    super(x,y,width,height,viewport)
    @selarrow     = AnimatedBitmap.new("Graphics/Pictures/CustomPokemon/cursor_list")
    @icon_on  = AnimatedBitmap.new("Graphics/Pictures/CustomPokemon/icon_on")
    self.baseColor   = Color.new(88,88,80)
    self.shadowColor = Color.new(168,184,184)
    self.windowskin  = nil
    self.in_submenu  = false
  end

  def commands=(value)
    @commands = value
    refresh
  end

  def dispose
    @icon_on.dispose
    super
  end

  def item
    return (@commands.length==0) ? 0 : @commands[self.index]
  end

  def itemCount
    return @commands.length
  end

  def drawItem(index,_count,rect)
    return if index>=self.top_row+self.page_item_max
    rect = Rect.new(rect.x+16,rect.y,rect.width-16,rect.height)
    if pbCustomPokemon.chips.include?(@commands[index])
      pbCopyBitmap(self.contents,@icon_on.bitmap,rect.x-6,rect.y+8)
    end
    text = _INTL("{1} {2}", PBChip.getName(@commands[index]), @commands[index]==0 ? "" : "Chip")
    pbDrawShadowText(self.contents,rect.x+32,rect.y+6,rect.width,rect.height,
       text,self.baseColor,self.shadowColor)
  end

  def refresh
    @item_max = itemCount
    dwidth  = self.width-self.borderX
    dheight = self.height-self.borderY
    self.contents = pbDoEnsureBitmap(self.contents,dwidth,dheight)
    self.contents.clear
    for i in 0...@item_max
      next if i<self.top_item || i>self.top_item+self.page_item_max
      drawItem(i,@item_max,itemRect(i))
    end
    drawCursor(self.index,itemRect(self.index))
  end

  def update
    super
    @uparrow.visible   = false
    @downarrow.visible = false
  end
end

#===============================================================================
#
#===============================================================================
class CustomPokemon_Scene
  def pbStartScene()
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    @page = 1
    @typebitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/types"))
    @species = :SILVALLY
    @custom = pbCustomPokemon
    @sprites = {}
    @sprites["background"] = IconSprite.new(0,0,@viewport)
    @sprites["infosprite"] = PokemonSprite.new(@viewport)
    @sprites["infosprite"].setOffset(PictureOrigin::Bottom)
    @sprites["infosprite"].x = Graphics.width / 2 + 12
    @sprites["infosprite"].y = Graphics.height / 2 + 80
    @sprites["overlay"] = BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    @sprites["choose_frame"] = Window_CustomFrame.new(0, 26, 240, 280, @viewport)
    @sprites["choose_memory"] = Window_CustomMemory.new(0, 26, 240, 510, @viewport)
    @sprites["choose_chips"] = Window_CustomChips.new(0, 26, 240, 300, @viewport)
    @sprites["control_exit"] = KeybindSprite.new(Input::BACK, "Exit", 248, Graphics.height - 32, @viewport)
    @sprites["control_page"] = KeybindSprite.new([Input::UP, Input::DOWN], "Change Option", 328, Graphics.height - 32, @viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    pbUpdateDummyPokemon
    drawPage(@page)
    pbFadeInAndShow(@sprites) { pbUpdate }
  end

  def pbEndScene
    pbCustomPokemon.update
    pbFadeOutAndHide(@sprites) { pbUpdate }
    pbDisposeSpriteHash(@sprites)
    @typebitmap.dispose
    @viewport.dispose
  end

  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end

  def pbUpdateDummyPokemon
    @species = :SILVALLY
    @gender = 0
    @form = @custom.form
    species_data = GameData::Species.get_species_form(@species, @form)
    @sprites["infosprite"].setSpeciesBitmap(@species,@gender,@form)
  end

  def drawPage(page)
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    # Draw page-specific information
    @sprites["choose_frame"].visible = (page == 1)
    @sprites["choose_frame"].active  = (page == 1)
    @sprites["choose_memory"].visible = (page == 2)
    @sprites["choose_memory"].active  = (page == 2)
    @sprites["choose_chips"].visible = (page == 3)
    @sprites["choose_chips"].active  = (page == 3)
    drawPageAll
    case page
    when 1 then drawPageFrame
    when 2 then drawPageMemory
    when 3 then drawPageChips
    end
  end

  def drawPageAll
      overlay = @sprites["overlay"].bitmap
      base   = Color.new(88, 88, 80)
      shadow = Color.new(168,184,184)
      base2  = Color.new(248,248,248)
      shadow2= Color.new(104,104,104)
      imagepos = []
      species_data = GameData::Species.get_species_form(@species, @custom.form)
      # Write various bits of text
      indexText = sprintf("%03d", GameData::Species.get(@species).id_number)
      smalltextpos = []
      textpos = [
          [_INTL("{1}{2} {3}", indexText, " ", @custom.name),
            498, 40, 0, Color.new(248, 248, 248), Color.new(0, 0, 0)],
          [_INTL("Height"), 564, 454, 0, base, shadow],
          [_INTL("Weight"), 564, 486, 0, base, shadow]
      ]
      # Draw the type icon(s)
      type1 = @custom.type
      type2 = @custom.type
      affinity = @custom.affinity
      type1_number = GameData::Type.get(type1).id_number
      type2_number = GameData::Type.get(type2).id_number
      affinity_number = GameData::Type.get(affinity).id_number
      type1rect = Rect.new(0, type1_number * 28, 64, 28)
      type2rect = Rect.new(0, type2_number * 28, 64, 28)
      affinity_rect = Rect.new(0, affinity_number * 28, 64, 28)
      if type1 == type2
        overlay.blt(550+34+48, 152, @typebitmap.bitmap, type1rect)
      else
        overlay.blt(550+48, 152, @typebitmap.bitmap, type1rect)
        overlay.blt(550+68+48, 152, @typebitmap.bitmap, type2rect)
      end
      overlay.blt(550+34+48, 152+64, @typebitmap.bitmap, affinity_rect)

      basestats = @custom.base_stats
      posY = 270
      smalltextpos += [
        [_INTL("HP"),628,posY,2,base2,shadow2],
        [sprintf("%d",basestats[:HP]),716,posY,2,base,shadow],
        [_INTL("Attack"),628,posY+28*1,2,base2,shadow2],
        [sprintf("%d",basestats[:ATTACK]),716,posY+28*1,2,base,shadow],
        [_INTL("Defense"),628,posY+28*2,2,base2,shadow2],
        [sprintf("%d",basestats[:DEFENSE]),716,posY+28*2,2,base,shadow],
        [_INTL("Sp. Atk"),628,posY+28*3,2,base2,shadow2],
        [sprintf("%d",basestats[:SPECIAL_ATTACK]),716,posY+28*3,2,base,shadow],
        [_INTL("Sp. Def"),628,posY+28*4,2,base2,shadow2],
        [sprintf("%d",basestats[:SPECIAL_DEFENSE]),716,posY+28*4,2,base,shadow],
        [_INTL("Speed"),628,posY+28*5,2,base2,shadow2],
        [sprintf("%d",basestats[:SPEED]),716,posY+28*5,2,base,shadow]
      ]
      # Write the category
      textpos.push([_INTL("{1} Pokémon", @custom.category), 498, 72, 0, base, shadow])
      # Write the height and weight
      height = @custom.height
      weight = @custom.weight
      if System.user_language[3..4] == "US"   # If the user is in the United States
        inches = (height / 0.254).round
        pounds = (weight / 0.45359).round
        textpos.push([_ISPRINTF("{1:d}'{2:02d}\"", inches / 12, inches % 12), 746, 454, 1, base, shadow])
        textpos.push([_ISPRINTF("{1:4.1f} lbs.", pounds / 10.0), 746, 486, 1, base, shadow])
      else
        textpos.push([_ISPRINTF("{1:.1f} m", height / 10.0), 746, 454, 1, base, shadow])
        textpos.push([_ISPRINTF("{1:.1f} kg", weight / 10.0), 746, 486, 1, base, shadow])
      end
      # Draw all text
      pbSetSmallFont(overlay)
      pbDrawTextPositions(overlay, smalltextpos)
      # Draw all text
      pbSetSystemFont(overlay)
      pbDrawTextPositions(overlay, textpos)
      # Draw all images
      pbDrawImagePositions(overlay, imagepos)
  end

  def drawPageFrame
    @sprites["background"].setBitmap(_INTL("Graphics/Pictures/CustomPokemon/bg_frame"))
    commands = []
    for i in 0...PBFrame.len
      commands.push(i) if @custom.available_frames.include?(i)
    end
    @sprites["choose_frame"].commands = commands
    smalltextpos = []
    overlay = @sprites["overlay"].bitmap
    base   = Color.new(88, 88, 80)
    shadow = Color.new(168,184,184)
    base2  = Color.new(248,248,248)
    shadow2= Color.new(104,104,104)
    statmods = PBFrame.getMods(@sprites["choose_frame"].item)
    statstrings = []
    for i in 0...6
      if statmods[i] == 0
        statstrings.push("-")
      elsif statmods[i] > 0
        statstrings.push(_INTL("+{1}", statmods[i]))
      else
        statstrings.push(statmods[i].to_s)
      end
    end
    posY = 350
    smalltextpos += [
      [_INTL("HP"),76,posY,2,base2,shadow2],
      [sprintf("%s",statstrings[0]),164,posY,2,base,shadow],
      [_INTL("Attack"),76,posY+28*1,2,base2,shadow2],
      [sprintf("%s",statstrings[1]),164,posY+28*1,2,base,shadow],
      [_INTL("Defense"),76,posY+28*2,2,base2,shadow2],
      [sprintf("%s",statstrings[2]),164,posY+28*2,2,base,shadow],
      [_INTL("Sp. Atk"),76,posY+28*3,2,base2,shadow2],
      [sprintf("%s",statstrings[4]),164,posY+28*3,2,base,shadow],
      [_INTL("Sp. Def"),76,posY+28*4,2,base2,shadow2],
      [sprintf("%s",statstrings[5]),164,posY+28*4,2,base,shadow],
      [_INTL("Speed"),76,posY+28*5,2,base2,shadow2],
      [sprintf("%s",statstrings[3]),164,posY+28*5,2,base,shadow]
    ]
    # Draw all text
    pbSetSmallFont(overlay)
    pbDrawTextPositions(overlay, smalltextpos)
  end

  def drawPageMemory
    @sprites["background"].setBitmap(_INTL("Graphics/Pictures/CustomPokemon/bg_memory"))
    commands = []
    for key in GameData::Type.keys
      if key.is_a?(Symbol) && key != :QMARKS
        commands.push(key)
      end
    end
    @sprites["choose_memory"].commands = commands
    return
    overlay = @sprites["overlay"].bitmap
    base   = Color.new(88,88,80)
    shadow = Color.new(168,184,184)
    @sprites["areahighlight"].bitmap.clear
    # Fill the array "points" with all squares of the region map in which the
    # species can be found
    points = []
    mapwidth = 1+PokemonRegionMap_Scene::RIGHT-PokemonRegionMap_Scene::LEFT
    GameData::Encounter.each_of_version($PokemonGlobal.encounter_version) do |enc_data|
      next if !pbFindEncounter(enc_data.types, @species)
      map_metadata = GameData::MapMetadata.try_get(enc_data.map)
      mappos = (map_metadata) ? map_metadata.town_map_position : nil
      next if !mappos || mappos[0] != @region
      showpoint = true
      for loc in @mapdata[@region][2]
        showpoint = false if loc[0]==mappos[1] && loc[1]==mappos[2] &&
                              loc[7] && !$game_switches[loc[7]]
      end
      next if !showpoint
      mapsize = map_metadata.town_map_size
      if mapsize && mapsize[0] && mapsize[0]>0
        sqwidth  = mapsize[0]
        sqheight = (mapsize[1].length*1.0/mapsize[0]).ceil
        for i in 0...sqwidth
          for j in 0...sqheight
            if mapsize[1][i+j*sqwidth,1].to_i>0
              points[mappos[1]+i+(mappos[2]+j)*mapwidth] = true
            end
          end
        end
      else
        points[mappos[1]+mappos[2]*mapwidth] = true
      end
    end
    # Draw coloured squares on each square of the region map with a nest
    pointcolor   = Color.new(0,248,248)
    pointcolorhl = Color.new(192,248,248)
    sqwidth = PokemonRegionMap_Scene::SQUAREWIDTH
    sqheight = PokemonRegionMap_Scene::SQUAREHEIGHT
    for j in 0...points.length
      if points[j]
        x = (j%mapwidth)*sqwidth
        x += (512+256-@sprites["areamap"].bitmap.width)/2
        y = (j/mapwidth)*sqheight
        y += (384+96-@sprites["areamap"].bitmap.height)/2
        @sprites["areahighlight"].bitmap.fill_rect(x,y,sqwidth,sqheight,pointcolor)
        if j-mapwidth<0 || !points[j-mapwidth]
          @sprites["areahighlight"].bitmap.fill_rect(x,y-2,sqwidth,2,pointcolorhl)
        end
        if j+mapwidth>=points.length || !points[j+mapwidth]
          @sprites["areahighlight"].bitmap.fill_rect(x,y+sqheight,sqwidth,2,pointcolorhl)
        end
        if j%mapwidth==0 || !points[j-1]
          @sprites["areahighlight"].bitmap.fill_rect(x-2,y,2,sqheight,pointcolorhl)
        end
        if (j+1)%mapwidth==0 || !points[j+1]
          @sprites["areahighlight"].bitmap.fill_rect(x+sqwidth,y,2,sqheight,pointcolorhl)
        end
      end
    end
    # Set the text
    textpos = []
    if points.length==0
      pbDrawImagePositions(overlay,[
          [sprintf("Graphics/Pictures/Pokedex/overlay_areanone"),108+128,188+32]
      ])
      textpos.push([_INTL("Area unknown"),Graphics.width/2,384/2 + 32 - 6,2,base,shadow])
    end
    textpos.push([pbGetMessage(MessageTypes::RegionNames,@region),414+128,38+32,2,base,shadow])
    textpos.push([_INTL("{1}'s area",GameData::Species.get(@species).name),
        Graphics.width/2,346+32,2,base,shadow])
    pbDrawTextPositions(overlay,textpos)
  end

  def drawPageChips
    @sprites["background"].setBitmap(_INTL("Graphics/Pictures/CustomPokemon/bg_chips"))
    commands = []
    for i in 1...PBChip.len
      if @custom.available_chip_types.include?(PBChip.getType(i))
        commands.push(i)
      end
    end
    @sprites["choose_chips"].commands = commands
    overlay = @sprites["overlay"].bitmap
    base   = Color.new(88, 88, 80)
    shadow = Color.new(168,184,184)
    base2  = Color.new(248,248,248)
    shadow2= Color.new(104,104,104)
    smalltextpos = []
    textpos = [
        [_INTL("{1}/{2} Equipped", @custom.total_chips, @custom.max_chips),
          358, 40, 1, base, shadow]
    ]
    statmods = PBChip.getMods(@sprites["choose_chips"].item)
    if @custom.frame == PBFrame::RKS
      for i in 0...6
        statmods[i] *= 2
      end
    end
    statstrings = []
    for i in 0...6
      if statmods[i] == 0
        statstrings.push("-")
      elsif statmods[i] > 0
        statstrings.push(_INTL("+{1}", statmods[i]))
      else
        statstrings.push(statmods[i].to_s)
      end
    end
    posY = 350
    smalltextpos += [
      [_INTL("HP"),76,posY,2,base2,shadow2],
      [sprintf("%s",statstrings[0]),164,posY,2,base,shadow],
      [_INTL("Attack"),76,posY+28*1,2,base2,shadow2],
      [sprintf("%s",statstrings[1]),164,posY+28*1,2,base,shadow],
      [_INTL("Defense"),76,posY+28*2,2,base2,shadow2],
      [sprintf("%s",statstrings[2]),164,posY+28*2,2,base,shadow],
      [_INTL("Sp. Atk"),76,posY+28*3,2,base2,shadow2],
      [sprintf("%s",statstrings[4]),164,posY+28*3,2,base,shadow],
      [_INTL("Sp. Def"),76,posY+28*4,2,base2,shadow2],
      [sprintf("%s",statstrings[5]),164,posY+28*4,2,base,shadow],
      [_INTL("Speed"),76,posY+28*5,2,base2,shadow2],
      [sprintf("%s",statstrings[3]),164,posY+28*5,2,base,shadow]
    ]
    # Draw all text
    pbSetSmallFont(overlay)
    pbDrawTextPositions(overlay, smalltextpos)
    pbSetSystemFont(overlay)
    pbDrawTextPositions(overlay, textpos)
  end

  def pbScene
    Pokemon.play_cry(@species, @form)
    loop do
      Graphics.update
      Input.update
      pbUpdate
      dorefresh = false
      if Input.trigger?(Input::BACK)
        pbPlayCloseMenuSE
        break
      elsif Input.trigger?(Input::USE)
        if @page==1
          @custom.frame = @sprites["choose_frame"].item
          dorefresh = true
        elsif @page==2
          @custom.type = @sprites["choose_memory"].item
          @custom.affinity = @custom.type
          dorefresh = true
        elsif @page==3
          chip = @sprites["choose_chips"].item
          if @custom.chips.include?(chip)
            for i in 0...@custom.chips.length
              if @custom.chips[i] == chip
                @custom.chips[i] = PBChip::None
                break
              end
            end
          else
            if @custom.chips[0] == PBChip::None
              @custom.chips[0] = chip
            elsif @custom.max_chips >= 2 && @custom.chips[1] == PBChip::None
              @custom.chips[1] = chip
            else
              if @custom.max_chips >= 2
                pbMessage(_INTL(
                  "Do you want to replace a chip for this chip?\\ch[1,3,{1},{2},No]",
                    PBChip.getName(@custom.chips[0]),
                    PBChip.getName(@custom.chips[1])))
                if $game_variables[1] < 2
                  @custom.chips[$game_variables[1]] = chip
                end
              else
                @custom.chips[0] = chip
              end
            end
          end
          dorefresh = true
        end
      elsif Input.repeat?(Input::UP)
        dorefresh = true
      elsif Input.repeat?(Input::DOWN)
        dorefresh = true
      elsif Input.trigger?(Input::LEFT)
        oldpage = @page
        @page -= 1
        @page = 1 if @page<1
        @page = 3 if @page>3
        if @page!=oldpage
          pbPlayCursorSE
          dorefresh = true
        end
      elsif Input.trigger?(Input::RIGHT)
        oldpage = @page
        @page += 1
        @page = 1 if @page<1
        @page = 3 if @page>3
        if @page!=oldpage
          pbPlayCursorSE
          dorefresh = true
        end
      end
      if dorefresh
        pbUpdateDummyPokemon
        drawPage(@page)
      end
    end
    return @index
  end
end

#===============================================================================
#
#===============================================================================
class CustomPokemonScreen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen()
    @scene.pbStartScene()
    ret = @scene.pbScene
    @scene.pbEndScene
    return ret
  end
end

def pbCustomPokemonScreen
  pbFadeOutIn {
    scene=CustomPokemon_Scene.new
    screen=CustomPokemonScreen.new(scene)
    screen.pbStartScreen()
  }
end