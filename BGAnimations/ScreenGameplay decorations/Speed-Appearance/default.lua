local t = Def.ActorFrame{};
local pn = ({...})[1]

-- OPTIONS (guardadas temporalmente)
local OptionsByPlayer = {
	PlayerNumber_P1 = GAMESTATE:GetPlayerState('PlayerNumber_P1'):GetPlayerOptionsString('ModsLevel_Preferred'),
	PlayerNumber_P2 = GAMESTATE:GetPlayerState('PlayerNumber_P2'):GetPlayerOptionsString('ModsLevel_Preferred'),
}
local OptionsSongByPlayer = {
	PlayerNumber_P1 = GAMESTATE:GetPlayerState('PlayerNumber_P1'):GetPlayerOptionsString('ModsLevel_Song'),
	PlayerNumber_P2 = GAMESTATE:GetPlayerState('PlayerNumber_P2'):GetPlayerOptionsString('ModsLevel_Song'),
}

local numPlayers = GAMESTATE:GetNumPlayersEnabled()
local center1P = PREFSMAN:GetPreference("Center1Player")
local style = GAMESTATE:GetCurrentStyle();
local styleType = ToEnumShortString(style:GetStyleType());

local SingleGraphic = THEME:GetPathG("Premium","Customizer/cover/single/"..CoverGraph(pn))
local DoubleGraphic = THEME:GetPathG("Premium","Customizer/cover/double/Normal")

-- Helper: normalize and apply battery/lives to an options string
local function applyLivesOption(opt_str)
	-- remove any existing battery tokens first
	opt_str = string.gsub(opt_str, "(battery,)", "")
	-- check explicit lives patterns (allow forms "1Lives" or "1 Lives")
	for i = 1, 4 do
		if string.find(opt_str, tostring(i) .. "Lives") or string.find(opt_str, tostring(i) .. " Lives") then
			-- remove existing XLives token if present
			opt_str = string.gsub(opt_str, "(" .. tostring(i) .. "Lives,)", "")
			opt_str = string.gsub(opt_str, "(" .. tostring(i) .. " Lives,)", "")
			-- append battery form used elsewhere in the theme
			opt_str = opt_str .. ",failimmediate,battery, " .. tostring(i) .. " Lives"
			return opt_str
		end
	end
	-- no lives keyword found -> just return with battery removed
	return opt_str
end

function retrieveMeterType()
	-- If extra stages, force certain battery values
	if GAMESTATE:IsExtraStage() then
		OptionsByPlayer.PlayerNumber_P1 = OptionsByPlayer.PlayerNumber_P1 .. ',failimmediate,battery,4 lives,'
		OptionsByPlayer.PlayerNumber_P2 = OptionsByPlayer.PlayerNumber_P2 .. ',failimmediate,battery,4 lives,'
	elseif GAMESTATE:IsExtraStage2() then
		OptionsByPlayer.PlayerNumber_P1 = OptionsByPlayer.PlayerNumber_P1 .. ',failimmediate,battery,1 lives,'
		OptionsByPlayer.PlayerNumber_P2 = OptionsByPlayer.PlayerNumber_P2 .. ',failimmediate,battery,1 lives,'
	else
		-- Normal flow: apply any "XLives" keywords into battery options
		OptionsByPlayer.PlayerNumber_P1 = applyLivesOption(OptionsByPlayer.PlayerNumber_P1)
		OptionsByPlayer.PlayerNumber_P2 = applyLivesOption(OptionsByPlayer.PlayerNumber_P2)
	end

	GAMESTATE:SetFailTypeExplicitlySet();
end

function RecordGameplayMeterType(player)
	if GAMESTATE:IsCourseMode() or GAMESTATE:IsExtraStage() or GAMESTATE:IsExtraStage2() then return end

	local pf = PROFILEMAN:GetProfile(player)
	if not pf then return end
	local PlayerUID = pf:GetGUID()
	local Options = (player == "PlayerNumber_P1") and OptionsByPlayer.PlayerNumber_P1 or OptionsByPlayer.PlayerNumber_P2

	if string.find(Options, "battery") then
		if string.find(Options, "1Lives") or string.find(Options, "1 Lives") then
			SaveGameplayMeterTypeForPlayer(PlayerUID, "1 Lives")
		elseif string.find(Options, "2Lives") or string.find(Options, "2 Lives") then
			SaveGameplayMeterTypeForPlayer(PlayerUID, "2 Lives")
		elseif string.find(Options, "3Lives") or string.find(Options, "3 Lives") then
			SaveGameplayMeterTypeForPlayer(PlayerUID, "3 Lives")
		elseif string.find(Options, "4Lives") or string.find(Options, "4 Lives") then
			SaveGameplayMeterTypeForPlayer(PlayerUID, "4 Lives")
		end
	else
		SaveGameplayMeterTypeForPlayer(PlayerUID, "Normal")
	end
end

function SetGameplayMeterType(player)
	if GAMESTATE:IsCourseMode() or GAMESTATE:IsExtraStage() or GAMESTATE:IsExtraStage2() then return end

	local pf = PROFILEMAN:GetProfile(player)
	if not pf then return end
	local PlayerUID = pf:GetGUID()

	-- read whatever value saved for this player
	local val = ReadOrCreateGameplayMeterTypeForPlayer(PlayerUID)

	-- get current preferred options fresh
	local OptionsP1P = GAMESTATE:GetPlayerState('PlayerNumber_P1'):GetPlayerOptionsString('ModsLevel_Preferred');
	local OptionsP2P = GAMESTATE:GetPlayerState('PlayerNumber_P2'):GetPlayerOptionsString('ModsLevel_Preferred');
	local Options = (player == "PlayerNumber_P1") and OptionsP1P or OptionsP2P

	-- remove any previous battery and XLives tokens then append based on saved val
	Options = string.gsub(Options, "(battery,)", "")
	Options = string.gsub(Options, "(1Lives,)", "")
	Options = string.gsub(Options, "(2Lives,)", "")
	Options = string.gsub(Options, "(3Lives,)", "")
	Options = string.gsub(Options, "(4Lives,)", "")

	if val == "1 Lives" then
		Options = Options .. ",failimmediate,battery, 1 Lives";
	elseif val == "2 Lives" then
		Options = Options .. ",failimmediate,battery, 2 Lives";
	elseif val == "3 Lives" then
		Options = Options .. ",failimmediate,battery, 3 Lives";
	elseif val == "4 Lives" then
		Options = Options .. ",failimmediate,battery, 4 Lives";
	else
		-- Normal -> no battery
	end

	if player == "PlayerNumber_P1" then
		GAMESTATE:GetPlayerState('PlayerNumber_P1'):SetPlayerOptions('ModsLevel_Preferred', Options);
	else
		GAMESTATE:GetPlayerState('PlayerNumber_P2'):SetPlayerOptions('ModsLevel_Preferred', Options);
	end
end

-- File helpers (kept original style)
function ReadOrCreateGameplayMeterTypeForPlayer(PlayerUID, MyValue)
	local File = RageFileUtil:CreateRageFile()
	if File:Open("Save/GameplayMeterType/"..PlayerUID..".txt",1) then 
		local str = File:Read();
		MyValue = str;
	else
		File:Open("Save/GameplayMeterType/"..PlayerUID..".txt",2);
		File:Write("Normal");
		MyValue = "Normal";
	end
	File:Close();
	return MyValue;
end

function SaveGameplayMeterTypeForPlayer(PlayerUID, MyValue)
	local File = RageFileUtil:CreateRageFile();
	File:Open("Save/GameplayMeterType/"..PlayerUID..".txt",2);
	File:Write(tostring(MyValue));
	File:Close();
end

function SaveAppearancePluShowForPlayer(PlayerUID, MyValue)
	local AppearancePlusShowFile = RageFileUtil:CreateRageFile();
	AppearancePlusShowFile:Open("Save/AppearancePlusShow/"..PlayerUID..".txt",2);
	AppearancePlusShowFile:Write(tostring(MyValue));
	AppearancePlusShowFile:Close();
end

function ReadOrCreateAppearancePluShowForPlayer(PlayerUID, MyValue)
	local AppearancePlusShowFile = RageFileUtil:CreateRageFile()
	if AppearancePlusShowFile:Open("Save/AppearancePlusShow/"..PlayerUID..".txt",1) then 
		local str = AppearancePlusShowFile:Read();
		MyValue = str;
	else
		AppearancePlusShowFile:Open("Save/AppearancePlusShow/"..PlayerUID..".txt",2);
		AppearancePlusShowFile:Write("Show");
		MyValue = "Show";
	end
	AppearancePlusShowFile:Close();
	return MyValue;
end

function ReadOrCreateAppearancePlusCoverPosForPlayer(PlayerUID, MyValue)
	local AppearancePlusCoverPosFile = RageFileUtil:CreateRageFile()
	if AppearancePlusCoverPosFile:Open("Save/AppearancePlusCoverPos/"..PlayerUID..".txt",1) then 
		local str = AppearancePlusCoverPosFile:Read();
		MyValue = str;
	else
		AppearancePlusCoverPosFile:Open("Save/AppearancePlusCoverPos/"..PlayerUID..".txt",2);
		AppearancePlusCoverPosFile:Write("0");
		MyValue="0";
	end
	AppearancePlusCoverPosFile:Close();
	return MyValue;
end

function SaveAppearancePlusCoverPosForPlayer(PlayerUID, MyValue)
	local AppearancePlusCoverPosFile = RageFileUtil:CreateRageFile();
	AppearancePlusCoverPosFile:Open("Save/AppearancePlusCoverPos/"..PlayerUID..".txt",2);
	AppearancePlusCoverPosFile:Write(tostring(MyValue));
	AppearancePlusCoverPosFile:Close();
end

-- Init cover position (kept logic, cleaned some formatting)
function InitCoverPos(self, player, CoverPosition, pos, Mode, TwoCoverMode)
	if GAMESTATE:IsCourseMode() then return end

	local pf = PROFILEMAN:GetProfile(player)
	local PlayerUID = pf and pf:GetGUID() or "Unknown"
	(cmd(zoom,0.667;x,pos;y,SCREEN_CENTER_Y;))(self)
	local selfy = tonumber(ReadOrCreateAppearancePlusCoverPosForPlayer(PlayerUID, CoverPosition)) or 0

	if TwoCoverMode and selfy > 0 then
		selfy = 0
	end

	-- If in Course mode some entries may have reverse
	local CourseSongTrailHasReverse = false
	if GAMESTATE:IsCourseMode() then
		local entry = GAMESTATE:GetCurrentTrail(player):GetTrailEntry(GAMESTATE:GetCourseSongIndex())
		if entry then
			local EntryModifierString = entry:GetNormalModifiers()
			if string.find(string.lower(EntryModifierString), "reverse") then
				CourseSongTrailHasReverse = true
			end
		end
	end

	local OptionString = (player == "PlayerNumber_P1") and OptionsByPlayer.PlayerNumber_P1 or OptionsByPlayer.PlayerNumber_P2

	if string.find(string.lower(OptionString), "reverse") or CourseSongTrailHasReverse then
		if Mode == "Hidden+" then
			self:y(SCREEN_CENTER_Y + SCREEN_HEIGHT/2 - 32 - selfy)
		elseif Mode == "Sudden+" then
			self:y(SCREEN_CENTER_Y - SCREEN_HEIGHT/2 + selfy)
		end
	else
		self:zoomy(0.667)
		if Mode == "Hidden+" then
			self:y(SCREEN_CENTER_Y - SCREEN_HEIGHT/2 + selfy)
		elseif Mode == "Sudden+" then
			self:y(SCREEN_CENTER_Y + SCREEN_HEIGHT/2 - 32 - selfy)
		end
	end
end

-- Control cover pos (kept structure, deduped some branches)
function ControlCoverPos(self, params, player, CoverPosition, Mode, TwoCoverMode)
	if params.PlayerNumber ~= player then return end

	local pf = PROFILEMAN:GetProfile(player)
	local PlayerUID = pf and pf:GetGUID() or "Unknown"

	-- Toggle Show/Hidden state
	if string.find(params.Name, "AppearancePlusShow") then
		local MyValue = ReadOrCreateAppearancePluShowForPlayer(PlayerUID, "Show")
		if TwoCoverMode then
			if MyValue == "Show" then
				self:diffusealpha(0); MyValue = "Show-1"
			elseif MyValue == "Show-1" then
				self:diffusealpha(0); MyValue = "Hidden"
			elseif MyValue == "Hidden" then
				MyValue = "Hidden-1"; self:diffusealpha(1)
			elseif MyValue == "Hidden-1" then
				MyValue = "Show"; self:diffusealpha(1)
			end
		else
			if MyValue == "Show" or MyValue == "Show-1" then
				self:diffusealpha(0); MyValue = "Hidden"
			elseif MyValue == "Hidden" or MyValue == "Hidden-1" then
				MyValue = "Show"; self:diffusealpha(1)
			end
		end
		SaveAppearancePluShowForPlayer(PlayerUID, MyValue)
		return
	end

	-- determine delta from input name
	local yDelta = 0
	if TwoCoverMode then
		if params.Name == "AppearancePlusHarsher" then yDelta = 5
		elseif params.Name == "AppearancePlusEasier" then yDelta = -5
		elseif params.Name == "AppearancePlusHarsherMore" then yDelta = 25
		elseif params.Name == "AppearancePlusEasierMore" then yDelta = -25 end
	else
		if params.Name == "AppearancePlusHarsher" then yDelta = 10
		elseif params.Name == "AppearancePlusEasier" then yDelta = -10
		elseif params.Name == "AppearancePlusHarsherMore" then yDelta = 50
		elseif params.Name == "AppearancePlusEasierMore" then yDelta = -50 end
	end

	self:diffusealpha(1)

	local selfy = tonumber(ReadOrCreateAppearancePlusCoverPosForPlayer(PlayerUID, CoverPosition)) or 0
	selfy = selfy + yDelta

	-- clamp
	if TwoCoverMode then
		if selfy > 0 then selfy = 0
		elseif selfy < -SCREEN_HEIGHT/2 then selfy = -SCREEN_HEIGHT/2 end
	else
		if selfy > SCREEN_HEIGHT/2 then selfy = SCREEN_HEIGHT/2
		elseif selfy < -SCREEN_HEIGHT/2 then selfy = -SCREEN_HEIGHT/2 end
	end

	self:linear(0.1)

	-- Course reverse check (same as InitCoverPos)
	local CourseSongTrailHasReverse = false
	if GAMESTATE:IsCourseMode() then
		local entry = GAMESTATE:GetCurrentTrail(player):GetTrailEntry(GAMESTATE:GetCourseSongIndex())
		if entry then
			local EntryModifierString = entry:GetNormalModifiers()
			if string.find(string.lower(EntryModifierString), "reverse") then
				CourseSongTrailHasReverse = true
			end
		end
	end

	local OptionString = (player == "PlayerNumber_P1") and OptionsByPlayer.PlayerNumber_P1 or OptionsByPlayer.PlayerNumber_P2

	if string.find(string.lower(OptionString), "reverse") or CourseSongTrailHasReverse then
		if Mode == "Hidden+" then
			self:y(SCREEN_HEIGHT - 32 - selfy)
		elseif Mode == "Sudden+" then
			self:y(selfy)
		end
	else
		if Mode == "Hidden+" then
			self:y(selfy)
		elseif Mode == "Sudden+" then
			self:y(SCREEN_HEIGHT - 32 - selfy)
		end
	end

	SaveAppearancePlusCoverPosForPlayer(PlayerUID, selfy)
end

-- Song change handler (kept, cleaned)
function SongChangeCoverPos(self, player, CoverPosition, pos, Mode, TwoCoverMode, FileName)
	if not GAMESTATE:IsCourseMode() then return end

	local pf = PROFILEMAN:GetProfile(player)
	local PlayerUID = pf and pf:GetGUID() or "Unknown"
	(cmd(zoom,0.667;x,pos;y,SCREEN_CENTER_Y))(self)
	local selfy = tonumber(ReadOrCreateAppearancePlusCoverPosForPlayer(PlayerUID, CoverPosition)) or 0

	if TwoCoverMode and selfy > 0 then selfy = 0 end

	-- Course reverse detection
	local CourseSongTrailHasReverse = false
	local entry = GAMESTATE:GetCurrentTrail(player):GetTrailEntry(GAMESTATE:GetCourseSongIndex())
	if entry then
		local EntryModifierString = entry:GetNormalModifiers()
		if string.find(string.lower(EntryModifierString), "reverse") then
			CourseSongTrailHasReverse = true
		end
	end

	local OptionString = (player == "PlayerNumber_P1") and OptionsByPlayer.PlayerNumber_P1 or OptionsByPlayer.PlayerNumber_P2

	if string.find(string.lower(OptionString), "reverse") or CourseSongTrailHasReverse then
		if Mode == "Hidden+" then
			self:y(SCREEN_CENTER_Y + SCREEN_HEIGHT/2 - 32 - selfy)
		elseif Mode == "Sudden+" then
			self:y(SCREEN_CENTER_Y - SCREEN_HEIGHT/2 + selfy)
		end
	else
		self:zoomy(0.667)
		if Mode == "Hidden+" then
			self:y(SCREEN_CENTER_Y - SCREEN_HEIGHT/2 + selfy)
		elseif Mode == "Sudden+" then
			self:y(SCREEN_CENTER_Y + SCREEN_HEIGHT/2 - 32 - selfy)
		end
	end
end

-- Add cover layer (unchanged behaviour, now uses table t)
function AddCoverLayer(FileName, player, CoverPosition, pos, Mode, TwoCoverMode)
	t[#t+1] = LoadActor(FileName)..{
		InitCommand=function(self)
			InitCoverPos(self, player, CoverPosition, pos, Mode, TwoCoverMode);
		end;
		CodeMessageCommand = function(self, params)
			retrieveMeterType();
			SetGameplayMeterType(player);
			ControlCoverPos(self, params, player, CoverPosition, Mode, TwoCoverMode);
		end;
		CurrentSongChangedMessageCommand=function(self)
			SongChangeCoverPos(self, player, CoverPosition, pos, Mode, TwoCoverMode, FileName);
		end;
		OffCommand=function(self) end;
		HealthStateChangedMessageCommand=function(self, param)
			if param.PlayerNumber == player then
				if param.HealthState == "HealthState_Dead" then
					self:visible(false);
				else
					self:visible(true);
				end
			end;
		end;
	};
end

-- Appearance main (reduced duplication)
function AppearancePlusMain(pn)
	local player = pn;
	local pNum = (player == PLAYER_1) and 1 or 2
	local OptionString = (player == PLAYER_1)  and OptionsByPlayer.PlayerNumber_P1 or OptionsByPlayer.PlayerNumber_P2;
	local pf = PROFILEMAN:GetProfile(player)
	local PlayerUID = pf and pf:GetGUID() or "Unknown"
	local CoverPosition = 0;

	local pos = SCREEN_CENTER_X;
	if not center1P then
		local metricName = string.format("PlayerP%i%sX", pNum, styleType)
		pos = THEME:GetMetric("ScreenGameplay", metricName)
	end

	local MyValue = ReadOrCreateAppearancePlusValueForPlayer(PlayerUID, "Visible");

	-- Normal options that use engine mods (we add them to OptionString)
	if MyValue == "Hidden" then
		OptionString = string.gsub(OptionString, "(Sudden,)", "");
		OptionString = string.gsub(OptionString, "(Stealth,)", "");
		OptionString = OptionString .. ', Hidden,';
	elseif MyValue == "Sudden" then
		OptionString = string.gsub(OptionString, "(Stealth,)", "");
		OptionString = string.gsub(OptionString, "(Hidden,)", "");
		OptionString = OptionString .. ', Sudden,';
	elseif MyValue == "Stealth" then
		OptionString = string.gsub(OptionString, "(Sudden,)", "");
		OptionString = string.gsub(OptionString, "(Hidden,)", "");
		OptionString = OptionString .. ', Stealth,';
	end

	-- For + modes we need to add covers. Use fewer branches by selecting graphic by steps type.
	local function addForMode(mode, twomode)
		local stepsType = GAMESTATE:GetCurrentStyle():GetStepsType()
		local graphic = (stepsType == "StepsType_Dance_Single") and SingleGraphic or DoubleGraphic
		-- the previous code duplicated reverse check but always did same AddCoverLayer call, so no need to branch on reverse here
		AddCoverLayer(graphic, player, CoverPosition, pos, mode, twomode)
	end

	if MyValue == "Hidden+" then
		OptionString = string.gsub(OptionString, "(Sudden,)", "");
		OptionString = string.gsub(OptionString, "(Stealth,)", "");
		OptionString = string.gsub(OptionString, "(Hidden,)", "");
		addForMode("Hidden+", false)
	elseif MyValue == "Sudden+" then
		OptionString = string.gsub(OptionString, "(Sudden,)", "");
		OptionString = string.gsub(OptionString, "(Stealth,)", "");
		OptionString = string.gsub(OptionString, "(Hidden,)", "");
		addForMode("Sudden+", false)
	elseif MyValue == "Hidden+&Sudden+" then
		OptionString = string.gsub(OptionString, "(Sudden,)", "");
		OptionString = string.gsub(OptionString, "(Stealth,)", "");
		OptionString = string.gsub(OptionString, "(Hidden,)", "");
		-- Hidden+ then Sudden+ (order doesn't affect visuals here)
		addForMode("Hidden+", true)
		CoverPosition = 0
		addForMode("Sudden+", true)
	end

	return OptionString;
end

-- Sound + input binding (kept, minimal changes)
local button = {}
local function AppearancePlusSound(event)
	local pn = event.PlayerNumber
	if event.type ~= "InputEventType_FirstPress" then return end
	if button[event.button] and GAMESTATE:IsPlayerEnabled(pn) then
		button[event.button]:play()
	end
end

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	local pf = PROFILEMAN:GetProfile(pn)
	local PlayerUID = pf and pf:GetGUID() or "Unknown"
	local MyValue = ReadOrCreateAppearancePlusValueForPlayer(PlayerUID, "Visible");
	if MyValue == "Hidden+" or MyValue == "Sudden+" or MyValue == "Hidden+&Sudden+" then
		t[#t+1] = Def.ActorFrame{
			Def.Sound{
				File = THEME:GetPathS("","HiddenPlusShow"), InitCommand = function(self)
					button.Start = self
				end
			},
			Def.ActorFrame{
				OnCommand= function(self)
					SCREENMAN:GetTopScreen():AddInputCallback(AppearancePlusSound)
				end
			}
		};
	end;
end;

-- Apply initial retrieval
retrieveMeterType();

-- Lock SpeedMod when Oni Course has SpeedMod in course file
if GAMESTATE:GetPlayMode() == "PlayMode_Oni" then
	local trailHasSpeedMod = false;
	local trailHasAppearanceMode = false;

	local checkTrail = function(playerTag)
		if not GAMESTATE:IsPlayerEnabled(playerTag) then return {} end
		local trail = GAMESTATE:GetCurrentTrail(playerTag)
		if not trail then return {} end
		local entries = trail:GetTrailEntries()
		for i = 1, #entries do
			local modString = entries[i]:GetNormalModifiers()
			if string.find(modString, "x") or string.find(modString, "X") then
				trailHasSpeedMod = true
			end
			if string.find(modString, "Hidden") or string.find(modString, "Sudden") or string.find(modString, "Stealth") then
				trailHasAppearanceMode = true
			end
		end
		return entries
	end

	checkTrail('PlayerNumber_P1')
	checkTrail('PlayerNumber_P2')

	if not trailHasSpeedMod then
		t[#t+1] = LoadActor("SpeedKill.lua");
	end

	if not trailHasAppearanceMode then
		if GAMESTATE:IsPlayerEnabled('PlayerNumber_P1') then
			OptionsByPlayer.PlayerNumber_P1 = AppearancePlusMain('PlayerNumber_P1');
		end
		if GAMESTATE:IsPlayerEnabled('PlayerNumber_P2') then
			OptionsByPlayer.PlayerNumber_P2 = AppearancePlusMain('PlayerNumber_P2');
		end
	end
else
	-- Non-Oni flow
	t[#t+1] = LoadActor("SpeedKill.lua");

	if GAMESTATE:IsPlayerEnabled('PlayerNumber_P1') then
		OptionsByPlayer.PlayerNumber_P1 = AppearancePlusMain('PlayerNumber_P1');
		RecordGameplayMeterType('PlayerNumber_P1')
	end
	if GAMESTATE:IsPlayerEnabled('PlayerNumber_P2') then
		OptionsByPlayer.PlayerNumber_P2 = AppearancePlusMain('PlayerNumber_P2');
		RecordGameplayMeterType('PlayerNumber_P2')
	end
end

-- Oni Options hack
if GAMESTATE:GetPlayMode() == "PlayMode_Oni" then
	if GAMESTATE:IsPlayerEnabled('PlayerNumber_P1') then
		if GAMESTATE:GetCurrentTrail('PlayerNumber_P1'):GetDifficulty() == "Difficulty_Hard" then
			OptionsByPlayer.PlayerNumber_P1 = OptionsByPlayer.PlayerNumber_P1 .. ',failimmediate,battery,4 lives,'
		else
			OptionsByPlayer.PlayerNumber_P1 = OptionsByPlayer.PlayerNumber_P1 .. ',failimmediate,battery,8 lives,'
		end
	end

	if GAMESTATE:IsPlayerEnabled('PlayerNumber_P2') then
		if GAMESTATE:GetCurrentTrail('PlayerNumber_P2'):GetDifficulty() == "Difficulty_Hard" then
			OptionsByPlayer.PlayerNumber_P2 = OptionsByPlayer.PlayerNumber_P2 .. ',failimmediate,battery,4 lives,'
		else
			OptionsByPlayer.PlayerNumber_P2 = OptionsByPlayer.PlayerNumber_P2 .. ',failimmediate,battery,8 lives,'
		end
	end

	GAMESTATE:SetFailTypeExplicitlySet();
end

-- Apply options to players
GAMESTATE:GetPlayerState('PlayerNumber_P1'):SetPlayerOptions('ModsLevel_Preferred', OptionsByPlayer.PlayerNumber_P1);
GAMESTATE:GetPlayerState('PlayerNumber_P2'):SetPlayerOptions('ModsLevel_Preferred', OptionsByPlayer.PlayerNumber_P2);

return t;
