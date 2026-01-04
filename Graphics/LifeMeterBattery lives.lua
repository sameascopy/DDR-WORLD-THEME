local pn = Var "Player"
local x = -3.94
local y = 1
local zx = 276
local zy = 25

return Def.ActorFrame{
	InitCommand=function(s) s:x(pn==PLAYER_1 and 0 or 2) end,
	-- Def.Sprite{
		-- Texture=THEME:GetPathB("ScreenGameplay","decorations/lifeframe/stream/ex"),
		-- InitCommand=function(s)
			-- s:setsize(zx,zy)
			-- s:xy(x,y)
		-- end;
	-- };
	-- Def.Sprite{
		-- Texture=THEME:GetPathB("ScreenGameplay","decorations/lifeframe/stream/effex"),
		-- InitCommand=function(s)
			-- s:blend('BlendMode_Add')
			-- s:texcoordvelocity(-1,0)
			-- s:setsize(zx,35)
			-- s:xy(x,y)
		-- end;
	-- };
	Def.Sprite{
		Texture=THEME:GetPathB("ScreenGameplay","decorations/lifeframe/stream/full"),
		InitCommand=function(s)
			s:texcoordvelocity(-0.6,0)
			s:setsize(zx,zy)
			s:xy(x,y)
		end;
		BeginCommand=function(s,p)
			local screen = SCREENMAN:GetTopScreen();
			local glifemeter = screen:GetLifeMeter(pn);
			if glifemeter:GetTotalLives() == 1 then
				s:Load(THEME:GetPathB("","ScreenGameplay decorations/lifeframe/stream/danger"));
				s:setsize(zx,zy)
			end
		end,
		LifeChangedMessageCommand=function(s,p)
			if (not p.LostLife) or (not p.Player == pn) then
				return;
			end;

			if p.LivesLeft == 1 then
				s:Load(THEME:GetPathB("","ScreenGameplay decorations/lifeframe/stream/danger"));
				s:setsize(zx,zy)
			else
				s:Load(THEME:GetPathB("","ScreenGameplay decorations/lifeframe/stream/normal"));
				s:setsize(zx,zy)
			end;
		end;
	};
	Def.Quad{
		InitCommand=function(s) s:diffuse(color("#1b1b19")):xy(135,y):horizalign(right) end,
		BeginCommand=function(s)
			local screen = SCREENMAN:GetTopScreen();
			local glifemeter = screen:GetLifeMeter(pn);
			assert(glifemeter);
			if glifemeter:GetTotalLives() == 4 then
				s:zoomto(0,zy);
			elseif glifemeter:GetTotalLives() == 1 then
				s:zoomto(205,zy);
			end
		end;
		LifeChangedMessageCommand=function(s,p)
		if p.Player ~= pn then return end;
			s:finishtweening();
			if p.LivesLeft == 4 then 
				s:zoomto(0,zy);
			elseif p.LivesLeft == 3 then
				s:zoomto(66,zy);
			elseif p.LivesLeft == 2 then
				s:zoomto(136,zy);
			elseif p.LivesLeft == 1 then
				s:zoomto(205,zy);
			elseif p.LivesLeft == 0 then
				s:zoomto(zx,zy);
			end;
		end;
	};
	
};