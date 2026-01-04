local grade = Def.ActorFrame{}
local diff = Def.ActorFrame{};
local top

local function GetExpandedSectionIndex()
	local mWheel = SCREENMAN:GetTopScreen():GetMusicWheel()
	local curSections = mWheel:GetCurrentSections()
	for i=1, #curSections do
		if curSections[i] == GAMESTATE:GetExpandedSectionName() then
			return i-1
		end
	end
end

local function SetXYPosition(self, param)
	if GetExpandedSectionIndex() then
		local index = param.Index-1
		if index%3 == 0 then
			self:x(-225):y(105)
		elseif index%3 == 1 then
			self:x(0):y(0)
		else
			self:x(225):y(-105)
		end
	end
end

for i,pn in pairs(GAMESTATE:GetEnabledPlayers()) do 
	grade[#grade+1] = loadfile(THEME:GetPathG("MusicWheelItem","Song NormalPart/grade.lua"))(pn)..{
		--InitCommand=function(s) s: end,
	};
	diff[#diff+1] = loadfile(THEME:GetPathG("MusicWheelItem","Song NormalPart/diff.lua"))(pn)..{
		InitCommand=function(s) s:xy(pn == PLAYER_1 and -47 or 47,42) end,
	};
end;

return Def.ActorFrame{
	Def.ActorFrame{
		OnCommand = function(self)
			top = SCREENMAN:GetTopScreen()
		end;
		SetMessageCommand=function(self,params)
			local index = params.Index
			
			if index ~= nil then
				SetXYPosition(self, params)
				self:zoom(1.755);
				self:name(tostring(params.Index))
			end
		end;
	-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		Def.Sprite{
			Texture="normal",
			InitCommand=function(s) s:zoom(0.94) end,
		};
		grade;
		Def.Sprite{
			Texture="selected",
			InitCommand=function(s) s:zoom(0.94) end,
			SetCommand=function(s,p) 
				if p.Index ~= nil then
					s:visible(p.HasFocus)
				end
			end,
		};
		Def.Sprite{
			Texture="deco",
			InitCommand=function(s) s:y(83):setsize(120,6):texcoordvelocity(-0.2,0) end,
			SetCommand=function(s,p) 
				if p.Index ~= nil then
					s:visible(p.HasFocus)
				end
			end,
		};
		
		Def.Sprite{
			Name="Banner",
			InitCommand=function(s) s:xy(0,-26) end,
			SetMessageCommand=function(s,p)
				local song = p.Song;
				if song then
					s:LoadFromCached("Jacket",GetJacketPath(song))
				end
				s:setsize(115,115)
			end,
		};
		Def.BitmapText{
			Font="_wheelnames 28px",
			InitCommand=function(s) s:xy(-58,60):zoom(0.5):halign(0):maxwidth(235) end,
			SetMessageCommand=function(s,p)
				local song = p.Song
				if song then
					s:settext(GetSongName(song))
					if p.Index ~= nil then
						if p.HasFocus then
							s:diffuse(color("0,0,0,1"))
						else
							s:diffuse(SongAttributes.GetMenuColor(song))
						end
					end
				end
			end;
		};
		diff;
	};
}