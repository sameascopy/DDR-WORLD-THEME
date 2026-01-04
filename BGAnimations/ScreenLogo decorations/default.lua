return Def.ActorFrame { 
	Def.ActorFrame{
		OnCommand=function(s)
			if IsLogo() then
				SOUND:PlayAnnouncer("title menu game name")
				SOUND:PlayOnce(THEME:GetPathS("ScreenLogo", "intro"))
			end
		end,
	};
	
	LoadActor(THEME:GetPathB("ScreenLogo","decorations/logo"))..{
		InitCommand=function(s) s:xy(_screen.cx,_screen.cy-40):zoom(0.667) end,
	};
	LoadActor(THEME:GetPathB("ScreenLogo","decorations/copyright"))..{
		InitCommand=function(s) s:xy(_screen.cx,SCREEN_BOTTOM-86):zoom(0.667) end,
	};
	Def.Quad{
		InitCommand=function(s) s:diffuse(Color("White")):FullScreen() end,
		OnCommand=function(s) 
			if IsLogo() then
				s:linear(0.25):diffusealpha(0):sleep(9.5):linear(0.25):diffusealpha(1) 
			elseif IsTitleMenu() or IsTitleJoin then 
				s:linear(0.25):diffusealpha(0)
			end
		end
	};
	LoadActor(THEME:GetPathB("","ModDate"));	
	LoadActor(THEME:GetPathG("","ArcadeDecorations"));
};