local pn = ({...})[1]
local Award = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetStageAward()
local Grade = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetGrade()

return Def.ActorFrame{

	Def.Sprite{
		InitCommand=function(s) 
			s:player(pn):x(pn== PLAYER_1 and _screen.cx-175 or _screen.cx+302)
			s:y(_screen.cy-70):zoom(0):queuecommand("Set") 
		end,
		OnCommand=function(s) s:linear(0.2):zoom(0.667) end,
		OffCommand=function(s) s:linear(0.2):zoomy(0) end,
		SetCommand=function(s) s:Load(THEME:GetPathG("","Grade/"..Grade)) end,
	};
	Def.Sprite{
		InitCommand=function(s) 
			s:player(pn):x(pn== PLAYER_1 and _screen.cx-176 or _screen.cx+380)
			s:y(_screen.cy-12):zoom(0):queuecommand("Set") 
		end,
		OnCommand=function(s) s:linear(0.2):zoom(0.667) end,
		OffCommand=function(s) s:linear(0.2):zoomy(0) end,
		SetCommand=function(s)
			if (Award == "StageAward_FullComboW1") then
													s:Load(THEME:GetPathG("","Grade/FullCombo_W1"))
			elseif ((Award == "StageAward_SingleDigitW2") 
			or (Award == "StageAward_OneW2") 
			or (Award == "StageAward_FullComboW2")) then
													s:Load(THEME:GetPathG("","Grade/FullCombo_W2"))
			elseif ((Award == "StageAward_SingleDigitW3") 
			or (Award == "StageAward_OneW3") 
			or (Award == "StageAward_FullComboW3")) then 
													s:Load(THEME:GetPathG("","Grade/FullCombo_W3"))
			elseif (STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):FullComboOfScore('TapNoteScore_W4')) then
													s:Load(THEME:GetPathG("","Grade/FullCombo_W4"))
			end
		end,
		
	};
};