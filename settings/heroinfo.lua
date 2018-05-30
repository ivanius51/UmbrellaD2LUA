local HeroInfo = {}

--[[

	--Transitioned from Ensage to be used with Hake. Includes heroes, creeps, summoned units, buildings--
	--Updated values to Patch 7.15, alphabetically ordered--
	--Simple breakdown of your desired units values, makes scripters lifes easier--
	--Categorized heroes by STR, AGL, INT--
	--All non heroes will be down the list as Non Hero Units--

	Structure:
	if not HeroInfo["HeroName"].ProjectileSpeed -- Melee hero.
		HeroInfo["HeroName"].AttackTime == Hero's Base Attack Time
		HeroInfo["HeroName"].AttackPoint == Hero's Base Attack Point
		HeroInfo["HeroName"].AttackRange == Hero's Base Attack Range
		HeroInfo["HeroName"].MovementSpeed == Hero's Base Movement Speed
		HeroInfo["HeroName"].TurnRate == Hero's Base Turning Rate
		HeroInfo["HeroName"].AttackBackSwing = Hero's attack backswing
		
	if HeroInfo["HeroName"].ProjectileSpeed -- Ranged hero.
		HeroInfo["HeroName"].AttackTime == Hero's Base Attack Time
		HeroInfo["HeroName"].AttackPoint == Hero's Base Attack Point
		HeroInfo["HeroName"].AttackRange == Hero's Base Attack Range
		HeroInfo["HeroName"].ProjectileSpeed == Hero's Attack's Projectile Speed
		HeroInfo["HeroName"].MovementSpeed == Hero's Base Movement Speed
		HeroInfo["HeroName"].TurnRate == Hero's Base Turning Rate
		HeroInfo["HeroName"].AttackBackSwing = Hero's attack backswing

	Note:
	Hero names with spaces in them have the space replaced with '_'.
--]]

HeroInfo = {

--Strength Heroes--

npc_dota_hero_abaddon = {
AttackTime = 1.7,
AttackPoint = 0.56,
AttackRange = 150,
MovementSpeed = 305,
TurnRate = 0.5,
AttackBackSwing = 0.41},

npc_dota_hero_alchemist = {
AttackTime = 1.7,
AttackPoint = 0.35,
AttackRange = 150,
MovementSpeed = 290,
TurnRate = 0.6,
AttackBackSwing = 0.65},

npc_dota_hero_axe = {
AttackTime = 1.7,
AttackPoint = 0.5,
AttackRange = 150,
MovementSpeed = 290,
TurnRate = 0.6,
AttackBackSwing = 0.5},

npc_dota_hero_beastmaster = {
AttackTime = 1.7,
AttackPoint = 0.3,
AttackRange = 150,
MovementSpeed = 305,
TurnRate = 0.5,
AttackBackSwing = 0.7},

npc_dota_hero_brewmaster = {
AttackTime = 1.7,
AttackPoint = 0.35,
AttackRange = 150,
MovementSpeed = 295,
TurnRate = 0.6,
AttackBackSwing = 0.65},

npc_dota_hero_bristleback = {
AttackTime = 1.8,
AttackPoint = 0.3,
AttackRange = 150,
MovementSpeed = 285,
TurnRate = 1.0,
AttackBackSwing = 0.3},

npc_dota_hero_centaur = {
AttackTime = 1.7,
AttackPoint = 0.3,
AttackRange = 150,
MovementSpeed = 295,
TurnRate = 0.5,
AttackBackSwing = 0.3},

npc_dota_hero_chaos_knight = {
AttackTime = 1.7,
AttackPoint = 0.5,
AttackRange = 150,
MovementSpeed = 320,
TurnRate = 0.5,
AttackBackSwing = 0.5},

npc_dota_hero_rattletrap = {
AttackTime = 1.7,
AttackPoint = 0.33,
AttackRange = 150,
MovementSpeed = 310,
TurnRate = 0.6,
AttackBackSwing = 0.64},

npc_dota_hero_doom_bringer = {
AttackTime = 2.0,
AttackPoint = 0.5,
AttackRange = 150,
MovementSpeed = 285,
TurnRate = 0.5,
AttackBackSwing = 0.7},

npc_dota_hero_dragon_knight = {
AttackTime = 1.7,
AttackPoint = 0.5,
AttackRange = 150,
MovementSpeed = 285,
TurnRate = 0.6,
AttackBackSwing = 0.5},

npc_dota_hero_earth_spirit = {
AttackTime = 1.7,
AttackPoint = 0.35,
AttackRange = 150,
MovementSpeed = 285,
TurnRate = 0.6,
AttackBackSwing = 0.65},

npc_dota_hero_earthshaker = {
AttackTime = 1.7,
AttackPoint = 0.467,
AttackRange = 150,
MovementSpeed = 305,
TurnRate = 0.9,
AttackBackSwing = 0.863},

npc_dota_hero_elder_titan = {
AttackTime = 1.7,
AttackPoint = 0.35,
AttackRange = 150,
MovementSpeed = 310,
TurnRate = 0.5,
AttackBackSwing = 0.97},

npc_dota_hero_huskar = {
AttackTime = 1.6,
AttackPoint = 0.4,
AttackRange = 400,
ProjectileSpeed = 1400,
MovementSpeed = 290,
TurnRate = 0.5,
AttackBackSwing = 0.5},

npc_dota_hero_wisp = {
AttackTime = 1.7,
AttackPoint = 0.15,
AttackRange = 575,
ProjectileSpeed = 1200,
MovementSpeed = 290,
TurnRate = 0.7,
AttackBackSwing = 0.4},

npc_dota_hero_kunkka = {
AttackTime = 1.7,
AttackPoint = 0.4,
AttackRange = 150,
MovementSpeed = 295,
TurnRate = 0.6,
AttackBackSwing = 0.3},

npc_dota_hero_legion_commander = {
AttackTime = 1.7,
AttackPoint = 0.46,
AttackRange = 150,
MovementSpeed = 315,
TurnRate = 0.5,
AttackBackSwing = 0.64},

npc_dota_hero_life_stealer = {
AttackTime = 1.85,
AttackPoint = 0.39,
AttackRange = 150,
MovementSpeed = 310,
TurnRate = 1.0,
AttackBackSwing = 0.44},

npc_dota_hero_lycan = {
AttackTime = 1.7,
AttackPoint = 0.55,
AttackRange = 150,
MovementSpeed = 300,
TurnRate = 0.5,
AttackBackSwing = 0.55},

npc_dota_hero_magnataur = {
AttackTime = 1.8,
AttackPoint = 0.5,
AttackRange = 150,
MovementSpeed = 305,
TurnRate = 0.8,
AttackBackSwing = 0.84},

npc_dota_hero_night_stalker = {
AttackTime = 1.7,
AttackPoint = 0.55,
AttackRange = 150,
MovementSpeed = 290,
TurnRate = 0.5,
AttackBackSwing = 0.55},

npc_dota_hero_omniknight = {
AttackTime = 1.7,
AttackPoint = 0.433,
AttackRange = 150,
MovementSpeed = 300,
TurnRate = 0.6,
AttackBackSwing = 0.567},

npc_dota_hero_phoenix = {
AttackTime = 1.7,
AttackPoint = 0.35,
AttackRange = 500,
ProjectileSpeed = 1100,
MovementSpeed = 280,
TurnRate = 1.0,
AttackBackSwing = 0.633},

npc_dota_hero_pudge = {
AttackTime = 1.7,
AttackPoint = 0.5,
AttackRange = 150,
MovementSpeed = 275,
TurnRate = 0.7,
AttackBackSwing = 1.17},

npc_dota_hero_sand_king = {
AttackTime = 1.7,
AttackPoint = 0.53,
AttackRange = 150,
MovementSpeed = 285,
TurnRate = 0.5,
AttackBackSwing = 0.47},

npc_dota_hero_slardar = {
AttackTime = 1.7,
AttackPoint = 0.36,
AttackRange = 150,
MovementSpeed = 285,
TurnRate = 0.5,
AttackBackSwing = 0.64},

npc_dota_hero_spirit_breaker = {
AttackTime = 1.9,
AttackPoint = 0.6,
AttackRange = 150,
MovementSpeed = 280,
TurnRate = 0.5,
AttackBackSwing = 0.3},

npc_dota_hero_sven = {
AttackTime = 1.8,
AttackPoint = 0.4,
AttackRange = 150,
MovementSpeed = 285,
TurnRate = 0.6,
AttackBackSwing = 0.3},

npc_dota_hero_tidehunter = {
AttackTime = 1.7,
AttackPoint = 0.6,
AttackRange = 150,
MovementSpeed = 300,
TurnRate = 0.5,
AttackBackSwing = 0.56},

npc_dota_hero_shredder = {
AttackTime = 1.7,
AttackPoint = 0.36,
AttackRange = 150,
MovementSpeed = 285,
TurnRate = 0.6,
AttackBackSwing = 0.64},

npc_dota_hero_tiny = {
AttackTime = 1.7,
AttackPoint = 0.4,
AttackRange = 150,
MovementSpeed = 280,
TurnRate = 0.5,
AttackBackSwing = 1},

npc_dota_hero_treant = {
AttackTime = 1.9,
AttackPoint = 0.6,
AttackRange = 150,
MovementSpeed = 265,
TurnRate = 0.5,
AttackBackSwing = 0.4},

npc_dota_hero_tusk = {
AttackTime = 1.7,
AttackPoint = 0.36,
AttackRange = 150,
MovementSpeed = 295,
TurnRate = 0.7,
AttackBackSwing = 0.64},

npc_dota_hero_abyssal_underlord = {
AttackTime = 1.7,
AttackPoint = 0.45,
AttackRange = 150,
MovementSpeed = 285,
TurnRate = 0.6,
AttackBackSwing = 0.7},

npc_dota_hero_undying = {
AttackTime = 1.7,
AttackPoint = 0.3,
AttackRange = 150,
MovementSpeed = 305,
TurnRate = 0.6,
AttackBackSwing = 0.3},

npc_dota_hero_skeleton_king = {
AttackTime = 1.7,
AttackPoint = 0.56,
AttackRange = 150,
MovementSpeed = 295,
TurnRate = 0.5,
AttackBackSwing = 0.44},

--Agility Heroes--

npc_dota_hero_antimage = {
AttackTime = 1.45,
AttackPoint = 0.3,
AttackRange = 150,
MovementSpeed = 310,
TurnRate = 0.5,
AttackBackSwing = 0.6},

npc_dota_hero_arc_warden = {
AttackTime = 1.7,
AttackPoint = 0.3,
AttackRange = 625,
ProjectileSpeed = 900,
MovementSpeed = 280,
TurnRate = 0.6,
AttackBackSwing = 0.7},

npc_dota_hero_bloodseeker = {
AttackTime = 1.7,
AttackPoint = 0.43,
AttackRange = 150,
MovementSpeed = 285,
TurnRate = 0.5,
AttackBackSwing = 0.74},

npc_dota_hero_bounty_hunter = {
AttackTime = 1.7,
AttackPoint = 0.59,
AttackRange = 150,
MovementSpeed = 315,
TurnRate = 0.6,
AttackBackSwing = 0.59},

npc_dota_hero_broodmother = {
AttackTime = 1.7,
AttackPoint = 0.4,
AttackRange = 150,
MovementSpeed = 270,
TurnRate = 0.5,
AttackBackSwing = 0.5},

npc_dota_hero_clinkz = {
AttackTime = 1.7,
AttackPoint = 0.7,
AttackRange = 640,
ProjectileSpeed = 900,
MovementSpeed = 295,
TurnRate = 0.5,
AttackBackSwing = 0.3},

npc_dota_hero_drow_ranger = {
AttackTime = 1.7,
AttackPoint = 0.7,
AttackRange = 625,
ProjectileSpeed = 1250,
MovementSpeed = 285,
TurnRate = 0.7,
AttackBackSwing = 0.3},

npc_dota_hero_ember_spirit = {
AttackTime = 1.7,
AttackPoint = 0.4,
AttackRange = 150,
MovementSpeed = 305,
TurnRate = 0.5,
AttackBackSwing = 0.3},

npc_dota_hero_faceless_void = {
AttackTime = 1.7,
AttackPoint = 0.5,
AttackRange = 150,
MovementSpeed = 295,
TurnRate = 1,
AttackBackSwing = 0.56},

npc_dota_hero_gyrocopter = {
AttackTime = 1.7,
AttackPoint = 0.2,
AttackRange = 365,
ProjectileSpeed = 3000,
MovementSpeed = 320,
TurnRate = 0.6,
AttackBackSwing = 0.97},

npc_dota_hero_juggernaut = {
AttackTime = 1.4,
AttackPoint = 0.33,
AttackRange = 150,
MovementSpeed = 295,
TurnRate = 0.6,
AttackBackSwing = 0.84},

npc_dota_hero_lone_druid = {
AttackTime = 1.7,
AttackPoint = 0.33,
AttackRange = 550,
ProjectileSpeed = 900,
MovementSpeed = 320,
TurnRate = 0.5,
AttackBackSwing = 0.53},

npc_dota_hero_luna = {
AttackTime = 1.7,
AttackPoint = 0.46,
AttackRange = 330,
ProjectileSpeed = 900,
MovementSpeed = 330,
TurnRate = 0.6,
AttackBackSwing = 0.54},

npc_dota_hero_medusa = {
AttackTime = 1.7,
AttackPoint = 0.5,
AttackRange = 600,
ProjectileSpeed = 1200,
MovementSpeed = 275,
TurnRate = 0.5,
AttackBackSwing = 0.6},

npc_dota_hero_meepo = {
AttackTime = 1.7,
AttackPoint = 0.38,
AttackRange = 150,
MovementSpeed = 310,
TurnRate = 0.65,
AttackBackSwing = 0.6},

npc_dota_hero_mirana = {
AttackTime = 1.7,
AttackPoint = 0.3,
AttackRange = 630,
ProjectileSpeed = 900,
MovementSpeed = 295,
TurnRate = 0.5,
AttackBackSwing = 0.7},

npc_dota_hero_monkey_king = {
AttackTime = 1.7,
AttackPoint = 0.45,
AttackRange = 300,
MovementSpeed = 300,
TurnRate = 0.6,
AttackBackSwing = 0.2},

npc_dota_hero_morphling = {
AttackTime = 1.5,
AttackPoint = 0.5,
AttackRange = 350,
ProjectileSpeed = 1300,
MovementSpeed = 280,
TurnRate = 0.6,
AttackBackSwing = 0.5},

npc_dota_hero_naga_siren = {
AttackTime = 1.7,
AttackPoint = 0.5,
AttackRange = 150,
MovementSpeed = 315,
TurnRate = 0.5,
AttackBackSwing = 0.5},

npc_dota_hero_nyx_assassin = {
AttackTime = 1.7,
AttackPoint = 0.46,
AttackRange = 150,
MovementSpeed = 295,
TurnRate = 0.5,
AttackBackSwing = 0.54},

npc_dota_hero_pangolier = {
AttackTime = 1.7,
AttackPoint = 0.33,
AttackRange = 150,
MovementSpeed = 305,
TurnRate = 1,
AttackBackSwing = 0},

npc_dota_hero_phantom_assassin = {
AttackTime = 1.7,
AttackPoint = 0.3,
AttackRange = 150,
MovementSpeed = 305,
TurnRate = 0.6,
AttackBackSwing = 0.7},

npc_dota_hero_phantom_lancer = {
AttackTime = 1.7,
AttackPoint = 0.5,
AttackRange = 150,
MovementSpeed = 285,
TurnRate = 0.6,
AttackBackSwing = 0.5},

npc_dota_hero_razor = {
AttackTime = 1.7,
AttackPoint = 0.3,
AttackRange = 475,
ProjectileSpeed = 2000,
MovementSpeed = 285,
TurnRate = 0.5,
AttackBackSwing = 0.7},

npc_dota_hero_riki = {
AttackTime = 1.7,
AttackPoint = 0.3,
AttackRange = 150,
MovementSpeed = 275,
TurnRate = 0.6,
AttackBackSwing = 0.3},

npc_dota_hero_nevermore = {
AttackTime = 1.7,
AttackPoint = 0.5,
AttackRange = 500,
ProjectileSpeed = 1200,
MovementSpeed = 310,
TurnRate = 1.0,
AttackBackSwing = 0.54},

npc_dota_hero_slark = {
AttackTime = 1.7,
AttackPoint = 0.5,
AttackRange = 150,
MovementSpeed = 295,
TurnRate = 0.6,
AttackBackSwing = 0.3},

npc_dota_hero_sniper = {
AttackTime = 1.7,
AttackPoint = 0.17,
AttackRange = 550,
ProjectileSpeed = 3000,
MovementSpeed = 285,
TurnRate = 0.7,
AttackBackSwing = 0.7},

npc_dota_hero_spectre = {
AttackTime = 1.7,
AttackPoint = 0.3,
AttackRange = 150,
MovementSpeed = 285,
TurnRate = 0.5,
AttackBackSwing = 0.7},

npc_dota_hero_templar_assassin = {
AttackTime = 1.7,
AttackPoint = 0.3,
AttackRange = 140,
ProjectileSpeed = 900,
MovementSpeed = 310,
TurnRate = 0.7,
AttackBackSwing = 0.5},

npc_dota_hero_terrorblade = {
AttackTime = 1.5,
AttackPoint = 0.3,
AttackRange = 150,
MovementSpeed = 310,
TurnRate = 0.5,
AttackBackSwing = 0.6},

npc_dota_hero_troll_warlord = {
AttackTime = 1.7,
AttackPoint = 0.3,
AttackRange = 500,
ProjectileSpeed = 1200,
MovementSpeed = 295,
TurnRate = 0.5,
AttackBackSwing = 0.3},

npc_dota_hero_ursa = {
AttackTime = 1.7,
AttackPoint = 0.3,
AttackRange = 150,
MovementSpeed = 305,
TurnRate = 0.5,
AttackBackSwing = 0.3},

npc_dota_hero_vengefulspirit = {
AttackTime = 1.7,
AttackPoint = 0.33,
AttackRange = 400,
ProjectileSpeed = 1500,
MovementSpeed = 295,
TurnRate = 0.6,
AttackBackSwing = 0.64},

npc_dota_hero_venomancer = {
AttackTime = 1.7,
AttackPoint = 0.3,
AttackRange = 450,
ProjectileSpeed = 900,
MovementSpeed = 275,
TurnRate = 0.5,
AttackBackSwing = 0.7},

npc_dota_hero_viper = {
AttackTime = 1.7,
AttackPoint = 0.33,
AttackRange = 575,
ProjectileSpeed = 1200,
MovementSpeed = 275,
TurnRate = 0.5,
AttackBackSwing = 1},

npc_dota_hero_weaver = {
AttackTime = 1.8,
AttackPoint = 0.64,
AttackRange = 425,
ProjectileSpeed = 900,
MovementSpeed = 280,
TurnRate = 0.5,
AttackBackSwing = 0.36},

--Intelligence Heroes--

npc_dota_hero_ancient_apparition = {
AttackTime = 1.7,
AttackPoint = 0.45,
AttackRange = 675,
ProjectileSpeed = 1250,
MovementSpeed = 295,
TurnRate = 0.6,
AttackBackSwing = 0.3},

npc_dota_hero_bane = {
AttackTime = 1.7,
AttackPoint = 0.3,
AttackRange = 400,
ProjectileSpeed = 900,
MovementSpeed = 310,
TurnRate = 0.6,
AttackBackSwing = 0.7},

npc_dota_hero_batrider = {
AttackTime = 1.7,
AttackPoint = 0.3,
AttackRange = 375,
ProjectileSpeed = 900,
MovementSpeed = 290,
TurnRate = 1.0,
AttackBackSwing = 0.54},

npc_dota_hero_chen = {
AttackTime = 1.7,
AttackPoint = 0.5,
AttackRange = 650,
ProjectileSpeed = 1100,
MovementSpeed = 310,
TurnRate = 0.6,
AttackBackSwing = 0.5},

npc_dota_hero_crystal_maiden = {
AttackTime = 1.7,
AttackPoint = 0.55,
AttackRange = 600,
ProjectileSpeed = 900,
MovementSpeed = 275,
TurnRate = 0.5,
AttackBackSwing = 0},

npc_dota_hero_dark_seer = {
AttackTime = 1.7,
AttackPoint = 0.59,
AttackRange = 150,
MovementSpeed = 295,
TurnRate = 0.6,
AttackBackSwing = 0.58},

npc_dota_hero_dark_willow = {
AttackTime = 1.3,
AttackPoint = 0.3,
AttackRange = 475,
ProjectileSpeed = 1200,
MovementSpeed = 295,
TurnRate = 0.7,
AttackBackSwing = 0},

npc_dota_hero_dazzle = {
AttackTime = 1.7,
AttackPoint = 0.3,
AttackRange = 550,
ProjectileSpeed = 1200,
MovementSpeed = 310,
TurnRate = 0.6,
AttackBackSwing = 0.3},

npc_dota_hero_death_prophet = {
AttackTime = 1.7,
AttackPoint = 0.56,
AttackRange = 600,
ProjectileSpeed = 1000,
MovementSpeed = 310,
TurnRate = 0.5,
AttackBackSwing = 0.51},

npc_dota_hero_disruptor = {
AttackTime = 1.7,
AttackPoint = 0.4,
AttackRange = 600,
ProjectileSpeed = 1200,
MovementSpeed = 300,
TurnRate = 0.5,
AttackBackSwing = 0.5},

npc_dota_hero_enchantress = {
AttackTime = 1.7,
AttackPoint = 0.3,
AttackRange = 550,
ProjectileSpeed = 900,
MovementSpeed = 340,
TurnRate = 0.5,
AttackBackSwing = 0.7},

npc_dota_hero_enigma = {
AttackTime = 1.7,
AttackPoint = 0.4,
AttackRange = 500,
ProjectileSpeed = 900,
MovementSpeed = 300,
TurnRate = 0.5,
AttackBackSwing = 0.77},

npc_dota_hero_invoker = {
AttackTime = 1.7,
AttackPoint = 0.4,
AttackRange = 600,
ProjectileSpeed = 900,
MovementSpeed = 280,
TurnRate = 0.5,
AttackBackSwing = 0.7},

npc_dota_hero_jakiro = {
AttackTime = 1.7,
AttackPoint = 0.4,
AttackRange = 400,
ProjectileSpeed = 1100,
MovementSpeed = 290,
TurnRate = 0.5,
AttackBackSwing = 0.3},

npc_dota_hero_keeper_of_the_light = {
AttackTime = 1.7,
AttackPoint = 0.3,
AttackRange = 600,
ProjectileSpeed = 900,
MovementSpeed = 335,
TurnRate = 0.5,
AttackBackSwing = 0.85},

npc_dota_hero_leshrac = {
AttackTime = 1.7,
AttackPoint = 0.4,
AttackRange = 600,
ProjectileSpeed = 900,
MovementSpeed = 330,
TurnRate = 0.5,
AttackBackSwing = 0.77},

npc_dota_hero_lich = {
AttackTime = 1.7,
AttackPoint = 0.46,
AttackRange = 550,
ProjectileSpeed = 900,
MovementSpeed = 315,
TurnRate = 0.5,
AttackBackSwing = 0.54},

npc_dota_hero_lina = {
AttackTime = 1.6,
AttackPoint = 0.75,
AttackRange = 670,
ProjectileSpeed = 1000,
MovementSpeed = 295,
TurnRate = 0.5,
AttackBackSwing = 0.78},

npc_dota_hero_lion = {
AttackTime = 1.7,
AttackPoint = 0.43,
AttackRange = 600,
ProjectileSpeed = 900,
MovementSpeed = 290,
TurnRate = 0.5,
AttackBackSwing = 0.74},

npc_dota_hero_furion = {
AttackTime = 1.7,
AttackPoint = 0.4,
AttackRange = 600,
ProjectileSpeed = 1125,
MovementSpeed = 290,
TurnRate = 0.6,
AttackBackSwing = 0.77},

npc_dota_hero_necrolyte = {
AttackTime = 1.7,
AttackPoint = 0.45,
AttackRange = 550,
ProjectileSpeed = 900,
MovementSpeed = 285,
TurnRate = 0.5,
AttackBackSwing = 0.47},

npc_dota_hero_ogre_magi = {
AttackTime = 1.7,
AttackPoint = 0.3,
AttackRange = 150,
MovementSpeed = 285,
TurnRate = 0.6,
AttackBackSwing = 0.3},

npc_dota_hero_oracle = {
AttackTime = 1.4,
AttackPoint = 0.3,
AttackRange = 620,
ProjectileSpeed = 900,
MovementSpeed = 305,
TurnRate = 0.7,
AttackBackSwing = 0.7},

npc_dota_hero_obsidian_destroyer = {
AttackTime = 1.7,
AttackPoint = 0.46,
AttackRange = 450,
ProjectileSpeed = 900,
MovementSpeed = 315,
TurnRate = 0.5,
AttackBackSwing = 0.54},

npc_dota_hero_puck = {
AttackTime = 1.7,
AttackPoint = 0.5,
AttackRange = 550,
ProjectileSpeed = 900,
MovementSpeed = 295,
TurnRate = 0.5,
AttackBackSwing = 0.8},

npc_dota_hero_pugna = {
AttackTime = 1.7,
AttackPoint = 0.5,
AttackRange = 630,
ProjectileSpeed = 900,
MovementSpeed = 335,
TurnRate = 0.5,
AttackBackSwing = 0.5},

npc_dota_hero_queenofpain = {
AttackTime = 1.5,
AttackPoint = 0.56,
AttackRange = 550,
ProjectileSpeed = 1500,
MovementSpeed = 295,
TurnRate = 0.5,
AttackBackSwing = 0.41},

npc_dota_hero_rubick = {
AttackTime = 1.7,
AttackPoint = 0.4,
AttackRange = 550,
ProjectileSpeed = 1125,
MovementSpeed = 290,
TurnRate = 0.7,
AttackBackSwing = 0.77},

npc_dota_hero_shadow_demon = {
AttackTime = 1.7,
AttackPoint = 0.35,
AttackRange = 500,
ProjectileSpeed = 900,
MovementSpeed = 295,
TurnRate = 0.6,
AttackBackSwing = 0.5},

npc_dota_hero_shadow_shaman = {
AttackTime = 1.7,
AttackPoint = 0.3,
AttackRange = 400,
ProjectileSpeed = 900,
MovementSpeed = 285,
TurnRate = 0.5,
AttackBackSwing = 0.5},

npc_dota_hero_silencer = {
AttackTime = 1.7,
AttackPoint = 0.5,
AttackRange = 600,
ProjectileSpeed = 1000,
MovementSpeed = 295,
TurnRate = 0.6,
AttackBackSwing = 0.5},

npc_dota_hero_skywrath_mage = {
AttackTime = 1.7,
AttackPoint = 0.4,
AttackRange = 600,
ProjectileSpeed = 1000,
MovementSpeed = 330,
TurnRate = 0.5,
AttackBackSwing = 0.78},

npc_dota_hero_storm_spirit = {
AttackTime = 1.7,
AttackPoint = 0.5,
AttackRange = 480,
ProjectileSpeed = 1100,
MovementSpeed = 285,
TurnRate = 0.8,
AttackBackSwing = 0.3},

npc_dota_hero_techies = {
AttackTime = 1.7,
AttackPoint = 0.5,
AttackRange = 700,
ProjectileSpeed = 900,
MovementSpeed = 270,
TurnRate = 0.5,
AttackBackSwing = 0.5},

npc_dota_hero_tinker = {
AttackTime = 1.7,
AttackPoint = 0.35,
AttackRange = 500,
ProjectileSpeed = 900,
MovementSpeed = 290,
TurnRate = 0.6,
AttackBackSwing = 0.65},

npc_dota_hero_visage = {
AttackTime = 1.7,
AttackPoint = 0.46,
AttackRange = 600,
ProjectileSpeed = 900,
MovementSpeed = 285,
TurnRate = 0.5,
AttackBackSwing = 0.54},

npc_dota_hero_warlock = {
AttackTime = 1.7,
AttackPoint = 0.3,
AttackRange = 600,
ProjectileSpeed = 1200,
MovementSpeed = 295,
TurnRate = 0.5,
AttackBackSwing = 0.3},

npc_dota_hero_windrunner = {
AttackTime = 1.5,
AttackPoint = 0.4,
AttackRange = 600,
ProjectileSpeed = 1250,
MovementSpeed = 295,
TurnRate = 0.8,
AttackBackSwing = 0.3},

npc_dota_hero_winter_wyvern = {
AttackTime = 1.7,
AttackPoint = 0.25,
AttackRange = 425,
ProjectileSpeed = 700,
MovementSpeed = 285,
TurnRate = 0.5,
AttackBackSwing = 0.8},

npc_dota_hero_witch_doctor = {
AttackTime = 1.7,
AttackPoint = 0.4,
AttackRange = 600,
ProjectileSpeed = 1200,
MovementSpeed = 305,
TurnRate = 0.5,
AttackBackSwing = 0.5},

npc_dota_hero_zuus = {
AttackTime = 1.7,
AttackPoint = 0.633,
AttackRange = 380,
ProjectileSpeed = 1100,
MovementSpeed = 300,
TurnRate = 0.6,
AttackBackSwing = 0.366},

--Non Hero Units--

npc_dota_lone_druid_bear1 = {
AttackTime = 1.65,
AttackPoint = 0.43,
AttackRange = 128,
AttackBackSwing = 0.67},

npc_dota_lone_druid_bear2 = {
AttackTime = 1.55,
AttackPoint = 0.43,
AttackRange = 128,
AttackBackSwing = 0.67},

npc_dota_lone_druid_bear3 = {
AttackTime = 1.45,
AttackPoint = 0.43,
AttackRange = 128,
AttackBackSwing = 0.67},

npc_dota_lone_druid_bear4 = {
AttackTime = 1.35,
AttackPoint = 0.43,
AttackRange = 128,
AttackBackSwing = 0.67},

npc_dota_creep_badguys_melee = {
AttackTime = 1,
AttackPoint = 0.467,
AttackRange = 100,
AttackBackSwing = 0.533},

npc_dota_creep_goodguys_melee = {
AttackTime = 1,
AttackPoint = 0.467,
AttackRange = 100,
AttackBackSwing = 0.533},

npc_dota_creep_badguys_ranged = {
AttackTime = 1,
AttackPoint = 0.5,
AttackRange = 500,
ProjectileSpeed = 900,
AttackBackSwing = 0.3},

npc_dota_creep_goodguys_ranged	= {
AttackTime = 1,
AttackPoint = 0.5,
AttackRange = 500,
ProjectileSpeed = 900,
AttackBackSwing = 0.3},

npc_dota_badguys_siege = {
AttackTime = 2.7,
AttackPoint = 0.7,
AttackRange = 690,
ProjectileSpeed = 1100,
AttackBackSwing = 2.0},

npc_dota_goodguys_siege = {
AttackTime = 2.7,
AttackPoint = 0.7,
AttackRange = 690,
ProjectileSpeed = 1100,
AttackBackSwing = 2.0},

npc_dota_venomancer_plague_ward_1 = {
AttackTime = 1.5,
AttackPoint = 0.3,
AttackRange = 600,
ProjectileSpeed = 1900,
AttackBackSwing = 0.7},

npc_dota_venomancer_plague_ward_2 = {
AttackTime = 1.5,
AttackPoint = 0.3,
AttackRange = 600,
ProjectileSpeed = 1900,
AttackBackSwing = 0.7},

npc_dota_venomancer_plague_ward_3 = {
AttackTime = 1.5,
AttackPoint = 0.3,
AttackRange = 600,
ProjectileSpeed = 1900,
AttackBackSwing = 0.7},

npc_dota_venomancer_plague_ward_4 = {
AttackTime = 1.5,
AttackPoint = 0.3,
AttackRange = 600,
ProjectileSpeed = 1900,
AttackBackSwing = 0.7},

npc_dota_badguys_tower1_bot = {
AttackTime = 1,
AttackPoint = 0.6,
AttackRange = 700,
ProjectileSpeed = 750,
AttackBackSwing = 0.4},

npc_dota_badguys_tower1_mid = {
AttackTime = 1,
AttackPoint = 0.6,
AttackRange = 700,
ProjectileSpeed = 750,
AttackBackSwing = 0.4},

npc_dota_badguys_tower1_top = {
AttackTime = 1,
AttackPoint = 0.6,
AttackRange = 700,
ProjectileSpeed = 750,
AttackBackSwing = 0.4},

npc_dota_badguys_tower2_bot = {
AttackTime = 0.95,
AttackPoint = 0.6,
AttackRange = 700,
ProjectileSpeed = 750,
AttackBackSwing = 0.4},

npc_dota_badguys_tower2_mid = {
AttackTime = 0.95,
AttackPoint = 0.6,
AttackRange = 700,
ProjectileSpeed = 750,
AttackBackSwing = 0.4},

npc_dota_badguys_tower2_top = {
AttackTime = 0.95,
AttackPoint = 0.6,
AttackRange = 700,
ProjectileSpeed = 750,
AttackBackSwing = 0.4},

npc_dota_badguys_tower3_bot = {
AttackTime = 0.95,
AttackPoint = 0.6,
AttackRange = 700,
ProjectileSpeed = 750,
AttackBackSwing = 0.4},

npc_dota_badguys_tower3_mid = {
AttackTime = 0.95,
AttackPoint = 0.6,
AttackRange = 700,
ProjectileSpeed = 750,
AttackBackSwing = 0.4},

npc_dota_badguys_tower3_top = {
AttackTime = 0.95,
AttackPoint = 0.6,
AttackRange = 700,
ProjectileSpeed = 750,
AttackBackSwing = 0.4},

npc_dota_badguys_tower4 = {
AttackTime = 0.95,
AttackPoint = 0.6,
AttackRange = 700,
ProjectileSpeed = 750,
AttackBackSwing = 0.4},

npc_dota_goodguys_tower1_bot = {
AttackTime = 1,
AttackPoint = 0.6,
AttackRange = 700,
ProjectileSpeed = 750,
AttackBackSwing = 0.4},

npc_dota_goodguys_tower1_mid = {
AttackTime = 1,
AttackPoint = 0.6,
AttackRange = 700,
ProjectileSpeed = 750,
AttackBackSwing = 0.4},

npc_dota_goodguys_tower1_top = {
AttackTime = 1,
AttackPoint = 0.6,
AttackRange = 700,
ProjectileSpeed = 750,
AttackBackSwing = 0.4},

npc_dota_goodguys_tower2_bot = {
AttackTime = 0.95,
AttackPoint = 0.6,
AttackRange = 700,
ProjectileSpeed = 750,
AttackBackSwing = 0.4},

npc_dota_goodguys_tower2_mid = {
AttackTime = 0.95,
AttackPoint = 0.6,
AttackRange = 700,
ProjectileSpeed = 750,
AttackBackSwing = 0.4},

npc_dota_goodguys_tower2_top = {
AttackTime = 0.95,
AttackPoint = 0.6,
AttackRange = 700,
ProjectileSpeed = 750,
AttackBackSwing = 0.4},

npc_dota_goodguys_tower3_bot = {
AttackTime = 0.95,
AttackPoint = 0.6,
AttackRange = 700,
ProjectileSpeed = 750,
AttackBackSwing = 0.4},

npc_dota_goodguys_tower3_mid = {
AttackTime = 0.95,
AttackPoint = 0.6,
AttackRange = 700,
ProjectileSpeed = 750,
AttackBackSwing = 0.4},

npc_dota_goodguys_tower3_top = {
AttackTime = 0.95,
AttackPoint = 0.6,
AttackRange = 700,
ProjectileSpeed = 750,
AttackBackSwing = 0.4},

npc_dota_goodguys_tower4 = {
AttackTime = 0.95,
AttackPoint = 0.6,
AttackRange = 700,
ProjectileSpeed = 750,
AttackBackSwing = 0.4},

npc_dota_invoker_forged_spirit = {
AttackTime = 1.5,
AttackPoint = 0.2,
AttackRange = 900,
ProjectileSpeed = 1000,
AttackBackSwing = 0.4},

npc_dota_lycan_wolf1 = {
AttackTime = 1.2,
AttackPoint = 0.33,
AttackBackSwing = 0.64},

npc_dota_lycan_wolf2 = {
AttackTime = 1.1,
AttackPoint = 0.33,
AttackBackSwing = 0.64},

npc_dota_lycan_wolf3 = {
AttackTime = 1,
AttackPoint = 0.33,
AttackBackSwing = 0.64},

npc_dota_lycan_wolf4 = {
AttackTime = 0.9,
AttackPoint = 0.33,
AttackBackSwing = 0.64},

npc_dota_brewmaster_earth_1 = {
AttackTime = 1.25,
AttackPoint = 0.3,
AttackBackSwing = 0.3},

npc_dota_brewmaster_earth_2 = {
AttackTime = 1.25,
AttackPoint = 0.3,
AttackBackSwing = 0.3},

npc_dota_brewmaster_earth_3 = {
AttackTime = 1.25,
AttackPoint = 0.3,
AttackBackSwing = 0.3},

npc_dota_brewmaster_fire_1 = {
AttackTime = 1.35,
AttackPoint = 0.3,
AttackBackSwing = 0.3},

npc_dota_brewmaster_fire_2 = {
AttackTime = 1.35,
AttackPoint = 0.3,
AttackBackSwing = 0.3},

npc_dota_brewmaster_fire_3 = {
AttackTime = 1.35,
AttackPoint = 0.3,
AttackBackSwing = 0.3},

npc_dota_brewmaster_storm_1 = {
AttackTime = 1.5,
AttackPoint = 0.4,
AttackBackSwing = 0.77},

npc_dota_brewmaster_storm_2 = {
AttackTime = 1.5,
AttackPoint = 0.4,
AttackBackSwing = 0.77},

npc_dota_brewmaster_storm_3 = {
AttackTime = 1.5,
AttackPoint = 0.4,
AttackBackSwing = 0.77},

npc_dota_necronomicon_archer_1 = {
AttackTime = 1,
AttackPoint = 0.7,
AttackBackSwing = 0.3},

npc_dota_necronomicon_archer_2 = {
AttackTime = 1,
AttackPoint = 0.7,
AttackBackSwing = 0.3},

npc_dota_necronomicon_archer_3 = {
AttackTime = 1,
AttackPoint = 0.7,
AttackBackSwing = 0.3},

npc_dota_necronomicon_warrior_1 = {
AttackTime = 0.75,
AttackPoint = 0.56,
AttackBackSwing = 0.44},

npc_dota_necronomicon_warrior_2 = {
AttackTime = 0.75,
AttackPoint = 0.56,
AttackBackSwing = 0.44},

npc_dota_necronomicon_warrior_3 = {
AttackTime = 0.75,
AttackPoint = 0.56,
AttackBackSwing = 0.44},

npc_dota_beastmaster_boar = {
AttackTime = 1.25,
AttackPoint = 0.5,
AttackBackSwing = 0.47},

npc_dota_beastmaster_greater_boar = {
AttackTime = 1.25,
AttackPoint = 0.5,
AttackBackSwing = 0.47},

npc_dota_visage_familiar1 = {
AttackTime = 0.4,
AttackPoint = 0.33,
AttackBackSwing = 0.2},

npc_dota_visage_familiar2 = {
AttackTime = 0.4,
AttackPoint = 0.33,
AttackBackSwing = 0.2},

npc_dota_visage_familiar3 = {
AttackTime = 0.4,
AttackPoint = 0.33,
AttackBackSwing = 0.2},

}

return HeroInfo