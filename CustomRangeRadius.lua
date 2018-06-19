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
CustomRangeRadius.Skills = {};
CustomRangeRadius.Inited = false;

CustomRangeRadius.Menu.Path = {"Info Screen", "Custom Range Radius"};
CustomRangeRadius.Menu.SkillsPath = {"Info Screen", "Custom Range Radius", "Skills"};
CustomRangeRadius.Menu.Enabled = Menu.AddOptionBool(CustomRangeRadius.Menu.Path, "Enabled", false);
CustomRangeRadius.Menu.Count = Menu.AddOptionSlider(CustomRangeRadius.Menu.Path, "Sliders Count", 1, 10, 1);
CustomRangeRadius.Menu.Radius = {};
CustomRangeRadius.Menu.Skills = {};

CustomRangeRadius.User.Hero = nil;
CustomRangeRadius.Particles.Radius = {};

function CustomRangeRadius.CreateRangeParticle(index)
	if (CustomRangeRadius.User.Hero == nil) then
		return false;
	end;
	if (CustomRangeRadius.Particles.Radius[index] == nil) then
		CustomRangeRadius.Particles.Radius[index] = {};
		CustomRangeRadius.Particles.Radius[index].ID = Particle.Create("particles/ui_mouseactions/drag_selected_ring.vpcf", Enum.ParticleAttachment.PATTACH_ABSORIGIN_FOLLOW, CustomRangeRadius.User.Hero);
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
	--Log.Write("Remove "..nameOrIndex)
	Menu.RemoveOption(CustomRangeRadius.Menu.Radius[nameOrIndex]);
	CustomRangeRadius.Menu.Radius[nameOrIndex] = nil;
	CustomRangeRadius.ClearRangeParticle(nameOrIndex);
end;
function CustomRangeRadius.InitRadiusMenu()
	--Log.Write(#CustomRangeRadius.Menu.Radius);
	--Log.Write(Menu.GetValue(CustomRangeRadius.Menu.Count));
	for i=#CustomRangeRadius.Menu.Radius, Menu.GetValue(CustomRangeRadius.Menu.Count) do
		CustomRangeRadius.AddRadius(i);
		Menu.LoadSettings();
		CustomRangeRadius.SetRange(i,CustomRangeRadius.GetRadius(i));
	end;
end;
function CustomRangeRadius.ClearRadiusMenu()
	for k in pairs(CustomRangeRadius.Menu.Radius) do
		CustomRangeRadius.RemoveRadius(k);
	end;
end;

function CustomRangeRadius.Initialization()
	if not CustomRangeRadius.Inited and Engine.IsInGame() then
		CustomRangeRadius.User.Hero = Heroes.GetLocal();
		CustomRangeRadius.User.HeroName = NPC.GetUnitName(CustomRangeRadius.User.Hero):gsub('npc_dota_hero_', '', 1);
		--for k in pairs(CustomRangeRadius.Particles.Radius) do
		--	CustomRangeRadius.ClearRangeParticle(k);
		--end;
		Menu.LoadSettings();
		CustomRangeRadius.InitRadiusMenu();
		Menu.SetEnabled(CustomRangeRadius.Menu.Enabled, true);
		for i=0, 24 do	
			local abil = NPC.GetAbilityByIndex(CustomRangeRadius.User.Hero, i);
			if abil and Entity.IsAbility(abil) and not Ability.IsHidden(abil) and not Ability.IsAttributes(abil) then
				--Log.Write();
				local NewOption = Menu.AddOptionBool(CustomRangeRadius.Menu.SkillsPath, Ability.GetName(abil):gsub(CustomRangeRadius.User.HeroName.."_", '', 1):gsub("_", " "), false);
				CustomRangeRadius.Skills[NewOption] = {};
				CustomRangeRadius.Skills[NewOption].Ability = abil;
				CustomRangeRadius.Skills[NewOption].Range = Ability.GetCastRange(abil);
			end;
		end;
		CustomRangeRadius.Inited = true;
	end;
end;
function CustomRangeRadius.Finalization()
	if CustomRangeRadius.Inited then
		CustomRangeRadius.User.Hero = nil;
		for k in pairs(CustomRangeRadius.Particles.Radius) do
			CustomRangeRadius.ClearRangeParticle(k);
		end;
		CustomRangeRadius.ClearRadiusMenu();
		CustomRangeRadius.Inited = false;
	end;
end;

function CustomRangeRadius.OnUpdate()
	if CustomRangeRadius.isEnabled() then
		CustomRangeRadius.Initialization();
	else
		CustomRangeRadius.Finalization();
	end;
end;

function CustomRangeRadius.OnMenuOptionChange(option, oldValue, newValue)
	if (option == CustomRangeRadius.Menu.Count) then
		if newValue > #CustomRangeRadius.Menu.Radius then
			for i=#CustomRangeRadius.Menu.Radius, newValue do
				CustomRangeRadius.AddRadius(i);
			end;
		elseif newValue < #CustomRangeRadius.Menu.Radius then
			for i=(newValue+1), #CustomRangeRadius.Menu.Radius do
				if CustomRangeRadius.Menu.Radius[i] then
					CustomRangeRadius.RemoveRadius(i);
				end;
			end;
		end;
	elseif (option == CustomRangeRadius.Menu.Enabled) then
		--Log.Write(tostring(newValue));
	--[[	
		if (newValue == false) then
			CustomRangeRadius.Finalization();
		else
			CustomRangeRadius.Initialization();
		end;
		--]]
	else--edit radius
		if CustomRangeRadius.Skills[option] then
			if newValue then
				Log.Write(CustomRangeRadius.Skills[option].Range);
				if CustomRangeRadius.Skills[option].Range>0 then
					CustomRangeRadius.SetRange(option,CustomRangeRadius.Skills[option].Range);
				end;
			else
				CustomRangeRadius.ClearRangeParticle(option);
			end;
		else
			local index = table.findValue(CustomRangeRadius.Menu.Radius, option);
			if index then
				CustomRangeRadius.SetRange(index, newValue);
			end;
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