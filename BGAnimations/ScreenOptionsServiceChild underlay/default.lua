return Def.ActorFrame {
	LoadActor(THEME:GetPathB("ScreenWithMenuElements","background"));
	LoadActor(Model().."Back") .. {
		InitCommand=function(s) 
			if IsOptionService() or IsOptionManageProfiles() then
				s:xy(_screen.cx+10,_screen.cy-24):setsize(500,400)
			else
				s:xy(_screen.cx,_screen.cy-9):setsize(720,430)
			end
		end,
		OnCommand=function(s) s:zoomx(0):linear(0.25):zoomx(1) end,
		OffCommand=function(s) s:sleep(0.3):linear(0.25):zoomx(0) end,
	};
	LoadActor(THEME:GetPathG("","ScreenSelectProfile/"..Model().."bottom")) .. {
		InitCommand=function(s) s:x(_screen.cx):setsize(400,59)
			if IsOptionService() or IsOptionManageProfiles() then
				s:y(SCREEN_BOTTOM-86)
			else
				s:y(SCREEN_BOTTOM-60) 
			end
		end,
		OnCommand=function(s) s:zoomx(0):linear(0.25):zoomx(1) end,
		OffCommand=function(s) s:sleep(0.3):linear(0.25):zoomx(0) end,
	};
};







