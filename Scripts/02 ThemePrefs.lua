local Background = {
		"World (Pattern 1)", "World (Pattern 2)", "World (Pattern 3)", "World (Pattern 4)", "World (Pattern 5)", "Hexagram (Pattern 1)", "Hexagram (Pattern 2)", "Hexagram (Pattern 3)", "Hexagram (Pattern 4)", "Hexagram (Pattern 5)", "Hexagram (Pattern 6)", "BemaniProLeague S2", "BemaniProLeague S4", "BemaniProLeague Emi", "HinaBita Chikuwa Festival 2023", "HinaBita Chikuwa Festival 2025", "HinaBita Mini Characters", "HinaBita SlideShow", "Arrow (Pattern 1)", "Arrow (Pattern 2)", "Arrow (Pattern 3)", "Arrow (Pattern 4)", "Arrow (Pattern 5)", "Arrow (Pattern 6)", 
		-- "Spring Festival 2024", "Spring Festival Mini Mascots", "Spring Festival SlideShow", "Ocean (Pattern 1)", "Ocean (Pattern 2)", "Ocean (Pattern 3)", "Hyper Distortion (Pattern 1)", "Hyper Distortion (Pattern 2)", "Hyper Distortion (Pattern 3)",
		"Gaussian", "Candy",
}

local SelectMusic = {}
for _, bg in ipairs(Background) do
    if bg ~= "Gaussian" then
        table.insert(SelectMusic, bg)
    end
end

local Characters = {
    "Off", "Emi", "Rage", "Alice", "Baby-Lon", "BemaniProLeague Emi", "BemaniProLeague Rage", "Yamagata Marika", "Izumi Kazuma", "Kasuga Sakiko", "Meto Meu", "Shimotsuki Rin", "Shinonome Natsuhi", "Shinonome Kokona", "Yuni", "Akira", "Amato Kon", "Komai Sakura",
	-- "Tsugaru", "Grace", "Rinon", "Mimi", "Rio", "Summer Yuni", "Summer Alice", "Hainiwa Mayoi", "Hineri"
}

local FilterSingle = {
	"Normal", "Emi", "Rage", "World", "Alice", "Baby-Lon", "Grid", "BemaniProLeague S2", "BemaniProLeague S4", "BemaniProLeague Emi", "BemaniProLeague Rage", "Yamagata Marika", "Izumi Kazuma", "Kasuga Sakiko", "Meto Meu", "Shimotsuki Rin", "Shinonome Natsuhi", "Shinonome Kokona", "Yuni", "Akira", "HoneyComb", "Bag", "Amato Kon", "Komai Sakura", "ShockArrow",
	-- "Tsugaru", "Grace", "Rinon", "Mimi", "Rio", "Triangle", "Summer Yuni", "Summer Alice", "Sunflower", "Hainiwa Mayoi", "Hineri", "HyperDril",
}

local FilterDouble = {
	"Normal", "Emi", "Rage", "Emi & Rage", "World", "Alice", "Baby-Lon", "Alice & Emi", "Grid"
}

local CoverSingle = {
	"Normal", "Amato Kon", "Komai Sakura",
}

local CoverDouble = {
	"Normal",
}



local Prefs = {
	SelectMusicBG = {
		Default = SelectMusic[1],
		Choices = SelectMusic,
		Values = SelectMusic,
	},
	GameplayBG = {
		Default = Background[1],
		Choices = Background,
		Values = Background,
	},
	CharacterP1 = {
        Default = Characters[2],
        Choices = Characters,
        Values = Characters,
    },
    CharacterP2 = {
        Default = Characters[3],
        Choices = Characters,
        Values = Characters,
    },
	FilterP1 = {
        Default = FilterSingle[1],
        Choices = FilterSingle,
        Values = FilterSingle,
    },
    FilterP2 = {
        Default = FilterSingle[1],
        Choices = FilterSingle,
        Values = FilterSingle,
    },
	FilterDouble = {
        Default = FilterDouble[1],
        Choices = FilterDouble,
        Values = FilterDouble,
    },
	
	CoverP1 = {
        Default = CoverSingle[1],
        Choices = CoverSingle,
        Values = CoverSingle,
    },
    CoverP2 = {
        Default = CoverSingle[1],
        Choices = CoverSingle,
        Values = CoverSingle,
    },
	CoverDouble = {
        Default = CoverDouble[1],
        Choices = CoverDouble,
        Values = CoverDouble,
    },
	VideoSize = {
        Default = "FullScreen",
        Choices = {"Off", "Small", "Medium", "FullScreen", },
        Values = {"Off", "Small", "Medium", "FullScreen", },
    },
	SpeedMod = {
        Default = "Xmod",
        Choices = {"Xmod", "Mmod", "Cmod", },
        Values = {"Xmod", "Mmod", "Cmod", },
    },
};

ThemePrefs.InitAll(Prefs)

function FilterGraph(pn)
	if pn == PLAYER_2 then
		return ThemePrefs.Get("FilterP2")
	else
		return ThemePrefs.Get("FilterP1")
	end
end

function CoverGraph(pn)
	if pn == PLAYER_2 then
		return ThemePrefs.Get("CoverP2")
	else
		return ThemePrefs.Get("CoverP1")
	end
end

function OptionSpeedMod()
	if ThemePrefs.Get("SpeedMod") == "Mmod" then
		return "lua,OptionRowSpeedM()"
	elseif ThemePrefs.Get("SpeedMod") == "Cmod" then
		return "lua,OptionRowSpeedC()"
	else
		return "lua,OptionRowSpeedX()"
	end
end
	
