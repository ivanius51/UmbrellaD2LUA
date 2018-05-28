--[[
TODO:

--]]

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
LastHitCreep.Menu.Enemys = Menu.AddOptionBool(LastHitCreep.Menu.Path, "Kill Enemys", false);
LastHitCreep.Menu.Friendlys = Menu.AddOptionBool(LastHitCreep.Menu.Path, "Deny Friendlys", false);
LastHitCreep.Menu.Neutrals = Menu.AddOptionBool(LastHitCreep.Menu.Path, "Kill Neutrals", false);

LastHitCreep.User.Hero = nil;
LastHitCreep.Particles = {};

function LastHitCreep.isEnabled()
	return Menu.IsEnabled(LastHitCreep.Menu.Enabled);
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

function LastHitCreep.CreateRangeParticle(index, ent, name)
	if (ent == nil) then
		return false;
	end;
	if (LastHitCreep.Particles[tonumber(index)] == nil) then
		LastHitCreep.Particles[tonumber(index)] = {};
		LastHitCreep.Particles[tonumber(index)].ID = Particle.Create(name, Enum.ParticleAttachment.PATTACH_ABSORIGIN_FOLLOW, ent);
		return true;
	end;
	return false;
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

function LastHitCreep.CreatePositionParticle(index, position, name)
	if (ent == nil) then
		return false;
	end;
	if (LastHitCreep.Particles[tonumber(index)] == nil) then
		LastHitCreep.Particles[tonumber(index)] = {};
		LastHitCreep.Particles[tonumber(index)].ID = Particle.Create(name, Enum.ParticleAttachment.PATTACH_ABSORIGIN, 0);
		Particle.SetControlPoint(LastHitCreep.Particles[tonumber(index)].ID, 0, position);
		Particle.SetControlPoint(LastHitCreep.Particles[tonumber(index)].ID, 1, Vector(300, 100, 100));
		Particle.SetControlPoint(LastHitCreep.Particles[tonumber(index)].ID, 6, Vector(100, 0, 0));
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
	LastHitCreep.User.Hero = Heroes.GetLocal();
	if LastHitCreep.User.Hero == nil then 
		return;
	else
		if not LastHitCreep.isEnabled() then
			for i in pairs(LastHitCreep.Particles) do
				ClearParticle(i);
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

return LastHitCreep