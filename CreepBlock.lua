--[[
30.05.2018 - 31.05.2018 
04.06.2018 rework, optimize, add draw option (debug)
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
]]

Blocker = {};
Blocker.inited = false;

local creep_melee_collision_size = 16;
local creep_ranged_collision_size =  8;

local hero_collision_size = 24;
local SearchRadius = 500;

Blocker.Menu = {};
Blocker.Menu.Path = {"Utility", "Creep Block"};
Blocker.Menu.Key = Menu.AddKeyOption(Blocker.Menu.Path, "Enable key", Enum.ButtonCode.KEY_SPACE);

-- enemyHeroBlock = Menu.AddOption({ "Utility", "[Bot] HeroBlock" }, "Enabled", "Block enemy hero with summoned units.")
Blocker.Menu.SkipRangedCreep = Menu.AddOptionBool(Blocker.Menu.Path, "Skip ranged creep", false); --"Bot will try to skip ranged creep."
Blocker.Menu.ShowDebugMove = Menu.AddOptionBool(Blocker.Menu.Path, "Show Debug Move", false);

local font = Renderer.LoadFont("Tahoma", 20, Enum.FontWeight.EXTRABOLD);

local DOTA_TEAM_BADGUYS = 3;

-- local npc_to_ignore = {}
local top_towers = {};
local mid_towers = {};
local bottom_towers = {};
local my_team = nil;

Blocker.LastStop = 0;
Blocker.Sleep = 0;
Blocker.LessStopping = false;

Blocker.Fountain = nil;

Blocker.User = nil;
Blocker.Creeps = nil;

Blocker.FountainOrigin = 0;
local size_x, size_y = 0;


function Blocker.Init()
    Blocker.User = Heroes.GetLocal();
    if Blocker.User == nil then return end;
    if not Entity.IsAlive(Blocker.User) then return end;
    Blocker.inited = true;
end

function Blocker.OnMenuOptionChange(option, oldValue, newValue)
    if (option == Blocker.Menu.ShowDebugMove) and newValue then
        size_x, size_y = Renderer.GetScreenSize();
    end;
end;

function Blocker.OnUpdate()

    if not Engine.IsInGame() then Blocker.Reset() end;
    Blocker.Init();
    if not Blocker.inited then return end;

    if not Menu.IsKeyDown(Blocker.Menu.Key) then
        return false;
    end;

    if not Blocker.User then return end;
    if not Blocker.Fountain or Blocker.Fountain == nil then
        Blocker.getFountain(Blocker.User);
    end;
    
    Blocker.Creeps = Entity.GetUnitsInRadius(Blocker.User, SearchRadius, Enum.TeamType.TEAM_FRIEND);
    local origin = Entity.GetAbsOrigin(Blocker.User);

    local best_npc = nil;
    local best_position = nil;
    local best_distance = 99999;
    local best_angle = 0.0;

    local curtime = GameRules.GetGameTime();

    Blocker.FountainOrigin = Entity.GetAbsOrigin(Blocker.Fountain);

    for i, npc in ipairs(Blocker.Creeps) do
        if NPC.IsCreep(npc) and not Entity.IsDormant(npc) and Entity.IsAlive(npc) then
            local creep_origin = Entity.GetAbsOrigin(npc)

            local ranged = false;
            if Menu.IsEnabled(Blocker.Menu.SkipRangedCreep) and NPC.IsRanged(npc) then
                ranged = true;
            end;

            local moves_to = Blocker.GetPredictedPosition(npc, 0.66);

            if not NPC.IsRunning(npc) or ranged then
                -- do nothing here
            else
                local distance = (origin - creep_origin):Length();
                distance = distance - hero_collision_size;

                if distance <= best_distance then
                    best_npc = npc;
                    best_position = moves_to;
                    best_distance = distance;
                    best_angle = angle;
                end;
            end;
        end;
    end;

    if best_position then
        local pos_to_fountain_len = (best_position - Blocker.FountainOrigin):Length();
        -- local name = NPC.GetUnitName(best_npc)
        local collision_size = creep_melee_collision_size;

        if curtime > Blocker.Sleep then
            Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION, Blocker.User, best_position, nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_HERO_ONLY);
        end;
        local dist = (best_position - origin):Length();
        local speed = NPC.GetMoveSpeed(Blocker.User);
        -- if curtime > Blocker.LastStop and dist >= 15 * speed / 315 and dist <= 150 * speed / 315 then
        if curtime > Blocker.LastStop and dist >= 10 and dist <= 150 then
            Blocker.LastStop = curtime + 0.25 * 315 / speed;
            if Blocker.LessStopping then
                -- Blocker.LastStop = curtime + 0.9
            end
            -- if speed < 315 then
            --     Blocker.Sleep = curtime + 0.05
            -- else
            --     Blocker.Sleep = curtime + 0.07
            -- end
            Blocker.Sleep = curtime + 0.07 * 315 / speed;
            Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_STOP, Blocker.User, best_position, nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_HERO_ONLY);
        end
    end

    -- get my line and towers
    Blocker.LessStopping = false;
    local TOWER_WARNING = 350;
    for i, tower in pairs(top_towers) do
        local TowerOrigin = Entity.GetAbsOrigin(tower);
        if Entity.IsNPC(tower) and (origin - TowerOrigin):Length() <= TOWER_WARNING then
            Blocker.LessStopping = true;
        end;
    end;
    for i, tower in pairs(mid_towers) do
        local TowerOrigin = Entity.GetAbsOrigin(tower);
        if Entity.IsNPC(tower) and (origin - TowerOrigin):Length() <= TOWER_WARNING then
            Blocker.LessStopping = true;
        end;
    end;
    for i, tower in pairs(bottom_towers) do
        local TowerOrigin = Entity.GetAbsOrigin(tower);
        if Entity.IsNPC(tower) and (origin - TowerOrigin):Length() <= TOWER_WARNING then
            Blocker.LessStopping = true;
        end;
    end;
end;

function Blocker.OnDraw()

    if not Blocker.inited then return end;

    if not Menu.IsEnabled(Blocker.Menu.ShowDebugMove) or not Menu.IsKeyDown(Blocker.Menu.Key) then
        return false;
    end;

    local origin = Entity.GetAbsOrigin(Blocker.User);

    if Blocker.LessStopping then
        local hx, hy = Renderer.WorldToScreen(origin);
        Renderer.SetDrawColor(0, 255, 255, 150);
        Renderer.DrawText(font, hx, hy, 'LESS STOPPING (TOWER NEAR)', 1);
    end;

    for i, npc in ipairs(Blocker.Creeps) do
        if NPC.IsCreep(npc) and not Entity.IsDormant(npc) and Entity.IsAlive(npc) then
            local creep_origin = Entity.GetAbsOrigin(npc);

            local ranged = false;
            if Menu.IsEnabled(Blocker.Menu.SkipRangedCreep) and NPC.IsRanged(npc) then
                ranged = true;
            end;

            local x, y = Renderer.WorldToScreen(creep_origin);
            Blocker.DrawCircle(creep_origin, creep_melee_collision_size);

            local moves_to = Blocker.GetPredictedPosition(npc, 0.66);

            if not NPC.IsRunning(npc) or ranged then
                -- do nothing here
            else
                local x2, y2 = Renderer.WorldToScreen(moves_to);
                Renderer.DrawLine(x, y, x2, y2);
            end;
        end;
    end;
end;

-- return predicted position
function Blocker.GetPredictedPosition(npc, delay)
    local pos = Entity.GetAbsOrigin(npc);
    if not NPC.IsRunning(npc) or not delay then return pos end;
    local totalLatency = (NetChannel.GetAvgLatency(Enum.Flow.FLOW_INCOMING) + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)); -- * 2 -- this may fix bot is not stopping at high ping
    delay = delay + totalLatency;

    local dir = Entity.GetRotation(npc):GetForward():Normalized();
    local speed = Blocker.GetMoveSpeed(npc);

    return pos + dir:Scaled(speed * delay);
end;

function Blocker.GetMoveSpeed(npc)
    --local base_speed = NPC.GetBaseSpeed(npc);
    --local bonus_speed = NPC.GetMoveSpeed(npc) - NPC.GetBaseSpeed(npc);
    
    return  NPC.GetMoveSpeed(npc);--base_speed + bonus_speed;
end;

function Blocker.DrawCircle(UnitPos, radius)
    local x1, y1 = Renderer.WorldToScreen(UnitPos)
    if x1 < size_x and x1 > 0 and y1 < size_y and y1 > 0 then
        local x4, y4, x3, y3, visible3
        local dergee = 90
        for angle = 0, 360 / dergee do
            x4 = 0 * math.cos(angle * dergee / 57.3) - radius * math.sin(angle * dergee / 57.3)
            y4 = radius * math.cos(angle * dergee / 57.3) + 0 * math.sin(angle * dergee / 57.3)
            x3,y3 = Renderer.WorldToScreen(UnitPos + Vector(x4,y4,0))
            Renderer.DrawLine(x1,y1,x3,y3)
            x1,y1 = Renderer.WorldToScreen(UnitPos + Vector(x4,y4,0))
        end;
    end;
end;

function Blocker.Reset()
    Blocker.inited = false;
    Blocker.Fountain = nil;
    top_towers = {};
    mid_towers = {};
    bottom_towers = {};
end;

function Blocker.getFountain(Hero)

    local team = 'badguys';
    my_team = Entity.GetTeamNum(Hero)
    if my_team ~= DOTA_TEAM_BADGUYS then
        team = 'goodguys';
    end;

    for i = 1, NPCs.Count() do 
        local npc = NPCs.Get(i);
        if NPC.IsStructure(npc) then
            local name = NPC.GetUnitName(npc);
            if name ~= nil then

                if name == "dota_fountain" then
                    if Entity.IsSameTeam(Hero, npc) then
                        Blocker.Fountain = npc;
                    -- else
                    --     Blocker.EnemyFountain = npc
                    end;
                end;

                if name == "npc_dota_"..team.."_tower1_top" then
                    top_towers[1] = npc;
                end;
                if name == "npc_dota_"..team.."_tower2_top" then
                    top_towers[2] = npc;
                end;
                if name == "npc_dota_"..team.."_tower3_top" then
                    top_towers[3] = npc;
                end;

                if name == "npc_dota_"..team.."_tower1_mid" then
                    mid_towers[1] = npc;
                end;
                if name == "npc_dota_"..team.."_tower2_mid" then
                    mid_towers[2] = npc;
                end;
                if name == "npc_dota_"..team.."_tower3_mid" then
                    mid_towers[3] = npc;
                end;

                if name == "npc_dota_"..team.."_tower1_bot" then
                    bottom_towers[1] = npc;
                end;
                if name == "npc_dota_"..team.."_tower2_bot" then
                    bottom_towers[2] = npc;
                end;
                if name == "npc_dota_"..team.."_tower3_bot" then
                    bottom_towers[3] = npc;
                end;

            end;
        end;
    end;
end;
--]]
return Blocker