local pn =...

local function setDiff(self,param)
	local st = GAMESTATE:GetCurrentStyle():GetStepsType()
	if self.ParamSong then
		local steps = GAMESTATE:GetCurrentSteps(pn)
		if steps then
			local sDiff = steps:GetDifficulty()
			local diff = self.ParamSong:GetOneSteps(st,sDiff)
			local diffname = GAMESTATE:GetCurrentSteps(pn):GetDifficulty()
			if diff then
				self:settext(diff:GetMeter())
				self:diffuse(CustomDifficultyToColor(diffname));
				self:visible(true)
			else
				self:settext("")
				self:diffuse(color("1,1,1,0"))
			end
		else
			self:settext("")
			self:diffuse(color("1,1,1,0"))
		end
	end
end

return Def.BitmapText{
	InitCommand=function(s) s:zoom(0.55) end,
	Font="_commador extended 32px";
	SetCommand=function(self,param)
		self.ParamSong = param.Song
		setDiff(self)
	end;
	CurrentStepsP1ChangedMessageCommand=function(self) setDiff(self) end;
	CurrentStepsP2ChangedMessageCommand=function(self) setDiff(self) end;
	CurrentSongChangedMessageCommand=function(self) setDiff(self) end;
};
