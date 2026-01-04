local c;
local cf;
local player = Var "Player";
local ShowComboAt = THEME:GetMetric("Combo", "ShowComboAt");
local Pulse = THEME:GetMetric("Combo", "PulseCommand");
local NumberZoom = THEME:GetMetric("Combo", "NumberZoom");
local NumberCommand = THEME:GetMetric("Combo", "NumberCommand");
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
		Def.BitmapText{
			Name="NumberW1";
			Font="combo marv_c",
			OnCommand = NumberCommand
		};
		Def.BitmapText{
			Name="NumberW2";
			Font="combo perf_c",
			OnCommand = NumberCommand
		};
		Def.BitmapText{
			Name="NumberW3";
			Font="combo great_c",
			OnCommand = NumberCommand
		};
		Def.BitmapText{
			Name="NumberW4";
			Font="combo good_c",
			OnCommand = NumberCommand
		};
		Def.BitmapText{
			Name="NumberNormal";
			Font="combo normal",
			OnCommand = NumberCommand
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

		local Number = xxState.Number;

		--Number
		param.Zoom = scale( iCombo, 0, 4, NumberZoom, NumberZoom );
		param.Zoom = clamp( param.Zoom, NumberZoom, NumberZoom );

		cfShowOnly(Number);
		
		cf[Number]:stoptweening()
		
		local iCombo_str = string.format("%04d", tostring(iCombo))
		local iCombo_digits = {}
		for i = 1, #iCombo_str do
			iCombo_digits[i] = tonumber(string.sub(iCombo_str, i, i))
		end
		
		cf[Number]:settext( string.format("%i", iCombo_digits[3])  )
		cf[Number]:visible(false)
		
		if iCombo > 9 then
			cf[Number]:visible(true)
			cf[Number]:xy(-6,-13)
		end
		if iCombo > 99 then
			cf[Number]:xy(5,-14)
		end
		if iCombo > 999 then
			cf[Number]:xy(26,-18)
		end
		-- Pulse
		Pulse( cf[Number], param );
	end;
	AfterStatsEngineMessageCommand=function(s, param)
		if param.Player ~= player then return end;
		xxState = param.Data.XXComboState;
	end;
};

return t;