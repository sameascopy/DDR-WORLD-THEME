local function ApplyRealMMod(pn)
    local m = getenv("SelectedMMod_" .. pn)
    if not m then return end

    local steps = GAMESTATE:GetCurrentSteps(pn)
    if not steps then return end

    -- 🔑 BPM CORRECTO PARA SCROLL
    local bpms = steps:GetDisplayBpms()
    local bpmMax = bpms[2]
    if not bpmMax or bpmMax <= 0 then return end

    -- XMod REAL equivalente a MMod
    local xmod = m / bpmMax

    local ps = GAMESTATE:GetPlayerState(pn)
    ps:GetPlayerOptions("ModsLevel_Song"):XMod(xmod)
end

return Def.ActorFrame{
    OnCommand = function(self)
        for _, pn in ipairs(GAMESTATE:GetEnabledPlayers()) do
            ApplyRealMMod(pn)
        end
    end,

    CurrentStepsP1ChangedMessageCommand = function(self)
        ApplyRealMMod(PLAYER_1)
    end,
    CurrentStepsP2ChangedMessageCommand = function(self)
        ApplyRealMMod(PLAYER_2)
    end,
}
