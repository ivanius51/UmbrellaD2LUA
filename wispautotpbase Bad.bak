local wisp = {}
wisp.optionEnable = Menu.AddOptionBool({"Hero Specific", "Io"}, "Auto TP After Relocate", false)
wisp.toggleKey = Menu.AddKeyOption({"Hero Specific", "Io"}, "Toggle Key", Enum.ButtonCode.KEY_NONE)
font = Renderer.LoadFont("Tahoma", 18, Enum.FontWeight.BOLD)
toggled1 = false
base = nil
function wisp.OnUpdate() 
	if not Heroes.GetLocal() or not Menu.IsEnabled(wisp.optionEnable) then return end
	local myHero = Heroes.GetLocal()
	local myTeam = Entity.GetTeamNum(myHero)
	if NPC.GetUnitName(myHero) ~= "npc_dota_hero_wisp" then return end
	if Menu.IsKeyDownOnce(wisp.toggleKey) then
		if toggled1 == false then
			toggled1 = true
		else
			toggled1 = false
		end
	end
	if not toggled1 then return end
	if NPC.HasModifier(myHero, "modifier_wisp_relocate_return") then
		local mod = NPC.GetModifier(myHero, "modifier_wisp_relocate_return")
		local tp = NPC.GetItem(myHero, "item_tpscroll", true)
		if not tp then
			tp = NPC.GetItem(myHero, "item_travel_boots", true)
			if not tp then
				tp = NPC.GetItem(myHero, "item_travel_boots_2", true)
			end
		end
		local dieTime = Modifier.GetCreationTime(mod) + 12
		if myTeam == 3 then 
			base = Vector(7264.000000, 6560.000000, 512.000000)
		else
			base = Vector(-7317.406250, -6815.406250, 512.000000)
		end
		if tp and Ability.IsReady(tp) and dieTime - GameRules.GetGameTime() <= 3 then
			Ability.CastPosition(tp, base)
		end
	end
end
function wisp.OnDraw()
	if not Menu.IsEnabled(wisp.optionEnable) or not Heroes.GetLocal() then return end
	if NPC.GetUnitName(Heroes.GetLocal()) ~= "npc_dota_hero_wisp" then return end
	local x, y = Renderer.GetScreenSize()
	if x == 1920 and y == 1080 then
		x, y = 1150, 910
	elseif x== 1600 and y == 900 then
		x, y = 950, 755
	elseif x== 1366 and y == 768 then
		x, y = 805, 643
	elseif x==1280 and y == 720 then
		x, y = 752, 600
	elseif x==1280 and y == 1024 then
		x, y = 800, 860
	elseif x==1440 and y == 900 then
		x, y = 870, 755
	elseif x== 1680 and y == 1050 then
		x, y = 1025, 885
	end
	if toggled1 then
		Renderer.SetDrawColor(90, 255, 100)
		Renderer.DrawText(font,x,y, "[Auto-TP: ON]")
	else
		Renderer.SetDrawColor(255, 90, 100)
		Renderer.DrawText(font, x, y, "[Auto-TP: OFF]")
	end	
end
return wisp