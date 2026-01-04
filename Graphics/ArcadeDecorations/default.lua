return Def.ActorFrame {
	Def.Sprite{
		Texture="icon",
		InitCommand=function(s) s:zoom(0.667):x(SCREEN_RIGHT-29.3):y(_screen.cy-88) end,
	};
	Def.Sprite{
		Texture=Language().."paseli",
		InitCommand=function(s) s:zoom(0.667):xy(_screen.cx+367,IsTitleMenu() and _screen.cy+115 or _screen.cy+186) end,
	};
	Def.Sprite{
		Condition=not IsTitleMenu(),
		InitCommand=function(s)
			s:zoom(0.56):xy(_screen.cx,_screen.cy+189):queuecommand("Set")
		end,
		CoinInsertedMessageCommand=function(s) s:queuecommand("Set") end,
		SetCommand=function(s)
			local path = "ArcadeDecorations/"..Language().."coin"
			if GAMESTATE:GetCoinMode() == 'CoinMode_Free'
			or GAMESTATE:GetCoinMode() == "CoinMode_Home"
			or GAMESTATE:EnoughCreditsToJoin() then
				path = "ArcadeDecorations/"..Language().."start"
			end
			s:Load(THEME:GetPathG("", path))
			s:diffuseshift():effectcolor1(color("#18ff00")):effectcolor2(color("#ffffff")):effectperiod(2.5)
		end
	};
	Def.Sprite{
		Condition=not IsTitleMenu(),
		InitCommand=function(s)
			s:zoom(0.56)
			s:x(GetCurrentLanguage() == "English" and _screen.cx or _screen.cx-83)
			s:y(_screen.cy+189)
			s:queuecommand("Set")
		end,
		CoinInsertedMessageCommand=function(s) s:queuecommand("Set") end,
		SetCommand=function(s)
			if GAMESTATE:GetCoinMode() == 'CoinMode_Free'
			or GAMESTATE:GetCoinMode() == "CoinMode_Home"
			or GAMESTATE:EnoughCreditsToJoin() then
				s:Load(THEME:GetPathG("","ArcadeDecorations/but"))
			end
			
		end
	};
};