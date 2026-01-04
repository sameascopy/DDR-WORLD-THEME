-- 02 NoteField.lua - Override BeatBars con gráficos originales
-- Colocar en Themes/TU_TEMA/Scripts/

local NUM_LINES   = 32    -- cuántas barras visibles
local LINE_SPACING = 64   -- separación vertical entre barras
local ALPHA       = 0.8   -- transparencia
local BEAT_OFFSET = 4     -- aparecen 4 beats antes del primer arrow

local function BeatBars()
    return Def.ActorFrame {
        InitCommand=function(self)
            self:SetUpdateFunction(function(self)
                local song = GAMESTATE:GetCurrentSong()
                local pos  = GAMESTATE:GetSongPosition()
                if not song or not pos then return end

                local firstBeat = song:GetFirstBeat() or 0
                local startBeat = firstBeat - BEAT_OFFSET
                local beat = pos:GetSongBeat() or 0

                -- limpiar hijos en cada frame (regenerar posiciones)
                self:RemoveAllChildren()

                if beat >= startBeat then
                    for i=0,NUM_LINES-1 do
                        local y_off = (i * LINE_SPACING) - ((beat - startBeat) * LINE_SPACING)

                        self:AddChild(
                            LoadActor("NoteField bars 1x4") .. {
                                InitCommand=function(s)
                                    s:diffusealpha(ALPHA)
                                    s:y(y_off)
                                    s:x(0)
                                end
                            }
                        )
                    end
                end
            end)
        end
    }
end

-- Devolvemos el ActorFrame principal del NoteField
return function()
    return Def.ActorFrame {
        BeatBars()
    }
end
