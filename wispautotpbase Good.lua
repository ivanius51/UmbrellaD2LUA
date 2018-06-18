local wisp = {}
wisp.optionEnable = Menu.AddOptionBool({"Hero Specific", "Io"}, "Auto TP After Relocate", false)
wisp.toggleKey = Menu.AddKeyOption({"Hero Specific", "Io"}, "Toggle Key", Enum.ButtonCode.KEY_NONE)
local font = Renderer.LoadFont("Tahoma", 18, Enum.FontWeight.BOLD)
local toggled1 = false
local base = nil
local myHero = nil;
local myTeam = 0;
local casted = false;
local modWispRelocate = nil;
local TPitem = nil;
local dieTime = 0;
local StatusScreenPos = {};
StatusScreenPos.x = 0;
StatusScreenPos.y = 0;

function wisp.init()
	if Engine.IsInGame() then
		myHero = Heroes.GetLocal();
		myTeam = Entity.GetTeamNum(myHero);
		dieTime = 0;
		if myTeam == 3 then 
			base = Vector(7264.000000, 6560.000000, 512.000000)
		else
			base = Vector(-7317.406250, -6815.406250, 512.000000)
		end
		local x, y = Renderer.GetScreenSize();
		StatusScreenPos.x = math.floor(x * 0.594);
		StatusScreenPos.y = math.floor(y * 0.84);
	end;
end;

wisp.init();

function wisp.OnGameStart()
	wisp.init();
end;

function wisp.OnUpdate() 
	if not Heroes.GetLocal() or not Menu.IsEnabled(wisp.optionEnable) then return end
	if NPC.GetUnitName(myHero) ~= "npc_dota_hero_wisp" then return end
	if Menu.IsKeyDownOnce(wisp.toggleKey) then
		if toggled1 == false then
			toggled1 = true
		else
			toggled1 = false
		end
	end
	if toggled1 then
		local GameTime = GameRules.GetGameTime();
		if (dieTime <= 0) or ((dieTime - GameTime) < 0) then 
			modWispRelocate = NPC.GetModifier(myHero, "modifier_wisp_relocate_return");
			if modWispRelocate then
				dieTime = Modifier.GetCreationTime(modWispRelocate) + 12;
				Log.Write(dieTime - GameTime);
			end;
		else
			if modWispRelocate and not casted then
				if (dieTime - GameTime <= 2.96 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)) and (dieTime- GameTime > 2.8) then	
					local TPitem = NPC.GetItem(myHero, "item_tpscroll", true)
					if not TPitem then
						TPitem = NPC.GetItem(myHero, "item_travel_boots", true)
						if not TPitem then
							TPitem = NPC.GetItem(myHero, "item_travel_boots_2", true)
						end
					end
					if TPitem and Entity.IsAbility(TPitem) and Ability.IsReady(TPitem) then
						Log.Write(dieTime - GameTime);
						Ability.CastPosition(TPitem, base)
						casted = true;
					end;
				end
			else
				casted = false;
			end
		end;
	end;
end

function wisp.OnDraw()
	if not Menu.IsEnabled(wisp.optionEnable) or not Heroes.GetLocal() then return end
	if toggled1 then
		Renderer.SetDrawColor(90, 255, 100)
		Renderer.DrawText(font, StatusScreenPos.x, StatusScreenPos.y, "[Auto-TP: ON]")
	else
		Renderer.SetDrawColor(255, 90, 100)
		Renderer.DrawText(font, StatusScreenPos.x, StatusScreenPos.y, "[Auto-TP: OFF]")
	end	
end
return wisp