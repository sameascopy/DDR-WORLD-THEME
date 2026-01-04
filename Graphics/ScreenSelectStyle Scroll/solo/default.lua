return Def.ActorFrame{
	InitCommand=function(s) s:xy(-77,-12):zoom(0.667) end,
	OnCommand=function(s) s:zoomy(0):linear(0.2):zoomy(0.667) end,
	OffCommand=function(s) s:zoomy(0.667):linear(0.15):zoomy(0) end,
	Def.Sprite{
		Texture=THEME:GetPathG("ScreenSelectStyle","Scroll/base_scroll"),
		InitCommand=function(s) s:y(-33) end,
	},
	Def.Sprite{
		Texture="main",
		InitCommand=function(s) s:pause():y(-72) end,
		GainFocusCommand=function(s) s:setstate(1) end, 
		LoseFocusCommand=function(s) s:setstate(0) end, 
	},
	Def.Sprite{
		Texture=Language().."text",
		InitCommand=function(s) s:xy(2,76) end,
	},
	Def.Quad{
		InitCommand=function(s) s:y(147):setsize(224,63) end,
		GainFocusCommand=function(s) s:diffuse(color("#00ffba")) end,
		LoseFocusCommand=function(s) s:diffuse(color("#8e8d8e")) end,
	},
	Def.Sprite{
		Texture=THEME:GetPathG("ScreenSelectStyle","Scroll/"..Language().."next"),
		InitCommand=function(s) s:y(147) end,
	},
	Def.Sprite{
		Texture=THEME:GetPathG("","_shared/aline"),
		InitCommand=function(s) s:y(174):setsize(224,9):texcoordvelocity(-0.15,0) end,
		GainFocusCommand=function(s) s:visible(true) end,
		LoseFocusCommand=function(s) s:visible(false) end,
	},
};