local t = LoadFallbackB();

t[#t+1] = Def.ActorFrame {
	LoadActor(THEME:GetPathB("","ModDate"));
};

return t
