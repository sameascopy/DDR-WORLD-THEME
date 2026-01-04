function GetVideoChanges()
	local song = GAMESTATE:GetCurrentSong()
	if not song then return false end
	
	if song and song.HasMusicVideo and song:HasMusicVideo() then
		return true
	end

	local songDir = song:GetSongDir()
	local files = FILEMAN:GetDirListing(songDir.."/")
	
	for _, file in ipairs(files) do
	
		local ext = file:match("^.+(%..+)$")
		ext = ext and ext:lower() or ""
		
		local allowedExtensions = {
			[".sm"]=true, [".ssc"]=true, [".ogg"]=true, [".mp3"]=true,
			[".wav"]=true, [".png"]=true, [".jpg"]=true, [".jpeg"]=true, [".bmp"]=true
		}
		
		if not allowedExtensions[ext] then
			return true
		end
		
	end
	
	local bg = song:GetBGChanges()
	if bg and #bg > 0 then return true end

	return false
end







local path = THEME:GetPathG("","Premium Customizer/background/World (Pattern 1)")
if not GAMESTATE:IsDemonstration() then
	path = THEME:GetPathG("","Premium Customizer/background/"..ThemePrefs.Get("GameplayBG"))
end

local cond;
if not (ThemePrefs.Get("VideoSize") == "Small" or ThemePrefs.Get("VideoSize") == "Medium") then
	cond = not GetVideoChanges()
end

return Def.ActorFrame {
	loadfile(path)()..{
		Condition=cond
	};
};