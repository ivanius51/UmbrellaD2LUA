--[[
TODO:
	Gyrocopter
	Apparition
	Willow
	Sven - stun
	Techies - suicide
--]]

local SkillAlert = {};
SkillAlert.Menu = {};
SkillAlert.User = {};
SkillAlert.Particles = {};
SkillAlert.SkillModifiers = {
	["default"] = {"particles/units/heroes/hero_gyrocopter/gyro_calldown_marker.vpcf", "position", 175},
	["modifier_invoker_sun_strike"] = {"particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf", "position", 175},
	["modifier_kunkka_torrent_thinker"] = {"particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf", "position", 325},
	["modifier_lina_light_strike_array"] = {"particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf", "position", 225},
	["modifier_leshrac_split_earth_thinker"] = {"particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf", "position", 225},
	["modifier_truesight"] = {"particles/ui_mouseactions/range_display.vpcf", "range", 100},
	["modifier_invisible"] = {"particles/ui_mouseactions/range_display.vpcf", "range", 100},
	["modifier_projectile_vision_on_minimap"] = {"particles/ui_mouseactions/range_display.vpcf", "range", 100},
	["modifier_spirit_breaker_charge_of_darkness_vision"] = {"particles/units/heroes/hero_spirit_breaker/spirit_breaker_charge_target_mark.vpcf", "overhead"},
	["modifier_tusk_snowball_target"] = {"particles/units/heroes/hero_tusk/tusk_snowball_target.vpcf", "overhead"},
	["modifier_tusk_snowball_visible"] = {"particles/units/heroes/hero_tusk/tusk_snowball_target.vpcf", "overhead"}
}

SkillAlert.Menu.Path = {"Utility", "Skill Alert"};
SkillAlert.Menu.Enabled = Menu.AddOptionBool(SkillAlert.Menu.Path, "Enabled", false);
SkillAlert.Menu.SkillEffects = Menu.AddOptionBool(SkillAlert.Menu.Path, "Default Skill Effects", false);
-- SkillAlert.Menu.SelectedEffect = Menu.AddOptionCombo(SkillAlert.Menu.Path, "Custom Effect", {"particles/neutral_fx/roshan_spawn.vpcf", "particles/units/heroes/hero_gyrocopter/gyro_calldown_marker.vpcf", "particles/ui_mouseactions/range_display.vpcf"} ,0);

SkillAlert.User.Hero = nil;
SkillAlert.Particles = {};

function SkillAlert.isEnabled()
	return Menu.IsEnabled(SkillAlert.Menu.Enabled);
end;

function SkillAlert.isDefaultSkillEffects()
	return Menu.IsEnabled(SkillAlert.Menu.SkillEffects);
end;

function SkillAlert.Initialization()
	SkillAlert.User.Hero = nil;
	for k in pairs(SkillAlert.Particles) do
		SkillAlert.Particles[k] = nil;
	end;
end;

function SkillAlert.Finalization()
	SkillAlert.User.Hero = nil;
	for k in pairs(SkillAlert.Particles) do
		SkillAlert.ClearParticle(k);
	end;
end;

function SkillAlert.CreateRangeParticle(index, ent, name)
	if (ent == nil) then
		return false;
	end;
	if (SkillAlert.Particles[tonumber(index)] == nil) and Entity.IsEntity(ent) then
		SkillAlert.Particles[tonumber(index)] = {};
		SkillAlert.Particles[tonumber(index)].ID = Particle.Create(name, Enum.ParticleAttachment.PATTACH_ABSORIGIN_FOLLOW, ent);
		return true;
	end;
	return false;
end;

function SkillAlert.CreateOverheadParticle(index, ent, name)
	if (ent == nil) then
		return false;
	end;
	if (SkillAlert.Particles[tonumber(index)] == nil) and Entity.IsEntity(ent) then
		SkillAlert.Particles[tonumber(index)] = {};
		SkillAlert.Particles[tonumber(index)].ID = Particle.Create(name, Enum.ParticleAttachment.PATTACH_OVERHEAD_FOLLOW, ent);
		return true;
	end;
	return false;
end;

function SkillAlert.CreatePositionParticle(index, position, name)
	if (ent == nil) then
		return false;
	end;
	if (SkillAlert.Particles[tonumber(index)] == nil) then
		SkillAlert.Particles[tonumber(index)] = {};
		SkillAlert.Particles[tonumber(index)].ID = Particle.Create(name, Enum.ParticleAttachment.PATTACH_ABSORIGIN, 0);
		Particle.SetControlPoint(SkillAlert.Particles[tonumber(index)].ID, 0, position);
		Particle.SetControlPoint(SkillAlert.Particles[tonumber(index)].ID, 1, Vector(300, 100, 100));
		Particle.SetControlPoint(SkillAlert.Particles[tonumber(index)].ID, 6, Vector(100, 0, 0));
		return true;
	end;
	return false;
end;

function SkillAlert.ClearParticle(index)
	if (SkillAlert.Particles[tonumber(index)] ~= nil) and (SkillAlert.Particles[tonumber(index)].ID ~= nil) then
		Particle.Destroy(SkillAlert.Particles[tonumber(index)].ID);
		SkillAlert.Particles[tonumber(index)] = nil;
	end;
end;

function SkillAlert.OnUpdate()
	SkillAlert.User.Hero = Heroes.GetLocal();
	if SkillAlert.User.Hero == nil then 
		return;
	else
		if not SkillAlert.isEnabled() then
			for i in pairs(SkillAlert.Particles) do
				if (i ~= nil) then
					ClearParticle(i);
				end;
			end;
		end;
	end;
end;

function SkillAlert.OnParticleCreate( particle )
	if not SkillAlert.isEnabled() then
		return;
	end;
	--[[
	Log.Write("particleCr = " .. particle.name);
	Log.Write("particleCr = " .. tostring(particle.entityForModifiers));
	if particle.entityForModifiers ~= 0 then
		SkillAlert.CreateRangeParticle(particle.entityForModifiers, particle.entityForModifiers, "particles/ui_mouseactions/range_display.vpcf")
		if (SkillAlert.Particles[particle.entityForModifiers] ~= nil) then
			Particle.SetControlPoint(SkillAlert.Particles[particle.entityForModifiers].ID, 1, Vector(120, 0, 0));
			Particle.SetControlPoint(SkillAlert.Particles[particle.entityForModifiers].ID, 6, Vector(1, 0, 0));
		end;
	end;
	--]]
end;

function SkillAlert.OnParticleDestroy( particle )
	if not SkillAlert.isEnabled() then
		return;
	end;
	--[[
	Log.Write("particleDe = " .. particle.name);
	Log.Write("particleDe = " .. tostring(particle.entityForModifiers));
	if particle.entityForModifiers ~= 0 then
		if (SkillAlert.Particles[particle.entityForModifiers] ~= nil) then
			SkillAlert.ClearParticle(particle.entityForModifiers);
		end;
	end;
	--]]
end;


function SkillAlert.OnModifierCreate(ent, mod)
	if SkillAlert.isEnabled() then
		--[[
		if NPC.GetUnitName(ent) ~= nil then
			Log.Write(NPC.GetUnitName(ent)); 
		else
			Log.Write(Entity.GetClassName(ent));
		end;
		Log.Write(Modifier.GetName(mod)); 
		--]]
		if SkillAlert.SkillModifiers[Modifier.GetName(mod)] ~= nil then
			if SkillAlert.SkillModifiers[Modifier.GetName(mod)][2] == "position" then
				if SkillAlert.isDefaultSkillEffects() then
					SkillAlert.CreateRangeParticle(ent, ent, SkillAlert.SkillModifiers[Modifier.GetName(mod)][1]);
				else
					SkillAlert.CreateRangeParticle(ent, ent, SkillAlert.SkillModifiers["default"][1]);
				end;
				if (SkillAlert.Particles[ent] ~= nil) then
					Particle.SetControlPoint(SkillAlert.Particles[ent].ID, 1, Vector(SkillAlert.SkillModifiers[Modifier.GetName(mod)][3], 0, 0));
				end;
			elseif SkillAlert.SkillModifiers[Modifier.GetName(mod)][2] == "overhead" then
				SkillAlert.CreateOverheadParticle(ent,ent,SkillAlert.SkillModifiers[Modifier.GetName(mod)][1]);
			elseif SkillAlert.SkillModifiers[Modifier.GetName(mod)][2] == "range" then
				SkillAlert.CreateRangeParticle(ent, ent, SkillAlert.SkillModifiers[Modifier.GetName(mod)][1])
				if (SkillAlert.Particles[ent] ~= nil) and (SkillAlert.Particles[ent].ID ~= nil) then
					Particle.SetControlPoint(SkillAlert.Particles[ent].ID, 1, Vector(SkillAlert.SkillModifiers[Modifier.GetName(mod)][3], 0, 0));
				end;
			end;

			if (SkillAlert.Particles[ent] ~= nil) and (SkillAlert.Particles[ent].ID ~= nil) then
				Particle.SetControlPoint(SkillAlert.Particles[ent].ID, 6, Vector(1, 0, 0));
			end;
		else
			-- not listed modifier
		end;
	end;
end;

function SkillAlert.OnModifierDestroy(ent, mod)
	if SkillAlert.isEnabled() then
		if SkillAlert.SkillModifiers[Modifier.GetName(mod)] ~= nil then
			if (SkillAlert.Particles[ent] ~= nil) then
				SkillAlert.ClearParticle(ent);
			end;
		else
			-- not listed modifier
			if (SkillAlert.Particles[ent] ~= nil) then
				SkillAlert.ClearParticle(ent);
			end;
		end;
	end;
end;

function SkillAlert.OnGameStart()
	SkillAlert.Initialization();
end

function SkillAlert.OnGameEnd()
	SkillAlert.Finalization();
end

return SkillAlert