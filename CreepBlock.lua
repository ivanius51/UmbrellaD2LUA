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

CreepsBlocker = {};
CreepsBlocker.inited = false;

local creep_melee_collision_size = 16;
local creep_ranged_collision_size =  8;

local hero_collision_size = 24;
local SearchRadius = 500;

CreepsBlocker.Menu = {};
CreepsBlocker.Menu.Path = {"Utility", "Creep Block"};
CreepsBlocker.Menu.Key = Menu.AddKeyOption(CreepsBlocker.Menu.Path, "Enable key", Enum.ButtonCode.KEY_SPACE);

-- enemyHeroBlock = Menu.AddOption({ "Utility", "[Bot] HeroBlock" }, "Enabled", "Block enemy hero with summoned units.")
CreepsBlocker.Menu.SkipRangedCreep = Menu.AddOptionBool(CreepsBlocker.Menu.Path, "Skip ranged creep", false); --"Bot will try to skip ranged creep."
CreepsBlocker.Menu.PredictTime = Menu.AddOptionSlider(CreepsBlocker.Menu.Path, "Predict Time (Latency)", 10, 250, 66);
CreepsBlocker.Menu.ShowDebugMove = Menu.AddOptionBool(CreepsBlocker.Menu.Path, "Show Debug Move", false);

local font = Renderer.LoadFont("Tahoma", 20, Enum.FontWeight.EXTRABOLD);

local DOTA_TEAM_BADGUYS = 3;

-- local npc_to_ignore = {}
local top_towers = {};
local mid_towers = {};
local bottom_towers = {};
local my_team = nil;

CreepsBlocker.NextStop = 0;
CreepsBlocker.Sleep = 0;
CreepsBlocker.PredictTime = Menu.GetValue(CreepsBlocker.Menu.PredictTime) * 0.01;
CreepsBlocker.LessStopping = false;
CreepsBlocker.BestPosition = nil;
CreepsBlocker.Fountain = nil;

CreepsBlocker.User = nil;
CreepsBlocker.Creeps = nil;

CreepsBlocker.FountainOrigin = 0;
local size_x, size_y = 0;


function CreepsBlocker.Init()
    CreepsBlocker.User = Heroes.GetLocal();
    if CreepsBlocker.User == nil then return end;
    if not Entity.IsAlive(CreepsBlocker.User) then return end;
    CreepsBlocker.inited = true;
end

function CreepsBlocker.OnMenuOptionChange(option, oldValue, newValue)
    if (option == CreepsBlocker.Menu.ShowDebugMove) and newValue then
        size_x, size_y = Renderer.GetScreenSize();
    end;
    if (option == CreepsBlocker.Menu.PredictTime) then
        CreepsBlocker.PredictTime = newValue * 0.01;
    end;
end;

function CreepsBlocker.OnUpdate()

    if not Engine.IsInGame() then CreepsBlocker.Reset() end;
    CreepsBlocker.Init();
    if not CreepsBlocker.inited then return end;

    if not Menu.IsKeyDown(CreepsBlocker.Menu.Key) then
        return false;
    end;

    if not CreepsBlocker.User then return end;
    --if not CreepsBlocker.Fountain or CreepsBlocker.Fountain == nil then
    --    CreepsBlocker.getFountain(CreepsBlocker.User);
    --end;
    
    CreepsBlocker.Creeps = Entity.GetUnitsInRadius(CreepsBlocker.User, SearchRadius, Enum.TeamType.TEAM_FRIEND);
    if not CreepsBlocker.Creeps or (#CreepsBlocker.Creeps < 2) then
        return false;
    end;
    local origin = Entity.GetAbsOrigin(CreepsBlocker.User);

    --local best_npc = nil;
    CreepsBlocker.BestPosition = nil;
    local best_distance = 99999;
    --local best_angle = 0.0;

    local curtime = GameRules.GetGameTime();

    --CreepsBlocker.FountainOrigin = Entity.GetAbsOrigin(CreepsBlocker.Fountain);

    for i, npc in ipairs(CreepsBlocker.Creeps) do
        if NPC.IsCreep(npc) and not Entity.IsDormant(npc) and Entity.IsAlive(npc) then
            local creep_origin = Entity.GetAbsOrigin(npc)

            local ranged = false;
            if Menu.IsEnabled(CreepsBlocker.Menu.SkipRangedCreep) and NPC.IsRanged(npc) then
                ranged = true;
            end;

            local moves_to = CreepsBlocker.GetPredictedPosition(npc, CreepsBlocker.PredictTime);

            if not NPC.IsRunning(npc) or ranged then
                -- do nothing here
            else
                local distance = (origin - creep_origin):Length();
                distance = distance - hero_collision_size;

                if distance <= best_distance then
                    --best_npc = npc;
                    CreepsBlocker.BestPosition = moves_to;
                    best_distance = distance;
                    --best_angle = angle;
                end;
            end;
        end;
    end;

    if CreepsBlocker.BestPosition then
        --local pos_to_fountain_len = (CreepsBlocker.BestPosition - CreepsBlocker.FountainOrigin):Length();
        -- local name = NPC.GetUnitName(best_npc)
        local collision_size = creep_melee_collision_size;

        if curtime > CreepsBlocker.Sleep then
            Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION, CreepsBlocker.User, CreepsBlocker.BestPosition, nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_HERO_ONLY);
        end;
        local dist = (CreepsBlocker.BestPosition - origin):Length();
        local speed = NPC.GetMoveSpeed(CreepsBlocker.User);
        -- if curtime > CreepsBlocker.NextStop and dist >= 15 * speed / 315 and dist <= 150 * speed / 315 then
        if curtime > CreepsBlocker.NextStop and dist >= 10 and dist <= 150 then
            CreepsBlocker.NextStop = curtime + 79 / speed;--0.25 * 315 / speed;

            --if CreepsBlocker.LessStopping and (CreepsBlocker.OldBestCreep ~= CreepsBlocker.BestCreep) then
                --CreepsBlocker.NextStop = curtime + dist / speed + NPC.GetTimeToFacePosition(CreepsBlocker.User, CreepsBlocker.BestPosition) + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) + NetChannel.GetAvgLatency(Enum.Flow.FLOW_INCOMING);
                -- CreepsBlocker.NextStop = curtime + 0.9
            --end;
            -- if speed < 315 then
            --     CreepsBlocker.Sleep = curtime + 0.05
            -- else
            --     CreepsBlocker.Sleep = curtime + 0.07
            -- end
            CreepsBlocker.Sleep = curtime + 22 / speed;--0.07 * 315 / speed;
            Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_STOP, CreepsBlocker.User, CreepsBlocker.BestPosition, nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_HERO_ONLY);
        end
    end

    -- get my line and towers
    --[[
    CreepsBlocker.LessStopping = false;
    local TOWER_WARNING = 350;
    for i, tower in pairs(top_towers) do
        local TowerOrigin = Entity.GetAbsOrigin(tower);
        if Entity.IsNPC(tower) and (origin - TowerOrigin):Length() <= TOWER_WARNING then
            CreepsBlocker.LessStopping = true;
        end;
    end;
    for i, tower in pairs(mid_towers) do
        local TowerOrigin = Entity.GetAbsOrigin(tower);
        if Entity.IsNPC(tower) and (origin - TowerOrigin):Length() <= TOWER_WARNING then
            CreepsBlocker.LessStopping = true;
        end;
    end;
    for i, tower in pairs(bottom_towers) do
        local TowerOrigin = Entity.GetAbsOrigin(tower);
        if Entity.IsNPC(tower) and (origin - TowerOrigin):Length() <= TOWER_WARNING then
            CreepsBlocker.LessStopping = true;
        end;
    end;
    ]]
end;

function CreepsBlocker.OnDraw()

    if not CreepsBlocker.inited then return end;

    if not Menu.IsEnabled(CreepsBlocker.Menu.ShowDebugMove) or not Menu.IsKeyDown(CreepsBlocker.Menu.Key) then
        return false;
    end;

    local origin = Entity.GetAbsOrigin(CreepsBlocker.User);
    --[[
    if CreepsBlocker.LessStopping then
        local hx, hy = Renderer.WorldToScreen(origin);
        Renderer.SetDrawColor(0, 255, 255, 150);
        Renderer.DrawText(font, hx, hy, 'LESS STOPPING (TOWER NEAR)', 1);
    end;
    ]]

    if CreepsBlocker.BestPosition then
        local x, y = Renderer.WorldToScreen(origin);
        Renderer.SetDrawColor(255, 33, 33, 150);
        CreepsBlocker.DrawCircle(CreepsBlocker.BestPosition, CreepsBlocker.UserCollisionSize);
        CreepsBlocker.DrawCircle(origin, CreepsBlocker.UserCollisionSize);
        local x2, y2 = Renderer.WorldToScreen(CreepsBlocker.BestPosition);
        Renderer.DrawLine(x, y, x2, y2);
    end;

    if not CreepsBlocker.Creeps or (#CreepsBlocker.Creeps < 2) then
        return false;
    end;

    for i, npc in ipairs(CreepsBlocker.Creeps) do
        if NPC.IsCreep(npc) and not Entity.IsDormant(npc) and Entity.IsAlive(npc) then
            Renderer.SetDrawColor(33, 33, 33, 150);
            local creep_origin = Entity.GetAbsOrigin(npc);

            local ranged = false;
            if Menu.IsEnabled(CreepsBlocker.Menu.SkipRangedCreep) and NPC.IsRanged(npc) then
                ranged = true;
            end;

            local x, y = Renderer.WorldToScreen(creep_origin);
            CreepsBlocker.DrawCircle(creep_origin, creep_melee_collision_size);

            local moves_to = CreepsBlocker.GetPredictedPosition(npc, 0.66);

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
function CreepsBlocker.GetPredictedPosition(npc, delay)
    local pos = Entity.GetAbsOrigin(npc);
    if not NPC.IsRunning(npc) or not delay then return pos end;
    local totalLatency = (NetChannel.GetAvgLatency(Enum.Flow.FLOW_INCOMING) + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)); -- * 2 -- this may fix bot is not stopping at high ping
    delay = delay + totalLatency;

    local dir = Entity.GetRotation(npc):GetForward():Normalized();
    local speed = CreepsBlocker.GetMoveSpeed(npc);

    return pos + dir:Scaled(speed * delay);
end;

function CreepsBlocker.GetMoveSpeed(npc)
    --local base_speed = NPC.GetBaseSpeed(npc);
    --local bonus_speed = NPC.GetMoveSpeed(npc) - NPC.GetBaseSpeed(npc);
    
    return  NPC.GetMoveSpeed(npc);--base_speed + bonus_speed;
end;

function CreepsBlocker.DrawCircle(UnitPos, radius)
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

function CreepsBlocker.Reset()
    CreepsBlocker.inited = false;
    CreepsBlocker.Fountain = nil;
    top_towers = {};
    mid_towers = {};
    bottom_towers = {};
end;

function CreepsBlocker.getFountain(Hero)

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
                        CreepsBlocker.Fountain = npc;
                    -- else
                    --     CreepsBlocker.EnemyFountain = npc
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
return CreepsBlocker