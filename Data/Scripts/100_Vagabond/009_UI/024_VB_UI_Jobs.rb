#===============================================================================
#
#===============================================================================

class Window_Jobs < Window_DrawableCommand
  def initialize(items,x,y,width,height,viewport=nil)
    @items = items
    super(x, y, width, height, viewport)
    @selarrow=AnimatedBitmap.new("Graphics/Pictures/Trainer Card/cursor")
    @baseColor=Color.new(88,88,80)
    @shadowColor=Color.new(168,184,184)
    self.windowskin=nil
  end

  def itemCount
    return @items.length
  end

  def item
    return self.index >= @items.length ? 0 : @items[self.index]
  end

  def drawItem(index,count,rect)
    textpos=[]
    rect=drawCursor(index,rect)
    ypos=rect.y
    itemname=@items[index]
    textpos.push([itemname,rect.x,ypos-4,false,self.baseColor,self.shadowColor])
    pbDrawTextPositions(self.contents,textpos)
  end
end


class PokemonJobs_Scene
  def pbStartScene
    @index = 0
    @debug_count = 0
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    background = pbResolveBitmap(sprintf("Graphics/Pictures/Trainer Card/bg_f"))
    if ($Trainer.female? || $game_switches[GPO_MEMBER]) && background
      addBackgroundPlane(@sprites,"bg","Trainer Card/bg_f",@viewport)
    else
      addBackgroundPlane(@sprites,"bg","Trainer Card/bg",@viewport)
    end
    cardexists = pbResolveBitmap(sprintf("Graphics/Pictures/Trainer Card/card_f"))
    @jobs = ["Trainer", "Stats"]
    for job in pbJobs
      if job.level > 0
        @jobs.push(job.name)
      end
    end
    @sprites["listbg"] = IconSprite.new(0,48,@viewport)
    @sprites["listbg"].setBitmap("Graphics/Pictures/Trainer Card/list")
    @sprites["itemlist"]=Window_Jobs.new(@jobs, -12, 54, 264, Graphics.height - 56)
    @sprites["itemlist"].viewport = @viewport
    @sprites["itemlist"].index = @index
    @sprites["itemlist"].baseColor = Color.new(252, 252, 252)
    @sprites["itemlist"].shadowColor = Color.new(0, 0, 0)
    @sprites["itemlist"].refresh
    spacing = 0
    for i in 0...([@jobs.length, 5].min)
      pos_y = 128 - spacing
      spacing += 48 - i * 12
      @sprites[_INTL("card_{1}", i)] = IconSprite.new(228,pos_y,@viewport)
      @sprites[_INTL("card_{1}", i)].z = 9 - i * 2
      @sprites[_INTL("overlay_{1}", i)] = BitmapSprite.new(512,384,@viewport)
      @sprites[_INTL("overlay_{1}", i)].x = 228
      @sprites[_INTL("overlay_{1}", i)].y = pos_y
      @sprites[_INTL("overlay_{1}", i)].z = 10 - i * 2
      pbSetSystemFont(@sprites[_INTL("overlay_{1}", i)].bitmap)
    end
    #@sprites["trainer"] = IconSprite.new(336+228,124+96,@viewport)
    #@sprites["trainer"].setBitmap(GameData::TrainerType.player_front_sprite_filename($Trainer.trainer_type))
    #@sprites["trainer"].x -= (@sprites["trainer"].bitmap.width-128)/2
    #@sprites["trainer"].y -= (@sprites["trainer"].bitmap.height-128)
    #@sprites["trainer"].z = 2
    pbRefresh
    pbFadeInAndShow(@sprites) { pbUpdate }
  end
  
  def pbUpdate
    pbUpdateSpriteHash(@sprites)
    if @index != @sprites["itemlist"].index
      @index = @sprites["itemlist"].index
      pbRefresh
    end
  end

  def pbRefresh
    for i in 0...([@jobs.length, 5].min)
      card = @sprites[_INTL("card_{1}", i)]
      overlay = (i > 1) ? nil : @sprites[_INTL("overlay_{1}", i)]
      job = @jobs[(@index+i) % @sprites["itemlist"].itemCount]
      case job
      when "Trainer"
        pbDrawTrainerCard(card, overlay)
      when "Stats"
        pbDrawStats(card, overlay)
      else
        pbDrawJob(job, card, overlay)
      end
    end
  end

  def pbGetQuestProgress
    return [0, 0]
    count = $game_variables[QUEST_ARRAY].length
    complete = 0
    for i in 1..count
      if $game_variables[QUEST_ARRAY][i-1].status == 2
        complete += 1
      end
    end
    return [complete, count]
  end

  def pbDrawTrainerCard(card, overlay)
    if $game_switches[GPO_MEMBER]
      card.setBitmap("Graphics/Pictures/Trainer Card/card_gpo")
    else
      if $Trainer.female? && cardexists
        card.setBitmap("Graphics/Pictures/Trainer Card/card_f")
      else
        card.setBitmap("Graphics/Pictures/Trainer Card/card")
      end
    end
    return if !overlay
    #@sprites["trainer"].visible=true
    overlay.bitmap.clear
    baseColor   = Color.new(72,72,72)
    shadowColor = Color.new(160,160,160)
    totalsec = Graphics.frame_count / Graphics.frame_rate
    hour = totalsec / 60 / 60
    min = totalsec / 60 % 60
    time = (hour>0) ? _INTL("{1}h {2}m",hour,min) : _INTL("{1}m",min)
    $PokemonGlobal.startTime = pbGetTimeNow if !$PokemonGlobal.startTime
    starttime = _INTL("{1} {2}, {3}",
       pbGetAbbrevMonthName($PokemonGlobal.startTime.mon),
       $PokemonGlobal.startTime.day,
       $PokemonGlobal.startTime.year)
    textPositions = [
       [_INTL("Name"),34,58,0,baseColor,shadowColor],
       [$Trainer.name,302,58,1,baseColor,shadowColor],
       [_INTL("ID No."),332,58,0,baseColor,shadowColor],
       [sprintf("%05d",$Trainer.public_ID),468,58,1,baseColor,shadowColor],
       [_INTL("Money"),34,106,0,baseColor,shadowColor],
       [_INTL("${1}",$Trainer.money.to_s_formatted),302,106,1,baseColor,shadowColor],
       [_INTL("Pokédex"),34,154,0,baseColor,shadowColor],
       [sprintf("%d/%d",$Trainer.pokedex.owned_count,$Trainer.pokedex.seen_count),302,154,1,baseColor,shadowColor],
       [_INTL("Time"),34,202,0,baseColor,shadowColor],
       [time,302,202,1,baseColor,shadowColor],
       [_INTL("Started"),34,250,0,baseColor,shadowColor],
       [starttime,302,250,1,baseColor,shadowColor]
    ]
    if $game_switches[GPO_MEMBER]
      count = $game_variables[MINIQUESTCOUNT]
      name=""
      if count==0
        name="Newbie"
      elsif count==1
        name="Beginner"
      elsif count < 6
        name="Novice"
      elsif count < 12
        name="Competent"
      elsif count < 20
        name="Proficient"
      elsif count < 30
        name="Expert"
      elsif count < 100
        name="Elite"
      elsif count < 1000
        name="Master"
      else
        name="Why?"
      end
      textPositions.push([name,424,250,2,baseColor,shadowColor])
    end
    pbDrawTextPositions(overlay.bitmap,textPositions)
    x = 42
    region = pbGetCurrentRegion(0) # Get the current region
    imagePositions = []
    for i in $Trainer.badges
      imagePositions.push(["Graphics/Pictures/Trainer Card/icon_badges",x,310,i*32,region*32,32,32])
      x += 44
    end
    pbDrawImagePositions(overlay.bitmap,imagePositions)
  end
  
  def pbDrawStats(card, overlay)
    if $game_switches[GPO_MEMBER]
      card.setBitmap("Graphics/Pictures/Trainer Card/card_gpo_2")
    else
      card.setBitmap("Graphics/Pictures/Trainer Card/card_2")
    end
    return if !overlay
    #@sprites["trainer"].visible=false
    overlay.bitmap.clear
    baseColor=Color.new(72,72,72)
    shadowColor=Color.new(160,160,160)
    quest = pbGetQuestProgress
    textPositions=[
       [_INTL("Trainer Battles"),84,82,0,baseColor,shadowColor],
       [_INTL("{1}",$Trainer.stats.battles),422,82,1,baseColor,shadowColor],
       [_INTL("Wins vs. Trainers"),84,114,0,baseColor,shadowColor],
       [_INTL("{1}",$Trainer.stats.battles_won),422,114,1,baseColor,shadowColor],
       [_INTL("Wild Encounters"),84,146,0,baseColor,shadowColor],
       [_INTL("{1}",$Trainer.stats.wild_battles),422,146,1,baseColor,shadowColor],
       [_INTL("Pokémon Captured"),84,178,0,baseColor,shadowColor],
       [_INTL("{1}",$Trainer.stats.pokemon_caught),422,178,1,baseColor,shadowColor],
       [_INTL("Eggs Hatched"),84,210,0,baseColor,shadowColor],
       [_INTL("{1}",$Trainer.stats.eggs_hatched),422,210,1,baseColor,shadowColor],
       [_INTL("Steps Taken"),84,242,0,baseColor,shadowColor],
       [_INTL("{1}",$Trainer.stats.steps_taken),422,242,1,baseColor,shadowColor],
       [_INTL("Money Earned"),84,274,0,baseColor,shadowColor],
       [_INTL("${1}",$Trainer.stats.money_earned),422,274,1,baseColor,shadowColor],
       [_INTL("Money Spent"),84,306,0,baseColor,shadowColor],
       [_INTL("${1}",$Trainer.stats.money_spent),422,306,1,baseColor,shadowColor]
    ]
    pbDrawTextPositions(overlay.bitmap,textPositions,false)
  end

  def pbDrawJob(name, card, overlay)
    job = pbJob(name)
    card.setBitmap(_INTL("Graphics/Pictures/Trainer Card/{1}", job.card_file))
    return if !overlay
    overlay.bitmap.clear
    baseColor    = Color.new(72,72,72)
    shadowColor  = Color.new(160,160,160)
    baseColor2   = Color.new(252,252,252)
    skills = []
    for r in job.rewards
      skills.push(r)
    end
    if job.level < 4
      for i in (job.level + 1)...5
        skills[i] = "???"
      end
    end
    textPositions = [
       [job.teacher_title,34,58,0,baseColor,shadowColor],
       [job.teacher,302,58,1,baseColor,shadowColor],
       [_INTL("ID No."),332,58,0,baseColor,shadowColor],
       [sprintf("%05d",$Trainer.public_ID),468,58,1,baseColor,shadowColor]
    ]
    for i in 0...skills.length
      textPositions.push([
        skills[i],74,106 + 36*i,0,(job.level <= i) ? baseColor : baseColor2,shadowColor
      ])
    end
    pbDrawTextPositions(overlay.bitmap,textPositions)
    y = 110
    imagePositions = []
    for i in 0...job.level
      imagePositions.push(["Graphics/Pictures/Trainer Card/star",30,y,0,0,32,32])
      y += 36
    end
    pbDrawImagePositions(overlay.bitmap,imagePositions)
  end
  
  def pbDrawStats(card, overlay)
    if $game_switches[GPO_MEMBER]
      card.setBitmap("Graphics/Pictures/Trainer Card/card_gpo_2")
    else
      card.setBitmap("Graphics/Pictures/Trainer Card/card_2")
    end
    return if !overlay
    #@sprites["trainer"].visible=false
    overlay.bitmap.clear
    baseColor=Color.new(72,72,72)
    shadowColor=Color.new(160,160,160)
    quest = pbGetQuestProgress
    textPositions=[
       [_INTL("Trainer Battles"),84,82,0,baseColor,shadowColor],
       [_INTL("{1}",$Trainer.stats.battles),422,82,1,baseColor,shadowColor],
       [_INTL("Wins vs. Trainers"),84,114,0,baseColor,shadowColor],
       [_INTL("{1}",$Trainer.stats.battles_won),422,114,1,baseColor,shadowColor],
       [_INTL("Wild Encounters"),84,146,0,baseColor,shadowColor],
       [_INTL("{1}",$Trainer.stats.wild_battles),422,146,1,baseColor,shadowColor],
       [_INTL("Pokémon Captured"),84,178,0,baseColor,shadowColor],
       [_INTL("{1}",$Trainer.stats.pokemon_caught),422,178,1,baseColor,shadowColor],
       [_INTL("Eggs Hatched"),84,210,0,baseColor,shadowColor],
       [_INTL("{1}",$Trainer.stats.eggs_hatched),422,210,1,baseColor,shadowColor],
       [_INTL("Steps Taken"),84,242,0,baseColor,shadowColor],
       [_INTL("{1}",$Trainer.stats.steps_taken),422,242,1,baseColor,shadowColor],
       [_INTL("Money Earned"),84,274,0,baseColor,shadowColor],
       [_INTL("${1}",$Trainer.stats.money_earned),422,274,1,baseColor,shadowColor],
       [_INTL("Money Spent"),84,306,0,baseColor,shadowColor],
       [_INTL("${1}",$Trainer.stats.money_spent),422,306,1,baseColor,shadowColor]
    ]
    pbDrawTextPositions(overlay.bitmap,textPositions,false)
  end

  def pbJobsScreen
    pbSEPlay("GUI trainer card open")
    loop do
      Graphics.update
      Input.update
      pbUpdate
      if Input.trigger?(Input::C)

      elsif Input.trigger?(Input::BACK)
        if @debug_count == 8
          if !$DEBUG
            $DEBUG = true
            Kernel.pbMessage("DEBUG MODE ACTIVATED")
          else
            $DEBUG = false
            Kernel.pbMessage("debug mode deactivated")
          end
        end
        pbPlayCloseMenuSE
        break
      end
      if Input.trigger?(Input::LEFT)
        if @debug_count == 0
          @debug_count = 1
        else
          @debug_count = 0
        end
      end
      if Input.trigger?(Input::UP)
        if @debug_count == 1
          @debug_count = 2
        elsif @debug_count == 4
          @debug_count = 5
        elsif @debug_count == 6
          @debug_count = 7
        else
          @debug_count = 0
        end
      end
      if Input.trigger?(Input::RIGHT)
        if @debug_count == 2
          @debug_count = 3
        else
          @debug_count = 0
        end
      end
      if Input.trigger?(Input::DOWN)
        if @debug_count == 3
          @debug_count = 4
        elsif @debug_count == 5
          @debug_count = 6
        elsif @debug_count == 7
          @debug_count = 8
        else
          @debug_count = 0
        end
      end
    end
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites) { pbUpdate }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end

#===============================================================================
#
#===============================================================================
class PokemonJobsScreen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen
    @scene.pbStartScene
    @scene.pbJobsScreen
    @scene.pbEndScene
  end
end
