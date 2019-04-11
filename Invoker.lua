local Invoker = {}

local keyGhostWalk = Menu.AddKeyOption({"Hero Specific", "Invoker"}, "Ghost Walk Key", Enum.ButtonCode.KEY_F5)
local RightClickCombo = Menu.AddOptionBool({"Hero Specific", "Invoker"}, "Right Click Combo", "cast cold snap, alacrity or forge spirit when right click enemy hero or building")
local MeteorBlastCombo = Menu.AddOptionBool({"Hero Specific", "Invoker"}, "Meteor & Blast Combo", "cast deafening blast after chaos meteor")
--local DoTCombo = Menu.AddOptionBool({"Hero Specific", "Invoker"}, "DoT Combo", "cast cold snap on enemy who is affected by DoT, like chaos meteor, urn, ice wall, etc.")
--local ColdSnapCombo = Menu.AddOptionBool({"Hero Specific", "Invoker"}, "Cold Snap Combo", "if someone is affected by cold snap, cast sun strike and EMP")
local TornadoCombo = Menu.AddOptionBool({"Hero Specific", "Invoker"}, "Eul/Tornado Combo", "Auto cast ice wall, chaos meteor, sun strike, EMP with eul/tornado")
local FixedPositionCombo = Menu.AddOptionBool({"Hero Specific", "Invoker"}, "Fixed Position Combo", "Auto cast sun strike, chaos meteor, EMP on fixed enemies.")
local SlowedCombo = Menu.AddOptionBool({"Hero Specific", "Invoker"}, "Slowed Combo", "Auto cast sun strike, chaos meteor, EMP on slowed enemies.")
local InstanceHelper = Menu.AddOptionBool({"Hero Specific", "Invoker"}, "Instance Helper", "auto switch instances, EEE when attacking, WWW when running")
local KillSteal = Menu.AddOptionBool({"Hero Specific", "Invoker"}, "Kill Steal", "auto cast deafening blast, tornado or sun strike to predicted position to KS")
local LinkenBreaker = Menu.AddOptionBool({"Hero Specific", "Invoker"}, "Linken Breaker", "auto cast cold snap to break linken sphere")
local Interrupt = Menu.AddOptionBool({"Hero Specific", "Invoker"}, "Interrupt", "Auto interrupt enemy's tp or channelling spell with tornado or cold snap")
--local SpellProtection = Menu.AddOptionBool({"Hero Specific", "Invoker"}, "Spell Protection", "Protect uncast spell by moving casted spell to second slot")
local Defend = Menu.AddOptionBool({"Hero Specific", "Invoker"}, "Defend", "If enemies are too close, auto cast (1) tornado, (2) blast, (3) cold snap, or (4) ghost walk to escape.")
local IceWallHelper = Menu.AddOptionBool({"Hero Specific", "Invoker"}, "Ice Wall Helper", "Auto cast ice wall if it can affect an enemy.")

local currentInstances;
local timer = 0;
local gap = 0.2; -- 0.2s seems to be a proper timing, 0.1s might cause issuese like break invisability.
local UserHero = nil;

function Invoker.OnUpdate()
    
    if not UserHero or NPC.GetUnitName(UserHero) ~= "npc_dota_hero_invoker" then return end

    if Menu.IsKeyDownOnce(keyGhostWalk) then
        Invoker.CastGhostWalk(UserHero)
        return
    end

    Invoker.Iteration(UserHero)
end

function Invoker.OnPrepareUnitOrders(orders)
    if not orders then return true end
    if orders.order == Enum.UnitOrder.DOTA_UNIT_ORDER_TRAIN_ABILITY then return true end

    
    if not UserHero or NPC.GetUnitName(UserHero) ~= "npc_dota_hero_invoker" then return true end

    if Menu.IsEnabled(RightClickCombo) and orders.order == Enum.UnitOrder.DOTA_UNIT_ORDER_ATTACK_TARGET then
        Invoker.RightClickCombo(UserHero, orders.target)
    end

    if Menu.IsEnabled(InstanceHelper) then
        Invoker.InstanceHelper(UserHero, orders.order)
    end

    --if Menu.IsEnabled(SpellProtection) and orders.ability and Entity.IsAbility(orders.ability) then
    --    Invoker.ProtectSpell(UserHero, orders.ability)
    --end

    return true
end

function Invoker.Initialization()
	if not UserHero then
		UserHero = Heroes.GetLocal();
	end;
	if timer == 0 then
		timer = GameRules.GetGameTime();
	end;
end;

function Invoker.OnGameStart()
	Invoker.Initialization();
end;

function Invoker.OnGameEnd()
	UserHero = nil;
	timer = 0;
end

--Utility
local Utility = {};

Utility.StunModifiers = {
    "modifier_stunned",
    "modifier_bashed",
    "modifier_bane_fiends_grip",
    "modifier_rattletrap_hookshot",
    "modifier_winter_wyvern_winters_curse_aura",
    "modifier_necrolyte_reapers_scythe",
    "modifier_sandking_impale",
    "modifier_skeleton_king_hellfire_blast",
    "modifier_ogre_magi_fireblast_multicast"
}

Utility.HexModifiers = {
    "modifier_lion_voodoo",
    "modifier_shadow_shaman_voodoo",
    "modifier_sheepstick_debuff"
}

-- Reference: https://dota2.gamepedia.com/Sleep
Utility.SleepModifiers = {
    "modifier_bane_nightmare",
    "modifier_elder_titan_echo_stomp",
    "modifier_naga_siren_song_of_the_siren"
}

-- Reference: https://dota2.gamepedia.com/Root
Utility.RootModifiers = {
    "modifier_crystal_maiden_frostbite",
    "modifier_dark_troll_warlord_ensnare",
    "modifier_ember_spirit_searing_chains",
    "modifier_meepo_earthbind",
    "modifier_naga_siren_ensnare",
    "modifier_oracle_fortunes_end_purge",
    "modifier_rod_of_atos_debuff",
    "modifier_lone_druid_spirit_bear_entangle_effect",
    "modifier_techies_stasis_trap_stunned",
    "modifier_treant_natures_guise_root",
    "modifier_treant_overgrowth",
    "modifier_abyssal_underlord_pit_of_malice_ensare",
    "modifier_earthspirit_petrify"
}

Utility.OtherHold = {
    "modifier_pudge_dismember",
    "modifier_axe_berserkers_call"
}

function Invoker.OnModifierCreate(entity, mod)
    --[[
      local ModifierName = Modifier.GetName(mod);
      local ModifierAbility = Modifier.GetAbility(mod);
      if ModifierAbility then
        Log.Write(ModifierName.."="..(Modifier.GetDieTime(mod) - GameRules.GetGameTime()).." "..ModifierAbility.."="); 
    else
        Log.Write(ModifierName);
    end;
    ]]
end;

function Utility.GetFixTimeLeft(npc)
    local lastmod = 0;

    if NPC.HasState(npc, Enum.ModifierState.MODIFIER_STATE_HEXED) then 
        --check hex
        --Log.Write("check hex");
        for i, val in ipairs(Utility.HexModifiers) do
            local mod = NPC.GetModifier(npc, val)
            if mod and (Modifier.GetDieTime(mod) - GameRules.GetGameTime() > 0) then lastmod = math.max(lastmod, Modifier.GetDieTime(mod) - GameRules.GetGameTime()) end
        end
    end;

    if NPC.HasState(npc, Enum.ModifierState.MODIFIER_STATE_ROOTED) then
        --check rooots
        --Log.Write("check rooots");
        for i, val in ipairs(Utility.RootModifiers) do
            local mod = NPC.GetModifier(npc, val)
            if mod and (Modifier.GetDieTime(mod) - GameRules.GetGameTime() > 0) then lastmod = math.max(lastmod, Modifier.GetDieTime(mod) - GameRules.GetGameTime()) end
        end
    end;

    if NPC.HasState(npc, Enum.ModifierState.MODIFIER_STATE_STUNNED) then
        --check StunModifiers
        --Log.Write("check StunModifiers");
        for i, val in ipairs(Utility.StunModifiers) do
            local mod = NPC.GetModifier(npc, val)
            if mod and (Modifier.GetDieTime(mod) - GameRules.GetGameTime() > 0) then lastmod = math.max(lastmod, Modifier.GetDieTime(mod) - GameRules.GetGameTime()) end
        end
        --Log.Write("check StunModifiers"..lastmod);
    end;

    if NPC.IsChannellingAbility(npc) then
        for i=0, 24 do	
            local abil = NPC.GetAbilityByIndex(npc, i);
            if abil and (Ability.GetLevel(abil) >= 1) and not Ability.IsHidden(abil) and not Ability.IsPassive(abil) and (Ability.IsInAbilityPhase(abil) or Ability.IsChannelling(abil)) then
                lastmod = math.max(lastmod, Ability.GetChannelStartTime(abil) - GameRules.GetGameTime())
            end;
        end;
    end;

    for i, val in ipairs(Utility.SleepModifiers) do
        local mod = NPC.GetModifier(npc, val)
        if mod and (Modifier.GetDieTime(mod) - GameRules.GetGameTime() > 0) then lastmod = math.max(lastmod, Modifier.GetDieTime(mod) - GameRules.GetGameTime()) end
    end

    for i, val in ipairs(Utility.OtherHold) do
        local mod = NPC.GetModifier(npc, val)
        if mod and (Modifier.GetDieTime(mod) - GameRules.GetGameTime() > 0) then lastmod = math.max(lastmod, Modifier.GetDieTime(mod) - GameRules.GetGameTime()) end
    end

    if (lastmod < 0.25) then
        lastmod = 0;
    end;
    return lastmod;
end

function IsInvisible(entity)
	if not entity then return false end;
	if 
		NPC.HasState(entity, Enum.ModifierState.MODIFIER_STATE_INVISIBLE)
		or NPC.HasModifier(entity, "modifier_invisible")
		or NPC.HasModifier(entity, "modifier_invoker_ghost_walk_self")
		or NPC.HasModifier(entity, "modifier_item_invisibility_edge_windwalk")
		or NPC.HasModifier(entity, "modifier_item_silver_edge_windwalk")
		or NPC.HasModifier(entity, "modifier_item_glimmer_cape_fade")
	then 
		return true;
	else
		return false;
	end;
end;

function IsCastNow(entity)
	if not entity then return false end;	
	if NPC.IsChannellingAbility(entity) then return true end;
	if NPC.HasModifier(entity, "modifier_teleporting") then return true end;
	for i=0, 24 do	
		local abil = NPC.GetAbilityByIndex(entity, i);
		if abil and (Ability.GetLevel(abil) >= 1) and not Ability.IsHidden(abil) and not Ability.IsPassive(abil) and (Ability.IsInAbilityPhase(abil) or Ability.IsChannelling(abil)) then
				--Log.Write(Ability.GetName(abil));
				return true;
		end;
	end;
	return false;
end;

function isCanAttackTarget(target)
	if 
		Entity.IsDormant(target) or 
		--not NPC.IsVisible(target) or 
		NPC.IsWaitingToSpawn(target) or 
		not Entity.IsAlive(target) or 
		NPC.IsStructure(target) or 
		not NPC.IsKillable(target)
	then 
		return false;
	else
		return true;
	end;
end;


-- return true if can cast spell on this npc, return false otherwise
function hasInMagicImmune(npc)
	if 
		isCanAttackTarget(npc)
		and not NPC.HasState(npc, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE)
		and not NPC.HasState(npc, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE)
		and not NPC.HasModifier(npc, "modifier_item_aeon_disk_buff")
	then 
		return false;
	else
		return true;
	end;
end;

function IsDisabled(entity)
	if 
		not entity
		or not Entity.IsAlive(entity) 
		or NPC.IsStunned(entity) 
		or NPC.HasState(entity, Enum.ModifierState.MODIFIER_STATE_HEXED)
		or NPC.HasState(entity, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) then 
		return true;
	else
		return false; 
	end;
end;

function CanCastSpells(caster)
	if 
		not caster
		or IsCastNow(caster)
		or IsInvisible(caster)
		or IsDisabled(caster)
		or NPC.IsSilenced(caster)
	then
		return false; 
	else 
		return true;
	end;
end;

function CanUseItems(caster)
	if 
		not caster
		or IsCastNow(caster)
		or IsInvisible(caster)
		or IsDisabled(caster)
		or NPC.HasState(caster, Enum.ModifierState.MODIFIER_STATE_MUTED)
		or NPC.HasModifier(caster, "modifier_item_nullifier_mute")
	then
		return false; 
	else 
		return true;
	end;
end;

function IsSuitableToCastSpell(myHero)
  if CanCastSpells(myHero) then
		return true;
	else
		return false;
	end;
end;

function IsSuitableToUseItem(myHero)
	if CanUseItems(myHero) then
		return true;
	else
		return false;
	end;
end;

function GetPredictedPosition(npc, delay)
    local pos = Entity.GetAbsOrigin(npc)
    if not NPC.IsRunning(npc) or not delay then return pos end
    local totalLatency = (NetChannel.GetAvgLatency(Enum.Flow.FLOW_INCOMING) + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)) -- * 2 -- this may fix bot is not stopping at high ping
    delay = delay + totalLatency

    local dir = Entity.GetRotation(npc):GetForward():Normalized()
    local speed = NPC.GetMoveSpeed(npc)

    return pos + dir:Scaled(speed * delay)
end
--Utility
-- deal all iteration related features, for efficiency
function Invoker.Iteration(myHero)
	if not myHero then return end
	if not IsSuitableToCastSpell(myHero) then return end

	for i = 1, Heroes.Count() do
		local enemy = Heroes.Get(i)
        if 
            enemy 
            and not Entity.IsSameTeam(myHero, enemy) 
            and not NPC.IsIllusion(enemy)
            --and isCanAttackTarget(enemy)
        then

			if Menu.IsEnabled(Defend) then Invoker.Defend(myHero, enemy) end

			if Menu.IsEnabled(IceWallHelper) then Invoker.CastIceWall(myHero, enemy) end

			if Menu.IsEnabled(KillSteal) then Invoker.KillSteal(myHero, enemy) end

			if Menu.IsEnabled(Interrupt) then Invoker.Interrupt(myHero, enemy) end

			if Menu.IsEnabled(FixedPositionCombo) then Invoker.FixedPositionCombo(myHero, enemy) end

			if Menu.IsEnabled(SlowedCombo) then Invoker.SlowedCombo(myHero, enemy) end

			if Menu.IsEnabled(LinkenBreaker) then Invoker.LinkenBreaker(myHero, enemy) end

			if Menu.IsEnabled(MeteorBlastCombo) then Invoker.MeteorBlastCombo(myHero, enemy) end

			if Menu.IsEnabled(TornadoCombo) then Invoker.TornadoCombo(myHero, enemy) end

			--if Menu.IsEnabled(DoTCombo) then Invoker.DoTCombo(myHero, enemy) end

			--if Menu.IsEnabled(ColdSnapCombo) then Invoker.ColdSnapCombo(myHero, enemy) end
		end
	end
end

function Invoker.InstanceHelper(myHero, order)
    if not myHero or not order then return end
    if not IsSuitableToCastSpell(myHero) then return end

    local pattern = "WWW"
    local E = NPC.GetAbility(myHero, "invoker_exort")
    if E and Ability.IsCastable(E, 0) then pattern = "EEE" end

    if Invoker.GetInstances(myHero) ~= pattern then
        currentInstances = Invoker.GetInstances(myHero)
    end

    -- if about to move or press STOP
    if order == Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION
    or order == Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_TARGET
    or order == Enum.UnitOrder.DOTA_UNIT_ORDER_HOLD_POSITION
    or order == Enum.UnitOrder.DOTA_UNIT_ORDER_STOP then
        Invoker.PressKey(myHero, currentInstances)
    end

    -- if about to attack
    if order == Enum.UnitOrder.DOTA_UNIT_ORDER_ATTACK_MOVE or order == Enum.UnitOrder.DOTA_UNIT_ORDER_ATTACK_TARGET then
        Invoker.PressKey(myHero, pattern)
    end
end

-- when attacking enemy hero, enemy building, rosh, or farming hard/ancient camp
-- combo: right click -> cold snap
-- combo: right click -> alacrity
-- combo: right click -> forge spirit
function Invoker.RightClickCombo(myHero, target)
    if 
        not myHero 
        or not target 
        or not IsSuitableToCastSpell(myHero) 
        or Entity.IsSameTeam(myHero, target) 
        or not NPC.IsEntityInRange(myHero, target, NPC.GetAttackRange(myHero) + 50) 
		then 
			return false
        end

    -- disable this combo if level is too low
    if NPC.GetCurrentLevel(myHero) <= 2 then return false end

    if NPC.IsHero(target) or NPC.IsRoshan(target) then
			
        -- combo: right click -> cold snap
        if 
        --Log.Write("RightClickCombo try CastColdSnap") or 
        Invoker.CastColdSnap(myHero, target) then Log.Write("RightClickCombo CastColdSnap"); return true end
    end

    if NPC.IsHero(target) or NPC.IsRoshan(target) or NPC.IsStructure(target) or (NPC.IsCreep(target) and not NPC.IsLaneCreep(target)) then

        -- combo: right click -> alacrity
        if 
        --Log.Write("RightClickCombo try CastAlacrity") or 
        Invoker.CastAlacrity(myHero, myHero) then Log.Write("RightClickCombo CastAlacrity");return true end

        -- combo: right click -> forge spirit
        if 
        --Log.Write("RightClickCombo try CastForgeSpirit") or 
        Invoker.CastForgeSpirit(myHero) then Log.Write("RightClickCombo CastForgeSpirit");return true end
    end

end

-- tornado/eul combo
-- priority: ice wall -> sun strike -> chaos meteor -> emp
function Invoker.TornadoCombo(myHero, enemy)
    if not myHero or not enemy then return false end;
    if not IsSuitableToCastSpell(myHero) then return false end;
    --if hasInMagicImmune(enemy) then return false end;
	--if isCanAttackTarget(enemy) then return false end;

    local mod

    local mod1 = NPC.GetModifier(enemy, "modifier_invoker_tornado")
    local mod2 = NPC.GetModifier(enemy, "modifier_eul_cyclone")
    local mod3 = NPC.GetModifier(enemy, "modifier_brewmaster_storm_cyclone")

    if mod1 then mod = mod1 end
    if mod2 then mod = mod2 end
    if mod3 then mod = mod3 end

    if not mod then return false end

    local enemy_pos = Entity.GetAbsOrigin(enemy)
    local time_left = math.max(Modifier.GetDieTime(mod) - GameRules.GetGameTime(), 0)

    local meteor = NPC.GetAbility(myHero, "invoker_chaos_meteor");
    local sun_strike = NPC.GetAbility(myHero, "invoker_sun_strike");
    local blast = NPC.GetAbility(myHero, "invoker_deafening_blast");

    --Log.Write("try TornadoCombo");

    -- -- 1. cast ice wall
    --if Invoker.CastIceWall(myHero, enemy) then return true end

    -- 2. cast sun strike
    -- delay: 1.7, cast point: 0.05, radius: 175, window: 175/400 = 0.4375
    if 
        (time_left < 1.75)
    then 
        if (time_left > (1.75 - 0.4375)) and Invoker.CastSunStrike(myHero, enemy_pos) then
            Log.Write("TornadoCombo CastSunStrike "..time_left);
        end;
        --return true 
    elseif (time_left > 3) and (Ability.GetCooldown(sun_strike)>1) and not Invoker.HasInvoked(myHero, sun_strike) then
        Invoker.PressKey(myHero, "EEER");
    end

    -- 3. cast chaos meteor
    -- delay: 1.3, cast point: 0.05, affect radius: 275, meteors speed: 300
    if time_left < 1.6 then
        local dir = (Entity.GetAbsOrigin(myHero) - enemy_pos):Normalized()
        local land_pos = enemy_pos + dir:Scaled(100);
        if (time_left > 1.35) then
            land_pos = land_pos + dir:Scaled(300 * (time_left - 1.35));
        end;
        local travel_distance = 315 + 150 * Ability.GetLevel(NPC.GetAbility(myHero, "invoker_wex"))
        if (land_pos - enemy_pos):Length2D() <= travel_distance and Invoker.CastChaosMeteor(myHero, land_pos) then 
			Log.Write("TornadoCombo CastChaosMeteor");
			--return true 
        end
    elseif (Ability.GetCooldown(sun_strike)>0) and not Invoker.HasInvoked(myHero, meteor) then
        Invoker.PressKey(myHero, "WEER");
    end;
    -- 4. cast EMP
    -- delay: 2.9, cast point: 0.05, radius: 675, window: 675/400 = 1.6875
    if (time_left > (2.95 - 1.6875)) and (time_left < 2.95) 
        and Invoker.CastEMP(myHero, enemy_pos) 
        then 
			Log.Write("TornadoCombo CastEMP");
			--return true 
		end


    -- -- 5. cast ice wall again
    --if Invoker.CastIceWall(myHero, enemy) then return true end

    return false
end

-- combo: chaos meteor -> deafening blast
function Invoker.MeteorBlastCombo(myHero, enemy)
    if not myHero or not enemy then return false end
    if not IsSuitableToCastSpell(myHero) then return false end
    if hasInMagicImmune(enemy) then return false end

    -- check nearby enemy who is affected by chaos meteor
    --if not NPC.HasModifier(enemy, "modifier_invoker_chaos_meteor_burn") then return false end
    local meteor = NPC.GetAbility(myHero, "invoker_chaos_meteor");
    local lastUseMeteor = Ability.SecondsSinceLastUse(meteor);
    if lastUseMeteor>0 and lastUseMeteor<1 then 
        local blast = NPC.GetAbility(myHero, "invoker_deafening_blast")
        if not Invoker.HasInvoked(myHero, blast) then
            Invoker.PressKey(myHero, "QWER")
        end;
        return false 
    end
    if lastUseMeteor<1 or lastUseMeteor>2.1 then return false end

    if Invoker.CastDeafeningBlast(myHero, Entity.GetAbsOrigin(enemy)) then 
			Log.Write("MeteorBlastCombo "..lastUseMeteor);
			return true 
		end
		
    return false
end

-- cast cold snap on enemy who is affected by DoT
function Invoker.DoTCombo(myHero, enemy)
    if not myHero or not enemy then return false end
    if not IsSuitableToCastSpell(myHero) then return false end
    if hasInMagicImmune(enemy) then return false end

    --if not Utility.IsAffectedByDoT(enemy) then return false end

    -- avoid confliction with chaos meteors combo
    if NPC.HasModifier(enemy, "modifier_invoker_chaos_meteor_burn") then
        local meteor = NPC.GetAbility(myHero, "invoker_chaos_meteor")
        if meteor and Ability.IsCastable(meteor, NPC.GetMana(myHero)) then return false end
    end

    if 
    --Log.Write("DoTCombo try CastColdSnap") or 
    Invoker.CastColdSnap(myHero, enemy) then Log.Write("DoTCombo CastColdSnap"); return true end

    return false
end

-- If someone is affected by cold snap, then cast EMP.
function Invoker.ColdSnapCombo(myHero, enemy)
    -- if not myHero or not enemy then return false end
    -- if not IsSuitableToCastSpell(myHero) then return false end
    -- if hasInMagicImmune(enemy) then return false end
    --
    -- local mod = NPC.GetModifier(enemy, "modifier_invoker_cold_snap")
    -- if not mod then return false end
    -- local time_left = math.max(Modifier.GetDieTime(mod) - GameRules.GetGameTime(), 0)
    -- local time_used = math.max(GameRules.GetGameTime() - Modifier.GetCreationTime(mod), 0)
    --
    -- -- EMP, delay: 2.9, radius: 675
    -- local delay = 2.95
    -- local escape_time = 675 / 400
    -- if time_left + 675/400 < delay or time_used < 0.5 then return false end
    --
    -- local pos = GetPredictedPosition(enemy, 0.5)
    -- if Invoker.CastEMP(myHero, pos) then return true end

    return false
end

-- auto cast deafening blast, tornado or sun strike to predicted position for kill steal
function Invoker.KillSteal(myHero, enemy)
    if not myHero or not enemy then return false end
    if not IsSuitableToCastSpell(myHero) then return false end
    if hasInMagicImmune(enemy) then return false end

    local Q = NPC.GetAbility(myHero, "invoker_quas")
    local W = NPC.GetAbility(myHero, "invoker_wex")
    local E = NPC.GetAbility(myHero, "invoker_exort")
    if not Q or not W or not E then return false end

    local Q_level = Ability.GetLevel(Q)
    local W_level = Ability.GetLevel(W)
    local E_level = Ability.GetLevel(E)

    if NPC.HasItem(myHero, "item_ultimate_scepter", true) then
        Q_level = Q_level + 1
        W_level = W_level + 1
        E_level = E_level + 1
    end

    local damage_tornado = 45 * W_level
    local damage_deafening_blast = 40 * E_level
    local damage_sun_strike = 100 + 62.5 * (E_level - 1)

    local enemyHp = Entity.GetHealth(enemy)
    local dis = (Entity.GetAbsOrigin(myHero) - Entity.GetAbsOrigin(enemy)):Length()
    local multiplier = NPC.GetMagicalArmorDamageMultiplier(enemy)

    -- cast tornado to KS
    if enemyHp <= damage_tornado * multiplier then
        local speed = 1000
        local delay = dis / (speed + 1)
        local pos = GetPredictedPosition(enemy, delay)
        if Invoker.CastTornado(myHero, pos) then Log.Write("KillSteal CastTornado"); return true end
    end

    -- cast deafening blast to KS
    if enemyHp <= damage_deafening_blast * multiplier then
        local speed = 1100
        local delay = dis / (speed + 1)
        local pos = GetPredictedPosition(enemy, delay)
        if Invoker.CastDeafeningBlast(myHero, pos) then Log.Write("KillSteal CastDeafeningBlast"); return true end
    end

    -- cast sun strike to KS
    --[[
    if enemyHp <= damage_sun_strike then
        local delay = 1.7 -- sun strike has 1.7s delay
        local pos = GetPredictedPosition(enemy, delay)
        if Invoker.CastSunStrike(myHero, pos) then Log.Write("KillSteal CastSunStrike"); return true end
    end
    ]]
    return false
end

-- according to info given by particle effects
-- cast sun strike when enemy is (1) tping; (2) farming neutral creep; (3) roshing
-- interrupt enemy's tp by tornado
-- function Invoker.MapHack(pos, particleName)
--     
--     if not myHero or NPC.GetUnitName(myHero) ~= "npc_dota_hero_invoker" then return end
--     if not IsSuitableToCastSpell(myHero) then return end
--
--     -- have to make sure these particles are not from teammate
--     if not pos or Map.IsAlly(myHero, pos) then return end
--
--     -- tp effects
--     if particleName == "teleport_start" then
--         -- interrupt tp with tornado
--         if Invoker.CastTornado(myHero, pos) then return end
--         -- sun strike on tping enemy. dont sun strike if enemy is tping in fountain (that would be so obvious)
--         if not Map.InFountain(pos) and Invoker.CastSunStrike(myHero, pos) then return end
--     end
--
--     -- -- sun strike when enemy is farming neutral camp
--     -- if Map.InNeutralCamp(pos) then
--     --     if Invoker.CastSunStrike(myHero, pos) then return end
--     -- end
--
--     -- sun strike when enemy is roshing
--     if Map.InRoshan(pos) then
--         if Invoker.CastSunStrike(myHero, pos) then return end
--     end
-- end

-- Auto interrupt enemy's tp or channelling spell with tornado or cold snap
function Invoker.Interrupt(myHero, enemy)
    if not myHero or not enemy then return false end
    if not IsSuitableToCastSpell(myHero) then return false end
    if hasInMagicImmune(enemy) then return false end

    if NPC.IsChannellingAbility(enemy) then
        -- cast cold snap to interrupt
        if 
        --Log.Write("Interrupt try CastColdSnap") or 
        Invoker.CastColdSnap(myHero, enemy) then Log.Write("Interrupt CastColdSnap"); return true end

        -- cast tornado to interrupt
        if Invoker.CastTornado(myHero, Entity.GetAbsOrigin(enemy)) then Log.Write("Interrupt CastTornado"); return true end
    end

    if NPC.HasModifier(enemy, "modifier_teleporting") then
        -- cast cold snap to interrupt
        if 
        --Log.Write("Interrupt try CastColdSnap") or 
        Invoker.CastColdSnap(myHero, enemy) then Log.Write("Interrupt CastColdSnap"); return true end

        -- Using tornado to cancel TP has been moved to MapHack() part
    end

    -- -- cast sun strike as follow up
    -- if Invoker.CastSunStrike(myHero, Entity.GetAbsOrigin(enemy)) then return true end

    -- -- cast chaos meteor as follow up
    -- if Invoker.CastChaosMeteor(myHero, Entity.GetAbsOrigin(enemy)) then return true end

    -- -- cast EMP as follow up
    -- if Invoker.CastEMP(myHero, Entity.GetAbsOrigin(enemy)) then return true end

    return false
end

-- Auto cast sun strike, chaos meteor, EMP on fixed enemies (rooted, stunned, taunted, or slept).
function Invoker.FixedPositionCombo(myHero, enemy)
    if not myHero or not enemy then return false end
    if not IsSuitableToCastSpell(myHero) then return false end
    if hasInMagicImmune(enemy) then  return false end

    -- disable this combo if level is too low
    if NPC.GetCurrentLevel(myHero) <= 2 then return false end

    local time_left = Utility.GetFixTimeLeft(enemy)
    if time_left <= 0 then return false end

	Log.Write("FixedPositionCombo");
		
    -- cast chaos meteor on fixed enemies
    -- delay: 1.3, cast point: 0.05, affect radius: 275, meteors speed: 300
    local delay = 1.35
    local range = 700
    local travel_distance = 0
    if NPC.HasAbility(myHero, "invoker_wex") then
        travel_distance = 315 + 150 * Ability.GetLevel(NPC.GetAbility(myHero, "invoker_wex"))
    end
    if NPC.IsEntityInRange(myHero, enemy, range) then
        local land_pos = Entity.GetAbsOrigin(enemy)
        if time_left > delay and Invoker.CastChaosMeteor(myHero, land_pos) then Log.Write("FixedPositionCombo CastChaosMeteor"); return true end
    elseif NPC.IsEntityInRange(myHero, enemy, range + travel_distance) then
        local diff_vec = Entity.GetAbsOrigin(enemy) - Entity.GetAbsOrigin(myHero)
        local land_pos = Entity.GetAbsOrigin(myHero) + diff_vec:Normalized():Scaled(range)
        local traval_time = (diff_vec:Length2D() - range) / 300
        if (time_left > delay + traval_time) and Invoker.CastChaosMeteor(myHero, land_pos) then Log.Write("FixedPositionCombo CastChaosMeteor"); return true end
    end

    -- cast EMP on fixed enemies
    -- delay: 2.9, cast point: 0.05, range: 950, affect radius: 675
    local range = 950
    local radius = 675
    local delay = 2.95
    if NPC.IsEntityInRange(myHero, enemy, range) then
        local land_pos = Entity.GetAbsOrigin(enemy)
        if (time_left + radius/400 > delay) and Invoker.CastEMP(myHero, land_pos) then Log.Write("FixedPositionCombo CastEMP"); return true end
    elseif NPC.IsEntityInRange(myHero, enemy, range + radius) then
        local diff_vec = Entity.GetAbsOrigin(enemy) - Entity.GetAbsOrigin(myHero)
        local land_pos = Entity.GetAbsOrigin(myHero) + diff_vec:Normalized():Scaled(range)
        if time_left > delay and Invoker.CastEMP(myHero, land_pos) then Log.Write("FixedPositionCombo CastEMP"); return true end
    end

    -- cast sun strike on fixed enemies
    local delay = 1.75
    local radius = 225-- 175
    local pos = Entity.GetAbsOrigin(enemy)
    if (time_left + radius/400 > delay) and Invoker.CastSunStrike(myHero, pos) then Log.Write("FixedPositionCombo CastSunStrike"); return true end

    return false
end

-- Auto cast cold snap to break linken sphere.
function Invoker.LinkenBreaker(myHero, enemy)
    if not myHero or not enemy then return false end
    if not IsSuitableToCastSpell(myHero) then return false end
    if hasInMagicImmune(enemy) then return false end

    if NPC.IsLinkensProtected(enemy) and 
    --not Log.Write("LinkenBreaker try CastColdSnap") and 
    Invoker.CastColdSnap(myHero, enemy) then Log.Write("LinkenBreaker CastColdSnap");  return true end

    return false
end

-- Auto cast sun strike, chaos meteor, EMP on slowed enemies.
function Invoker.SlowedCombo(myHero, enemy)
    if not myHero or not enemy then return false end
    if not IsSuitableToCastSpell(myHero) then return false end
    if hasInMagicImmune(enemy) then return false end

    -- disable this combo if level is too low
    if NPC.GetCurrentLevel(myHero) <= 2 then return false end

    -- NPC.GetMoveSpeed() fails to consider (1) hex (2) ice wall
    local speedThreshold = 265
    if NPC.GetMoveSpeed(enemy) > speedThreshold then return false end

	Log.Write("SlowedCombo");
		
    -- sun strike, delay: 1.7
    local pos = GetPredictedPosition(enemy, 1.75)
    if Invoker.CastSunStrike(myHero, pos) then Log.Write("SlowedCombo CastSunStrike"); return true end

    -- chaos meteor, delay: 1.3
    local pos = GetPredictedPosition(enemy, 1.35)
    if Invoker.CastChaosMeteor(myHero, pos) then Log.Write("SlowedCombo CastChaosMeteor");  return true end

    -- EMP, delay: 2.9
    local pos = GetPredictedPosition(enemy, 2.95)
    if Invoker.CastEMP(myHero, pos) then Log.Write("SlowedCombo CastEMP");  return true end

    return false
end

-- define defensive actions
-- priority: tornado -> blast -> cold snap -> ghost walk
function Invoker.Defend(myHero, enemy)
    if not myHero or not enemy then return end
    if not IsSuitableToCastSpell(myHero) then return end
    if IsDisabled(enemy) then return end

    -- 1. use tornado to defend if available
    if NPC.IsEntityInRange(myHero, enemy, 350)
    and not hasInMagicImmune(enemy)
    and Invoker.CastTornado(myHero, Entity.GetAbsOrigin(enemy)) then Log.Write("Defend CastTornado"); return end

    -- 2. use deafening blast to defend if available
    if NPC.IsEntityInRange(myHero, enemy, 200)
    and not hasInMagicImmune(enemy)
    and Invoker.CastDeafeningBlast(myHero, Entity.GetAbsOrigin(enemy)) then Log.Write("Defend CastDeafeningBlast"); return end

    -- 3. use cold snap to defend if available
    if NPC.IsEntityInRange(myHero, enemy, 350)
    and not Log.Write("Defend CastColdSnap") 
    and Invoker.CastColdSnap(myHero, enemy) then Log.Write("Defend CastColdSnap");return end

    -- 4. use ghost walk to escape
    if (not hasInMagicImmune(enemy) or NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE))
    and NPC.IsEntityInRange(myHero, enemy, 200)
    and Invoker.CastGhostWalk(myHero) then Log.Write("Defend CastGhostWalk"); return end

    -- -- 5. use EMP to defend if available
    -- local mid = (Entity.GetAbsOrigin(myHero) + Entity.GetAbsOrigin(enemy)):Scaled(0.5)
    -- if Invoker.CastEMP(myHero, mid) then return end
end

-- return true if successfully cast, false otherwise
function Invoker.CastTornado(myHero, pos)
    if not myHero or not pos then return false end
    if not IsSuitableToCastSpell(myHero) then return false end

    local invoke = NPC.GetAbility(myHero, "invoker_invoke")
    if not invoke then return false end

    local tornado = NPC.GetAbility(myHero, "invoker_tornado")
    if not tornado or not Ability.IsCastable(tornado, NPC.GetMana(myHero)-Ability.GetManaCost(invoke)) then return false end

    local W = NPC.GetAbility(myHero, "invoker_wex")
    if not W or not Ability.IsCastable(W, 0) then return false end

    local level = Ability.GetLevel(W)
    local range = 2000
    local travel_distance = 800 + 400 * (level - 1)

    local dir = pos - Entity.GetAbsOrigin(myHero)
    local dis = dir:Length()

    if dis > travel_distance then return false end
    if dis > range then pos = Entity.GetAbsOrigin(myHero) + dir:Scaled(range/dis) end

    --Log.Write("try CastTornado"); 

    if (Invoker.HasInvoked(myHero, tornado) or Invoker.PressKey(myHero, "QWWR"))
    and Invoker.ProtectSpell(myHero, tornado) then
        Log.Write("CastTornado"); 
        Ability.CastPosition(tornado, pos)
        return true
    end

    return false
end

-- return true if successfully cast, false otherwise
function Invoker.CastDeafeningBlast(myHero, pos)
    if not myHero or not pos then return false end
    if not IsSuitableToCastSpell(myHero) then return false end

    local invoke = NPC.GetAbility(myHero, "invoker_invoke")
    if not invoke then return false end

    local blast = NPC.GetAbility(myHero, "invoker_deafening_blast")
    if not blast or not Ability.IsCastable(blast, NPC.GetMana(myHero)-Ability.GetManaCost(invoke)) then return false end

    local range = 1000
    local dis = (Entity.GetAbsOrigin(myHero) - pos):Length()
    if dis > range then return false end

    --Log.Write("try CastDeafeningBlast"); 

    if (Invoker.HasInvoked(myHero, blast) or Invoker.PressKey(myHero, "QWER"))
    and Invoker.ProtectSpell(myHero, blast) then
        Log.Write("CastDeafeningBlast"); 
        Ability.CastPosition(blast, pos)
        return true
    end

    return false
end

-- return true if successfully cast, false otherwise
function Invoker.CastColdSnap(myHero, target)
    if not myHero or not target then return false end
    if not IsSuitableToCastSpell(myHero) then return false end
	if not isCanAttackTarget(target) then return false end
    if hasInMagicImmune(target) then return false end

    local invoke = NPC.GetAbility(myHero, "invoker_invoke")
    if not invoke then return false end

    local cold_snap = NPC.GetAbility(myHero, "invoker_cold_snap")
    if not cold_snap or not Ability.IsCastable(cold_snap, NPC.GetMana(myHero)-Ability.GetManaCost(invoke)) then return false end

    local range = 1000
    local dis = (Entity.GetAbsOrigin(myHero) - Entity.GetAbsOrigin(target)):Length()
    if dis > range then return false end
		
	--Log.Write("try CastColdSnap");
		
    if (Invoker.HasInvoked(myHero, cold_snap) or Invoker.PressKey(myHero, "QQQR"))
    and Invoker.ProtectSpell(myHero, cold_snap) then
        Log.Write("CastColdSnap");
        Ability.CastTarget(cold_snap, target)
        return true
    end

    return false
end

-- return true if successfully cast, false otherwise
function Invoker.CastEMP(myHero, pos)
    if not myHero or not pos then return false end
    if not IsSuitableToCastSpell(myHero) then return false end

    local invoke = NPC.GetAbility(myHero, "invoker_invoke")
    if not invoke then return false end

    local emp = NPC.GetAbility(myHero, "invoker_emp")
    if not emp or not Ability.IsCastable(emp, NPC.GetMana(myHero)-Ability.GetManaCost(invoke)) then return false end

    local range = 950
    local dis = (Entity.GetAbsOrigin(myHero) - pos):Length()
    if dis > range then return false end

	--Log.Write("try CastEMP");
		
    if (Invoker.HasInvoked(myHero, emp) or Invoker.PressKey(myHero, "WWWR"))
    and Invoker.ProtectSpell(myHero, emp) then
        Log.Write("CastEMP");
        Ability.CastPosition(emp, pos)
        return true
    end

    return false
end

-- return true if successfully cast, false otherwise
function Invoker.CastAlacrity(myHero, target)
    if not myHero or not target then return false end
    if not IsSuitableToCastSpell(myHero) then return false end
    if not Entity.IsSameTeam(myHero, target) then return false end
    --if hasInMagicImmune(target) then return false end

    local invoke = NPC.GetAbility(myHero, "invoker_invoke")
    if not invoke then return false end

    local alacrity = NPC.GetAbility(myHero, "invoker_alacrity")
    if not alacrity or not Ability.IsCastable(alacrity, NPC.GetMana(myHero) - Ability.GetManaCost(invoke)) then return false end

	--Log.Write("try CastAlacrity");
		
    if (Invoker.HasInvoked(myHero, alacrity) or Invoker.PressKey(myHero, "WWER"))
    and Invoker.ProtectSpell(myHero, alacrity) then
        Log.Write("CastAlacrity");
        Ability.CastTarget(alacrity, myHero)
        return true
    end

    return false
end

-- return true if successfully cast, false otherwise
function Invoker.CastForgeSpirit(myHero)
    if not myHero then return false end
    if not IsSuitableToCastSpell(myHero) then return false end

    local invoke = NPC.GetAbility(myHero, "invoker_invoke")
    if not invoke then return false end

    local forge_spirit = NPC.GetAbility(myHero, "invoker_forge_spirit")
    if not forge_spirit or not Ability.IsCastable(forge_spirit, NPC.GetMana(myHero) - Ability.GetManaCost(invoke)) then return false end

	--Log.Write("try CastForgeSpirit");

    if (Invoker.HasInvoked(myHero, forge_spirit) or Invoker.PressKey(myHero, "QEER"))
    and Invoker.ProtectSpell(myHero, forge_spirit) then
        Log.Write("CastForgeSpirit");
        Ability.CastNoTarget(forge_spirit)
        return true
    end

    return false
end

-- return true if successfully cast, false otherwise
function Invoker.CastSunStrike(myHero, pos)
    if not myHero or not pos then return false end
    if not IsSuitableToCastSpell(myHero) then return false end

    local invoke = NPC.GetAbility(myHero, "invoker_invoke")
    if not invoke then return false end

    local sun_strike = NPC.GetAbility(myHero, "invoker_sun_strike")
    if not sun_strike or not Ability.IsCastable(sun_strike, NPC.GetMana(myHero) - Ability.GetManaCost(invoke)) then return false end

    -- dont cast sun strike if there are more than one enemy around the position
    local radius = 175
    local enemies = NPCs.InRadius(pos, radius, Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY)
    if enemies and #enemies >= 2 then return false end

	--Log.Write("try CastSunStrike");
		
    if (Invoker.HasInvoked(myHero, sun_strike) or Invoker.PressKey(myHero, "EEER"))
    and Invoker.ProtectSpell(myHero, sun_strike) then
        Log.Write("CastSunStrike");
        Ability.CastPosition(sun_strike, pos)
       
        return true
    end

    return false
end

-- return true if successfully cast, false otherwise
function Invoker.CastChaosMeteor(myHero, pos)
    if not myHero then return false end
    if not IsSuitableToCastSpell(myHero) then return false end

    local invoke = NPC.GetAbility(myHero, "invoker_invoke")
    if not invoke then return false end

    local meteor = NPC.GetAbility(myHero, "invoker_chaos_meteor")
    if not meteor or not Ability.IsCastable(meteor, NPC.GetMana(myHero) - Ability.GetManaCost(invoke)) then return false end

    local cast_range = Ability.GetCastRange(meteor)
    if (pos - Entity.GetAbsOrigin(myHero)):Length2D() > cast_range then return false end

	--Log.Write("try CastChaosMeteor");
		
    if (Invoker.HasInvoked(myHero, meteor) or Invoker.PressKey(myHero, "WEER"))
    and Invoker.ProtectSpell(myHero, meteor) then
        Log.Write("CastChaosMeteor");
        Ability.CastPosition(meteor, pos)
        return true
    end

    return false
end

-- return true if successfully cast, false otherwise
function Invoker.CastGhostWalk(myHero)
    if not myHero then return false end
    if not IsSuitableToCastSpell(myHero) then return false end

    local invoke = NPC.GetAbility(myHero, "invoker_invoke")
    if not invoke then return false end

    local ghost_walk = NPC.GetAbility(myHero, "invoker_ghost_walk")
    if not ghost_walk or not Ability.IsCastable(ghost_walk, NPC.GetMana(myHero) - Ability.GetManaCost(invoke)) then return false end

	--Log.Write("try CastGhostWalk");
		
    if (Invoker.HasInvoked(myHero, ghost_walk) or Invoker.PressKey(myHero, "QQWR"))
    and Invoker.ProtectSpell(myHero, ghost_walk) then
        local ratio = 0.8
        if Entity.GetHealth(myHero) >= ratio * Entity.GetMaxHealth(myHero) then
            Invoker.PressKey(myHero, "WWW")
        else
            Invoker.PressKey(myHero, "QQQ")
        end
        Log.Write("CastGhostWalk");
        Ability.CastNoTarget(ghost_walk)
        return true
    end

    return false
end

-- return true if successfully cast, false otherwise
function Invoker.CastIceWall(myHero, enemy)
    if not myHero then return false end
    if not IsSuitableToCastSpell(myHero) then return false end
    -- if Entity.IsTurning(myHero) then return false end

    if hasInMagicImmune(enemy)
    and not NPC.HasModifier(enemy, "modifier_invoker_tornado")
    and not NPC.HasModifier(enemy, "modifier_eul_cyclone")
    and not NPC.HasModifier(enemy, "modifier_brewmaster_storm_cyclone")
    then return false end

    local invoke = NPC.GetAbility(myHero, "invoker_invoke")
    if not invoke then return false end

    local ice_wall = NPC.GetAbility(myHero, "invoker_ice_wall")
    if not ice_wall or not Ability.IsCastable(ice_wall, NPC.GetMana(myHero) - Ability.GetManaCost(invoke)) then return false end
    if Ability.GetLevel(NPC.GetAbility(myHero, "invoker_quas")) < 2 then return false end

    local distance = 200
    local dir = Entity.GetAbsRotation(myHero):GetForward():Normalized()
    local mid_point = Entity.GetAbsOrigin(myHero) + dir:Scaled(distance)
    local vec = Entity.GetAbsOrigin(enemy) - mid_point
    local w_sqrt = dir:Dot2D(vec) * dir:Dot2D(vec)
    local l_sqrt = vec:Length2DSqr() - w_sqrt

    -- wall_length: 1120, wall_width: 105
    if w_sqrt > 55 * 55 or l_sqrt > 560 * 560 then return false end

	--Log.Write("try CastIceWall");
		
    if (Invoker.HasInvoked(myHero, ice_wall) or Invoker.PressKey(myHero, "QQER"))
    and Invoker.ProtectSpell(myHero, ice_wall) then
        Log.Write("CastIceWall");
        Ability.CastNoTarget(ice_wall)
        return true
    end

    return false
end

-- return current instances ("QWE", "QQQ", "EEE", etc)
function Invoker.GetInstances(myHero)
    local modTable = NPC.GetModifiers(myHero)
    local Q_num, W_num, E_num = 0, 0, 0

    for i, mod in ipairs(modTable) do
        if Modifier.GetName(mod) == "modifier_invoker_quas_instance" then
            Q_num = Q_num + 1
        elseif Modifier.GetName(mod) == "modifier_invoker_wex_instance" then
            W_num = W_num + 1
        elseif Modifier.GetName(mod) == "modifier_invoker_exort_instance" then
            E_num = E_num + 1
        end
    end

    local QWE_text = ""
    while Q_num > 0 do QWE_text = QWE_text .. "Q"; Q_num = Q_num - 1 end
    while W_num > 0 do QWE_text = QWE_text .. "W"; W_num = W_num - 1 end
    while E_num > 0 do QWE_text = QWE_text .. "E"; E_num = E_num - 1 end

    return QWE_text
end

-- return whether a spell has been invoked.
function Invoker.HasInvoked(myHero, spell)
    if not myHero or not spell then return false end

    --local name = Ability.GetName(spell)
    local spell_1 = NPC.GetAbilityByIndex(myHero, 3)
    local spell_2 = NPC.GetAbilityByIndex(myHero, 4)

    if spell_2 and spell_2 == spell--name == Ability.GetName(spell_2) 
    then return true end
    if spell_1 and spell_1 == spell--name == Ability.GetName(spell_1) 
    then return true end

    return false
end

-- After casting a spell , move this spell to second slot
-- so as to protect another spell
function Invoker.ProtectSpell(myHero, spell)
	-- temporarily disable spell protection due to performance issues
	return Ability.IsReady(spell);
	--[[
	if true then return true end

	if not myHero or not spell then return false end
	if not IsSuitableToCastSpell(myHero) then return false end
	if not Invoker.HasInvoked(myHero, spell) then return false end

	local spell_1 = NPC.GetAbilityByIndex(myHero, 3)
	local spell_2 = NPC.GetAbilityByIndex(myHero, 4)
	if not spell_1 or not spell_2 then return false end
	if not Ability.IsCastable(spell_2, NPC.GetMana(myHero)) then return false end
	if Ability.GetName(spell) == Ability.GetName(spell_2) then return false end

	local name = Ability.GetName(spell_2)

	if name == "invoker_cold_snap" then Invoker.PressKey(myHero, "QQQR"); return true end
	if name == "invoker_ghost_walk" then Invoker.PressKey(myHero, "QQWR"); return true end
	if name == "invoker_tornado" then Invoker.PressKey(myHero, "QWWR"); return true end
	if name == "invoker_emp" then Invoker.PressKey(myHero, "WWWR"); return true end
	if name == "invoker_alacrity" then Invoker.PressKey(myHero, "WWER"); return true end
	if name == "invoker_chaos_meteor" then Invoker.PressKey(myHero, "WEER"); return true end
	if name == "invoker_sun_strike" then Invoker.PressKey(myHero, "EEER"); return true end
	if name == "invoker_forge_spirit" then Invoker.PressKey(myHero, "QEER"); return true end
	if name == "invoker_ice_wall" then Invoker.PressKey(myHero, "QQER"); return true end
	if name == "invoker_deafening_blast" then Invoker.PressKey(myHero, "QWER"); return true end

	return false]]
end

-- return true if all ordered keys have been pressed successfully
-- return false otherwise
function Invoker.PressKey(myHero, keys)
    if not myHero or not keys then return false end
    if not IsSuitableToCastSpell(myHero) then return false end
    if Invoker.GetInstances(myHero) == keys then return true end
    if GameRules.GetGameTime() - timer <= gap then return false end

    local Q = NPC.GetAbility(myHero, "invoker_quas")
    local W = NPC.GetAbility(myHero, "invoker_wex")
    local E = NPC.GetAbility(myHero, "invoker_exort")
    local R = NPC.GetAbility(myHero, "invoker_invoke")

    for i = 1, #keys do
        local key = keys:sub(i,i)
        if key == "Q" and (not Q or not Ability.IsCastable(Q, 0)) then return false end
        if key == "W" and (not W or not Ability.IsCastable(W, 0)) then return false end
        if key == "E" and (not E or not Ability.IsCastable(E, 0)) then return false end
        if key == "R" and (not R or not Ability.IsCastable(R, NPC.GetMana(myHero))) then return false end
    end

    for i = 1, #keys do
        local key = keys:sub(i,i)
        if key == "Q" then Ability.CastNoTarget(Q) end
        if key == "W" then Ability.CastNoTarget(W) end
        if key == "E" then Ability.CastNoTarget(E) end
        if key == "R" then Ability.CastNoTarget(R) end
    end

    timer = GameRules.GetGameTime()
    return true
end

Invoker.Initialization();

return Invoker
