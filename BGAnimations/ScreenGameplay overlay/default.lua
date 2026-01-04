local t = Def.ActorFrame{}

-- =========================================
-- FullCombo por jugador
-- =========================================
for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	t[#t+1] = LoadActor("FullCombo", pn)
end

-- =========================================
-- Canciones especiales
-- =========================================
if not GAMESTATE:IsCourseMode() then
	local song = GAMESTATE:GetCurrentSong()
	if song then
		local title = song:GetDisplayFullTitle()
		if title == "LET'S CHECK YOUR LEVEL!" then
			t[#t+1] = LoadActor("LET'S CHECK YOUR LEVEL!")
		elseif title == "Lesson by DJ" then
			t[#t+1] = LoadActor("Lesson by DJ")
		end
	end
end

-- =========================================
-- MMOD REAL
-- =========================================
-- =========================================
-- FUNCIÓN REAL MMOD
-- =========================================
local function ApplyGlobalMMod(pn)
	if not GAMESTATE:IsPlayerEnabled(pn) then return end

	local m = getenv("SelectedMMod_" .. pn)
	if not m then return end

	local steps = GAMESTATE:GetCurrentSteps(pn)
	if not steps then return end

	-- 🔥 BPM REAL DEL CHART (ssc o sm)
	local bpms = steps:GetTimingData():GetActualBPM()
	local bpmMax = bpms[2]
	if not bpmMax or bpmMax <= 0 then return end

	-- 🔥 MMOD REAL
	local xmod = m / bpmMax

	GAMESTATE:GetPlayerState(pn)
		:GetPlayerOptions("ModsLevel_Song")
		:XMod(xmod)
end



t[#t+1] = Def.ActorFrame{
	Name = "ApplyGlobalMMod",

	OnCommand = function(self)
		self:sleep(0)
		self:queuecommand("Apply")
	end,

	ApplyCommand = function(self)
		for _, pn in ipairs(GAMESTATE:GetEnabledPlayers()) do
			ApplyGlobalMMod(pn)
		end
	end,

	CurrentStepsP1ChangedMessageCommand = function(self)
		ApplyGlobalMMod(PLAYER_1)
	end,

	CurrentStepsP2ChangedMessageCommand = function(self)
		ApplyGlobalMMod(PLAYER_2)
	end,
}





return t
