--[[
TODO:

--]]
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
LastHitCreep.Menu.Enabled = Menu.AddOptionBool(LastHitCreep.Menu.Path, "Enabled", false);
LastHitCreep.Menu.Education = Menu.AddOptionBool(LastHitCreep.Menu.Path, "Education Mode", false);
LastHitCreep.Menu.Enemys = Menu.AddOptionBool(LastHitCreep.Menu.Path, "Kill Enemys", false);
LastHitCreep.Menu.Friendlys = Menu.AddOptionBool(LastHitCreep.Menu.Path, "Deny Friendlys", false);
LastHitCreep.Menu.Neutrals = Menu.AddOptionBool(LastHitCreep.Menu.Path, "Kill Neutrals", false);

LastHitCreep.Particles = {};
LastHitCreep.Creeps = nil;
LastHitCreep.UpdateTime = 0.25;

function LastHitCreep.isEnabled()
	return Menu.IsEnabled(LastHitCreep.Menu.Enabled);
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

function LastHitCreep.Initialization()
	LastHitCreep.User.Hero = nil;
	LastHitCreep.User.LastTarget = nil;
	LastHitCreep.User.LastAttackTime = os.clock();
	LastHitCreep.User.LastUpdateTime = os.clock();
	LastHitCreep.User.AttackTime = 0.5;
	LastHitCreep.User.AttackRange = 0;
	for k in pairs(LastHitCreep.Particles) do
		LastHitCreep.Particles[k] = nil;
	end;
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

function LastHitCreep.ClearParticle(index)
	if (LastHitCreep.Particles[tonumber(index)] ~= nil) then
		Particle.Destroy(LastHitCreep.Particles[tonumber(index)].ID);
		LastHitCreep.Particles[tonumber(index)] = nil;
	end;
end;

function LastHitCreep.OnUpdate()
	if not LastHitCreep.isEnabled() then
		for i in pairs(LastHitCreep.Particles) do
			ClearParticle(i);
		end;
		return;
	end;
	LastHitCreep.User.Hero = Heroes.GetLocal();
	if LastHitCreep.User.Hero == nil then 
		return;
	else
		--Log.Write(os.clock());
		--Log.Write(LastHitCreep.User.LastAttackTime);
		if ((os.clock() - LastHitCreep.User.LastUpdateTime) > LastHitCreep.UpdateTime) then
			LastHitCreep.Creeps = Entity.GetUnitsInRadius(LastHitCreep.User.Hero, LastHitCreep.User.AttackRange + 150, Enum.TeamType.TEAM_BOTH);
		end;
		if Entity.IsAlive(LastHitCreep.User.Hero) and ((os.clock() - LastHitCreep.User.LastAttackTime) > (LastHitCreep.User.AttackTime + 0.1)) then
			--Log.Write((os.clock() - LastHitCreep.User.LastAttackTime));
			--get last data
			LastHitCreep.User.Name = NPC.GetUnitName(LastHitCreep.User.Hero);
			LastHitCreep.User.AttackRange = NPC.GetAttackRange(LastHitCreep.User.Hero);
			LastHitCreep.User.TeamNum = Entity.GetTeamNum(LastHitCreep.User.Hero);
			LastHitCreep.User.AttackTime = NPC.GetAttackTime(LastHitCreep.User.Hero);
			LastHitCreep.User.APS = NPC.GetAttacksPerSecond(LastHitCreep.User.Hero);
			LastHitCreep.User.MoveSpeed = NPC.GetMoveSpeed(LastHitCreep.User.Hero);
			LastHitCreep.User.Damage = NPC.GetTrueDamage(LastHitCreep.User.Hero);
			LastHitCreep.User.MaximumDamage = NPC.GetTrueMaximumDamage(LastHitCreep.User.Hero);
			-- search for creeps
			-- check priority
			if LastHitCreep.Creeps ~= nil then
				for k, npc in pairs(LastHitCreep.Creeps) do
					if (NPC.IsLaneCreep(npc) and ( (not Entity.IsSameTeam(npc, LastHitCreep.User.Hero)and LastHitCreep.isKillEnemys()) or (Entity.IsSameTeam(npc, LastHitCreep.User.Hero) and LastHitCreep.isDenyFriendlys()) )) then -- and NPC.IsKillable(npc)
						-- Log.Write(NPC.GetUnitName(npc).." "..Entity.GetHealth(npc).." "..NPC.GetArmorDamageMultiplier(npc));
						local TrueDMG = NPC.GetArmorDamageMultiplier(npc)*LastHitCreep.User.MaximumDamage;
						if (Entity.GetHealth(npc) < TrueDMG) then
							if (LastHitCreep.isEducation()) then
								
							else
								Game.AttackTarget(npc,LastHitCreep.User.Hero);
								LastHitCreep.User.LastTarget = npc;
								LastHitCreep.User.LastAttackTime = os.clock();
								-- Game.MoveTo(Entity.GetOrigin(LastHitCreep.User.Hero),LastHitCreep.User.Hero, true);
								break;
							end;
						end;
						--NPC.IsCreep(npc)
						--NPC.IsNeutral(npc)
					end;
				end;
			end;
		end;
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

LastHitCreep.Initialization();

return LastHitCreep