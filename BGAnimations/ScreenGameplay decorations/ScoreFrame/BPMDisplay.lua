local pn = ({...})[1]

local function UpdateSingleBPM(self)
	local bpmDisplay = self:GetChild("BPMDisplay")
	local ps = GAMESTATE:GetPlayerState(pn)
	local song = ps:GetSongPosition()
	local bpm = song:GetCurBPS()*60
	local po = ps:GetPlayerOptions("ModsLevel_Current")
	local speed = bpm*(po:ScrollSpeed())
	
	if not song:GetFreeze() and not song:GetDelay() then
		if speed > 10000 then
			bpmDisplay:settext("9999")
		else
			bpmDisplay:settext(string.format("%04.0f",speed) )
		end
	else
		bpmDisplay:settext("0000")
	end
end

return Def.ActorFrame{
	InitCommand=function(s) s:SetUpdateFunction(UpdateSingleBPM) end,
	Def.BitmapText{
		Name="BPMDisplay";
		Font="_arial black 28px",
		InitCommand=function(s) s:draworder(101):zoomx(0.6):zoomy(0.7):y(-1):diffuse(color("#14caac")) end,
	};
	Def.BitmapText{
		Font="_arial black 28px",
		InitCommand=function(s) s:settext("SPEED"):zoom(0.4):y(13):diffuse(color("#14caac")) end,
	};
};