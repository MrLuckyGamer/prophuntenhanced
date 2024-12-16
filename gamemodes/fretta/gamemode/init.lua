--[[
	init.lua - Server Component
	-----------------------------------------------------
	The entire server side bit of Fretta starts here.
]]

util.AddNetworkString("PlayableGamemodes")
util.AddNetworkString("fretta_teamchange")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("skin.lua")
AddCSLuaFile("player_class.lua")
AddCSLuaFile("class_default.lua")
AddCSLuaFile("cl_splashscreen.lua")
AddCSLuaFile("cl_selectscreen.lua")
AddCSLuaFile("cl_gmchanger.lua")
AddCSLuaFile("cl_help.lua")
AddCSLuaFile("player_extension.lua")
AddCSLuaFile("vgui/vgui_hudlayout.lua")
AddCSLuaFile("vgui/vgui_hudelement.lua")
AddCSLuaFile("vgui/vgui_hudbase.lua")
AddCSLuaFile("vgui/vgui_hudcommon.lua")
AddCSLuaFile("vgui/vgui_gamenotice.lua")
AddCSLuaFile("vgui/vgui_scoreboard.lua")
AddCSLuaFile("vgui/vgui_scoreboard_team.lua")
AddCSLuaFile("vgui/vgui_scoreboard_small.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_deathnotice.lua")
AddCSLuaFile("cl_scores.lua")
AddCSLuaFile("cl_notify.lua")
AddCSLuaFile("player_colours.lua")

include("shared.lua")
include("sv_spectator.lua")
include("round_controller.lua")
include("utility.lua")

GM.ReconnectedPlayers = {}

function GM:Initialize()
	--[[
	-- Disabled - causes games to end in the middle of a round - we don't want that to happen!
	-- ::Think takes care of this anyway.
	
	if ( GAMEMODE.GameLength > 0 ) then
		timer.Simple( GAMEMODE.GameLength * 60, function() GAMEMODE:EndOfGame( true ) end )
		SetGlobalFloat( "GameEndTime", CurTime() + GAMEMODE.GameLength * 60 )
	end
	]]
	--
	-- If we're round based, wait 3 seconds before the first round starts
	--GAMEMODE:SetInRound( false ) --iguess?
	if GAMEMODE.RoundBased then
		timer.Simple(3, function()
			GAMEMODE:StartRoundBasedGame()
		end)
	end
end

function GM:Think()
	self.BaseClass:Think()

	for _, pl in pairs(player.GetAll()) do
		if pl:GetPlayerClass() then
			pl:CallClassFunction("Think")
		end
	end

	-- Game time related
	if not GAMEMODE.IsEndOfGame and (not GAMEMODE.RoundBased or (GAMEMODE.RoundBased and GAMEMODE:CanEndRoundBasedGame())) and CurTime() >= GAMEMODE.GetTimeLimit() then
		GAMEMODE:EndOfGame(true)
	end
end

--[[---------------------------------------------------------
   Name: gamemode:CanPlayerSuicide( Player ply )
   Desc: Is the player allowed to commit suicide?
---------------------------------------------------------]]
function GM:CanPlayerSuicide(ply)
	if not GAMEMODE:InRound() then return false end
	if ply:Team() == TEAM_UNASSIGNED or ply:Team() == TEAM_SPECTATOR then return false end -- no suicide in spectator mode

	return not GAMEMODE.NoPlayerSuicide
end

--[[---------------------------------------------------------
   Name: gamemode:PlayerSwitchFlashlight( Player ply, Bool on )
   Desc: Can we turn our flashlight on or off?
---------------------------------------------------------]]
function GM:PlayerSwitchFlashlight(ply, on)
	if ply:Team() == TEAM_SPECTATOR or ply:Team() == TEAM_UNASSIGNED or ply:Team() == TEAM_CONNECTING then return not on end

	return ply:CanUseFlashlight()
end

--[[---------------------------------------------------------
   Name: gamemode:PlayerInitialSpawn( Player ply )
   Desc: Our very first spawn in the game.
---------------------------------------------------------]]
function GM:PlayerInitialSpawn(pl)
	--pl:SetTeam( TEAM_UNASSIGNED )
	pl:SetTeam(TEAM_SPECTATOR)
	pl:SetPlayerClass("Spectator")
	pl.m_bFirstSpawn = true
	pl:UpdateNameColor()
	GAMEMODE:CheckPlayerReconnected(pl)
end

function GM:CheckPlayerReconnected(pl)
	if table.HasValue(GAMEMODE.ReconnectedPlayers, pl:UniqueID()) then
		GAMEMODE:PlayerReconnected(pl)
	end
end

--[[---------------------------------------------------------
   Name: gamemode:PlayerReconnected( Player ply )
   Desc: Called if the player has appeared to have reconnected.
---------------------------------------------------------]]
function GM:PlayerReconnected(pl)
	-- Use this hook to do stuff when a player rejoins and has been in the server previously
end

function GM:PlayerDisconnected(pl)
	table.insert(GAMEMODE.ReconnectedPlayers, pl:UniqueID())
	self.BaseClass:PlayerDisconnected(pl)
end

function GM:ShowHelp(pl)
	pl:SendLua("GAMEMODE:ShowHelp()")
end

function GM:PlayerSpawn(pl)
	pl:UpdateNameColor()

	-- The player never spawns straight into the game in Fretta
	-- They spawn as a spectator first (during the splash screen and team picking screens)
	if pl.m_bFirstSpawn then
		pl.m_bFirstSpawn = nil

		if pl:IsBot() then
			GAMEMODE:AutoTeam(pl)

			-- The bot doesn't send back the 'seen splash' command, so fake it.
			if not GAMEMODE.TeamBased and not GAMEMODE.NoAutomaticSpawning then
				pl:Spawn()
			end
		else
			pl:StripWeapons()
			GAMEMODE:PlayerSpawnAsSpectator(pl)
			-- Follow a random player until we join a team
			--[[
			if ( #player.GetAll() > 1 ) then
				pl:Spectate( OBS_MODE_CHASE )
				pl:SpectateEntity( table.Random( player.GetAll() ) )
			end
			]]
			--
			pl:Spectate(OBS_MODE_ROAMING)
		end

		return
	end

	pl:CheckPlayerClassOnSpawn()

	if GAMEMODE.TeamBased and (pl:Team() == TEAM_SPECTATOR or pl:Team() == TEAM_UNASSIGNED) then
		GAMEMODE:PlayerSpawnAsSpectator(pl)
		return
	end

	-- Stop observer mode
	pl:UnSpectate()
	-- Call item loadout function
	hook.Call("PlayerLoadout", GAMEMODE, pl)
	-- Set player model
	hook.Call("PlayerSetModel", GAMEMODE, pl)
	-- Call class function
	pl:OnSpawn()
end

function GM:PlayerLoadout(pl)
	pl:CheckPlayerClassOnSpawn()
	pl:OnLoadout()
	-- Switch to prefered weapon if they have it
	local cl_defaultweapon = pl:GetInfo("cl_defaultweapon")

	if pl:HasWeapon(cl_defaultweapon) then
		pl:SelectWeapon(cl_defaultweapon)
	end
end

function GM:PlayerSetModel(pl)
	pl:OnPlayerModel()
end

function GM:AutoTeam(pl)
	if not (GAMEMODE.AllowAutoTeam and GAMEMODE.TeamBased) then return end

	
	if GAMEMODE.OriginalTeamBalance then
		GAMEMODE:PlayerRequestTeam(pl, team.BestAutoJoinTeam())
	else
		local playerCount = GAMEMODE:GetPlayingCount(pl)
		local hunterCount = GAMEMODE:GetHunterCount(playerCount)

		if hunterCount > team.NumPlayers(TEAM_HUNTERS) then
			GAMEMODE:PlayerRequestTeam(pl, TEAM_HUNTERS)
		elseif (playerCount - hunterCount) > team.NumPlayers(TEAM_PROPS) then
			GAMEMODE:PlayerRequestTeam(pl, TEAM_PROPS)
		else
			GAMEMODE:PlayerRequestTeam(pl, TEAM_UNASSIGNED)
		end
	end

end

concommand.Add("autoteam", function(pl, cmd, args)
	hook.Call("AutoTeam", GAMEMODE, pl)
end)

function GM:PlayerRequestClass(ply, class, disablemessage)
	local Classes = team.GetClass(ply:Team())
	if not Classes then return end
	local RequestedClass = Classes[class]
	if not RequestedClass then return end

	if SERVER and ply:Alive() then
		if ply.m_SpawnAsClass and ply.m_SpawnAsClass == RequestedClass then return end
		ply.m_SpawnAsClass = RequestedClass

		if not disablemessage then
			ply:ChatInfo("Your class will change to '" .. player_class.GetClassName(RequestedClass) .. "' when you respawn")
		end
	else
		self:PlayerJoinClass(ply, RequestedClass)
		ply.m_SpawnAsClass = nil
	end
end

concommand.Add("changeclass", function(pl, cmd, args)
	hook.Call("PlayerRequestClass", GAMEMODE, pl, tonumber(args[1]))
end)

local function SeenSplash(ply)
	if ply.m_bSeenSplashScreen then return end
	ply.m_bSeenSplashScreen = true

	if not GAMEMODE.TeamBased and not GAMEMODE.NoAutomaticSpawning then
		ply:KillSilent()
	end
end
concommand.Add("seensplash", SeenSplash)

function GM:PlayerJoinTeam(ply, teamid)
	local iOldTeam = ply:Team()

	if ply:Alive() then
		if iOldTeam == TEAM_SPECTATOR or (iOldTeam == TEAM_UNASSIGNED and GAMEMODE.TeamBased) then
			ply:KillSilent()
		else
			ply:Kill()
		end
	end

	ply:SetTeam(teamid)
	ply.LastTeamSwitch = RealTime()
	local Classes = team.GetClass(teamid)

	-- Needs to choose class
	if Classes and #Classes > 1 then
		if ply:IsBot() or not GAMEMODE.SelectClass then
			GAMEMODE:PlayerRequestClass(ply, math.random(1, #Classes))
		else
			ply.m_fnCallAfterClassChoose = function()
				ply.DeathTime = CurTime()
				GAMEMODE:OnPlayerChangedTeam(ply, iOldTeam, teamid)
				ply:EnableRespawn()
			end

			ply:SendLua("GAMEMODE:ShowClassChooser( " .. teamid .. " )")
			ply:DisableRespawn()
			ply:SetRandomClass() -- put the player in a VALID class in case they don't choose and get spawned

			return
		end
	end

	-- No class, use default
	if not Classes or #Classes == 0 then
		ply:SetPlayerClass("Default")
	end

	-- Only one class, use that
	if Classes and #Classes == 1 then
		GAMEMODE:PlayerRequestClass(ply, 1)
	end

	gamemode.Call("OnPlayerChangedTeam", ply, iOldTeam, teamid)
end

function GM:PlayerJoinClass(ply, classname)
	ply.m_SpawnAsClass = nil
	ply:SetPlayerClass(classname)

	if ply.m_fnCallAfterClassChoose then
		ply.m_fnCallAfterClassChoose()
		ply.m_fnCallAfterClassChoose = nil
	end
end

function GM:OnPlayerChangedTeam(ply, oldteam, newteam)
	-- Here's an immediate respawn thing by default. If you want to 
	-- re-create something more like CS or some shit you could probably
	-- change to a spectator or something while dead.
	if newteam == TEAM_SPECTATOR then
		-- If we changed to spectator mode, respawn where we are		
		local Pos = ply:EyePos()
		ply:Spawn()
		ply:SetPos(Pos)
	elseif oldteam == TEAM_SPECTATOR then
		-- If we're changing from spectator, join the game
		if not GAMEMODE.NoAutomaticSpawning then
			ply:Spawn()
		end
	elseif oldteam ~= TEAM_SPECTATOR then
		ply.LastTeamChange = CurTime()
	else
		-- If we're straight up changing teams just hang
		--  around until we're ready to respawn onto the 
		--  team that we chose
	end

	-- Send net for team change
	net.Start("fretta_teamchange")
	net.WriteEntity(ply)
	net.WriteInt(oldteam, 12)
	net.WriteInt(newteam, 12)
	net.Broadcast()
end


-- https://stackoverflow.com/a/17120745
function GM:customshuffle(array)
	local counter = #array

	while counter > 1 do
		local index = math.random(counter)
		array[index], array[counter] = array[counter], array[index]
		counter = counter - 1
	end
end

function GM:CheckTeamBalanceCustom()
	local plyrTable = player.GetAll()

	if not GetConVar("ph_forcespectatorstoplay"):GetBool() then
		plyrTable = team.GetPlayers(TEAM_HUNTERS)
		table.Add(plyrTable, team.GetPlayers(TEAM_PROPS))
	end

	local plyrCount = #plyrTable
	local hunterCount = GAMEMODE:GetHunterCount(plyrCount)

	if GAMEMODE.RotateTeams then
		local offset = GetGlobalInt("RotateTeamsOffset", 1)
		SetGlobalInt("RotateTeamsOffset", offset + 1)
		offset = offset % plyrCount
		local max = hunterCount + offset

		for ix, plyr in ipairs(plyrTable) do
			if (ix >= (1 + offset) and ix <= max) or (max > plyrCount and ix <= max - plyrCount) then
				plyr:SetTeam(TEAM_HUNTERS)
			else
				plyr:SetTeam(TEAM_PROPS)
			end
		end
	else
		math.randomseed(os.time())
		for ix = 1, 5 do math.random() end 
		for ix = 1, math.random(2, 5) do GAMEMODE:customshuffle(plyrTable) end 

		if GAMEMODE.PreventConsecutiveHunting then

			local teamContainingHunters = TEAM_HUNTERS

			if GetConVar("ph_swap_teams_every_round"):GetBool() then
				teamContainingHunters = TEAM_PROPS
			end

			for _, pl in pairs(team.GetPlayers(teamContainingHunters)) do
				pl:SetVar("ForceAsProp", true)
			end
		end

		for ix = 1, #plyrTable do
			local plyr = table.remove(plyrTable, math.random(#plyrTable))

			if ix <= hunterCount then
				if plyr:GetVar("ForceAsProp", false) then
					plyr:SetTeam(TEAM_PROPS)
					hunterCount = hunterCount + 1
				else
					plyr:SetTeam(TEAM_HUNTERS)
				end
			else
				plyr:SetTeam(TEAM_PROPS)
			end

			plyr:SetVar("ForceAsProp", false) 
		end
	end
end

function GM:CheckTeamBalance()
	local highest

	for id, tm in pairs(team.GetAllTeams()) do
		if (id > 0 and id < 1000 and team.Joinable(id)) and
		(not highest or team.NumPlayers(id) > team.NumPlayers(highest)) then
			highest = id
		end
	end

	if not highest then return end

	for id, tm in pairs(team.GetAllTeams()) do
		if (id ~= highest and id > 0 and id < 1000 and team.Joinable(id)) and team.NumPlayers(id) < team.NumPlayers(highest) then
			while team.NumPlayers(id) < team.NumPlayers(highest) - 1 do
				local ply = GAMEMODE:FindLeastCommittedPlayerOnTeam(highest)
				ply:Kill()
				ply:SetTeam(id)

				-- Advert
				for _, listener in ipairs(player.GetAll()) do
					if listener == ply then
						listener:ChatInfo(PHE.LANG.CHAT.SWAPBALANCEYOU)
					else
						listener:ChatInfo(string.format(PHE.LANG.CHAT.SWAPBALANCE, ply:Name(), team.GetName(id)))
					end
				end
			end
		end
	end
end

function GM:FindLeastCommittedPlayerOnTeam(teamid)
	local worst
	local worstteamswapper

	for k, v in pairs(team.GetPlayers(teamid)) do
		if v.LastTeamChange and CurTime() < v.LastTeamChange + 180 and (not worstteamswapper or worstteamswapper.LastTeamChange < v.LastTeamChange) then
			worstteamswapper = v
		end

		if not worst or v:Frags() < worst:Frags() then
			worst = v
		end
	end

	return worstteamswapper or worst
end

function GM:OnEndOfGame(bGamemodeVote)
	for k, v in pairs(player.GetAll()) do
		v:Freeze(true)
		v:ConCommand("+showscores")

		timer.Simple(GAMEMODE.VotingDelay, function()
			if IsValid(v) then
				v:ConCommand("-showscores")
			end
		end)
	end
end

-- Override OnEndOfGame to do any other stuff. like winning music.
function GM:EndOfGame(bGamemodeVote)
	if GAMEMODE.IsEndOfGame then return end

	GAMEMODE.IsEndOfGame = true
	SetGlobalBool("IsEndOfGame", true)
	gamemode.Call("OnEndOfGame", bGamemodeVote)

	if bGamemodeVote then
		MsgN("Starting gamemode voting...")
		PrintMessage(HUD_PRINTTALK, "Starting gamemode voting...")

		timer.Simple(GAMEMODE.VotingDelay, function()
			MapVote.Start()
		end)
	end
end

function GM:GetWinningFraction()
	if not GAMEMODE.GMVoteResults then return end

	return GAMEMODE.GMVoteResults.Fraction
end

function GM:PlayerShouldTakeDamage(ply, attacker)
	if GAMEMODE.NoPlayerDamage or (GAMEMODE.NoPlayerSelfDamage and IsValid(attacker) and ply == attacker) then return false end

	if GAMEMODE.NoPlayerTeamDamage and IsValid(attacker) and attacker.Team and ply:Team() == attacker:Team() and ply ~= attacker then
		return false
	end

	if IsValid(attacker) and attacker:IsPlayer() and GAMEMODE.NoPlayerPlayerDamage then return false end
	if IsValid(attacker) and not attacker:IsPlayer() and GAMEMODE.NoNonPlayerPlayerDamage then return false end

	return true
end

function GM:PlayerDeathThink(pl)
	pl.DeathTime = pl.DeathTime or CurTime()
	local timeDead = CurTime() - pl.DeathTime

	-- If we're in deathcam mode, promote to a generic spectator mode
	if GAMEMODE.DeathLingerTime > 0 and timeDead > GAMEMODE.DeathLingerTime and (pl:GetObserverMode() == OBS_MODE_FREEZECAM or pl:GetObserverMode() == OBS_MODE_DEATHCAM) then
		GAMEMODE:BecomeObserver(pl)
	end

	-- If we're in a round based game, player NEVER spawns in death think
	if GAMEMODE.NoAutomaticSpawning then return end
	-- The gamemode is holding the player from respawning.
	-- Probably because they have to choose a class..
	if not pl:CanRespawn() then return end

	-- Don't respawn yet - wait for minimum time...
	if GAMEMODE.MinimumDeathLength then
		pl:SetNWFloat("RespawnTime", pl.DeathTime + GAMEMODE.MinimumDeathLength)
		if timeDead < pl:GetRespawnTime() then return end
	end

	-- Force respawn
	if pl:GetRespawnTime() ~= 0 and GAMEMODE.MaximumDeathLength ~= 0 and timeDead > GAMEMODE.MaximumDeathLength then
		pl:Spawn()
		return
	end

	-- We're between min and max death length, player can press a key to spawn.
	if pl:KeyPressed(IN_ATTACK) or pl:KeyPressed(IN_ATTACK2) or pl:KeyPressed(IN_JUMP) then
		pl:Spawn()
	end
end

function GM:GetFallDamage(ply, flFallSpeed)
	if not GAMEMODE:InRound() or not GAMEMODE.FallDamage then return 0 end
	if GAMEMODE.RealisticFallDamage then return flFallSpeed / 8 end

	return 10
end

function GM:PostPlayerDeath(ply)
	-- Note, this gets called AFTER DoPlayerDeath.. AND it gets called
	-- for KillSilent too. So if Freezecam isn't set by DoPlayerDeath, we
	-- pick up the slack by setting DEATHCAM here.
	if ply:GetObserverMode() == OBS_MODE_NONE then
		ply:Spectate(OBS_MODE_DEATHCAM)
	end

	ply:OnDeath()
end

function GM:DoPlayerDeath(ply, attacker, dmginfo)
	ply:CallClassFunction("OnDeath", attacker, dmginfo)
	ply:CreateRagdoll()
	ply:AddDeaths(1)

	if not IsValid(attacker) then return end

	if attacker:IsPlayer() then
		if attacker == ply then
			if GAMEMODE.TakeFragOnSuicide then
				attacker:AddFrags(-1)

				if GAMEMODE.TeamBased and GAMEMODE.AddFragsToTeamScore then
					team.AddScore(attacker:Team(), -1)
				end
			end
		else
			attacker:AddFrags(1)

			if GAMEMODE.TeamBased and GAMEMODE.AddFragsToTeamScore then
				team.AddScore(attacker:Team(), 1)
			end
		end
	end

	if GAMEMODE.EnableFreezeCam and attacker ~= ply then
		ply:SpectateEntity(attacker)
		ply:Spectate(OBS_MODE_FREEZECAM)
	end
end

function GM:StartSpectating(ply)
	if not GAMEMODE:PlayerCanJoinTeam(ply) then return end
	ply:StripWeapons()
	GAMEMODE:PlayerJoinTeam(ply, TEAM_SPECTATOR)
	GAMEMODE:BecomeObserver(ply)
end

function GM:EndSpectating(ply)
	if not GAMEMODE:PlayerCanJoinTeam(ply) then return end
	GAMEMODE:PlayerJoinTeam(ply, TEAM_UNASSIGNED)
	ply:KillSilent()
end

--[[---------------------------------------------------------
   Name: gamemode:PlayerRequestTeam()
		Player wants to change team
---------------------------------------------------------]]
function GM:PlayerRequestTeam(ply, teamid)
	if not GAMEMODE.TeamBased and GAMEMODE.AllowSpectating then
		if teamid == TEAM_SPECTATOR then
			GAMEMODE:StartSpectating(ply)
		else
			GAMEMODE:EndSpectating(ply)
		end

		return
	end

	return self.BaseClass:PlayerRequestTeam(ply, teamid)
end

local function TimeLeft(ply)
	local tl = GAMEMODE:GetGameTimeLeft()
	if tl == -1 then return end
	local Time = util.ToMinutesSeconds(tl)

	if IsValid(ply) then
		ply:PrintMessage(HUD_PRINTCONSOLE, Time)
	else
		MsgN(Time)
	end
end
concommand.Add("timeleft", TimeLeft)