hook.Add("PH_CustomTabMenu", "PHE.About", function(tab, pVgui)
	surface.CreateFont("PHE.TitleFont", {
		font = "Roboto",
		size = 40,
		weight = 700,
		antialias = true,
		shadow = true
	})

	local panel = vgui.Create("DPanel", tab)
	panel:SetBackgroundColor(Color(40, 40, 40, 120))

	local scroll = vgui.Create("DScrollPanel", panel)
	scroll:Dock(FILL)

	local grid = vgui.Create("DGrid", scroll)
	grid:Dock(NODOCK)
	grid:SetPos(10, 10)
	grid:SetCols(1)
	grid:SetColWide(800)
	grid:SetRowHeight(50)

	local label = {
		title 	= "Prop Hunt: Enhanced",
		authors	= "Wolvindra-Vinzuerio, Jai Choccy Fox, Lucky, Fafy & KO-pKAs3tnj5sU8e85yuXA", 
		version = GAMEMODE._VERSION,
		credits	= "Yam, Lucky, Godfather, adk, Lucas2107, Jonpopnycorn, Thundernerd, stephanlachnit",
		lhome	= "https://prophuntenhanced.xyz/",
		ldonate = GAMEMODE.DONATEURL,
		lgit	= "https://github.com/MrLuckyGamer/prophuntenhanced",
		lwiki	= "https://wiki.prophuntenhanced.xyz/",
		lplugins = "https://prophuntenhanced.xyz/plugins"
	}

	pVgui("", "label", "PHE.TitleFont", grid, label.title)
	pVgui("", "label", "Trebuchet24", grid, PHE.LANG.PHEMENU.ABOUT.CURRENTVER .. label.version)
	pVgui("", "label", "Trebuchet24", grid, PHE.LANG.PHEMENU.ABOUT.ENHANCED_BY .. label.authors) 
	pVgui("", "label", "Trebuchet24", grid, PHE.LANG.PHEMENU.ABOUT.ENJOYING)
	pVgui("", "label", false, grid, PHE.LANG.PHEMENU.ABOUT.LINKS)
	pVgui("", "btn", {max = 5, textdata = {
		[1] = { PHE.LANG.PHEMENU.ABOUT.HOME,	function() gui.OpenURL(label.lhome) end},
		[2] = { PHE.LANG.PHEMENU.ABOUT.DONATE,	function() gui.OpenURL(label.ldonate) end},
		[3] = { PHE.LANG.PHEMENU.ABOUT.GIT,		function() gui.OpenURL(label.lgit) end},
		[4] = { PHE.LANG.PHEMENU.ABOUT.WIKI,	function() gui.OpenURL(label.lwiki) end},
		[5] = { PHE.LANG.PHEMENU.ABOUT.PLUGINS,	function() gui.OpenURL(label.lplugins) end},
	}}, grid, "")
	pVgui("spacer1", "spacer", nil, grid, "")
	pVgui("", "label", "Trebuchet24", grid, PHE.LANG.PHEMENU.ABOUT.THANKS .. "\n" .. label.credits)

	tab:AddSheet(PHE.LANG.PHEMENU.ABOUT.TAB, panel, "icon16/information.png")
end)