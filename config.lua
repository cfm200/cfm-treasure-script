Config = {}

Config.Invincible = true --Do you want the peds to be invincible?
Config.Frozen = true --Do you want the peds to be unable to move? It's probably a yes, so leave true in there.
Config.Stoic = true --Do you want the peds to react to what is happening in their surroundings?
Config.Fade = true-- Do you want the peds to fade into/out of existence? It looks better than just *POP* its there.
Config.Distance = 15.0 --The distance you want peds to spawn at

Config.Peds = {
	{ --- legion treasure ped
		model = "a_m_m_acult_01",
		coords = vector3(129.88, -1035.33, 28.43),
    heading = 336.56,
		gender = "male",
		freeze = true,
		invincible = true,
		blockevents = true,
    isRendered = false,
	},
}


Config.Locations = {
  {
    --- Behind/Near PD ---
    coords = vector3(521.41, -762.61, 24.77)
  },

  {
    --- Park near Rockford Plaza ---
    coords = vector3(-103.25, -431.51, 36.15)
  },

  {
    --- Casino ---
    coords = vector3(923.39, 75.39, 78.97)
  },

  {
    --- Vinewood Sign ---
    coords = vector3(720.31, 1203.09, 325.99)
  }
}


Config.Loot = {
    [1] = 'tosti',
    [2] = 'water_bottle',
    [3] = 'kurkakola',
    [4] = 'twerks_candy',
    [5] = 'snikkel_candy',
    [6] = 'sandwich',
    [7] = 'beer',
    [8] = 'whiskey',
    [9] = 'vodka',
    [10] = 'bandage',
    [11] = 'lighter',
    [12] = 'rolling_paper',
}

