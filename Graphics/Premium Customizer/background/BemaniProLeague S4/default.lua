local lin = 0.4

return Def.ActorFrame{
	Def.Sprite{
	Texture="bg", 
		InitCommand=function(s) s:FullScreen() end, 
	};
	Def.Sprite{
	Texture="four1", 
		InitCommand=function(s) s:xy(_screen.cx+2,_screen.cy+1):blend("BlendMode_Add"):zoom(0.667):diffusealpha(0) end, 
		OnCommand=function(s) s:queuecommand("Bright") end,
		BrightCommand=function(s) s:sleep(2):linear(0.05):diffusealpha(1):linear(0.05):diffusealpha(0):sleep(4):queuecommand("Bright") end,
	};
	Def.Sprite{
	Texture="four2", 
		InitCommand=function(s) s:xy(_screen.cx+2,_screen.cy-1):blend("BlendMode_Add"):zoom(0.667):diffusealpha(0) end,
		OnCommand=function(s) s:queuecommand("Bright") end,
		BrightCommand=function(s) s:sleep(6):linear(0.05):diffusealpha(1):linear(0.05):diffusealpha(0):sleep(4):queuecommand("Bright") end,
	};
	Def.Sprite{
	Texture="four3", 
		InitCommand=function(s) s:xy(_screen.cx-1,_screen.cy+1):blend("BlendMode_Add"):zoom(0.667):diffusealpha(0) end,
		OnCommand=function(s) s:queuecommand("Bright") end,
		BrightCommand=function(s) s:sleep(10):linear(0.05):diffusealpha(1):linear(0.05):diffusealpha(0):sleep(4):queuecommand("Bright") end,
	};
	Def.Sprite{
	Texture="four4", 
		InitCommand=function(s) s:xy(_screen.cx-1,_screen.cy-1):blend("BlendMode_Add"):zoom(0.667):diffusealpha(0) end,
		OnCommand=function(s) s:queuecommand("Bright") end,
		BrightCommand=function(s) s:sleep(14):linear(0.05):diffusealpha(1):linear(0.05):diffusealpha(0):sleep(4):queuecommand("Bright") end,
	};
	
	Def.Sprite{
	Texture="white", 
		InitCommand=function(s) s:setsize(2,250):xy(_screen.cx-353,_screen.cy):rotationz(30) end,
		OnCommand=function(s) s:queuecommand("Shooting") end,
		ShootingCommand=function(s) s:sleep(5):linear(lin):addx(-175):addy(300):linear(0.0001):addx(375):addy(-650):linear(lin):xy(_screen.cx-353,_screen.cy):sleep(6):queuecommand("Shooting") end,
	};
	Def.Sprite{
	Texture="red", 
		InitCommand=function(s) s:setsize(20,350):xy(_screen.cx-274,_screen.cy-104):z(10):rotationz(30) end,
		OnCommand=function(s) s:queuecommand("Shooting") end,
		ShootingCommand=function(s) s:sleep(6):linear(lin):addx(-175*2):addy(300*2):linear(0.0001):addx(375*2):addy(-650*2):linear(lin):xy(_screen.cx-274,_screen.cy-104):sleep(6):queuecommand("Shooting") end,
	};
	Def.Sprite{
	Texture="red", 
		InitCommand=function(s) s:setsize(20,400):xy(_screen.cx-288,_screen.cy+90):z(10):rotationz(30) end,
		OnCommand=function(s) s:queuecommand("Shooting") end,
		ShootingCommand=function(s) s:sleep(14):linear(lin):addx(-175*2):addy(300*2):linear(0.0001):addx(375*2):addy(-650*2):linear(lin):xy(_screen.cx-288,_screen.cy+90):sleep(6):queuecommand("Shooting") end,
	};
	Def.Sprite{
	Texture="red", 
		InitCommand=function(s) s:setsize(20,400):xy(_screen.cx+282,_screen.cy-120):z(10):rotationz(30) end,
		OnCommand=function(s) s:queuecommand("Shooting") end,
		ShootingCommand=function(s) s:sleep(20):linear(lin):addx(-175*2):addy(300*2):linear(0.0001):addx(375*2):addy(-650*2):linear(lin):xy(_screen.cx+282,_screen.cy-120):sleep(6):queuecommand("Shooting") end,
	};
	Def.Sprite{
	Texture="white", 
		InitCommand=function(s) s:setsize(2,250):xy(_screen.cx+345,_screen.cy-68):rotationz(30) end,
		OnCommand=function(s) s:queuecommand("Shooting") end,
		ShootingCommand=function(s) s:sleep(10):linear(lin):addx(-175*2):addy(300*2):linear(0.0001):addx(375*2):addy(-650*2):linear(lin):xy(_screen.cx+345,_screen.cy-68):sleep(6):queuecommand("Shooting") end,
	};
	Def.Sprite{
	Texture="white", 
		InitCommand=function(s) s:setsize(2,250):xy(_screen.cx+280,_screen.cy+96):rotationz(30) end,
		OnCommand=function(s) s:queuecommand("Shooting") end,
		ShootingCommand=function(s) s:sleep(8):linear(lin):addx(-175*2):addy(300*2):linear(0.0001):addx(375*2):addy(-650*2):linear(lin):xy(_screen.cx+280,_screen.cy+96):sleep(6):queuecommand("Shooting") end,
	};
	Def.Sprite{
	Texture="red", 
		InitCommand=function(s) s:setsize(20,400):xy(_screen.cx+312,_screen.cy+90):z(10):rotationz(30) end,
		OnCommand=function(s) s:queuecommand("Shooting") end,
		ShootingCommand=function(s) s:sleep(9):linear(lin):addx(-175*2):addy(300*2):linear(0.0001):addx(375*2):addy(-650*2):linear(lin):xy(_screen.cx+312,_screen.cy+90):sleep(6):queuecommand("Shooting") end,
	};
	Def.Sprite{
	Texture="fire", 
		InitCommand=function(s) s:FullScreen() end, 
	};
	
	
};