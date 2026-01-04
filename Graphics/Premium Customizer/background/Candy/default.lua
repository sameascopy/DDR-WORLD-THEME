return Def.ActorFrame{
	LoadActor("bg")..{ 
		InitCommand=function(s) s:FullScreen():texcoordvelocity(-0.012,0) end, 
	};
};