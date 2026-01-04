local t = Def.ActorFrame{ 
	StandardDecorationFromFileOptional("Footer","Footer");
	LoadActor("background");
	--Def.Sprite{ Texture="o4ma", InitCommand=function(s) s:FullScreen() end, };
};

local StageIndex = GAMESTATE:GetCurrentStageIndex()
local FinalStage = PREFSMAN:GetPreference("SongsPerPlay")

t[#t+1] = Def.ActorFrame{
	Def.Sprite{
		Texture=THEME:GetPathG("","_shared/ddr"),
		InitCommand=function(s) s:zoom(0.667):xy(SCREEN_LEFT+88,_screen.t+23) end,
	};
	Def.Sprite{
		Texture="RESULTS",
		InitCommand=function(s) s:zoom(0.667):xy(_screen.cx,_screen.t+27) end,
	};
	Def.Sprite{
		Texture="event",
		InitCommand=function(s) s:zoom(0.667):xy(_screen.cx,_screen.t+56) end,
	};
};

t[#t+1] = Def.ActorFrame{
    Name="Jacket";
	Def.Sprite{
		Texture="base",
		InitCommand=function(s) s:setsize(149,189):xy(_screen.cx,_screen.cy-77) end,
	};
	Def.Sprite{
		Texture="rocket",
		InitCommand=function(s) s:zoom(0.667):xy(_screen.cx+64,_screen.cy+5) end,
	};
	Def.Sprite {
		OnCommand=function(s)
		local song; if GAMESTATE:IsCourseMode() then song = GAMESTATE:GetCurrentCourse() else song = GAMESTATE:GetCurrentSong(); end
			if GAMESTATE:IsCourseMode() then
                s:Load(song:GetBannerPath()):zoomto(290,52):xy(_screen.cx+3,_screen.cy-114)
			else	
				s:Load(GetJacketPath(song)):setsize(141,141):xy(_screen.cx,_screen.cy-97)
			end
		end;
	};
	Def.BitmapText{
        Font="_swis721 blk bt 28px",
        InitCommand=function(s) s:xy(_screen.cx-70,_screen.cy-8):maxwidth(310):zoom(0.4):halign(0)
            local song = GAMESTATE:GetCurrentSong()
            local course = GAMESTATE:GetCurrentCourse()
            if GAMESTATE:IsCourseMode() then
                s:settext(GAMESTATE:GetCurrentCourse() and GAMESTATE:GetCurrentCourse():GetDisplayFullTitle() or "")
			else
				s:settext(GetSongName(song))
			end
        end,
    };		
    Def.BitmapText{
        Font="_swis721 blk bt 28px",
        InitCommand=function(s) s:xy(_screen.cx-70,_screen.cy+6):wrapwidthpixels(650):zoom(0.2):halign(0)
            local song = GAMESTATE:GetCurrentSong()
			if not GAMESTATE:IsCourseMode() then
                s:settext(GetArtistName(song))
            end
        end,
    };	
};

for _,pn in pairs(GAMESTATE:GetEnabledPlayers()) do
	t[#t+1] = Def.ActorFrame{ 
		Name="Player";
		Def.Sprite{
			Texture=THEME:GetPathG("Premium","Customizer/appeal/eval/appeal_board_0002_result"),
			InitCommand=function(s) s:zoom(0.667):y(_screen.t+47.5)
				s:x(_screen.cx-192)
			end,
		};
		Def.BitmapText{
			Font="_arial black cont 28px",
			InitCommand=function(s) 
				s:maxwidth(285):diffuse(color("#ffffff")):zoom(0.5):y(_screen.t+70)
				s:x(_screen.cx-195)
				--s:horizalign(right)
				if PROFILEMAN:GetNumLocalProfiles() >= 1 then
					s:settext(string.upper(PROFILEMAN:GetPlayerName(pn)))
				else
					s:settext(pn==PLAYER_1 and "PLAYER 1" or "PLAYER 2")
				end
			end,
        };
		Def.Quad{
			InitCommand=function(s) 
				s:diffuse(color("#00000")):diffusealpha(0.3):setsize(148.2,24)
				s:xy(_screen.cx-192,_screen.t+90) 
			end,
		};
		Def.Sprite{
			Texture="style",
			InitCommand=function(s) s:zoom(0.667):xy(_screen.cx-238, _screen.t+90):pause():queuecommand("Set") end,
			SetCommand=function(s) s:setstate(GAMESTATE:GetCurrentStyle()== "StyleType_OnePlayerTwoSides" and 1 or 0) end,
		},
		Def.Sprite{
			Texture="diff",
			InitCommand=function(s) s:zoom(0.7):xy(_screen.cx-179, _screen.t+90):pause():queuecommand("Set") end,
			SetCommand=function(s)
				local steps = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentTrail(pn) or GAMESTATE:GetCurrentSteps(pn)
				local diff = steps and ToEnumShortString(steps:GetDifficulty()) or "Beginner"
				local idx = {Beginner=0,Easy=1,Medium=2,Hard=3,Challenge=4,Edit=5}
					s:setstate(idx[diff] or 0)
			end,
		},
		Def.BitmapText{
			Font="eval_diff",
            InitCommand=function(s) s:zoom(0.285):y(_screen.t+92)
                local steps = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentTrail(pn) or GAMESTATE:GetCurrentSteps(pn)
				local meter = steps:GetMeter();
				local shortDiff = ToEnumShortString(steps:GetDifficulty())
				local diffData = {
					Beginner  = { x = 136 },
					Easy      = { x = 169 },
					Medium    = { x = 146 },
					Hard      = { x = 157 },
					Challenge = { x = 136 },
					Edit      = { x = 136 },
				}
				local data = diffData[shortDiff]
				s:x(_screen.cx-data.x)
				if meter ~= 0 then
					s:settext(meter)
				end
			end,
        };
	};
	
	-- local IsScore = "NORMAL.png"
	-- if IsEXScore() then
		-- IsScore = "EX.png"
	-- end
	-- t[#t+1] = Def.ActorFrame{
		-- InitCommand=function(s) s:zoom(0.667):xy(pn==PLAYER_1 and _screen.cx-208 or _screen.cx+220,_screen.cy-40) end,
        -- OffCommand=function(s) s:sleep(0.2):linear(0.2):diffusealpha(0) end,
		-- Def.Sprite{
			-- Texture=IsScore,
            -- InitCommand=function(s) s:xy(-124,-36) end,
        -- };
    -- };
	t[#t+1] = LoadActor("Grade",pn);
	local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)
	t[#t+1] = Def.RollingNumbers{
            File="eval_score",
            InitCommand=function(s) 
				s:zoom(0.667)
				s:xy(pn==PLAYER_1 and _screen.cx-183 or _screen.cx+200,_screen.cy+16)
				s:playcommand("Set") 
			end,
            OffCommand=function(s) s:sleep(0.2):linear(0.2):diffusealpha(0) end,
            SetCommand=function(s)
            local score
				if IsEXScore() then
					score = (pss:GetPossibleDancePoints())*(pss:GetPercentDancePoints());
				else 
					score = pss:GetScore();
				end;
			    s:Load("RollingNumbersEvaluation"):targetnumber(score);
            end,
		};
	
	if pss:GetMachineHighScoreIndex() == 0 or pss:GetPersonalHighScoreIndex() == 0 then
		t[#t+1] = Def.Sprite{
			Texture="RECORD",
			InitCommand=function(s) s:zoom(0.667):xy(_screen.cx-138,_screen.cy+34) end,
			OnCommand=function(s) s:queuecommand("Light") end,
			LightCommand=function(s) s:diffusealpha(1):linear(1):diffusealpha(0.4):linear(1):diffusealpha(1):queuecommand("Light") end,
		};
	end

	-- if not ((StageIndex == FinalStage+1) or (StageIndex == FinalStage+2)) then
		-- t[#t+1] = LoadActor(THEME:GetPathB("ScreenEvaluation","decorations/stars"))..{
			-- InitCommand=function(s) s:xy(pn==PLAYER_1 and _screen.cx-54 or _screen.cx+278,_screen.cy-10):zoom(0.667) end,
			-- OffCommand=function(s) s:sleep(0.2):linear(0.2):addx(pn==PLAYER_1 and -700 or 700) end,
		-- };
	-- end;
-- end;

	if #GAMESTATE:GetEnabledPlayers() == 1 then
		t[#t+1] = LoadActor("frame", GAMESTATE:GetMasterPlayerNumber(),PLAYER_1,(GAMESTATE:GetMasterPlayerNumber() ~= PLAYER_1))..{
			InitCommand=cmd(xy,_screen.cx-172,_screen.cy+115;zoom,0.667);
		};
		t[#t+1] = LoadActor("frame", GAMESTATE:GetMasterPlayerNumber(),PLAYER_2,(GAMESTATE:GetMasterPlayerNumber() ~= PLAYER_2))..{
			InitCommand=cmd(xy,_screen.cx+172,_screen.cy+115;zoom,0.667);
		};
	else
		t[#t+1] = LoadActor("frame", PLAYER_1,PLAYER_1,false)..{
			InitCommand=cmd(xy,_screen.cx-172,_screen.cy+115;zoom,0.667);
		};
		t[#t+1] = LoadActor("frame", PLAYER_2,PLAYER_2,false)..{
			InitCommand=cmd(xy,_screen.cx+172,_screen.cy+115;zoom,0.667);
		};
	end
end;



-- if not ((StageIndex == FinalStage+1) or (StageIndex == FinalStage+2)) then
	-- t[#t+1] = LoadActor(THEME:GetPathG("","_shared/stars"))..{
		-- InitCommand=function(s) s:xy(_screen.cx,_screen.cy+184):zoom(0.667) end,
		-- OffCommand=function(s) s:linear(0.2):diffusealpha(0) end,
	-- };
-- end

-- if (GAMESTATE:HasEarnedExtraStage() and GAMESTATE:IsExtraStage()) then
	-- t[#t+1] = LoadActor("Extra");
-- elseif (GAMESTATE:HasEarnedExtraStage() and GAMESTATE:IsExtraStage2()) then
	-- t[#t+1] = LoadActor("Encore");
-- end





-- t[#t+1] = Def.ActorFrame{
    -- Name="songinfo",
    -- InitCommand=function(s) s:xy(_screen.cx,_screen.cy-40):zoom(0.667) end,
    -- OffCommand=function(s) s:linear(0.2):zoomy(0) end,
    -- Def.Sprite{ 
		-- Texture=THEME:GetPathG("","_shared/song info"), 
		-- InitCommand=function(s) s:setsize(300,47) end,
	-- };
    
-- };

return t;