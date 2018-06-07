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

--]]
local InfoScreen = {};

function table.tostring(list)
	local result = "{";
	for k, v in pairs(list) do
			-- Check the key type (ignore any numerical keys - assume its an array)
			if type(k) == "string" then
					result = result.."[\""..k.."\"]".."=";
			end;

			-- Check the value type
			if type(v) == "table" then
					result = result..table.tostring(v);
			elseif type(v) == "boolean" then
					result = result..tostring(v);
			else
					result = result.."\""..v.."\"";
			end;
			result = result..",";
	end;
	-- Remove leading commas from the result
	if result ~= "" then
			result = result:sub(1, result:len()-1);
	end;
	return result.."}";
end;

InfoScreen.PseudoData = {};

InfoScreen.PseudoData.ChanseTable = {
  [5] = 0.003802,
  [6] = 0.005440,
  [7] = 0.007359,
  [8] = 0.009552,
  [9] = 0.012016,
  [10] = 0.014746,
  [11] = 0.017736,
  [12] = 0.020983,
  [13] = 0.024482,
  [14] = 0.028230,
  [15] = 0.032221,
  [16] = 0.036452,
  [17] = 0.040920,
  [18] = 0.045620,
  [19] = 0.050549,
  [20] = 0.055704,
  [21] = 0.061081,
  [22] = 0.066676,
  [23] = 0.072488,
  [24] = 0.078511,
  [25] = 0.084744,
  [26] = 0.091183,
  [27] = 0.097826,
  [28] = 0.104670,
  [29] = 0.111712,
  [30] = 0.118949,
  [31] = 0.126379,
  [32] = 0.134001,
  [33] = 0.141805,
  [34] = 0.149810,
  [35] = 0.157983,
  [36] = 0.166329,
  [37] = 0.174909,
  [38] = 0.183625,
  [39] = 0.192486,
  [40] = 0.201547,
  [41] = 0.210920,
  [42] = 0.220365,
  [43] = 0.229899,
  [44] = 0.239540,
  [45] = 0.249307,
  [46] = 0.259872,
  [47] = 0.270453,
  [48] = 0.281008,
  [49] = 0.291552,
  [50] = 0.302103,
  [51] = 0.312677,
  [52] = 0.323291,
  [53] = 0.334120,
  [54] = 0.347370,
  [55] = 0.360398,
  [56] = 0.373217,
  [57] = 0.385840,
  [58] = 0.398278,
  [59] = 0.410545,
  [60] = 0.422650,
  [61] = 0.434604,
  [62] = 0.446419,
  [63] = 0.458104,
  [64] = 0.469670,
  [65] = 0.481125,
  [66] = 0.492481,
  [67] = 0.507463,
  [68] = 0.529412,
  [69] = 0.550725,
  [70] = 0.571429,
  [71] = 0.591549,
  [72] = 0.611111,
  [73] = 0.630137,
  [74] = 0.648649,
  [75] = 0.666667,
  [76] = 0.684211,
  [77] = 0.701299,
  [78] = 0.717949,
  [79] = 0.734177,
  [80] = 0.750276
};

InfoScreen.GameData = {};

InfoScreen.GameData.CritAnimationList = {
  ["phantom_assassin_attack_crit_anim"] = true,
  ["attack_crit_alt_anim"] = 46,
  ["attack_crit_alt_injured"] = 22,
  ["attack_crit_anim"] = 19,
  ["Attack Critical_anim"] = true,
  ["attack_event"] = true
}

InfoScreen.GameData.CriticalSkills = {
  [0] = 0,
  ["juggernaut_blade_dance"] = {20, 25, 30, 35},
  ["skeleton_king_mortal_strike"] = {9, 11, 13, 15}, --15],//
  ["phantom_assassin_coup_de_grace"] = 15,-- talant 20
  ["lycan_shapeshift"] = 30,
  ["brewmaster_drunken_brawler"] = {10, 15, 20, 25},
  ["chaos_knight_chaos_strike"] = 10
};

--OnSkillsTable = {
  --["ogre_magi_multicast"] = {60, 30, 15},--2x, 3x, 4x
--  ["obsidian_destroyer_essence_aura"] = 40-- talant 55
--};

InfoScreen.GameData.PassiveSkillsChanseAtTakeDamage = {
  [0] = 1,
  --["tiny_craggy_exterior"] = {10, 15, 20, 25},
  --["phantom_assassin_blur"] ={20,30,40,50},
  ["legion_commander_moment_of_courage"] = 25,
  ["axe_counter_helix"] = 20
};

InfoScreen.GameData.PassiveSkillsChanseOnAttack = {
  [0] = 2,
  ["spirit_breaker_greater_bash"] = 17,
  ["slardar_bash"] = {10, 15, 20, 25},
  ["faceless_void_time_lock"] = {10, 15, 20, 25},
  --["phantom_lancer_juxtapose"] ={40,45,50},
  ["troll_warlord_berserkers_rage"] = 10,
  ["sniper_headshot"] = 40
};

InfoScreen.GameData.SkillModifiers = {
	["modifier_item_quelling_blade"]= {24, 7},
	["modifier_item_bfury"] = {0.5, 0.25},
	--["modifier_item_iron_talon"] = {1.4},
	["modifier_bloodseeker_bloodrage"] = {0.25, 0.3, 0.35, 0.4}
};


InfoScreen.Menu = {};
InfoScreen.User = nil;
InfoScreen.Particles = {};
InfoScreen.Renderer = {};

InfoScreen.Pseudo = {};
InfoScreen.Pseudo.NoLuckCount = {};
InfoScreen.Pseudo.Chanses = {};
InfoScreen.Pseudo.FindedList = {};
InfoScreen.Pseudo.Enabled = false;
InfoScreen.Menu.Pseudo = {};
InfoScreen.Menu.Pseudo.Path = {"Info Screen", "Pseudo"};
InfoScreen.Menu.Pseudo.PanelsPath = {"Info Screen", "Pseudo", "Panels"};
InfoScreen.Menu.Pseudo.Enabled = Menu.AddOptionBool(InfoScreen.Menu.Pseudo.Path, "Enabled", false);
InfoScreen.Menu.Debug = Menu.AddOptionBool({"Info Screen"}, "Debug Log", false);
InfoScreen.Menu.Pseudo.OverHero = Menu.AddOptionBool(InfoScreen.Menu.Pseudo.Path, "Show Over Hero", true);
InfoScreen.Menu.Pseudo.Panels = {};

InfoScreen.Renderer.Font = Renderer.LoadFont("Tahoma", 11, Enum.FontWeight.EXTRABOLD);
InfoScreen.Renderer.XOffset = -57;
InfoScreen.Renderer.YTopOffset = -55;
InfoScreen.Renderer.YBottomOffset = -17;
InfoScreen.Renderer.BorderSize = 1;
InfoScreen.Renderer.PanelWidth = 129;--110
InfoScreen.Renderer.PanelHeight = 15;

--Menu
function InfoScreen.Menu.AddOptionBool(path, name, list)
  Log.Write("InfoScreen : Add to menu - "..name);
  list[name] = Menu.AddOptionBool(path, name, true);
end;
function InfoScreen.Pseudo.isEnabled()
	return Menu.IsEnabled(InfoScreen.Menu.Pseudo.Enabled);
end;
function InfoScreen.isDebug()
	return Menu.IsEnabled(InfoScreen.Menu.Debug);
end;
--Menu

--Utils
function InfoScreen.GetAbilities(entity)
  local list = {};
  for i=0, 24 do	
		local abil = NPC.GetAbilityByIndex(entity, i);
		if abil and Entity.IsEntity(abil) and (Ability.GetLevel(abil) >= 1) and not Ability.IsHidden(abil) then
			table.insert(list, abil);
		end;
  end;
  return list;
end;
function InfoScreen.GetItems(entity)
  local list = {};
  for i=0, 9 do	
		local item = NPC.GetAbilityByIndex(entity, i);
		if item and Entity.IsEntity(item) then
			table.insert(list, item);
		end;
  end;
  return list;
end;

--Dota 2 Clases Entity based OOP
local D2Unit = {};
function D2Unit:new (entity)
  local object = nil;
  if (entity and (entity ~= 0)) then
    object = {};
    setmetatable(object, self);
    self.__index = self;
    
    object.LastUpdateTime = 0;
    object.Entity = entity;
    
    --static properties
    --Entity.(.+)\(ent object.$1 = Entity.$1(entity
    object.ClassName = Entity.GetClassName(entity);
    object.IsNPC = Entity.IsNPC(entity);
    object.IsHero = Entity.IsHero(entity);
    object.IsPlayer = Entity.IsPlayer(entity);
    object.IsAbility = Entity.IsAbility(entity);
    --object.GetOwner = Entity.GetOwner(entity);
    --object.RecursiveGetOwner = Entity.RecursiveGetOwner(entity);
    --NPC.(.+)\(npc object.$1 = Entity.$1(entity
    object.Name = NPC.GetUnitName(entity);
    object.IsRanged = NPC.IsRanged(entity);
    object.HealthBarOffset = NPC.GetHealthBarOffset(entity);
    object.TeamNum = Entity.GetTeamNum(entity);
    
    --methods
    function object:Update()
      if ((GameRules.GetGameTime() - object.LastUpdateTime) > 0.01) then
        object.LastUpdateTime = GameRules.GetGameTime();
        --
        object.IsAlive = Entity.IsAlive(entity);
        object.HP = Entity.GetHealth(entity);
        object.MaxHP = Entity.GetMaxHealth(entity);
        --
        object.Origin = Entity.GetOrigin(entity);
        object.AbsOrigin = Entity.GetAbsOrigin(entity);
        object.Rotation = Entity.GetRotation(entity);
        object.AbsRotation = Entity.GetAbsRotation(entity);
        --
        object.MP = NPC.GetMana(entity);
        object.MaxMP = NPC.GetMaxMana(entity);
        object.Damage = NPC.GetTrueDamage(entity);
        object.MaximumDamage = NPC.GetTrueMaximumDamage(entity);
        object.AttackRange = NPC.GetAttackRange(entity);
        object.MoveSpeed = NPC.GetMoveSpeed(entity);
        object.Level = NPC.GetCurrentLevel(entity);
        --lists
        object.Abilities = InfoScreen.GetAbilities(entity);
        object.Items = InfoScreen.GetItems(entity);
        object.Modifiers = NPC.GetModifiers(entity);
        return true;
      end;
      return false;
    end;
    function object:ForceUpdate()
      object.LastUpdateTime = 0;
      return object:Update();
    end;
    function object:GetItem(Name)
      return NPC.GetItem(self.Entity, Name);
    end;
    function object:GetAbility(Name)
      return NPC.GetAbility(self.Entity, Name);
    end;
    function object:GetModifier(Name)
      return NPC.GetModifier(self.Entity, Name);
    end;

    function object:HasState(Name)
      return NPC.HasState(self.Entity, Name);
    end;
    function object:HasModifier(Name)
      return NPC.HasModifier(self.Entity, Name);
    end;

    function object:GetAbsOrigin()
      object.AbsOrigin = Entity.GetAbsOrigin(self.Entity);
      return object.AbsOrigin;
    end;
    function object:IsAlive()
      object.IsAlive = Entity.IsAlive(self.Entity);
      return object.IsAlive;
    end;
    function object:GetLevel()
      object.Level = NPC.GetCurrentLevel(self.Entity);
      return object.Level;
    end;
    function object:GetMana()
      return NPC.GetMana(self.Entity);
    end;

    object:Update();

  end;
  return object;
end;
--Dota 2 Clases Entity based OOP

function InfoScreen.IsCastNow(entity)
	if not entity then return false, nil end;	
	for i=0, 24 do	
		local abil = NPC.GetAbilityByIndex(entity, i);
		if abil and Entity.IsEntity(abil) and (Ability.GetLevel(abil) >= 1) and not Ability.IsHidden(abil) and not Ability.IsPassive(abil) and (Ability.IsInAbilityPhase(abil) or Ability.IsChanneling(abil)) then
			return true, abil;
		end;
  end;
  if NPC.HasModifier(entity, "modifier_teleporting") then return true, nil end;
	return false, nil;
end;

function InfoScreen.GetTarget(creep, team)
	if not creep then return end;
	if not Entity.IsEntity(creep) then return end;
	if not Entity.IsAlive(creep) then return end;
	
	local creepRotation = Entity.GetRotation(creep):GetForward():Normalized();
	
	local targets = Entity.GetUnitsInRadius(creep, 178, team);
	if next(targets) == nil then return end;
	if not targets then return end;

	if #targets == 1 then
		if (targets[1] ~= creep) and Entity.IsEntity(targets[1]) then
			return targets[1];
		end;
	else
		local adjustedHullSize = 20;
		for i, v in ipairs(targets) do
			if v and (v ~= creep) and Entity.IsEntity(v) and Entity.IsAlive(v) then
				local vpos = Entity.GetAbsOrigin(v);
				local vposZ = vpos:GetZ();
				local pos = Entity.GetAbsOrigin(creep);
				for i = 1, 9 do
					local searchPos = pos + creepRotation:Scaled(25*(9-i));
					searchPos:SetZ(vposZ);
					if NPC.IsPositionInRange(v, searchPos, adjustedHullSize, 0) then
						return v;
					end;
				end;
			end;
		end;
	end;
	return;
end;
--Utils

function InfoScreen.CheckInTable(list, SkillToCheck)
  if not list or not SkillToCheck then
    return false;
  end;
  for name, chanses in pairs(list) do
    local AbilityName = Ability.GetName(SkillToCheck);
    if (name == AbilityName) then
      local chanse = 0;
      local level = Ability.GetLevel(SkillToCheck);
      local NoLuckCount = 1;
      if InfoScreen.Pseudo.NoLuckCount[name] then
        NoLuckCount = InfoScreen.Pseudo.NoLuckCount[name];
      else
        InfoScreen.Pseudo.NoLuckCount[name] = 1;
      end;
      if (type(chanses) == "table") then
        InfoScreen.Pseudo.FindedList[name] = {name:gsub(InfoScreen.User.Name:gsub('npc_dota_hero_', '', 1)..'_', '', 1):gsub("_", " "), NoLuckCount * (InfoScreen.PseudoData.ChanseTable[chanses[level]] + 0.02), list[0], SkillToCheck};
      else
        InfoScreen.Pseudo.FindedList[name] = {name:gsub(InfoScreen.User.Name:gsub('npc_dota_hero_', '', 1)..'_', '', 1):gsub("_", " "), NoLuckCount * (InfoScreen.PseudoData.ChanseTable[chanses] + 0.02), list[0], SkillToCheck};
      end;
      return true;
    end;
  end;
  return false;
end;

function InfoScreen.OnProjectile(projectile)
  if InfoScreen.Pseudo.isEnabled() and particle and InfoScreen.User then
    if InfoScreen.isDebug then
      Log.Write("S="..projectile.source.." T="..projectile.target.." MS="..projectile.moveSpeed.." Names="..projectile.fullName..", "..projectile.name);
    end;
  end;
end;

function InfoScreen.OnLinearProjectileCreate(projectile)
  if InfoScreen.Pseudo.isEnabled() and particle and InfoScreen.User then
    if InfoScreen.isDebug then
      Log.Write("S="..projectile.source.." MS="..projectile.maxSpeed.." Names="..projectile.fullName..", "..projectile.name);
    end;
  end;
end;

function InfoScreen.OnParticleCreate(particle)
  if InfoScreen.Pseudo.isEnabled() and particle and InfoScreen.User then
    --hero_levelup OnLevelUp
    if InfoScreen.isDebug then
      Log.Write(particle.fullName.." "..particle.name);
    end;
    for name, chanselist in pairs(InfoScreen.Pseudo.FindedList) do
      if (particle.name:gsub("_", "")==name:gsub("_", "")) and (chanselist[3]==InfoScreen.GameData.PassiveSkillsChanseAtTakeDamage[0]) then
        InfoScreen.Pseudo.NoLuckCount[name] = 1;
      end;
    end;
  end;
end;

function InfoScreen.OnUnitAnimation(animation)
  if InfoScreen.Pseudo.isEnabled() and animation and InfoScreen.User and (animation.unit==InfoScreen.User.Entity) then
    local ent = InfoScreen.GetTarget(InfoScreen.User.Entity, Enum.TeamType.TEAM_BOTH);
    --Log.Write(animation.sequenceName.."="..animation.sequence.." "..animation.sequenceName:lower():find("attack"));
    if ent and not Entity.IsSameTeam(ent, InfoScreen.User.Entity) then
      if (not InfoScreen.GameData.CritAnimationList[animation.sequenceName]) and (animation.sequenceName:lower():find("attack")) then
        for name, chanselist in pairs(InfoScreen.Pseudo.FindedList) do
          if (chanselist[3]==InfoScreen.GameData.CriticalSkills[0]) or (chanselist[3]==InfoScreen.GameData.PassiveSkillsChanseOnAttack[0]) then
            InfoScreen.Pseudo.NoLuckCount[name] = InfoScreen.Pseudo.NoLuckCount[name] + 1;
          end;
        end;
      else
        for kname, chanselist in pairs(InfoScreen.Pseudo.FindedList) do
          if (chanselist[3]==InfoScreen.GameData.CriticalSkills[0]) then
            InfoScreen.Pseudo.NoLuckCount[name] = 1;
          end;
        end;
      end;
    end;
	end;
end;

function InfoScreen.OnModifierCreate(entity, mod)
  if InfoScreen.Pseudo.isEnabled() and InfoScreen.User and mod then
    local ModifierName = Modifier.GetName(mod);
    local ModifierAbility = Modifier.GetAbility(mod);
    if InfoScreen.isDebug then
      if (NPC.GetUnitName(entity) ~= nil) then
        Log.Write(NPC.GetUnitName(entity)); 
      elseif entity then
        Log.Write(Entity.GetClassName(entity));
      end;
      Log.Write(ModifierName); 
    end;
    if entity and (entity~=0) and NPC.IsEntityInRange(InfoScreen.User.Entity, entity, 250) then
      for name, chanselist in pairs(InfoScreen.Pseudo.FindedList) do
        if (ModifierAbility==chanselist[4]) or ModifierName:lower():gsub("_", ""):find(name:lower():gsub("_", ""))--(v[3]==InfoScreen.GameData.CriticalSkills[0]) 
        then
          if InfoScreen.isDebug then
            Log.Write(ModifierName.."="..name.." "..ModifierAbility.."="..chanselist[4]); 
          end;
          InfoScreen.Pseudo.NoLuckCount[name] = 1;
        end;
      end;
    end;
	end;
end;

function InfoScreen.OnUpdate()
  if InfoScreen.Pseudo.isEnabled() and InfoScreen.User then
    if InfoScreen.User.Update() then
      --
      InfoScreen.Pseudo.Enabled = false;
      for k, v in pairs(InfoScreen.User.Abilities) do
        InfoScreen.Pseudo.Enabled = InfoScreen.Pseudo.Enabled or InfoScreen.CheckInTable(InfoScreen.GameData.CriticalSkills, v);
        InfoScreen.Pseudo.Enabled = InfoScreen.Pseudo.Enabled or InfoScreen.CheckInTable(InfoScreen.GameData.PassiveSkillsChanse, v);
        InfoScreen.Pseudo.Enabled = InfoScreen.Pseudo.Enabled or InfoScreen.CheckInTable(InfoScreen.GameData.PassiveSkillsChanseAtTakeDamage, v);
        InfoScreen.Pseudo.Enabled = InfoScreen.Pseudo.Enabled or InfoScreen.CheckInTable(InfoScreen.GameData.PassiveSkillsChanseOnAttack, v);
      end;
      if (InfoScreen.Pseudo.Enabled) then
        for name, chanselist in pairs(InfoScreen.Pseudo.FindedList) do
          if not InfoScreen.Menu.Pseudo.Panels[chanselist[1]] then
            InfoScreen.Menu.AddOptionBool(InfoScreen.Menu.Pseudo.PanelsPath, chanselist[1], InfoScreen.Menu.Pseudo.Panels);
          end;
          if (Ability.GetCooldown(chanselist[4]) ~= 0) or 
            Ability.IsChannelling(chanselist[4]) or 
            Ability.IsInAbilityPhase(chanselist[4]) or 
            ((Ability.SecondsSinceLastUse(chanselist[4]) ~= -1) and (Ability.SecondsSinceLastUse(chanselist[4]) <= 0.1)) or 
            not Ability.IsReady(chanselist[4]) 
          then
            --if InfoScreen.isDebug then
              Log.Write(Ability.GetName(chanselist[4]));
              Log.Write(Ability.GetCooldown(chanselist[4]));
            --end;
            
          end;
          if ((chanselist[3] == InfoScreen.GameData.PassiveSkillsChanseOnAttack[0]) or (chanselist[3] == InfoScreen.GameData.PassiveSkillsChanseAtTakeDamage[0])) and 
            (Ability.IsInAbilityPhase(chanselist[4]) or ((Ability.SecondsSinceLastUse(chanselist[4]) ~= -1) and (Ability.SecondsSinceLastUse(chanselist[4]) <= 0.5)) or not InfoScreen.User.IsAlive) then
            InfoScreen.Pseudo.NoLuckCount[name] = 1;
          end;
          if (chanselist[3] == InfoScreen.GameData.PassiveSkillsChanseAtTakeDamage[0]) then
            if InfoScreen.User.HP < InfoScreen.Pseudo.OldHP then -- take damage???
              InfoScreen.Pseudo.OldHP = InfoScreen.User.HP;--костыль
              InfoScreen.Pseudo.NoLuckCount[name] = InfoScreen.Pseudo.NoLuckCount[name] + 1;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function InfoScreen.Renderer.DrawBar(x, y, width, height, percent, text, index)
  if percent > 100 then
    percent = 100;
  end;
  Renderer.SetDrawColor(0, 0, 0, 125);
  Renderer.DrawFilledRect(x + InfoScreen.Renderer.XOffset,y + InfoScreen.Renderer.YTopOffset - height*index, width, height);
  Renderer.SetDrawColor(0, 0, 0, 255);
  Renderer.DrawOutlineRect(x + InfoScreen.Renderer.XOffset,y + InfoScreen.Renderer.YTopOffset - height*index, width, height);
  Renderer.SetDrawColor(222, 222, 0, 125);
  Renderer.DrawFilledRect(x + InfoScreen.Renderer.XOffset + InfoScreen.Renderer.BorderSize,y + InfoScreen.Renderer.YTopOffset + InfoScreen.Renderer.BorderSize - height*index, math.ceil(InfoScreen.Renderer.PanelWidth * percent), height - InfoScreen.Renderer.BorderSize * 2);
  Renderer.SetDrawColor(222, 222, 222, 255);
  Renderer.DrawText(InfoScreen.Renderer.Font, x + InfoScreen.Renderer.XOffset + InfoScreen.Renderer.BorderSize, y + InfoScreen.Renderer.YTopOffset + InfoScreen.Renderer.BorderSize * 2 - height*index, text, 1);
end;
function InfoScreen.OnDraw()
  if InfoScreen.Pseudo.isEnabled() and InfoScreen.Pseudo.Enabled and InfoScreen.User and InfoScreen.User.IsAlive then
    InfoScreen.User:GetAbsOrigin(); 
    InfoScreen.User.AbsOrigin:SetZ(InfoScreen.User.AbsOrigin:GetZ() + InfoScreen.User.HealthBarOffset);
    local hx, hy = Renderer.WorldToScreen(InfoScreen.User.AbsOrigin);
    local i = 0;
    for name, chanselist in pairs(InfoScreen.Pseudo.FindedList) do
      if InfoScreen.Menu.Pseudo.Panels[chanselist[1]] and Menu.IsEnabled(InfoScreen.Menu.Pseudo.Panels[chanselist[1]]) then
        InfoScreen.Renderer.DrawBar(hx, hy, InfoScreen.Renderer.PanelWidth, InfoScreen.Renderer.PanelHeight, chanselist[2], "  "..chanselist[1].." "..math.ceil(chanselist[2] * 100).."%", i);
        i = i + 1;
      end;
    end;
  end;
end;

function InfoScreen.OnGameStart()
  Log.Write("Game start");
  InfoScreen.User = D2Unit:new(Heroes.GetLocal());
  InfoScreen.Pseudo.OldHP = InfoScreen.User.HP;--костыль
end;
function InfoScreen.OnGameEnd()
  InfoScreen.User = nil;
  for name, option in pairs(InfoScreen.Menu.Pseudo.Panels) do
    Menu.RemoveOption(option);
  end;
  InfoScreen.Menu.Pseudo.Panels = {};
end;

InfoScreen.User = D2Unit:new(Heroes.GetLocal());


return InfoScreen;