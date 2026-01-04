local function background(X,Y,Z,L,S,D)
    local tex			= GetJacketPath(GAMESTATE:GetCurrentSong())
    local xpos			= X
    local ypos			= Y
    local w				= _screen.w
    local h				= _screen.h+100
	local zoom			= Z
    local layers		= L
    local strength		= S
	local distance		= D

    local t = Def.ActorFrame{}

    t[#t+1] = Def.Sprite{
        Texture=tex,
        InitCommand=function(self)
            self:xy(xpos, ypos)
            self:zoomto(w,h)
            self:diffusealpha(1)
        end
    }
    for i = 1, layers do
        t[#t+1] = Def.Sprite{
            Texture=tex,
            InitCommand=function(self)
                self:xy(xpos, ypos)
                self:zoomto(w + ((i * strength)*(D*100)),h + ((i * strength))*(D*100))
                self:diffusealpha(1 / (i * 3))
            end
        }
    end

    return t
end

return Def.ActorFrame{
	background(_screen.cx,_screen.cy,1.5,8,0.05,3)
};