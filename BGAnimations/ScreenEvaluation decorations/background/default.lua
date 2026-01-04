local function CharSprite(side, x)
	return LoadActor(THEME:GetPathG("", "Premium Customizer/character/eval/"..side.."/"..ThemePrefs.Get("Character"..side)))..{
		InitCommand=function(s) s:zoom(0.667):xy(_screen.cx+x,_screen.cy) end,
		OnCommand=function(s)
			local ex = 300
			local des = 0.7
			local ful = 1
			local off = 0
			if side=="P1" then 
				s:addx(-ex):decelerate(des):addx(ex)
			else 
				s:addx(ex):decelerate(des):addx(-ex)
			end
		end
	}
end

return Def.ActorFrame{
	Def.Quad{ 
		InitCommand=function(s) s:FullScreen():diffuse(color("#ebebeb")) end 
	},
	CharSprite("P1", -214),
	CharSprite("P2", 213.5),
	LoadActor("tri_up")..{ 
		InitCommand=function(s) s:xy(_screen.cx,_screen.cy-87):zoom(0.667) end 
	},
	LoadActor("tex")..{ 
		InitCommand=function(s) 
		s:zoom(0.667):xy(_screen.cx-33,_screen.cy-195)
		s:rotationz(-45):texcoordvelocity(0.03,0):cropleft(0.44) 
		end 
	},
	LoadActor("tri_down")..{ 
		InitCommand=function(s) s:xy(_screen.cx,_screen.cy+87):zoom(0.667) end 
	}
}
