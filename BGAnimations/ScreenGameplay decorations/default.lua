local t = Def.ActorFrame{};
local lastAnnouncer = ANNOUNCER:GetCurrentAnnouncer()

t[#t+1] = StatsEngine()

t[#t+1] = Def.Actor{
    AfterStatsEngineMessageCommand = function(_,params)
        local pn = params.Player
		local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)

        local aScore = params.Data.AScoring
		pss:SetScore(aScore.Score)
		pss:SetCurMaxScore(aScore.MaxScore)

        local fast, slow = 0, 0

        local fastSlow = params.Data.FastSlowRecord
			if fastSlow then
				fast = fastSlow.Fast
				slow = fastSlow.Slow
			end

        local short = ToEnumShortString(pn)
			setenv("numFast"..short, fast)
		setenv("numSlow"..short, slow)
	end,
};


t[#t+1] = Def.ActorFrame {
	Def.Actor {
		OffCommand=function(s)
			ANNOUNCER:SetCurrentAnnouncer('')
			s:sleep(BeginOutDelay()):queuecommand('Play')
		end,
		PlayCommand=function()
			local st = STATSMAN:GetCurStageStats()
			if lastAnnouncer then
				ANNOUNCER:SetCurrentAnnouncer(lastAnnouncer)
			end
			
			if st:AllFailed() then
				SOUND:PlayAnnouncer('gameplay failed')
			else
				SOUND:PlayAnnouncer('gameplay cleared')
			end
		end,
	},
	Def.Actor {
		NextCourseSongMessageCommand=function(s) s:stoptweening() end,
		CurrentSongChangedMessageCommand=function(s)
			if GAMESTATE:IsCourseMode() then
				local curStage = GAMESTATE:GetLoadingCourseSongIndex()+1
				if curStage > 1 then
					s:sleep(BeginReadyDelay()):queuecommand('Play')
				end
			end
		end,
		PlayCommand=function(s) SOUND:PlayAnnouncer('gameplay ready') end,
	},
	Def.Actor{
		NextCourseSongMessageCommand=function(s) s:sleep(2):queuecommand('Play') end,
		PlayCommand=function(s)
			local curStage = GAMESTATE:GetLoadingCourseSongIndex()+1
			local stageName = 'stage ' .. curStage
			local maxStages = GAMESTATE:GetCurrentCourse():GetEstimatedNumStages()
		
			if curStage == maxStages then
				stageName = 'stage final'
			end
			
			SOUND:PlayAnnouncer(stageName)
		end,
	},
};

for _, pn in ipairs(GAMESTATE:GetEnabledPlayers()) do	
	t[#t+1] = LoadActor("ScreenFilter",pn);
	t[#t+1] = LoadActor("Danger",pn);
end;

t[#t+1] = LoadActor("SongMeter")..{ InitCommand=function(s) s:draworder(99) end, };
t[#t+1] = LoadActor("ScoreFrame")..{ InitCommand=function(s) s:draworder(99) end, };

for _,pn in pairs(GAMESTATE:GetEnabledPlayers()) do
	t[#t+1] = LoadActor("lifeframe",pn);
	t[#t+1] = LoadActor(THEME:GetPathG("","OptionIcon"),pn)..{
		InitCommand=function(s) 
			s:zoom(0.667):draworder(1):xy(pn==PLAYER_1 and SCREEN_LEFT+23 or SCREEN_RIGHT-23,_screen.cy+165)
		end,
	};
	t[#t+1] = Def.Sprite{
	Condition=GAMESTATE:GetNumPlayersEnabled() == 2 and GAMESTATE:PlayerIsUsingModifier(pn,'battery'),
	Texture="GameOver"..ToEnumShortString(pn);
	InitCommand=function(s) s:visible(false):zoom(0.667) end,
	BobCommand=function(s) s:bob():effectmagnitude(0,10,0):effectperiod(1) end,
	HealthStateChangedMessageCommand= function(self, param)
		if param.PlayerNumber == pn then
			if param.HealthState == 'HealthState_Dead' then 
				if GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Current'):FailSetting() == 'FailType_Immediate' then
					if PREFSMAN:GetPreference("Center1Player") and GAMESTATE:GetNumPlayersEnabled() == 1 then
						self:x(_screen.cx)
					else
						self:x(pn == PLAYER_1 and ScreenGameplay_P1X() or ScreenGameplay_P2X())
					end
					self:y(_screen.cy)
				else
					self:xy(pn == PLAYER_1 and ScreenGameplay_P1X() or ScreenGameplay_P2X(),SCREEN_TOP+60)
				end
				self:visible(true):rotationz(360):linear(0.2):rotationz(0):queuecommand("Bob")
			end
		end
	end,
	NextCourseSongDelayMessageCommand=function(s)
		s:sleep(BeginOutDelay()):linear(0.2):diffusealpha(0)
	end,
	OffCommand=function(s)
		s:sleep(BeginOutDelay()):linear(0.2):diffusealpha(0)
	end,
	};
	t[#t+1] = LoadActor("Speed-Appearance",pn)..{ InitCommand=function(s) s:draworder(1) end, };
end






t[#t+1] = LoadActor("StageFrame")..{ InitCommand=function(s) s:draworder(1) end, };

if not GAMESTATE:IsDemonstration() then
	-- t[#t+1] = LoadActor("message")..{ InitCommand=function(s) s:draworder(99) end, };
	
	
	
	
	
	t[#t+1] = Def.Sprite{
	Texture=THEME:GetPathG("","_shared/message/READY"),
	InitCommand=function(s) s:Center():zoom(1.5):decelerate(0.3):zoom(0.667):draworder(99) end,
	CurrentSongChangedMessageCommand=function(s) s:sleep(BeginReadyDelay()+SongMeasureSec()-0.3):decelerate(0.3):zoom(0)end,
};	

t[#t+1] = Def.Sprite{
	Texture=THEME:GetPathG("","_doors/circle.png"),
	InitCommand=function(s) s:Center():zoom(2):draworder(99) end,
	OnCommand=function(s) s:decelerate(0.3):zoom(0) end, 
};
	
	t[#t+1] = loadfile(THEME:GetPathB("ScreenGameplay","out/_doors"))() .. {
		InitCommand=function(s) s:draworder(99) end,
		OffCommand=function(s)
		local st = STATSMAN:GetCurStageStats()
			-- delay before shutter close
			s:sleep(BeginOutDelay())
			if st:AllFailed() then
				s:queuecommand("AnimFailedClose")
			else
				s:queuecommand("AnimClose")
			end
		end,
	};
	-- t[#t+1] = loadfile(THEME:GetPathB("ScreenStageInformation","decorations/_doors"))()..{
		-- InitCommand=function(s) s:draworder(99) end,
		-- NextCourseSongMessageCommand=function(s) s:playcommand("AnimClose") end,
		-- CurrentSongChangedMessageCommand=function(s) s:playcommand("AnimOpen") end,
	-- };
	
	-- t[#t+1] = Def.ActorFrame {
		-- InitCommand=function(s) s:x(_screen.cx):y(_screen.cy+12):draworder(99) end,
		-- Def.ActorFrame {
			-- BeginCommand=function(s)
				-- s:GetChild('Actual Jacket'):Load(GetJacketPath(GetSong())):setsize(300,300)
			-- end,
			-- NextCourseSongMessageCommand=function(s)
				-- s:GetChild('Actual Jacket'):Load(GetJacketPath(GetSong())):setsize(300,300)
				-- s:finishtweening():diffusealpha(0):zoom(1):sleep(1.85):linear(0.2):diffusealpha(1)
			-- end,
			-- CurrentSongChangedMessageCommand=function(s)
				-- s:sleep(BeginReadyDelay()):linear(0.06):zoom(1.5):diffusealpha(0)
			-- end,
			-- Def.Sprite { Name='Actual Jacket', },
		-- },
	-- };
end

return t