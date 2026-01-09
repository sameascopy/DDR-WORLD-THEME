local pn = ...
local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)

-- ================= LIFE =================
local LifePercent = math.floor(pss:GetLifeRemainingSeconds() * 100 + 0.5)

local LivesLeft = -1
if pss.GetRemainingLives then
	LivesLeft = pss:GetRemainingLives()
elseif pss.GetLivesRemaining then
	LivesLeft = pss:GetLivesRemaining()
end

-- ================= DELTA =================
local function FormatWithCommas(n)
	local s = tostring(math.floor(n))
	local sign = ""

	if s:sub(1,1) == "-" then
		sign = "-"
		s = s:sub(2)
	end

	local len = #s
	for i = len - 3, 1, -3 do
		s = s:sub(1, i) .. "," .. s:sub(i + 1)
	end

	return sign .. s
end

-- ================= COMBO =================
local Steps = GAMESTATE:GetCurrentSteps(pn)
local MaxCombo = pss:MaxCombo()
local SongCombo = 0
if Steps then
	local rv = Steps:GetRadarValues(pn)
	SongCombo = rv:GetValue("RadarCategory_TapsAndHolds")
end

-- ================= SCORE =================
local Score   = pss:GetScore()
local EXScore = math.floor(pss:GetPossibleDancePoints()) * pss:GetPercentDancePoints() + 0.5

-- ================= JUDGES =================
local Marvelous = pss:GetTapNoteScores("TapNoteScore_W1")
local Perfect   = pss:GetTapNoteScores("TapNoteScore_W2")
local Great     = pss:GetTapNoteScores("TapNoteScore_W3")
local Good      = pss:GetTapNoteScores("TapNoteScore_W4")
local Ok        = pss:GetHoldNoteScores("HoldNoteScore_Held")
local Miss      = pss:GetTapNoteScores("TapNoteScore_Miss") + pss:GetTapNoteScores("TapNoteScore_W5")

local Fast = getenv("numFast"..ToEnumShortString(pn))
local Slow = getenv("numSlow"..ToEnumShortString(pn))

-- ================= FONTS =================
local data = Def.BitmapText{
	Font="_swis721 blk bt 28px",
	InitCommand=function(s) s:zoom(0.667):halign(1) end,
}

local rolnum = Def.RollingNumbers{
	Font="_swis721 blk bt 28px",
	InitCommand=function(s)
		s:zoom(0.667):halign(1):Load("RollingNumbersSongData")
	end,
}

return Def.ActorFrame{

	-- ================= DECO =================
	Def.Sprite{ Texture="data" },
	Def.Sprite{ Texture="FAST", InitCommand=function(s) s:visible(ShowFastSlow()) end },
	
	-- ================= JUDGMENTS =================
	data..{ InitCommand=function(s) s:xy(-80,-14):settext(Marvelous) end },
	data..{ InitCommand=function(s) s:xy(-80,  4):settext(Perfect)   end },
	data..{ InitCommand=function(s) s:xy(-80, 21):settext(Great)     end },
	data..{ InitCommand=function(s) s:xy(-80, 40):settext(Good)      end },
	data..{ InitCommand=function(s) s:xy(-80, 60):settext(Ok)        end },
	data..{ InitCommand=function(s) s:xy(-80, 79):settext(Miss)      end },

	data..{ InitCommand=function(s) s:xy(-44,4):halign(0.5):settext(Fast):visible(ShowFastSlow()) end },
	data..{ InitCommand=function(s) s:xy(-44,49):halign(0.5):settext(Slow):visible(ShowFastSlow()) end },

	-- ================= SCORE =================
	rolnum..{
		Name="Score",
		InitCommand=function(s) s:xy(240,-17):targetnumber(Score) end,
	},

	-- ================= BEST + DELTA =================
	Def.ActorFrame{
		Name="BestDeltaContainer",
		InitCommand=function(s) s:xy(240,4) end,
		OnCommand=function(s) s:queuecommand("Set") end,

		SetCommand=function(s)
			local Song  = GAMESTATE:GetCurrentSong()
			local Steps = GAMESTATE:GetCurrentSteps(pn)
			if not Song or not Steps then return end

			local profile
			if PROFILEMAN:IsPersistentProfile(pn) then
				profile = PROFILEMAN:GetProfile(pn)
			else
				profile = PROFILEMAN:GetMachineProfile()
			end

			local scorelist = profile:GetHighScoreList(Song, Steps)
			local scores = scorelist and scorelist:GetHighScores() or {}

			local AbsoluteBest = 0
			for _,hs in ipairs(scores) do
				AbsoluteBest = math.max(AbsoluteBest, hs:GetScore())
			end

			local BestScore
			if Score >= AbsoluteBest then
				BestScore = 0
				for _,hs in ipairs(scores) do
					local s = hs:GetScore()
					if s < Score and s > BestScore then
						BestScore = s
					end
				end
			else
				BestScore = AbsoluteBest
			end

			local DeltaScore = Score - BestScore
				s.DeltaScore = DeltaScore
			s:GetChild("BestScore"):targetnumber(BestScore)
			s:GetChild("DeltaText"):playcommand("Update")
		end,

		-- BEST SCORE
		rolnum..{ Name="BestScore", },
		data..{
			Name="DeltaText",
			InitCommand=function(s) s:y(20):halign(1) end,
			UpdateCommand=function(s)
				local parent = s:GetParent()
				local delta = parent.DeltaScore or 0
				local sign, col
				if delta > 0 then
					sign = "+"
					col  = color("#28e1af")
				elseif delta < 0 then
					sign = "-"
					col  = color("#d44c19")
				else
					sign = ""
					col  = Color.White
				end
				s:settext(sign .. FormatWithCommas(math.abs(delta)))
				s:diffuse(col)
			end,
		},
	},
	-- ================= EX SCORE =================
	rolnum..{ InitCommand=function(s) s:xy(240,42):targetnumber(EXScore) end, },

	-- ================= COMBO =================
	data..{ InitCommand=function(s) s:xy(240,61)
			:settext(string.format("%d/%d", MaxCombo, SongCombo))
		end,
	},
}
