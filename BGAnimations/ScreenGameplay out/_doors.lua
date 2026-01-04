return Def.ActorFrame{
	Def.Quad{
		InitCommand=function(s) s:FullScreen():diffuse(color("#00ffc4")):diffusealpha(0) end,
		AnimCloseCommand=function(s) s:linear(0.2):diffusealpha(1) end,
		AnimOpenCommand=function(s) s:diffusealpha(1):sleep(1.3):linear(0.3):diffusealpha(0) end,
		AnimFailedCloseCommand=function(s) s:playcommand("AnimClose") end,
		AnimFailedOpenCommand=function(s) s:playcommand("AnimOpen") end,
	};
	Def.Sprite{
		Texture="lines",
		InitCommand=function(s) s:Center():zoom(0.667):diffusealpha(0) end,
		AnimCloseCommand=function(s) s:linear(0.2):diffusealpha(1) end,
		AnimOpenCommand=function(s) s:diffusealpha(1):sleep(1):linear(0.2):zoom(0.7):linear(0.2):diffusealpha(0) end,
	};
	Def.Sprite{
		Texture="planet",
		InitCommand=function(s) s:Center():zoom(0.667):diffusealpha(0) end,
		AnimCloseCommand=function(s) s:linear(0.2):diffusealpha(1) end,
		AnimOpenCommand=function(s) s:diffusealpha(1):sleep(1):linear(0.2):zoom(0.7):linear(0.2):diffusealpha(0) end,
	};
	Def.Sprite{
		Texture="star",
		InitCommand=function(s) s:Center():zoom(0.667):diffusealpha(0) end,
		AnimCloseCommand=function(s) s:linear(0.2):diffusealpha(1) end,
		AnimOpenCommand=function(s) s:diffusealpha(1):sleep(1):linear(0.2):zoom(0.7):linear(0.2):diffusealpha(0) end,
	};
	Def.Sprite{
		Texture="cleared",
		InitCommand=function(s) s:Center():zoomx(0.62):zoomy(0):diffusealpha(0) end,
		AnimCloseCommand=function(s) s:linear(0.2):diffusealpha(1):zoomy(0.62) end,
		AnimOpenCommand=function(s) s:diffusealpha(1):zoomy(0.62):sleep(1):linear(0.2):zoom(0.63):linear(0.2):zoomy(0):diffusealpha(0) end,
	};
};