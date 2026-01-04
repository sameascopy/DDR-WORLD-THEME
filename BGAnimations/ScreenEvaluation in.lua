local st = STATSMAN:GetCurStageStats()
local pss_p1 = st:GetPlayerStageStats(PLAYER_1)
local pss_p2 = st:GetPlayerStageStats(PLAYER_2)

return Def.ActorFrame {
	Def.ActorFrame{
		Condition=pss_p1:GetScore() > 0 or pss_p2:GetScore() > 0;
		OnCommand=function(s) s:queuecommand("Play") end,
		PlayCommand=function(s) 
			local sound = THEME:GetPathS("ScreenEvaluation","Score")
			SOUND:PlayOnce(StreamingSound(sound)) 
		end,
	};
	Def.Sprite{
		Texture=THEME:GetPathG("","_doors/StageCleared"),
		InitCommand=function(s) s:FullScreen() end,
		OnCommand=function(s) s:linear(0.1):zoom(0.667):decelerate(0.2):zoom(0):diffusealpha(0) end,
	};
};