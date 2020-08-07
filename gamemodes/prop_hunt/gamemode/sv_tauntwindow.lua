util.AddNetworkString("CL2SV_PlayThisTaunt")

net.Receive("CL2SV_PlayThisTaunt", function(len, ply)
	local snd = net.ReadString()
	
	if IsValid(ply) then
		ply:EmitSound(snd, 100)
	end
end)	