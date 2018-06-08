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

function table.findValue(list, toFind)
	for k, v in pairs(list) do
		if v == toFind then
			return k;
		end;
	end;
	return nil;
end;

local CustomRangeRadius = {};

CustomRangeRadius.Menu = {};
CustomRangeRadius.User = {};
CustomRangeRadius.Particles = {};

CustomRangeRadius.Menu.Path = {"Info Screen", "Custom Range Radius"};
CustomRangeRadius.Menu.Enabled = Menu.AddOptionBool(CustomRangeRadius.Menu.Path, "Enabled", false);
CustomRangeRadius.Menu.Count = Menu.AddOptionSlider(CustomRangeRadius.Menu.Path, "Sliders Count", 1, 10, 1);
CustomRangeRadius.Menu.Radius = {};

CustomRangeRadius.User.Hero = nil;
CustomRangeRadius.Particles.Radius = {};

function CustomRangeRadius.CreateRangeParticle(index)
	if (CustomRangeRadius.User.Hero == nil) then
		return false;
	end;
	if (CustomRangeRadius.Particles.Radius[index] == nil) then
		CustomRangeRadius.Particles.Radius[index] = {};
		CustomRangeRadius.Particles.Radius[index].ID = Particle.Create("particles/ui_mouseactions/range_display.vpcf", Enum.ParticleAttachment.PATTACH_ABSORIGIN_FOLLOW, CustomRangeRadius.User.Hero);
		CustomRangeRadius.Particles.Radius[index].Value = 0;
		return true;
	end;
	return false;
end;
function CustomRangeRadius.ClearRangeParticle(index)
	if CustomRangeRadius.Particles.Radius[index] then
		Particle.Destroy(CustomRangeRadius.Particles.Radius[index].ID);
		CustomRangeRadius.Particles.Radius[index] = nil;
	end;
end;
function CustomRangeRadius.SetRange(index,range)
	if (CustomRangeRadius.User.Hero == nil) then
		return false;
	end
	CustomRangeRadius.CreateRangeParticle(index);
	if (CustomRangeRadius.Particles.Radius[index].ID ~= 0) and (CustomRangeRadius.Particles.Radius[index].Value ~= range) then
		if (CustomRangeRadius.Particles.Radius[index].Value ~= 0) then
			CustomRangeRadius.ClearRangeParticle(index);
			CustomRangeRadius.CreateRangeParticle(index);
		end;
		CustomRangeRadius.Particles.Radius[index].Value = range;
		Particle.SetControlPoint(CustomRangeRadius.Particles.Radius[index].ID, 1, Vector(tonumber(range),0,0));
		Particle.SetControlPoint(CustomRangeRadius.Particles.Radius[index].ID, 6, Vector(1, 0, 0));
		return true;
	end;
	return false;
end;

function CustomRangeRadius.isEnabled()
	return Menu.IsEnabled(CustomRangeRadius.Menu.Enabled);
end;
function CustomRangeRadius.GetRadius(nameOrIndex)
	if CustomRangeRadius.Menu.Radius[nameOrIndex] then
		return Menu.GetValue(CustomRangeRadius.Menu.Radius[nameOrIndex]);
	end;
	return 0;
end;
function CustomRangeRadius.AddRadius(nameOrIndex)
	if not CustomRangeRadius.Menu.Radius[nameOrIndex] and (nameOrIndex~=0) then
		CustomRangeRadius.Menu.Radius[nameOrIndex] = Menu.AddOptionSlider(CustomRangeRadius.Menu.Path, "Radius "..nameOrIndex, 150, 2500, 1200);
		CustomRangeRadius.SetRange(nameOrIndex,CustomRangeRadius.GetRadius(nameOrIndex));
	end;
end;
function CustomRangeRadius.RemoveRadius(nameOrIndex)
	Menu.RemoveOption(CustomRangeRadius.Menu.Radius[nameOrIndex]);
	CustomRangeRadius.Menu.Radius[nameOrIndex] = nil;
	CustomRangeRadius.ClearRangeParticle(nameOrIndex);
end;
function CustomRangeRadius.InitRadiusMenu()
	for i=#CustomRangeRadius.Menu.Radius, Menu.GetValue(CustomRangeRadius.Menu.Count) do
		CustomRangeRadius.AddRadius(i);
	end;
end;
function CustomRangeRadius.ClearRadiusMenu()
	for k in pairs(CustomRangeRadius.Menu.Radius) do
		CustomRangeRadius.RemoveRadius(k);
	end;
end;

function CustomRangeRadius.Initialization()
	CustomRangeRadius.User.Hero = Heroes.GetLocal();
	for k in pairs(CustomRangeRadius.Particles.Radius) do
		CustomRangeRadius.ClearRangeParticle(k);
	end;
	--CustomRangeRadius.ClearRadiusMenu();
	--Log.Write(Menu.GetValue(CustomRangeRadius.Menu.Count));
	CustomRangeRadius.InitRadiusMenu();
end;
function CustomRangeRadius.Finalization()
	CustomRangeRadius.User.Hero = nil;
	for k in pairs(CustomRangeRadius.Particles.Radius) do
		CustomRangeRadius.ClearRangeParticle(k);
	end;
	CustomRangeRadius.ClearRadiusMenu();
end;

function CustomRangeRadius.OnMenuOptionChange(option, oldValue, newValue)
	if (option == CustomRangeRadius.Menu.Count) then
		if newValue > #CustomRangeRadius.Menu.Radius then
			for i=#CustomRangeRadius.Menu.Radius, newValue do
				CustomRangeRadius.AddRadius(i);
			end;
		elseif newValue < #CustomRangeRadius.Menu.Radius then
			for i=(#CustomRangeRadius.Menu.Radius-newValue), #CustomRangeRadius.Menu.Radius do
				if CustomRangeRadius.Menu.Radius[i] then
					CustomRangeRadius.RemoveRadius(i);
				end;
			end;
		end;
	elseif (option == CustomRangeRadius.Menu.Enabled) then
		if (newValue == false) then
			CustomRangeRadius.Finalization();
		else
			CustomRangeRadius.Initialization();
		end;
	else
		local index = table.findValue(CustomRangeRadius.Menu.Radius, option);
		if index then
			CustomRangeRadius.SetRange(index, newValue);
		end;
	end;
end;

function CustomRangeRadius.OnGameStart()
	CustomRangeRadius.Initialization();
end;
function CustomRangeRadius.OnGameEnd()
	CustomRangeRadius.Finalization();
end;
CustomRangeRadius.Initialization();

return CustomRangeRadius