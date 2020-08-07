-- Finds the player meta table or terminates
local meta = FindMetaTable("Player")
if !meta then return end


-- Blinds the player by setting view out into the void
function meta:Blind(bool)
	if !self:IsValid() then return end
	
	if SERVER then
		net.Start("SetBlind")
		if bool then
			net.WriteBool(true)
		else
			net.WriteBool(false)
		end
		net.Send(self)
	elseif CLIENT then
		blind = bool
	end
end


-- Player has locked prop rotation?
function meta:GetPlayerLockedRot()
	return self:GetNWBool("PlayerLockedRotation", false)
end


-- Player's prop entity
function meta:GetPlayerPropEntity()
	return self:GetNWEntity("PlayerPropEntity", nil)
end


-- Removes the prop given to the player
function meta:RemoveProp()
	if CLIENT || !self:IsValid() then return end
	
	if self.ph_prop && self.ph_prop:IsValid() then
		self.ph_prop:Remove()
		self.ph_prop = nil
	end
end


-- Returns ping for the scoreboard
function meta:ScoreboardPing()
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
	function meta:IsHoldingEntity()
		if !self.LastPickupEnt then
			return false 
		end
		if !IsValid(self.LastPickupEnt) then
			return false 
		end
		
		local ent = self.LastPickupEnt
		
		if ent.LastPickupPly != self then
			return false 
		end
		
		return self.LastPickupEnt:IsPlayerHolding()
	end
end