local t = Def.ActorFrame{}

local images = {
    "first.png",
    "second.png",
    "third.png",
    "fourth.png",
    "fifth.png",
    "sixth.png"
}

local displayTime = 8
local fadeTime = 0.5
local overlapDelay = displayTime * 0.08 

t[#t+1] = Def.Sprite{ Name="SlideA", InitCommand=function(s) s:FullScreen():diffusealpha(1) end }
t[#t+1] = Def.Sprite{ Name="SlideB", InitCommand=function(s) s:FullScreen():diffusealpha(0) end }

t[#t+1] = Def.Actor{
    OnCommand = function(self)
        self.index = 1   
        self.frontIsA = true

        local a = self:GetParent():GetChild("SlideA")
        local b = self:GetParent():GetChild("SlideB")

        local path = THEME:GetPathG("Premium","Customizer/background/HinaBita Slideshow/"..images[1])
        a:Load(path):FullScreen():diffusealpha(1)
        b:diffusealpha(0)

        self:sleep(displayTime):queuecommand("Next")
    end,

    NextCommand = function(self)
        local a = self:GetParent():GetChild("SlideA")
        local b = self:GetParent():GetChild("SlideB")

        local front = self.frontIsA and a or b
        local back  = self.frontIsA and b or a

        self.index = (self.index % #images) + 1
        local path = THEME:GetPathG("Premium","Customizer/background/HinaBita Slideshow/"..images[self.index])
        back:stoptweening():Load(path):FullScreen():diffusealpha(0)

        back:linear(fadeTime):diffusealpha(1)

        front:sleep(overlapDelay):linear(fadeTime):diffusealpha(0)

        self.frontIsA = not self.frontIsA

        self:sleep(displayTime):queuecommand("Next")
    end
}

return t
