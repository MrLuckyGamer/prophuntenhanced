-- Validity check to prevent some sort of spam
local function IsDelayed(ply)
	local lastTauntTime = ply:GetNWFloat("LastTauntTime")
	local delayedTauntTime = lastTauntTime + GetConVar("ph_customtaunts_delay"):GetInt()
	local currentTime = CurTime()
	return delayedTauntTime > currentTime
end

local function IsValidTauntForTeam(ply, snd)
	local teamid = ply:Team()

	local builtin = PHE:GetTeamTaunt(teamid, false)
	if builtin and table.HasValue(builtin, snd) then return true end

	local custom = PHE:GetTeamTaunt(teamid, true)
	if custom and table.HasValue(custom, snd) then return true end

	return false
end

net.Receive("CL2SV_PlayThisTaunt", function(len, ply)
	local snd = net.ReadString()

	if IsValid(ply) and not IsDelayed(ply) then
		if not IsValidTauntForTeam(ply, snd) then
			ply:ChatError("That taunt you selected does not exists on server!")
			return
		end

		if file.Exists("sound/" .. snd, "GAME") then
			ply:Taunt(ply:GetInfoNum("ph_cl_tauntpitch", 100), snd) 
		else
			ply:ChatError("That taunt you selected does not exists on server!")
		end
	else
		ply:ChatWarning("Please wait in few seconds...!")
	end
end)