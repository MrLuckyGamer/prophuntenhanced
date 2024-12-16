CreateClientConVar("ph_cl_halos", "1", true, true, "Toggle Enable/Disable Halo effects when choosing a prop.")
CreateClientConVar("ph_cl_pltext", "1", true, false, "Options for Text above players. 0 = Disable. 1 = Enable.")
CreateClientConVar("ph_cl_endround_sound", "1", true, false, "Play a sound when round ends? 0 to disable.")
CreateClientConVar("ph_cl_autoclose_taunt", "1", true, false, "Auto close the taunt window (When Double Clicking on them)?")
CreateClientConVar("ph_cl_spec_hunter_line", "1", true, false, "Draw a line on hunters so we can see their aim in spectator mode.")
CreateClientConVar("cl_enable_luckyballs_icon", "1", true, false, "Enable 'Lucky ball' icon to be displayed once they spawned")
CreateClientConVar("cl_enable_devilballs_icon", "1", true, false, "Enable 'Devil ball' icon to be displayed once they spawned")
CreateClientConVar("ph_hud_use_new", "1", true, false, "Use new PH: Enhanced HUD")
CreateClientConVar("ph_show_team_topbar", "1", true, false, "Show total alive team players bar on the top left (Experimental)")
CreateClientConVar("ph_show_custom_crosshair", "1", true, false, "Show custom crosshair for props")
CreateClientConVar("ph_show_tutor_control", "1", true, false, "Show 'Prop Gameplay Control' hud on each prop spawns. This only show twice and reset until map changes/user disconnect.")
CreateClientConVar("ph_cl_taunt_key", "95", true, true, "Key to play a random taunt or open the taunts menu depending on server settings.")


CreateClientConVar("ph_cl_unstuck_key", "94", true, true, "Key to try to unstuck")
CreateClientConVar("ph_cl_tauntpitch", "100", false, true, "Taunt pitch (100 = normal)", 0, 255)
CreateClientConVar("ph_cl_pitched_autotaunts", "0", true, true, "Whether to use a random pitch for autotaunts")
CreateClientConVar("ph_cl_pitched_randtaunts", "0", true, true, "Whether to use a random pitch for random taunts that were manually triggered")


surface.CreateFont("HunterBlindLockFont", {
	font	= "Arial",
	size	= 14,
	weight	= 1200,
	antialias = true,
	underline = false
})

surface.CreateFont("TrebuchetBig", {
	font = "Impact",
	size = 40
})

include("sh_init.lua")
include("sh_config.lua")
CL_GLOBAL_LIGHT_STATE	= 0
include("cl_hud_mask.lua")
include("cl_hud.lua")
include("cl_menu.lua")
include("cl_tauntwindow.lua")
include("cl_targetid.lua")
include("cl_autotaunt.lua")
include("cl_scoreboard.lua")
include("cl_credits.lua")

-- Called immediately after starting the gamemode 
function Initialize()
	cHullz 	= 64
	client_prop_light = false
	blind = false

	CL_GLIMPCAM 	= 0
	MAT_LASERDOT 	= Material("sprites/glow04_noz")
end
hook.Add("Initialize", "PH_Initialize", Initialize)

-- Decides where the player view should be (forces third person for props)
function GM:CalcView(pl, origin, angles, fov)
	local view = {}

	if blind then
		view.origin = Vector(20000, 0, 0)
		view.angles = Angle(0, 0, 0)
		view.fov = fov

		return view
	end

	view.origin = origin
	view.angles	= angles
	view.fov = fov

	-- Give the active weapon a go at changing the viewmodel position 
	if pl:Team() == TEAM_PROPS and pl:Alive() then
		local trace = pl:AdjustedTraceFromEyes(cHullz, origin, true)
		trace.endpos = trace.start + angles:Forward() * -80

		if GetConVar("ph_prop_camera_collisions"):GetBool() then
			local tr = util.TraceLine(trace)
			view.origin = tr.HitPos
		else
			view.origin = trace.endpos
		end
	elseif pl:Team() == TEAM_HUNTERS and pl:Alive() then
	 	local wep = pl:GetActiveWeapon()
	 	if wep and wep ~= NULL then
	 		local func = wep.GetViewModelPosition
	 		if func then
	 			view.vm_origin, view.vm_angles = func(wep, origin * 1, angles * 1)
	 		end

	 		func = wep.CalcView
	 		if func then
	 			view.origin, view.angles, view.fov = func(wep, pl, origin * 1, angles * 1, fov)
	 		end
	 	end

		-- hunter glimpse of thirdperson
		if CL_GLIMPCAM > CurTime() then
			local trace = {}

			trace.start = origin
			trace.endpos = origin + (angles:Forward() * -80)
			trace.filter = player.GetAll()
			trace.maxs = Vector(4, 4, 4)
			trace.mins = Vector(-4, -4, -4)
			local tr = util.TraceHull(trace)

			view.drawviewer = true
			view.origin = tr.HitPos
		end
	end

	return view
end

local mat 		= "prophunt_enhanced/sprites/luckyball"
local pointer 	= "prophunt_enhanced/sprites/luckyball_pointer"

local dmat		= "prophunt_enhanced/sprites/devilball"
local dpointer	= "prophunt_enhanced/sprites/devilball_pointer"
local crosshair = Material("vgui/hud_crosshair")
-- Draw round timeleft and hunter release timeleft
function HUDPaint()
	local pl = LocalPlayer()

	-- Draw player texts
	if GetConVar("ph_enable_plnames"):GetBool() and GetConVar("ph_cl_pltext"):GetBool() and pl:Team() ~= TEAM_SPECTATOR then
		for _, ply in pairs(player.GetAll()) do
			if ply ~= pl and (ply and ply:IsValid() and ply:Alive() and ply:Team() == pl:Team()) then
				local addvector = Vector(0, 0, math.Clamp(ply:EyePos():Distance(pl:EyePos()) * 0.04, 16, 64))
				-- todo: text will disappear in a specified distance.
				draw.DrawText(ply:Name() .. " (" .. ply:Health() .. "%)", "TargetIDSmall", (ply:EyePos() + addvector):ToScreen().x, (ply:EyePos() + addvector):ToScreen().y, team.GetColor(ply:Team()), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	end

	-- Hunter Blindlock Time
	if GetGlobalBool("InRound", false) then
		local blindlock_time_left = (GetConVar("ph_hunter_blindlock_time"):GetInt() - (CurTime() - GetGlobalFloat("RoundStartTime", 0))) + 1

		if blindlock_time_left < 1 and blindlock_time_left > -6 then
			blindlock_time_left_msg = PHE.LANG.HUD.BLINDEND
		elseif blindlock_time_left > 0 then
			blindlock_time_left_msg = string.format(PHE.LANG.HUD.BLINDTIME, string.ToMinutesSeconds(blindlock_time_left))
		else
			blindlock_time_left_msg = nil
		end

		if blindlock_time_left_msg then
			surface.SetFont("HunterBlindLockFont")
			local tw, _ = surface.GetTextSize(blindlock_time_left_msg)

			draw.RoundedBox(8, 20, 20, tw + 20, 26, Color(0, 0, 0, 75))
			draw.DrawText(blindlock_time_left_msg, "HunterBlindLockFont", 31, 26, Color(255, 255, 0, 255), TEXT_ALIGN_LEFT)
		end
	end

	-- Draw Lucky Balls Icon
	if GetConVar("cl_enable_luckyballs_icon"):GetBool() and pl:Team() == TEAM_HUNTERS then
		local offset = Vector(0, 0, 45)

		local w = ScrW()
		local h = ScrH()
		local cX = w / 2
		local cY = h / 2

		for _, ent in pairs(ents.FindByClass("ph_luckyball")) do
			local pos = ent:GetPos() + offset
			local poscr = pos:ToScreen()

			if pl:IsLineOfSightClear(ent) then
				if (poscr.x > 32 and poscr.x < (w-43)) and (poscr.y > 32 and poscr.y < (h-38)) then
					surface.SetDrawColor(255,255,255,255)
					surface.SetTexture(surface.GetTextureID(mat))
					surface.DrawTexturedRect( poscr.x-32, poscr.y, 64, 64 )
				else
					local r = math.Round(cX / 2)
					local rad = math.atan2(poscr.y-cY, poscr.x-cX)
					local deg = 0 - math.Round(math.deg(rad))
					surface.SetDrawColor(255,255,255,255)
					surface.SetTexture(surface.GetTextureID(pointer))
					surface.DrawTexturedRectRotated(math.cos(rad) * r + cX, math.sin(rad) * r + cY,64,64,deg + 90)
				end
			end
		end
	end

	-- Draw Devil Ball Icon
	if GetConVar("cl_enable_devilballs_icon"):GetBool() and pl:Team() == TEAM_PROPS then
		local offset = Vector(0, 0, 35)

		local w = ScrW()
		local h = ScrH()
		local cX = w / 2
		local cY = h / 2

		for _, ent in pairs(ents.FindByClass("ph_devilball")) do
			local pos = ent:GetPos() + offset
			local poscr = pos:ToScreen()

			if pl:IsLineOfSightClear(ent) then
				if (poscr.x > 32 and poscr.x < (w-43)) and (poscr.y > 32 and poscr.y < (h-38)) then
					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetTexture(surface.GetTextureID(dmat))
					surface.DrawTexturedRect(poscr.x - 32, poscr.y, 64, 64)
				else
					local r = math.Round(cX / 2)
					local rad = math.atan2(poscr.y - cY, poscr.x - cX)
					local deg = 0 - math.Round(math.deg(rad))
					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetTexture(surface.GetTextureID(dpointer))
					surface.DrawTexturedRectRotated(math.cos(rad) * r + cX, math.sin(rad) * r + cY, 64, 64, deg + 90)
				end
			end
		end
	end

	-- Prop Crosshair
	if GetConVar("ph_show_custom_crosshair"):GetBool() and pl:Team() == TEAM_PROPS and pl:Alive() and not crosshair:IsError() then
		local color
		local trace = pl:AdjustedTraceFromEyes(cHullz)
		if trace.Entity and trace.Entity:IsValid() and table.HasValue(PHE.USABLE_PROP_ENTITIES, trace.Entity:GetClass()) then
			color = Color(10, 255, 10, 255)
		else
			color = Color(255, 255, 255, 255)
		end
		surface.SetDrawColor(color)
		surface.SetMaterial(crosshair)
		surface.DrawTexturedRect(ScrW() / 2 - (64 / 2), ScrH() / 2 - (64 / 2), 64, 64)
	end

	-- The 'You were Killed By' text, or the Freeze Cam text.
	if pl:GetNWBool("InFreezeCam", false) then
		local textx = ScrW() / 2
		draw.SimpleTextOutlined(string.format(PHE.LANG.HUD.FREEZECAM, pl:GetNWEntity("PlayerKilledByPlayerEntity", nil):Name()), "TrebuchetBig", textx, ScrH() * 0.75, Color(255, 10, 10, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1.5, Color(0, 0, 0, 255))
	end
end
hook.Add("HUDPaint", "PH_HUDPaint", HUDPaint)


-- After the player has been drawn
function PH_PostPlayerDraw(pl)
	-- Draw a line on hunters
	if GetConVar("ph_cl_spec_hunter_line"):GetBool() and (not LocalPlayer():Alive() or LocalPlayer():Team() == TEAM_SPECTATOR) and IsValid(pl) and pl:Alive() and pl:Team() == TEAM_HUNTERS then
		render.DrawLine(pl:GetShootPos(), pl:GetEyeTrace().HitPos, team.GetColor(pl:Team()), true)
		render.SetMaterial(MAT_LASERDOT)
		render.DrawSprite(pl:GetEyeTrace().HitPos, 8, 8, team.GetColor(pl:Team()))
	end
end
hook.Add("PostPlayerDraw", "PH_PostPlayerDraw", PH_PostPlayerDraw)

hook.Add("PrePlayerDraw", "PHE.HidePlayer", function(ply)
	return ply:Team() == TEAM_PROPS
end)

-- Draws halos on team members
function PHEDrawPropselectHalos()
	local pl = LocalPlayer()

	-- Something to tell if the prop is selectable
	if GetConVar("ph_cl_halos"):GetBool() and pl:Team() == TEAM_PROPS and pl:Alive() then
		local trace = pl:AdjustedTraceFromEyes(cHullz)

		if trace.Entity and trace.Entity:IsValid() and table.HasValue(PHE.USABLE_PROP_ENTITIES, trace.Entity:GetClass()) then
			halo.Add({trace.Entity}, Color(20, 250, 0), 1.2, 1.2, 1, true, true)
		end
	end
end
hook.Add("PreDrawHalos", "PHEDrawPropselectHalos", PHEDrawPropselectHalos)

-- Called every client frame
function GM:Think()
	-- Prop light
	if client_prop_light and LocalPlayer() and LocalPlayer():IsValid() and LocalPlayer():Alive() and LocalPlayer():Team() == TEAM_PROPS then
		local prop_light = DynamicLight(LocalPlayer():EntIndex())
		if prop_light then
			prop_light.pos = LocalPlayer():GetPos()
			prop_light.r = 255
			prop_light.g = 255
			prop_light.b = 255
			prop_light.brightness = 0.25
			prop_light.decay = 1
			prop_light.size = 180
			prop_light.dietime = CurTime() + 0.1
		end
	end
end

-- ///////////////////\\\\\\\\\\\\\\\\\ --
-- 			Net Receives Hooks 			--
-- ///////////////////\\\\\\\\\\\\\\\\\ --

local tutormat = Material ("vgui/hud_control_help.png")
local curshow = 0
net.Receive("PH_ShowTutor", function()
	if GetConVar("ph_show_tutor_control"):GetBool() and LocalPlayer():Alive() and not tutormat:IsError() and curshow <= 2 then
		local xNotify = vgui.Create("DNotify")
		xNotify:SetPos(ScrW() - 300, 60)
		xNotify:SetSize(256, 256)
		xNotify:SetLife(12)

		local bg = vgui.Create("DPanel", xNotify)
		bg:Dock(FILL)
		bg:SetBackgroundColor(Color(16, 16, 16, 180))

		local image = vgui.Create("DImage", bg)
		image:SetMaterial(tutormat)
		image:Dock(FILL)

		xNotify:AddItem(bg)

		curshow = curshow + 1
	end
end)

-- Receive the Winning Notification
net.Receive("PH_RoundDraw_Snd", function(len)
	if GetConVar("ph_cl_endround_sound"):GetBool() then
		surface.PlaySound(table.Random(PHE.WINNINGSOUNDS["Draw"]))
	end
end)
net.Receive("PH_TeamWinning_Snd", function(len)
	local snd = net.ReadString()
	if GetConVar("ph_cl_endround_sound"):GetBool() then
		surface.PlaySound(snd)
	end
end)

-- Resets the player hull
net.Receive("ResetHull", function()
	if LocalPlayer() and LocalPlayer():IsValid() then
		LocalPlayer():ResetHull()
		cHullz = 64
	end
end)

-- Sets the local blind variable to be used in CalcView
net.Receive("SetBlind", function()
	blind = net.ReadBool()
end)

--[[ Here you can add more than 2 additional freeze cam sounds. 
You can add more sounds by using table.insert(PHE.FreezeCamSnd, <path file>) repeatedly outside of this code scope.
Example:
	table.insert(PHE.FreezeCamSnd, "vo/k_lab/kl_fiddlesticks.wav")
	table.insert(PHE.FreezeCamSnd, "vo/k_lab/kl_ohdear.wav")
	...more ]]

-- If you wish to use a single sound instead, use ph_fc_use_single_sound 1 & ph_fc_cue_path "<path/sound/file.wav>" convar to override.

PHE.FreezeCamSnd = {
	-- do not manually add sounds in here, which this may break the sound list. Use table.insert instead!
	"misc/freeze_cam.wav",
	"misc/freeze_cam_sad1.wav"
}
-- Plays the Freeze Cam sound
net.Receive("PlayFreezeCamSound", function()
	if GetConVar("ph_fc_use_single_sound"):GetBool() then
		surface.PlaySound(GetConVar("ph_fc_cue_path"):GetString())
	else
		surface.PlaySound(table.Random(PHE.FreezeCamSnd))
	end
end)

-- Sets the player hull
net.Receive("SetHull", function()
	
	local minVector = net.ReadVector()
	local maxVector = net.ReadVector()
	local duckMaxVector = net.ReadVector()
	local new_health = net.ReadInt(9)

	cHullz = maxVector.z
	LocalPlayer():SetHull(minVector, maxVector)
	LocalPlayer():SetHullDuck(minVector, duckMaxVector)

	LocalPlayer():SetHealth(new_health)

end)

-- Replaces the flashlight with a client-side dynamic light for props
net.Receive("PlayerSwitchDynamicLight", function()
	if client_prop_light then
		client_prop_light = false
		surface.PlaySound("prop_idbs/light_off1.wav")
		CL_GLOBAL_LIGHT_STATE = 0
	else
		client_prop_light = true
		surface.PlaySound("prop_idbs/light_on.wav")
		CL_GLOBAL_LIGHT_STATE = 1
	end
end)

-- Turns the dynamic light OFF
net.Receive("DisableDynamicLight", function()
	if client_prop_light then
		client_prop_light = false
	end
end)


net.Receive("SendChatMessage", function()
	local text, prefixColor, prefix, msgColor = net.ReadString(), net.ReadColor(), net.ReadString(), net.ReadColor()
	LocalPlayer():ChatMessage(text, prefixColor, prefix, msgColor)
end)
