local pn = ...

return Def.ActorFrame{
	Def.Sprite{
		InitCommand=function(self) self:zoom(0.94)
			if #(GAMESTATE:GetHumanPlayers()) == 2 then
				if pn == PLAYER_1 then
					self:cropright(0.5);
				elseif pn == PLAYER_2 then
					self:cropleft(0.5);
				end;
			end;
		end;
		SetCommand=function(self,param)
			if not GAMESTATE:IsCourseMode() then
				self.cur_song = param.Song;
				self:queuecommand "DiffChange";
			end
		end;
		DiffChangeCommand=function(self)
			local st = GAMESTATE:GetCurrentStyle():GetStepsType();
			local diff = GAMESTATE:GetCurrentSteps(pn):GetDifficulty();
			if self.cur_song then
				if self.cur_song:HasStepsTypeAndDifficulty(st,diff) then
					local steps = self.cur_song:GetOneSteps( st, diff );
					local profile
					if PROFILEMAN:IsPersistentProfile(pn) then
						profile = PROFILEMAN:GetProfile(pn);
					else
						profile = PROFILEMAN:GetMachineProfile();
					end;
					local scorelist = profile:GetHighScoreList(self.cur_song,steps);
					assert(scorelist);
					local scores = scorelist:GetHighScores();
					assert(scores);
					local topscore=0;
					if scores[1] then
						topscore = scores[1];
						assert(topscore);
						local misses = topscore:GetTapNoteScore("TapNoteScore_Miss")
									  +topscore:GetTapNoteScore("TapNoteScore_CheckpointMiss")
									  +topscore:GetTapNoteScore("TapNoteScore_HitMine")
									  +topscore:GetTapNoteScore("TapNoteScore_W5")
						local goods = topscore:GetTapNoteScore("TapNoteScore_W4")
						local greats = topscore:GetTapNoteScore("TapNoteScore_W3")
						local perfects = topscore:GetTapNoteScore("TapNoteScore_W2")
						local marvelous = topscore:GetTapNoteScore("TapNoteScore_W1")
						local hasUsedBattery = string.find(topscore:GetModifiers(),"Lives")
						if (misses) == 0 and scores[1]:GetScore() > 0 and (marvelous+perfects)>0 then
							if (greats+perfects) == 0 then
								self:Load(THEME:GetPathG("MusicWheelItem Song NormalPart/lamp/ClearedMark","MFC"))
							elseif greats == 0 then
								self:Load(THEME:GetPathG("MusicWheelItem Song NormalPart/lamp/ClearedMark","PFC"))
							elseif (misses+goods) == 0 then
								self:Load(THEME:GetPathG("MusicWheelItem Song NormalPart/lamp/ClearedMark","GreatFC"))
							elseif (misses) == 0 then
								self:Load(THEME:GetPathG("MusicWheelItem Song NormalPart/lamp/ClearedMark","GoodFC"))
							end;
							self:visible(true)
						else
							if topscore:GetGrade() ~= 'Grade_Failed' then
								if hasUsedBattery then
									self:visible(true)
									self:Load(THEME:GetPathG("MusicWheelItem Song NormalPart/lamp/ClearedMark","Risky"))
								else
									self:visible(true)
									self:Load(THEME:GetPathG("MusicWheelItem Song NormalPart/lamp/ClearedMark","LifeBar"))
								end
							else
								self:visible(true)
								self:Load(THEME:GetPathG("MusicWheelItem Song NormalPart/lamp/ClearedMark","Failed"))
							end
						end;
					else
						self:visible(false)
					end;
                else
					self:visible(false)
				end;
            else
                self:visible(false)
            end;
        end;
    };
};