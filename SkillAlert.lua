local AbilityProtector = {};
AbilityProtector.Menu = {};
AbilityProtector.User = {};
AbilityProtector.Particles = {};

AbilityProtector.Menu.Path = {"Utility", "Ability Protector"};
AbilityProtector.Menu.Enabled = Menu.AddOptionBool(AbilityProtector.Menu.Path, "Enabled", false);

AbilityProtector.User.Hero = nil;
AbilityProtector.Particles = {};

function AbilityProtector.isEnabled()
	return Menu.IsEnabled(AbilityProtector.Menu.Enabled);
end;

function AbilityProtector.Initialization()
	AbilityProtector.User.Hero = nil;
	for k in pairs(AbilityProtector.Particles) do
		AbilityProtector.Particles[k] = nil;
	end;
end;

function AbilityProtector.Finalization()
	AbilityProtector.User.Hero = nil;
	for k in pairs(AbilityProtector.Particles) do
		AbilityProtector.Particles[k] = nil;
	end;
end;

function AbilityProtector.CreateRangeParticle(index)
	if (AbilityProtector.User.Hero == nil) then
		return false;
	end;
	if (AbilityProtector.Particles[tonumber(index)] == nil) then
		AbilityProtector.Particles[tonumber(index)] = {};
		AbilityProtector.Particles[tonumber(index)].ID = Particle.Create("particles/ui_mouseactions/range_display.vpcf", Enum.ParticleAttachment.PATTACH_ABSORIGIN_FOLLOW, AbilityProtector.User.Hero);
		AbilityProtector.Particles[tonumber(index)].Value = 0;
		return true;
	end;
	return false;
end;

function AbilityProtector.ClearParticle(index)
	if (AbilityProtector.Particles[tonumber(index)] ~= nil) then
		Particle.Destroy(AbilityProtector.Particles[tonumber(index)].ID);
		AbilityProtector.Particles[tonumber(index)] = nil;
	end;
end;

function AbilityProtector.OnUpdate()
	AbilityProtector.User.Hero = Heroes.GetLocal();
	if AbilityProtector.User.Hero == nil then 
		return;
	else
		if not AbilityProtector.isEnabled() then
			for i in pairs(AbilityProtector.Particles) do
				ClearParticle(i);
			end;
		end;
	end;
end;

function AbilityProtector.OnModifierCreate(ent, mod)

end;


function AbilityProtector.OnGameStart()
	AbilityProtector.Initialization();
end

function AbilityProtector.OnGameEnd()
	AbilityProtector.Finalization();
end

return AbilityProtector