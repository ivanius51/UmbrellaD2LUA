local PerfomanceTest = {};
local Items = {};
local User = Heroes.GetLocal();
local GameTime = GameRules.GetGameTime();
local OldGameTime = GameTime;
local UpdateGameTime = GameTime;

local FontBig = Renderer.LoadFont("Tahoma", 16, Enum.FontWeight.EXTRABOLD);

local Debug = {};
Debug.Enabled = Menu.AddOptionBool({"Debug"}, "Enabled", false);


local Perfomance = {};

local counter = 0;
local UpdateCounter = 1;
local UpdatePeriod = 5;
local SecCounter = UpdatePeriod;

function PerfomanceTest.OnPerformance(scriptName, callbackName, elapsedTime)
  if not Perfomance[scriptName] then
    Perfomance[scriptName] = {};
  end;
  local temp = Perfomance[scriptName][callbackName];
  if not temp then
    temp = {};
    temp.AllTime = 0;
    temp.Count = 0;
    temp.Time = 0;
  end;
  temp.Count = temp.Count + 1;
  temp.Time = temp.Time + math.floor(elapsedTime / 100);
  temp.AllTime = temp.AllTime + math.floor(elapsedTime / 100);

  Perfomance[scriptName][callbackName] = temp;
end;

function PerfomanceTest.OnUpdate()
	if Menu.IsEnabled(Debug.Enabled) then
  GameTime = GameRules.GetGameTime();
  if (GameTime - OldGameTime) >= UpdatePeriod then
    OldGameTime = GameTime;
    for scriptName, callbacks in pairs(Perfomance) do
      if (scriptName~="Protected_Script_1")and(scriptName~="Perfomance") then
        local DrawTime = 0;
        local DrawCount = 0;
        local UpdateTime = 0;
        local UpdateCount = 0;
        local AllTime = 0;
        local ScriptTime = 0;
        local Max = 0;
        local MaxCount = 0;
        local MaxName = '';
        for callbackName, Timings in pairs(callbacks) do
          ScriptTime = ScriptTime + Timings.Time / 10;
          if (callbackName=="OnUpdate") or (callbackName=="OnDraw") then
            if (callbackName=="OnUpdate") then
              UpdateTime = Timings.Time / 10;
              UpdateCount = Timings.Count;
              Timings.Count = 0;
            end;
            if (callbackName=="OnDraw") then
              DrawTime = Timings.Time / 10;
              DrawCount = Timings.Count;
              Timings.Count = 0;
            end;
            AllTime = AllTime + Timings.AllTime;
            Timings.Time = 0;
          else
            if Max < Timings.Time then
              Max = Timings.Time / 10;
              MaxCount = Timings.Count;
              MaxName = callbackName;
            end;
            Timings.Time = 0;
            Timings.Count = 0;
          end;
        end;
        Log.Write(scriptName.." ScriptTime="..ScriptTime.."("..MaxName.."="..Max.."/"..MaxCount..")".." Update="..UpdateTime.."/"..UpdateCount.." Draw="..DrawTime.."/"..DrawCount.." AVGTime="..math.ceil(AllTime / (SecCounter * 10)));
      end;
    end;
    SecCounter = SecCounter + UpdatePeriod;
  end;
	end;
end;


return PerfomanceTest;