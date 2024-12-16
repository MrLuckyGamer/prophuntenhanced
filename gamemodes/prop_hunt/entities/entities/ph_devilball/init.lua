AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.model = Model("models/props_idbs/phenhanced/devil.mdl")

function ENT:StartTeslaSpark()
	timer.Create("DoTeslaSpark-" .. self:EntIndex(), math.random(3, 6), 0, function()
		self:ShowEffects(self, "StunstickImpact", self:GetPos(), self:GetPos())
	end)
end

function ENT:StopTeslaSpark()
	if timer.Exists("DoTeslaSpark-" .. self:EntIndex()) then
		timer.Remove("DoTeslaSpark-" .. self:EntIndex())
	end
end

function ENT:Initialize()
	self:SetModel(self.model)
	self:PhysicsInit(SOLID_BBOX)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self.health = 50

	-- Spawn a Sprite, for an Effect.
	self.Sprite = ents.Create("env_sprite")
	self.Sprite:SetPos(self:GetPos())
	self.Sprite:SetAngles(Angle(0, 0, 0))
	self.Sprite:SetKeyValue("spawnflags", "1")
	self.Sprite:SetKeyValue("framerate", "1")
	self.Sprite:SetKeyValue("rendermode", "5")
	self.Sprite:SetKeyValue("rendercolor", "255 " .. tostring(math.random(1, 180)) .. " " .. tostring(math.random(1, 20)))
	self.Sprite:SetKeyValue("model", "sprites/light_glow01.vmt")
	self.Sprite:SetKeyValue("scale", "0.4")

	self.Sprite:Spawn()
	self.Sprite:Activate()

	self.Sprite:SetParent(self)

	self:StartTeslaSpark()
end

function ENT:OnRemove()
	self:StopTeslaSpark()
	if IsValid(self.Sprite) then
		self.Sprite:Remove()
	end
end

ENT.sounds = {
	"prop_idbs/huntep4_bc44_pickup.wav",
	"prop_idbs/zavogant_pickup.wav"
}

--[[
Base Devil Balls Functions. 
Please note that you might have to create a custom serverside lua with full of function list with list.Set into "DevilBallsAddition".
	Example:
	
	list.Set("DevilBallsAddition", "UniqueName", function(pl,ball)
		-- code...
	end)
	
Keep in note that UniqueName should be unique and different. Otherwise will cause some confusion with printVerbose!
]]
ENT.funclists = {
	function(pl)
		if not pl.ph_fastspeed then
			if not pl._OriginalWSpeed then pl._OriginalWSpeed = pl:GetWalkSpeed() end

			pl:ChatPrint("[Devil Crystal] You have super speed Power up!")
			pl:SendLua("surface.PlaySound('prop_idbs/speedup.wav')")
			pl:SetWalkSpeed(pl:GetWalkSpeed() + 100)
			pl.ph_fastspeed = true
			pl.RevertWalk = timer.Simple(math.random(4, 12), function()
				pl:ChatPrint("[Devil Crystal] super speed power up exhausted...")
				pl:SendLua("surface.PlaySound('prop_idbs/generic_exhaust.wav')")
				pl:SetWalkSpeed(pl._OriginalWSpeed)
				pl.ph_fastspeed = false
			end)
		end
	end,
	function(pl)
		local rand = math.random(10,50)
		pl:SetHealth(pl:Health() + rand)
		pl.ph_prop.health = pl.ph_prop.health + rand
		pl:ChatPrint("[Devil Crystal] You got free +" .. tostring(rand) .. " HP for your current Prop!")
	end,
	function(pl)
		local rand
		rand = math.random(20,60)
		pl:SetArmor(pl:Armor() + rand)
		pl:ChatPrint("[Devil Crystal] You gained armor points bonus : " .. tostring(rand) .. "!")
	end,
	function(pl)
		if not pl.ph_slowspeed then
			if not pl._OriginalWSpeed then pl._OriginalWSpeed = pl:GetWalkSpeed() end

			pl:ChatPrint("[Devil Crystal] Uh oh, you're slowing down!")
			pl:SendLua("surface.PlaySound('prop_idbs/slowdown.wav')")
			pl:SetWalkSpeed(pl:GetWalkSpeed() - 100)
			pl.ph_slowspeed = true
			pl.RevertWalk = timer.Simple(math.random(4, 12), function()
				pl:ChatPrint("[Devil Crystal] slow down power up exhausted...")
				pl:SendLua("surface.PlaySound('prop_idbs/generic_exhaust.wav')")
				pl:SetWalkSpeed(pl._OriginalWSpeed)
				pl.ph_slowspeed = false
			end)
		end
	end,
	function(pl)
		if table.Count(team.GetPlayers(TEAM_HUNTERS)) >= 3 then
			pl:ChatPrint("[Devil Crystal] Hunters are frozen!")
			pl:SendLua("surface.PlaySound('prop_idbs/surface_prop_froze_hunter.wav')")
			for _, v in pairs(team.GetPlayers(TEAM_HUNTERS)) do
				if v:Alive() then
					v:Freeze(true)
					v:EmitSound(Sound("prop_idbs/govarchz_pickup.wav"))
					v:ChatPrint("[Devil Crystal] Oops, you are temporary frozen...!")
					v.UnFrooze = timer.Simple(math.random(2, 3), function()
						v:ChatPrint("[Devil Crystal] You are free now!")
						v:EmitSound(Sound("prop_idbs/froze_done.wav"))
						v:Freeze(false)
					end)
				end
			end
		else
			pl:ChatPrint("[Devil Crystal] It seems there are no hunters available to Froze 'em. Let it Go~")
		end
	end,
	function(pl)
		if not pl.ph_cloacking then
			pl:ChatPrint("[Devil Crystal] Cloaking...")
			pl:SendLua("surface.PlaySound('prop_idbs/cloak.wav')")
			pl.ph_prop:DrawShadow(false)
			pl.ph_prop:SetMaterial("models/effects/vol_light001")
			pl.ph_cloacking = true
			pl.RevertMaterial = timer.Simple(math.random(5, 15), function()
				pl:ChatPrint("[Devil Crystal] cloak power up exhausted...")
				pl:SendLua("surface.PlaySound('prop_idbs/generic_exhaust.wav')")
				pl.ph_prop:DrawShadow(true)
				pl.ph_prop:SetMaterial("")
				pl.ph_cloacking = false
			end)
		end
	end
}
-- Don't Edit below unless you know what you're doing.

local function ResetEverything()
	for _, v in pairs(player.GetAll()) do
		if IsValid(v) and v:Alive() then
			v.ph_cloacking		= false
			v.ph_slowspeed		= false
			v.ph_fastspeed		= false

			if v:Team() == TEAM_PROPS and v._OriginalWSpeed then v:SetWalkSpeed(v._OriginalWSpeed) end
			if v:Team() == TEAM_PROPS and v.ph_prop:GetMaterial() then
				v.ph_prop:DrawShadow(true)
				v.ph_prop:SetMaterial("")
			end
			if v:IsFrozen() then v:Freeze(false) end
		end
	end
end
hook.Add("PH_RoundEnd", "PHE.ForceResetDevilBall", ResetEverything)

function ENT:AddMoreLuckyEvents()
	local t = list.Get("DevilBallsAddition")
	if table.Count(t) > 0 then
		for name, tab in pairs(t) do
			printVerbose("[ Devil Ball :: Add Event ] Adding new Devil Balls events : " .. name)
			table.insert(self.funclists, tab)
		end
	else
		printVerbose("[ Devil Ball :: Add Event ] There is no additional Devil Balls events detected, ignoring...")
	end
end

ENT:AddMoreLuckyEvents()

function ENT:The_DevilDrop(pl)
	if pl:Team() == TEAM_PROPS and pl:Alive() then
		self.getfunction = table.Random(self.funclists)
		self.getfunction(pl)

		hook.Call("PH_OnDevilBallPickup", nil, pl)
	end
end

function ENT:Use(activator)
	if GAMEMODE:InRound() and IsValid(activator) and activator:IsPlayer() and activator:Alive() and activator:Team() == TEAM_PROPS then
		self:The_DevilDrop(activator)
		self:ShowEffects(self, "GlassImpact", self:GetPos(), self:GetPos())
		self:EmitSound(Sound(table.Random(self.sounds)), 60)
		self:Remove()
	end
end

function ENT:OnTakeDamage(dmg)
	local hit = dmg:GetDamage()
	self.health = self.health - hit

	if self.health < 0 then
		self:EmitSound(Sound("physics/glass/glass_cup_break" .. math.random(1, 2) .. ".wav"))
		self:ShowEffects(self, "GlassImpact", self:GetPos(), self:GetPos())
		self:Remove()
	end
end