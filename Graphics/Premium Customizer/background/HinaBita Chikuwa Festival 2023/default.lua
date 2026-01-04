return Def.ActorFrame{
	Def.Sprite{
	Texture="bg", 
		InitCommand=function(s) s:FullScreen() end, 
	};
	Def.Sprite{
	Texture="deco", 
		InitCommand=function(s) s:FullScreen():texcoordvelocity(-0.02,0) end, 
	};
	
};