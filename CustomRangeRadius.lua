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
	skill ranges 
	more custom ranges
--]]

local CustomRangeRadius = {};
CustomRangeRadius.Menu = {};
CustomRangeRadius.User = {};
CustomRangeRadius.Particles = {};



CustomRangeRadius.Menu.Path = {"Utility", "Custom Range Radius"};
CustomRangeRadius.Menu.Enabled = Menu.AddOptionBool(CustomRangeRadius.Menu.Path, "Enabled", false);
CustomRangeRadius.Menu.Radius = Menu.AddOptionSlider(CustomRangeRadius.Menu.Path, "Radius", 150, 2500, 1300);

CustomRangeRadius.User.Hero = nil;
CustomRangeRadius.Particles.Radius = {};

function CustomRangeRadius.isEnabled()
	return Menu.IsEnabled(CustomRangeRadius.Menu.Enabled);
end;

function CustomRangeRadius.getRadius()
	return Menu.GetValue(CustomRangeRadius.Menu.Radius);
end;

function CustomRangeRadius.Initialization()
	CustomRangeRadius.User.Hero = nil;
	for k in pairs(CustomRangeRadius.Particles.Radius) do
		CustomRangeRadius.Particles.Radius[k] = nil;
	end;
end;

function CustomRangeRadius.Finalization()
	CustomRangeRadius.User.Hero = nil;
	for k in pairs(CustomRangeRadius.Particles.Radius) do
		CustomRangeRadius.Particles.Radius[k] = nil;
	end;
end;

function CustomRangeRadius.CreateRangeParticle(index)
	if (CustomRangeRadius.User.Hero == nil) then
		return false;
	end;
	if (CustomRangeRadius.Particles.Radius[tonumber(index)] == nil) then
		CustomRangeRadius.Particles.Radius[tonumber(index)] = {};
		CustomRangeRadius.Particles.Radius[tonumber(index)].ID = Particle.Create("particles/ui_mouseactions/range_display.vpcf", Enum.ParticleAttachment.PATTACH_ABSORIGIN_FOLLOW, CustomRangeRadius.User.Hero);
		CustomRangeRadius.Particles.Radius[tonumber(index)].Value = 0;
		return true;
	end;
	return false;
end;

function CustomRangeRadius.ClearRangeParticle(index)
	if (CustomRangeRadius.Particles.Radius[tonumber(index)] ~= nil) then
		Particle.Destroy(CustomRangeRadius.Particles.Radius[tonumber(index)].ID);
		CustomRangeRadius.Particles.Radius[tonumber(index)] = nil;
	end;
end;

function CustomRangeRadius.SetRange(index,range)
	if (CustomRangeRadius.User.Hero == nil) then
		return false;
	end
	CustomRangeRadius.CreateRangeParticle(index);
	if (CustomRangeRadius.Particles.Radius[tonumber(index)].ID ~= 0) and (CustomRangeRadius.Particles.Radius[tonumber(index)].Value ~= range) then
		if (CustomRangeRadius.Particles.Radius[tonumber(index)].Value ~= 0) then
			CustomRangeRadius.ClearRangeParticle(index);
			CustomRangeRadius.CreateRangeParticle(index);
		end;
		CustomRangeRadius.Particles.Radius[tonumber(index)].Value = range;
		Particle.SetControlPoint(CustomRangeRadius.Particles.Radius[tonumber(index)].ID, 1, Vector(tonumber(range),0,0));
		Particle.SetControlPoint(CustomRangeRadius.Particles.Radius[tonumber(index)].ID, 6, Vector(1, 0, 0));
		return true;
	end
	return false;
end

function CustomRangeRadius.OnUpdate(p1)
	CustomRangeRadius.User.Hero = Heroes.GetLocal();
	if CustomRangeRadius.User.Hero == nil then 
		return;
	else
		if CustomRangeRadius.isEnabled() then
			-- main radius will be replaced with for loop
			CustomRangeRadius.SetRange(1,CustomRangeRadius.getRadius());
		else
			for i in pairs(CustomRangeRadius.Particles.Radius) do
				CustomRangeRadius.ClearRangeParticle(i);
			end;
		end;
	end;
end;

function CustomRangeRadius.OnGameStart()
	CustomRangeRadius.Initialization();
end

function CustomRangeRadius.OnGameEnd()
	CustomRangeRadius.Finalization();
end

return CustomRangeRadius