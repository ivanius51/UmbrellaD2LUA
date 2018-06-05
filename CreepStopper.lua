--[[
30.05.2018 - 31.05.2018 
04.06.2018 rework, optimize, add draw option (debug)
05.06.2018 rewrite formulas
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

CreepsStopper = {};
CreepsStopper.inited = false;

local creep_melee_collision_size = 16;
local creep_ranged_collision_size =  8;

local hero_collision_size = 24;
local SearchRadius = 500;

CreepsStopper.Menu = {};
CreepsStopper.Menu.Path = {"Utility", "Creeps Block"};
CreepsStopper.Menu.Key = Menu.AddKeyOption(CreepsStopper.Menu.Path, "Enable key", Enum.ButtonCode.KEY_SPACE);

-- enemyHeroBlock = Menu.AddOption({ "Utility", "[Bot] HeroBlock" }, "Enabled", "Block enemy hero with summoned units.")
CreepsStopper.Menu.SkipRangedCreep = Menu.AddOptionBool(CreepsStopper.Menu.Path, "Skip ranged creep", false); --"Bot will try to skip ranged creep."
CreepsStopper.Menu.PredictTime = Menu.AddOptionSlider(CreepsStopper.Menu.Path, "Predict Time (Latency)", 10, 250, 45);
CreepsStopper.Menu.ShowDebugMove = Menu.AddOptionBool(CreepsStopper.Menu.Path, "Show Debug Move", false);

local font = Renderer.LoadFont("Tahoma", 20, Enum.FontWeight.EXTRABOLD);

local DOTA_TEAM_BADGUYS = 3;

-- local npc_to_ignore = {}

CreepsStopper.Towers = {};
CreepsStopper.Towers.Top = {};
CreepsStopper.Towers.Mid = {};
CreepsStopper.Towers.Bot = {};
CreepsStopper.Team = nil;
CreepsStopper.NextStop = 0;
CreepsStopper.Sleep = 0;
CreepsStopper.LessStopping = false;
CreepsStopper.Fountain = nil;
CreepsStopper.User = nil;
CreepsStopper.Creeps = nil;
CreepsStopper.FountainOrigin = 0;
CreepsStopper.PredictTime = Menu.GetValue(CreepsStopper.Menu.PredictTime) * 0.01;
CreepsStopper.BestPosition = nil;
CreepsStopper.BestCreep = nil;
CreepsStopper.OldBestCreep = nil;
local size_x, size_y = 0;
CreepsStopper.UserCollisionSize = hero_collision_size;

function CreepsStopper.Init()
    CreepsStopper.Towers = {};
    CreepsStopper.Towers.Top = {};
    CreepsStopper.Towers.Mid = {};
    CreepsStopper.Towers.Bot = {};
    CreepsStopper.Team = nil;
    CreepsStopper.NextStop = 0;
    CreepsStopper.Sleep = 0;
    CreepsStopper.LessStopping = false;
    CreepsStopper.Fountain = nil;
    CreepsStopper.User = nil;
    CreepsStopper.Creeps = nil;
    CreepsStopper.FountainOrigin = 0;
    local size_x, size_y = 0;

    CreepsStopper.User = Heroes.GetLocal();
    if CreepsStopper.User == nil then return end;
    if not Entity.IsAlive(CreepsStopper.User) then return end;

    CreepsStopper.UserCollisionSize = NPC.GetProjectileCollisionSize(CreepsStopper.User);

    CreepsStopper.inited = true;
    Log.Write("Creeps Stopper inited "..tostring(CreepsStopper.inited));
end;
CreepsStopper.Init();

function CreepsStopper.OnMenuOptionChange(option, oldValue, newValue)
    if (option == CreepsStopper.Menu.ShowDebugMove) and newValue then
        size_x, size_y = Renderer.GetScreenSize();
    end;
    if (option == CreepsStopper.Menu.PredictTime) then
        CreepsStopper.PredictTime = newValue * 0.01;
    end;
end;

function CreepsStopper.OnUpdate()

    if not Engine.IsInGame() then CreepsStopper.Reset() end;
    if not CreepsStopper.inited then return end;

    if not Menu.IsKeyDown(CreepsStopper.Menu.Key) then
        return false;
    end;

    if not CreepsStopper.User then return end;
    if not CreepsStopper.Fountain or CreepsStopper.Fountain == nil then
        CreepsStopper.getFountain(CreepsStopper.User);
    end;
    
    CreepsStopper.Creeps = Entity.GetUnitsInRadius(CreepsStopper.User, SearchRadius, Enum.TeamType.TEAM_FRIEND);
    if not CreepsBlocker.Creeps or (#CreepsBlocker.Creeps < 2) then
        return false;
    end;
    local origin = Entity.GetAbsOrigin(CreepsStopper.User);
    local speed = NPC.GetMoveSpeed(CreepsStopper.User);

    CreepsStopper.OldBestCreep = CreepsStopper.BestCreep;
    CreepsStopper.BestCreep = nil;
    CreepsStopper.BestPosition = nil;
    local MinDistance = 99999;
    local best_angle = 0.0;

    local curtime = GameRules.GetGameTime();

    CreepsStopper.FountainOrigin = Entity.GetAbsOrigin(CreepsStopper.Fountain);

    CreepsStopper.LessStopping = false;
    local CreepsCount = 0;
    for i, npc in ipairs(CreepsStopper.Creeps) do
        if NPC.IsLaneCreep(npc) and not Entity.IsDormant(npc) and Entity.IsAlive(npc) then
            local creep_origin = Entity.GetAbsOrigin(npc)
            local distance = (origin - creep_origin):Length();
            if (distance < (150 + CreepsStopper.UserCollisionSize * 2)) then
                CreepsCount = CreepsCount + 1;
                if CreepsCount > 1 then
                    CreepsStopper.LessStopping = true;
                    break;
                end;
            end;
        end;
    end;

    for i, npc in ipairs(CreepsStopper.Creeps) do
        if NPC.IsLaneCreep(npc) and not Entity.IsDormant(npc) and Entity.IsAlive(npc) then
            local creep_origin = Entity.GetAbsOrigin(npc)
            local distance = (origin - creep_origin):Length();

            local ranged = false;
            if Menu.IsEnabled(CreepsStopper.Menu.SkipRangedCreep) and NPC.IsRanged(npc) then
                ranged = true;
            end;

            local moves_to;
            if CreepsStopper.LessStopping then
                --Log.Write(distance / speed);
                moves_to = CreepsStopper.GetPredictedPosition(npc, CreepsStopper.PredictTime);
            else
                moves_to = CreepsStopper.GetPredictedPosition(npc, CreepsStopper.PredictTime);
            end;
            
            if not NPC.IsRunning(npc) or ranged then
                -- do nothing here
            else
                distance = distance - CreepsStopper.UserCollisionSize;
                if distance < MinDistance then
                    CreepsStopper.BestCreep = npc;
                    CreepsStopper.BestPosition = moves_to;
                    MinDistance = distance;
                    best_angle = angle;
                end;
            end;
        end;
    end;

    if CreepsStopper.BestPosition then
        --local pos_to_fountain_len = (CreepsStopper.BestPosition - CreepsStopper.FountainOrigin):Length();
        --local name = NPC.GetUnitName(CreepsStopper.BestCreep)
        --local collision_size = creep_melee_collision_size;

        if (curtime > CreepsStopper.Sleep) or (CreepsStopper.OldBestCreep ~= CreepsStopper.BestCreep) then
            Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION, CreepsStopper.User, CreepsStopper.BestPosition, nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_HERO_ONLY);
        end;
        local dist = (CreepsStopper.BestPosition - origin):Length();
        local maxdist = (150 + (speed - 270) * 1.7);
        -- if curtime > CreepsStopper.NextStop and dist >= 15 * speed / 315 and dist <= 150 * speed / 315 then
        --if (curtime > CreepsStopper.NextStop) and (dist >= 10) and (((dist <= 150) and (speed <= 300)) or ((dist <= 190) and (speed <= 325)) or ((dist <= 200) and (speed > 325))) then
        --if (curtime > CreepsStopper.NextStop )and (dist >= 10) and (dist <= 150) then
        if (curtime > CreepsStopper.NextStop) and (dist >= 10) and (dist <= maxdist) then
            if (speed < 500) then
                CreepsStopper.NextStop = curtime + (500 - speed) / 500;
            else
                CreepsStopper.NextStop = curtime + 79 / speed;--0.25 * 315 / speed;--
            end;

            if CreepsStopper.LessStopping and (CreepsStopper.OldBestCreep ~= CreepsStopper.BestCreep) then
                CreepsStopper.NextStop = curtime + dist / speed + NPC.GetTimeToFacePosition(CreepsStopper.User, CreepsStopper.BestPosition) + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) + NetChannel.GetAvgLatency(Enum.Flow.FLOW_INCOMING);
                -- CreepsStopper.NextStop = curtime + 0.9
            end;
            --[[
            if speed < 300 then
                CreepsStopper.Sleep = curtime + 16 / speed;--0.05 * 315 / speed;
            else
                CreepsStopper.Sleep = curtime + 22 / speed;--0.07 * 315 / speed;
            end
            ]]
            CreepsStopper.Sleep = curtime + 0.05 * 315 / speed;--speed / 5000;--
            Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_STOP, CreepsStopper.User, CreepsStopper.BestPosition, nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_HERO_ONLY);
        end;
    end;

    -- get my line and towers
    --[[
    CreepsStopper.LessStopping = false;
    local TOWER_WARNING = 350;
    for i, tower in pairs(CreepsStopper.Towers.Top) do
        local TowerOrigin = Entity.GetAbsOrigin(tower);
        if Entity.IsNPC(tower) and (origin - TowerOrigin):Length() <= TOWER_WARNING then
            CreepsStopper.LessStopping = true;
        end;
    end;
    for i, tower in pairs(CreepsStopper.Towers.Mid) do
        local TowerOrigin = Entity.GetAbsOrigin(tower);
        if Entity.IsNPC(tower) and (origin - TowerOrigin):Length() <= TOWER_WARNING then
            CreepsStopper.LessStopping = true;
        end;
    end;
    for i, tower in pairs(CreepsStopper.Towers.Bot) do
        local TowerOrigin = Entity.GetAbsOrigin(tower);
        if Entity.IsNPC(tower) and (origin - TowerOrigin):Length() <= TOWER_WARNING then
            CreepsStopper.LessStopping = true;
        end;
    end;
    ]]
end;

function CreepsStopper.OnDraw()

    if not CreepsStopper.inited then return end;

    if not Menu.IsEnabled(CreepsStopper.Menu.ShowDebugMove) or not Menu.IsKeyDown(CreepsStopper.Menu.Key) or not CreepsStopper.Creeps then
        return false;
    end;

    local origin = Entity.GetAbsOrigin(CreepsStopper.User);

    
    if CreepsStopper.LessStopping then
        local hx, hy = Renderer.WorldToScreen(origin);
        Renderer.SetDrawColor(0, 255, 255, 150);
        Renderer.DrawText(font, hx, hy, 'LESS STOPPING (TOWER NEAR)', 1);
    end;

    if CreepsStopper.BestPosition then
        local x, y = Renderer.WorldToScreen(origin);
        Renderer.SetDrawColor(255, 33, 33, 150);
        CreepsStopper.DrawCircle(CreepsStopper.BestPosition, CreepsStopper.UserCollisionSize);
        CreepsStopper.DrawCircle(origin, CreepsStopper.UserCollisionSize);
        local x2, y2 = Renderer.WorldToScreen(CreepsStopper.BestPosition);
        Renderer.DrawLine(x, y, x2, y2);
    end;
    
    if not CreepsBlocker.Creeps or (#CreepsBlocker.Creeps < 2) then
        return false;
    end;

    for i, npc in ipairs(CreepsStopper.Creeps) do
        if NPC.IsCreep(npc) and not Entity.IsDormant(npc) and Entity.IsAlive(npc) then
            local creep_origin = Entity.GetAbsOrigin(npc);
            Renderer.SetDrawColor(33, 33, 33, 150);

            local x, y = Renderer.WorldToScreen(creep_origin);
            CreepsStopper.DrawCircle(creep_origin, creep_melee_collision_size);

            local moves_to = CreepsStopper.GetPredictedPosition(npc, CreepsStopper.PredictTime);

            if not NPC.IsRunning(npc) then
                -- do nothing here
            else
                local x2, y2 = Renderer.WorldToScreen(moves_to);
                Renderer.DrawLine(x, y, x2, y2);
            end;
        end;
    end;
    
end;

-- return predicted position
function CreepsStopper.GetPredictedPosition(npc, delay)
    local pos = Entity.GetAbsOrigin(npc);
    if not NPC.IsRunning(npc) or not delay then return pos end;
    local totalLatency = (NetChannel.GetAvgLatency(Enum.Flow.FLOW_INCOMING) + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)); -- * 2 -- this may fix bot is not stopping at high ping
    delay = delay + totalLatency;

    local dir = Entity.GetRotation(npc):GetForward():Normalized();
    local speed = CreepsStopper.GetMoveSpeed(npc);

    return pos + dir:Scaled(speed * delay);
end;

function CreepsStopper.GetMoveSpeed(npc)
    --local base_speed = NPC.GetBaseSpeed(npc);
    --local bonus_speed = NPC.GetMoveSpeed(npc) - NPC.GetBaseSpeed(npc);
    
    return  NPC.GetMoveSpeed(npc);--base_speed + bonus_speed;
end;

function CreepsStopper.DrawCircle(UnitPos, radius)
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

function CreepsStopper.Reset()
    CreepsStopper.inited = false;
    CreepsStopper.Fountain = nil;
    CreepsStopper.Towers.Top = {};
    CreepsStopper.Towers.Mid = {};
    CreepsStopper.Towers.Bot = {};
end;

function CreepsStopper.getFountain(Hero)

    local team = 'badguys';
    CreepsStopper.Team = Entity.GetTeamNum(Hero)
    if CreepsStopper.Team ~= DOTA_TEAM_BADGUYS then
        team = 'goodguys';
    end;

    for i = 1, NPCs.Count() do 
        local npc = NPCs.Get(i);
        if NPC.IsStructure(npc) then
            local name = NPC.GetUnitName(npc);
            if name ~= nil then

                if name == "dota_fountain" then
                    if Entity.IsSameTeam(Hero, npc) then
                        CreepsStopper.Fountain = npc;
                    -- else
                    --     CreepsStopper.EnemyFountain = npc
                    end;
                end;

                if name == "npc_dota_"..team.."_tower1_top" then
                    CreepsStopper.Towers.Top[1] = npc;
                end;
                if name == "npc_dota_"..team.."_tower2_top" then
                    CreepsStopper.Towers.Top[2] = npc;
                end;
                if name == "npc_dota_"..team.."_tower3_top" then
                    CreepsStopper.Towers.Top[3] = npc;
                end;

                if name == "npc_dota_"..team.."_tower1_mid" then
                    CreepsStopper.Towers.Mid[1] = npc;
                end;
                if name == "npc_dota_"..team.."_tower2_mid" then
                    CreepsStopper.Towers.Mid[2] = npc;
                end;
                if name == "npc_dota_"..team.."_tower3_mid" then
                    CreepsStopper.Towers.Mid[3] = npc;
                end;

                if name == "npc_dota_"..team.."_tower1_bot" then
                    CreepsStopper.Towers.Bot[1] = npc;
                end;
                if name == "npc_dota_"..team.."_tower2_bot" then
                    CreepsStopper.Towers.Bot[2] = npc;
                end;
                if name == "npc_dota_"..team.."_tower3_bot" then
                    CreepsStopper.Towers.Bot[3] = npc;
                end;

            end;
        end;
    end;
end;

function CreepsStopper.OnGameStart()
	CreepsStopper.Init();
end;

return CreepsStopper