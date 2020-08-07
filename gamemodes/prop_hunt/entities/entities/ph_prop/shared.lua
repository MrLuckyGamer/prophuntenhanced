-- Entity information
ENT.Type = "anim"
ENT.Base = "base_anim"

-- Entity think
function ENT:Think()
	-- Prop Movement and Rotation (SERVER)
	if SERVER then
		-- Local variables
		local pl = self:GetOwner()
		local ent = self.Entity
		-- Set position and angles
		if IsValid(ent) && IsValid(pl) && pl:Alive() then
			-- Set position
			if (ent:GetModel() == "models/player/kleiner.mdl" || ent:GetModel() == player_manager.TranslatePlayerModel(pl:GetInfo("cl_playermodel"))) then
				ent:SetPos(pl:GetPos())
			else
				ent:SetPos(pl:GetPos() - Vector(0, 0, ent:OBBMins().z))
			end
			-- Set angles
			if SERVER && !pl:GetPlayerLockedRot() then
				ent:SetAngles(pl:GetAngles())
			end
		end
	end
	
	-- Prop Movement and Rotation (CLIENT)
	if CLIENT then
		-- Local variables
		local pl = self:GetOwner()
		local ent = self.Entity
		-- Set position and angles
		if IsValid(ent) && IsValid(pl) && pl:Alive() && pl == LocalPlayer() then
			-- Set position
			if ent:GetModel() == "models/player/kleiner.mdl" || ent:GetModel() == player_manager.TranslatePlayerModel(pl:GetInfo("cl_playermodel")) then
				ent:SetPos(pl:GetPos())
			else
				ent:SetPos(pl:GetPos() - Vector(0, 0, ent:OBBMins().z))
			end
		end
	end

	-- Next think
	if SERVER then
		self:NextThink(CurTime())
	elseif CLIENT then
		self:SetNextClientThink(CurTime())
	end

	return true
end