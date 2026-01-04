local t = Def.ActorFrame{};
local screenName = Var "LoadingScreen"

local footerTextImage
if screenName == "ScreenSelectMusic" or screenName == "ScreenSelectCourse" then
	footerTextImage = Language().."selmus"
elseif screenName == "ScreenEvaluationNormal" then
	footerTextImage = Language().."eval"
elseif screenName == "ScreenEvaluationSummary" then
	footerTextImage = Language().."total"
elseif screenName == "ScreenSelectStyle" then
	footerTextImage = Language().."style"
end

return Def.ActorFrame{
	Condition=footerTextImage;
	Def.Quad{
		InitCommand=function(s) s:diffuse(color("#000000")):setsize(SCREEN_WIDTH,40):y(20) end,
	};
	Def.Sprite{
		Texture=footerTextImage,
		InitCommand=function(s) s:zoom(0.667):y(15) end,
	};
};