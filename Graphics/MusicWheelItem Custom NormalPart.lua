return Def.ActorFrame {
	Def.Sprite{
		InitCommand=function(s) s:y(1):zoom(1.3) end,
		SetCommand=function(s,p) 
			if p.Index ~= nil then
				if p.HasFocus then
					s:Load(THEME:GetPathG("","MusicWheelItem/selected"))
				else
					s:Load(THEME:GetPathG("","MusicWheelItem/normal"))
				end
			end
		end,
	};
	Def.Sprite{
		Texture=THEME:GetPathG("","MusicWheelItem/deco"),
		InitCommand=function(s) s:y(45):setsize(680,15):texcoordvelocity(-0.2,0) end,
		SetCommand=function(s,p) 
			if p.Index ~= nil then
				s:visible(p.HasFocus)
			end
		end,
	};
	LoadFont("MusicWheelItem GroupNames")..{
		InitCommand=function(s) s:maxwidth(320):zoom(2) end,
		SetCommand=function(s,p) s:settext("COURSE MODE")
			if p.Index ~= nil then
				if p.HasFocus then
					s:diffuse(color("#000000"))
				else
					s:diffuse(color("#ffffff"))
				end
			end
		end,
	};
};
