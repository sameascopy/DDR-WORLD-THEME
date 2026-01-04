local lap = 2

return Def.ActorFrame{
	loadfile(THEME:GetPathG("","Premium Customizer/background/"..ThemePrefs.Get("SelectMusicBG")))();
	Def.Sprite{
		Texture=THEME:GetPathG("","Premium Customizer/character/selmus/P1/"..ThemePrefs.Get("CharacterP1")),
		InitCommand=function(s) s:xy(SCREEN_LEFT+204,_screen.cy):zoom(0.6):queuecommand("Anim") end,
		AnimCommand=function(s) s:linear(lap):zoom(0.63):linear(lap):zoom(0.6):queuecommand("Anim") end,
		OffCommand=function(s) s:stoptweening() end,
	};
	Def.Sprite{
		Texture=THEME:GetPathG("","Premium Customizer/character/selmus/P2/"..ThemePrefs.Get("CharacterP2")),
		InitCommand=function(s) s:xy(SCREEN_RIGHT-204.5,_screen.cy):zoom(0.63):queuecommand("Anim") end,
		AnimCommand=function(s) s:linear(lap):zoom(0.6):linear(lap):zoom(0.63):queuecommand("Anim") end,
		OffCommand=function(s) s:stoptweening() end,
	};
};