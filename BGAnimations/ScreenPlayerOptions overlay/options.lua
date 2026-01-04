-- 📌 Configuración base de velocidades
local SPEED_MIN, SPEED_STEP, SPEED_MAX = 0.25, 0.05, 10

-- ===========================================
-- 🧩 FUNCIÓN REAL DE MMOD (SCALING VISUAL)
-- ===========================================
local function GetMModVisualBPM(pn, mmod_value)
	local song = GAMESTATE:GetCurrentSong()
	local steps = GAMESTATE:GetCurrentSteps(pn)
	if not song or not steps then return 0, 0 end

	local bpm_range = steps:GetTimingData():GetActualBPM()
	local realMin = bpm_range[1]
	local realMax = bpm_range[2]

	if realMin <= 0 then realMin = realMax end

	-- BPM base exacto (como tú lo usas)
	local baseBPM = realMin

	-- Factor tipo XMod
	local factor = mmod_value / baseBPM

	local visualMin = realMin * factor
	local visualMax = realMax * factor

	return visualMin, visualMax
end




local args = {...}
local pn = args[1]

local function p(text)
	return text:gsub("%%", ToEnumShortString(pn))
end

local function GetOptionName(screen, idx)
	return screen:GetOptionRow(idx - 1):GetName()
end

local function base_x()
	if pn == PLAYER_1 then return SCREEN_CENTER_X - 215
	elseif pn == PLAYER_2 then return SCREEN_CENTER_X + 215
	else error("Pass a valid player number", 2) end
end

-- Lista de filas
local rownames = {
	"Speed","Accel","Appearance","Turn","Hide","Scroll",
	"NoteSkins","Remove","Freeze","Jump","VisualDelaySeconds",
	"ScreenFilter","Gauge"
}

-- Texto de explicación
local function getSettingText(screen, idx, pn)
	if not screen then return "" end
	local row = screen:GetOptionRow(idx - 1)
	if not row then return "" end
	local name = row:GetName()
	local choice = row:GetChoiceInRowWithFocus(pn)
	if THEME:GetMetric("ScreenOptionsMaster", name.."Explanation") then
		return THEME:GetString("OptionItemExplanations", name..tostring(choice))
	elseif name == "Speed" then
		return "Change the Speed."
	elseif name == "NoteSkins" then
		return "Change the appearance of the arrows."
	elseif name == "ScreenFilter" then
		return "Change the visibility of the filter."
	elseif name == "VisualDelaySeconds" then
		return "Adjust the display timing of the arrows.\nIf input is lagging, decrease the amount."
	end
	return ""
end

-- Valor de la opción
local function ChoiceToText(screen, idx, pn)
	if not screen then return "", false end
	local row = screen:GetOptionRow(idx - 1)
	if not row then return "", false end
	local name = row:GetName()
	local choice = row:GetChoiceInRowWithFocus(pn)

	if name == "Speed" then
		if ThemePrefs.Get("SpeedMod") == "Mmod" then
			local value = 25 + (choice * 25)
			return "M" .. tostring(value), false
		elseif ThemePrefs.Get("SpeedMod") == "Cmod" then
			local value = 25 + (choice * 25)
			return "C" .. tostring(value), false
		else	
			local value = math.floor((SPEED_MIN + choice * SPEED_STEP) * 100 + 0.5) / 100
			return string.format("x%g", value), value == 1
		end
	elseif name == "NoteSkins" then
		return NOTESKIN:GetNoteSkinNames()[choice + 1] or "", false
	elseif name == "ScreenFilter" then
		local value = choice * 0.1
		return value == 0 and "0%" or string.format("%d%%", value * 100), value == 0
	elseif name == "VisualDelaySeconds" then
		local value = choice - 50
		if value == 0 then return "±0.0", true end
		return string.format("%+.1f", value * 0.1), false
	else
		local key = name .. tostring(choice)
		return THEME:GetString("OptionItemNames", key) or "", choice == 0
	end
end

-- Crear filas
local RowList = {}

for idx = 1, #rownames do
	local hasFocus = idx == 1

	-- Si es Speed, insertamos primero CurrentBPM
	if rownames[idx] == "Speed" then
		RowList[#RowList + 1] = Def.ActorFrame{
			Name = "RowCurrentBPM",
			InitCommand = cmd(y, -20),
			ChangeRowMessageCommand = cmd(queuecommand, "Set"),
			[p"MenuLeft%MessageCommand"] = cmd(queuecommand, "Set"),
			[p"MenuRight%MessageCommand"] = cmd(queuecommand, "Set"),

			SetCommand = function(self)
				local screen = SCREENMAN:GetTopScreen()
				if not screen then return self:visible(false) end
				local idx = screen:GetCurrentRowIndex(pn) + 1
				local row = screen:GetOptionRow(idx - 1)
				self:visible(row and row:GetName() == "Speed")
			end,

			Def.Sprite{ Texture = "large_base", InitCommand = function(s) s:diffuse(color("0,0,0,1")) end },
			Def.Quad{ InitCommand = function(s) s:setsize(4,15):xy(-132,0):diffuse(color("#8b000e")) end },
			LoadActor("type_base")..{ InitCommand = function(s) s:x(64):setsize(142,30):diffuse(color("0,0,0,1")) end },
			LoadActor("type_line")..{ InitCommand = function(s) s:x(64):setsize(142,30):diffuse(color("#dac42e")) end },
			LoadActor("large_line"),

			Def.BitmapText{
				Font = "_avenirnext lt pro bold Bold 20px",
				InitCommand = cmd(x, -67; zoom, 0.8; settext, "CURRENT BPM"),
			},
			Def.BitmapText{
				Font = "_avenirnext lt pro bold Bold 20px",
				Name = "CurrentBPM",
				InitCommand = cmd(x, 65; zoom, 0.9; queuecommand, "Set"),
SetCommand = function(self)
	local steps = GAMESTATE:GetCurrentSteps(pn)
	if not steps then return end

	local td = steps:GetTimingData()
	if not td then return end

	local bpms = td:GetActualBPM()
	if not bpms or not bpms[1] or not bpms[2] then return end

	local bpmMin = bpms[1]
	local bpmMax = bpms[2]
	if bpmMax <= 0 then return end

	local po = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
	local speedmod = ThemePrefs.Get("SpeedMod")
	local text = ""

	-------------------------------------------------
	-- XMOD
	-------------------------------------------------
	if speedmod == "Xmod" then
		local x = po:XMod() or 1

		local vMin = math.floor(bpmMin * x + 0.5)
		local vMax = math.floor(bpmMax * x + 0.5)

		text = (vMin == vMax)
			and tostring(vMax)
			or string.format("%d–%d", vMin, vMax)

	-------------------------------------------------
	-- CMOD
	-------------------------------------------------
	elseif speedmod == "Cmod" then
		local c = po:CMod() or 0
		text = tostring(math.floor(c + 0.5))

	-------------------------------------------------
	-- MMOD (REAL)
	-------------------------------------------------
	elseif speedmod == "Mmod" then
		local m = po:MMod()
		if not m or m <= 0 then return end

		local factor = m / bpmMax
		local vMin = math.floor(bpmMin * factor + 0.5)
		local vMax = math.floor(m + 0.5)

		text = (vMin == vMax)
			and tostring(vMax)
			or string.format("%d–%d", vMin, vMax)
	end

	self:settext(text)
end


			}


		}
	end

	-- fila normal
	RowList[#RowList + 1] = Def.ActorFrame{
		Name = "Row" .. idx,
		OnCommand = function(self) self:playcommand(hasFocus and "GainFocus" or "LoseFocus") end,
		ChangeRowMessageCommand = function(self, param)
			if param.PlayerNumber ~= pn then return end
			local focusNow = param.RowIndex + 1 == idx
			if focusNow ~= hasFocus then
				hasFocus = focusNow
				self:stoptweening()
				self:queuecommand(focusNow and "GainFocus" or "LoseFocus")
			end
		end,

		Def.Sprite{ Texture = "large_base", GainFocusCommand = function(s) s:diffuse(color("#84ffff")) end, LoseFocusCommand = function(s) s:diffuse(color("0,0,0,1")) end },
		Def.Quad{ InitCommand = function(s) s:setsize(4,15):xy(-132,0) end, GainFocusCommand = function(s) s:diffuse(color("0,0,0,1")) end, LoseFocusCommand = function(s) s:diffuse(color("#8b000e")) end },
		LoadActor("type_base")..{ InitCommand = function(s) s:x(64):setsize(142,30):diffuse(color("0,0,0,1")) end },
		LoadActor("type_line")..{ InitCommand = function(s) s:x(64):setsize(142,30):diffuse(color("#dac42e")) end },
		LoadActor("large_line"),

		-- Nombre
		LoadFont("_avenirnext lt pro bold Bold 20px")..{
			InitCommand = function(s) s:x(-122):halign(0):zoom(0.75):maxwidth(150):uppercase(true) end,
			SetCommand = function(self)
				local screen = SCREENMAN:GetTopScreen()
				if screen then self:settext(THEME:GetString("OptionTitles", GetOptionName(screen, idx))) end
			end,
			GainFocusCommand = function(s) s:diffuse(color("#000000")) end,
			LoseFocusCommand = function(s) s:diffuse(color("#ffffff")) end,
			OnCommand = cmd(queuecommand, "Set"),
			ChangeRowMessageCommand = cmd(queuecommand, "Set"),
		},

		-- Valor
		LoadFont("_avenirnext lt pro bold Bold 20px")..{
			InitCommand = cmd(x, 64; zoom, 0.8; maxwidth, 150; uppercase, true),
			SetCommand = function(self)
				local screen = SCREENMAN:GetTopScreen()
				local text, isDefault = ChoiceToText(screen, idx, pn)
				self:settext(text)
				if isDefault then
					self:diffuse(color("#06ff06")):diffusetopedge(color("#74ff74"))
				else
					self:diffuse(color("1,1,1,1"))
				end
			end,
			OnCommand = cmd(queuecommand, "Set"),
			[p"MenuLeft%MessageCommand"] = cmd(queuecommand, "Set"),
			[p"MenuRight%MessageCommand"] = cmd(queuecommand, "Set"),
			ChangeRowMessageCommand = cmd(queuecommand, "Set"),
		},
	}
end

-- ActorFrame principal
local t = Def.ActorFrame{
	InitCommand = cmd(x, base_x()),
	OnCommand = cmd(diffusealpha, 1),
	OffCommand = cmd(diffusealpha, 0),

	-- Scroller
	Def.ActorScroller{
		Name = "ListScroller",
		SecondsPerItem = 0.1,
		NumItemsToDraw = 30,
		InitCommand = cmd(y, SCREEN_CENTER_Y - 26),
		TransformFunction = function(self, offsetFromCenter) self:y(offsetFromCenter * 40) end,
		children = RowList,
		ChangeRowMessageCommand = function(s, param)
			local screen = SCREENMAN:GetTopScreen()
			if param.PlayerNumber == pn then
				s:SetDestinationItem(screen:GetCurrentRowIndex(param.PlayerNumber))
			end
		end,
	},

	-- Cuadro de explicación
	LoadActor("exp.png")..{ InitCommand = cmd(y, SCREEN_CENTER_Y + 215) },
	LoadFont("_avenirnext lt pro bold Bold 20px")..{
		Name = "ExplanationText",
		InitCommand = cmd(y, SCREEN_CENTER_Y + 215; wrapwidthpixels, 290; zoom, 1; queuecommand, "Set"),
		SetCommand = function(self)
			local screen = SCREENMAN:GetTopScreen()
			if not screen then return end
			local idx = screen:GetCurrentRowIndex(pn) + 1
			self:settext(getSettingText(screen, idx, pn))
		end,
		ChangeRowMessageCommand = cmd(queuecommand, "Set"),
		[p"MenuLeft%MessageCommand"] = cmd(queuecommand, "Set"),
		[p"MenuRight%MessageCommand"] = cmd(queuecommand, "Set"),
	},
}

return t
