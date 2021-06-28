def pbTrades(id)
  
  id = id.downcase
  
  trades = nil
  
  case id
  when "plum"
    trades = [
      ["Berry Juice",[:ORANBERRY,3],[:BERRYJUICE,2]],
      ["Lum Berry Soup",[:LUMBERRY,1,:CHESTOBERRY,1],[:LUMBERRYSOUP,1]],
      ["Pecheri Pastry",[:PECHABERRY,1,:CHERIBERRY,1],[:PECHERIPASTRY,1]],
      ["Honeyed Berries",[:HONEY,1,:HONDEWBERRY,3],[:HONEYEDBERRY,3]],
      ["Mushroom Muffin",[:TINYMUSHROOM,3,:BIGMUSHROOM,1],[:MUSHROOMMUFFIN,4]],
      ["Baked Balm",[:TINYMUSHROOM,2,:BALMMUSHROOM,1],[:BAKEDBALM,2]]
      #["Plum's Special",[:COBABERRY,1,:OCCABERRY,1,:KEBIABERRY,1],[:PLUMSSPECIAL,1]]
    ]
  when "pent"
    trades = [
      ["Miracle Seed",[:RINDOBERRY,2,:DAMPROCK,1],[:MIRACLESEED,1,:DAMPROCK,1]],
      #-10% grass-type damage
      ["Nature's Guard",[:MIRACLESEED,1,:RINDOBERRY,3,:TINYMUSHROOM,1],[:NATURESGUARD,1]],
      ["Beetle Bark",[:SILVERPOWDER,1,:TANGABERRY,3,:HONEY,1],[:BEETLEBARK,1]],
      ["Souvenir",[:RAREBONE,1],[:ALOLANSOUVENIR,1]],
      #+25% powder-move accuracy
      ["All-Seeing Totem",[:WIDELENS,1,:SILVERPOWDER,1,:MENTALHERB,1],[:ALLSEEINGTOTEM,1]],
      # Prevents the foe from inducing confusion on the holder
      ["Mental Ward",[:BLUESHARD,3,:PERSIMBERRY,2,:PRETTYWING,1],[:MENTALWARD,1]]
    ]
  when "allon"
    trades = [
      ["Charcoal",[:ENERGYROOT,1,:HEATROCK,1],[:CHARCOAL,1,:HEATROCK,1]],
      ["Heat Medallion",[:CHARCOAL,1,:OCCABERRY,3,:REDSHARD,3],[:HEATMEDALLION,1]],
      ["Draco Shield",[:DRAGONFANG,1,:HABANBERRY,3,:QUICKPOWDER,1],[:DRACOSHIELD,1]],
      ["Iron Gauntlets",[:METALCOAT,1,:BABIRIBERRY,3,:METALPOWDER,1],[:IRONGAUNTLETS,1]],
      ["Rocky Helmet",[:YELLOWSHARD,7,:METALCOAT,1],[:ROCKYHELMET,1]],
      ["Sturdy Helmet",[:GREENSHARD,7,:METALCOAT,1],[:STURDYHELMET,1]],
      ["Heavy Stone",[:HARDSTONE,1,:IRONBALL,1],[:HEAVYSTONE,1]],
      ["Hazard Armor",[:BLUESHARD,9,:METALPOWDER,1,:QUICKPOWDER,1],[:HAZARDARMOR,1]],
      ["Assault Vest",[:REDSHARD,9,:METALPOWDER,1,:PROTECTOR,1],[:ASSAULTVEST,1]]
    ]
  when "channelle"
    trades = [
      ["Mystic Water",[:SHOALSHELL,2,:BLUESHARD,2],[:MYSTICWATER,1]],
      #-20% water-type damage
      ["Ocean Necklace",[:MYSTICWATER,1,:PASSHOBERRY,3,:SHOALSHELL,1],[:OCEANNECKLACE,1]],
      ["Frost Bracelet",[:NEVERMELTICE,1,:YACHEBERRY,3,:BLUESHARD,2],[:FROSTBRACELET,1]],
      ["Pearl String",[:PEARL,3],[:PEARLSTRING,1]],
      ["Amulet Coin",[:BIGNUGGET,1],[:AMULETCOIN,1]],
      ["Shed Shell",[:SHOALSHELL,5,:QUICKPOWDER,1],[:SHEDSHELL,1]],
      # The Pokémon is treated as if it has half of its current HP (rounded down)
      ["Zen Charm",[:STICKYBARB,1,:STARPIECE,1],[:ZENCHARM,1]],
      # When afflicting target with Poison, it's always Bad Poison
      ["Noxious Choker",[:TOXICORB,1,:BLACKSLUDGE,1],[:NOXIOUSCHOKER,1]],
      # Protection from curses (Curse, Destiny Bond, Spite, Grudge, Perish Song)
      ["Aegis Talisman",[:HEARTSCALE,2,:PEARLSTRING,1,:CLEANSETAG,1],[:AEGISTALISMAN,1]]
    ]
  end
  
  if pbQuest(:UnitedCraftmanship).status>=1
    if id=="pent"
      trades.push(["Grass Element",[:MIRACLESEED,1,:LEAFSTONE,1,:GREENSHARD,5],[:GRASSELEMENT,1]])
    elsif id=="allon"
      trades.push(["Fire Element",[:CHARCOAL,1,:FIRESTONE,1,:REDSHARD,5],[:FIREELEMENT,1]])
    elsif id=="channelle"
      trades.push(["Water Element",[:MYSTICWATER,1,:WATERSTONE,1,:BLUESHARD,5],[:WATERELEMENT,1]])
    end
  end
  
  return trades
end








