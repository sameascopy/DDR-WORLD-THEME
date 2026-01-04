return Def.ActorFrame {
	loadfile(THEME:GetPathB("","_doors"))()..{
		StartTransitioningCommand=function(s) s:playcommand("Open") end,
	};
};