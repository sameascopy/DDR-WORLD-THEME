return Def.ActorFrame{
	LoadActor(THEME:GetPathB("ScreenStageInformation","decorations/Announcer"));
    OnCommand=function(s) s:sleep(3) end,
};