function OptionRowAppearancePlus()
	local t = {
		Name="AppearancePlus",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = { "Visible", 'Hidden', 'Sudden', 'Stealth', 'Hidden+', 'Sudden+', 'Hidden+&Sudden+', },
		LoadSelections = function(self, list, pn)
			local AppearancePlusValue = "Visible";
			local pf = PROFILEMAN:GetProfile(pn);
			local PlayerUID = "";
			
			if pf then 
				PlayerUID = pf:GetGUID()  
				AppearancePlusValue = ReadOrCreateAppearancePlusValueForPlayer(PlayerUID,AppearancePlusValue);
			else
				PlayerUID = "UnknownPlayerUID"
				AppearancePlusValue = "Visible";
			end
			
			if AppearancePlusValue ~= nil then
				if AppearancePlusValue == "Hidden" then
					list[2] = true
				elseif AppearancePlusValue == "Sudden" then
					list[3] = true
				elseif AppearancePlusValue == "Stealth" then
					list[4] = true
				elseif AppearancePlusValue == "Hidden+" then
					list[5] = true
				elseif AppearancePlusValue == "Sudden+" then
					list[6] = true
				elseif AppearancePlusValue == "Hidden+&Sudden+" then
					list[7] = true
				else
					list[1] = true
				end
			else
				SaveAppearancePlusValueForPlayer(PlayerUID,"Visible")
				list[1] = true
			end
			
		end,
		SaveSelections = function(self, list, pn)
			local pName = ToEnumShortString(pn)
			local found = false
			local PlayerUID = "";
			local pf = PROFILEMAN:GetProfile(pn);
			
			if pf then 
				PlayerUID = pf:GetGUID()  
			else
				PlayerUID = "UnknownPlayerUID"
			end
			
			for i=1,#list do
				if not found then
					if list[i] == true then
						local val = "Visible";
						if i==2 then
							val = "Hidden";
						elseif i==3 then
							val = "Sudden";
						elseif i==4 then
							val = "Stealth";
						elseif i==5 then
							val = "Hidden+";
						elseif i==6 then
							val = "Sudden+";
						elseif i==7 then
							val = "Hidden+&Sudden+";
						else
							val = "Visible";
						end
						setenv("AppearancePlus"..pName,val)
						SaveAppearancePlusValueForPlayer(PlayerUID,val)
						found = true
						break;
					end
				end
			end
		end,
	};
	setmetatable(t, t)
	return t
end

function OptionRowFastSlow()
	local t = {
		Name = "FastSlow";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true,
		Choices = {"Off", "On", };
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("OptionRowFastSlow") ~= nil then
				if GetUserPref("OptionRowFastSlow")=='Off' then
					list[1] = true
				elseif GetUserPref("OptionRowFastSlow")=='On' then
					list[2] = true
				else
					list[2] = true
				end
			else
				WritePrefToFile("OptionRowFastSlow",'On');
				list[1] = true;
			end;
		end;
		SaveSelections = function(self, list, pn)
			if list[1] then
				WritePrefToFile("OptionRowFastSlow",'Off');
			elseif list[2] then
				WritePrefToFile("OptionRowFastSlow",'On');
			else
				WritePrefToFile("OptionRowFastSlow",'On');
			end;
		end;
	};
	setmetatable( t, t );
	return t;
end

function OptionRowLanguage()
	local t = {
		Name = "Language";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		Choices = {"jp", "en", "kor", };
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("OptionRowLanguage") ~= nil then
				if GetUserPref("OptionRowLanguage")=='jp' then
					list[1] = true
				elseif GetUserPref("OptionRowLanguage")=='en' then
					list[2] = true
				elseif GetUserPref("OptionRowLanguage")=='kor' then
					list[3] = true
				else
					list[1] = true
				end
			else
				WritePrefToFile("OptionRowLanguage",'en');
				list[1] = true;
			end;
		end;
		SaveSelections = function(self, list, pn)
			if list[1] then
				WritePrefToFile("OptionRowLanguage",'jp');
			elseif list[2] then
				WritePrefToFile("OptionRowLanguage",'en');
			elseif list[3] then
				WritePrefToFile("OptionRowLanguage",'kor');
			else
				WritePrefToFile("OptionRowLanguage",'en');
			end;
		end;
	};
	setmetatable( t, t );
	return t;
end

function OptionRowComboUnderField()
	local t = {
		Name = "ComboUnderField";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		Choices = {"Background", "Foreground", };
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("OptionRowComboUnderField") ~= nil then
				if GetUserPref("OptionRowComboUnderField")=='true' then
					list[1] = true
				elseif GetUserPref("OptionRowComboUnderField")=='false'then
					list[2] = true
				else
					list[1] = true
				end
			else
				WritePrefToFile("OptionRowComboUnderField",true);
				list[1] = true;
			end;
		end;
		SaveSelections = function(self, list, pn)
			if list[1] then
				WritePrefToFile("OptionRowComboUnderField",true);
			elseif list[2] then
				WritePrefToFile("OptionRowComboUnderField",false);
			else
				WritePrefToFile("OptionRowComboUnderField",true);
			end;
			THEME:ReloadMetrics();
		end;
	};
	setmetatable( t, t );
	return t;
end

function OptionRowGuideLines()
	local t = {
		Name = "GuideLines";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		Choices = {"Off", "On", };
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("OptionRowGuideLines") ~= nil then
				if GetUserPref("OptionRowGuideLines")=='true' then
					list[2] = true
				elseif GetUserPref("OptionRowGuideLines")=='false' then
					list[1] = true
				else
					list[2] = true
				end
			else
				WritePrefToFile("OptionRowGuideLines",true);
				list[2] = true;
			end;
		end;
		SaveSelections = function(self, list, pn)
			if list[2] then
				WritePrefToFile("OptionRowGuideLines",true);
			elseif list[1] then
				WritePrefToFile("OptionRowGuideLines",false);
			else
				WritePrefToFile("OptionRowGuideLines",true);
			end;
			THEME:ReloadMetrics();
		end;
	};
	setmetatable( t, t );
	return t;
end

function OptionRowShockArrows()
	local t = {
		Name = "ShockArrows";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		Choices = {"Off", "On", };
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("OptionRowShockArrows") ~= nil then
				if GetUserPref("OptionRowShockArrows")=='false' then
					list[1] = true
				elseif GetUserPref("OptionRowShockArrows")=='true' then
					list[2] = true
				else
					list[1] = true
				end
			else
				WritePrefToFile("OptionRowShockArrows",false);
				list[1] = true;
			end;
		end;
		SaveSelections = function(self, list, pn)
			if list[1] then
				WritePrefToFile("OptionRowShockArrows",false);
			elseif list[2] then
				WritePrefToFile("OptionRowShockArrows",true);
			else
				WritePrefToFile("OptionRowShockArrows",false);
			end;
			THEME:ReloadMetrics();
		end;
	};
	setmetatable( t, t );
	return t;
end

function OptionRowScreenFilter()
    local choices = {}
    for i = 0, 10 do
        table.insert(choices, string.format("%.1f", i/10))
    end

    local t = {
        Name = "ScreenFilter",
        LayoutType = "ShowAllInRow",
        SelectType = "SelectOne",
        OneChoiceForAllPlayers = false,
        ExportOnChange = true,
        Choices = choices,

        LoadSelections = function(self, list, pn)
            local pName = ToEnumShortString(pn)
            local pref = GetUserPref("OptionRowScreenFilter"..pName) or "0"
            
            local found = false
            for i, v in ipairs(self.Choices) do
                if v == pref then
                    list[i] = true
                    found = true
                    break
                end
            end
            
            if not found then
                list[1] = true -- default 0
            end
        end,

        SaveSelections = function(self, list, pn)
            local pName = ToEnumShortString(pn)
            for i, v in ipairs(self.Choices) do
                if list[i] then
                    SetUserPref("OptionRowScreenFilter"..pName, v)
                    return
                end
            end
            SetUserPref("OptionRowScreenFilter"..pName, "1")
        end,
    }

    setmetatable(t, t)
    return t
end



function OptionRowBPM()
	local t = {
		Name = "BPM";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		Choices = {"Name", "BPM", };
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("OptionRowBPM") ~= nil then
				if GetUserPref("OptionRowBPM")=='Name' then
					list[1] = true
				elseif GetUserPref("OptionRowBPM")=='BPM' then
					list[2] = true
				else
					list[1] = true
				end
			else
				WritePrefToFile("OptionRowBPM",'Name');
				list[1] = true;
			end;
		end;
		SaveSelections = function(self, list, pn)
			if list[1] then
				WritePrefToFile("OptionRowBPM",'Name');
			elseif list[2] then
				WritePrefToFile("OptionRowBPM",'BPM');
			else
				WritePrefToFile("OptionRowBPM",'Name');
			end;
		end;
	};
	setmetatable( t, t );
	return t;
end

function OptionRowSpeedDisplay()
	local t = {
		Name = "SpeedDisplay";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		Choices = {"Off" ,"On" };
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("OptionRowSpeedDisplay") ~= nil then
				if GetUserPref("OptionRowSpeedDisplay")=='Off' then
					list[1] = true
				elseif GetUserPref("OptionRowSpeedDisplay")=='On' then
					list[2] = true
				else
					list[1] = true
				end
			else
				WritePrefToFile("OptionRowSpeedDisplay",'Off');
				list[1] = true;
			end;
		end;
		SaveSelections = function(self, list, pn)
			if list[1] then
				WritePrefToFile("OptionRowSpeedDisplay",'Off');
			elseif list[2] then
				WritePrefToFile("OptionRowSpeedDisplay",'On');
			else
				WritePrefToFile("OptionRowSpeedDisplay",'Off');
			end;
		end;
	};
	setmetatable( t, t );
	return t;
end

function OptionRowModel()
	local t = {
		Name = "Model";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = false;
		Choices = {"Gold", "White", };
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("OptionRowModel") ~= nil then
				if GetUserPref("OptionRowModel")=='Gold' then
					list[1] = true
				elseif GetUserPref("OptionRowModel")=='White' then
					list[2] = true
				else
					list[1] = true
				end
			else
				WritePrefToFile("OptionRowModel",'Gold');
				list[1] = true;
			end;
		end;
		SaveSelections = function(self, list, pn)
			if list[1] then
				WritePrefToFile("OptionRowModel",'Gold');
			elseif list[2] then
				WritePrefToFile("OptionRowModel",'White');
			else
				WritePrefToFile("OptionRowModel",'Gold');
			end;
		end;
	};
	setmetatable( t, t );
	return t;
end

function OptionRowLogo()
	local t = {
		Name = "Logo";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true,
		Choices = {"ARCADE", "GRANDPRIX", };
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("OptionRowLogo") ~= nil then
				if GetUserPref("OptionRowLogo")=='ARCADE' then list[1] = true
				elseif GetUserPref("OptionRowLogo")=='GRANDPRIX' then list[2] = true
				else list[2] = true
				end
			else
				WritePrefToFile("OptionRowLogo",'ARCADE'); list[1] = true;
			end;
		end;
		SaveSelections = function(self, list, pn)
			if list[1] then WritePrefToFile("OptionRowLogo",'ARCADE');
			elseif list[2] then WritePrefToFile("OptionRowLogo",'GRANDPRIX');
			else WritePrefToFile("OptionRowLogo",'ARCADE');
			end;
		end;
	};
	setmetatable( t, t );
	return t;
end

function OptionRowGoldenLeague()
	local t = {
		Name = "GoldenLeague";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = false;
		Choices = {"Off" ,"Bronze", "Silver", "Gold" };
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("OptionRowGoldenLeague") ~= nil then
				if GetUserPref("OptionRowGoldenLeague")=='Off' then
					list[1] = true
				elseif GetUserPref("OptionRowGoldenLeague")=='Bronze' then
					list[2] = true
				elseif GetUserPref("OptionRowGoldenLeague")=='Silver' then
					list[3] = true
				elseif GetUserPref("OptionRowGoldenLeague")=='Gold' then
					list[4] = true
				else
					list[1] = true
				end
			else
				WritePrefToFile("OptionRowGoldenLeague",'Off');
				list[1] = true;
			end;
		end;
		SaveSelections = function(self, list, pn)
			if list[1] then
				WritePrefToFile("OptionRowGoldenLeague",'Off');
			elseif list[2] then
				WritePrefToFile("OptionRowGoldenLeague",'Bronze');
			elseif list[3] then
				WritePrefToFile("OptionRowGoldenLeague",'Silver');
			elseif list[4] then
				WritePrefToFile("OptionRowGoldenLeague",'Gold');
			else
				WritePrefToFile("OptionRowGoldenLeague",'Off');
			end;
		end;
	};
	setmetatable( t, t );
	return t;
end

function OptionRowBGM()
	local t = {
		Name = "BGM";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		Choices = {"On", "Off", };
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("OptionRowBGM") ~= nil then
				if GetUserPref("OptionRowBGM")=='On' then
					list[1] = true
				elseif GetUserPref("OptionRowBGM")=='Off' then
					list[2] = true
				else
					list[1] = true
				end
			else
				WritePrefToFile("OptionRowBGM",'On');
				list[1] = true;
			end;
		end;
		SaveSelections = function(self, list, pn)
			if list[1] then
				WritePrefToFile("OptionRowBGM",'On');
			elseif list[2] then
				WritePrefToFile("OptionRowBGM",'Off');
			else
				WritePrefToFile("OptionRowBGM",'On');
			end;
			THEME:ReloadMetrics();
		end;
	};
	setmetatable( t, t );
	return t;
end

function OptionRowJudgementAnimation()
	local t = {
		Name = "JudgementAnimation";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		Choices = {"Normal", "Simple", };
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("OptionRowJudgementAnimation") ~= nil then
				if GetUserPref("OptionRowJudgementAnimation")=='Normal' then
					list[1] = true
				elseif GetUserPref("OptionRowJudgementAnimation")=='Simple' then
					list[2] = true
				else
					list[1] = true
				end
			else
				WritePrefToFile("OptionRowJudgementAnimation",'Normal');
				list[1] = true;
			end;
		end;
		SaveSelections = function(self, list, pn)
			if list[1] then
				WritePrefToFile("OptionRowJudgementAnimation",'Normal');
			elseif list[2] then
				WritePrefToFile("OptionRowJudgementAnimation",'Simple');
			else
				WritePrefToFile("OptionRowJudgementAnimation",'Normal');
			end;
			THEME:ReloadMetrics();
		end;
	};
	setmetatable( t, t );
	return t;
end

function OptionRowDanCourse()
	local t = {
		Name = "DanCourse";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = false;
		Choices = {"None" ,"1st", "2nd", "3rd", "4th", "5th", "6th", "7th", "8th", "9th", "10th", "Kaiden", };
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("OptionRowDanCourse") ~= nil then
				if GetUserPref("OptionRowDanCourse")=='None' then
					list[1] = true
				elseif GetUserPref("OptionRowDanCourse")=='1st' then
					list[2] = true
				elseif GetUserPref("OptionRowDanCourse")=='2nd' then
					list[3] = true
				elseif GetUserPref("OptionRowDanCourse")=='3rd' then
					list[4] = true
				elseif GetUserPref("OptionRowDanCourse")=='4th' then
					list[5] = true
				elseif GetUserPref("OptionRowDanCourse")=='5th' then
					list[6] = true
				elseif GetUserPref("OptionRowDanCourse")=='6th' then
					list[7] = true
				elseif GetUserPref("OptionRowDanCourse")=='7th' then
					list[8] = true
				elseif GetUserPref("OptionRowDanCourse")=='8th' then
					list[9] = true
				elseif GetUserPref("OptionRowDanCourse")=='9th' then
					list[10] = true
				elseif GetUserPref("OptionRowDanCourse")=='10th' then
					list[11] = true
				elseif GetUserPref("OptionRowDanCourse")=='Kaiden' then
					list[12] = true
				else
					list[1] = true
				end
			else
				WritePrefToFile("OptionRowDanCourse",'None');
				list[1] = true;
			end;
		end;
		SaveSelections = function(self, list, pn)
			if list[1] then
				WritePrefToFile("OptionRowDanCourse",'None');
			elseif list[2] then
				WritePrefToFile("OptionRowDanCourse",'1st');
			elseif list[3] then
				WritePrefToFile("OptionRowDanCourse",'2nd');
			elseif list[4] then
				WritePrefToFile("OptionRowDanCourse",'3rd');
			elseif list[5] then
				WritePrefToFile("OptionRowDanCourse",'4th');
			elseif list[6] then
				WritePrefToFile("OptionRowDanCourse",'5th');
			elseif list[7] then
				WritePrefToFile("OptionRowDanCourse",'6th');
			elseif list[8] then
				WritePrefToFile("OptionRowDanCourse",'7th');
			elseif list[9] then
				WritePrefToFile("OptionRowDanCourse",'8th');
			elseif list[10] then
				WritePrefToFile("OptionRowDanCourse",'9th');
			elseif list[11] then
				WritePrefToFile("OptionRowDanCourse",'10th');
			elseif list[12] then
				WritePrefToFile("OptionRowDanCourse",'Kaiden');
			else
				WritePrefToFile("OptionRowDanCourse",'None');
			end;
		end;
	};
	setmetatable( t, t );
	return t;
end

function OptionRowEXScore()
	local t = {
		Name = "EXScore";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		Choices = {"Off", "On", };
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("OptionRowEXScore") ~= nil then
				if GetUserPref("OptionRowEXScore")=='Off' then
					list[1] = true
				elseif GetUserPref("OptionRowEXScore")=='On' then
					list[2] = true
				else
					list[1] = true
				end
			else
				WritePrefToFile("OptionRowEXScore",'Off');
				list[1] = true;
			end;
		end;
		SaveSelections = function(self, list, pn)
			if list[1] then
				WritePrefToFile("OptionRowEXScore",'Off');
			elseif list[2] then
				WritePrefToFile("OptionRowEXScore",'On');
			else
				WritePrefToFile("OptionRowEXScore",'Off');
			end;
		end;
	};
	setmetatable( t, t );
	return t;
end

--Code by Midflight Digital
function OptionRowGauge()
	local t = {
		Name="Gauge",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = true,
		Choices = {"NORMAL", "LIFE4", "RISKY"};
		LoadSelections = function(self, list, pn)
			local po = GAMESTATE:GetPlayerState(pn):GetPlayerOptionsArray("ModsLevel_Preferred")
				if table.search(po, "4Lives") then
					list[2] = true
				elseif table.search(po, "1Lives") then
					list[3] = true
				else
					list[1] = true
				end
		end,
		SaveSelections = function(self, list, pn)
			local mod
			if list[2] then
				mod = "4 lives,battery,failimmediate"
			elseif list[3] then
				mod = "1 lives,battery,failimmediate"
			else
				mod = "bar,failimmediate"
			end
			if mod ~= "" then
				GAMESTATE:ApplyPreferredModifiers(pn, mod)
			end
		end,
	};
	setmetatable(t, t);
	return t;
end

--Code by Midflight Digital

function OptionRowSpeedX()
    -- Configuración base: misma que en tu pantalla principal
    local SPEED_MIN, SPEED_STEP, SPEED_MAX = 0.25, 0.05, 10
    local speeds = {}

    -- Generar lista desde x0.25 a x10.00 (en pasos de 0.05)
    for i = SPEED_MIN, SPEED_MAX + 0.001, SPEED_STEP do
        table.insert(speeds, string.format("x%.2f", i))
    end

    return {
        Name = "Speed",
        LayoutType = "ShowAllInRow",
        SelectType = "SelectOne",
        OneChoiceForAllPlayers = false,
        ExportOnChange = true,
        Choices = speeds,

        LoadSelections = function(self, list, pn)
            local po = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
            local speed = po:XMod() or 1
            local target = string.format("x%.2f", math.floor(speed * 100 + 0.5) / 100)

            for i, v in ipairs(speeds) do
                if v == target then
                    list[i] = true
                    break
                end
            end
        end,

        SaveSelections = function(self, list, pn)
            local po = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
            for i, v in ipairs(speeds) do
                if list[i] then
                    local speed = tonumber(v:sub(2)) -- quita la 'x' y convierte a número
                    po:XMod(speed)
                    break
                end
            end
        end,
    }
end

function OptionRowSpeedM()
    -- Configuración del rango para MMod
    local MMOD_MIN, MMOD_STEP, MMOD_MAX = 25, 25, 1000
    local mm_speeds = {}

    -- Generar lista de MMod: M25, M50, M75 ... M1000
    for i = MMOD_MIN, MMOD_MAX, MMOD_STEP do
        table.insert(mm_speeds, "M" .. tostring(i))
    end

    return {
        Name = "Speed",
        LayoutType = "ShowAllInRow",
        SelectType = "SelectOne",
        OneChoiceForAllPlayers = false,
        ExportOnChange = true,
        Choices = mm_speeds,

        LoadSelections = function(self, list, pn)
            local po = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
            local current = po:MMod() or 0

            -- Redondear al entero más cercano
            local target = "M" .. tostring(math.floor(current + 0.5))

            for i, v in ipairs(mm_speeds) do
                if v == target then
                    list[i] = true
                    break
                end
            end
        end,

        SaveSelections = function(self, list, pn)
            local po = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")

            for i, v in ipairs(mm_speeds) do
                if list[i] then
                    local value = tonumber(v:sub(2)) -- quitar "M"
                    po:MMod(value)
                    break
                end
            end
        end,
    }
end

function OptionRowSpeedC()
    -- Configuración del rango para CMod
    local CMOD_MIN, CMOD_STEP, CMOD_MAX = 25, 25, 1000
    local c_speeds = {}

    -- Generar lista de CMod: C25, C50, C75 ... C1000
    for i = CMOD_MIN, CMOD_MAX, CMOD_STEP do
        table.insert(c_speeds, "C" .. tostring(i))
    end

    return {
        Name = "Speed",
        LayoutType = "ShowAllInRow",
        SelectType = "SelectOne",
        OneChoiceForAllPlayers = false,
        ExportOnChange = true,
        Choices = c_speeds,

        LoadSelections = function(self, list, pn)
            local po = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
            local current = po:CMod() or 0

            -- redondeo seguro
            local target = "C" .. tostring(math.floor(current + 0.5))

            for i, v in ipairs(c_speeds) do
                if v == target then
                    list[i] = true
                    break
                end
            end
        end,

        SaveSelections = function(self, list, pn)
            local po = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")

            for i, v in ipairs(c_speeds) do
                if list[i] then
                    local value = tonumber(v:sub(2)) -- quitar "C"
                    
                    po:CMod(value)
                    break
                end
            end
        end,
    }
end


