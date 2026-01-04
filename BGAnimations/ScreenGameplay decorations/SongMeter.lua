local function GetSongPercent()
    local song = GAMESTATE:GetCurrentSong()
    if not song then return 0 end
    local songPos = GAMESTATE:GetSongPosition()
    if not songPos then return 0 end

    local musicLength = song:GetLastSecond() or 1
    local elapsed = songPos:GetMusicSeconds() or 0

    local percent = math.min(elapsed / musicLength, 1)
    return percent
end

return Def.ActorFrame{
    InitCommand=function(self) 
		self:xy(_screen.cx-97.5,SCREEN_BOTTOM-38)
    end,

    Def.Quad{
        Name="ProgressBar",
        InitCommand=function(self)
            self:setsize(1,39)
            self:horizalign(left)
			if GAMESTATE:GetCurrentStyle():GetStepsType() == 'StepsType_Dance_Double' then
				self:diffuse(color("#000000"))
			else	
				self:diffuse(color("#ffffff"))
			end
        end,
        OnCommand=function(self)
            self:queuecommand("Update")
        end,
        UpdateCommand=function(self)
			local percent = GetSongPercent()
			local width = (SCREEN_WIDTH/4.38) * percent
    
    -- Animación suave hacia el nuevo ancho
			self:stoptweening()               -- cancela animaciones anteriores
			self:smooth(0.01)                 -- duración de la transición
			self:zoomx(width)                 -- cambia el tamaño suavemente

			self:queuecommand("Update")       -- sigue actualizando
		end
    }
}
