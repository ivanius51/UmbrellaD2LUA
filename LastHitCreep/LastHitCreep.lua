--[[
Ivanius51 13.07.2016 АвтоДенай крипов + подсвечивание
22.07.2016 Убрал спам атаки
04.02.2017 Переработана формула расчтеа учитвая последние патчи
25.05.2018 - 30.05.2018 Переведено на LUA, добавлено правильное предсказание, изменены настройки
02.06 - calculation reworked, added prediction configs, add prediction helper.
03.06 no Prevent Player.
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

----------------------TODO---------------------
Priority creeps, by calculate PossiblyMissedDPS on DmgTime + AttackTime
--TODO: rewrite - dont calculate it, write it every...

local Game = {};
function Game.AttackTarget(target, entity, queue)
	if type(target) ~= "number" then
		error("no target");
	end;
	return Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_ATTACK_TARGET, target, Vector(0, 0, 0), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, entity or nil, queue or false);
end;
function Game.MoveTo(xyz, entity, queue)
	if xyz == nil then
		return
	end;
	return Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, xyz, nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, entity or nil, queue or false);
end;
--]]

--LUA additional functions
-- Convert a lua table into a lua syntactically correct string
function table.tostring(list)
	local result = "{";
	for k, v in pairs(list) do
			-- Check the key type (ignore any numerical keys - assume its an array)
			if type(k) == "string" then
					result = result.."[\""..k.."\"]".."=";
			end;

			-- Check the value type
			if type(v) == "table" then
					result = result..table.tostring(v);
			elseif type(v) == "boolean" then
					result = result..tostring(v);
			else
					result = result.."\""..v.."\"";
			end;
			result = result..",";
	end;
	-- Remove leading commas from the result
	if result ~= "" then
			result = result:sub(1, result:len()-1);
	end;
	return result.."}";
end;

table.reduce = function (list, fn, count) 
	local acc
	for k, v in ipairs(list) do
		if 1 == k then
			acc = v;
		else
			acc = fn(acc, v);
		end; 
		if k>= count then
			break;
		end;
	end;
	return acc;
end;

function table.sum(list, count)
	if not count then
		count = #list;
	end;
	return 
		table.reduce(
			list,
			function (a, b)
				return a + b
			end,
			count
		);
end;

function spairs(t, order)
	-- collect the keys
	local keys = {};
	for k in pairs(t) do 
		keys[#keys+1] = k;
	end;

	-- if order function given, sort by it by passing the table and keys a, b,
	-- otherwise just sort the keys 
	if order then
			table.sort(keys, function(a,b) return order(t, a, b) end);
	else
			table.sort(keys);
	end;

	-- return the iterator function
	local i = 0;
	return function()
			i = i + 1
			if keys[i] then
				return keys[i], t[keys[i]];
			end;
	end;
end;

function RoundNumber(num, idp)
	local mult = 10^(idp or 0);
	return math.floor(num * mult + 0.5) / mult;
end

function VectorDistance (a, b)
	return (a - b):Length2D();
end;
function NPC.Distance (a, b)
	local av = Entity.GetAbsOrigin(a);
	local bv = Entity.GetAbsOrigin(b);
	return VectorDistance(av, bv);
end;
--LUA additional functions

local HeroInfo = require("scripts.settings.HeroInfo");

local LastHitCreep = {};
LastHitCreep.Menu = {};
LastHitCreep.User = {};
LastHitCreep.Particles = {};
LastHitCreep.SkillModifiers = {
	["modifier_item_quelling_blade"]= {24,7},
	["modifier_item_bfury"] = {0.5,0.25},
	--["modifier_item_iron_talon"] = {1.4},
	["modifier_bloodseeker_bloodrage"] = {0.25,0.3,0.35,0.4}
}

--options
LastHitCreep.Menu.Path = {"Utility", "Last Hit Creep"};
LastHitCreep.Menu.Path.CreepTypes = {"Utility", "Last Hit Creep", "Creep Types"};
LastHitCreep.Menu.Enabled = Menu.AddOptionBool(LastHitCreep.Menu.Path, "Enabled", false);
LastHitCreep.Menu.Education = Menu.AddOptionBool(LastHitCreep.Menu.Path, "Education Mode", false);
LastHitCreep.Menu.AttackMove = Menu.AddOptionBool(LastHitCreep.Menu.Path, "Attack Move", false);
LastHitCreep.Menu.Prediction = Menu.AddOptionCombo(LastHitCreep.Menu.Path, "Predict", {" Disabled", " Creeps Die", " Player Last Hit"}, 0);
LastHitCreep.Menu.ShowPrediction = Menu.AddOptionCombo(LastHitCreep.Menu.Path, "Show Prediction", {" Disabled", " Enemy", " Allies", " Both"}, 0);
LastHitCreep.Menu.LastHitKey = Menu.AddKeyOption(LastHitCreep.Menu.Path, "Last Hit Key", Enum.ButtonCode.KEY_P);
LastHitCreep.Menu.Enemys = Menu.AddOptionBool(LastHitCreep.Menu.Path.CreepTypes, "Kill Enemys", false);
LastHitCreep.Menu.Friendlys = Menu.AddOptionBool(LastHitCreep.Menu.Path.CreepTypes, "Deny Allies", false);
LastHitCreep.Menu.Neutrals = Menu.AddOptionBool(LastHitCreep.Menu.Path.CreepTypes, "Kill Neutrals", false);

LastHitCreep.Particles = {};
LastHitCreep.Particles.Target = {};
LastHitCreep.Creeps = nil;
LastHitCreep.CreepsDPS = {};
LastHitCreep.CreepsPredictedDieTime = {};
LastHitCreep.UpdateTime = 0.10;
LastHitCreep.User.UpdateTime = 0.10;
LastHitCreep.DPSMult = (1 / LastHitCreep.UpdateTime);

--menu options
function LastHitCreep.isEnabled()
	return Menu.IsEnabled(LastHitCreep.Menu.Enabled);
end;
function LastHitCreep.isHitKeyDown()
	return Menu.IsKeyDown(LastHitCreep.Menu.LastHitKey);
end;
function LastHitCreep.isEducation()
	return Menu.IsEnabled(LastHitCreep.Menu.Education);
end;
function LastHitCreep.isAttackMove()
	return Menu.IsEnabled(LastHitCreep.Menu.AttackMove);
end;
function LastHitCreep.isPrediction()
	return Menu.GetValue(LastHitCreep.Menu.Prediction) ~= 0;
end;
function LastHitCreep.GetPrediction()
	return Menu.GetValue(LastHitCreep.Menu.Prediction);
end;
function LastHitCreep.GetShowPrediction()
	return Menu.GetValue(LastHitCreep.Menu.ShowPrediction);
end;
function LastHitCreep.isKillEnemys()
	return Menu.IsEnabled(LastHitCreep.Menu.Enemys);
end;
function LastHitCreep.isDenyFriendlys()
	return Menu.IsEnabled(LastHitCreep.Menu.Friendlys);
end;
function LastHitCreep.isKillNeutrals()
	return Menu.IsEnabled(LastHitCreep.Menu.Neutrals);
end;
--end menu options

--particles
function LastHitCreep.CreateOverheadParticle(index, ent, name)
	if (ent == nil) then
		return false;
	end;
	if (LastHitCreep.Particles[tonumber(index)] == nil) then
		LastHitCreep.Particles[tonumber(index)] = {};
		LastHitCreep.Particles[tonumber(index)].ID = Particle.Create(name, Enum.ParticleAttachment.PATTACH_OVERHEAD_FOLLOW, ent);
		return true;
	end;
	return false;
end;

function LastHitCreep.CreateTargetingParticle(caster, target)
	if (caster == nil) or (target == nil) then
		return false;
	end;
	local newParicle = 0;
	if (LastHitCreep.Particles[caster] == nil) then
		LastHitCreep.Particles[caster] = {};
		newParicle = Particle.Create("particles/ui_mouseactions/range_finder_tower_aoe.vpcf", Enum.ParticleAttachment.PATTACH_ABSORIGIN_FOLLOW, target);
	else
		if (LastHitCreep.Particles[caster].ID ~= nil) then
			Particle.Destroy(LastHitCreep.Particles[caster].ID);
		end;
		newParicle = Particle.Create("particles/ui_mouseactions/range_finder_tower_aoe.vpcf", Enum.ParticleAttachment.PATTACH_ABSORIGIN_FOLLOW, target);
	end;
	if newParicle ~= 0 then
		Particle.SetControlPoint(newParicle, 2, Entity.GetOrigin(caster));
		Particle.SetControlPoint(newParicle, 6, Vector(1, 0, 0));
		Particle.SetControlPoint(newParicle, 7, Entity.GetOrigin(target));
		LastHitCreep.Particles[caster].ID = newParicle;
		LastHitCreep.Particles[caster].Target = target;
		return true;
	end;
	return false;
end;

function LastHitCreep.ClearParticle(index)
	if (LastHitCreep.Particles[tonumber(index)] ~= nil) then
		Particle.Destroy(LastHitCreep.Particles[tonumber(index)].ID);
		LastHitCreep.Particles[tonumber(index)] = nil;
	end;
end;
--end particles

function LastHitCreep.IsInvisible(user)
	if not user then return false end;
	if NPC.HasState(user, Enum.ModifierState.MODIFIER_STATE_INVISIBLE) then return true end;
	if NPC.HasModifier(user, "modifier_invisible") then return true end;
	if NPC.HasModifier(user, "modifier_invoker_ghost_walk_self") then return true end;
	if NPC.HasModifier(user, "modifier_item_invisibility_edge_windwalk") then return true end;
	if NPC.HasModifier(user, "modifier_item_silver_edge_windwalk") then return true end;
	if NPC.HasModifier(user, "modifier_item_glimmer_cape_fade") then return true end;
end;

function LastHitCreep.IsCastNow(user)
	if not user then return false end;	
	if NPC.IsChannellingAbility(user) then return true end;
	if NPC.HasModifier(user, "modifier_teleporting") then return true end;
	for i=0, 24 do	
		local abil = NPC.GetAbilityByIndex(user, i);
		if abil and Entity.IsEntity(abil) and (Ability.GetLevel(abil) >= 1) and not Ability.IsHidden(abil) and not Ability.IsPassive(abil) and Ability.IsInAbilityPhase(abil) then
			Log.Write(Ability.GetName(abil));
			return true;
		end;
	end;
end;

function LastHitCreep.PreventPlayer(user)
	if not user then return false end;
	if LastHitCreep.IsCastNow(user) then return true end;
	if LastHitCreep.IsInvisible(user) then return true end;
end;

function LastHitCreep.CanCastSpells(caster, enemy)

	if not caster then return false end;
	if not Entity.IsAlive(caster) then return false end;

	if NPC.IsSilenced(caster) then return false end;
	if NPC.IsStunned(caster) then return false end;
	if NPC.HasModifier(caster, "modifier_bashed") then return false end;
	if NPC.HasState(caster, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then return false end;
	if NPC.HasModifier(caster, "modifier_eul_cyclone") then return false end;
	if NPC.HasModifier(caster, "modifier_obsidian_destroyer_astral_imprisonment_prison") then return false end;
	if NPC.HasModifier(caster, "modifier_shadow_demon_disruption") then return false end;
	if NPC.HasModifier(caster, "modifier_invoker_tornado") then return false end;
	if NPC.HasState(caster, Enum.ModifierState.MODIFIER_STATE_HEXED) then return false end;
	if NPC.HasModifier(caster, "modifier_legion_commander_duel") then return false end;
	if NPC.HasModifier(caster, "modifier_axe_berserkers_call") then return false end;
	if NPC.HasModifier(caster, "modifier_winter_wyvern_winters_curse") then return false end;
	if NPC.HasModifier(caster, "modifier_bane_fiends_grip") then return false end;
	if NPC.HasModifier(caster, "modifier_bane_nightmare") then return false end;
	if NPC.HasModifier(caster, "modifier_faceless_void_chronosphere_freeze") then return false end;
	if NPC.HasModifier(caster, "modifier_enigma_black_hole_pull") then return false end;
	if NPC.HasModifier(caster, "modifier_magnataur_reverse_polarity") then return false end;
	if NPC.HasModifier(caster, "modifier_pudge_dismember") then return false end;
	if NPC.HasModifier(caster, "modifier_shadow_shaman_shackles") then return false end;
	if NPC.HasModifier(caster, "modifier_techies_stasis_trap_stunned") then return false end;
	if NPC.HasModifier(caster, "modifier_storm_spirit_electric_vortex_pull") then return false end;
	if NPC.HasModifier(caster, "modifier_tidehunter_ravage") then return false end;
	if NPC.HasModifier(caster, "modifier_windrunner_shackle_shot") then return false end;
	if NPC.HasModifier(caster, "modifier_item_nullifier_mute") then return false end;
	if enemy then
		if NPC.HasModifier(enemy, "modifier_item_aeon_disk_buff") then return false end;
	end
	return true;
end;

function LastHitCreep.RightNameFromModifier(mod)
	return string.gsub(mod, "modifier_", "", 1);
end;

function DamageMulOrAdd (Damage, Bonus, mod)
	if math.abs(mod)<2 then
		return Bonus + (Damage + Bonus) * mod;
	else
		return Bonus + mod;
	end;
end;

function LastHitCreep.DamageToCreep(ent)

	if not ent then 
		return 0;
	end;

	local Damage = NPC.GetTrueDamage(ent) + math.floor((NPC.GetTrueMaximumDamage(ent) - NPC.GetTrueDamage(ent)) / 4);
	local BonusDamage = 0;

	for mod, mul in pairs(LastHitCreep.SkillModifiers) do
		local modifier = NPC.GetModifier(ent, mod);
		if modifier then
			if #mul == 2 then
				local indexvalue = 1;
				if NPC.IsRanged(ent) then
					indexvalue = 2;
				end;
				BonusDamage = DamageMulOrAdd(Damage, BonusDamage, mul[indexvalue]);
			else
				local abil = Modifier.GetAbility(modifier);--NPC.GetAbility(ent, LastHitCreep.RightNameFromModifier(mod));
				if abil then
					BonusDamage = DamageMulOrAdd(Damage, BonusDamage, mul[Ability.GetLevel(abil)]);
				end;
			end;
		end;
	end;

	return Damage + BonusDamage;
end;

function LastHitCreep.ReCalcAttackPoint()
	LastHitCreep.User.IncreasedAS = NPC.GetIncreasedAttackSpeed(LastHitCreep.User.Hero);
	local attackSpeed = LastHitCreep.User.AttackPoint / (1 + (LastHitCreep.User.IncreasedAS / 100));
	LastHitCreep.User.TrueAttackPoint = attackSpeed + (LastHitCreep.User.AttackPoint * 0.17);
	return LastHitCreep.User.TrueAttackPoint;
end;
--dont use without call ReCalcAttackPoint() first, one time to all cycle
--Attack time hero to target
function LastHitCreep.CalcAttackTimeTo(target)
	if not target then
		return 0;-- error=-1?
	end;
	--Time for turning to target 
	local FaceTime = math.max(NPC.GetTimeToFace(LastHitCreep.User.Hero, target) - ((0.033 * math.pi / NPC.GetTurnRate(LastHitCreep.User.Hero) / 180) * 11.5), 0);

	local DistanceToTarget = math.ceil(NPC.Distance(target, LastHitCreep.User.Hero));
	local ProjectileDistance = DistanceToTarget - math.max(DistanceToTarget - (LastHitCreep.User.AttackRange + LastHitCreep.User.HullRadius + NPC.GetHullRadius(target)), 0);
	local MoveDistance = 0;
	local MoveTime = 0;
	if DistanceToTarget>ProjectileDistance then
		local MoveDistance = DistanceToTarget - ProjectileDistance;
		local MoveTime = math.ceil(MoveDistance/LastHitCreep.User.MoveSpeed) * 3;
	end;
	local ProjectileTime = 0;
	if NPC.IsRanged(LastHitCreep.User.Hero) and (LastHitCreep.User.ProjectileSpeed > 0) then
		ProjectileTime = ((ProjectileDistance - 24) / LastHitCreep.User.ProjectileSpeed);
	end;
	
	local AttackTime = RoundNumber(LastHitCreep.User.TrueAttackPoint + ProjectileTime + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) + FaceTime + MoveTime, 3);
	return AttackTime;
end;

function LastHitCreep.User.Read()
	LastHitCreep.User.Hero = Heroes.GetLocal();
	if not LastHitCreep.User.Hero then
		return false;
	end;
	
	LastHitCreep.User.Name = NPC.GetUnitName(LastHitCreep.User.Hero);
	LastHitCreep.User.IncreasedAS = NPC.GetIncreasedAttackSpeed(LastHitCreep.User.Hero);
	LastHitCreep.User.AttackPoint = HeroInfo[LastHitCreep.User.Name].AttackPoint
	LastHitCreep.ReCalcAttackPoint();
	--LastHitCreep.User.TrueAttackPoint = LastHitCreep.User.AttackPoint / (1 + (LastHitCreep.User.IncreasedAS / 100)) + (LastHitCreep.User.AttackPoint * 0.17);
	LastHitCreep.User.AttackBackSwing = HeroInfo[LastHitCreep.User.Name].AttackBackSwing;
	LastHitCreep.User.AttackTime = NPC.GetAttackTime(LastHitCreep.User.Hero);-- + LastHitCreep.User.AttackPoint;-- + LastHitCreep.User.AttackBackSwing;
	LastHitCreep.User.Damage = NPC.GetTrueDamage(LastHitCreep.User.Hero);
	LastHitCreep.User.MaximumDamage = NPC.GetTrueMaximumDamage(LastHitCreep.User.Hero);

	LastHitCreep.User.ProjectileSpeed = 0;
	LastHitCreep.User.TrueDamage = LastHitCreep.User.Damage + math.ceil((LastHitCreep.User.MaximumDamage - LastHitCreep.User.Damage) / 2);
	LastHitCreep.User.IsRanged = NPC.IsRanged(LastHitCreep.User.Hero);
	if LastHitCreep.User.IsRanged then
		LastHitCreep.User.ProjectileSpeed = HeroInfo[LastHitCreep.User.Name].ProjectileSpeed;
	end;
	LastHitCreep.User.AttackRange = NPC.GetAttackRange(LastHitCreep.User.Hero);
	LastHitCreep.User.HullRadius =  NPC.GetHullRadius(LastHitCreep.User.Hero);
	LastHitCreep.User.MoveSpeed = NPC.GetMoveSpeed(LastHitCreep.User.Hero);

	LastHitCreep.User.DamageToCreep = LastHitCreep.DamageToCreep(LastHitCreep.User.Hero);

	return true;
end;

function LastHitCreep.Initialization()
	math.randomseed(os.time());
	LastHitCreep.User.Read();
	LastHitCreep.User.LastTarget = nil;
	LastHitCreep.User.LastAttackTime = os.clock();
	LastHitCreep.User.LastUpdateTime = os.clock();
	LastHitCreep.LastUpdateTime = os.clock();
	LastHitCreep.User.LastMoveTime = os.clock();
	for k in pairs(LastHitCreep.Particles) do
		LastHitCreep.Particles[k] = nil;
	end;
	--Log.Write(NPC.GetUnitName(LastHitCreep.User.Hero).." "..tostring(HeroInfo[NPC.GetUnitName(LastHitCreep.User.Hero)].AttackPoint));
end;

function LastHitCreep.Finalization()
	LastHitCreep.User.Hero = nil;
	for k in pairs(LastHitCreep.Particles) do
		LastHitCreep.ClearParticle(k);
	end;
end;

function LastHitCreep.WriteCreepHPAround(list, ent, range, team)
	--calculate DPS
	--TODO: rewrite - dont calculate it, write it every...
	LastHitCreep.Creeps = Entity.GetUnitsInRadius(ent, range, team);
	for k, npc in ipairs(LastHitCreep.Creeps) do
		if npc and Entity.IsEntity(npc) and Entity.IsAlive(npc) and Entity.IsNPC(npc) and NPC.IsLaneCreep(npc) then
			--todo incapsulate it
			if list[npc] == nil then
				list[npc] = {};
				list[npc].HP = math.floor(Entity.GetHealth(npc) + NPC.GetHealthRegen(npc));
				list[npc].OldHP = list[npc].HP;
				list[npc].DPS = -1; 
				list[npc].Damage = {}; 
			else
				list[npc].OldHP = list[npc].HP;
				list[npc].HP = math.floor(Entity.GetHealth(npc) + NPC.GetHealthRegen(npc));
				local curDPS = (list[npc].OldHP-list[npc].HP);
				table.insert(list[npc].Damage, curDPS);
				if (#list[npc].Damage > (LastHitCreep.DPSMult * 2)) then
					table.remove(list[npc].Damage,1);
				end;
			end;
		end;
	end;
end;

function LastHitCreep.PredictCreepHPAround(list, ent, range, team)
	local Creeps = Entity.GetUnitsInRadius(ent, range, team);
	if not Creeps or (#Creeps<=1) then
		return;
	end; 
	LastHitCreep.ReCalcAttackPoint();
	for k, npc in ipairs(Creeps) do
		if npc and Entity.IsEntity(npc) and Entity.IsAlive(npc) and Entity.IsNPC(npc) and NPC.IsLaneCreep(npc) then
			local HP =  math.floor(Entity.GetHealth(npc) + NPC.GetHealthRegen(npc));
			if (list[npc] == nil) then
				list[npc] = {};
				list[npc].HP = HP;
				list[npc].OldHP = HP;
				list[npc].DieTime = 0; 
				list[npc].DPS = nil;
			else
				local OldHP = list[npc].HP;
				local DamageTaken = (OldHP-HP);
				if (DamageTaken>0) then
					list[npc].OldHP = OldHP;
					list[npc].HP = HP;
					if LastHitCreep.CreepsDPS[npc] and LastHitCreep.CreepsDPS[npc].Damage and (#LastHitCreep.CreepsDPS[npc].Damage >= LastHitCreep.DPSMult) then
						local HeroDamage = math.floor(NPC.GetDamageMultiplierVersus(LastHitCreep.User.Hero, npc) * LastHitCreep.User.DamageToCreep * NPC.GetArmorDamageMultiplier(npc) * 0.975);
						local DPS = math.floor((table.sum(LastHitCreep.CreepsDPS[npc].Damage) - DamageTaken) * LastHitCreep.DPSMult / #LastHitCreep.CreepsDPS[npc].Damage);
						local AttackTime = LastHitCreep.CalcAttackTimeTo(npc);
						list[npc].DPS = DPS;
						list[npc].HeroDamage = HeroDamage;
						list[npc].AttackTime = AttackTime;
						--Log.Write("HP="..HP.." DamageTaken="..DamageTaken.." DPS="..DPS.." "..table.tostring(LastHitCreep.CreepsDPS[npc].Damage));
						if (list[npc].DieTime == 0) then
							if LastHitCreep.GetPrediction() == 1 then-- Creep Die
								--list[npc].AttackTime = 0.45;--creep Attack Time
								if ((HP > DPS) and (HP < (DPS + DamageTaken))) then
									list[npc].DieTime = GameRules.GetGameTime() + 1 + AttackTime;
								elseif (HP < (DPS * 1.5)) then
									list[npc].DieTime = GameRules.GetGameTime() + (math.abs(HP-DPS) / DPS)  + AttackTime;
								end;
							elseif LastHitCreep.GetPrediction() == 2 then-- Player Can HittKill
								if (HP <= HeroDamage) then
									list[npc].DieTime = GameRules.GetGameTime() + AttackTime + 0.1;
								elseif ((HP > (DPS - HeroDamage * 0.25)) and (HP < (DPS + HeroDamage))) then
									list[npc].DieTime = GameRules.GetGameTime() + 1 + AttackTime;
								elseif (DPS < HeroDamage) then -- think about it
									--list[npc].DieTime = GameRules.GetGameTime() + LastHitCreep.User.AttackTime * math.ceil(HP / HeroDamage);
								end;
							end;
						end;
					end;
				end;
			end;
		end;
	end;
end;

function LastHitCreep.FindBestTarget()
	--sort and check list 
	local target = {nil, 0};
	--1) if (HP <= True Hero DMG) : 1 hit kill
	--2) if (HP <= True Hero DMG + Possibly Missed DPS) : 1 hit kill after attack time
	--3) if (DPS < MaxHP\10)) : 

	--(HP <= True Hero DMG) 
	--predicted.HP
	--predicted.DieTime
	--predicted.AttackTime
	--predicted.DPS
	--predicted.HeroDamage
	LastHitCreep.ReCalcAttackPoint();
	
	if (LastHitCreep.User.IsRanged) then
		if LastHitCreep.isPrediction() then
			for npc, predicted in spairs(LastHitCreep.CreepsPredictedDieTime, function(t, a, b) return t[b].DieTime > t[a].DieTime end) do
				if npc and predicted.DPS and Entity.IsEntity(npc) and Entity.IsAlive(npc) and Entity.IsNPC(npc) and  --NPC.IsLaneCreep(npc) and
					( (not Entity.IsSameTeam(npc, LastHitCreep.User.Hero)and LastHitCreep.isKillEnemys()) or (Entity.IsSameTeam(npc, LastHitCreep.User.Hero) and LastHitCreep.isDenyFriendlys()) ) and
					((predicted.DieTime - GameRules.GetGameTime()) > 0)
				then
					local AttackTime = LastHitCreep.CalcAttackTimeTo(npc);
					if ((predicted.DieTime - GameRules.GetGameTime()) >= AttackTime * 0.25) and ((predicted.DieTime - GameRules.GetGameTime()) <= AttackTime * 1.2) then
						--Log.Write("PR 1, HP="..predicted.HP.." DPS="..predicted.DPS.." DT="..(predicted.DieTime - GameRules.GetGameTime()).." AT="..AttackTime);
						return {npc, AttackTime};
					end;
				end;
			end;
		end;
		for npc, predicted in spairs(LastHitCreep.CreepsPredictedDieTime, function(t, a, b) return t[b].HP > t[a].HP end) do
			if npc and predicted.DPS and Entity.IsEntity(npc) and Entity.IsAlive(npc) and Entity.IsNPC(npc) and  --NPC.IsLaneCreep(npc) and
				( (not Entity.IsSameTeam(npc, LastHitCreep.User.Hero)and LastHitCreep.isKillEnemys()) or (Entity.IsSameTeam(npc, LastHitCreep.User.Hero) and LastHitCreep.isDenyFriendlys()) )
			then
				local AttackTime = LastHitCreep.CalcAttackTimeTo(npc);
				local HP = Entity.GetHealth(npc);
				if (HP <= (predicted.HeroDamage + predicted.DPS * AttackTime)) then
					--Log.Write("NP 1, HP="..HP.." DPS="..predicted.DPS.." AT="..AttackTime);
					return {npc, AttackTime};
				end;
			end;
		end;
	else -- melee
		if LastHitCreep.isPrediction() then
			for npc, predicted in spairs(LastHitCreep.CreepsPredictedDieTime, function(t, a, b) return t[b].DieTime > t[a].DieTime end) do
				if npc and predicted.DPS and Entity.IsEntity(npc) and Entity.IsAlive(npc) and Entity.IsNPC(npc) and  --NPC.IsLaneCreep(npc) and
					( (not Entity.IsSameTeam(npc, LastHitCreep.User.Hero)and LastHitCreep.isKillEnemys()) or (Entity.IsSameTeam(npc, LastHitCreep.User.Hero) and LastHitCreep.isDenyFriendlys()) ) and
					((predicted.DieTime - GameRules.GetGameTime()) > 0)
				then
					local AttackTime = LastHitCreep.CalcAttackTimeTo(npc);
					if ((predicted.DieTime - GameRules.GetGameTime()) >= AttackTime * 0.5) and ((predicted.DieTime - GameRules.GetGameTime()) <= AttackTime * 1.2) then
						--Log.Write("PR 1, HP="..predicted.HP.." DPS="..predicted.DPS.." DT="..(predicted.DieTime - GameRules.GetGameTime()).." AT="..AttackTime);
						return {npc, AttackTime};
					end;
				end;
			end;
		end;
		for npc, predicted in spairs(LastHitCreep.CreepsPredictedDieTime, function(t, a, b) return t[b].HP > t[a].HP end) do		
			if npc and predicted.DPS and Entity.IsEntity(npc) and Entity.IsAlive(npc) and Entity.IsNPC(npc) and
				( (not Entity.IsSameTeam(npc, LastHitCreep.User.Hero)and LastHitCreep.isKillEnemys()) or (Entity.IsSameTeam(npc, LastHitCreep.User.Hero) and LastHitCreep.isDenyFriendlys()) )
			then	
				local AttackTime = LastHitCreep.CalcAttackTimeTo(npc);
				local HP = Entity.GetHealth(npc);
				if (HP <= (predicted.HeroDamage + predicted.DPS * AttackTime)) then
					--Log.Write("NP 1, HP="..HP.." DPS="..predicted.DPS.." AT="..AttackTime);
					return {npc, AttackTime};
				end;
			end;	
		end;	
	end;

	return target;
end;

function LastHitCreep.ClearDiedInList()
	if not LastHitCreep.CreepsPredictedDieTime then return end;
	for npc, val in pairs(LastHitCreep.CreepsPredictedDieTime) do
		if npc and (not Entity.IsEntity(npc) or not Entity.IsAlive(npc)) then
			val = nil;
		end;
	end;
end;

function LastHitCreep.OnUpdate()
	if not LastHitCreep.isEnabled() then
		return;
	end;
	LastHitCreep.User.Hero = Heroes.GetLocal();
	if (LastHitCreep.User.Hero == nil) or not Entity.IsAlive(LastHitCreep.User.Hero) then 
		return;
	end;

	if ((os.clock() - LastHitCreep.User.LastUpdateTime) > LastHitCreep.User.UpdateTime) then
		--update user data
		if not LastHitCreep.User.Read() then
			return;
		end;
		LastHitCreep.User.LastUpdateTime = os.clock();
	end;

	--
	LastHitCreep.ClearDiedInList();
	LastHitCreep.PredictCreepHPAround(LastHitCreep.CreepsPredictedDieTime, LastHitCreep.User.Hero, LastHitCreep.User.AttackRange + 500, Enum.TeamType.TEAM_BOTH);

	if ((os.clock() - LastHitCreep.LastUpdateTime) > LastHitCreep.UpdateTime) then
		LastHitCreep.WriteCreepHPAround(LastHitCreep.CreepsDPS, LastHitCreep.User.Hero, LastHitCreep.User.AttackRange + 500, Enum.TeamType.TEAM_BOTH);
		LastHitCreep.LastUpdateTime = os.clock();
	end;

	if ((os.clock() - LastHitCreep.User.LastAttackTime) > LastHitCreep.User.AttackTime) and LastHitCreep.CanCastSpells(LastHitCreep.User.Hero) and not LastHitCreep.PreventPlayer(LastHitCreep.User.Hero) then
		local BestTarget = LastHitCreep.FindBestTarget();
		if BestTarget and BestTarget[1] and (not LastHitCreep.isEducation() or LastHitCreep.isHitKeyDown()) then
			Player.AttackTarget(Players.GetLocal(), LastHitCreep.User.Hero, BestTarget[1]);
			LastHitCreep.User.LastAttackTime = os.clock() + 0.05 + BestTarget[2];
			LastHitCreep.User.LastMoveTime = LastHitCreep.User.LastAttackTime + 0.5;
		else
			--Player.HoldPosition(Players.GetLocal(), LastHitCreep.User.Hero, false);
		end;
		LastHitCreep.User.LastTarget = BestTarget[1];
	end;
	
	--Attack Move Block
	if LastHitCreep.isAttackMove() then
		if NPC.IsTurning(LastHitCreep.User.Hero) or NPC.IsRunning(LastHitCreep.User.Hero) then
			LastHitCreep.User.LastMoveTime = os.clock() + 2;
		else
			if ((os.clock() - LastHitCreep.User.LastAttackTime) > (LastHitCreep.User.AttackPoint + 0.05)) and ((os.clock() - LastHitCreep.User.LastMoveTime) > 0.45)  then
				--Log.Write("Attack Move");
				local position = Entity.GetAbsOrigin(LastHitCreep.User.Hero);
				movevec = position:__add(Vector(math.random(-70,70),math.random(-70,70),0));--magic number for range move
				NPC.MoveTo(LastHitCreep.User.Hero, movevec, false);
				LastHitCreep.User.LastMoveTime = os.clock() + 3 + (VectorDistance(position,movevec)/LastHitCreep.User.MoveSpeed);--magic numbers for time delay
			end;
		end;
	end;
	
	--[[
		-- check 
				if (NPC.IsLaneCreep(npc) and (LastHitCreep.User.LastTarget ~= npc) and ) then
	]]
end;

function LastHitCreep.OnUnitDie(ent)
	--Log.Write(NPC.GetUnitName(ent));
end;

function LastHitCreep.OnUnitAnimation(animation)
	if not animation or not LastHitCreep.isEnabled() then 
		return;
	end;
	
	if (NPC.GetUnitName(animation.unit) == LastHitCreep.User.Name) then
		if LastHitCreep.User.LastTarget and Entity.IsEntity(LastHitCreep.User.LastTarget) then
			--Log.Write("LT HP Start="..math.floor(Entity.GetHealth(LastHitCreep.User.LastTarget) + NPC.GetHealthRegen(LastHitCreep.User.LastTarget)));
		end;
		if (not LastHitCreep.isEducation() or LastHitCreep.isHitKeyDown()) and 
				(LastHitCreep.User.LastTarget and 
				((Entity.GetHealth(LastHitCreep.User.LastTarget)>(LastHitCreep.User.TrueDamage*5)) or not Entity.IsAlive(LastHitCreep.User.LastTarget))) 
		then-- or not(LastHitCreep.User.LastTarget and Entity.IsEntity(LastHitCreep.User.LastTarget)) 
			--Player.HoldPosition(Players.GetLocal(), LastHitCreep.User.Hero, false);
		end;
		--[[
		local increasedAS = NPC.GetIncreasedAttackSpeed(animation.unit);
		local attackTime = LastHitCreep.User.AttackTime;
		local attackPoint = LastHitCreep.User.AttackPoint;
		local attackSpeed = attackPoint / (1 + (increasedAS/100));
		local attackTime = GameRules.GetGameTime() + attackSpeed + (attackPoint * 0.75);
		Log.Write("R_StartAttack="..GameRules.GetGameTime().." EndAttack="..attackTime);
		]]
	end;
	--[[
	--try find\test facing, but it not right
	if animation.unit and Entity.IsNPC(animation.unit) and NPC.IsLaneCreep(animation.unit) and (Entity.IsSameTeam(LastHitCreep.User.Hero, animation.unit)) and (animation.type == 1) then
		local attackRange = NPC.GetAttackRange(animation.unit);
		if NPC.IsRanged(animation.unit) then
			attackRange = attackRange + 64;--magin number 64???
		else
			attackRange = attackRange + 55;--magin number 55???
		end;
		local facing = NPC.FindFacingNPC(animation.unit);
		if (facing and Entity.IsEntity(facing) and Entity.IsNPC(facing) and NPC.IsEntityInRange(animation.unit, facing, attackRange)) then
			LastHitCreep.CreateTargetingParticle(animation.unit, facing);
		end;
	end;
	]]
end;

function LastHitCreep.OnUnitAnimationEnd(animation)
	if not animation or not LastHitCreep.isEnabled() then 
		return;
	end;

	if (NPC.GetUnitName(animation.unit) == LastHitCreep.User.Name) then
		if LastHitCreep.User.LastTarget and Entity.IsEntity(LastHitCreep.User.LastTarget) then
			--Log.Write("LT HP END="..math.floor(Entity.GetHealth(LastHitCreep.User.LastTarget) + NPC.GetHealthRegen(LastHitCreep.User.LastTarget)));
			if (Entity.GetHealth(LastHitCreep.User.LastTarget)>0) then
				--Player.HoldPosition(Players.GetLocal(), LastHitCreep.User.Hero, false);
			end;
		end;
		--Log.Write("R_EndAttack="..GameRules.GetGameTime());
	end;

end;

function LastHitCreep.OnModifierCreate(ent, mod)
	if not LastHitCreep.isEnabled() then
		return;
	end;

end;

function LastHitCreep.OnModifierDestroy(ent, mod)
	if not LastHitCreep.isEnabled() then
		return;
	end;

end;

function LastHitCreep.OnGameStart()
	LastHitCreep.Initialization();
end

function LastHitCreep.OnGameEnd()
	LastHitCreep.Finalization();
end

function LastHitCreep.OnMenuOptionChange(option, oldValue, newValue)

end;

function LastHitCreep.PredictDrawing(myHero)
	if not myHero then return end
	if not LastHitCreep.isEnabled() then return end
	if not LastHitCreep.CreepsPredictedDieTime then return end

	if (LastHitCreep.GetShowPrediction() ~= 0) then
		local imageHandle = LastHitCreep.KillableImage;
		if imageHandle == nil then
			imageHandle = Renderer.LoadImage("resource/flash3/images/heroes/selection/fav_heart.png");--("resource/flash3/images/heroes/selection/fav_star.png");--resource/flash3/images/heroes/selection/fav_heart.png
			LastHitCreep.KillableImage = imageHandle;
		end
		for target, predicted in pairs(LastHitCreep.CreepsPredictedDieTime) do
			if target and Entity.IsEntity(target) and Entity.IsNPC(target) and 
				((LastHitCreep.GetShowPrediction() == 3) or ((LastHitCreep.GetShowPrediction() == 2) and Entity.IsSameTeam(target, myHero)) or ((LastHitCreep.GetShowPrediction() == 1) and not Entity.IsSameTeam(target, myHero)) )  then
				
				local TimeDiff = nil;
				if (predicted.DieTime ~= 0) then
					TimeDiff = (predicted.DieTime - GameRules.GetGameTime());
				end;
				if not TimeDiff or (TimeDiff < -2.5) or not Entity.IsAlive(target) then
					predicted.DieTime = 0;
				else
					local pos = Entity.GetAbsOrigin(target);
					local posY = NPC.GetHealthBarOffset(target);
					pos:SetZ(pos:GetZ() + posY);
					local x, y, visible = Renderer.WorldToScreen(pos);

					if visible and (TimeDiff > -2) then
						if (TimeDiff > (predicted.AttackTime + 0.1)) then
							Renderer.SetDrawColor(50,235,50,200);
						elseif (TimeDiff > -0.1) then
							Renderer.SetDrawColor(215,215,0,200);
						else
							Renderer.SetDrawColor(235,25,25,200);
							predicted.DieTime = 0;
						end;
						Renderer.DrawImage(imageHandle, x-20, y-49, 40, 40);
					end;
				end;
			end;
		end;
	end;

end

function LastHitCreep.OnDraw()

	if not LastHitCreep.isEnabled() then return end;
	local myHero = Heroes.GetLocal()
  if not myHero then return end
	if not Entity.IsAlive(myHero) then return end
	
	LastHitCreep.PredictDrawing(myHero)
end

LastHitCreep.Initialization();

return LastHitCreep