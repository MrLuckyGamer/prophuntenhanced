-- Finds the player Player/Entities table
local Player = FindMetaTable("Player")
local Entity = FindMetaTable("Entity")
if not Player then return end
if not Entity then return end

-- Checks player hull to make sure it does not even stuck with the world/other objects.
function Entity:GetPropSize()
	local hullxymax = math.Round(math.Max(self:OBBMaxs().x-self:OBBMins().x, self:OBBMaxs().y-self:OBBMins().y))
	local hullz = math.Round(self:OBBMaxs().z - self:OBBMins().z)

	return hullxymax,hullz
end

function Player:CheckHull(hx,hy,hz)
	local tr = {}
	tr.start = self:GetPos()
	tr.endpos = self:GetPos()
	tr.filter = {self, self.ph_prop}
	tr.maxs = Vector(hx,hy,hz)
	tr.mins = Vector(-hx,-hy,0)

	local trx = util.TraceHull(tr)
	if trx.Hit then return false end
	return true
end


function Player:IsPlaying()
	return self:Team() == TEAM_HUNTERS or self:Team() == TEAM_PROPS
end

function Player:TraceLineFromPlayer(endpos)
	local trace = {}
	trace.filter = {self, self.ph_prop}
	trace.start = self:GetPos()
	trace.endpos = endpos

	local traceResult = util.TraceLine(trace)
	return traceResult
end

function Player:AdjustedTraceFromEyes(hullz, startpos, donottrace)
	local trace = {}

	local addStart = 8
	if hullz < 24 then 
		addStart = 24
	elseif hullz > 84 then
		addStart = hullz - 84
	end

	trace.start = (startpos or self:EyePos()) + Vector(0, 0, addStart)
	trace.endpos = trace.start + self:EyeAngles():Forward() * (hullz > 84 and 300 or 100)

	trace.filter = ents.FindByClass("ph_prop") 
	table.insert(trace.filter, self)

	return donottrace and trace or util.TraceLine(trace)
end

function Player:Taunt(pitch, snd_file, auto)
	if not GAMEMODE:InRound() then return end

	if GetConVar("ph_enable_custom_taunts"):GetInt() == 1 and snd_file == nil and not auto then
		self:ConCommand("ph_showtaunts")
		return
	end


	if not (self:Alive() and self:IsPlaying()
	and (self.last_taunt_time + GetConVar("ph_normal_taunt_delay"):GetInt() <= CurTime() or auto)
	and table.Count(PHE.PROP_TAUNTS) > 1 and table.Count(PHE.HUNTER_TAUNTS) > 1) then
		return
	end

	local actualPitch = 100
	if pitch and GetConVar("ph_tauntpitch_allowed"):GetBool() then 
		if type(pitch) == "boolean" then 
			math.randomseed(os.time())
			for ix=1,5 do math.random() end 
			actualPitch = math.random(GetConVar("ph_tauntpitch_min"):GetInt(), GetConVar("ph_tauntpitch_max"):GetInt())
		else 

			actualPitch = math.Clamp(pitch, GetConVar("ph_tauntpitch_min"):GetInt(), GetConVar("ph_tauntpitch_max"):GetInt())
		end
	end

	local TEAM_TAUNTS = PHE:GetAllTeamTaunt(self:Team())

	local taunt = snd_file 
	local tauntName
	if taunt == nil then
		repeat
			taunt, tauntName = table.Random(TEAM_TAUNTS)
		until taunt ~= self.last_taunt

		if not auto then
			self.last_taunt_time = CurTime() + GetConVar("ph_normal_taunt_delay"):GetInt()
			self.last_taunt = taunt
		end
	else
		tauntName = table.KeyFromValue(TEAM_TAUNTS, taunt)
	end

	self:EmitSound(taunt, 100, actualPitch)
	self:SetNWFloat("LastTauntTime", CurTime())

	hook.Call("PH_PostTaunt", nil, self, tauntName, taunt, actualPitch, snd_file == nil, pitch == true, auto == true) 
end

function Player:ChatMessage(text, prefixColor, prefix, msgColor)
	prefixColor = prefixColor or Color(235, 10, 15)
	msgColor = msgColor or Color(220, 220, 220)

	prefix = prefix or "PH: Enhanced"

	if CLIENT then
		prefix = "[" .. prefix .. "] "
		chat.AddText(prefixColor, prefix, msgColor, text)
	else


		net.Start("SendChatMessage")
			net.WriteString(text)
			net.WriteColor(prefixColor)
			net.WriteString(prefix)
			net.WriteColor(msgColor)
		net.Send(self)
	end
end

function Player:ChatSuccess(text, prefix)
	self:ChatMessage(text, Color(0, 200, 0), prefix)
end

function Player:ChatInfo(text, prefix)
	self:ChatMessage(text, Color(51, 122, 229), prefix)
end

function Player:ChatWarning(text, prefix)
	self:ChatMessage(text, Color(228, 182, 0), prefix)
end

function Player:ChatError(text, prefix)
	self:ChatMessage(text, Color(210, 22, 22), prefix)
end


-- Blinds the player by setting view out into the void
function Player:Blind(bool)
	if not self:IsValid() then return end

	if SERVER then
		net.Start("SetBlind")
			net.WriteBool(bool)
			self:SetNWBool("isBlind", bool)
		net.Send(self)
	elseif CLIENT then
		blind = bool
	end
end

-- Player has locked prop rotation?
function Player:GetPlayerLockedRot()
	return self:GetNWBool("PlayerLockedRotation", false)
end

-- Player's prop entity
function Player:GetPlayerPropEntity()
	return self:GetNWEntity("PlayerPropEntity", nil)
end

-- Removes the prop given to the player
function Player:RemoveProp()
	if CLIENT or not self:IsValid() then return end

	if self.ph_prop and self.ph_prop:IsValid() then
		self.ph_prop:Remove()
		self.ph_prop = nil
	end
end

-- Returns ping for the scoreboard
function Player:ScoreboardPing()
	-- If this is not a dedicated server and player is the host
	if self:GetNWBool("ListenServerHost") then
		return "SV"
	elseif self:IsBot() then
		return "BOT" -- otherwise this will act very strange.
	end
	-- Return normal ping value otherwise
	return self:Ping()
end

if SERVER then
	function Player:IsHoldingEntity()
		if not self.LastPickupEnt then
			return false
		end
		if not IsValid(self.LastPickupEnt) then
			return false
		end

		local ent = self.LastPickupEnt

		if ent.LastPickupPly ~= self then
			return false
		end

		return self.LastPickupEnt:IsPlayerHolding()
	end
end