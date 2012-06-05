admins = [
  {
    :nick                  => 'Quetzalcoatl',
    :password              => 'admin1',
    :password_confirmation => 'admin1',
    :avatar                => 'sky drake fly',
    :background            => 'jevyan',
    :color                 => 'purple',
    :country               => 'europeanunion',
    :timezone              => 'UTC',
    :description           => %q(!http://fc01.deviantart.net/fs70/i/2012/004/1/1/evil_unearthed_by_ralphhorsley-d4l9dl0.jpg! Want me to do something? Read "this":http://lwn.net/Articles/105375/ first.),
    :signature             => 'I know the cheatz... All of them.'
  }
]

Player.create admins
Player.all.each {|p| p.update_attribute :admin, true}

maps_2p = [
    "Aethermaw", "Arcanclave Citadel", "Astral Port", "Caves of the Basilisk", "Crescent Lake",
    "Cynsaun Bettlefield", "Den of Onis", "Elensefar Courtyard", "Fallenstar Lake", "Hamlets",
    "Hornshark Island", "Howling Ghost Badlands", "Sablestone Delta", "Serpent Ford",
    "Silverhead Crossing", "Sulla's Ruins", "Swamp Of Dread", "The Freelands", "The Walls Of Pyrennis",
    "Thousand Stings Garrison", "Tombs of Kesorak",
    "Weldyn Channel"
].collect {|n| {:name => n, :slots => 2}}

maps_4p = [
    "Blue Water Province", "Castle Hopping Isle", "Clash", "Hamlets", "Isar's Cross", "Loris River",
    "Morituri", "Path of Daggers", "Ruins of Terra-Dwelve", "Underworld", "Xanthe Chaos"
].collect {|n| {:name => n, :slots => 4}}

Map.create maps_2p + maps_4p
