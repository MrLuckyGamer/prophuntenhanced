surface.CreateFont("PHE.MapVoteTitle", {
	font = "Roboto",
	size = 26,
	weight = 700,
	antialias = true,
})

surface.CreateFont("PHE.MapVoteSub", {
	font = "Roboto",
	size = 15,
	weight = 500,
	antialias = true,
})

surface.CreateFont("PHE.MapVoteCountdown", {
	font = "Roboto",
	size = 34,
	weight = 700,
	antialias = true,
})

surface.CreateFont("PHE.MapVoteMapName", {
	font = "Roboto",
	size = 19,
	weight = 700,
	antialias = true,
})

surface.CreateFont("PHE.MapVoteVotes", {
	font = "Roboto",
	size = 14,
	weight = 500,
	antialias = true,
})

surface.CreateFont("PHE.MapVoteClose", {
	font = "Marlett",
	size = 16,
	weight = 0,
	symbol = true,
})

if not draw.ShadowText then
	function draw.ShadowText(n, f, x, y, c, px, py, shadowColor)
		draw.SimpleText(n, f, x + 1, y + 1, shadowColor or color_black, px, py)
		draw.SimpleText(n, f, x, y, c, px, py)
	end
end

local COL_BG          = Color(36, 36, 36, 235)
local COL_ROW         = Color(45, 45, 45, 235)
local COL_ROW_HOVER   = Color(60, 60, 60, 240)
local COL_ROW_DOWN    = Color(70, 70, 70, 240)
local COL_ROW_VOTED   = Color(199, 49, 29, 90)
local COL_BORDER      = Color(68, 68, 68, 255)
local COL_ACCENT      = Color(199, 49, 29, 255)
local COL_TEXT        = Color(220, 220, 220, 255)
local COL_TEXT_DIM    = Color(190, 190, 190, 255)
local COL_WHITE       = Color(255, 255, 255, 255)

MapVote.EndTime = 0
MapVote.Panel = false
MapVote.ThumbCache = MapVote.ThumbCache or {}

local THUMB_LOCAL_PATHS = {
	"maps/thumb/%s.png",
	"maps/thumb/%s.jpg",
	"maps/%s.png",
	"materials/maps/%s.png",
	"materials/thumbnails/%s.png",
	"materials/vgui/maps/%s.png",
}

local GAMETRACKER_URLS = {
	"http://image.gametracker.com/images/maps/160x120/garrysmod/%s.jpg",
	"http://image.gametracker.com/images/maps/160x120/css/%s.jpg",
}

local function TryLoadMaterial(path)
	local mat = Material(path, "noclamp")

	if not mat or mat:IsError() then return nil end

	return mat
end

local function FindLocalThumb(mapname)
	for _, fmt in ipairs(THUMB_LOCAL_PATHS) do
		local relpath = string.format(fmt, mapname)

		if file.Exists(relpath, "GAME") then
			local mat = TryLoadMaterial("../" .. relpath)
			if mat then return mat end
		end
	end

	return nil
end

function MapVote.GetThumbnail(mapname, callback)
	local cached = MapVote.ThumbCache[mapname]
	if cached ~= nil then
		callback(cached or nil)
		return
	end

	local local_mat = FindLocalThumb(mapname)
	if local_mat then
		MapVote.ThumbCache[mapname] = local_mat
		callback(local_mat)
		return
	end

	if GetConVar("mv_thumb_gametracker") and not GetConVar("mv_thumb_gametracker"):GetBool() then
		MapVote.ThumbCache[mapname] = false
		callback(nil)
		return
	end

	local data_rel = "phe_mapthumbs/" .. mapname .. ".jpg"

	if file.Exists("data/" .. data_rel, "GAME") then
		local mat = TryLoadMaterial("../data/" .. data_rel)
		MapVote.ThumbCache[mapname] = mat or false
		callback(mat)
		return
	end

	if not file.IsDir("phe_mapthumbs", "DATA") then
		file.CreateDir("phe_mapthumbs")
	end

	local urls = GAMETRACKER_URLS
	local attempt

	attempt = function(i)
		local url = urls[i]

		if not url then
			MapVote.ThumbCache[mapname] = false
			callback(nil)
			return
		end

		http.Fetch(string.format(url, mapname),
			function(body, len, headers, code)
				if code ~= 200 or not body or len == 0 then
					attempt(i + 1)
					return
				end

				file.Write(data_rel, body)

				local mat = TryLoadMaterial("../data/" .. data_rel)
				MapVote.ThumbCache[mapname] = mat or false
				callback(mat)
			end,
			function(err)
				attempt(i + 1)
			end
		)
	end

	attempt(1)
end

net.Receive("RAM_MapVoteStart", function()
	MapVote.CurrentMaps = {}
	MapVote.Allow = true
	MapVote.Votes = {}

	local amt = net.ReadUInt(32)

	for i = 1, amt do
		local map = net.ReadString()

		MapVote.CurrentMaps[#MapVote.CurrentMaps + 1] = map
	end

	MapVote.EndTime = CurTime() + net.ReadUInt(32)

	if IsValid(MapVote.Panel) then
		MapVote.Panel:Remove()
	end

	MapVote.Panel = vgui.Create("PHE.VoteScreen")
	MapVote.Panel:SetMaps(MapVote.CurrentMaps)
end)

net.Receive("RAM_MapVoteUpdate", function()
	local update_type = net.ReadUInt(3)

	if update_type == MapVote.UPDATE_VOTE then
		local ply = net.ReadEntity()

		if IsValid(ply) then
			local map_id = net.ReadUInt(32)
			MapVote.Votes[ply:SteamID()] = map_id

			if IsValid(MapVote.Panel) then
				MapVote.Panel:AddVoter(ply)
			end
		end
	elseif update_type == MapVote.UPDATE_WIN then
		if IsValid(MapVote.Panel) then
			MapVote.Panel:Flash(net.ReadUInt(32))
		end
	end
end)

net.Receive("RAM_MapVoteCancel", function()
	if IsValid(MapVote.Panel) then
		MapVote.Panel:Remove()
	end
end)

net.Receive("RTV_Delay", function()
	LocalPlayer():ChatMessage("The vote has been rocked, map vote will begin on round end", Color(102, 255, 51), "RTV")
end)

local PANEL = {}

function PANEL:Init()
	self:ParentToHUD()

	self.Canvas = vgui.Create("Panel", self)
	self.Canvas:MakePopup()
	self.Canvas:SetKeyboardInputEnabled(false)
	self.Canvas:SetCursor("arrow")

	self.Canvas.Paint = function(s, w, h)
		draw.RoundedBox(8, 0, 0, w, h, COL_BG)
		surface.SetDrawColor(COL_BORDER)
		surface.DrawOutlinedRect(0, 0, w, h, 1)
	end

	self.Header = vgui.Create("Panel", self.Canvas)
	self.Header.Paint = function(s, w, h)
		draw.ShadowText("Prop Hunt: ENHANCED", "PHE.MapVoteTitle", 16, 8, COL_ACCENT, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.ShadowText("Vote for the next map", "PHE.MapVoteSub", 16, 36, COL_TEXT_DIM, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end

	self.countDown = vgui.Create("DLabel", self.Header)
	self.countDown:SetTextColor(COL_WHITE)
	self.countDown:SetFont("PHE.MapVoteCountdown")
	self.countDown:SetText("")
	self.countDown:SetContentAlignment(6)
	self.countDown:SetExpensiveShadow(1, color_black)

	self.closeButton = vgui.Create("DButton", self.Canvas)
	self.closeButton:SetText("")
	self.closeButton:SetCursor("hand")
	self.closeButton.Paint = function(s, w, h)
		local bg = Color(255, 255, 255, 10)
		if s:IsHovered() then bg = COL_ACCENT end

		draw.RoundedBox(4, 0, 0, w, h, bg)
		draw.SimpleText("r", "PHE.MapVoteClose", w / 2, h / 2, COL_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	self.closeButton.DoClick = function()
		surface.PlaySound("ui/buttonclickrelease.wav")
		self:SetVisible(false)
	end

	self.mapList = vgui.Create("DPanelList", self.Canvas)
	self.mapList:SetPaintBackground(false)
	self.mapList:SetSpacing(6)
	self.mapList:SetPadding(0)
	self.mapList:EnableHorizontal(false)
	self.mapList:EnableVerticalScrollbar()

	local sbar = self.mapList.VBar
	if IsValid(sbar) then
		sbar:SetWide(8)
		sbar.Paint = function(s, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(20, 20, 20, 150)) end
		sbar.btnUp:SetTall(0)
		sbar.btnUp:SetVisible(false)
		sbar.btnDown:SetTall(0)
		sbar.btnDown:SetVisible(false)
		sbar.btnGrip.Paint = function(s, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(90, 90, 90, 220)) end
	end

	self.Footer = vgui.Create("Panel", self.Canvas)
	self.Footer.Paint = function(s, w, h)
		draw.ShadowText("Click a map to cast your vote", "PHE.MapVoteSub", 2, 2, COL_TEXT_DIM, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end

	self.Voters = {}
end

function PANEL:PerformLayout()
	self:SetPos(0, 0)
	self:SetSize(ScrW(), ScrH())

	local cw = math.Clamp(ScrW() * 0.55, 560, 1000)
	local ch = math.Clamp(ScrH() * 0.7, 420, 760)

	self.Canvas:SetSize(cw, ch)
	self.Canvas:Center()
	self.Canvas:SetZPos(0)

	local pad = 16

	self.Header:SetPos(0, 0)
	self.Header:SetSize(cw, 64)

	self.closeButton:SetSize(28, 28)
	self.closeButton:SetPos(cw - 28 - 10, 10)

	self.countDown:SetSize(90, 64)
	self.countDown:SetPos(cw - 100 - 40, 0)

	self.Footer:SetPos(pad, ch - 26)
	self.Footer:SetSize(cw - pad * 2, 20)

	self.mapList:SetPos(pad, 70)
	self.mapList:SetSize(cw - pad * 2, ch - 70 - 32)
end

local star_mat = Material("icon16/star.png")

function PANEL:AddVoter(voter)
	for k, v in pairs(self.Voters) do
		if v.Player and v.Player == voter then
			return false
		end
	end

	local icon_container = vgui.Create("Panel", self.mapList:GetCanvas())
	local icon = vgui.Create("AvatarImage", icon_container)
	icon:SetSize(16, 16)
	icon:SetZPos(1000)
	icon:SetTooltip(voter:Name())
	icon_container.Player = voter
	icon_container:SetTooltip(voter:Name())
	icon:SetPlayer(voter, 16)

	if MapVote.HasExtraVotePower(voter) then
		icon_container:SetSize(40, 20)
		icon:SetPos(21, 2)
		icon_container.img = star_mat
	else
		icon_container:SetSize(20, 20)
		icon:SetPos(2, 2)
	end

	icon_container.Paint = function(s, w, h)
		draw.RoundedBox(4, 0, 0, w, h, COL_ROW_VOTED)

		if icon_container.img then
			surface.SetMaterial(icon_container.img)
			surface.SetDrawColor(Color(255, 255, 255))
			surface.DrawTexturedRect(2, 2, 16, 16)
		end
	end

	table.insert(self.Voters, icon_container)
end

function PANEL:Think()
	for k, v in pairs(self.mapList:GetItems()) do
		v.NumVotes = 0
	end

	for k, v in pairs(self.Voters) do
		if not IsValid(v.Player) then
			v:Remove()
		else
			if not MapVote.Votes[v.Player:SteamID()] then
				v:Remove()
			else
				local bar = self:GetMapButton(MapVote.Votes[v.Player:SteamID()])

				if IsValid(bar) then
					if MapVote.HasExtraVotePower(v.Player) then
						bar.NumVotes = bar.NumVotes + 2
					else
						bar.NumVotes = bar.NumVotes + 1
					end

					local NewPos = Vector((bar.x + bar:GetWide()) - 21 * bar.NumVotes - 6, bar.y + (bar:GetTall() * 0.5 - 10), 0)

					if not v.CurPos or v.CurPos ~= NewPos then
						v:MoveTo(NewPos.x, NewPos.y, 0.3)
						v.CurPos = NewPos
					end
				end
			end
		end
	end

	local timeLeft = math.Round(math.Clamp(MapVote.EndTime - CurTime(), 0, math.huge))

	self.countDown:SetText(tostring(timeLeft or 0))
	self.countDown:SetTextColor(timeLeft <= 5 and COL_ACCENT or COL_WHITE)
end

function PANEL:SetMaps(maps)
	self.mapList:Clear()

	if not maps or #maps == 0 then
		local empty = vgui.Create("Panel", self.mapList)
		empty:SetTall(70)
		empty.Paint = function(s, w, h)
			draw.RoundedBox(6, 0, 0, w, h, COL_ROW)
			draw.ShadowText("No eligible maps found", "PHE.MapVoteMapName", w * 0.5, h * 0.5 - 12, COL_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.ShadowText("Check mv_mapprefix, mv_cooldown, and your maps folder", "PHE.MapVoteVotes", w * 0.5, h * 0.5 + 10, COL_TEXT_DIM, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end
		self.mapList:AddItem(empty)
		return
	end

	for k, v in RandomPairs(maps) do
		local button = vgui.Create("DButton", self.mapList)
		button.ID = k
		button.MapName = v
		button:SetText("")
		button:SetCursor("hand")

		button.ThumbMat = nil

		MapVote.GetThumbnail(v, function(mat)
			if IsValid(button) then
				button.ThumbMat = mat
			end
		end)

		button.DoClick = function()
			surface.PlaySound("ui/buttonclick.wav")

			net.Start("RAM_MapVoteUpdate")
				net.WriteUInt(MapVote.UPDATE_VOTE, 3)
				net.WriteUInt(button.ID, 32)
			net.SendToServer()
		end

		button.Paint = function(s, w, h)
			local bg = COL_ROW

			if button.bgColor then
				bg = button.bgColor
			elseif s:IsDown() then
				bg = COL_ROW_DOWN
			elseif s:IsHovered() then
				bg = COL_ROW_HOVER
			end

			draw.RoundedBox(6, 0, 0, w, h, bg)

			if MapVote.Votes[LocalPlayer():SteamID()] == button.ID then
				draw.RoundedBoxEx(6, 0, 0, 4, h, COL_ACCENT, true, false, true, false)
			end

			local textX = 14

			if button.ThumbMat then
				local thumbSize = h - 12
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(button.ThumbMat)
				surface.DrawTexturedRect(10, 6, thumbSize, thumbSize)
				textX = 10 + thumbSize + 12
			end

			draw.ShadowText(button.MapName, "PHE.MapVoteMapName", textX, 9, COL_TEXT, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

			local voteLabel = (button.NumVotes or 0) == 1 and "1 vote" or (button.NumVotes or 0) .. " votes"
			draw.ShadowText(voteLabel, "PHE.MapVoteVotes", textX, h - 9, COL_TEXT_DIM, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
		end

		button:SetPaintBackground(false)
		button:SetTall(50)
		button.NumVotes = 0

		self.mapList:AddItem(button)
	end
end

function PANEL:GetMapButton(id)
	for k, v in pairs(self.mapList:GetItems()) do
		if v.ID == id then return v end
	end

	return false
end

function PANEL:Paint()
	surface.SetDrawColor(0, 0, 0, 180)
	surface.DrawRect(0, 0, ScrW(), ScrH())
end

function PANEL:Flash(id)
	self:SetVisible(true)

	local bar = self:GetMapButton(id)

	if IsValid(bar) then
		timer.Simple(0.0, function() if IsValid(bar) then bar.bgColor = COL_ACCENT surface.PlaySound("hl1/fvox/blip.wav") end end)
		timer.Simple(0.2, function() if IsValid(bar) then bar.bgColor = nil end end)
		timer.Simple(0.4, function() if IsValid(bar) then bar.bgColor = COL_ACCENT surface.PlaySound("hl1/fvox/blip.wav") end end)
		timer.Simple(0.6, function() if IsValid(bar) then bar.bgColor = nil end end)
		timer.Simple(0.8, function() if IsValid(bar) then bar.bgColor = COL_ACCENT surface.PlaySound("hl1/fvox/blip.wav") end end)
		timer.Simple(1.0, function() if IsValid(bar) then bar.bgColor = Color(100, 100, 100, 220) end end)
	end
end

derma.DefineControl("PHE.VoteScreen", "", PANEL, "DPanel")