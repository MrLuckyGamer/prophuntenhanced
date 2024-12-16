if GAMEMODE && IsValid(GAMEMODE.ScoreboardPanel) then
	GAMEMODE.ScoreboardPanel:Remove()
end

local menu

surface.CreateFont("ScoreboardPlayer", {
	font = "coolvetica",
	size = 32,
	weight = 500,
	antialias = true,
	italic = false
})

local function createRoboto(s)
	surface.CreateFont("RobotoHUD-" .. s, {
		font = "Roboto",
		size = math.Round(ScrW() / 1000 * s),
		weight = 700,
		antialias = true,
		italic = false
	})
	surface.CreateFont("RobotoHUD-L" .. s, {
		font = "Roboto",
		size = math.Round(ScrW() / 1000 * s),
		weight = 500,
		antialias = true,
		italic = false
	})
end

for i = 1, 50, 1 do
	createRoboto(i)
end
createRoboto(8)

function draw.ShadowText(n, f, x, y, c, px, py, shadowColor)
	draw.SimpleText(n, f, x + 1, y + 1, shadowColor or color_black, px, py)
	draw.SimpleText(n, f, x, y, c, px, py)
end

local function colMul(color, mul)
	color.r = math.Clamp(math.Round(color.r * mul), 0, 255)
	color.g = math.Clamp(math.Round(color.g * mul), 0, 255)
	color.b = math.Clamp(math.Round(color.b * mul), 0, 255)
end

// local function formatTime(totalSeconds)
//     local days = math.floor(totalSeconds / 86400)
//     local hours = math.floor((totalSeconds % 86400) / 3600)
//     local minutes = math.floor((totalSeconds % 3600) / 60)

//     return days, hours, minutes
// end

local muted = Material("icon32/muted.png", "noclamp")

local function addPlayerItem(self, mlist, ply, pteam)
	local but = vgui.Create("DButton")
	but.player = ply
	but.ctime = CurTime()
	but:SetTall(draw.GetFontHeight("RobotoHUD-20") + 4)
	but:SetText("")

	function but:Paint(w, h)
		local bgColor = Color(45, 45, 45, 150)
		local hoverColor = Color(60, 60, 60, 150)
		local clickColor = Color(70, 70, 70, 150)

		surface.SetDrawColor(bgColor)
		draw.RoundedBox(6, 0, 0, w, h, bgColor)

		if self:IsHovered() then
			surface.SetDrawColor(hoverColor)
		elseif self:IsDown() then
			surface.SetDrawColor(clickColor)
		end
		draw.RoundedBox(6, 0, 0, w, h, surface.GetDrawColor())

		if IsValid(ply) && ply:IsPlayer() then
			local s = 4

			if !ply:Alive() then
				local iconSize = 32
				local xPos = s
				local yPos = h / 2 - iconSize / 5.5
				draw.SimpleText("☠", "RobotoHUD-18", xPos, yPos, Color(200, 0, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				s = s + iconSize + 20
			end			

			if ply:IsMuted() then
				surface.SetMaterial(muted)
				surface.SetDrawColor(150, 150, 150, 255)
				surface.DrawTexturedRect(s, h / 2 - 16, 32, 32)
				s = s + 32 + 4
			end

			local col = Color(220, 220, 220)

			// local time = ply:GetUTimeTotalTime() or 0
			// local days, hours, minutes, seconds = formatTime(math.floor(time))

			// local timeString = ""
			// if days > 0 then
			// 	timeString = timeString .. days .. "d "
			// end
			// timeString = timeString .. string.format("%2dh %2dm", hours, minutes)

			// draw.ShadowText(timeString, "RobotoHUD-L20", w - 110, 0, col, 2)
			draw.ShadowText(ply:Ping(), "RobotoHUD-L20", w - 4, 0, col, 2)
			draw.ShadowText(ply:Nick(), "RobotoHUD-L20", s, 0, col, 0)
		end
	end

	function but:DoClick()
		if IsValid(ply) then
			GAMEMODE:DoScoreboardActionPopup(ply)
		end
	end

	mlist:AddItem(but)
end

local function doPlayerItems(self, mlist, pteam)
	for k, ply in pairs(team.GetPlayers(pteam)) do
		local found = false

		for t,v in pairs(mlist:GetCanvas():GetChildren()) do
			if v.player == ply then
				found = true
				v.ctime = CurTime()
			end
		end

		if !found then
			addPlayerItem(self, mlist, ply, pteam)
		end
	end

	local del = false

	for t,v in pairs(mlist:GetCanvas():GetChildren()) do
		if !v.perm && v.ctime != CurTime() then
			v:Remove()
			del = true
		end
	end

	if del then
		timer.Simple(0, function() mlist:GetCanvas():InvalidateLayout() end)
	end
end

local function makeTeamList(parent, pteam)
	local mlist
	local pnl = vgui.Create("DPanel", parent)
	pnl:DockPadding(0, 0, 0, 0)

	local hs = math.Round(draw.GetFontHeight("RobotoHUD-25") * 1.1)
	function pnl:Paint(w, h)
		surface.SetDrawColor(36, 36, 36, 150)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(68, 68, 68, 255)
		surface.DrawLine(0, hs, 0, h - 1)
		surface.DrawLine(w - 1, hs, w - 1, h - 1)
		surface.DrawLine(0, h - 1, w, h - 1)

		surface.SetDrawColor(0, 0, 0, 155)
		surface.DrawRect(1, hs, w - 2, h - hs)
	end

	function pnl:Think()
		if !self.RefreshWait || self.RefreshWait < CurTime() then
			self.RefreshWait = CurTime() + 0.1
			doPlayerItems(self, mlist, pteam)
		end
	end

	local headp = vgui.Create("DPanel", pnl)
	headp:DockMargin(0, 0, 0, 4)
	headp:Dock(TOP)
	headp:SetTall(hs)
	function headp:Paint(w, h)
		draw.RoundedBoxEx(4, 0, 0, w, h, Color(36, 36, 36), true, true, false, false)
		draw.ShadowText(team.GetName(pteam), "RobotoHUD-25", 6, 0, team.GetColor(pteam), 0)
	end

	local but = vgui.Create("DButton", headp)
	but:Dock(RIGHT)
	but:SetText("")
	surface.SetFont("RobotoHUD-20")
	local tw, th = surface.GetTextSize("Join Team")
	but:SetWide(tw + 6)
	function but:DoClick()
		RunConsoleCommand("changeteam", pteam)
	end
	function but:Paint(w, h)
		local col = table.Copy(team.GetColor(pteam))
		if self:IsDown() then
			surface.SetDrawColor(12, 50, 50, 120)
			col.r = col.r * 0.8
			col.g = col.g * 0.8
			col.b = col.b * 0.8
		elseif self:IsHovered() then
			surface.SetDrawColor(255, 255, 255, 30)
			col.r = col.r * 1.2
			col.g = col.g * 1.2
			col.b = col.b * 1.2
		end
		draw.ShadowText("Join Team", "RobotoHUD-20", 2, h / 2 - th / 2, col, 0)
	end

	mlist = vgui.Create("DScrollPanel", pnl)
	mlist:Dock(FILL)

	local canvas = mlist:GetCanvas()
	canvas:DockPadding(8, 8, 8, 8)
	function canvas:OnChildAdded(child)
		child:Dock(TOP)
		child:DockMargin(0, 0, 0, 4)
	end

	local head = vgui.Create("DPanel")
	head:SetTall(draw.GetFontHeight("RobotoHUD-15") * 1.05)
	head.perm = true
	local col = Color(190, 190, 190)
	function head:Paint(w, h)
		draw.ShadowText("Name", "RobotoHUD-15", 4, 0, col, 0)
		draw.ShadowText("Ping", "RobotoHUD-15", w - 4, 0, col, 2)
		// draw.ShadowText("PlayTime", "RobotoHUD-15", w - 110, 0, col, 2)
	end
	mlist:AddItem(head)

	return pnl
end

function GM:ScoreboardRoundResults(results)
	self:ScoreboardShow()
	menu.ResultsPanel.Results = results
	menu.ResultsPanel:InvalidateLayout()
end

function GM:ScoreboardShow()
	if IsValid(menu) then
		if GAMEMODE.GameState == 3 then
			menu:SetVisible(false)
		else
			menu:SetVisible(true)
		end
	else
		menu = vgui.Create("DFrame")
		GAMEMODE.ScoreboardPanel = menu
		menu:SetSize(ScrW() * 0.8, ScrH() * 0.8)
		menu:Center()
		menu:MakePopup()
		menu:SetKeyboardInputEnabled(false)
		menu:SetDeleteOnClose(false)
		menu:SetDraggable(false)
		menu:ShowCloseButton(false)
		menu:SetTitle("")
		menu:DockPadding(8, 8, 8, 8)
		function menu:PerformLayout()
			if IsValid(menu.CopsList) then
				menu.CopsList:SetWidth((self:GetWide() - 16) * 0.5)
			end
		end

		function menu:Paint(w, h)
			surface.SetDrawColor(36, 36, 36, 220)
			surface.DrawRect(0, 0, w, h)
		end

		menu.Credits = vgui.Create("DPanel", menu)
		menu.Credits:Dock(TOP)
		menu.Credits:DockMargin(0, 0, 0, 4)
		function menu.Credits:Paint(w, h)
			surface.SetFont("RobotoHUD-25")
			local t = GAMEMODE.Name or ""
			local tw, th = surface.GetTextSize(t)
			draw.ShadowText(t, "RobotoHUD-25", 4, 0, Color(199, 49, 29), 0)

			draw.ShadowText("by: Wolvindra-Vinzuerio, Jai Choccy Fox, & Lucky.", "RobotoHUD-L15", 4 + tw + 24, h * 0.9, Color(220, 220, 220), 0, 4)

			local round = GetGlobalInt("RoundNumber", 0)
			local total_rounds = GetConVarNumber("ph_rounds_per_map")

			local rounds_left = total_rounds - round

			draw.ShadowText("Rounds until map vote: " .. rounds_left, "RobotoHUD-L15", w - 10, h * 0.9, Color(220, 220, 220), TEXT_ALIGN_RIGHT, 4)
		end

		function menu.Credits:PerformLayout()
			surface.SetFont("RobotoHUD-25")
			local w, h = surface.GetTextSize(GAMEMODE.Name or "")
			self:SetTall(h)
		end

		local bottom = vgui.Create("DPanel", menu)
		bottom:SetTall(draw.GetFontHeight("RobotoHUD-15") * 1.3)
		bottom:Dock(BOTTOM)
		bottom:DockMargin(0, 8, 0, 0)

		surface.SetFont("RobotoHUD-15")
		local tw, th = surface.GetTextSize("Spectate")

		function bottom:Paint(w, h)
			local c
			for k, ply in pairs(team.GetPlayers(TEAM_SPECTATOR)) do
				if c then
					c = c .. ", " .. ply:Nick()
				else
					c = ply:Nick()
				end
			end
			if c then
				draw.ShadowText(c, "RobotoHUD-10", tw + 8 + 4, h / 2, color_white, 0, 1)
			end
			local mapName = "Map: " .. game.GetMap()
			draw.ShadowText(mapName, "RobotoHUD-L15", w - 10, h * 0.9, Color(220, 220, 220), TEXT_ALIGN_RIGHT, 4)
		end

		local but = vgui.Create("DButton", bottom)
		but:Dock(LEFT)
		but:SetText("")
		but:DockMargin(0, 0, 4, 0)

		but:SetWide(tw + 8)
		function but:Paint(w, h)
			local col = Color(36, 36, 36, 220)
			if self:IsHovered() then
				col = Color(55, 55, 55, 220)
			elseif self:IsDown() then
				col = Color(80, 80, 80, 220)
			end
			draw.RoundedBox(4, 0, 0, w, h, col)
            draw.ShadowText("Spectate", "RobotoHUD-15", 4, h / 2 - th / 2, Color(255, 255, 160), 0)
		end

		function but:DoClick()
			RunConsoleCommand("changeteam", TEAM_SPECTATOR)
		end

		local main = vgui.Create("DPanel", menu)
		main:Dock(FILL)
		function main:Paint(w, h)
			surface.SetDrawColor(40,40,40,220)
		end

		menu.CopsList = makeTeamList(main, 1)
		menu.CopsList:Dock(LEFT)
		menu.CopsList:DockMargin(0, 0, 8, 0)
		menu.RobbersList = makeTeamList(main, 2)
		menu.RobbersList:Dock(FILL)


	end
	
end

function GM:ScoreboardHide()
	if GAMEMODE.GameState == 3 then
		menu:Close()
		return
	end
	if IsValid(menu) then
		menu:Close()
	end
end

function GM:HUDDrawScoreBoard()
end

function GM:DoScoreboardActionPopup(ply)
    local actions = DermaMenu()

    if ply:IsAdmin() then
        local admin = actions:AddOption("Is a Staff Member")
        admin:SetIcon("icon16/shield.png")
    end

    if ply != LocalPlayer() then
        local t = "Mute"
        if ply:IsMuted() then
            t = "Unmute"
        end
        local mute = actions:AddOption(t)
        mute:SetIcon("icon16/sound_mute.png")
        function mute:DoClick()
            if IsValid(ply) then
                ply:SetMuted(!ply:IsMuted())
            end
        end
    end

    local steamProfile = actions:AddOption("Open Steam Profile")
    steamProfile:SetIcon("icon16/user.png")
    function steamProfile:DoClick()
        if IsValid(ply) then
            local steamID64 = ply:SteamID64()
            local steamProfileURL = "https://steamcommunity.com/profiles/" .. steamID64
            gui.OpenURL(steamProfileURL)
        end
    end

	-- ULX Commands Bellow, change or delete if you are not using ULX on your server.
	if IsValid(LocalPlayer()) and LocalPlayer():IsAdmin() then
		actions:AddSpacer()
	
		local kickOption = actions:AddOption("Kick Player")
		kickOption:SetIcon("icon16/cross.png")
		function kickOption:DoClick()
			if IsValid(ply) then
				local kickFrame = vgui.Create("DFrame")
				kickFrame:SetTitle("Kick " .. ply:Nick())
				kickFrame:SetSize(400, 200)
				kickFrame:Center()
				kickFrame:MakePopup()

				local reasonLabel = vgui.Create("DLabel", kickFrame)
				reasonLabel:SetPos(10, 30)
				reasonLabel:SetText("Reason for kicking: " .. ply:Nick())
				reasonLabel:SizeToContents()
	
				local reasonEntry = vgui.Create("DTextEntry", kickFrame)
				reasonEntry:SetPos(10, 50)
				reasonEntry:SetSize(380, 30)

				local kickButton = vgui.Create("DButton", kickFrame)
				kickButton:SetPos(10, 100)
				kickButton:SetSize(380, 40)
				kickButton:SetText("Kick Player")
				kickButton.DoClick = function()
					local reason = reasonEntry:GetValue()
					if reason != "" then
						if ply:IsBot() then
							RunConsoleCommand("ulx", "kick", ply:Nick(), reason)
						else
							RunConsoleCommand("ulx", "kick", ply:SteamID64(), reason)
						end
						kickFrame:Close()
					end
				end
			end
		end

		local banOption = actions:AddOption("Ban Player")
		banOption:SetIcon("icon16/stop.png")
		function banOption:DoClick()
			if IsValid(ply) then
				local banFrame = vgui.Create("DFrame")
				banFrame:SetTitle("Ban " .. ply:Nick())
				banFrame:SetSize(400, 300)
				banFrame:Center()
				banFrame:MakePopup()

				local reasonLabel = vgui.Create("DLabel", banFrame)
				reasonLabel:SetPos(10, 30)
				reasonLabel:SetText("Reason for banning: " .. ply:Nick())
				reasonLabel:SizeToContents()
	
				local reasonEntry = vgui.Create("DTextEntry", banFrame)
				reasonEntry:SetPos(10, 50)
				reasonEntry:SetSize(380, 30)

				local durationLabel = vgui.Create("DLabel", banFrame)
				durationLabel:SetPos(10, 90)
				durationLabel:SetText("Ban Duration (minutes):")
				durationLabel:SizeToContents()
	
				local durationEntry = vgui.Create("DTextEntry", banFrame)
				durationEntry:SetPos(10, 110)
				durationEntry:SetSize(380, 30)

				local banButton = vgui.Create("DButton", banFrame)
				banButton:SetPos(10, 150)
				banButton:SetSize(380, 40)
				banButton:SetText("Ban Player")
				banButton.DoClick = function()
					local reason = reasonEntry:GetValue()
					local duration = tonumber(durationEntry:GetValue())
					if reason != "" and duration and duration > 0 then
						if ply:IsBot() then
							RunConsoleCommand("ulx", "ban", ply:Nick(), duration, reason)
						else
							RunConsoleCommand("ulx", "ban", ply:SteamID64(), duration, reason)
						end
						banFrame:Close()
					end
				end
			end
		end
    end

    actions:Open()
end