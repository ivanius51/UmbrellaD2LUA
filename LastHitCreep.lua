--[[
Ivanius51 13.07.2016 АвтоДенай крипов + подсвечивание
22.07.2016 Убрал спам атаки
04.02.2017 Переработана формула расчтеа учитвая последние патчи
25.02.2018 - 30.02.2018 Переведено на LUA, добавлено правильное предсказание, изменены настройки
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

local HeroInfo = require("scripts.settings.HeroInfo");

function VectorDistance (a, b)
	local diff = Vector(a:GetX() - b:GetX(), a:GetY() - b:GetY(), a:GetZ() - b:GetZ());
	return math.sqrt(math.pow(diff:GetX(), 2) + math.pow(diff:GetY(), 2) + math.pow(diff:GetZ(), 2));
end;

function NPC.Distance (a, b)
	local av = Entity.GetAbsOrigin(a);
	local bv = Entity.GetAbsOrigin(b);
	return VectorDistance(av, bv);
end;

local LastHitCreep = {};
LastHitCreep.Menu = {};
LastHitCreep.User = {};
LastHitCreep.Particles = {};
LastHitCreep.SkillModifiers = {
	["modifier_item_quelling_blade"]= {1.4},
	["modifier_item_bfury"] = {1.6},
	["modifier_item_iron_talon"] = {1.4},
	["modifier_bloodseeker_bloodrage"] = {1.25,1.3,1.35,1.4}
}

LastHitCreep.Menu.Path = {"Utility", "Last Hit Creep"};
LastHitCreep.Menu.Path.CreepTypes = {"Utility", "Last Hit Creep", "Creep Types"};
LastHitCreep.Menu.Enabled = Menu.AddOptionBool(LastHitCreep.Menu.Path, "Enabled", false);
LastHitCreep.Menu.Education = Menu.AddOptionBool(LastHitCreep.Menu.Path, "Education Mode", false);
LastHitCreep.Menu.LastHitKey = Menu.AddKeyOption(LastHitCreep.Menu.Path, "Last Hit Key", Enum.ButtonCode.KEY_P);
LastHitCreep.Menu.Enemys = Menu.AddOptionBool(LastHitCreep.Menu.Path.CreepTypes, "Kill Enemys", false);
LastHitCreep.Menu.Friendlys = Menu.AddOptionBool(LastHitCreep.Menu.Path.CreepTypes, "Deny Friendlys", false);
LastHitCreep.Menu.Neutrals = Menu.AddOptionBool(LastHitCreep.Menu.Path.CreepTypes, "Kill Neutrals", false);

LastHitCreep.Particles = {};
LastHitCreep.Particles.Target = {};
LastHitCreep.Creeps = nil;
LastHitCreep.CreepsDPS = {};
LastHitCreep.UpdateTime = 0.5;
LastHitCreep.DPSMult = (1 / LastHitCreep.UpdateTime);

function LastHitCreep.isEnabled()
	return Menu.IsEnabled(LastHitCreep.Menu.Enabled);
end;

function LastHitCreep.isHitKeyDown()
	return Menu.IsKeyDown(LastHitCreep.Menu.LastHitKey);
end;

function LastHitCreep.isEducation()
	return Menu.IsEnabled(LastHitCreep.Menu.Education);
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

function LastHitCreep.User.Read()
	LastHitCreep.User.Hero = Heroes.GetLocal();
	if not LastHitCreep.User.Hero then
		return false;
	end;
	LastHitCreep.User.Name = NPC.GetUnitName(LastHitCreep.User.Hero);
	LastHitCreep.User.AttackPoint = HeroInfo[LastHitCreep.User.Name].AttackPoint + 0.05;
	LastHitCreep.User.AttackBackSwing = HeroInfo[LastHitCreep.User.Name].AttackBackSwing;
	LastHitCreep.User.AttackTime = NPC.GetAttackTime(LastHitCreep.User.Hero) + LastHitCreep.User.AttackPoint;-- + LastHitCreep.User.AttackBackSwing;
	LastHitCreep.User.Damage = NPC.GetTrueDamage(LastHitCreep.User.Hero);
	LastHitCreep.User.MaximumDamage = NPC.GetTrueMaximumDamage(LastHitCreep.User.Hero);
	LastHitCreep.User.TrueDamage = math.ceil((LastHitCreep.User.MaximumDamage + LastHitCreep.User.Damage) / 2);
	LastHitCreep.User.Range = NPC.GetAttackRange(LastHitCreep.User.Hero);
	LastHitCreep.User.MoveSpeed = NPC.GetMoveSpeed(LastHitCreep.User.Hero);
	return true;
end;

function LastHitCreep.Initialization()
	LastHitCreep.User.Read();
	LastHitCreep.User.LastTarget = nil;
	LastHitCreep.User.LastAttackTime = os.clock();
	LastHitCreep.User.LastUpdateTime = os.clock();
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

--[[
function LastHitCreep.GetMeleeCreepTarget(hero, creep)

	if not hero or not creep or not Entity.IsNPC(creep) or not NPC.IsLaneCreep(creep) or not Entity.IsAlive(creep) then 
		return 
	end;

	if NPC.IsRanged(creep) then return end;

	local creepRotation = Entity.GetRotation(creep):GetForward():Normalized();
	
	local targets = Entity.GetUnitsInRadius(creep, 148, Enum.TeamType.TEAM_ENEMY)
		if next(targets) == nil then 
			return; 
		end;
		if #targets < 1 then 
			return; 
		end;

	if #targets == 1 then
		if Entity.IsNPC(targets[1]) and NPC.IsLaneCreep(targets[1]) then
			return targets[1];
		end;
	else
		local adjustedHullSize = 20;
		for i, npc in ipairs(targets) do
			if npc and Entity.IsNPC(npc) and NPC.IsLaneCreep(npc) and Entity.IsAlive(npc) then
				local npcpos = Entity.GetAbsOrigin(npc);
				local npcposZ = npcpos:GetZ();
				local pos = Entity.GetAbsOrigin(creep);
				for i = 1, 9 do
					local searchPos = pos + creepRotation:Scaled(25*(9-i));
					searchPos:SetZ(npcposZ);
					if NPC.IsPositionInRange(npc, searchPos, adjustedHullSize, 0) then
						return npc;
					end;
				end;
			end;
		end;
	end;
	return;
end;
]]--

function LastHitCreep.CalcDPS(oldHP, curentHP)
	return math.ceil((oldHP-curentHP) * LastHitCreep.DPSMult);
end;

function LastHitCreep.OnUpdate()
	if not LastHitCreep.isEnabled() then
		return;
	end;
	LastHitCreep.User.Hero = Heroes.GetLocal();
	if (LastHitCreep.User.Hero == nil) or not Entity.IsAlive(LastHitCreep.User.Hero) then 
		return;
	end;

	--
	if ((os.clock() - LastHitCreep.User.LastUpdateTime) > LastHitCreep.UpdateTime) then
		--update user data
		if not LastHitCreep.User.Read() then
			return;
		end;
		--end update user data
		LastHitCreep.User.LastUpdateTime = os.clock();
		LastHitCreep.Creeps = Entity.GetUnitsInRadius(LastHitCreep.User.Hero, LastHitCreep.User.Range + 350, Enum.TeamType.TEAM_BOTH);
		for k, npc in ipairs(LastHitCreep.Creeps) do
			if Entity.IsAlive(npc) and  NPC.IsLaneCreep(npc) then
				if LastHitCreep.CreepsDPS[npc] == nil then
					LastHitCreep.CreepsDPS[npc] = {};
					LastHitCreep.CreepsDPS[npc].CurHP = math.floor(Entity.GetHealth(npc) + NPC.GetHealthRegen(npc));
					LastHitCreep.CreepsDPS[npc].OldHP = LastHitCreep.CreepsDPS[npc].CurHP;
					LastHitCreep.CreepsDPS[npc].DPS = 0; 
				else
					LastHitCreep.CreepsDPS[npc].OldHP = LastHitCreep.CreepsDPS[npc].CurHP;
					LastHitCreep.CreepsDPS[npc].CurHP = math.floor(Entity.GetHealth(npc) + NPC.GetHealthRegen(npc));
					local curDPS = LastHitCreep.CalcDPS(LastHitCreep.CreepsDPS[npc].OldHP, LastHitCreep.CreepsDPS[npc].CurHP);
					if (LastHitCreep.CreepsDPS[npc].DPS == 0) then
						LastHitCreep.CreepsDPS[npc].DPS = curDPS;
					else
						--dps move to current dps
						if curDPS~=0 then
							LastHitCreep.CreepsDPS[npc].DPS = math.floor((LastHitCreep.CreepsDPS[npc].DPS + curDPS * 3) / 4);
						end;
					end;
				end;
			end;
		end;
		--find creep to kill
	end;

	if ((os.clock() - LastHitCreep.User.LastAttackTime) > (LastHitCreep.User.AttackTime + 0.05)) then
		if (LastHitCreep.isEducation()) then
			LastHitCreep.User.AttackTime = 0.05;
		else
			LastHitCreep.User.AttackTime = NPC.GetAttackTime(LastHitCreep.User.Hero);
		end;
		LastHitCreep.Creeps = Entity.GetUnitsInRadius(LastHitCreep.User.Hero, LastHitCreep.User.Range + 350, Enum.TeamType.TEAM_BOTH);
		for k, npc in ipairs(LastHitCreep.Creeps) do
			if Entity.IsEntity(npc) and Entity.IsAlive(npc) and NPC.IsLaneCreep(npc) then
				local TrueDMG = math.ceil(NPC.GetArmorDamageMultiplier(npc) * LastHitCreep.User.Damage * NPC.GetDamageMultiplierVersus(LastHitCreep.User.Hero, npc));
				local dist = NPC.Distance(npc, LastHitCreep.User.Hero);

				local DMGTime = LastHitCreep.User.AttackPoint + NPC.GetTimeToFace(LastHitCreep.User.Hero, npc);
				if (dist>LastHitCreep.User.Range) then
					DMGTime = DMGTime + ((dist-LastHitCreep.User.Range)/LastHitCreep.User.MoveSpeed) + 0.01;
				end;
				local HP = math.floor(Entity.GetHealth(npc) + NPC.GetHealthRegen(npc) * DMGTime);
				local DPS =  10;
				if LastHitCreep.CreepsDPS[npc] then
					DPS = LastHitCreep.CreepsDPS[npc].DPS;
				end;
				local PossiblyMissedDPS = DPS * DMGTime;
				if (LastHitCreep.isEducation()) then
					if ( (HP < (TrueDMG + PossiblyMissedDPS)) ) then
						Log.Write("HP="..HP.." Dist="..dist.." DMG="..TrueDMG.." PMD="..PossiblyMissedDPS.." PrepareTime="..DMGTime);
						--LastHitCreep.ClearParticle(npc);
						LastHitCreep.CreateOverheadParticle(npc, npc, "particles/units/heroes/hero_sniper/sniper_crosshair.vpcf");
						LastHitCreep.User.LastAttackTime = os.clock();
						break;
					end;
				else
					if (HP < (TrueDMG + PossiblyMissedDPS)) then
						Log.Write("HP="..HP.." Dist="..dist.." DMG="..TrueDMG.." PMD="..PossiblyMissedDPS.." PrepareTime="..DMGTime);
						Player.AttackTarget(Players.GetLocal(), LastHitCreep.User.Hero, npc)
						LastHitCreep.User.LastAttackTime = os.clock();
						break;
					end; 
				end;
			end;
		end;
	end;
	--[[
		-- check 
				if (NPC.IsLaneCreep(npc) and (LastHitCreep.User.LastTarget ~= npc) and ( (not Entity.IsSameTeam(npc, LastHitCreep.User.Hero)and LastHitCreep.isKillEnemys()) or (Entity.IsSameTeam(npc, LastHitCreep.User.Hero) and LastHitCreep.isDenyFriendlys()) )) then
	]]
end;

function LastHitCreep.OnUnitDie(ent)
	Log.Write(NPC.GetUnitName(ent));
end;

function LastHitCreep.OnUnitAnimation(animation)
	if not animation then 
		return;
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

LastHitCreep.Initialization();

return LastHitCreep