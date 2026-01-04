return Def.ActorFrame{
	loadfile(THEME:GetPathB("","_doors"))()..{
		OnCommand=function(s) s:playcommand("Close") end,
	};
	Def.Sprite{
		Texture="base",
		InitCommand=function(s) s:zoom(0):Center() end,
		OnCommand=function(s) s:sleep(0.3):linear(0.2):zoomx(-0.567):zoomy(0.567):linear(0.2):zoom(0.667) end,
		OffCommand=function(s) s:sleep(0.25):linear(0.3):zoomx(-0.667):zoomy(0) end,
	},
	Def.Sprite{
		Texture="caution",
		InitCommand=function(s) s:zoom(0.667):xy(_screen.cx,_screen.cy-60):diffusealpha(0) end,
		OnCommand=function(s) s:sleep(0.7):linear(0.2):diffusealpha(1) end,
		OffCommand=function(s) s:linear(0.2):diffusealpha(0) end,
	},
	Def.Sprite{
		Texture=Language().."text",
		InitCommand=function(s) s:zoom(0.667):xy(_screen.cx,_screen.cy+7):diffusealpha(0) end,
		OnCommand=function(s) s:sleep(0.7):linear(0.2):diffusealpha(1) end,
		OffCommand=function(s) s:linear(0.2):diffusealpha(0) end,
	},
}