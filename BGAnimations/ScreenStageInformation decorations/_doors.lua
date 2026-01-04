return Def.ActorFrame{
	Def.Sprite{ 
		Texture="logo", 
		InitCommand=function(s) s:zoom(0.667):xy(_screen.cx,_screen.cy) end,  
	};
	Def.Sprite{ 
		Texture="rcir", 
		InitCommand=function(s) s:pause():zoom(0.667):xy(SCREEN_LEFT+49,_screen.cy) end, 
		OnCommand=function(s) s:setstate(1) end, 
	};
	Def.Sprite{ 
		Texture="rcir", 
		InitCommand=function(s) s:pause():zoom(0.667):xy(SCREEN_LEFT+53,_screen.cy) end, 
		OnCommand=function(s) s:setstate(0) end, 
	};
	Def.Sprite{ 
		Texture="rcir", 
		InitCommand=function(s) s:pause():zoom(-0.667):xy(SCREEN_RIGHT-49,_screen.cy) end, 
		OnCommand=function(s) s:setstate(1) end, 
	};
	Def.Sprite{ 
		Texture="rcir", 
		InitCommand=function(s) s:pause():zoom(-0.667):xy(SCREEN_RIGHT-53,_screen.cy) end, 
		OnCommand=function(s) s:setstate(0) end, 
	};
};