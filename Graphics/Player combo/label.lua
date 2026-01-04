local c;
local cf;
local player = Var "Player";
local ShowComboAt = THEME:GetMetric("Combo", "ShowComboAt");
local PulseLabel = THEME:GetMetric("Combo", "PulseLabelCommand");
local LabelZoom = THEME:GetMetric("Combo", "LabelZoom");
local LabelCommand = cmd(horizalign,right;vertalign,bottom;xy,52,6);
local xxState;

--you can pass nil to this function, it acts the same as passing nothing
--however, i think that passing nil makes the intent clearer -tertu
local function cfShowOnly(...)
	local cfMembersToShow = {...}

	--build an inverse version of the argument table to speed up lookup
	local cfMTSInv = {}
	for _, name in pairs(cfMembersToShow) do
		cfMTSInv[name] = true
	end

	for name, a in pairs(cf) do
		--"if the name of this actor was passed, make it visible, otherwise
		--hide it"
		a:visible(cfMTSInv[name] == true)
	end
end

local t = Def.ActorFrame {
	Def.ActorFrame {
		Name="ComboFrame";
		Def.Sprite{
			Name="LabelW1";
			Texture="combo",
			InitCommand=function(s) s:pause():setstate(0) end,
			OnCommand = LabelCommand
		};
		Def.Sprite{
			Name="LabelW2";
			Texture="combo",
			InitCommand=function(s) s:pause():setstate(1) end,
			OnCommand = LabelCommand
		};
		Def.Sprite{
			Name="LabelW3";
			Texture="combo",
			InitCommand=function(s) s:pause():setstate(2) end,
			OnCommand = LabelCommand
		};
		Def.Sprite{
			Name="LabelW4";
			Texture="combo",
			InitCommand=function(s) s:pause():setstate(3) end,
			OnCommand = LabelCommand
		};
		Def.Sprite{
			Name="LabelNormal";
			Texture="combo",
			InitCommand=function(s) s:pause():setstate(4) end,
			OnCommand = LabelCommand
		};
	};
	InitCommand = function(self)
		c = self:GetChildren();
		cf = c.ComboFrame:GetChildren();
		-- Inclu
		cfShowOnly(nil);
	end;
	ComboCommand=function(self, param)
		if not xxState then
			cfShowOnly(nil);
			return;
		end
		if param.Misses then
			cfShowOnly(nil);
			return;
		end
		local iCombo = param.Combo;
		if not iCombo or iCombo < ShowComboAt then
			cfShowOnly(nil);
			return;
		end
		
		local Label = xxState.Label

		param.LabelZoom = scale( iCombo, 0, 4, LabelZoom, LabelZoom );
		param.LabelZoom = clamp( param.LabelZoom, LabelZoom, LabelZoom);

		cfShowOnly(Label);

		-- Pulse
		PulseLabel( cf[Label], param)
		
	end;
	AfterStatsEngineMessageCommand=function(s, param)
		if param.Player ~= player then return end;
		xxState = param.Data.XXComboState;
	end;
};

return t;