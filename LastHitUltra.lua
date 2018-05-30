--[[
25.02.2018 - 30.02.2018 
-----------------------------------------------
  ______     __   _____                _        _____ _____ __ 
 |  _ \ \   / /  |_   _|              (_)      / ____| ____/_ |
 | |_) \ \_/ /     | |_   ____ _ _ __  _ _   _| (___ | |__  | |
 |  _ < \   /      | \ \ / / _` | '_ \| | | | |\___ \|___ \ | |
 | |_) | | |      _| |\ V / (_| | | | | | |_| |____) |___) || |
 |____/  |_|     |_____\_/ \__,_|_| |_|_|\__,_|_____/|____/ |_|
                                                               
http://GetScript.Net
-----------------------End---------------------
Is licensed under the
GNU General Public License v3.0
]]
local LastHitUltra = {}

LastHitUltra.optionLastHitEnable = Menu.AddOptionBool({ "Utility", "<BETA> Last Hitter" }, "0. Enable ", false)
LastHitUltra.optionLastHitKey = Menu.AddKeyOption({ "Utility", "<BETA> Last Hitter" }, "1. Activation key ", Enum.ButtonCode.KEY_P)
LastHitUltra.optionLastHitStyle = Menu.AddOptionCombo({ "Utility", "<BETA> Last Hitter" }, "2. Targeting style ", { ' last hit + deny', ' only last hit', ' only deny' }, 0, 2, 1)
LastHitUltra.optionLastHitDrawCreepEnable = Menu.AddOptionBool({ "Utility", "<BETA> Last Hitter", "3. Drawings" }, "0. Enable creep drawings ", false)
LastHitUltra.optionLastHitDrawStyle = Menu.AddOptionCombo({ "Utility", "<BETA> Last Hitter", "3. Drawings" }, "1. creep info style ", { ' enemy+ally creeps', ' enemy creeps only' }, 0, 1, 1)
LastHitUltra.optionLastHitDrawCreepTimer = Menu.AddOptionBool({ "Utility", "<BETA> Last Hitter", "3. Drawings" }, "2. Draw last hit indicator ", false)

LastHitUltra.attackPointTable = {
	npc_dota_hero_abaddon = { 0.56, 0.41, 0 },
	npc_dota_hero_alchemist = { 0.35, 0.65, 0 },
	npc_dota_hero_ancient_apparition = { 0.45, 0.3, 1250 },
	npc_dota_hero_antimage = { 0.3, 0.6, 0 },
	npc_dota_hero_arc_warden = { 0.3, 0.7, 800 },
	npc_dota_hero_axe = { 0.5, 0.5, 0 },
	npc_dota_hero_bane = { 0.3, 0.7, 900 },
	npc_dota_hero_batrider = { 0.3, 0.54, 900 },
	npc_dota_hero_beastmaster = { 0.3, 0.7, 0 },
	npc_dota_hero_bloodseeker = { 0.43, 0.74, 0 },
	npc_dota_hero_bounty_hunter = { 0.59, 0.59, 0 },
	npc_dota_hero_brewmaster = { 0.35, 0.65, 0 },
	npc_dota_hero_bristleback = { 0.3, 0.3, 0 },
	npc_dota_hero_broodmother = { 0.4, 0.5, 0 },
	npc_dota_hero_centaur = { 0.3, 0.3, 0 },
	npc_dota_hero_chaos_knight = { 0.5, 0.5, 0 },
	npc_dota_hero_chen = { 0.5, 0.5, 1100 },
	npc_dota_hero_clinkz = { 0.7, 0.3, 900 },
	npc_dota_hero_rattletrap = { 0.33, 0.64, 0 },
	npc_dota_hero_crystal_maiden = { 0.55, 0, 900 },
	npc_dota_hero_dark_seer = { 0.59, 0.58, 0 },
	npc_dota_hero_dazzle = { 0.3, 0.3, 1200 },
	npc_dota_hero_death_prophet = { 0.56, 0.51, 1000 },
	npc_dota_hero_disruptor = { 0.4, 0.5, 1200 },
	npc_dota_hero_doom_bringer = { 0.5, 0.7, 0 },
	npc_dota_hero_dragon_knight = { 0.5, 0.5, 900 },
	npc_dota_hero_drow_ranger = { 0.7, 0.3, 1250 },
	npc_dota_hero_earth_spirit = { 0.35, 0.65, 0 },
	npc_dota_hero_earthshaker = { 0.467, 0.863, 0 },
	npc_dota_hero_elder_titan = { 0.35, 0.97, 0 },
	npc_dota_hero_ember_spirit = { 0.4, 0.3, 0 },
	npc_dota_hero_enchantress = { 0.3, 0.7, 900 },
	npc_dota_hero_enigma = { 0.4, 0.77, 900 },
	npc_dota_hero_faceless_void = { 0.5, 0.56, 0 },
	npc_dota_hero_gyrocopter = { 0.2, 0.97, 3000 },
	npc_dota_hero_huskar = { 0.4, 0.5, 1400 },
	npc_dota_hero_invoker = { 0.4, 0.7, 900 },
	npc_dota_hero_wisp = { 0.15, 0.4, 1200 },
	npc_dota_hero_jakiro = { 0.4, 0.5, 1100 },
	npc_dota_hero_juggernaut = { 0.33, 0.84, 0 },
	npc_dota_hero_keeper_of_the_light = { 0.3, 0.85, 900 },
	npc_dota_hero_kunkka = { 0.4, 0.3, 0 },
	npc_dota_hero_legion_commander = { 0.46, 0.64, 0 },
	npc_dota_hero_leshrac = { 0.4, 0.77, 900 },
	npc_dota_hero_lich = { 0.46, 0.54, 900 },
	npc_dota_hero_life_stealer = { 0.39, 0.44, 0 },
	npc_dota_hero_lina = { 0.75, 0.78, 1000 },
	npc_dota_hero_lion = { 0.43, 0.74, 1000 },
	npc_dota_hero_lone_druid = { 0.33, 0.53, 900 },
	npc_dota_hero_luna = { 0.46, 0.54, 900 },
	npc_dota_hero_lycan = { 0.55, 0.55, 0 },
	npc_dota_hero_magnataur = { 0.5, 0.84, 0 },
	npc_dota_hero_medusa = { 0.5, 0.6, 1200 },
	npc_dota_hero_meepo = { 0.38, 0.6, 0 },
	npc_dota_hero_mirana = { 0.3, 0.7, 900 },
	npc_dota_hero_morphling = { 0.45, 0.2, 0 },
	npc_dota_hero_monkey_king = { 0.5, 0.5, 1300 },
	npc_dota_hero_naga_siren = { 0.5, 0.5, 0 },
	npc_dota_hero_furion = { 0.4, 0.77, 1125 },
	npc_dota_hero_necrolyte = { 0.53, 0.47, 900 },
	npc_dota_hero_night_stalker = { 0.55, 0.55, 0 },
	npc_dota_hero_nyx_assassin = { 0.46, 0.54, 0 },
	npc_dota_hero_ogre_magi = { 0.3, 0.3, 0 },
	npc_dota_hero_omniknight = { 0.433, 0.567, 0 },
	npc_dota_hero_oracle = { 0.3, 0.7, 900 },
	npc_dota_hero_obsidian_destroyer = { 0.46, 0.54, 900 },
	npc_dota_hero_phantom_assassin = { 0.3, 0.7, 0 },
	npc_dota_hero_phantom_lancer = { 0.5, 0.5, 0 },
	npc_dota_hero_phoenix = { 0.35, 0.633, 1100 },
	npc_dota_hero_puck = { 0.5, 0.8, 900 },
	npc_dota_hero_pudge = { 0.5, 1.17, 0 },
	npc_dota_hero_pugna = { 0.5, 0.5, 900 },
	npc_dota_hero_queenofpain = { 0.56, 0.41, 1500 },
	npc_dota_hero_razor = { 0.3, 0.7, 2000 },
	npc_dota_hero_riki = { 0.3, 0.3, 0 },
	npc_dota_hero_rubick = { 0.4, 0.77, 1125 },
	npc_dota_hero_sand_king = { 0.53, 0.47, 0 },
	npc_dota_hero_shadow_demon = { 0.35, 0.5, 900 },
	npc_dota_hero_nevermore = { 0.5, 0.54, 1200 },
	npc_dota_hero_shadow_shaman = { 0.3, 0.5, 900 },
	npc_dota_hero_silencer = { 0.5, 0.5, 1000 },
	npc_dota_hero_skywrath_mage = { 0.4, 0.78, 1000 },
	npc_dota_hero_slardar = { 0.36, 0.64, 0 },
	npc_dota_hero_slark = { 0.5, 0.3, 0 },
	npc_dota_hero_sniper = { 0.17, 0.7, 3000 },
	npc_dota_hero_spectre = { 0.3, 0.7, 0 },
	npc_dota_hero_spirit_breaker = { 0.6, 0.3, 0 },
	npc_dota_hero_storm_spirit = { 0.5, 0.3, 1100 },
	npc_dota_hero_sven = { 0.4, 0.3, 0 },
	npc_dota_hero_techies = { 0.5, 0.5, 900 },
	npc_dota_hero_templar_assassin = { 0.3, 0.5, 900 },
	npc_dota_hero_terrorblade = { 0.3, 0.6, 0 },
	npc_dota_hero_tidehunter = { 0.6, 0.56, 0 },
	npc_dota_hero_shredder = { 0.36, 0.64, 0 },
	npc_dota_hero_tinker = { 0.35, 0.65, 900 },
	npc_dota_hero_tiny = { 0.49, 1, 0 },
	npc_dota_hero_treant = { 0.6, 0.4, 0 },
	npc_dota_hero_troll_warlord = { 0.3, 0.3, 1200 },
	npc_dota_hero_tusk = { 0.36, 0.64, 0 },
	npc_dota_hero_abyssal_underlord = { 0.45, 0.7, 0 },
	npc_dota_hero_undying = { 0.3, 0.3, 0 },
	npc_dota_hero_ursa = { 0.3, 0.3, 0 },
	npc_dota_hero_vengefulspirit = { 0.33, 0.64, 1500 },
	npc_dota_hero_venomancer = { 0.3, 0.7, 900 },
	npc_dota_hero_viper = { 0.33, 1, 1200 },
	npc_dota_hero_visage = { 0.46, 0.54, 900 },
	npc_dota_hero_warlock = { 0.3, 0.3, 1200 },
	npc_dota_hero_weaver = { 0.64, 0.36, 900 },
	npc_dota_hero_windrunner = { 0.4, 0.3, 1250 },
	npc_dota_hero_winter_wyvern = { 0.25, 0.8, 700 },
	npc_dota_hero_witch_doctor = { 0.4, 0.5, 1200 },
	npc_dota_hero_skeleton_king = { 0.56, 0.44, 0 },
	npc_dota_hero_zuus = { 0.633, 0.366, 1100 },
	npc_dota_hero_dark_willow = { 0.3, 0.7, 1200 },
	npc_dota_hero_pangolier = { 0.33, 0.67, 0 } }

LastHitUltra.lastHitCreepHPPrediction = {}
LastHitUltra.lastHitCreepHPPredictionTime = {}
LastHitUltra.creepAttackPointData = {}
LastHitUltra.lastHitterDelay = 0
LastHitUltra.lastHitterKillableImage = nil
LastHitUltra.lastHitterOrbSkill = nil
LastHitUltra.lastHitterOrbSkillEnemy = nil
LastHitUltra.myUnitName = nil
LastHitUltra.AttackAnimationCreate = 0

function LastHitUltra.OnUpdate()

	if not Engine.IsInGame() then
		return
	end
	
	if GameRules.GetGameState() < 4 then return end
	if GameRules.GetGameState() > 5 then return end

	local myHero = Heroes.GetLocal()
		if not myHero then return end
		if not Entity.IsAlive(myHero) then return end
		if LastHitUltra.myUnitName == nil then
			LastHitUltra.myUnitName = NPC.GetUnitName(myHero)
		end
		
	if Menu.IsKeyDown(LastHitUltra.optionLastHitKey) then
		Engine.ExecuteCommand("dota_range_display 100 0")
	else
		--Engine.ExecuteCommand("dota_range_display 0")
	end
	LastHitUltra.lastHitter(myHero)
end

function LastHitUltra.lastHitter(myHero)
	
	if not myHero then return end
	if not Menu.IsEnabled(LastHitUltra.optionLastHitEnable) then return end

	local increasedAS = NPC.GetIncreasedAttackSpeed(myHero)

	local attackPoint = 0
	for i, v in pairs(LastHitUltra.attackPointTable) do
		if i == NPC.GetUnitName(myHero) then
			attackPoint = v[1] / (1 + (increasedAS/100))
			break
		end
	end

	LastHitUltra.lastHitterPredictDieTime(myHero)
	LastHitUltra.lastHitterDieTimeCleaner(myHero, attackPoint)
	LastHitUltra.lastHitterExecuteLastHit(myHero, attackPoint)
			
end

function LastHitUltra.lastHitterPredictDieTime(myHero)

	if not myHero then return end

	if next(LastHitUltra.lastHitCreepHPPredictionTime) ~= nil then
		table.sort(LastHitUltra.lastHitCreepHPPredictionTime, function(a, b)
       			return a < b
    		end)
	end

	for target, attackTable in pairs(LastHitUltra.lastHitCreepHPPrediction) do
		if attackTable then
			if target and Entity.IsEntity(target) and Entity.IsNPC(target) and Entity.IsAlive(target) then
				local creepHP = math.ceil(Entity.GetHealth(target) + NPC.GetHealthRegen(target))
				local myAttackDMG = math.floor(math.floor(NPC.GetDamageMultiplierVersus(myHero, target) * ((LastHitUltra.myCreepDamageAdjuster(myHero, target) + NPC.GetBonusDamage(myHero)) * NPC.GetArmorDamageMultiplier(target))) * 0.975)
				table.sort(attackTable, function(a, b)
       					return a[1] < b[1]
    				end)

				for i, info in ipairs(attackTable) do
					if info then
						local hitTime = info[1]
						local hitDamage = info[2]
						if hitTime > GameRules.GetGameTime() and math.abs(hitTime - GameRules.GetGameTime()) > 0.15 then
							creepHP = creepHP - hitDamage
							if LastHitUltra.lastHitCreepHPPredictionTime[target] == nil then
								local offSet = LastHitUltra.lastHitGetAttackerCount(myHero, target)
								if creepHP > myAttackDMG and creepHP - myAttackDMG <= math.ceil(math.ceil(0.025 * myAttackDMG) + offSet) then
									if hitTime > GameRules.GetGameTime() and hitTime - GameRules.GetGameTime() < LastHitUltra.lastHitterTimingOffsetter(myHero, target) * 1.25 then
										LastHitUltra.lastHitCreepHPPredictionTime[target] = hitTime + 0.075
										break
										return
									end
								elseif creepHP <= myAttackDMG then
									if hitTime > GameRules.GetGameTime() and hitTime - GameRules.GetGameTime() < LastHitUltra.lastHitterTimingOffsetter(myHero, target) * 1.25 then
										LastHitUltra.lastHitCreepHPPredictionTime[target] = hitTime + 0.075
										break
										return
									end
								end
							else
								if creepHP <= myAttackDMG then
									if hitTime + 0.075 < LastHitUltra.lastHitCreepHPPredictionTime[target] then
										LastHitUltra.lastHitCreepHPPredictionTime[target] = hitTime + 0.075
										break
										return
									end
								end
							end	
						end
					end
				end
			end
		end
	end

	local Units = Entity.GetUnitsInRadius(myHero, 1000, Enum.TeamType.TEAM_BOTH);
	if not Units then
		return;
	end;
	for i, v in ipairs(Units) do
		if v and Entity.IsNPC(v) and not Entity.IsDormant(v) and not NPC.IsWaitingToSpawn(v) and NPC.GetUnitName(v) ~= "npc_dota_neutral_caster" and (NPC.IsCreep(v) or NPC.IsTower(v)) then
			local creepHP = Entity.GetHealth(v) + NPC.GetHealthRegen(v)
			local myAttackDMG = NPC.GetDamageMultiplierVersus(myHero, v) * ((LastHitUltra.myCreepDamageAdjuster(myHero, v) + NPC.GetBonusDamage(myHero)) * NPC.GetArmorDamageMultiplier(v))
			if creepHP < myAttackDMG then
				LastHitUltra.lastHitCreepHPPredictionTime[v] = GameRules.GetGameTime()
			end
		end
	end
	
end

function LastHitUltra.lastHitterDieTimeCleaner(myHero, attackPoint)

	if next(LastHitUltra.lastHitCreepHPPredictionTime) == nil then return end

	if not myHero then
		LastHitUltra.lastHitCreepHPPredictionTime = {}
	end

	if not Entity.IsAlive(myHero) then
		LastHitUltra.lastHitCreepHPPredictionTime = {}
	end

	local Units = Entity.GetUnitsInRadius(myHero, 1000, Enum.TeamType.TEAM_BOTH);

	if not Units or (#Units <= 1) then
		LastHitUltra.lastHitCreepHPPredictionTime = {}
	end

	if next(LastHitUltra.lastHitCreepHPPredictionTime) ~= nil then
		for i, v in pairs(LastHitUltra.lastHitCreepHPPredictionTime) do
			local target = i
			local dieTime = v
			if not target then
				LastHitUltra.lastHitCreepHPPredictionTime[i] = nil
				break
				return
			end
			if target and Entity.IsNPC(target) and not Entity.IsAlive(target) then
				LastHitUltra.lastHitCreepHPPredictionTime[i] = nil
				break
				return
			end
			if GameRules.GetGameTime() > dieTime then
				LastHitUltra.lastHitCreepHPPredictionTime[i] = nil
				break
				return
			end
		end
	end
end


function LastHitUltra.lastHitterExecuteLastHit(myHero, attackPoint)

	if not myHero then return end

	local curTime = GameRules.GetGameTime()

	local lastHitTarget = nil
	local lastHitTime = 0
		for i, v in pairs(LastHitUltra.lastHitCreepHPPredictionTime) do
			if i and Entity.IsNPC(i) and Entity.IsAlive(i) then
				if (not Entity.IsSameTeam(myHero, i) and (not NPC.IsTower(i) or (NPC.IsTower(i) and Entity.GetHealth(i) < 159))) or (Entity.IsSameTeam(myHero, i) and ((not NPC.IsTower(i) and Entity.GetHealth(i)/Entity.GetMaxHealth(i) < 0.5) or (NPC.IsTower(i) and Entity.GetHealth(i) < 159))) then
					if Menu.GetValue(LastHitUltra.optionLastHitStyle) == 0 then
						if LastHitUltra.utilityGetTableLength(LastHitUltra.lastHitCreepHPPredictionTime) <= 1 then
							lastHitTarget = i
							lastHitTime = v
							break
						else
							local tempTable = {}

							for k, l in pairs(LastHitUltra.lastHitCreepHPPredictionTime) do
								table.insert(tempTable, { l, k })
							end

							if #tempTable > 1 then
								if Entity.IsNPC(tempTable[1][2]) and Entity.IsNPC(tempTable[2][2]) then
									if math.abs(tempTable[2][1] - tempTable[1][1]) < NPC.GetAttackTime(myHero) + 0.1 then
										if not Entity.IsSameTeam(myHero, tempTable[1][2]) then
											lastHitTarget = tempTable[1][2]
											lastHitTime = tempTable[1][1]
										else
											if not Entity.IsSameTeam(myHero, tempTable[2][2]) then
												lastHitTarget = tempTable[2][2]
												lastHitTime = tempTable[2][1]
											else
												lastHitTarget = tempTable[1][2]
												lastHitTime = tempTable[1][1]
											end
										end
									else
										lastHitTarget = tempTable[1][2]
										lastHitTime = tempTable[1][1]
									end
								end
							end
						end
					elseif Menu.GetValue(LastHitUltra.optionLastHitStyle) == 1 then
						if not Entity.IsSameTeam(myHero, i) then
							lastHitTarget = i
							lastHitTime = v
							break
						end
					elseif Menu.GetValue(LastHitUltra.optionLastHitStyle) == 2 then
						if Entity.IsSameTeam(myHero, i) then
							lastHitTarget = i
							lastHitTime = v
							break
						end
					end
				end
			end
		end


	if Menu.IsKeyDown(LastHitUltra.optionLastHitKey) then

		if lastHitTarget == nil then
			if LastHitUltra.lastHitInAttackAnimation(myHero, attackPoint) == true then
				Player.HoldPosition(Players.GetLocal(), myHero, false)
				return
			end
		else
			local target = lastHitTarget
			local hitTime = LastHitUltra.utilityRoundNumber((lastHitTime - NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)), 3)
			if Entity.IsNPC(target) and Entity.IsAlive(target) and not NPC.HasState(target, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then
				if curTime > hitTime - LastHitUltra.lastHitterTimingOffsetter(myHero, target) then
					if not LastHitUltra.lastHitInAttackAnimation(myHero, attackPoint) then
						if LastHitUltra.lastHitterOrbSkill ~= nil and not Entity.IsSameTeam(myHero, target) and not NPC.IsTower(target) then
							Ability.CastTarget(LastHitUltra.lastHitterOrbSkill, target)
							return
						else
							Player.AttackTarget(Players.GetLocal(), myHero, target, false)
							return
						end
					end	
				else
					if LastHitUltra.lastHitInAttackAnimation(myHero, attackPoint) == true then
						if (GameRules.GetGameTime() - (os.clock() - LastHitUltra.AttackAnimationCreate)) + LastHitUltra.lastHitterTimingOffsetter(myHero, target) < hitTime then
							Player.HoldPosition(Players.GetLocal(), myHero, false)
							return
						end
					end
				end	
			end
		end
	end
	
	return

end

function LastHitUltra.OnEntityDestroy(ent)
	Log.Write(ent);
	if not ent then return end

	if LastHitUltra.lastHitCreepHPPrediction[ent] ~= nil then
		LastHitUltra.lastHitCreepHPPrediction[ent] = nil
	end

	if LastHitUltra.lastHitCreepHPPredictionTime[ent] ~= nil then
		LastHitUltra.lastHitCreepHPPredictionTime[ent] = nil
	end
	
end

function LastHitUltra.OnUnitAnimation(animation)

	if not animation then return end
	if not Heroes.GetLocal() then return end

	if animation.unit then
		if Entity.IsNPC(animation.unit) and not Entity.IsSameTeam(Heroes.GetLocal(), animation.unit) and not Entity.IsHero(animation.unit) and not Entity.IsDormant(animation.unit) and NPC.IsEntityInRange(Heroes.GetLocal(), animation.unit, 1000) then
			local name = NPC.GetUnitName(animation.unit)
			if LastHitUltra.creepAttackPointData[name] == nil then
				LastHitUltra.creepAttackPointData[name] = animation.castpoint
			else
				if animation.castpoint < LastHitUltra.creepAttackPointData[name] then
					LastHitUltra.creepAttackPointData[name] = animation.castpoint
				end
			end
		end
	end

	if Entity.IsNPC(animation.unit) and not NPC.IsRanged(animation.unit) then
		if NPC.IsEntityInRange(Heroes.GetLocal(), animation.unit, 1000) then
			if NPC.IsLaneCreep(animation.unit) then
				if LastHitUltra.lastHitterGetTarget(Heroes.GetLocal(), animation.unit) ~= nil then
					local targetCreep = LastHitUltra.lastHitterGetTarget(Heroes.GetLocal(), animation.unit)
					local creepHP = math.floor(Entity.GetHealth(targetCreep) + NPC.GetHealthRegen(targetCreep))
					local creepDMG = math.ceil(NPC.GetDamageMultiplierVersus(animation.unit, targetCreep) * ((NPC.GetMinDamage(animation.unit) + NPC.GetBonusDamage(animation.unit)) * NPC.GetArmorDamageMultiplier(targetCreep)))
				--	local hitTime = LastHitUltra.utilityRoundNumber((GameRules.GetGameTime() + animation.castpoint - 0.035 - NetChannel.GetAvgLatency(Enum.Flow.FLOW_INCOMING)), 3)
					local hitTime = LastHitUltra.utilityRoundNumber((GameRules.GetGameTime() + animation.castpoint - 0.035), 3)
					local sourceIndex = Entity.GetIndex(animation.unit)
					if LastHitUltra.lastHitCreepHPPrediction[targetCreep] == nil then
						LastHitUltra.lastHitCreepHPPrediction[targetCreep] = {}
						table.insert(LastHitUltra.lastHitCreepHPPrediction[targetCreep], { hitTime, math.ceil(creepDMG), sourceIndex })
						if LastHitUltra.lastHitterTimingOffsetter(Heroes.GetLocal(), targetCreep) ~= nil and LastHitUltra.lastHitterTimingOffsetter(Heroes.GetLocal(), targetCreep) > 0.45 then
							if creepHP > 2 * creepDMG then
								table.insert(LastHitUltra.lastHitCreepHPPrediction[targetCreep], { hitTime + NPC.GetAttackTime(animation.unit), creepDMG, sourceIndex })
							end
						end
					else
						local inserted = false
						for _, info in ipairs(LastHitUltra.lastHitCreepHPPrediction[targetCreep]) do
							if info and info[3] == sourceIndex and math.abs(hitTime - info[1]) < 0.25 then
								inserted = true
							end
						end
						if not inserted then
							table.insert(LastHitUltra.lastHitCreepHPPrediction[targetCreep], { hitTime, math.ceil(creepDMG), sourceIndex })
							if LastHitUltra.lastHitterTimingOffsetter(Heroes.GetLocal(), targetCreep) ~= nil and LastHitUltra.lastHitterTimingOffsetter(Heroes.GetLocal(), targetCreep) > 0.45 then
								if creepHP > 2 * creepDMG then
									table.insert(LastHitUltra.lastHitCreepHPPrediction[targetCreep], { hitTime + NPC.GetAttackTime(animation.unit), creepDMG, sourceIndex })
								end
							end
						else
							if LastHitUltra.lastHitterTimingOffsetter(Heroes.GetLocal(), targetCreep) ~= nil and LastHitUltra.lastHitterTimingOffsetter(Heroes.GetLocal(), targetCreep) > 0.45 then
								if creepHP > 2 * creepDMG then
									table.insert(LastHitUltra.lastHitCreepHPPrediction[targetCreep], { hitTime + NPC.GetAttackTime(animation.unit), creepDMG, sourceIndex })
								end
							end
						end
					end
					local removeInstance = 0
					local removeTarget = nil
					for target, table in pairs(LastHitUltra.lastHitCreepHPPrediction) do
						if table then
							if target ~= targetCreep then
								for i, info in ipairs(table) do
									if info and info[3] == sourceIndex and info[1] > GameRules.GetGameTime() and math.abs(hitTime - info[1]) > 0.1 then
										removeInstance = i
										removeTarget = target
									end
								end
							end
						end
					end
					if removeInstance > 0 and removeTarget ~= nil then
						table.remove(LastHitUltra.lastHitCreepHPPrediction[removeTarget], removeInstance)
					end
				end
			end
		end
	end

end

function LastHitUltra.myCreepDamageAdjuster(myHero, target)

	if not myHero then return 0 end

	local quelling = NPC.GetItem(myHero, "item_quelling_blade", true)

	local minCreepDamage = NPC.GetMinDamage(myHero)
	local bonusCreepDamage = 0
		if quelling then
			if NPC.IsRanged(myHero) then
				bonusCreepDamage = 7
			else
				bonusCreepDamage = 24
			end
		end

	local orbSkill = LastHitUltra.lastHitterOrbSkill
	if orbSkill ~= nil then
		if not Entity.IsSameTeam(myHero, target) and not NPC.IsTower(target) then
			local orbSkillName = Ability.GetName(orbSkill)
			if orbSkillName == "clinkz_searing_arrows" then
				minCreepDamage = minCreepDamage + (20 + 10 * Ability.GetLevel(orbSkill))
				if NPC.HasAbility(myHero, "special_bonus_unique_clinkz_1") then
					if Ability.GetLevel(NPC.GetAbility(myHero, "special_bonus_unique_clinkz_1")) > 0 then
						minCreepDamage = minCreepDamage + 30
					end
				end
			elseif orbSkillName == "obsidian_destroyer_arcane_orb" then
				local bonusDMG = (0.05 + (0.01 * Ability.GetLevel(orbSkill))) * NPC.GetMana(myHero)
				local bonusPureDMG = bonusDMG * (1 + (1 - NPC.GetDamageMultiplierVersus(myHero, target)) + (1 - NPC.GetArmorDamageMultiplier(target)))
				minCreepDamage = minCreepDamage + bonusPureDMG
			elseif orbSkillName == "silencer_glaives_of_wisdom" then
				local myInt = Hero.GetIntellectTotal(myHero)
				local bonusDMG = 0.15 * Ability.GetLevel(orbSkill) * myInt
					if NPC.HasAbility(myHero, "special_bonus_unique_silencer_3") then
						if Ability.GetLevel(NPC.GetAbility(myHero, "special_bonus_unique_silencer_3")) > 0 then
							bonusDMG = (0.2 + 0.15 * Ability.GetLevel(orbSkill)) * myInt
						end
					end
				local bonusPureDMG = bonusDMG * (1 + (1 - NPC.GetDamageMultiplierVersus(myHero, target)) + (1 - NPC.GetArmorDamageMultiplier(target)))
				minCreepDamage = minCreepDamage + bonusPureDMG
			end
		end
	end

	if NPC.HasModifier(myHero, "modifier_storm_spirit_overload") then
		local overload = NPC.GetAbility(myHero, "storm_spirit_overload")
		local bonus = 0
		if overload and Ability.GetLevel(overload) > 0 then
			bonus = Ability.GetDamage(overload)
		end
		local bonusTrue = (1 - NPC.GetMagicalArmorValue(target)) * bonus + bonus * (Hero.GetIntellectTotal(myHero) / 14 / 100)
		minCreepDamage = minCreepDamage + bonusTrue
	end

	local overallCreepDamage = minCreepDamage + bonusCreepDamage

	return math.floor(overallCreepDamage)

end

function LastHitUltra.lastHitterTimingOffsetter(myHero, target)

	if not myHero then return 0 end
	if not target then return 0 end
	if target and not Entity.IsNPC(target) then return 0 end

	local increasedAS = NPC.GetIncreasedAttackSpeed(myHero)

	local attackPoint = 0
	local projectileSpeed = 0
	for i, v in pairs(LastHitUltra.attackPointTable) do
		if i == NPC.GetUnitName(myHero) then
			if NPC.IsRanged(myHero) then
				attackPoint = v[1] / (1 + (increasedAS/100))
				projectileSpeed = v[3]
				break
			else
				attackPoint = v[1] / (1 + (increasedAS/100))
				projectileSpeed = 0
				break
			end
		end
	end

	local faceTime = math.max(NPC.GetTimeToFace(myHero, target) - ((0.033 * math.pi / NPC.GetTurnRate(myHero) / 180) * 11.5), 0)

	local myAttackRange = NPC.GetAttackRange(myHero)
	local myMovementSpeed = NPC.GetMoveSpeed(myHero)
	local distanceToTarget = (Entity.GetAbsOrigin(myHero) - Entity.GetAbsOrigin(target)):Length2D()
	local projectileDistance = distanceToTarget - math.max(distanceToTarget - (myAttackRange + NPC.GetHullRadius(myHero) + NPC.GetHullRadius(target)), 0)
	local moveDistance = distanceToTarget - projectileDistance

	local projectileOffset = 0
		if projectileSpeed > 0 then
			projectileOffset = (projectileDistance - 24) / projectileSpeed
		end

	local moveTime = 0
		if moveDistance > 0 then
			moveTime = moveDistance / myMovementSpeed
		end

	local overallOffset = LastHitUltra.utilityRoundNumber(attackPoint + projectileOffset + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) + faceTime + moveTime, 3)

	return overallOffset or 0

end

function LastHitUltra.lastHitGetAttackerCount(myHero, target)

	if not myHero then return 0 end
	if not target then return 0 end

	local count = 0
	for i, v in pairs(LastHitUltra.lastHitCreepHPPrediction) do
		if i and Entity.IsEntity(i) and Entity.IsNPC(i) and Entity.IsAlive(i) then
			if i == target then
				local temp = {}
				for k, l in ipairs(v) do
					if not LastHitUltra.utilityIsInTable(temp, l[3]) and GameRules.GetGameTime() > l[1] then
						table.insert(temp, l[3])
					end
				end
				count = #temp or 0
			end
		end
	end
				
	return count

end

function LastHitUltra.heroCanCastSpells(myHero, enemy)

	if not myHero then return false end
	if not Entity.IsAlive(myHero) then return false end

	if NPC.IsSilenced(myHero) then return false end 
	if NPC.IsStunned(myHero) then return false end
	if NPC.HasModifier(myHero, "modifier_bashed") then return false end
	if NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then return false end	
	if NPC.HasModifier(myHero, "modifier_eul_cyclone") then return false end
	if NPC.HasModifier(myHero, "modifier_obsidian_destroyer_astral_imprisonment_prison") then return false end
	if NPC.HasModifier(myHero, "modifier_shadow_demon_disruption") then return false end	
	if NPC.HasModifier(myHero, "modifier_invoker_tornado") then return false end
	if NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_HEXED) then return false end
	if NPC.HasModifier(myHero, "modifier_legion_commander_duel") then return false end
	if NPC.HasModifier(myHero, "modifier_axe_berserkers_call") then return false end
	if NPC.HasModifier(myHero, "modifier_winter_wyvern_winters_curse") then return false end
	if NPC.HasModifier(myHero, "modifier_bane_fiends_grip") then return false end
	if NPC.HasModifier(myHero, "modifier_bane_nightmare") then return false end
	if NPC.HasModifier(myHero, "modifier_faceless_void_chronosphere_freeze") then return false end
	if NPC.HasModifier(myHero, "modifier_enigma_black_hole_pull") then return false end
	if NPC.HasModifier(myHero, "modifier_magnataur_reverse_polarity") then return false end
	if NPC.HasModifier(myHero, "modifier_pudge_dismember") then return false end
	if NPC.HasModifier(myHero, "modifier_shadow_shaman_shackles") then return false end
	if NPC.HasModifier(myHero, "modifier_techies_stasis_trap_stunned") then return false end
	if NPC.HasModifier(myHero, "modifier_storm_spirit_electric_vortex_pull") then return false end
	if NPC.HasModifier(myHero, "modifier_tidehunter_ravage") then return false end
	if NPC.HasModifier(myHero, "modifier_windrunner_shackle_shot") then return false end
	if NPC.HasModifier(myHero, "modifier_item_nullifier_mute") then return false end

	if enemy then
		if NPC.HasModifier(enemy, "modifier_item_aeon_disk_buff") then return false end
	end

	return true	

end

function LastHitUltra.lastHitBackswingChecker(myHero)

	if not myHero then return false end

	local increasedAS = NPC.GetIncreasedAttackSpeed(myHero)
	local attackTime = NPC.GetAttackTime(myHero)
	local attackPoint
	local attackBackSwing
	for i, v in pairs(LastHitUltra.attackPointTable) do
		if i == NPC.GetUnitName(myHero) then
			attackPoint = v[1] / (1 + (increasedAS/100))
			attackBackSwing = v[2] / (1 + (increasedAS/100))
			break
		end
	end

	local idleTime = attackTime - attackPoint - attackBackSwing

	if NPC.IsRanged(myHero) then
		if LastHitUltra.AttackProjectileCreate > 0 then
			if os.clock() > LastHitUltra.AttackAnimationCreate and os.clock() < LastHitUltra.AttackProjectileCreate + attackBackSwing + idleTime then
				return true
			else
				return false
			end
		end
	else
		if LastHitUltra.AttackParticleCreate > 0 then
			if NPC.HasItem(myHero, "item_echo_sabre", true) then
				if Ability.SecondsSinceLastUse(NPC.GetItem(myHero, "item_echo_sabre", true)) > -1 and Ability.SecondsSinceLastUse(NPC.GetItem(myHero, "item_echo_sabre", true)) < (attackPoint / 1.49) + 0.15 then
					return false
				else
					if os.clock() > LastHitUltra.AttackAnimationCreate and os.clock() < LastHitUltra.AttackParticleCreate + attackBackSwing + idleTime then
						return true
					else
						return false
					end
				end
			else
				if os.clock() > LastHitUltra.AttackAnimationCreate and os.clock() < LastHitUltra.AttackParticleCreate + attackBackSwing + idleTime then
					return true
				else
					return false
				end
			end
		end
	end

	return false

end

function LastHitUltra.GenericMainAttack(myHero, attackType, target, position)
	
	if not myHero then return end
	if not target and not position then return end

	if LastHitUltra.isHeroChannelling(myHero) == true then return end
	if LastHitUltra.heroCanCastItems(myHero) == false then return end
	if LastHitUltra.IsInAbilityPhase(myHero) == true then return end

	if Menu.IsEnabled(LastHitUltra.optionOrbwalkEnable) then
		if target ~= nil then
			if NPC.HasModifier(myHero, "modifier_windrunner_focusfire") then
				LastHitUltra.GenericAttackIssuer(attackType, target, position, myHero)
			elseif NPC.HasModifier(myHero, "modifier_item_hurricane_pike_range") then
				LastHitUltra.GenericAttackIssuer(attackType, target, position, myHero)
			else
				LastHitUltra.OrbWalker(myHero, target)
			end
		else
			LastHitUltra.GenericAttackIssuer(attackType, target, position, myHero)
		end
	else
		LastHitUltra.GenericAttackIssuer(attackType, target, position, myHero)
	end

end

function LastHitUltra.lastHitInAttackAnimation(myHero, attackPoint)

	if not myHero then return false end
	if not attackPoint then return false end
		if attackPoint == 0 then return false end

	if os.clock() >= LastHitUltra.AttackAnimationCreate - 0.035 then
		if os.clock() <= (LastHitUltra.AttackAnimationCreate + attackPoint + 0.075) then
			return true
		end
	end

	return false

end

function LastHitUltra.targetChecker(genericEnemyEntity)

	local myHero = Heroes.GetLocal()
		if not myHero then return end

	if genericEnemyEntity and not NPC.IsDormant(genericEnemyEntity) and not NPC.IsIllusion(genericEnemyEntity) and Entity.GetHealth(genericEnemyEntity) > 0 then

		if Menu.IsEnabled(LastHitUltra.optionTargetCheckAM) then
			if NPC.GetUnitName(genericEnemyEntity) == "npc_dota_hero_antimage" and NPC.HasItem(genericEnemyEntity, "item_ultimate_scepter", true) and NPC.HasModifier(genericEnemyEntity, "modifier_antimage_spell_shield") and Ability.IsReady(NPC.GetAbility(genericEnemyEntity, "antimage_spell_shield")) then
				return
			end
		end
		if Menu.IsEnabled(LastHitUltra.optionTargetCheckLotus) then
			if NPC.HasModifier(genericEnemyEntity, "modifier_item_lotus_orb_active") then
				return
			end
		end
		if Menu.IsEnabled(LastHitUltra.optionTargetCheckBlademail) then
			if NPC.HasModifier(genericEnemyEntity, "modifier_item_blade_mail_reflect") and Entity.GetHealth(Heroes.GetLocal()) <= 0.25 * Entity.GetMaxHealth(Heroes.GetLocal()) then
				return
			end
		end
		if Menu.IsEnabled(LastHitUltra.optionTargetCheckNyx) then
			if NPC.HasModifier(genericEnemyEntity, "modifier_nyx_assassin_spiked_carapace") then
				return
			end
		end
		if Menu.IsEnabled(LastHitUltra.optionTargetCheckUrsa) then
			if NPC.HasModifier(genericEnemyEntity, "modifier_ursa_enrage") then
				return
			end
		end
		if Menu.IsEnabled(LastHitUltra.optionTargetCheckAbbadon) then
			if NPC.HasModifier(genericEnemyEntity, "modifier_abaddon_borrowed_time") then
				return
			end
		end
		if Menu.IsEnabled(LastHitUltra.optionTargetCheckDazzle) then
			if NPC.HasModifier(genericEnemyEntity, "modifier_dazzle_shallow_grave") and NPC.GetUnitName(myHero) ~= "npc_dota_hero_axe" then
				return
			end
		end
		if NPC.HasModifier(genericEnemyEntity, "modifier_skeleton_king_reincarnation_scepter_active") then
			return
		end
		if NPC.HasModifier(genericEnemyEntity, "modifier_winter_wyvern_winters_curse") then
			return
		end

	return genericEnemyEntity
	end	
end

function LastHitUltra.utilityRoundNumber(number, digits)

	if not number then return end

  	local mult = 10^(digits or 0)
  	return math.floor(number * mult + 0.5) / mult

end

function LastHitUltra.lastHitterGetTarget(myHero, creep)

	if not myHero then return end
	if not creep then return end

	if not Entity.IsNPC(creep) then return end
	if not NPC.IsLaneCreep(creep) then return end
	if NPC.IsRanged(creep) then return end
	if not Entity.IsAlive(creep) then return end
	
	local creepRotation = Entity.GetRotation(creep):GetForward():Normalized()
	
	local targets = Entity.GetUnitsInRadius(creep, 148, Enum.TeamType.TEAM_ENEMY)
	if not targets or next(targets) == nil or #targets < 1 then return end

	if #targets == 1 then
		if Entity.IsNPC(targets[1]) and NPC.IsLaneCreep(targets[1]) then
			return targets[1]
		end
	else
		local adjustedHullSize = 20
		for i, v in ipairs(targets) do
			if v and Entity.IsNPC(v) and NPC.IsLaneCreep(v) and Entity.IsAlive(v) then
				local vpos = Entity.GetAbsOrigin(v)
				local vposZ = vpos:GetZ()
				local pos = Entity.GetAbsOrigin(creep)
				for i = 1, 9 do
					local searchPos = pos + creepRotation:Scaled(25*(9-i))
						searchPos:SetZ(vposZ)
					if NPC.IsPositionInRange(v, searchPos, adjustedHullSize, 0) then
						return v
					end
				end
			end
		end
	end

	return

end

function LastHitUltra.utilityGetTableLength(table)

	if not table then return 0 end
	if next(table) == nil then return 0 end

	local count = 0
	for i, v in pairs(table) do
		count = count + 1
	end

	return count

end

function LastHitUltra.utilityIsInTable(table, arg)

	if not table then return false end
	if not arg then return false end
	if next(table) == nil then return false end

	for i, v in pairs(table) do
		if i == arg then
			return true
		end
		if type(v) ~= 'table' and v == arg then
			return true
		end
	end

	return false

end

function LastHitUltra.isHeroChannelling(myHero)

	if not myHero then return true end

	if NPC.IsChannellingAbility(myHero) then return true end
	if NPC.HasModifier(myHero, "modifier_teleporting") then return true end

	return false

end

function LastHitUltra.lastHitterDrawing(myHero)

	if not myHero then return end
	if not Menu.IsEnabled(LastHitUltra.optionLastHitDrawCreepEnable) then return end
	
	if next(LastHitUltra.lastHitCreepHPPredictionTime) == nil then return end

	if Menu.IsEnabled(LastHitUltra.optionLastHitDrawCreepTimer) then
		local imageHandle = LastHitUltra.lastHitterKillableImage
			if imageHandle == nil then
				imageHandle = Renderer.LoadImage("resource/flash3/images/heroes/selection/fav_heart.png")
				LastHitUltra.lastHitterKillableImage = imageHandle
			end
		for i, v in pairs(LastHitUltra.lastHitCreepHPPredictionTime) do
			local target = i
			local dieTime = v
			if target and Entity.IsEntity(target) and Entity.IsNPC(target) then
				local pos = Entity.GetAbsOrigin(target)
				local posY = NPC.GetHealthBarOffset(target)
					pos:SetZ(pos:GetZ() + posY)	
				local x, y, visible = Renderer.WorldToScreen(pos)
				if Menu.GetValue(LastHitUltra.optionLastHitDrawStyle) < 1 then
					if visible then
						if dieTime - GameRules.GetGameTime() > LastHitUltra.lastHitterTimingOffsetter(myHero, target) then
							Renderer.SetDrawColor(255,215,0,200)
							Renderer.DrawImage(imageHandle, x-20, y-49, 40, 40)
						else
							Renderer.SetDrawColor(50,205,50,200)
							Renderer.DrawImage(imageHandle, x-20, y-49, 40, 40)
						end
					end
				else
					if not Entity.IsSameTeam(myHero, i) then
						if visible then
							if dieTime - GameRules.GetGameTime() > LastHitUltra.lastHitterTimingOffsetter(myHero, target) then
								Renderer.SetDrawColor(255,215,0,200)
								Renderer.DrawImage(imageHandle, x-20, y-49, 40, 40)
							else
								Renderer.SetDrawColor(50,205,50,200)
								Renderer.DrawImage(imageHandle, x-20, y-49, 40, 40)
							end
						end
					end
				end
			end
		end
	end

end

function LastHitUltra.OnDraw()
	local myHero = Heroes.GetLocal()
        	if not myHero then return end
		if not Entity.IsAlive(myHero) then return end
	LastHitUltra.lastHitterDrawing(myHero)
end

return LastHitUltra