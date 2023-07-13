#===============================================================================
# Randomizers
#===============================================================================
def pbRollModifier(check=false,dfc=pbDifficulty,mod=(1.025-(0.025*dfc)),clover=0.00,item=1.00,ability=1.00)
  # Easy:   99,88 % / 53,75 %, # Normal: 95,00 % / 50,00 % 
  # Hard:   90,12 % / 46,25 %, # V-Hard: 85,25 % / 42,50 %
  #===========================================================================
  if $DEBUG && Input.press?(Input::CTRL)
    pbText("Run mod calc?\\ch[500,0,Yes,No]")
    if pbAnswer == 0
      pbText("Clover Charm?\\ch[500,0,Yes,No]")
      if pbAnswer == 0
        clover = 1.30
      else
        clover = 1.00
      end
      item = 1.25
      ability = 1.20     
      mod_e = (1.025*clover*item*ability)
      mod_n = (1.00*clover*item*ability)
      mod_h = (0.975*clover*item*ability)
      mod_v = (0.95*clover*item*ability)
      pbText("\\l[4]<ac>[G] Easy : " + mod_e.to_s + "[/]\\n [B] Normal : " + mod_n.to_s + "[/]\\n [Y] Hard : " + mod_h.to_s + "[/]\\n [P] Very Hard : " + mod_v.to_s + "[/]</ac>")
      return (mod*clover*item*ability)     
    end
  end
  # Clover Modifiers
  if $bag.has?(:FOURLEAFCLOVER)
    clover += 0.15; $bag.remove(:FOURLEAFCLOVER)
  elsif $bag.has?(:THREELEAFCLOVER)
    clover += 0.10; $bag.remove(:THREELEAFCLOVER)
  elsif $bag.has?(:TWOLEAFCLOVER)
    clover += 0.05; $bag.remove(:TWOLEAFCLOVER)
  end
  clover *= 2  if pbHasBagItem?(:CLOVERCHARM)
  clover += 1.00
  # Item Modifiers
  for i in $Trainer.pokemonParty
    if i.species == PBSpecies::MAGIKARP &&
        i.item == PBItems::FORTUNEFIN
      item += 0.20
      break
    end
  end
  for i in $Trainer.pokemonParty
    if i.item == PBItems::LUCKYEGG ||
        i.item == PBItems::LUCKINCENSE 
      item += 0.05
      break
    end  
  end
  mod *= item
  # Ability Modifiers
  for i in $Trainer.pokemonParty
    if i.ability == PBAbilities::SUPERLUCK  
        ability += 0.15
      break
    end
  end
  for i in $Trainer.pokemonParty
    if i.ability == PBAbilities::SERENEGRACE
        ability += 0.05
      break
    end
  end
  mod *= ability
  return (mod).round
end

def pbUpdateDex(echo=false)
  pbText("\\ch[500,0,Update Dex,Update Dex W/Echomon]")
  echo = true if pbAnswer == 1  
  # Total:    (41 / 1008)
  completed = [
  # Gen I     (34 / 151)
  :BULBASAUR,:IVYSAUR,:VENUSAUR,:CHARMANDER,:CHARMELEON,:CHARIZARD,:SQUIRTLE,:WARTORTLE,:BLASTOISE,:CATERPIE,
  :METAPOD,:BUTTERFREE,:WEEDLE,:KAKUNA,:BEEDRILL,:PIDGEY,:PIDGEOTTO,:PIDGEOT,:RATTATA,:RATICATE,:SPEAROW,
  :FEAROW,:EKANS,:ARBOK,:PIKACHU,:RAICHU,:SANDSHREW,:SANDSLASH,:VULPIX,:NINETALES,:JIGGLYPUFF,:WIGGLYTUFF,
  :ZUBAT,:GOLBAT,
  
  # Gen II    (4 / 100)
  :PICHU,:IGGLYBUFF,:ESPEON,:UMBREON,

  # Gen III   (0 / 135)

  # Gen IV    (2 / 107)
  :LEAFEON,:GLACEON,
  # Gen V     (0 / 156)

  # Gen VI    (1 / 72) 
  :SYLVEON
  # Gen VII   (0 / 87) 

  # Gen VIII  (0 / 95) 

  # Gen IX    (0 / 103)
  ]
  # Echomon   (59 / 76 (111))
  comp_echo = [
  :INLYS,:ZIIRA,:MENIYGNA,:LICIT,:SALICOT,:SERGEVAUL,:VINETTE,:VARAEL,:EUDRRAMINA,:TROGRETTE,:CROPHATOR,
  :RESPLERIA,:REVAGLO,:REVULTRE,:ULVIS,:NORILDYS,:KAMALYN,:KAMARASHI,:EPHREAM,:VOYAGION,:WANDRAZE,:SHIRYNTH,
  :CYILARD,:KYEILDRA,:YINCHI,:SAKURANCER,:RIDDLING,:SPHIRIGMA,:MIRBIT,:JURAGE,:PIKORIN,:OPHIRION,:GHUILON,
  :SPHADEX,:ARQUIOD,:MAREFELLION,:CLAIRVOGIL,:PALANDHORIN,:GOPHIEL,:TALPHAUMET,:NEPHIES,:HARCIPHIM,:HOTAPHEE,
  :LEVYANA,:TRANSLUCEON,:MORPHEON,:ADAMANTEON,:ANTIQUEON,:VALOREON,:HARMONEON,:ZEPHYREON,:PANDEMEON,
  :PHANTASMEON,:KIRINEON,:ALCHENT,:LAPHIVROS,:ATTRIGO,:ZEPTUS,:YOCRIDENS,:PANGRAELYS,:IGUALAPYS,:THRAENAGOS
  ]

  for pkmn in completed
    $player.set_seen(pkmn)  
    $player.pokedex.register_caught(pkmn)  
  end
  if echo
    for echo in comp_echo
      $player.set_seen(echo)  
      $player.pokedex.register_caught(echo)  
    end
  end
end