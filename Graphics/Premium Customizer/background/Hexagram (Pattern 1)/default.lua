return Def.ActorFrame{
	LoadActor("bg")..{ 
		InitCommand=function(s) s:FullScreen():texcoordvelocity(-0.02,0) end, 
	};
};