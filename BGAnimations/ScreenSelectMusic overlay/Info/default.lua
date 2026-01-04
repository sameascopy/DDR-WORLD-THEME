local function HasSplitBpm(song)
  local stepType = GAMESTATE:GetCurrentStyle():GetStepsType()
  local steps = song:GetStepsByStepsType(stepType)
  for s=1,#steps do
      -- EDIT譜面は判定対象外
      if steps[s]:GetDifficulty() ~= 'Difficulty_Edit'
          and song:IsStepsUsingDifferentTiming(steps[s]) then
          return true
      end
  end
  return false
end

local AnimPlayed = true

return Def.ActorFrame{
    InitCommand=function(s) s:xy(_screen.cx,_screen.cy-274) end,

    -- Detecta cambio de canción
    CurrentSongChangedMessageCommand=function(s)
        local song = GAMESTATE:GetCurrentSong()
        if song then
            s:queuecommand("Show"):queuecommand("Set")
        else
            s:queuecommand("Hide")
        end
    end,

    -- Animaciones Show/Hide
    ShowCommand=function(s)
        if not AnimPlayed then
            s:diffusealpha(0):linear(0.05):diffusealpha(0.75)
            s:linear(0.1):diffusealpha(0.25):linear(0.1):diffusealpha(1)
            s:queuecommand("UpdateShow")
        end
    end,
    UpdateShowCommand=function(s) AnimPlayed = true end,
    HideCommand=function(s)
        if AnimPlayed then
            s:diffusealpha(1):sleep(0.05):diffusealpha(0):sleep(0.05):diffusealpha(0.5)
            s:sleep(0.05):diffusealpha(0):sleep(0.05):diffusealpha(0.25):sleep(0.05)
            s:linear(0.05):diffusealpha(0)
            s:queuecommand("UpdateHide")
        end
    end,
    UpdateHideCommand=function(s) AnimPlayed = false end,

    -- Panel de info
    Def.ActorFrame{
        Def.Sprite{
            Texture="info",
            InitCommand=function(s) s:y(4) end, 
        },
        LoadFont("_swis721 blk bt 28px")..{
            Name="Title",
            InitCommand=function(s) 
                s:xy(-155,-15):zoom(0.8):halign(0):maxwidth(560)
                s:diffuse(color("#000000"))
            end,
            SetCommand=function(s)    
                local song = GAMESTATE:GetCurrentSong()
                if song then
                    s:settext(GetSongName(song))
                end
            end
        },
        LoadFont("_swis721 blk bt 28px")..{
            Name="Artist",
            InitCommand=function(s) 
                s:xy(-155,12):zoom(0.5):halign(0):maxwidth(560)
                s:diffuse(color("#000000"))
            end,
            SetCommand=function(s)
                local song = GAMESTATE:GetCurrentSong()
                if song then
                    s:settext(GetArtistName(song))
                end
            end
        },
        Def.Sprite{
            InitCommand=function(s) s:x(-229):y(-1) end,
            SetCommand=function(s)
                local song = GAMESTATE:GetCurrentSong()
                if song then
                    s:LoadFromCached("Jacket",GetJacketPath(song))
                end
                s:setsize(128,128)
            end
        },
    },

    -- BPM dinámico por jugador activo
    Def.BitmapText{
        Font="_swis721 blk bt 28px",
        InitCommand=function(s)
            s:zoom(0.667):xy(-115,36):halign(0):diffuse(color("#000000"))
            s:queuecommand("UpdateBPM")
        end,
        UpdateBPMCommand=function(self)
            local song = GAMESTATE:GetCurrentSong()
            if not song then 
                self:settext("") 
                return 
            end

            local bpmText = ""

            if GAMESTATE:IsHumanPlayer(PLAYER_1) then
                local steps = GAMESTATE:GetCurrentSteps(PLAYER_1)
                if steps then
                    local timing = steps:GetTimingData():GetActualBPM()
                    bpmText = "P1: " .. ((timing[1]==timing[2]) and round(timing[1],0) or string.format("%d~%d", round(timing[1],0), round(timing[2],0)))
                end
            end

            if GAMESTATE:IsHumanPlayer(PLAYER_2) then
                local steps = GAMESTATE:GetCurrentSteps(PLAYER_2)
                if steps then
                    local timing = steps:GetTimingData():GetActualBPM()
                    if bpmText ~= "" then bpmText = bpmText .. " | " end
                    bpmText = bpmText .. "P2: " .. ((timing[1]==timing[2]) and round(timing[1],0) or string.format("%d~%d", round(timing[1],0), round(timing[2],0)))
                end
            end

            self:settext(bpmText)
        end,
        CurrentStepsP1ChangedMessageCommand=function(self) self:queuecommand("UpdateBPM") end,
        CurrentStepsP2ChangedMessageCommand=function(self) self:queuecommand("UpdateBPM") end,
        CurrentSongChangedMessageCommand=function(self) self:queuecommand("UpdateBPM") end,
    },
	Def.BitmapText{
		Font="_swis721 blk bt 28px",
			InitCommand=function(s)
				s:zoom(0.5):xy(-120,56):halign(0):diffuse(color("#000000"))
				s:settext("SPLIT BPM"):queuecommand("Set")
			end,
		SetCommand=function(s) 
			local song = GAMESTATE:GetCurrentSong()
				if song then
					s:visible(HasSplitBpm(song))
				end
		end,

	}

};