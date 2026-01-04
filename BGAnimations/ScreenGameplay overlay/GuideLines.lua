local t = Def.ActorFrame{}

local NUM_LINES    = 32
local LINE_HEIGHT  = 4
local ALPHA        = 0.8
local BEAT_OFFSET  = 4
local COLOR        = {1,1,1,ALPHA} -- color de las barras

local function CreateMaskedBeatBars(playerP)
    local af = Def.ActorFrame{}

    -- Máscara para tapar las BeatBars nativas
    af[#af+1] = Def.Quad{
        InitCommand=function(s)
            local screen = SCREENMAN:GetTopScreen()
if not screen then return end

local nf
if playerP == PLAYER_1 then
    nf = screen:GetChild("PlayerP1"):GetChild("NoteField")
elseif playerP == PLAYER_2 then
    nf = screen:GetChild("PlayerP2"):GetChild("NoteField")
end
if not nf then return end

            s:diffuse({0,0,0,1}) -- color fondo para tapar
            s:zoomto(nf:GetWidth(), nf:GetHeight())
            s:xy(nf:GetX(), nf:GetY())
        end
    }

    -- Pre-creamos los quads que simulan BeatBars
    for i=0,NUM_LINES-1 do
        af[#af+1] = Def.Quad{
            Name="Bar"..i,
            InitCommand=function(s)
                s:diffuse(COLOR)
                s:zoomto(128, LINE_HEIGHT)
            end
        }
    end

    af.InitCommand=function(self)
        self:SetUpdateFunction(function(self)
            local song = GAMESTATE:GetCurrentSong()
            local pos  = GAMESTATE:GetSongPosition()
            if not song or not pos then return end

            local firstBeat = song:GetFirstBeat() or 0
            local startBeat = firstBeat - BEAT_OFFSET
            local beat = pos:GetSongBeat() or 0

            local screen = SCREENMAN:GetTopScreen()
            if not screen then return end
            local player = screen:GetChild(playerP)
            local nf = player:GetChild("NoteField")

            local nfX = nf:GetX()
            local nfY = nf:GetY()
            local nfW = nf:GetWidth()
            local nfH = nf:GetHeight()
            local spacing = nfH / NUM_LINES

            for i=0,NUM_LINES-1 do
                local bar = self:GetChild("Bar"..i)
                local y_off = (i * spacing) - ((beat - startBeat) * spacing)

                if beat >= startBeat and y_off >= -nfH and y_off <= nfH then
                    bar:visible(true)
                    bar:x(nfX)
                    bar:y(nfY + y_off)
                    bar:zoomto(nfW, LINE_HEIGHT)
                else
                    bar:visible(false)
                end
            end
        end)
    end

    return af
end

if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
    t[#t+1] = CreateMaskedBeatBars("PlayerP1")
end
if GAMESTATE:IsPlayerEnabled(PLAYER_2) then
    t[#t+1] = CreateMaskedBeatBars("PlayerP2")
end

return t
