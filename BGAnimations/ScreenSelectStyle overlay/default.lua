local t = Def.ActorFrame {};



t[#t+1] = Def.Actor{
	PlayerJoinedMessageCommand=function(self)
		self:queuecommand("Delay1")
	end;
	Delay1Command=function(self)
		self:sleep(2)
		self:queuecommand("SetScreen")
	end;
	SetScreenCommand=function(self)
		SCREENMAN:GetTopScreen():SetNextScreenName("ScreenProfileLoad"):StartTransitioningScreen("SM_GoToNextScreen")
	end;
};

--t[#t+1] = Def.Sprite{ Texture="cap", InitCommand=function(s) s:FullScreen() end, };

return Def.ActorFrame{
	t,
	Def.Sprite{
		Texture=THEME:GetPathG("","_shared/ddr"),
		InitCommand=function(s) s:zoom(0.667):xy(_screen.l+89,_screen.t+23) end,
		OffCommand=function(s) s:linear(0.2):zoomy(0) end,
	},
	Def.Sprite{
		Texture="header",
		InitCommand=function(s) s:zoom(0.667):xy(_screen.cx,_screen.t+68) end,
		OffCommand=function(s) s:linear(0.2):zoomy(0) end,
	},
	Def.Sprite{
		Texture=Language().."mode",
		InitCommand=function(s) s:zoom(0.667):xy(_screen.cx,_screen.t+78):halign(0.7) end,
		OffCommand=function(s) s:linear(0.2):zoomy(0) end,
	},

}