--[[
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
	Gyrocopter - ult, rocket
	Apparition
	Willow
	Sven - stun
	Techies - suicide
--]]

local SkillAlert = {};
SkillAlert.Menu = {};
SkillAlert.User = {};
SkillAlert.Particles = {};
SkillAlert.Menu.ParticleEffects = {"particles/neutral_fx/roshan_spawn.vpcf", "particles/units/heroes/hero_gyrocopter/gyro_calldown_marker.vpcf", "particles/ui_mouseactions/range_display.vpcf"};
SkillAlert.Menu.TrueSightTypes = {" Disabled", " Self Hero", " All Allies", " All include enemies"};
SkillAlert.SkillModifiers = {
	["default"] = {"particles/units/heroes/hero_gyrocopter/gyro_calldown_marker.vpcf", "position", 175},
	["modifier_invoker_sun_strike"] = {"particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf", "position", 175},
	["modifier_kunkka_torrent_thinker"] = {"particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf", "position", 250},
	["modifier_lina_light_strike_array"] = {"particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf", "position", 225},
	["modifier_leshrac_split_earth_thinker"] = {"particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf", "position", 225},
	["modifier_truesight"] = {"particles/econ/wards/f2p/f2p_ward/ward_true_sight.vpcf", "overhead",},--"particles/ui_mouseactions/range_display_magenta.vpcf"TrueSide = "particles/econ/wards/f2p/f2p_ward/ward_true_sight.vpcf"
	--["modifier_invisible"] = {"particles/range_display_blue.vpcf", "range", 50},--"particles/ui_mouseactions/range_display_blue.vpcf"
	["modifier_projectile_vision_on_minimap"] = {"particles/items_fx/aura_shivas.vpcf", "range", 100},--range_display_aqua
	["modifier_projectile_vision"] = {"particles/items_fx/aura_shivas.vpcf", "range", 100},--range_display_aqua
	["modifier_spirit_breaker_charge_of_darkness_vision"] = {"particles/units/heroes/hero_spirit_breaker/spirit_breaker_charge_target_mark.vpcf", "overhead"},
	["modifier_tusk_snowball_target"] = {"particles/units/heroes/hero_tusk/tusk_snowball_target.vpcf", "overhead"},
	["modifier_tusk_snowball_visible"] = {"particles/units/heroes/hero_tusk/tusk_snowball_target.vpcf", "overhead"}
}

SkillAlert.Menu.Path = {"Awareness", "Hidden Spells"};
SkillAlert.Menu.Enabled = Menu.AddOptionBool(SkillAlert.Menu.Path, "Enabled", false);
SkillAlert.Menu.SkillEffects = Menu.AddOptionBool(SkillAlert.Menu.Path, "Default Skill Effects", false);
SkillAlert.Menu.ParticleEffect = Menu.AddOptionCombo(SkillAlert.Menu.Path, "Custom Effect", SkillAlert.Menu.ParticleEffects ,0);
SkillAlert.Menu.TrueSight = Menu.AddOptionCombo({"Awareness", "Visible By Enemy"}, "True Sight", SkillAlert.Menu.TrueSightTypes ,0);

SkillAlert.User.Hero = nil;
SkillAlert.Particles = {};

function SkillAlert.isEnabled()
	return Menu.IsEnabled(SkillAlert.Menu.Enabled);
end;

function SkillAlert.isDefaultSkillEffects()
	return Menu.IsEnabled(SkillAlert.Menu.SkillEffects);
end;

function SkillAlert.getSkillParticleEffect()
	local result = tonumber(Menu.GetValue(SkillAlert.Menu.ParticleEffect))+1;
	return SkillAlert.Menu.ParticleEffects[result];
end;

function SkillAlert.getTruSight()
	local result = Menu.GetValue(SkillAlert.Menu.TrueSight)+1;
	return result;
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
	if (SkillAlert.Particles[index] == nil) and Entity.IsEntity(ent) then
		SkillAlert.Particles[index] = {};
		SkillAlert.Particles[index].ID = Particle.Create(name, Enum.ParticleAttachment.PATTACH_ABSORIGIN_FOLLOW, ent);
		return true;
	end;
	return false;
end;

function SkillAlert.CreateOverheadParticle(index, ent, name)
	if (ent == nil) then
		return false;
	end;
	if (SkillAlert.Particles[index] == nil) and Entity.IsEntity(ent) then
		SkillAlert.Particles[index] = {};
		SkillAlert.Particles[index].ID = Particle.Create(name, Enum.ParticleAttachment.PATTACH_OVERHEAD_FOLLOW, ent);
		return true;
	end;
	return false;
end;

function SkillAlert.CreatePositionParticle(index, position, name)
	if (ent == nil) then
		return false;
	end;
	if (SkillAlert.Particles[index] == nil) then
		SkillAlert.Particles[index] = {};
		SkillAlert.Particles[index].ID = Particle.Create(name, Enum.ParticleAttachment.PATTACH_ABSORIGIN, 0);
		Particle.SetControlPoint(SkillAlert.Particles[index].ID, 0, position);
		Particle.SetControlPoint(SkillAlert.Particles[index].ID, 1, Vector(300, 1, 1));
		Particle.SetControlPoint(SkillAlert.Particles[index].ID, 6, Vector(1, 0, 0));
		return true;
	end;
	return false;
end;

function SkillAlert.ClearParticle(index)
	if (SkillAlert.Particles[index] ~= nil) and (SkillAlert.Particles[index].ID ~= nil) then
		Particle.Destroy(SkillAlert.Particles[index].ID);
		SkillAlert.Particles[index] = nil;
	end;
end;

function SkillAlert.OnUpdate()
	SkillAlert.User.Hero = Heroes.GetLocal();
	if SkillAlert.User.Hero == nil then 
		return;
	else
		if SkillAlert.isEnabled() then
			if not NPC.IsHero(SkillAlert.User.Hero) or (SkillAlert.getTruSight() <= 1) then
				return;
			end;
			local mod = NPC.GetModifier(SkillAlert.User.Hero,"modifier_truesight");
			if mod and Entity.IsAlive(SkillAlert.User.Hero) then
					SkillAlert.CreateOverheadParticle(SkillAlert.User.Hero ~ mod, SkillAlert.User.Hero, SkillAlert.SkillModifiers[Modifier.GetName(mod)][1]);
			end;
		else
			for i in pairs(SkillAlert.Particles) do
				if (i ~= nil) then
					ClearParticle(i);
				end;
			end;
		end;
	end;
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
		if ent and mod and (Modifier.GetName(mod)=="modifier_truesight") then
			local TrueSightType = SkillAlert.getTruSight();
			if not NPC.IsHero(ent) or ((TrueSightType <= 1) or ((TrueSightType == 2) and (ent~=SkillAlert.User.Hero)) or ((TrueSightType == 3) and not Entity.IsSameTeam(ent, SkillAlert.User.Hero))) then
				return;
			end;
		end;
		if SkillAlert.SkillModifiers[Modifier.GetName(mod)] ~= nil then
			if SkillAlert.SkillModifiers[Modifier.GetName(mod)][2] == "position" then
				if SkillAlert.isDefaultSkillEffects() then
					SkillAlert.CreateRangeParticle(ent ~ mod, ent, SkillAlert.SkillModifiers[Modifier.GetName(mod)][1]);
				else
					SkillAlert.CreateRangeParticle(ent ~ mod, ent, SkillAlert.getSkillParticleEffect());
				end;
				if (SkillAlert.Particles[ent ~ mod] ~= nil) then
					Particle.SetControlPoint(SkillAlert.Particles[ent ~ mod].ID, 1, Vector(SkillAlert.SkillModifiers[Modifier.GetName(mod)][3], 0, 0));
				end;
			elseif SkillAlert.SkillModifiers[Modifier.GetName(mod)][2] == "overhead" then
				SkillAlert.CreateOverheadParticle(ent ~ mod,ent,SkillAlert.SkillModifiers[Modifier.GetName(mod)][1]);
			elseif SkillAlert.SkillModifiers[Modifier.GetName(mod)][2] == "range" then
				SkillAlert.CreateRangeParticle(ent ~ mod, ent, SkillAlert.SkillModifiers[Modifier.GetName(mod)][1])
				if (SkillAlert.Particles[ent ~ mod] ~= nil) and (SkillAlert.Particles[ent ~ mod].ID ~= nil) then
					Particle.SetControlPoint(SkillAlert.Particles[ent ~ mod].ID, 1, Vector(SkillAlert.SkillModifiers[Modifier.GetName(mod)][3], 0, 0));
				end;
			end;
			if (SkillAlert.Particles[ent ~ mod] ~= nil) and (SkillAlert.Particles[ent ~ mod].ID ~= nil) then
				Particle.SetControlPoint(SkillAlert.Particles[ent ~ mod].ID, 6, Vector(1, 0, 0));
			end;
		else
			-- not listed modifier
		end;
	end;
end;

function SkillAlert.OnModifierDestroy(ent, mod)
	if SkillAlert.isEnabled() then
		if SkillAlert.SkillModifiers[Modifier.GetName(mod)] ~= nil then
			if (SkillAlert.Particles[ent ~ mod] ~= nil) then
				SkillAlert.ClearParticle(ent ~ mod);
			end;
		else
			-- not listed modifier
			if (SkillAlert.Particles[ent ~ mod] ~= nil) then
				Log.Write(Modifier.GetName(mod));
				SkillAlert.ClearParticle(ent ~ mod);
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