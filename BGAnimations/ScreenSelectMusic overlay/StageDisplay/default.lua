local sStage = GAMESTATE:GetCurrentStage();
local tRemap = {
	Stage_1st		= 1,
	Stage_2nd		= 2,
	Stage_3rd		= 3,
	Stage_4th		= 4,
	Stage_5th		= 5,
	Stage_6th		= 6,
};

if tRemap[sStage] == PREFSMAN:GetPreference("SongsPerPlay") then
	sStage = "Stage_Final";
else
	sStage = sStage;
end;

return Def.ActorFrame {
	Def.Sprite{
		Texture=THEME:GetPathG("","_shared/ddr"),
		InitCommand=function(s) s:zoom(0.48):xy(SCREEN_LEFT+64,SCREEN_TOP+18) end,
	};
	Def.Sprite{
		Texture="all",
		InitCommand=function(s) s:zoom(0.667):xy(SCREEN_LEFT+119,SCREEN_TOP+40) end,
	};
	Def.Sprite{
		Texture="style",
		InitCommand=function(s) s:zoom(0.667):xy(SCREEN_LEFT+52,SCREEN_TOP+59):pause():queuecommand("Set") end,
		SetCommand=function(s)
			local style = GAMESTATE:GetCurrentStyle()
			if style:GetStyleType() == "StyleType_OnePlayerOneSide" then
				s:setstate(0);
			elseif style:GetStyleType() == "StyleType_TwoPlayersTwoSides" then
				s:setstate(1);
			elseif style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
				s:setstate(2);
			end;
		end,
	};
	-- Def.Sprite{
		-- Texture=Model()..ToEnumShortString(sStage),
		-- InitCommand=function(s) s:xy(96,30.5) end,
	-- };
};
