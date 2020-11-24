hook.Add("PH_CustomTabMenu", "PHE.About", function(tab, pVgui)
	
	surface.CreateFont("PHE.TitleFont", 
	{
		font = "Roboto",
		size = 40,
		weight = 700,
		antialias = true,
		shadow = true
	})
	
	local panel = vgui.Create("DPanel", tab)
	panel:SetBackgroundColor(Color(40,40,40,120))
	
	local scroll = vgui.Create( "DScrollPanel", panel )
	scroll:Dock(FILL)
	
	local grid = vgui.Create("DGrid", scroll)
	grid:Dock(NODOCK)
	grid:SetPos(10,10)
	grid:SetCols(1)
	grid:SetColWide(800)
	grid:SetRowHeight(50)
	
	local label = {
		title 	= "Prop Hunt: Enhanced",
		author	= "Enhanced by: Wolvindra-Vinzuerio, D4UNKN0WNM4N & Lucky. Original: AMT.",
		version = GAMEMODE._VERSION,
		rev 	= GAMEMODE.REVISION,
		credits	= "Yam, Lucky, Godfather, adk, Lucas2107, Jonpopnycorn, Thundernerd",
		lgit	= "https://github.com/MrLuckyGamer/prophuntenhanced",
		lhome	= "https://prophuntenhanced.xyz/",
		ldonate = GAMEMODE.DONATEURL,
		lwiki	= "https://prophuntenhanced.xyz/wiki/index.php",
		lklog	= "https://prophunt.wolvindra.net/changelogs",
		lplugins = "https://prophuntenhanced.xyz/plugins"
	}
	
	pVgui("","label","PHE.TitleFont",grid, label.title .. " [BETA]" )
	pVgui("","label","Trebuchet24",grid, "Current Version: "..label.version.." | Current Revision: "..label.rev)
	pVgui("","label","Trebuchet24",grid, "If you have enjoyed the gamemode, Please support by Donating!" )
	pVgui("spacer0","spacer",nil,grid,"" )
	pVgui("","label",false,grid, "Helpful External Links & Credits" )
	pVgui("","btn",{max = 4,textdata = {
		[1] = {"DONATE to PH:E Project", 	  function() gui.OpenURL(label.ldonate) end},
		[2] = {"PH:E Official Homepage", 	  function() gui.OpenURL(label.lhome) end},
		[3] = {"GitHub Repository", 	  	  function() gui.OpenURL(label.lgit) end},
		[4] = {"PH:E Manuals & Wiki", 		  function() gui.OpenURL(label.lwiki) end},
		[4] = {"PH:E Addons/Plugins", 		  function() gui.OpenURL(label.lplugins) end}
	}},grid,"")
	pVgui("spacer1","spacer",nil,grid,"" )
	pVgui("","label","Trebuchet24",grid, "Special Thanks for the support, suggestion & contributing:\n"..label.credits )
	
	tab:AddSheet("About & Credits",panel,"icon16/information.png")

end)