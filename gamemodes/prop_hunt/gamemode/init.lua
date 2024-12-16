-- Ship
resource.AddWorkshop("2048645528")

-- Send required file to clients
AddCSLuaFile("sh_init.lua")
AddCSLuaFile("sh_player.lua")
AddCSLuaFile("cl_tauntwindow.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_hud_mask.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_menu.lua")
AddCSLuaFile("cl_targetid.lua")
AddCSLuaFile("cl_autotaunt.lua")
AddCSLuaFile("cl_credits.lua")
AddCSLuaFile("cl_scoreboard.lua")

-- Include the required lua files
include("sv_networkfunctions.lua")
include("sh_init.lua")
include("sh_config.lua")
include("sv_admin.lua")
include("sv_autotaunt.lua")
include("sv_tauntwindow.lua")

include("sv_bbox_addition.lua")

-- Server only constants
PHE.EXPLOITABLE_DOORS = {
	"func_door",
	"prop_door_rotating",
	"func_door_rotating"
}

-- Voice Control Constant init
PHE.VOICE_IS_END_ROUND = 0

-- Update cvar to variables changes every so seconds
PHE.UPDATE_CVAR_TO_VARIABLE = 0

-- Spectator check
PHE.SPECTATOR_CHECK = 0

-- Player Join/Leave message
gameevent.Listen("player_authed")
hook.Add("player_authed", "AnnouncePLJoin", function(data)
	for k, v in pairs(player.GetAll()) do
		v:PrintMessage(HUD_PRINTTALK, data.name .. " has connected to the server.")
	end
end)

gameevent.Listen( "player_disconnect" )
hook.Add("player_disconnect", "AnnouncePLLeave", function(data)
	for k, v in pairs(player.GetAll()) do
		v:PrintMessage(HUD_PRINTTALK, data.name .. " has left the server (Reason: " .. data.reason .. ")")
	end
end)

-- Force Close taunt window function, determined whenever the round ends, or team winning.
local function ForceCloseTauntWindow(num)
	if num == 1 then
		net.Start("PH_ForceCloseTauntWindow")
		net.Broadcast()
	elseif num == 0 then
		net.Start("PH_AllowTauntWindow")
		net.Broadcast()
	end
end

-- Called alot
function GM:CheckPlayerDeathRoundEnd()
	if not GAMEMODE.RoundBased or not GAMEMODE:InRound() then
		return
	end

	local Teams = GAMEMODE:GetTeamAliveCounts()

	if table.Count(Teams) == 0 then
		GAMEMODE:RoundEndWithResult(1001, PHE.LANG.HUD.DRAW)
		PHE.VOICE_IS_END_ROUND = 1
		ForceCloseTauntWindow(1)

		net.Start("PH_RoundDraw_Snd")
		net.Broadcast()

		hook.Call("PH_OnRoundDraw", nil)
		return
	end

	if table.Count(Teams) == 1 then
		local TeamID, _ = next(Teams)
		-- debug
		MsgAll("Round Result: " .. team.GetName(TeamID) .. " (" .. TeamID .. ") Wins!\n")
		-- End Round
		GAMEMODE:RoundEndWithResult(TeamID, string.format(PHE.LANG.HUD.WIN, team.GetName(TeamID)))
		PHE.VOICE_IS_END_ROUND = 1
		ForceCloseTauntWindow(1)

		-- send the win notification
		if TeamID == TEAM_HUNTERS then
			net.Start("PH_TeamWinning_Snd")
			net.WriteString(PHE.WINNINGSOUNDS[TEAM_HUNTERS])
			net.Broadcast()
		elseif TeamID == TEAM_PROPS then
			net.Start("PH_TeamWinning_Snd")
			net.WriteString(PHE.WINNINGSOUNDS[TEAM_PROPS])
			net.Broadcast()
		end

		hook.Call("PH_OnRoundWinTeam", nil, TeamID)
		return
	end
end

-- Player Voice & Chat Control to prevent Metagaming. (As requested by some server owners/suggestors.)
-- You can disable this feature by typing 'sv_alltalk 1' in console to make everyone can hear.

-- Control Player Voice
function GM:PlayerCanHearPlayersVoice(listen, speaker)
	local alltalk_cvar = GetConVar("sv_alltalk"):GetInt()
	if alltalk_cvar > 0 then return true, false end

	-- prevent Loopback check.
	if listen == speaker then return false, false end

	-- Only alive players can listen other living players.
	if listen:Alive() and speaker:Alive() then return true, false end

	-- Event: On Round Start. Living Players don't listen to dead players.
	if PHE.VOICE_IS_END_ROUND == 0 and listen:Alive() and not speaker:Alive() then return false, false end

	-- Listen to all dead players while you dead.
	if not listen:Alive() and not speaker:Alive() then return true, false end

	-- However, Living players can be heard from dead players.
	if not listen:Alive() and speaker:Alive() then return true, false end

	-- Event: On Round End/Time End. Listen to everyone.
	if PHE.VOICE_IS_END_ROUND == 1 and listen:Alive() and not speaker:Alive() then return true, false end

	-- Spectator can only read from themselves.
	if listen:Team() == TEAM_SPECTATOR and listen:Alive() and speaker:Alive() then return false, false end

	-- This is for ULX "Permanent Gag". Uncomment this if you have some issues.
	-- if speaker:GetPData( "permgagged" ) == "true" then return false, false end

	-- does return true, true required here?
end

-- Control Players Chat
function GM:PlayerCanSeePlayersChat(txt, onteam, listen, speaker)
	if onteam then
		-- Generic Specific OnTeam chats
		if not IsValid(speaker) or not IsValid(listen) then return false end
		if listen:Team() ~= speaker:Team() then return false end

		-- ditto, this is same as below.
		if listen:Alive() and speaker:Alive() then return true end
		if PHE.VOICE_IS_END_ROUND == 0 and listen:Alive() and not speaker:Alive() then return false end
		if not listen:Alive() and not speaker:Alive() then return true end
		if not listen:Alive() and speaker:Alive() then return true end
		if PHE.VOICE_IS_END_ROUND == 1 and listen:Alive() and not speaker:Alive() then return true end
		if listen:Team() == TEAM_SPECTATOR and listen:Alive() and speaker:Alive() then return false end
	end

	local alltalk_cvar = GetConVar("sv_alltalk"):GetInt()
	if alltalk_cvar > 0 then return true end

	-- Generic Checks
	if not IsValid(speaker) or not IsValid(listen) then return false end

	-- Only alive players can see other living players.
	if listen:Alive() and speaker:Alive() then return true end

	-- Event: On Round Start. Living Players don't see dead players' chat.
	if PHE.VOICE_IS_END_ROUND == 0 and listen:Alive() and not speaker:Alive() then return false end

	-- See Chat to all dead players while you dead.
	if not listen:Alive() and not speaker:Alive() then return true end

	-- However, Living players' chat can be seen from dead players.
	if not listen:Alive() and speaker:Alive() then return true end

	-- Event: On Round End/Time End. See Chat to everyone.
	if PHE.VOICE_IS_END_ROUND == 1 and listen:Alive() and not speaker:Alive() then return true end

	-- Spectator can only read from themselves.
	if listen:Team() == TEAM_SPECTATOR and listen:Alive() and speaker:Alive() then return false end

	return true
end

-- Called when an entity takes damage
function EntityTakeDamage(ent, dmginfo)
	local att = dmginfo:GetAttacker()

	-- Code from: https://facepunch.com/showthread.php?t=1500179 , Special thanks from AlcoholicoDrogadicto(http://steamcommunity.com/profiles/76561198082241865/) for suggesting this.
	if GAMEMODE:InRound() and ent and ent:IsPlayer() and ent:Alive() and ent:Team() == TEAM_PROPS and ent.ph_prop then
		-- Prevent Prop 'Friendly Fire'
		if dmginfo:GetAttacker():IsPlayer() and dmginfo:GetAttacker():Team() == ent:Team() then
			printVerbose("DMGINFO::ATTACKED!!-> " .. tostring(dmginfo:GetAttacker()) .. ", DMGTYPE: " .. dmginfo:GetDamageType())
			return
		end
		--Debug purpose.
		printVerbose("!! " .. ent:Name() .. "'s PLAYER entity appears to have taken damage, we can redirect it to the prop! (Model is: " .. ent.ph_prop:GetModel() .. ")")
		ent.ph_prop:TakeDamageInfo(dmginfo)
		return
	end

	if GAMEMODE:InRound() and ent and (ent:GetClass() ~= "ph_prop" and ent:GetClass() ~= "func_breakable" and ent:GetClass() ~= "prop_door_rotating" and ent:GetClass() ~= "prop_dynamic*") and not ent:IsPlayer() and att and att:IsPlayer() and att:Team() == TEAM_HUNTERS and att:Alive() then
		if att:Armor() >= 5 and GetConVar("ph_hunter_fire_penalty"):GetInt() >= 5 then
			att:SetHealth(att:Health() - (math.Round(GetConVar("ph_hunter_fire_penalty"):GetInt() / 2)))
			att:SetArmor(att:Armor() - 15)
			if att:Armor() < 0 then att:SetArmor(0) end
		else
			att:SetHealth(att:Health() - GetConVar("ph_hunter_fire_penalty"):GetInt())
		end
		if att:Health() <= 0 then
			MsgAll(att:Name() .. " felt guilty for hurting so many innocent props and committed suicide\n")
			att:Kill()

			hook.Call("PH_HunterDeathPenalty", nil, att)
		end
	end
end
hook.Add("EntityTakeDamage", "PH_EntityTakeDamage", EntityTakeDamage)

-- Called when player tries to pickup a weapon
function GM:PlayerCanPickupWeapon(pl, ent)
	return pl:Team() == TEAM_HUNTERS
end

function PH_ResetCustomTauntWindowState()
	-- Force close any taunt menu windows
	ForceCloseTauntWindow(0)
	-- Extra additional
	PHE.VOICE_IS_END_ROUND = 0
	-- Reset Player's Height
end
hook.Add("PostCleanupMap", "PH_ResetCustomTauntWindow", PH_ResetCustomTauntWindowState)

-- Make a variable for 4 unique combines.
-- Clean up, sorry btw.
local playerModels = {
	"combine",
	"combineprison",
	"combineelite",
	"police"
	-- you may add more here.
}

function GM:PlayerSetModel(pl)
	-- player actual model to prevent multi-damage hitbox.
	local player_model = "models/props_idbs/phenhanced/box.mdl"

	if GetConVar("ph_use_custom_plmodel"):GetBool() then
		-- Use a delivered player model info from cl_playermodel ConVar.
		-- This however will use a custom player selection. It'll immediately apply once it is selected.
		local mdlinfo = pl:GetInfo("cl_playermodel")
		local mdlname = player_manager.TranslatePlayerModel(mdlinfo)

		if pl:Team() == TEAM_HUNTERS then
			player_model = mdlname
		end
	else
		-- Otherwise, Use Random one based from a table above.
		local customModel = table.Random(playerModels)
		local customMdlName = player_manager.TranslatePlayerModel(customModel)

		if pl:Team() == TEAM_HUNTERS then
			player_model = customMdlName
		end
	end

	-- precache and Set the model.
	util.PrecacheModel(player_model)
	pl:SetModel(player_model)
end

-- The [E] & Mouse Click 1 behaviour is now moved in here!
function GM:PlayerExchangeProp(pl, ent)
	if not (IsValid(pl) and IsValid(ent)) then return end

	if pl:Team() == TEAM_PROPS and pl:IsOnGround() and not pl:Crouching() and table.HasValue(PHE.USABLE_PROP_ENTITIES, ent:GetClass()) and ent:GetModel() then
		if table.HasValue(PHE.BANNED_PROP_MODELS, ent:GetModel()) then
			pl:ChatError("That prop has been banned from the server.")
		elseif IsValid(ent:GetPhysicsObject()) and IsValid(pl.ph_prop) and (pl.ph_prop:GetModel() ~= ent:GetModel() or pl.ph_prop:GetSkin() ~= ent:GetSkin()) then
			
			local hmx, hz = ent:GetPropSize()
			if GetConVar("phe_check_props_boundaries"):GetBool() and not pl:CheckHull(hmx, hmx, hz) then
				pl:ChatError("There is no room to change that prop!")
				return
			end


			local ent_health = math.Clamp(ent:GetPhysicsObject():GetVolume() / 250, 1, 200)
			local new_health = math.Clamp((pl.ph_prop.health / pl.ph_prop.max_health) * ent_health, 1, 200)
			pl.ph_prop.health = new_health

			pl.ph_prop.max_health = ent_health
			pl.ph_prop:SetModel(ent:GetModel())
			pl.ph_prop:SetSkin(ent:GetSkin())
			pl.ph_prop:SetSolid(SOLID_VPHYSICS)
			pl.ph_prop:SetPos(pl:GetPos() - Vector(0, 0, ent:OBBMins().z))
			pl.ph_prop:SetAngles(pl:GetAngles())

			pl:SetHealth(new_health)

			

			local minVector, maxVector, duckMaxVector
			if GetConVar("ph_sv_enable_obb_modifier"):GetBool() and ent:GetNWBool("hasCustomHull", false) then
				local hullMin, hullMax = ent.m_Hull[1], ent.m_Hull[2]
				local hullDuckMin, hullDuckMax = ent.m_dHull[1], ent.m_dHull[2]

				pl:SetViewOffset(Vector(0, 0, math.Clamp(24, 84, hullMax.z)))
				pl:SetViewOffsetDucked(Vector(0, 0, math.Clamp(24, 84, hullDuckMax.z)))

				pl:SetHull(hullMin, hullMax)
				pl:SetHullDuck(hullDuckMin, hullDuckMax)

				minVector = hullMin
				if GAMEMODE.ExperimentalPropCollisions then
					maxVector = hullMax
					duckMaxVector = hullDuckMax
				else
					local hullXYMax = math.Round(math.Max(hullMax.x, hullMax.y))
					maxVector = Vector(hullXYMax, hullXYMax, hullMax.z)
					duckMaxVector = Vector(hullXYMax, hullXYMax, hullDuckMax.z)
				end
			else
				local obbMin, obbMax = ent:OBBMins(), ent:OBBMaxs()
				local hullXMin, hullYMin, hullZMin = obbMin.x, obbMin.y, obbMin.z
				local hullXMax, hullYMax, hullZMax = obbMax.x, obbMax.y, obbMax.z
				local hullZAbs = hullZMax - hullZMin

				local hullZDuckAbsMul = 1
				if hullZAbs > 10 and hullZAbs <= 30 then
					hullZDuckAbsMul = 0.5
				elseif hullZAbs > 30 and hullZAbs <= 40 then
					hullZDuckAbsMul = 0.8
				elseif hullZAbs > 40 and hullZAbs <= 50 then
					hullZDuckAbsMul = 0.9
				end
				local hullZDuckAbs = hullZAbs * hullZDuckAbsMul

				pl:SetViewOffset(Vector(0, 0, math.Clamp(24, 84, hullZAbs)))
				pl:SetViewOffsetDucked(Vector(0, 0, math.Clamp(24, 84, hullZDuckAbs)))

				if GAMEMODE.ExperimentalPropCollisions then
					minVector = Vector(hullXMin, hullYMin, 0)
					maxVector = Vector(hullXMax, hullYMax, hullZAbs)
					duckMaxVector = Vector(hullXMax, hullYMax, hullZDuckAbs)
				else
					local hullXYMax = math.Round(math.Max(hullXMax, hullYMax))
					local hullXYMin = hullXYMax * -1
					minVector = Vector(hullXYMin, hullXYMin, 0)
					maxVector = Vector(hullXYMax, hullXYMax, math.Round(hullZAbs))
					duckMaxVector = Vector(hullXMax, hullYMax, hullZDuckAbs)
				end

				pl:SetHull(minVector, maxVector)
				pl:SetHullDuck(minVector, duckMaxVector)
			end

			net.Start("SetHull")
				net.WriteVector(minVector)
				net.WriteVector(maxVector)
				net.WriteVector(duckMaxVector)
				net.WriteInt(new_health, 9)
			net.Send(pl)

		end

		hook.Call("PH_OnChangeProp", nil, pl, ent)
	end
end

-- Called when a player tries to use an object. By default this pressed ['E'] button. MouseClick 1 will be mentioned below at line @351
function GM:PlayerUse(pl, ent)
	if not pl:Alive() or pl:Team() == TEAM_SPECTATOR or pl:Team() == TEAM_UNASSIGNED then return false end

	-- Prevent Execution Spam by holding ['E'] button too long.
	if pl.UseTime <= CurTime() then
		self:PlayerExchangeProp(pl, ent)
		pl.UseTime = CurTime() + 1
	end

	-- Allow pickup?
	if IsValid(ent) and (ent:GetClass() == "prop_physics" or ent:GetClass() == "prop_physics_multiplayer") and (GetConVar("ph_allow_prop_pickup"):GetInt() <= 0 or (GetConVar("ph_allow_prop_pickup"):GetInt() == 2 and pl:Team() ~= TEAM_HUNTERS)) then
		return false
	end

	-- Prevent the door exploit
	if table.HasValue(PHE.EXPLOITABLE_DOORS, ent:GetClass()) and pl.last_door_time and pl.last_door_time + 1 > CurTime() then
		return false
	end

	pl.last_door_time = CurTime()

	return true
end

net.Receive("CL2SV_ExchangeProp", function(len, ply)
	ply:PrintMessage(HUD_PRINTCONSOLE, "-=* NOTICE *=-")
	ply:PrintMessage(HUD_PRINTCONSOLE, "Hello! We've noticed you tried using the \"CL2SV_ExchangeProp\" net message.")
	ply:PrintMessage(HUD_PRINTCONSOLE, "Sad news is that this net message is no longer used (due to exploits). Shame, isn't it?")
	ply:PrintMessage(HUD_PRINTCONSOLE, "")
	ply:PrintMessage(HUD_PRINTCONSOLE, "This net message will still respond, but you will receive this message instead.")
	ply:PrintMessage(HUD_PRINTCONSOLE, "-=* NOTICE *=-")
end)


function GM:TeleportPlayerToClosestSpawnpoint(pl) 
	local playerPos = pl:GetPos()
	local closestPos = nil

	local trace = {}
	trace.filter = {pl, pl.ph_prop}
	local xy, z = pl.ph_prop:GetPropSize()
	trace.maxs = Vector(xy, xy, z)
	trace.mins = Vector(-xy, -xy, 0)


	local sortedSpawnpoints = {}
	for _, spawnpoint in pairs(ents.FindByClass(navmesh.GetPlayerSpawnName())) do 
		local pos = spawnpoint:GetPos()
		sortedSpawnpoints[pos:DistToSqr(playerPos)] = pos
	end

	
	local firstPos, rescuePos = nil, nil
	for dist, pos in SortedPairs(sortedSpawnpoints) do
		if rescuePos == nil then rescuePos = pos end

		if firstPos == nil then

			local x, y, z = (pos - playerPos):Unpack()
			local sum = math.abs(x) + math.abs(y) + math.abs(z)
			if sum > 50 then
				firstPos = pos
			end
		end

		if closestPos == nil then 
			for i=1,5,1 do 
				if closestPos == nil then
					trace.start = pos
					trace.endpos = pos
					if not util.TraceHull(trace).Hit then
						closestPos = pos
					else 
						pos = pos + Vector(0, 0, 5) 
					end
				end
			end
		end
	end

	if closestPos ~= nil then
		pl:SetPos(closestPos + Vector(0, 0, 100))
	else
		if firstPos ~= nil then 
			pl:SetPos(firstPos)
			pl:ChatError(PHE.LANG.UNSTUCK.BAD_SPAWNPOINT)
		elseif rescuePos ~= nil then 
			pl:SetPos(rescuePos)
			pl:ChatError(PHE.LANG.UNSTUCK.RESCUE_SPAWNPOINT)
		else 
			pl:SetPos(Vector(0, 0, 0))
			pl:ChatError(PHE.LANG.UNSTUCK.NO_SPAWNPOINTS)
		end


		pl:SetVar("unstuckRecently", false)
	end
end

function GM:PosOnGround(pl) 
	local traceResult = pl:TraceLineFromPlayer(pl:GetPos() - Vector(0, 0, 200))
	return traceResult.HitPos
end

function GM:PlayerButtonDown(pl, button)

	if not (IsValid(pl) and pl:Alive()) then return end

	if button == pl:GetInfoNum("ph_cl_taunt_key", KEY_F4) then
		pl:Taunt(pl:GetInfoNum("ph_cl_pitched_randtaunts", 0) ~= 0) 
	elseif button == pl:GetInfoNum("ph_cl_unstuck_key", KEY_F3) then
		GAMEMODE:UnstuckPlayer(pl)
	end
end

function GM:UnstuckPlayer(pl)

	if pl:Team() ~= TEAM_PROPS then return end

	if pl:GetVar("unstuckRecently", false) then
		pl:ChatError(string.format(PHE.LANG.UNSTUCK.PLEASE_WAIT, GAMEMODE.UnstuckWaitTime))
		return
	end

	pl:SetVar("unstuckRecently", true)
	timer.Simple(GAMEMODE.UnstuckWaitTime, function() pl:SetVar("unstuckRecently", false) end)

	if not pl:IsOnGround() then 

		local pos = pl:GetPos()
		local origZ = pos.z

		timer.Simple(0.2, function()
			local newZ = pl:GetPos().z

			if math.abs(origZ - newZ) > 0.1 then 
				pl:ChatInfo(PHE.LANG.UNSTUCK.NOT_STUCK_JITTER)
			else 
				local xy, z = pl.ph_prop:GetPropSize()
				if pl:CheckHull(xy, xy, z) then 

					local traceUp = pl:TraceLineFromPlayer(pl:GetPos() + Vector(0, 0, 200))


					if traceUp.HitSky then 
						GAMEMODE:TryNormalUnstuck(pl)
					else 
						pl:SetPos(pos + Vector(0, 0, 20))
						pl:ChatSuccess(PHE.LANG.UNSTUCK.YOURE_UNSTUCK)
					end
				else 
					GAMEMODE:TryNormalUnstuck(pl)
				end
			end
		end)
	else 
		GAMEMODE:TryNormalUnstuck(pl)
	end
end

function GM:TryNormalUnstuck(pl)
	local hullCheckHeight = 10

	local initialPos = GAMEMODE:PosOnGround(pl)

	local trace = {}
	trace.filter = {pl, pl.ph_prop}
	local xy, z = pl.ph_prop:GetPropSize()
	trace.maxs = Vector(xy, xy, z)
	trace.mins = Vector(-xy, -xy, 0)
	trace.start = initialPos
	trace.endpos = initialPos

	local traceResult = util.TraceHull(trace)
	if not traceResult.Hit then 
		pl:ChatInfo(PHE.LANG.UNSTUCK.NOT_STUCK_TOOBAD)


		trace.endpos = initialPos - Vector(0, 0, 50)
		local hitPos = util.TraceLine(trace).HitPos

		if hitPos ~= initialPos then 


			pl:SetPos(traceResult.HitPos) 
		end

		return
	end

	local tries = 0
	local nogroundBackups = {}


	for dist=5,GAMEMODE.UnstuckRange,5 do
		for rot=5,360,5 do


			local vec = Vector(dist, 0, hullCheckHeight)
			vec:Rotate(Angle(0, rot, 0))
			local target = vec + initialPos

			trace.start = target
			trace.endpos = target

			local traceResult = util.TraceHull(trace)
			if not traceResult.Hit then 
				local correctedTarget = target - Vector(0, 0, hullCheckHeight) 
				pl:SetPos(correctedTarget)

				
				if pl:IsOnGround() then 
					pl:ChatSuccess(PHE.LANG.UNSTUCK.YOURE_UNSTUCK)
					return
				else



					if tries == 10 then
						pl:SetPos(nogroundBackups[1])
						pl:ChatSuccess(PHE.LANG.UNSTUCK.YOURE_UNSTUCK)
						return
					end
					tries = tries + 1

					table.insert(nogroundBackups, correctedTarget)
				end
			end
		end
	end

	if #nogroundBackups > 0 then
		pl:SetPos(nogroundBackups[1])
		pl:ChatSuccess(PHE.LANG.UNSTUCK.YOURE_UNSTUCK)
		return
	end

	pl:ChatError(PHE.LANG.UNSTUCK.CANNOT_FIND_SPOT)

	if GAMEMODE.CannotTpUnstuckInRound then
		local blindlock_time_left = (GetConVar("ph_hunter_blindlock_time"):GetInt() - (CurTime() - GetGlobalFloat("RoundStartTime", 0))) + 1
		if blindlock_time_left < 1 then 
			pl:ChatError(PHE.LANG.UNSTUCK.SPAWNPOINTS_DISABLED)
			return
		end
	end

	GAMEMODE:TeleportPlayerToClosestSpawnpoint(pl)



	pl:SetPos(GAMEMODE:PosOnGround(pl) + Vector(0, 0, 20))
end


-- Called when a player leaves
function PlayerDisconnected(pl)
	pl:RemoveProp()
end
hook.Add("PlayerDisconnected", "PH_PlayerDisconnected", PlayerDisconnected)

-- Set specific variable for checking in player initial spawn, then use Player:IsHoldingEntity()
hook.Add("PlayerInitialSpawn", "PHE.SetupInitData", function(ply)
	ply.LastPickupEnt = NULL
	ply.UseTime = 0
end)
hook.Add("AllowPlayerPickup", "PHE.IsHoldingEntity", function(ply,ent)
	ply.LastPickupEnt = ent
	ent.LastPickupPly = ply
end)

-- Spray Controls
hook.Add("PlayerSpray", "PH.GeneralSprayFunc", function(ply)
	return not ply:Alive() or ply:Team() == TEAM_SPECTATOR
end)

-- Called when the players spawns
function PlayerSpawn(pl)
	pl:SetNWBool("PlayerLockedRotation", false)
	pl:SetNWBool("InFreezeCam", false)
	pl:SetNWEntity("PlayerKilledByPlayerEntity", nil)
	pl:Blind(false)
	pl:RemoveProp()
	pl:SetColor(Color(255, 255, 255, 255))
	pl:SetRenderMode(RENDERMODE_TRANSALPHA)
	pl:UnLock()
	pl:ResetHull()
	pl:SetNWFloat("LastTauntTime", CurTime())
	pl.last_taunt_time = 0

	net.Start("ResetHull")
	net.Send(pl)

	net.Start("DisableDynamicLight")
	net.Send(pl)

	pl:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
	pl:CollisionRulesChanged()

	if pl:Team() == TEAM_HUNTERS then
		pl:SetJumpPower(160 * GetConVar("ph_hunter_jumppower"):GetFloat())
	elseif pl:Team() == TEAM_PROPS then
		pl:SetJumpPower(160 * GetConVar("ph_prop_jumppower"):GetFloat())
	end

	-- Listen server host
	if not game.IsDedicated() then
		pl:SetNWBool("ListenServerHost", pl:IsListenServerHost())
	end
end
hook.Add("PlayerSpawn", "PH_PlayerSpawn", PlayerSpawn)


-- Called when round ends
function RoundEnd()
	-- Unblind the hunters
	for _, pl in pairs(team.GetPlayers(TEAM_HUNTERS)) do
		pl:Blind(false)
		pl:UnLock()
	end

	-- Stop autotaunting
	net.Start("AutoTauntRoundEnd")
	net.Broadcast()
end
hook.Add("PH_RoundEnd", "PH.ForceHuntersUnblind", RoundEnd)


-- This is called when the round time ends (props win)
function GM:RoundTimerEnd()
	if not GAMEMODE:InRound() then
		return
	end

	GAMEMODE:RoundEndWithResult(TEAM_PROPS, string.format(PHE.LANG.HUD.WIN, "Props"))
	PHE.VOICE_IS_END_ROUND = 1
	ForceCloseTauntWindow(1)

	net.Start("PH_TeamWinning_Snd")
	net.WriteString(PHE.WINNINGSOUNDS[TEAM_PROPS])
	net.Broadcast()

	hook.Call("PH_OnTimerEnd", nil)
end


-- Called before start of round
function GM:OnPreRoundStart(num)
	game.CleanUpMap()

	if GetConVar("ph_swap_teams_every_round"):GetBool() and (GetGlobalInt("RoundNumber") ~= 1 or ((team.GetScore(TEAM_PROPS) + team.GetScore(TEAM_HUNTERS)) > 0)) then
		for _, pl in pairs(player.GetAll()) do
			if pl:IsPlaying() then
				if pl:Team() == TEAM_PROPS then
					pl:SetTeam(TEAM_HUNTERS)
				else
					pl:SetTeam(TEAM_PROPS)
					if GetConVar("ph_notice_prop_rotation"):GetBool() then
						timer.Simple(0.5, function() pl:SendLua([[notification.AddLegacy("You are in Prop Team with Rotate support! You can rotate the prop around by moving your mouse.", NOTIFY_UNDO, 20)]]) end)
						pl:SendLua([[notification.AddLegacy("Additionally you can toggle lock rotation by pressing R key!", NOTIFY_GENERIC, 18)]])
						pl:SendLua([[surface.PlaySound("garrysmod/content_downloaded.wav")]])
					end
				end

			pl:ChatInfo(PHE.LANG.CHAT.SWAP)
			end
		end

		-- Props will gain a Bonus Armor points Hunter teams has more than 4 players in it. The more player, the more armor they get.
		timer.Simple(1, function()
			local NumHunter = team.NumPlayers(TEAM_HUNTERS)
			if NumHunter < 4 then return end

			local min, max = 1, 3
			if NumHunter > 8 then
				min, max = 3, 7
			end

			for _, prop in pairs(team.GetPlayers(TEAM_PROPS)) do
				if IsValid(prop) then prop:SetArmor(math.random(min, max) * 15) end
			end
		end)

		hook.Call("PH_OnPreRoundStart", nil, GetConVar("ph_swap_teams_every_round"):GetInt())
	end

	-- Balance teams?
	if GetConVar("ph_autoteambalance"):GetBool() then
		if GetConVar("ph_originalteambalance"):GetBool() then
			GAMEMODE:CheckTeamBalance()
		else
			GAMEMODE:CheckTeamBalanceCustom()
		end
	end

	UTIL_StripAllPlayers()
	UTIL_SpawnAllPlayers()
	UTIL_FreezeAllPlayers()
end


-- Called every server tick.
function GM:Think()	-- Prop spectating is a bit messy so let us clean it up a bit
	if PHE.SPECTATOR_CHECK < CurTime() then
		for _, pl in pairs(team.GetPlayers(TEAM_PROPS)) do
			if IsValid(pl) and not pl:Alive() and pl:GetObserverMode() == OBS_MODE_IN_EYE then
				hook.Call("ChangeObserverMode", GAMEMODE, pl, OBS_MODE_ROAMING)
			end
		end
		PHE.SPECTATOR_CHECK = CurTime() + PHE.SPECTATOR_CHECK_ADD
	end
end

-- Bonus Drop :D
function PH_Props_OnBreak(ply, ent)
	if GetConVar("ph_enable_lucky_balls"):GetBool() then
		local pos = ent:GetPos()
		if math.random() < 0.08 then -- 8% Chance of drops.
			local dropent = ents.Create("ph_luckyball")
			dropent:SetPos(Vector(pos.x, pos.y, pos.z + 32)) -- to make sure the Lucky Ball didn't fall underground.
			dropent:SetAngles(Angle(0,0,0))
			dropent:SetColor(Color(math.Round(math.random(0,255)),math.Round(math.random(0,255)),math.Round(math.random(0,255)),255))
			dropent:Spawn()
		end
	end
end
hook.Add("PropBreak", "Props_OnBreak_WithDrops", PH_Props_OnBreak)

-- Force Close the Taunt Menu whenever the prop is being killed.
function close_PlayerKilledSilently(ply)
	if ply:Team() == TEAM_PROPS then
		net.Start( "PH_ForceCloseTauntWindow" )
		net.Send(ply)
	end
end
hook.Add("PlayerSilentDeath", "SilentDed_ForceClose", close_PlayerKilledSilently)

-- Flashlight toggling
function GM:PlayerSwitchFlashlight(pl, on)
	if pl:Alive() and pl:Team() == TEAM_HUNTERS then
		return true
	end

	if pl:Alive() and pl:Team() == TEAM_PROPS then
		net.Start("PlayerSwitchDynamicLight")
		net.Send(pl)
	end

	return false
end

-- Round Control
cvars.AddChangeCallback("ph_min_waitforplayers", function(cvar, old, new)
	if tonumber(new) < 1 then
		RunConsoleCommand("ph_min_waitforplayers", "1")
		print("[PH:E] Warning: Value must not be 0! Use ph_waitforplayers 0 to disable.")
	end
end)

local bAlreadyStarted = false
function GM:OnRoundEnd(num)
	-- Check if GetConVar("ph_waitforplayers"):GetBool() is true
	-- This is a fast implementation for a waiting system
	-- Make optimisations if needed
	if GetConVar("ph_waitforplayers"):GetBool() then
		-- Take away a round number quickly before it adds another when there are not enough players
		-- Set to false
		if (team.NumPlayers(TEAM_HUNTERS) < GetConVar("ph_min_waitforplayers"):GetInt()) or (team.NumPlayers(TEAM_PROPS) < GetConVar("ph_min_waitforplayers"):GetInt()) then
			bAlreadyStarted = false
		end

		-- Set to true
		if (team.NumPlayers(TEAM_HUNTERS) >= GetConVar("ph_min_waitforplayers"):GetInt()) and (team.NumPlayers(TEAM_PROPS) >= GetConVar("ph_min_waitforplayers"):GetInt()) then
			bAlreadyStarted = true
		end

		-- Check if the round was already started before so we count it as a fully played round
		if not bAlreadyStarted then
			SetGlobalInt("RoundNumber", GetGlobalInt("RoundNumber") - 1)
		end
	end

	hook.Call("PH_OnRoundEnd", nil, num)
end

function GM:RoundStart()
	local roundNum = GetGlobalInt("RoundNumber")
	local roundDuration = GAMEMODE:GetRoundTime( roundNum )

	GAMEMODE:OnRoundStart(roundNum)

	timer.Create("RoundEndTimer", roundDuration, 0, function() GAMEMODE:RoundTimerEnd() end)
	timer.Create("CheckRoundEnd", 1, 0, function() GAMEMODE:CheckRoundEnd() end)

	SetGlobalFloat("RoundEndTime", CurTime() + roundDuration)

	-- Check if GetConVar("ph_waitforplayers"):GetBool() is true
	-- This is a fast implementation for a waiting system
	-- Make optimisations if needed
	if GetConVar("ph_waitforplayers"):GetBool() and
	((team.NumPlayers(TEAM_HUNTERS) < GetConVar("ph_min_waitforplayers"):GetInt()) or (team.NumPlayers(TEAM_PROPS) < GetConVar("ph_min_waitforplayers"):GetInt())) and -- Pause these timers if there are not enough players on the teams in the server
	(timer.Exists("RoundEndTimer") and timer.Exists("CheckRoundEnd")) then
		timer.Pause("RoundEndTimer")
		timer.Pause("CheckRoundEnd")

		SetGlobalFloat("RoundEndTime", -1)

		PrintMessage(HUD_PRINTTALK, PHE.LANG.CHAT.NOTENOUGHPLYS)
		-- Reset the team score
		team.SetScore(TEAM_PROPS, 0)
		team.SetScore(TEAM_HUNTERS, 0)
	end

	-- Send this as a global boolean
	SetGlobalBool("RoundWaitForPlayers", GetConVar("ph_waitforplayers"):GetBool())

	hook.Call("PH_RoundStart", nil)
end
-- End of Round Control Override

-- Player pressed a key
function PlayerPressedKey(pl, key)
	if not (pl and pl:IsValid() and pl:Alive() and pl:Team() == TEAM_PROPS) then return end

	-- Use traces to select a prop
	if key == IN_ATTACK then
		local _, max = pl:GetHull()
		local trace = pl:AdjustedTraceFromEyes(max.z)

		if trace.Entity and trace.Entity:IsValid() and table.HasValue(PHE.USABLE_PROP_ENTITIES, trace.Entity:GetClass()) and pl.UseTime <= CurTime() then
			if not pl:IsHoldingEntity() then
				GAMEMODE:PlayerExchangeProp(pl, trace.Entity)
			end
			pl.UseTime = CurTime() + 1
		end
	elseif key == IN_ATTACK2 then
		pl:Taunt(pl:GetInfoNum("ph_cl_pitched_randtaunts", 0) ~= 0) 
	elseif key == IN_RELOAD then -- Prop rotation lock key
		local isLocked = pl:GetPlayerLockedRot()
		pl:SetNWBool("PlayerLockedRotation", not isLocked)
		pl:PrintMessage(HUD_PRINTCENTER, isLocked and PHE.LANG.HUD.ROTLOCKOFF or PHE.LANG.HUD.ROTLOCKON)
		net.Start("PHE.rotateState")
			net.WriteInt(isLocked and 0 or 1, 2)
		net.Send(pl)
	end
end
hook.Add("KeyPress", "PlayerPressedKey", PlayerPressedKey, HOOK_HIGH)

hook.Add("PlayerSay", "PH_UnstuckCommand", function(pl, text)
	if table.HasValue(PHE.UNSTUCK_COMMANDS, string.lower(text)) then
		GAMEMODE:UnstuckPlayer(pl)
		return ""
	end
end)
