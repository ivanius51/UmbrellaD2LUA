local CustomRangeRadius = {}
CustomRangeRadius.Menu = {}
CustomRangeRadius.User = {}
CustomRangeRadius.Particles = {}

CustomRangeRadius.Menu.Path = {"Utility", "Custom Range Radius"}
CustomRangeRadius.Menu.Enabled = Menu.AddOptionBool(CustomRangeRadius.Menu.Path, "Enabled", false)
CustomRangeRadius.Menu.Radius = Menu.AddOptionSlider(CustomRangeRadius.Menu.Path, "Radius", 150, 2500, 1300)

CustomRangeRadius.User.Hero = nil
CustomRangeRadius.Particles.Radius = {}

function CustomRangeRadius.isEnabled()
	return Menu.IsEnabled(CustomRangeRadius.Menu.Enabled)
end

function CustomRangeRadius.getRadius()
	return Menu.GetValue(CustomRangeRadius.Menu.Radius)
end

function CustomRangeRadius.Initialization()
	CustomRangeRadius.User.Hero = nil
	for k in pairs(CustomRangeRadius.Particles.Radius) do
		CustomRangeRadius.Particles.Radius[k] = nil
	end
end

function CustomRangeRadius.Finalization()
	CustomRangeRadius.User.Hero = nil
	for k in pairs(CustomRangeRadius.Particles.Radius) do
		CustomRangeRadius.Particles.Radius[k] = nil
	end
end

function CustomRangeRadius.SetRange(index,range)
	if CustomRangeRadius.User.Hero == nil then
		return false
	elseif ((CustomRangeRadius.Particles.Radius[index] == nil) or (CustomRangeRadius.Particles.Radius[index].ID == 0)) then
		CustomRangeRadius.Particles.Radius[index] = {}
		CustomRangeRadius.Particles.Radius[index].ID = Particle.Create("particles/range_display_blue.vpcf", Enum.ParticleAttachment.PATTACH_ABSORIGIN_FOLLOW, CustomRangeRadius.User.Hero)
		CustomRangeRadius.Particles.Radius[index].Value = range
		Particles.SetControlPoint(CustomRangeRadius.Particles.Radius[index].ID, 1, Vector(range,0,0))
		return true
	elseif CustomRangeRadius.Particles.Radius[index].Value ~= range then
		Particles.SetControlPoint(CustomRangeRadius.Particles.Radius[index].ID, 1, Vector(range,0,0))
		return true
	end
	return false
end

function CustomRangeRadius.OnUpdate(p1)
	CustomRangeRadius.User.Hero = Heroes.GetLocal()
	if CustomRangeRadius.User.Hero == nil then 
		return 
	else
		if CustomRangeRadius.isEnabled() then
			-- main radius will be replaced with for loop
			CustomRangeRadius.SetRange(0,CustomRangeRadius.getRadius())
		else
			for i in pairs(CustomRangeRadius.Particles.Radius) do
				if	(CustomRangeRadius.Particles.Radius[i].ID == 0) then
					Particle.Destroy(CustomRangeRadius.Particles.Radius[i].ID)
					CustomRangeRadius.Particles.Radius[i].ID = 0
				end
			end
		end
	end
end

function CustomRangeRadius.OnGameStart()
	CustomRangeRadius.Initialization()
end

function CustomRangeRadius.OnGameEnd()
	CustomRangeRadius.Finalization()
end

return CustomRangeRadius