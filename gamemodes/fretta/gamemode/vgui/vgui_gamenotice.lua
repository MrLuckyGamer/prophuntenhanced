-- client cvars to control deathmsgs
local hud_deathnotice_time = CreateClientConVar( "hud_deathnotice_time", "6", true, false )
local hud_deathnotice_limit = CreateClientConVar( "hud_deathnotice_limit", "5", true, false )

/*
	This is the player death panel. This should be parented to a DeathMessage_Panel. The DeathMessage_Panel that
	it's parented to controls aspects such as the position on screen. All this panel's job is to print the
	specific death it's been given and fade out before its RetireTime.
*/

local PANEL = {}

Derma_Hook( PANEL, 	"Paint", 				"Paint", 	"GameNotice" )
Derma_Hook( PANEL, 	"ApplySchemeSettings", 	"Scheme", 	"GameNotice" )
Derma_Hook( PANEL, 	"PerformLayout", 		"Layout", 	"GameNotice" )

function PANEL:Init()
	self.m_bHighlight = false
	self.Padding = 8
	self.Spacing = 8
	self.Items = {}
end

function PANEL:AddEntityText(txt)
    -- Ensure `txt` is not nil
    if not txt then
        self:AddText("Suicide", GAMEMODE.DeathNoticeDefaultColor)
        return false
    end

    -- Handle case where `txt` is a player
    if type(txt) == "Player" then
        local playerName = IsValid(txt) and txt:Nick() or "Unknown Player"
        self:AddText(playerName, GAMEMODE:GetTeamColor(txt))
        if txt == LocalPlayer() then
            self.m_bHighlight = true
        end
        return true
    end

    -- Handle case where `txt` is an entity
    if txt.IsValid and txt:IsValid() then
        local entityClass = txt:GetClass()
        self:AddText(entityClass, GAMEMODE.DeathNoticeDefaultColor)
        return true
    end

    -- Fallback for invalid or unrecognized entities
    self:AddText("Unknown", GAMEMODE.DeathNoticeDefaultColor)
    return false
end

function PANEL:AddItem( item )

	table.insert( self.Items, item )
	self:InvalidateLayout( true )
	
end

function PANEL:AddText(txt, color)
    -- Prevent infinite recursion by skipping entity handling here
    if type(txt) ~= "string" then
        local processed = self:AddEntityText(txt)
        if processed then return end
    end

    -- Ensure `txt` is a valid string
    local textToDisplay = tostring(txt or "")

    -- Create a label for the text
    local lbl = vgui.Create("DLabel", self)
    Derma_Hook(lbl, "ApplySchemeSettings", "Scheme", "GameNoticeLabel")
    lbl:ApplySchemeSettings()
    lbl:SetText(textToDisplay)

    -- Determine text color
    if string.Left(textToDisplay, 1) == "#" and not color then
        color = GAMEMODE.DeathNoticeDefaultColor
    elseif GAMEMODE.DeathNoticeTextColor and not color then
        color = GAMEMODE.DeathNoticeTextColor
    end

    lbl:SetTextColor(color or color_white)
    self:AddItem(lbl)
end

function PANEL:AddIcon( txt )

	if ( killicon.Exists( txt ) ) then

		local icon = vgui.Create( "DKillIcon", self )
			icon:SetName( txt )
			icon:SizeToContents()

		self:AddItem( icon )
	
	else
	
		self:AddText( "killed" )
	
	end
	
end

function PANEL:PerformLayout()

	local x = self.Padding
	local height = self.Padding * 0.5
	
	for k, v in pairs( self.Items ) do
	
		v:SetPos( x, self.Padding * 0.5 )
		v:SizeToContents()
		
		x = x + v:GetWide() + self.Spacing
		height = math.max( height, v:GetTall() + self.Padding )
	
	end
	
	self:SetSize( x + self.Padding, height )
	
end

derma.DefineControl( "GameNotice", "", PANEL, "DPanel" )