local pn = ...
local Risky = GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Current'):LifeSetting() == 'LifeType_Battery'
local sizex = 273
local sizey = 25

return Def.ActorFrame{
    InitCommand=function(s)
        s:xy(pn==PLAYER_1 and _screen.cx-231 or _screen.cx+233, SCREEN_TOP+23):draworder(99)
    end,
    Name="LifeFrame",
	Def.Sprite{
        Texture=THEME:GetPathB("","ScreenGameplay decorations/lifeframe/stream/base"),
		InitCommand=function(s) s:xy(pn==PLAYER_1 and -9 or 11,2):zoom(0.667):diffusealpha(Risky and 0 or 1) end,
	};
	Def.Sprite{
		Texture=THEME:GetPathB("","ScreenGameplay decorations/lifeframe/stream/normal"),
		InitCommand=function(s) s:xy(pn==PLAYER_1 and -11 or 8,2):setsize(sizex,sizey) end,
        OnCommand=function(s) 
			s:MaskDest()
			s:ztestmode("ZTestMode_WriteOnFail")
			s:texcoordvelocity(0.6,0)
        end,
        HealthStateChangedMessageCommand=function(self, param) self:setsize(sizex,sizey)
			if param.PlayerNumber == pn then
				if param.HealthState == "HealthState_Danger" then
					self:Load(THEME:GetPathB("","ScreenGameplay decorations/lifeframe/stream/danger"))
					self:setsize(sizex,sizey)
				elseif param.HealthState == "HealthState_Hot" then
					self:Load(THEME:GetPathB("","ScreenGameplay decorations/lifeframe/stream/full"))
					self:setsize(sizex,sizey)
		  		else
					self:Load(THEME:GetPathB("","ScreenGameplay decorations/lifeframe/stream/normal"))
					self:setsize(sizex,sizey)
		  		end;
			end;
			self:setsize(sizex,sizey)
		end;
    };
	Def.Sprite{
        Name="LifeFrame"..pn,
        InitCommand=function(s) s:xy(pn==PLAYER_1 and -9 or 9,2):zoom(0.667) end,
        BeginCommand=function(self)
			if Risky then
				self:Load(THEME:GetPathB("ScreenGameplay","decorations/lifeframe/life"))  
				--self:Load(THEME:GetPathB("ScreenGameplay","decorations/lifeframe/normal"))  
			else
				self:Load(THEME:GetPathB("ScreenGameplay","decorations/lifeframe/normal"))
			end;
        end
    };
};