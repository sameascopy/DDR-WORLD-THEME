local t = Def.ActorFrame{
	Def.Quad{
		InitCommand=function(s) s:FullScreen():diffuse(color("#00ce9c")) end,
	};
	--Def.Sprite { Texture="Captura de pantalla (563)", InitCommand=function(s) s:FullScreen() end, };
}

t[#t+1] = Def.ActorFrame{
	OnCommand=function(s) s:queuecommand("Play") end,
	PlayCommand=function(s) 
		local sound = THEME:GetPathS("ScreenStageInformation","intro")
		SOUND:PlayOnce(StreamingSound(sound)) 
	end,
};
	
t[#t+1] = LoadActor("_doors");

--t[#t+1] = LoadActor("StageDisplay")..{ InitCommand=function(s) s:xy(140,80):zoom(0.667) end, };

t[#t+1] = Def.ActorFrame{
	InitCommand=function(s) s:diffusealpha(0) end,
	OnCommand=function(s) s:sleep(2.5):linear(0.2):diffusealpha(1):sleep(0.7) end,

	-- -- Círculo que REVELA el jacket
	-- Def.Sprite{
		-- Texture=THEME:GetPathG("", "circle_mask"), -- círculo blanco con borde difuminado
		-- InitCommand=function(s)
			-- s:zoom(0)
			-- s:diffusealpha(0.9)
			-- s:MaskSource(true)
		-- end,
		-- OnCommand=function(s)
			-- s:decelerate(0.8):zoom(1.4):diffusealpha(0)
		-- end,
	-- },

	-- -- Jacket que aparece dentro del círculo
	-- Def.Sprite{
		-- InitCommand=function(s)
			-- s:MaskDest(true)
		-- end,
		-- OnCommand=function(s)
			-- s:queuecommand("Set")
		-- end,
		-- SetCommand=function(s)
			-- if GAMESTATE:IsCourseMode() then
				-- local ent = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber()):GetTrailEntries()
				-- s:Load(GetJacketPath(ent[1]:GetSong()))
			-- else
				-- local song = GAMESTATE:GetCurrentSong()
				-- s:Load(GetJacketPath(song))
			-- end
			-- s:setsize(287, 287)
		-- end,
	-- },
	Def.Quad{
		InitCommand=function(s) s:diffuse(color("#000000")):xy(_screen.cx,_screen.cy-16):diffusealpha(0.35):setsize(301,287) end,
	};
	Def.Sprite{
		InitCommand=function(s) s:xy(_screen.cx,_screen.cy-27) end,
		OnCommand=function(s) s:queuecommand("Set") end,
		SetCommand=function(s)
			if GAMESTATE:IsCourseMode() then
				local ent = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber()):GetTrailEntries()
				s:Load(GetJacketPath(ent[1]:GetSong()))
			else
				local song = GAMESTATE:GetCurrentSong()
				s:Load(GetJacketPath(song))
			end
			s:setsize(287,287)
		end,
	};
	LoadActor("ScoreDisplay");
}





t[#t+1] = Def.Sprite{ 
	Texture=THEME:GetPathG("","_doors/circle.png"), 
	InitCommand=function(s) s:Center():zoom(0.667):diffusealpha(0) end,
	OnCommand=function(s) s:sleep(4.9):decelerate(0.2):diffusealpha(1) end,
};

t[#t+1] = Def.Sprite{ 
	Texture=THEME:GetPathG("","_doors/circle_fade"), 
	InitCommand=function(s) s:Center():FullScreen():zoom(160):diffusealpha(0) end,
	OnCommand=function(s) s:sleep(4.6):diffusealpha(1):decelerate(0.4):zoom(0.667) end,
};
 


return t