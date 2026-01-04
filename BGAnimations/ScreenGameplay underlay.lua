local t = Def.ActorFrame{}

local allowedExtensions = {
    [".sm"]=true, [".ssc"]=true, [".ogg"]=true, [".mp3"]=true,
    [".wav"]=true, [".png"]=true, [".jpg"]=true, [".jpeg"]=true,
	[".bmp"]=true, [".old"]=true, [".ini"]=true
}

local function GetSongVideo()
    local song = GAMESTATE:GetCurrentSong()
    if not song then return nil end

    local files = FILEMAN:GetDirListing(song:GetSongDir() .. "/")
    for _, file in ipairs(files) do
        local ext = file:match("^.+(%..+)$")
        ext = ext and ext:lower() or ""
        if not allowedExtensions[ext] then
            return song:GetSongDir() .. "/" .. file
        end
    end
    return nil
end

local videoPath = GetSongVideo()
local enabledPlayers = GAMESTATE:GetEnabledPlayers()

PREFSMAN:SetPreference('SongBackgrounds', true)

if ThemePrefs.Get("VideoSize") == "Small" or ThemePrefs.Get("VideoSize") == "Medium" then
PREFSMAN:SetPreference('SongBackgrounds', false)
	if videoPath and #enabledPlayers > 0 then
		-- Si hay más de un jugador, cargamos solo 1 video
		t[#t+1] = Def.Sprite{
			Texture = videoPath,
			InitCommand = function(s)
				local style = GAMESTATE:GetCurrentStyle()
				local sizePref = ThemePrefs.Get("VideoSize")
				local w, h, x, y = 320, 180, _screen.cx, _screen.cy

				if style:GetStepsType() == 'StepsType_Dance_Double' then
					if sizePref == "Small" or sizePref == "Medium" then
						w, h = 144, 80
						if #enabledPlayers == 1 then
							local pn = enabledPlayers[1]
							x = pn == PLAYER_1 and SCREEN_RIGHT-72 or SCREEN_LEFT+72
						end
					end
				else
					if sizePref == "Small" then
						w, h = 195, 108
						y = _screen.cy + 129
					elseif sizePref == "Medium" then
						if style:GetStyleType() == "StyleType_TwoPlayersTwoSides" then
							w, h = 195, 108
							y = _screen.cy + 129
						else
							w, h = 513, 289
							if #enabledPlayers == 2 then
								x = _screen.cx
							else
								x = enabledPlayers[1] == PLAYER_1 and _screen.cx + 166 or _screen.cx - 166
							end
						end
					end
				end

				s:SetSize(w, h):xy(x, y)
			end,
			OnCommand = function(s)
				s:loop(0):sleep(SongMeasureSec())
			end
		}
	end
else
	PREFSMAN:SetPreference('SongBackgrounds', true)
end

return t
