local StageDisplay = Def.ActorFrame{
	BeginCommand=function(s) s:playcommand("Set") end,
	CurrentSongChangedMessageCommand=function(s) s:finishtweening():playcommand("Set") end,
};

if GAMESTATE:IsCourseMode() then
	StageDisplay[#StageDisplay+1] = LoadFont("_impact 32px")..{
		Text="",
		SetCommand=function(self)
			local CourseIndex = GAMESTATE:GetCourseSongIndex()+1
			local TrailEntries = #GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber()):GetTrailEntries()
			if CourseIndex == TrailEntries then 
				self:settext("FINAL")
			else
				self:settext(FormatNumberAndSuffix(tostring(CourseIndex)))
			end
		end,
		DoneLoadingNextSongMessageCommand=function(s) s:queuecommand("Set") end,
	};
else
	StageDisplay[#StageDisplay+1] = LoadFont("_gibson bold") .. {
		SetCommand=function(self)
			if GAMESTATE:GetCurrentSong():GetDisplayFullTitle() == "LET'S CHECK YOUR LEVEL!" then
				self:settextf("CHECKING")
			elseif GAMESTATE:GetCurrentSong():GetDisplayFullTitle() == "Lesson by DJ" then
				self:settextf("HOW TO PLAY")
			elseif GAMESTATE:IsDemonstration() then
				self:settextf("");
			elseif GAMESTATE:IsEventMode() then
				self:settextf("EVENT");
			else
				local thed_stage= thified_curstage_index(false)
				if thed_stage == "Extra1" then
					thed_stage = "EXTRA";
				elseif thed_stage == "Extra2" then
					thed_stage = "ENCORE EXTRA"
				end
				if string.len(thed_stage) >= 5 then
					thed_stage=string.upper(thed_stage);
				end
				self:settextf(thed_stage)
			end
			self:maxwidth(135)
		end;
	};
end

return Def.ActorFrame {
	Def.Sprite{
		InitCommand=function(s) s:xy(_screen.cx,SCREEN_TOP+10):zoom(0.667):queuecommand("Set") end,
		SetCommand=function(s) 
			if GAMESTATE:IsDemonstration() then
				s:Load(THEME:GetPathB("ScreenGameplay","decorations/StageFrame/demo"))
			else
				s:Load(THEME:GetPathB("ScreenGameplay","decorations/StageFrame/gameplay"))
			end
		end,
	};
	StageDisplay..{
		InitCommand=function(s) 
			s:zoomx(0.57):zoomy(0.53):x(_screen.cx):y(SCREEN_TOP+22):diffuse(color("1,1,1,1"))
		end,
	};
};