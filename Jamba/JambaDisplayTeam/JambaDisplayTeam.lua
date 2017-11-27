--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2017 Michael "Jafula" Miller
License: The MIT License
]]--

-- Create the addon using AceAddon-3.0 and embed some libraries.
local AJM = LibStub( "AceAddon-3.0" ):NewAddon( 
	"JambaDisplayTeam",
	"JambaModule-1.0", 
	"AceConsole-3.0", 
	"AceEvent-3.0",
	"AceHook-3.0",
	"AceTimer-3.0"
)

-- Load libraries.
local JambaUtilities = LibStub:GetLibrary( "JambaUtilities-1.0" )
local JambaHelperSettings = LibStub:GetLibrary( "JambaHelperSettings-1.0" )
local LibBagUtils = LibStub:GetLibrary( "LibBagUtils-1.0" )
local LibButtonGlow = LibStub:GetLibrary( "LibButtonGlow-1.0")
AJM.SharedMedia = LibStub( "LibSharedMedia-3.0" )

-- Constants required by JambaModule and Locale for this module.
AJM.moduleName = "JmbDspTm"
AJM.settingsDatabaseName = "JambaDisplayTeamProfileDB"
AJM.chatCommand = "jamba-display-team"
local L = LibStub( "AceLocale-3.0" ):GetLocale( AJM.moduleName )
AJM.parentDisplayName = L["Team"]
AJM.moduleDisplayName = L["Display: Team"]

-- Settings - the values to store and their defaults for the settings database.
AJM.settings = {
	profile = {
		showTeamList = true,
		showTeamListOnMasterOnly = true,
		hideTeamListInCombat = false,
		enableClique = false,
		statusBarTexture = L["Blizzard"],
		borderStyle = L["Blizzard Tooltip"],
		backgroundStyle = L["Blizzard Dialog Background"],
		fontStyle = L["Arial Narrow"],
		fontSize = 12,
		teamListScale = 1,
		teamListTitleHeight = 15,
		teamListVerticalSpacing = 3,
		teamListHorizontalSpacing = 6,
		barVerticalSpacing = 2,
		barHorizontalSpacing = 2,
		charactersPerRow = 1,
		--Old code kept for Legacy Purpose
		barsAreStackedVertically = true,
		teamListHorizontal = true,
		showListTitle = false,
		olnyShowInParty = false,
		healthManaOutOfParty = false,
		showCharacterPortrait = true,
		characterPortraitWidth = 80,
		showFollowStatus = true,
		followStatusWidth = 100,
		followStatusHeight = 15,
		followStatusShowName = true,
		showExperienceStatus = true,
		showXpStatus = true,
		showArtifactStatus = false,
		showHonorStatus = false,
		showRepStatus = false,
		experienceStatusWidth = 100,
		experienceStatusHeight = 15,
		experienceStatusShowValues = false,
		experienceStatusShowPercentage = true,		
		showHealthStatus = true,
		showClassColors = false,
		healthStatusWidth = 100,
		healthStatusHeight = 30,
		healthStatusShowValues = true,
		healthStatusShowPercentage = true,		
		showPowerStatus = true,
		powerStatusWidth = 100,
		powerStatusHeight = 15,
		powerStatusShowValues = true,
		powerStatusShowPercentage = true,
		showComboStatus = false,
		comboStatusWidth = 100,
		comboStatusHeight = 10,
		comboStatusShowValues = true,
		comboStatusShowPercentage = true,		
		showToolTipInfo = true,
--		ShowEquippedOnly = false,
		framePoint = "LEFT",
		frameRelativePoint = "LEFT",
		frameXOffset = 0,
		frameYOffset = 80,
		frameAlpha = 1.0,
		frameBackgroundColourR = 1.0,
		frameBackgroundColourG = 1.0,
		frameBackgroundColourB = 1.0,
		frameBackgroundColourA = 1.0,
		frameBorderColourR = 1.0,
		frameBorderColourG = 1.0,
		frameBorderColourB = 1.0,
		frameBorderColourA = 1.0,
		timerCount = 1,
		currGold = true
	},
}

-- Debug message.
function AJM:DebugMessage( ... )
	--AJM:Print( ... )
end

-- Configuration.
function AJM:GetConfiguration()
	local configuration = {
		name = AJM.moduleDisplayName,
		handler = AJM,
		type = "group",
		get = "JambaConfigurationGetSetting",
		set = "JambaConfigurationSetSetting",
		args = {	
			push = {
				type = "input",
				name = L["Push Settings"],
				desc = L["Push the display team settings to all characters in the team."],
				usage = "/jamba-display-team push",
				get = false,
				set = "JambaSendSettings",
			},	
			hide = {
				type = "input",
				name = L["Hide Team Display"],
				desc = L["Hide the display team panel."],
				usage = "/jamba-display-team hide",
				get = false,
				set = "HideTeamListCommand",
			},	
			show = {
				type = "input",
				name = L["Show Team Display"],
				desc = L["Show the display team panel."],
				usage = "/jamba-display-team show",
				get = false,
				set = "ShowTeamListCommand",
			},				
		},
	}
	return configuration
end

-------------------------------------------------------------------------------------------------------------
-- Command this module sends.
-------------------------------------------------------------------------------------------------------------

AJM.COMMAND_FOLLOW_STATUS_UPDATE = "FlwStsUpd"
AJM.COMMAND_EXPERIENCE_STATUS_UPDATE = "ExpStsUpd"
AJM.COMMAND_TOONINFORMATION_UPDATE = "IlvlInfoUpd"
AJM.COMMAND_REPUTATION_STATUS_UPDATE = "RepStsUpd"
AJM.COMMAND_COMBO_STATUS_UPDATE = "CboStsUpd"
AJM.COMMAND_REQUEST_INFO = "SendInfo"
AJM.COMMAND_COMBAT_STATUS_UPDATE = "InComStsUpd"
AJM.COMMAND_POWER_STATUS_UPDATE = "PowStsUpd"
AJM.COMMAND_HEALTH_STATUS_UPDATE = "heaStsUpd"											  

-------------------------------------------------------------------------------------------------------------
-- Messages module sends.
-------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------
-- Constants used by module.
-------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------
-- Variables used by module.
-------------------------------------------------------------------------------------------------------------

-- Team display variables.
AJM.globalFramePrefix = "JambaDisplayTeam"
AJM.characterStatusBar = {}
AJM.totalMembersDisplayed = 0
AJM.teamListCreated = false	
AJM.refreshHideTeamListControlsPending = false
AJM.refreshShowTeamListControlsPending = false
AJM.updateSettingsAfterCombat = false

-------------------------------------------------------------------------------------------------------------
-- Team Frame.
-------------------------------------------------------------------------------------------------------------

local function GetCharacterHeight()
	local height = 0
	local heightPortrait = 0
	local heightFollowStatus = 0
	local heightExperienceStatus = 0
	local heightHealthStatus = 0
	local heightPowerStatus = 0
	local heightComboStatus = 0		
	local heightAllBars = 0
	if AJM.db.showCharacterPortrait == true then
		heightPortrait = AJM.db.characterPortraitWidth + AJM.db.teamListVerticalSpacing
	end
	if AJM.db.showFollowStatus == true then
		heightFollowStatus = AJM.db.followStatusHeight + AJM.db.barVerticalSpacing
		heightAllBars = heightAllBars + heightFollowStatus
	end
	if AJM.db.showExperienceStatus == true then
		heightExperienceStatus = AJM.db.experienceStatusHeight + AJM.db.barVerticalSpacing
		heightAllBars = heightAllBars + heightExperienceStatus
	end	
	if AJM.db.showHealthStatus == true then
		heightHealthStatus = AJM.db.healthStatusHeight + AJM.db.barVerticalSpacing
		heightAllBars = heightAllBars + heightHealthStatus
	end
	if AJM.db.showPowerStatus == true then
		heightPowerStatus = AJM.db.powerStatusHeight + AJM.db.barVerticalSpacing
		heightAllBars = heightAllBars + heightPowerStatus
	end
	if AJM.db.showComboStatus == true then
		heightComboStatus = AJM.db.comboStatusHeight + AJM.db.barVerticalSpacing
		heightAllBars = heightAllBars + heightComboStatus
	end	
	if AJM.db.barsAreStackedVertically == true then
		height = max( heightPortrait, heightAllBars )
	
	else
		height = max( heightPortrait, heightFollowStatus, heightExperienceStatus, heightHealthStatus, heightPowerStatus, heightComboStatus )
		--height = max( heightPortrait, heightBagInformation, heightFollowStatus, heightExperienceStatus, heightReputationStatus, heightHealthStatus, heightPowerStatus, heightComboStatus )
	end
	return height
end

local function GetCharacterWidth()
	local width = 0
	local widthPortrait = 0
	local widthFollowStatus = 0
	local widthExperienceStatus = 0
	local widthHealthStatus = 0
	local widthPowerStatus = 0
	local widthComboStatus = 0	
	local widthAllBars = 0
	if AJM.db.showCharacterPortrait == true then
		widthPortrait = AJM.db.characterPortraitWidth + AJM.db.teamListHorizontalSpacing
	end
	if AJM.db.showFollowStatus == true then
		widthFollowStatus = AJM.db.followStatusWidth + AJM.db.barHorizontalSpacing
		widthAllBars = widthAllBars + widthFollowStatus
	end
	if AJM.db.showExperienceStatus == true then
		widthExperienceStatus = AJM.db.experienceStatusWidth + AJM.db.barHorizontalSpacing
		widthAllBars = widthAllBars + widthExperienceStatus		
	end
	if AJM.db.showHealthStatus == true then
		widthHealthStatus = AJM.db.healthStatusWidth + AJM.db.barHorizontalSpacing
		widthAllBars = widthAllBars + widthHealthStatus		
	end	
	if AJM.db.showPowerStatus == true then
		widthPowerStatus = AJM.db.powerStatusWidth + AJM.db.barHorizontalSpacing
		widthAllBars = widthAllBars + widthPowerStatus		
	end
	if AJM.db.showComboStatus == true then
		widthComboStatus = AJM.db.comboStatusWidth + AJM.db.barHorizontalSpacing
		widthAllBars = widthAllBars + widthComboStatus		
	end
	if AJM.db.barsAreStackedVertically == true then
		width = widthPortrait + max( widthFollowStatus, widthExperienceStatus, widthHealthStatus, widthPowerStatus, widthComboStatus )
		--width = widthPortrait + max( widthBagInformation, widthFollowStatus, widthExperienceStatus, widthReputationStatus, widthHealthStatus, widthPowerStatus, widthComboStatus )
	else
		width = widthPortrait + widthAllBars
	end
	return width
end

local function UpdateJambaTeamListDimensions()
	local frame = JambaDisplayTeamListFrame
	if AJM.db.showListTitle == true then
		AJM.db.teamListTitleHeight = 15
		JambaDisplayTeamListFrame.titleName:SetText( L["Jamba Team"] )
	else
		AJM.db.teamListTitleHeight = 0
		JambaDisplayTeamListFrame.titleName:SetText( "" )
	end
	if AJM.db.teamListHorizontal == true then
		--Old code kept for Legacy Purpose
		--	frame:SetWidth( (AJM.db.teamListVerticalSpacing * 3) + (GetCharacterWidth() * AJM.totalMembersDisplayed) )
		--	frame:SetHeight( AJM.db.teamListTitleHeight + (AJM.db.teamListVerticalSpacing * 3) + GetCharacterHeight() )
	else
		frame:SetWidth( (AJM.db.teamListHorizontalSpacing * 3) + GetCharacterWidth() )
		frame:SetHeight( AJM.db.teamListTitleHeight + (GetCharacterHeight() * AJM.totalMembersDisplayed) + (AJM.db.teamListVerticalSpacing * 3) )
	end
	frame:SetScale( AJM.db.teamListScale )
end

local function CreateJambaTeamListFrame()
	-- The frame.
	local frame = CreateFrame( "Frame", "JambaDisplayTeamListWindowFrame", UIParent )
	frame.obj = AJM
	frame:SetFrameStrata( "LOW" )
	frame:SetToplevel( true )
	frame:SetClampedToScreen( true )
	frame:EnableMouse( true )
	frame:SetMovable( true )	
	frame:RegisterForDrag( "LeftButton" )
	frame:SetScript( "OnDragStart", 
		function( this ) 
			if IsAltKeyDown() then
				if not UnitAffectingCombat("player") then		
					this:StartMoving()
				end	
			end
		end )
	frame:SetScript( "OnDragStop", 
		function( this ) 
			this:StopMovingOrSizing() 
			local point, relativeTo, relativePoint, xOffset, yOffset = this:GetPoint()
			AJM.db.framePoint = point
			AJM.db.frameRelativePoint = relativePoint
			AJM.db.frameXOffset = xOffset
			AJM.db.frameYOffset = yOffset
		end	)	
	frame:ClearAllPoints()
	frame:SetPoint( AJM.db.framePoint, UIParent, AJM.db.frameRelativePoint, AJM.db.frameXOffset, AJM.db.frameYOffset )
	frame:SetBackdrop( {
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", 
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", 
		tile = true, tileSize = 10, edgeSize = 10, 
		insets = { left = 3, right = 3, top = 3, bottom = 3 }
	} )

	-- Create the title for the team list frame.
	local titleName = frame:CreateFontString( "JambaDisplayTeamListWindowFrameTitleText", "OVERLAY", "GameFontNormal" )
	titleName:SetPoint( "TOP", frame, "TOP", 0, -5 )
	titleName:SetTextColor( 1.00, 1.00, 1.00 )
	titleName:SetText( L["Jamba Team"] )
	frame.titleName = titleName
	
	-- Set transparency of the the frame (and all its children).
	frame:SetAlpha(AJM.db.frameAlpha)
	
	-- Set the global frame reference for this frame.
	JambaDisplayTeamListFrame = frame
	
	AJM:SettingsUpdateBorderStyle()	
	AJM.teamListCreated = true

end

local function CanDisplayTeamList()
	local canShow = false
	if AJM.db.showTeamList == true then
		if AJM.db.showTeamListOnMasterOnly == true then
			if JambaApi.IsCharacterTheMaster( AJM.characterName ) == true then
				canShow = true
			end
		else
			canShow = true
		end
	end
	return canShow
end

function AJM:ShowTeamListCommand()
	AJM.db.showTeamList = true
	AJM:SetTeamListVisibility()
end

function AJM:HideTeamListCommand()
	AJM.db.showTeamList = false
	AJM:SetTeamListVisibility()
end

function AJM:SetTeamListVisibility()
	if CanDisplayTeamList() == true then
		JambaDisplayTeamListFrame:ClearAllPoints()
		JambaDisplayTeamListFrame:SetPoint( AJM.db.framePoint, UIParent, AJM.db.frameRelativePoint, AJM.db.frameXOffset, AJM.db.frameYOffset )
		JambaDisplayTeamListFrame:SetAlpha( AJM.db.frameAlpha )
		JambaDisplayTeamListFrame:Show()
	else
		JambaDisplayTeamListFrame:Hide()
	end	
end

function AJM:RefreshTeamListControlsHide()
	if InCombatLockdown() then
		AJM.refreshHideTeamListControlsPending = true
		return
	end
	for characterName, characterStatusBar in pairs( AJM.characterStatusBar ) do	
		characterName = JambaUtilities:AddRealmToNameIfMissing ( characterName ) 
		-- Hide their status bar.
		AJM:HideJambaTeamStatusBar( characterName )		
	end
	UpdateJambaTeamListDimensions()
end

function AJM:RefreshTeamListControlsShow()
	if InCombatLockdown() then
		AJM.refreshShowTeamListControlsPending = true
		return
	end

	AJM.totalMembersDisplayed = 0
	for index, characterName in JambaApi.TeamListOrdered() do
		characterName = JambaUtilities:AddRealmToNameIfMissing ( characterName )
		-- Is the team member online?
	if JambaApi.GetCharacterOnlineStatus( characterName ) == true then
		-- Checks the player is the party to hide the bar if needed.
			if AJM.db.olnyShowInParty == true then
				if UnitClass(Ambiguate( characterName, "none" ) ) then
				-- Yes, the team member is online, draw their status bars.
					AJM:UpdateJambaTeamStatusBar( characterName, AJM.totalMembersDisplayed )		
					AJM.totalMembersDisplayed = AJM.totalMembersDisplayed + 1
				end
			else
					AJM:UpdateJambaTeamStatusBar( characterName, AJM.totalMembersDisplayed )		
					AJM.totalMembersDisplayed = AJM.totalMembersDisplayed + 1			
			end
		end
	end
	UpdateJambaTeamListDimensions()	
end
	
function AJM:RefreshTeamListControls()
	AJM:RefreshTeamListControlsHide()
	AJM:RefreshTeamListControlsShow()
end

function AJM:SettingsUpdateStatusBarTexture()
	local statusBarTexture = AJM.SharedMedia:Fetch( "statusbar", AJM.db.statusBarTexture )
	for characterName, characterStatusBar in pairs( AJM.characterStatusBar ) do	
		characterStatusBar["followBar"]:SetStatusBarTexture( statusBarTexture )
		characterStatusBar["followBar"]:GetStatusBarTexture():SetHorizTile( false )
		characterStatusBar["followBar"]:GetStatusBarTexture():SetVertTile( false )		
		characterStatusBar["experienceBar"]:SetStatusBarTexture( statusBarTexture )
		characterStatusBar["experienceBar"]:GetStatusBarTexture():SetHorizTile( false )
		characterStatusBar["experienceBar"]:GetStatusBarTexture():SetVertTile( false )
		characterStatusBar["experienceArtBar"]:SetStatusBarTexture( statusBarTexture )
		characterStatusBar["experienceArtBar"]:GetStatusBarTexture():SetHorizTile( false )
		characterStatusBar["experienceArtBar"]:GetStatusBarTexture():SetVertTile( false )		
		characterStatusBar["experienceHonorBar"]:SetStatusBarTexture( statusBarTexture )
		characterStatusBar["experienceHonorBar"]:GetStatusBarTexture():SetHorizTile( false )
		characterStatusBar["experienceHonorBar"]:GetStatusBarTexture():SetVertTile( false )		
		characterStatusBar["reputationBar"]:SetStatusBarTexture( statusBarTexture )
		characterStatusBar["reputationBar"]:GetStatusBarTexture():SetHorizTile( false )
		characterStatusBar["reputationBar"]:GetStatusBarTexture():SetVertTile( false )		
		characterStatusBar["healthBar"]:SetStatusBarTexture( statusBarTexture )
		characterStatusBar["healthBar"]:GetStatusBarTexture():SetHorizTile( false )
		characterStatusBar["healthBar"]:GetStatusBarTexture():SetVertTile( false )				
		characterStatusBar["powerBar"]:SetStatusBarTexture( statusBarTexture )
		characterStatusBar["powerBar"]:GetStatusBarTexture():SetHorizTile( false )
		characterStatusBar["powerBar"]:GetStatusBarTexture():SetVertTile( false )
		characterStatusBar["comboBar"]:SetStatusBarTexture( statusBarTexture )
		characterStatusBar["comboBar"]:GetStatusBarTexture():SetHorizTile( false )
		characterStatusBar["comboBar"]:GetStatusBarTexture():SetVertTile( false )
	end
end

function AJM:SettingsUpdateFontStyle()
	local textFont = AJM.SharedMedia:Fetch( "font", AJM.db.fontStyle )
	local textSize = AJM.db.fontSize
	for characterName, characterStatusBar in pairs( AJM.characterStatusBar ) do	
		characterStatusBar["followBarText"]:SetFont( textFont , textSize , "OUTLINE")		
		characterStatusBar["experienceBarText"]:SetFont( textFont , textSize , "OUTLINE")
		characterStatusBar["experienceArtBarText"]:SetFont( textFont , textSize , "OUTLINE")
		characterStatusBar["experienceHonorBarText"]:SetFont( textFont , textSize , "OUTLINE")
		characterStatusBar["reputationBarText"]:SetFont( textFont , textSize , "OUTLINE")
		characterStatusBar["healthBarText"]:SetFont( textFont , textSize , "OUTLINE")
		characterStatusBar["powerBarText"]:SetFont( textFont , textSize , "OUTLINE")
		characterStatusBar["comboBarText"]:SetFont( textFont , textSize , "OUTLINE")

	end
end

function AJM:SettingsUpdateBorderStyle()
	local borderStyle = AJM.SharedMedia:Fetch( "border", AJM.db.borderStyle )
	local backgroundStyle = AJM.SharedMedia:Fetch( "background", AJM.db.backgroundStyle )
	local frame = JambaDisplayTeamListFrame
	frame:SetBackdrop( {
		bgFile = backgroundStyle, 
		edgeFile = borderStyle, 
		tile = true, tileSize = frame:GetWidth(), edgeSize = 10, 
		insets = { left = 3, right = 3, top = 3, bottom = 3 }
	} )
	frame:SetBackdropColor( AJM.db.frameBackgroundColourR, AJM.db.frameBackgroundColourG, AJM.db.frameBackgroundColourB, AJM.db.frameBackgroundColourA )
	frame:SetBackdropBorderColor( AJM.db.frameBorderColourR, AJM.db.frameBorderColourG, AJM.db.frameBorderColourB, AJM.db.frameBorderColourA )	
end

function AJM:CreateJambaTeamStatusBar( characterName, parentFrame )
	local statusBarTexture = AJM.SharedMedia:Fetch( "statusbar", AJM.db.statusBarTexture )
	local textFont = AJM.SharedMedia:Fetch( "font", AJM.db.fontStyle )
	local textSize = AJM.db.fontSize
	
	-- Create the table to hold the status bars for this character.
	AJM.characterStatusBar[characterName] = {}
	-- Get the status bars table.
	local characterStatusBar = AJM.characterStatusBar[characterName]
	-- Set the portrait.
	local portraitName = AJM.globalFramePrefix.."PortraitButton"
	local portraitButton = CreateFrame( "PlayerModel", portraitName, parentFrame )
	portraitButton:ClearModel()
	portraitButton:SetUnit( Ambiguate( characterName, "short" ) )
	portraitButton:SetPortraitZoom( 1 )
    portraitButton:SetCamDistanceScale( 1 )
    portraitButton:SetPosition( 0, 0, 0 )
	local portraitButtonClick = CreateFrame( "CheckButton", portraitName.."Click", parentFrame, "SecureActionButtonTemplate" )
	portraitButtonClick:SetAttribute( "unit", Ambiguate( characterName, "all" ) )
	characterStatusBar["portraitButton"] = portraitButton
	characterStatusBar["portraitButtonClick"] = portraitButtonClick
	-- Set the follow bar.
	local followName = AJM.globalFramePrefix.."FollowBar"
	local followBar = CreateFrame( "StatusBar", followName, parentFrame, "TextStatusBar,SecureActionButtonTemplate" )
	followBar.backgroundTexture = followBar:CreateTexture( followName.."BackgroundTexture", "ARTWORK" )
	followBar.backgroundTexture:SetColorTexture( 0.58, 0.0, 0.55, 0.15 )
	followBar:SetStatusBarTexture( statusBarTexture )
	followBar:GetStatusBarTexture():SetHorizTile( false )
	followBar:GetStatusBarTexture():SetVertTile( false )
	followBar:SetStatusBarColor( 0.55, 0.15, 0.15, 0.25 )
	followBar:SetMinMaxValues( 0, 100 )
	followBar:SetValue( 100 )
	followBar:SetFrameStrata( "LOW" )
	followBar:SetAlpha( 1 )
	local followBarClick = CreateFrame( "CheckButton", followName.."Click", parentFrame, "SecureActionButtonTemplate" )
	followBarClick:SetAttribute( "unit", Ambiguate( characterName, "all" ) )
	--followBarClick:SetAttribute( "macrotext", "/targetexact "..characterName )
	followBarClick:SetFrameStrata( "MEDIUM" )
	characterStatusBar["followBar"] = followBar
	characterStatusBar["followBarClick"] = followBarClick	
	local followBarText = followBar:CreateFontString( followName.."Text", "OVERLAY", "GameFontNormal" )
	followBarText:SetTextColor( 1.00, 1.00, 1.00, 1.00 )
	followBarText:SetFont( textFont , textSize, "OUTLINE")
	followBarText:SetAllPoints()
	characterStatusBar["followBarText"] = followBarText
	AJM:SettingsUpdateFollowText( characterName ) --, UnitLevel( Ambiguate( characterName, "none" ) ), nil, nil )
	--ToolTip infomation
	followBar.FreeBagSpace = 0
	followBar.TotalBagSpace = 8
	followBar.ArgIlvl = 1
	followBar.Durability = 000
	followBar.Gold = 0
	followBar.Mail = "nothing"
	followBar.CurrText = "currNothing"
	followBar.CharacterLevel = 1
	followBar.MaxCharacterLevel = 100
--	followBarClick:SetScript("OnEnter", function(self) AJM:ShowFollowTooltip(followBarClick, followBar, characterName, true) end)
--	followBarClick:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	-- Set the experience bar.
	local experienceName = AJM.globalFramePrefix.."ExperienceBar"
	local experienceBar = CreateFrame( "StatusBar", experienceName, parentFrame, "AnimatedStatusBarTemplate" ) --"TextStatusBar,SecureActionButtonTemplate" )
	experienceBar.backgroundTexture = experienceBar:CreateTexture( experienceName.."BackgroundTexture", "ARTWORK" )
	experienceBar.backgroundTexture:SetColorTexture( 0.0, 0.39, 0.88, 0.15 )
	experienceBar:SetStatusBarTexture( statusBarTexture )
	experienceBar:GetStatusBarTexture():SetHorizTile( false )
	experienceBar:GetStatusBarTexture():SetVertTile( false )
	experienceBar:SetMinMaxValues( 0, 100 )
	experienceBar:SetValue( 100 )
	experienceBar:SetFrameStrata( "LOW" )
	local experienceBarClick = CreateFrame( "CheckButton", experienceName.."Click", parentFrame, "SecureActionButtonTemplate" )
	experienceBarClick:SetAttribute( "unit", Ambiguate( characterName, "all" ) )
	experienceBarClick:SetFrameStrata( "MEDIUM" )
	characterStatusBar["experienceBar"] = experienceBar
	characterStatusBar["experienceBarClick"] = experienceBarClick
	local experienceBarText = experienceBar:CreateFontString( experienceName.."Text", "OVERLAY", "GameFontNormal" )
	experienceBarText:SetTextColor( 1.00, 1.00, 1.00, 1.00 )
	experienceBarText:SetFont( textFont , textSize, "OUTLINE")
	experienceBarText:SetAllPoints()
	experienceBarText.playerExperience = 100
	experienceBarText.playerMaxExperience = 100
	experienceBarText.exhaustionStateID = 1
	experienceBarText.playerLevel = 1
	characterStatusBar["experienceBarText"] = experienceBarText
	AJM:UpdateExperienceStatus( characterName, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil )	
	-- Set the artifactXP bar.
	local experienceArtName = AJM.globalFramePrefix.."ExperienceArtBar"
	local experienceArtBar = CreateFrame( "StatusBar", experienceArtName, parentFrame, "AnimatedStatusBarTemplate" ) --"TextStatusBar,SecureActionButtonTemplate" )
	experienceArtBar.backgroundTexture = experienceArtBar:CreateTexture( experienceArtName.."BackgroundTexture", "ARTWORK" )
	experienceArtBar.backgroundTexture:SetColorTexture( 1.0, 0.0, 0.0, 0.15 )
	experienceArtBar:SetStatusBarTexture( statusBarTexture )
	experienceArtBar:GetStatusBarTexture():SetHorizTile( false )
	experienceArtBar:GetStatusBarTexture():SetVertTile( false )
	experienceArtBar:SetMinMaxValues( 0, 100 )
	experienceArtBar:SetValue( 100 )
	experienceArtBar:SetFrameStrata( "LOW" )
	local experienceArtBarClick = CreateFrame( "CheckButton", experienceArtName.."Click", parentFrame, "SecureActionButtonTemplate" )
	experienceArtBarClick:SetAttribute( "unit", Ambiguate( characterName, "all" ) )
	experienceArtBarClick:SetFrameStrata( "MEDIUM" )
	characterStatusBar["experienceArtBar"] = experienceArtBar
	characterStatusBar["experienceArtBarClick"] = experienceArtBarClick
	local experienceArtBarText = experienceArtBar:CreateFontString( experienceArtName.."Text", "OVERLAY", "GameFontNormal" )
	experienceArtBarText:SetTextColor( 1.00, 1.00, 1.00, 1.00 )
	experienceArtBarText:SetFont( textFont , textSize, "OUTLINE")
	experienceArtBarText:SetAllPoints()
	experienceArtBarText.artifactName = "N/A"
	experienceArtBarText.artifactXP = 0
	experienceArtBarText.artifactForNextPoint = 100
	experienceArtBarText.artifactPointsSpent = 1
	experienceArtBarText.artifactPointsAvailable = 0
	characterStatusBar["experienceArtBarText"] = experienceArtBarText
	AJM:UpdateExperienceStatus( characterName, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil )
	-- Set the HonorXP bar.
	local experienceHonorName = AJM.globalFramePrefix.."ExperienceHonorBar"
	local experienceHonorBar = CreateFrame( "StatusBar", experienceHonorName, parentFrame, "AnimatedStatusBarTemplate" ) --"TextStatusBar,SecureActionButtonTemplate" )
	experienceHonorBar.backgroundTexture = experienceArtBar:CreateTexture( experienceArtName.."BackgroundTexture", "ARTWORK" )
	experienceHonorBar.backgroundTexture:SetColorTexture( 1.0, 0.0, 0.0, 0.15 )
	experienceHonorBar:SetStatusBarTexture( statusBarTexture )
	experienceHonorBar:GetStatusBarTexture():SetHorizTile( false )
	experienceHonorBar:GetStatusBarTexture():SetVertTile( false )
	experienceHonorBar:SetMinMaxValues( 0, 100 )
	experienceHonorBar:SetValue( 100 )
	experienceHonorBar:SetFrameStrata( "LOW" )
	local experienceHonorBarClick = CreateFrame( "CheckButton", experienceHonorName.."Click", parentFrame, "SecureActionButtonTemplate" )
	experienceHonorBarClick:SetAttribute( "unit", Ambiguate( characterName, "all" ) )
	experienceHonorBarClick:SetFrameStrata( "MEDIUM" )
	characterStatusBar["experienceHonorBar"] = experienceHonorBar
	characterStatusBar["experienceHonorBarClick"] = experienceHonorBarClick
	local experienceHonorBarText = experienceHonorBar:CreateFontString( experienceHonorName.."Text", "OVERLAY", "GameFontNormal" )
	experienceHonorBarText:SetTextColor( 1.00, 1.00, 1.00, 1.00 )
	experienceHonorBarText:SetFont( textFont , textSize, "OUTLINE")
	experienceHonorBarText:SetAllPoints()
	experienceHonorBarText.honorLevel = 0
	experienceHonorBarText.honorXP = 0
	experienceHonorBarText.honorMax = 100
	experienceHonorBarText.honorExhaustionStateID = 1
	experienceHonorBarText.canPrestige = "N/A"
	characterStatusBar["experienceHonorBarText"] = experienceHonorBarText
	AJM:UpdateExperienceStatus( characterName, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil )	
	-- Set the reputation bar.
	local reputationName = AJM.globalFramePrefix.."ReputationBar"
	local reputationBar = CreateFrame( "StatusBar", reputationName, parentFrame, "AnimatedStatusBarTemplate" ) --"TextStatusBar,SecureActionButtonTemplate" )
	reputationBar.backgroundTexture = reputationBar:CreateTexture( reputationName.."BackgroundTexture", "ARTWORK" )
	reputationBar.backgroundTexture:SetColorTexture( 0.0, 0.39, 0.88, 0.15 )
	reputationBar:SetStatusBarTexture( statusBarTexture )
	reputationBar:GetStatusBarTexture():SetHorizTile( false )
	reputationBar:GetStatusBarTexture():SetVertTile( false )
	reputationBar:SetMinMaxValues( 0, 100 )
	reputationBar:SetValue( 100 )
	reputationBar:SetFrameStrata( "LOW" )
	local reputationBarClick = CreateFrame( "CheckButton", reputationName.."Click", parentFrame, "SecureActionButtonTemplate" )
	reputationBarClick:SetAttribute( "unit", Ambiguate( characterName, "all" ) )
	reputationBarClick:SetFrameStrata( "MEDIUM" )
	characterStatusBar["reputationBar"] = reputationBar
	characterStatusBar["reputationBarClick"] = reputationBarClick
	local reputationBarText = reputationBar:CreateFontString( reputationName.."Text", "OVERLAY", "GameFontNormal" )
	reputationBarText:SetTextColor( 1.00, 1.00, 1.00, 1.00 )
	reputationBarText:SetFont( textFont , textSize, "OUTLINE")
	reputationBarText:SetAllPoints()
	reputationBarText.reputationName = "Faction"
	reputationBarText.reputationStandingID = 4
	reputationBarText.reputationBarMin = 0
	reputationBarText.reputationBarMax = 100
	reputationBarText.reputationBarValue = 100
	characterStatusBar["reputationBarText"] = reputationBarText
	AJM:UpdateReputationStatus( characterName, nil, nil, nil )
	-- Set the health bar.
	
	local healthName = AJM.globalFramePrefix.."HealthBar"
	local healthBar = CreateFrame( "StatusBar", healthName, parentFrame, "TextStatusBar,SecureActionButtonTemplate" )
	healthBar.backgroundTexture = healthBar:CreateTexture( healthName.."BackgroundTexture", "ARTWORK" )
	healthBar.backgroundTexture:SetColorTexture( 0.58, 0.0, 0.55, 0.15 )
	healthBar:SetStatusBarTexture( statusBarTexture )
	healthBar:GetStatusBarTexture():SetHorizTile( false )
	healthBar:GetStatusBarTexture():SetVertTile( false )
	healthBar:SetMinMaxValues( 0, 100 )
	healthBar:SetValue( 100 )
	healthBar:SetFrameStrata( "LOW" )
	healthBar:SetAlpha( 1 )

	
	local healthIncomingName = AJM.globalFramePrefix.."HealthIncomingBar"
	local healthIncomingBar = CreateFrame( "StatusBar", healthIncomingName, parentFrame, "TextStatusBar,SecureActionButtonTemplate" )
	healthIncomingBar.backgroundTexture = healthIncomingBar:CreateTexture( healthIncomingName.."BackgroundTexture", "ARTWORK" )
	healthIncomingBar.backgroundTexture:SetColorTexture( 0.58, 0.0, 0.55, 0.15 )
	healthIncomingBar:SetStatusBarTexture( statusBarTexture )
	healthIncomingBar:GetStatusBarTexture():SetHorizTile( false )
	healthIncomingBar:GetStatusBarTexture():SetVertTile( false )
	healthIncomingBar:SetMinMaxValues( 0, 100 )
	healthIncomingBar:SetValue( 0 )
	healthIncomingBar:SetFrameStrata( "BACKGROUND" )
	healthIncomingBar:SetAlpha( 1 )
	
	-- Set the heal Incoming bar	

	local healthBarClick = CreateFrame( "CheckButton", healthName.."Click"..characterName, parentFrame, "SecureActionButtonTemplate" )
	healthBarClick:SetAttribute( "unit", Ambiguate( characterName, "all" ) )
	healthBarClick:SetFrameStrata( "MEDIUM" )
	characterStatusBar["healthBar"] = healthBar
	characterStatusBar["healthIncomingBar"] = healthIncomingBar
	characterStatusBar["healthBarClick"] = healthBarClick
	local healthBarText = healthBar:CreateFontString( healthName.."Text", "OVERLAY", "GameFontNormal" )
	healthBarText:SetTextColor( 1.00, 1.00, 1.00, 1.00 )
	healthBarText:SetFont( textFont , textSize, "OUTLINE")
	healthBarText:SetAllPoints()
	healthBarText.playerHealth = 100
	healthBarText.playerMaxHealth = 100
	healthBarText.inComingHeal = 0
	characterStatusBar["healthBarText"] = healthBarText
	AJM:UpdateHealthStatus( characterName, nil, nil )
	
	
	-- Set the power bar.
	local powerName = AJM.globalFramePrefix.."PowerBar"
	local powerBar = CreateFrame( "StatusBar", powerName, parentFrame, "TextStatusBar,SecureActionButtonTemplate" )
	powerBar.backgroundTexture = powerBar:CreateTexture( powerName.."BackgroundTexture", "ARTWORK" )
	powerBar.backgroundTexture:SetColorTexture( 0.58, 0.0, 0.55, 0.15 )
	powerBar:SetStatusBarTexture( statusBarTexture )
	powerBar:GetStatusBarTexture():SetHorizTile( false )
	powerBar:GetStatusBarTexture():SetVertTile( false )
	powerBar:SetMinMaxValues( 0, 100 )
	powerBar:SetValue( 100 )
	powerBar:SetFrameStrata( "LOW" )
	powerBar:SetAlpha( 1 )
	local powerBarClick = CreateFrame( "CheckButton", powerName.."Click"..characterName, parentFrame, "SecureActionButtonTemplate" )
	powerBarClick:SetAttribute( "unit", Ambiguate( characterName, "all" ) )
	powerBarClick:SetFrameStrata( "MEDIUM" )
	characterStatusBar["powerBar"] = powerBar
	characterStatusBar["powerBarClick"] = powerBarClick
	local powerBarText = powerBar:CreateFontString( powerName.."Text", "OVERLAY", "GameFontNormal" )
	powerBarText:SetTextColor( 1.00, 1.00, 1.00, 1.00 )
	powerBarText:SetFont( textFont , textSize, "OUTLINE")
	powerBarText:SetAllPoints()
	powerBarText.playerPower = 100
	powerBarText.playerMaxPower = 100
	characterStatusBar["powerBarText"] = powerBarText
	AJM:UpdatePowerStatus( characterName, nil, nil, nil )
	-- Set the Combo Points bar.
	local comboName = AJM.globalFramePrefix.."ComboBar"
	local comboBar = CreateFrame( "StatusBar", comboName, parentFrame, "TextStatusBar,SecureActionButtonTemplate" )
	comboBar.backgroundTexture = comboBar:CreateTexture( comboName.."BackgroundTexture", "ARTWORK" )
	comboBar.backgroundTexture:SetColorTexture( 0.58, 0.0, 0.55, 0.15 )
	comboBar:SetStatusBarTexture( statusBarTexture )
	comboBar:GetStatusBarTexture():SetHorizTile( false )
	comboBar:GetStatusBarTexture():SetVertTile( false )
	comboBar:SetStatusBarColor( 1.00, 0.0, 0.0, 1.00 )
	comboBar:SetMinMaxValues( 0, 5 )
	comboBar:SetValue( 5 )
	comboBar:SetFrameStrata( "LOW" )
	comboBar:SetAlpha( 1 )
	local comboBarClick = CreateFrame( "CheckButton", comboName.."Click"..characterName, parentFrame, "SecureActionButtonTemplate" )
	comboBarClick:SetAttribute( "unit", characterName )
	comboBarClick:SetFrameStrata( "MEDIUM" )
	characterStatusBar["comboBar"] = comboBar
	characterStatusBar["comboBarClick"] = comboBarClick
	local comboBarText = comboBar:CreateFontString( comboName.."Text", "OVERLAY", "GameFontNormal" )
	comboBarText:SetTextColor( 1.00, 1.00, 0.0, 1.00 )
	comboBarText:SetFont( textFont , textSize, "OUTLINE")
	comboBarText:SetAllPoints()
	comboBarText.playerCombo = 0
	comboBarText.playerMaxCombo = 5
	characterStatusBar["comboBarText"] = comboBarText
	AJM:UpdateComboStatus( characterName, nil, nil )
	-- Add the health and power click bars to ClickCastFrames for addons like Clique to use.
	--Ebony if Support for Clique if not on then default to target unit
	--TODO there got to be a better way to doing this for sure but right now i can not be assed to do this for now you need to reload the UI when turning off and on clique support. 
	ClickCastFrames = ClickCastFrames or {}
	if AJM.db.enableClique == true then
		ClickCastFrames[portraitButtonClick] = true
		ClickCastFrames[followBarClick] = true
		ClickCastFrames[experienceBarClick] = true
		ClickCastFrames[reputationBarClick] = true
		ClickCastFrames[healthBarClick] = true
		ClickCastFrames[powerBarClick] = true
		ClickCastFrames[comboBarClick] = true
	else
		portraitButtonClick:SetAttribute( "type1", "target")
		followBarClick:SetAttribute( "type1", "target")
		experienceBarClick:SetAttribute( "type1", "target")
		reputationBarClick:SetAttribute( "type1", "target")
		healthBarClick:SetAttribute( "type1", "target")
		powerBarClick:SetAttribute( "type1", "target")
		comboBarClick:SetAttribute( "type1", "target")
	end
end



function AJM:ShowFollowTooltip( frame, followBar, characterName, canShow )
	--AJM:Print("test", frame, characterName, canShow)
	AJM:JambaRequestUpdate()
	--Tooltip
	if canShow then	
		if AJM.db.showToolTipInfo == true then
			local combat = UnitAffectingCombat("player")
			if combat == false then
				--AJM:Print("CanShow")
					--followBarClick:SetScript("OnEnter", function(self)
					GameTooltip:SetOwner(frame, "ANCHOR_TOP")
				if AJM.db.followStatusShowName == true then 	
				GameTooltip:AddLine(L["Toon Information"], 1, 0.82, 0, 1)	
				else
				GameTooltip:AddLine(Ambiguate( characterName, "none" ), 1, 0.82, 0, 1)
				end
				--level of player if not max.
				if followBar.CharacterLevel ~= followBar.MaxCharacterLevel then
					GameTooltip:AddLine(L["Player Level:"]..L[" "]..L["("]..tostring (format("%.0f", followBar.CharacterLevel ))..L[")"],1,1,1,1)
				end
					-- Item Level of player
					GameTooltip:AddLine(L["Item Level:"]..L[" "]..L["("]..tostring (format("%.0f", followBar.ArgIlvl ))..L[")"],1,1,1,1)
					-- Bag Space
					GameTooltip:AddLine(" ",1,1,1,1)
					GameTooltip:AddLine(L["Bag Space:"]..L[" "]..L["("]..tostring(followBar.FreeBagSpace).."/"..tostring( followBar.TotalBagSpace)..L[")"],1,1,1,1)
					-- Durability
					GameTooltip:AddLine(L["Durability:"]..L[" "]..L["("]..tostring(gsub( followBar.Durability , "%.[^|]+", "") )..L["%"]..L[")"],1,1,1,1)
					-- Gold
					GameTooltip:AddLine(" ",1,1,1,1)
					GameTooltip:AddLine(L["Gold:"]..L[" "]..GetCoinTextureString( followBar.Gold ),1,1,1,1)
					--AJM:Print("mail", ilvlInformationFrame.toolText, "Curr", ilvlInformationFrame.currText)
					-- Shows if has Ingame Mail
					if not (followBar.Mail == "nothing") then
						GameTooltip:AddLine(" ",1,1,1,1)
						GameTooltip:AddLine(L["Has New Mail From:"], 1, 0.82, 0, 1)
						GameTooltip:AddLine( followBar.Mail,1,1,1,1)
					end	
					if not (followBar.CurrText == "currNothing") then
						GameTooltip:AddLine(" ",1,1,1,1)
						GameTooltip:AddLine(L["Currency Info:"], 1, 0.82, 0, 1)
						GameTooltip:AddLine( followBar.CurrText,1,1,1,1)
					end	

					GameTooltip:Show()
				else
					GameTooltip:Hide()
				end
			end	
	else
		GameTooltip:Hide()
	end
end






function AJM:HideJambaTeamStatusBar( characterName )	
	local parentFrame = JambaDisplayTeamListFrame
	-- Get (or create and get) the character status bar information.
	local characterStatusBar = AJM.characterStatusBar[characterName]
	if characterStatusBar == nil then
		AJM:CreateJambaTeamStatusBar( characterName, parentFrame )
		characterStatusBar = AJM.characterStatusBar[characterName]
	end
	-- Hide the bars.
	characterStatusBar["portraitButton"]:Hide()
	characterStatusBar["portraitButtonClick"]:Hide()
	characterStatusBar["followBar"]:Hide()
	characterStatusBar["followBarClick"]:Hide()
	characterStatusBar["experienceBar"]:Hide()
	characterStatusBar["experienceBarClick"]:Hide()
	characterStatusBar["experienceArtBar"]:Hide()
	characterStatusBar["experienceArtBarClick"]:Hide()
	characterStatusBar["experienceHonorBar"]:Hide()
	characterStatusBar["experienceHonorBarClick"]:Hide()	
	characterStatusBar["reputationBar"]:Hide()
	characterStatusBar["reputationBarClick"]:Hide()	
	characterStatusBar["healthBar"]:Hide()
	characterStatusBar["healthIncomingBar"]:Hide()
	characterStatusBar["healthBarClick"]:Hide()
	characterStatusBar["powerBar"]:Hide()
	characterStatusBar["powerBarClick"]:Hide()
	characterStatusBar["comboBar"]:Hide()
	characterStatusBar["comboBarClick"]:Hide()
end	


function AJM:UpdateJambaTeamStatusBar( characterName, characterPosition )	
	local parentFrame = JambaDisplayTeamListFrame
	-- Get (or create and get) the character status bar information.
	local characterStatusBar = AJM.characterStatusBar[characterName]
	if characterStatusBar == nil then
		AJM:CreateJambaTeamStatusBar( characterName, parentFrame )
		characterStatusBar = AJM.characterStatusBar[characterName]
	end
	-- Set the positions.
	local characterHeight = GetCharacterHeight()
	local characterWidth = GetCharacterWidth()
	local positionLeft = 0
	local positionTop = -AJM.db.teamListTitleHeight - (AJM.db.teamListVerticalSpacing * 2)
	local charactersPerRow = AJM.db.charactersPerRow
	if AJM.db.teamListHorizontal == true then
		if characterPosition < charactersPerRow then
			positionLeft = -6 + (characterPosition * characterWidth) + (AJM.db.teamListHorizontalSpacing * 3)
			parentFrame:SetWidth( (AJM.db.teamListVerticalSpacing * 3) + (GetCharacterWidth() ) + ( positionLeft ) )
			parentFrame:SetHeight( AJM.db.teamListTitleHeight + (AJM.db.teamListVerticalSpacing * 3) + GetCharacterHeight() ) 
		-- Row 2
		elseif 	characterPosition < ( charactersPerRow * 2 ) then
			positionLeft = -6 + (characterPosition - charactersPerRow ) * ( characterWidth ) + (AJM.db.teamListHorizontalSpacing * 3)
			positionTop = (positionTop - characterHeight)
			parentFrame:SetHeight( AJM.db.teamListTitleHeight + (AJM.db.teamListVerticalSpacing * 3) + ( GetCharacterHeight() ) * 2 ) 
		-- Row 3	
		elseif 	characterPosition < ( charactersPerRow * 3 ) then
			positionLeft = -6 + (characterPosition - charactersPerRow * 2 ) * ( characterWidth ) + (AJM.db.teamListHorizontalSpacing * 3)
			positionTop = (positionTop - characterHeight * 2 )
			parentFrame:SetHeight( AJM.db.teamListTitleHeight + (AJM.db.teamListVerticalSpacing * 3) + GetCharacterHeight() * 3 )
			-- Row 4	
		elseif 	characterPosition < ( charactersPerRow * 4 ) then
			positionLeft = -6 + (characterPosition - charactersPerRow * 3 ) * ( characterWidth ) + (AJM.db.teamListHorizontalSpacing * 3)
			positionTop = (positionTop - characterHeight * 3 )
			parentFrame:SetHeight( AJM.db.teamListTitleHeight + (AJM.db.teamListVerticalSpacing * 3) + GetCharacterHeight() * 4 )
		-- Row 5
		elseif 	characterPosition < ( charactersPerRow * 5 ) then
			positionLeft = -6 + (characterPosition - charactersPerRow * 4 ) * ( characterWidth ) + (AJM.db.teamListHorizontalSpacing * 3)
			positionTop = (positionTop - characterHeight * 4 )
			parentFrame:SetHeight( AJM.db.teamListTitleHeight + (AJM.db.teamListVerticalSpacing * 3) + GetCharacterHeight() * 5)
		-- Row 6
		elseif 	characterPosition < ( charactersPerRow * 6 ) then
			positionLeft = -6 + (characterPosition - charactersPerRow * 5 ) * ( characterWidth ) + (AJM.db.teamListHorizontalSpacing * 3)
			positionTop = (positionTop - characterHeight * 5 )
			parentFrame:SetHeight( AJM.db.teamListTitleHeight + (AJM.db.teamListVerticalSpacing * 3) + GetCharacterHeight() * 6 )				
		--Row 7
		elseif 	characterPosition < ( charactersPerRow * 7 ) then
			positionLeft = -6 + (characterPosition - charactersPerRow * 6 ) * ( characterWidth ) + (AJM.db.teamListHorizontalSpacing * 3)
			positionTop = (positionTop - characterHeight * 6 )
			parentFrame:SetHeight( AJM.db.teamListTitleHeight + (AJM.db.teamListVerticalSpacing * 3) + GetCharacterHeight() * 7 )
		--Row 8
		elseif 	characterPosition < ( charactersPerRow * 8 ) then
			positionLeft = -6 + (characterPosition - charactersPerRow * 7 ) * ( characterWidth ) + (AJM.db.teamListHorizontalSpacing * 3)
			positionTop = (positionTop - characterHeight * 7 )
			parentFrame:SetHeight( AJM.db.teamListTitleHeight + (AJM.db.teamListVerticalSpacing * 3) + GetCharacterHeight() * 8 )				
		--Row 9
		elseif 	characterPosition < ( charactersPerRow * 9 ) then
			positionLeft = -6 + (characterPosition - charactersPerRow * 8 ) * ( characterWidth ) + (AJM.db.teamListHorizontalSpacing * 3)
			positionTop = (positionTop - characterHeight * 8 )
			parentFrame:SetHeight( AJM.db.teamListTitleHeight + (AJM.db.teamListVerticalSpacing * 3) + GetCharacterHeight() * 9 )
			--Row 10
		elseif 	characterPosition < ( charactersPerRow * 10 ) then
			positionLeft = -6 + (characterPosition - charactersPerRow * 9 ) * ( characterWidth ) + (AJM.db.teamListHorizontalSpacing * 3)
			positionTop = (positionTop - characterHeight * 9 )
			parentFrame:SetHeight( AJM.db.teamListTitleHeight + (AJM.db.teamListVerticalSpacing * 3) + GetCharacterHeight() * 10 )
		else		
			return
		end	
	--Old code kept for Legacy Purpose
		--positionLeft = -6 + (characterPosition * characterWidth) + (AJM.db.teamListHorizontalSpacing * 3)
	else
		positionLeft = 6
		positionTop = positionTop - (characterPosition * characterHeight)
	end
	-- Display the portrait.
	local portraitButton = characterStatusBar["portraitButton"]
	local portraitButtonClick = characterStatusBar["portraitButtonClick"]
	if AJM.db.showCharacterPortrait == true then
		portraitButton:ClearModel()
		portraitButton:SetUnit( characterName )
		portraitButton:SetPortraitZoom( 1 )
        portraitButton:SetCamDistanceScale( 1 )
        portraitButton:SetPosition( 0, 0, 0 )
        portraitButton:SetWidth( AJM.db.characterPortraitWidth )
		portraitButton:SetHeight( AJM.db.characterPortraitWidth )
		portraitButton:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", positionLeft, positionTop )
		portraitButtonClick:SetWidth( AJM.db.characterPortraitWidth )
		portraitButtonClick:SetHeight( AJM.db.characterPortraitWidth )
		portraitButtonClick:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", positionLeft, positionTop )
		--SetPortraitTexture( portraitButton.Texture, characterName )
		--portraitButton.Texture:SetAllPoints()	
		portraitButton:Show()
		portraitButtonClick:Show()
		positionLeft = positionLeft + AJM.db.characterPortraitWidth + AJM.db.teamListHorizontalSpacing
	else
		portraitButton:Hide()
		portraitButtonClick:Hide()
	end
	-- Display the follow bar.
	local followBar	= characterStatusBar["followBar"]
	local followBarClick = characterStatusBar["followBarClick"]
	if AJM.db.showFollowStatus == true then
		followBar.backgroundTexture:SetAllPoints()
		followBar:SetWidth( AJM.db.followStatusWidth )
		followBar:SetHeight( AJM.db.followStatusHeight )
		followBar:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", positionLeft, positionTop )
		followBarClick:SetWidth( AJM.db.followStatusWidth )
		followBarClick:SetHeight( AJM.db.followStatusHeight )
		followBarClick:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", positionLeft, positionTop )
		followBar:Show()
		followBarClick:Show()
		if AJM.db.barsAreStackedVertically == true then
			positionTop = positionTop - AJM.db.followStatusHeight - AJM.db.barVerticalSpacing
		else
			positionLeft = positionLeft + AJM.db.followStatusWidth + AJM.db.teamListHorizontalSpacing
		end
	else
		followBar:Hide()
		followBarClick:Hide()
	end
	-- Display the experience bar.
	local experienceBar	= characterStatusBar["experienceBar"]
	local experienceBarClick = characterStatusBar["experienceBarClick"]
	local experienceArtBar = characterStatusBar["experienceArtBar"]
	local experienceArtBarClick	= characterStatusBar["experienceArtBarClick"]
	local experienceHonorBar = characterStatusBar["experienceHonorBar"]
	local experienceHonorBarClick = characterStatusBar["experienceHonorBarClick"]
	local reputationBar	= characterStatusBar["reputationBar"]
	local reputationBarClick = characterStatusBar["reputationBarClick"]	
	if AJM.db.showExperienceStatus == true then
		--AJM:Print("TestLevel", characterName, level, maxLevel, xpDisabled, showXP, showArtifact )
		local showBarCount = 0
		if AJM.db.showXpStatus == true then
			showBarCount = showBarCount + 1
			showBeforeBar = parentFrame
			showXP = true
		end
		if AJM.db.showArtifactStatus == true then
			--AJM:Print("ShowArtifact")
			showBarCount = showBarCount + 1
			if AJM.db.showXpStatus == true then
				showArtBeforeBar = experienceBar
				setArtPoint = "BOTTOMLEFT"
				setArtLeft = 0
				setArtTop = -1			
			else
				showArtBeforeBar = parentFrame
				setArtPoint = "TOPLEFT"
				setArtLeft = positionLeft
				setArtTop = positionTop
			end	
		end				
		if AJM.db.showHonorStatus == true then
			--AJM:Print("ShowHonorXP")
			showBarCount = showBarCount + 1
			if AJM.db.showXpStatus == true and AJM.db.showArtifactStatus == false then
				showHonorBeforeBar = experienceBar
				setHonorPoint = "BOTTOMLEFT"
				setHonorLeft = 0
				setHonorTop = -1				
			elseif AJM.db.showArtifactStatus == true then
				showHonorBeforeBar = experienceArtBar
				setHonorPoint = "BOTTOMLEFT"
				setHonorLeft = 0
				setHonorTop = -1				
			else
				showHonorBeforeBar = parentFrame
				setHonorPoint = "TOPLEFT"
				setHonorLeft = positionLeft
				setHonorTop = positionTop
			end	
		end
		if AJM.db.showRepStatus == true then
			--AJM:Print("Show Reputation")
			showBarCount = showBarCount + 1
			if AJM.db.showXpStatus == true and AJM.db.showArtifactStatus == false and AJM.db.showHonorStatus == false then
				--AJM:Print("Show Reputation 1")
				showRepBeforeBar = experienceBar
				setRepPoint = "BOTTOMLEFT"
				setRepLeft = 0
				setRepTop = -1				
			elseif AJM.db.showArtifactStatus == true and AJM.db.showHonorStatus == false then
				--AJM:Print("Show Reputation 2")
				showRepBeforeBar = experienceArtBar
				setRepPoint = "BOTTOMLEFT"
				setRepLeft = 0
				setRepTop = -1				
			elseif AJM.db.showHonorStatus == true then
				--AJM:Print("Show Reputation 3")
				showRepBeforeBar = experienceHonorBar
				setRepPoint = "BOTTOMLEFT"
				setRepLeft = 0
				setRepTop = -1				
			
			else
				--AJM:Print("Show Reputation 4")
				showRepBeforeBar = parentFrame
				setRepPoint = "TOPLEFT"
				setRepLeft = positionLeft
				setRepTop = positionTop
			end		
		end
		if showBarCount < 1 then
			showBarCount = showBarCount + 1
		end	
		--AJM:Print("showBarCountTest", showBarCount)
		--Xp Bar
			experienceBar.backgroundTexture:SetAllPoints()
			experienceBar:SetWidth( AJM.db.experienceStatusWidth )
			experienceBar:SetHeight( AJM.db.experienceStatusHeight / showBarCount )
			experienceBar:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", positionLeft , positionTop )
			experienceBarClick:SetWidth( AJM.db.experienceStatusWidth )
			experienceBarClick:SetHeight( AJM.db.experienceStatusHeight / showBarCount )
			experienceBarClick:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", positionLeft, positionTop )		
		if AJM.db.showXpStatus == true then
			experienceBar:Show()
			experienceBarClick:Show()
		else
			experienceBar:Hide()
			experienceBarClick:Hide()
		end	
		--Artifact Bar
			experienceArtBar.backgroundTexture:SetAllPoints()
			experienceArtBar:SetWidth( AJM.db.experienceStatusWidth )
			experienceArtBar:SetHeight( AJM.db.experienceStatusHeight / showBarCount )
			experienceArtBar:SetPoint( "TOPLEFT", showArtBeforeBar, setArtPoint, setArtLeft , setArtTop )
			experienceArtBarClick:SetPoint( "TOPLEFT", showArtBeforeBar, setArtPoint, setArtLeft , setArtTop )
			experienceArtBarClick:SetWidth( AJM.db.experienceStatusWidth )
			experienceArtBarClick:SetHeight( AJM.db.experienceStatusHeight / showBarCount )		
		if AJM.db.showArtifactStatus == true then	
			experienceArtBar:Show()
			experienceArtBarClick:Show()
		else
			experienceArtBar:Hide()
			experienceArtBarClick:Hide()
		end	
		-- Honor
			experienceHonorBar.backgroundTexture:SetAllPoints()
			experienceHonorBar:SetWidth( AJM.db.experienceStatusWidth )
			experienceHonorBar:SetHeight( AJM.db.experienceStatusHeight / showBarCount )
			experienceHonorBar:SetPoint( "TOPLEFT", showHonorBeforeBar , setHonorPoint, setHonorLeft, setHonorTop )
			experienceHonorBarClick:SetPoint( "TOPLEFT", showHonorBeforeBar , setHonorPoint, setHonorLeft, setHonorTop )			
			experienceHonorBarClick:SetWidth( AJM.db.experienceStatusWidth )
			experienceHonorBarClick:SetHeight( AJM.db.experienceStatusHeight / showBarCount )
		if AJM.db.showHonorStatus == true then	
			experienceHonorBar:Show()
			experienceHonorBarClick:Show()
		else
			experienceHonorBar:Hide()
			experienceHonorBarClick:Hide()
		end
		--rep
			reputationBar.backgroundTexture:SetAllPoints()
			reputationBar:SetWidth( AJM.db.experienceStatusWidth )
			reputationBar:SetHeight( AJM.db.experienceStatusHeight / showBarCount )
			reputationBar:SetPoint( "TOPLEFT", showRepBeforeBar , setRepPoint, setRepLeft, setRepTop )
			reputationBarClick:SetPoint( "TOPLEFT", showRepBeforeBar , setRepPoint, setRepLeft, setRepTop )
			reputationBarClick:SetWidth( AJM.db.experienceStatusWidth )
			reputationBarClick:SetHeight( AJM.db.experienceStatusHeight / showBarCount )
		if AJM.db.showRepStatus == true then
			reputationBar:Show()
			reputationBarClick:Show()
		else
			reputationBar:Hide()
			reputationBarClick:Hide()		
		end	
		
		if AJM.db.barsAreStackedVertically == true then
			positionTop = positionTop - AJM.db.experienceStatusHeight - AJM.db.barVerticalSpacing
		else
			positionLeft = positionLeft + AJM.db.experienceStatusWidth + AJM.db.teamListHorizontalSpacing
		end
	
	else
		experienceBar:Hide()
		experienceBarClick:Hide()
		experienceArtBar:Hide()
		experienceArtBarClick:Hide()
		experienceHonorBar:Hide()
		experienceHonorBarClick:Hide()
	end		
	-- Display the health bar.
	local healthBar	= characterStatusBar["healthBar"]
	local healthIncomingBar = characterStatusBar["healthIncomingBar"]
	local healthBarClick = characterStatusBar["healthBarClick"]
	if AJM.db.showHealthStatus == true then
		healthBar.backgroundTexture:SetAllPoints()
		healthBar:SetWidth( AJM.db.healthStatusWidth )
		healthBar:SetHeight( AJM.db.healthStatusHeight )
		healthBar:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", positionLeft, positionTop )
		healthBarClick:SetWidth( AJM.db.healthStatusWidth )
		healthBarClick:SetHeight( AJM.db.healthStatusHeight )
		healthBarClick:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", positionLeft, positionTop )
		healthBar:Show()
		healthBarClick:Show()
		if AJM.db.barsAreStackedVertically == true then
			positionTop = positionTop - AJM.db.healthStatusHeight - AJM.db.barVerticalSpacing
		else
			positionLeft = positionLeft + AJM.db.healthStatusWidth + AJM.db.teamListHorizontalSpacing
		end
	else
		healthBar:Hide()
		healthBarClick:Hide()
	end
	-- Display the health Incoming bar.
	if AJM.db.showHealthStatus == true then
		healthIncomingBar.backgroundTexture:SetAllPoints()
		healthIncomingBar:SetWidth( AJM.db.healthStatusWidth )
		healthIncomingBar:SetHeight( AJM.db.healthStatusHeight )
		healthIncomingBar:SetPoint( "TOPLEFT", healthBar, "TOPLEFT", 0, 0 )
		healthIncomingBar:Show()
	else
		healthIncomingBar:Hide()
		--healthBarClick:Hide()
	end			
	-- Display the power bar.
	local powerBar = characterStatusBar["powerBar"]
	local powerBarClick = characterStatusBar["powerBarClick"]
	if AJM.db.showPowerStatus == true then
		powerBar.backgroundTexture:SetAllPoints()
		powerBar:SetWidth( AJM.db.powerStatusWidth )
		powerBar:SetHeight( AJM.db.powerStatusHeight )
		powerBar:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", positionLeft, positionTop )
		powerBarClick:SetWidth( AJM.db.powerStatusWidth )
		powerBarClick:SetHeight( AJM.db.powerStatusHeight )
		powerBarClick:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", positionLeft, positionTop )
		powerBar:Show()
		powerBarClick:Show()
		if AJM.db.barsAreStackedVertically == true then
			positionTop = positionTop - AJM.db.powerStatusHeight - AJM.db.barVerticalSpacing
		else
			positionLeft = positionLeft + AJM.db.powerStatusWidth + AJM.db.teamListHorizontalSpacing
		end
	else
		powerBar:Hide()
		powerBarClick:Hide()
	end
	-- Display the Combo Point bar.
	local comboBar = characterStatusBar["comboBar"]
	local comboBarClick = characterStatusBar["comboBarClick"]
	if AJM.db.showComboStatus == true then
		comboBar.backgroundTexture:SetAllPoints()
		comboBar:SetWidth( AJM.db.comboStatusWidth )
		comboBar:SetHeight( AJM.db.comboStatusHeight )
		comboBar:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", positionLeft, positionTop )
		comboBarClick:SetWidth( AJM.db.comboStatusWidth )
		comboBarClick:SetHeight( AJM.db.comboStatusHeight )
		comboBarClick:SetPoint( "TOPLEFT", parentFrame, "TOPLEFT", positionLeft, positionTop )
		comboBar:Show()
		comboBarClick:Show()
		if AJM.db.barsAreStackedVertically == true then
			positionTop = positionTop - AJM.db.comboStatusHeight - AJM.db.barVerticalSpacing
		else
			positionLeft = positionLeft + AJM.db.comboStatusWidth + AJM.db.teamListHorizontalSpacing
		end
	else
		comboBar:Hide()
		comboBarClick:Hide()
	end		
end

-------------------------------------------------------------------------------------------------------------
-- Settings Dialogs.
-------------------------------------------------------------------------------------------------------------

local function SettingsCreateDisplayOptions( top )
	-- Get positions.
	local checkBoxHeight = JambaHelperSettings:GetCheckBoxHeight()
	local labelContinueHeight = JambaHelperSettings:GetContinueLabelHeight()
	local sliderHeight = JambaHelperSettings:GetSliderHeight()
	local mediaHeight = JambaHelperSettings:GetMediaHeight()
	local left = JambaHelperSettings:LeftOfSettings()
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( true )
	local horizontalSpacing = JambaHelperSettings:GetHorizontalSpacing()
	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local sectionSpacing = verticalSpacing * 4
	local halfWidthSlider = (headingWidth - horizontalSpacing) / 2
	local thirdWidth = (headingWidth - (horizontalSpacing * 2)) / 3
	local column2left = left + halfWidthSlider
	local left2 = left + thirdWidth
	local left3 = left + (thirdWidth * 2)
	local movingTop = top
	-- Create show.
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Show"], movingTop, true )
	movingTop = movingTop - headingHeight
	AJM.settingsControl.displayOptionsCheckBoxShowTeamList = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Show Team List"],
		AJM.SettingsToggleShowTeamList,
		L["Show Jamba Team or Unit Frame List"]
	)	
	movingTop = movingTop - checkBoxHeight - verticalSpacing
	AJM.settingsControl.displayOptionsCheckBoxShowTeamListOnlyOnMaster = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Only On Master"],
		AJM.SettingsToggleShowTeamListOnMasterOnly,
		L["Only Show on Master Character"]
	)	
	movingTop = movingTop - checkBoxHeight - verticalSpacing
	AJM.settingsControl.displayOptionsCheckBoxHideTeamListInCombat = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Hide Team List In Combat"],
		AJM.SettingsToggleHideTeamListInCombat,
		L["Olny Show The Team List out of Combat"]
	)
	movingTop = movingTop - checkBoxHeight - verticalSpacing
	AJM.settingsControl.displayOptionsCheckBoxEnableClique = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Enable Clique Support"],
		AJM.SettingsToggleEnableClique,
		L["Enable Clique Support\n\n**reload UI to take effect**"]
	)	
	movingTop = movingTop - checkBoxHeight - verticalSpacing
	AJM.settingsControl.displayOptionsCheckBoxOlnyShowInParty = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Only Show in Party"],
		AJM.SettingsToggleOlnyShowinParty,
		L["Only Show Display-Team\nIn Party or Raid"]
	)
	movingTop = movingTop - checkBoxHeight - verticalSpacing
	AJM.settingsControl.displayOptionsCheckBoxHpManaOutOfParty = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Health & Power Out of Group"],
		AJM.SettingsToggleHpManaOutOfParty,
		L["Update Health and Power out of Groups\nUse Guild Communications!"]
	)
	movingTop = movingTop - checkBoxHeight - verticalSpacing
	-- Create appearance & layout.
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Appearance & Layout"], movingTop, true )
	movingTop = movingTop - headingHeight
	AJM.settingsControl.displayOptionsCheckBoxShowListTitle = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		thirdWidth, 
		left, 
		movingTop, 
		L["Show Title"],
		AJM.SettingsToggleShowTeamListTitle,
		L["Show Team List Title"]
	)	
	movingTop = movingTop - checkBoxHeight - verticalSpacing
	AJM.settingsControl.displayOptionsCheckBoxStackVertically = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Stack Bars Vertically"],
		AJM.SettingsToggleStackVertically,
		L["Stack Bars Vertically"]
	)
	movingTop = movingTop - checkBoxHeight - verticalSpacing

--[[	movingTop = movingTop - sliderHeight - sectionSpacing	
	
	AJM.settingsControl.displayOptionsCheckBoxTeamHorizontal = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Display Team List Horizontally"],
		AJM.SettingsToggleTeamHorizontal,
		L["Display Team List Horizontally"]
	)

	movingTop = movingTop - checkBoxHeight - verticalSpacing
 ]]	

	AJM.settingsControl.displayOptionsCharactersPerBar = JambaHelperSettings:CreateSlider( 
		AJM.settingsControl, 
		halfWidthSlider, 
		left, 
		movingTop, 
		L["Characters Per Bar"]
	)
	AJM.settingsControl.displayOptionsCharactersPerBar:SetSliderValues( 1, 10, 1 )
	AJM.settingsControl.displayOptionsCharactersPerBar:SetCallback( "OnValueChanged", AJM.SettingsChangeCharactersPerBar )

	
	AJM.settingsControl.displayOptionsTeamListScaleSlider = JambaHelperSettings:CreateSlider( 
		AJM.settingsControl, 
		halfWidthSlider, 
		column2left, 
		movingTop, 
		L["Scale"]
	)
	AJM.settingsControl.displayOptionsTeamListScaleSlider:SetSliderValues( 0.5, 2, 0.01 )
	AJM.settingsControl.displayOptionsTeamListScaleSlider:SetCallback( "OnValueChanged", AJM.SettingsChangeScale )
	movingTop = movingTop - sliderHeight - verticalSpacing

	AJM.settingsControl.displayOptionsTeamListTransparencySlider = JambaHelperSettings:CreateSlider( 
		AJM.settingsControl, 
		halfWidthSlider, 
		left, 
		movingTop, 
		L["Transparency"]
	)
	AJM.settingsControl.displayOptionsTeamListTransparencySlider:SetSliderValues( 0, 1, 0.01 )
	AJM.settingsControl.displayOptionsTeamListTransparencySlider:SetCallback( "OnValueChanged", AJM.SettingsChangeTransparency )
	movingTop = movingTop - sliderHeight - verticalSpacing	
	AJM.settingsControl.displayOptionsTeamListMediaStatus = JambaHelperSettings:CreateMediaStatus( 
		AJM.settingsControl, 
		halfWidthSlider, 
		left, 
		movingTop,
		L["Status Bar Texture"]
	)
	AJM.settingsControl.displayOptionsTeamListMediaStatus:SetCallback( "OnValueChanged", AJM.SettingsChangeStatusBarTexture )
	movingTop = movingTop - mediaHeight - verticalSpacing
	AJM.settingsControl.displayOptionsTeamListMediaBorder = JambaHelperSettings:CreateMediaBorder( 
		AJM.settingsControl, 
		halfWidthSlider, 
		left, 
		movingTop,
		L["Border Style"]
	)
	AJM.settingsControl.displayOptionsTeamListMediaBorder:SetCallback( "OnValueChanged", AJM.SettingsChangeBorderStyle )
	AJM.settingsControl.displayOptionsBorderColourPicker = JambaHelperSettings:CreateColourPicker(
		AJM.settingsControl,
		halfWidthSlider,
		column2left + 15,
		movingTop - 15,
		L["Border Colour"]
	)
	AJM.settingsControl.displayOptionsBorderColourPicker:SetHasAlpha( true )
	AJM.settingsControl.displayOptionsBorderColourPicker:SetCallback( "OnValueConfirmed", AJM.SettingsBorderColourPickerChanged )	
	movingTop = movingTop - mediaHeight - verticalSpacing
	AJM.settingsControl.displayOptionsTeamListMediaBackground = JambaHelperSettings:CreateMediaBackground( 
		AJM.settingsControl, 
		halfWidthSlider, 
		left, 
		movingTop,
		L["Background"]
	)
	AJM.settingsControl.displayOptionsTeamListMediaBackground:SetCallback( "OnValueChanged", AJM.SettingsChangeBackgroundStyle )
	AJM.settingsControl.displayOptionsBackgroundColourPicker = JambaHelperSettings:CreateColourPicker(
		AJM.settingsControl,
		halfWidthSlider,
		column2left + 15,
		movingTop - 15,
		L["Background Colour"]
	)
	AJM.settingsControl.displayOptionsBackgroundColourPicker:SetHasAlpha( true )
	AJM.settingsControl.displayOptionsBackgroundColourPicker:SetCallback( "OnValueConfirmed", AJM.SettingsBackgroundColourPickerChanged )
	--Set the font
	movingTop = movingTop - mediaHeight - verticalSpacing
	AJM.settingsControl.displayOptionsTeamListMediaFont = JambaHelperSettings:CreateMediaFont( 
		AJM.settingsControl, 
		halfWidthSlider, 
		left, 
		movingTop,
		L["Font"]
	)
	AJM.settingsControl.displayOptionsTeamListMediaFont:SetCallback( "OnValueChanged", AJM.SettingsChangeFontStyle )
	AJM.settingsControl.displayOptionsSetFontSize = JambaHelperSettings:CreateSlider( 
		AJM.settingsControl, 
		halfWidthSlider, 
		column2left, 
		movingTop, 
		L["Font Size"]
	)
	AJM.settingsControl.displayOptionsSetFontSize:SetSliderValues( 8, 20 , 1 )
	AJM.settingsControl.displayOptionsSetFontSize:SetCallback( "OnValueChanged", AJM.SettingsChangeFontSize )
	movingTop = movingTop - mediaHeight - sectionSpacing	
	-- Create portrait.
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Portrait"], movingTop, true )
	movingTop = movingTop - headingHeight
	AJM.settingsControl.displayOptionsCheckBoxShowPortrait = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Show"],
		AJM.SettingsToggleShowPortrait,
		L["Show the Character Portrait"]
	)	
	movingTop = movingTop - checkBoxHeight - verticalSpacing
	AJM.settingsControl.displayOptionsPortraitWidthSlider = JambaHelperSettings:CreateSlider( 
		AJM.settingsControl, 
		halfWidthSlider, 
		left, 
		movingTop, 
		L["Width"]
	)
	AJM.settingsControl.displayOptionsPortraitWidthSlider:SetSliderValues( 15, 300, 1 )
	AJM.settingsControl.displayOptionsPortraitWidthSlider:SetCallback( "OnValueChanged", AJM.SettingsChangePortraitWidth )
	movingTop = movingTop - sliderHeight - sectionSpacing
	-- Create follow status.
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Follow Status Bar"], movingTop, true )
	movingTop = movingTop - headingHeight
	AJM.settingsControl.displayOptionsCheckBoxShowFollowStatus = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		thirdWidth, 
		left, 
		movingTop, 
		L["Show"],
		AJM.SettingsToggleShowFollowStatus,
		L["Show the Follow Bar and Character Name\n\nHover Over for Character Infomation"]
	)	
	AJM.settingsControl.displayOptionsCheckBoxShowFollowStatusName = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		thirdWidth, 
		left2, 
		movingTop, 
		L["Name"],
		AJM.SettingsToggleShowFollowStatusName,
		L["Show Character Name"]
	)
	AJM.settingsControl.displayOptionsCheckBoxShowToolTipInfo = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		thirdWidth, 
		left3, 
		movingTop, 
		L["Show ToolTip"],
		AJM.SettingsToggleShowToolTipInfo,
		L["Show ToolTip Information"]
	)
--[[
	movingTop = movingTop - checkBoxHeight - verticalSpacing
	AJM.settingsControl.displayOptionsCheckBoxShowEquippedOnly = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		thirdWidth, 
		left, 
		movingTop, 
		L["Equipped iLvl Only"],
		AJM.SettingsToggleShowEquippedOnly,
		L["Olny shows Equipped item Level"]
	)
--]]	
	movingTop = movingTop - checkBoxHeight - verticalSpacing
	AJM.settingsControl.displayOptionsFollowStatusWidthSlider = JambaHelperSettings:CreateSlider( 
		AJM.settingsControl, 
		halfWidthSlider, 
		left, 
		movingTop, 
		L["Width"]
	)
	AJM.settingsControl.displayOptionsFollowStatusWidthSlider:SetSliderValues( 15, 300, 1 )
	AJM.settingsControl.displayOptionsFollowStatusWidthSlider:SetCallback( "OnValueChanged", AJM.SettingsChangeFollowStatusWidth )
	AJM.settingsControl.displayOptionsFollowStatusHeightSlider = JambaHelperSettings:CreateSlider( 
		AJM.settingsControl, 
		halfWidthSlider, 
		column2left, 
		movingTop, 
		L["Height"]
	)
	AJM.settingsControl.displayOptionsFollowStatusHeightSlider:SetSliderValues( 15, 100, 1 )
	AJM.settingsControl.displayOptionsFollowStatusHeightSlider:SetCallback( "OnValueChanged", AJM.SettingsChangeFollowStatusHeight )
	movingTop = movingTop - sliderHeight - sectionSpacing
	-- Create experience status.
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Experience Bars"], movingTop, true )
	movingTop = movingTop - headingHeight
	AJM.settingsControl.displayOptionsCheckBoxShowExperienceStatus = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		thirdWidth, 
		left, 
		movingTop, 
		L["Show"],
		AJM.SettingsToggleShowExperienceStatus,
		L["Show the Team Experience bar\n\nAnd Artifact XP Bar\nAnd Honor XP Bar\nAnd Reputation Bar\n \nHover Over Bar With Mouse and Shift to Show More Infomation."]
	)	
	AJM.settingsControl.displayOptionsCheckBoxShowExperienceStatusValues = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		thirdWidth, 
		left2, 
		movingTop, 
		L["Values"],
		AJM.SettingsToggleShowExperienceStatusValues,
		L["Show Values"]
	)	
	AJM.settingsControl.displayOptionsCheckBoxShowExperienceStatusPercentage = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		thirdWidth, 
		left3, 
		movingTop, 
		L["Percentage"],
		AJM.SettingsToggleShowExperienceStatusPercentage,
		L["Show Percentage"]
	)		
	movingTop = movingTop - checkBoxHeight - verticalSpacing
	AJM.settingsControl.displayOptionsCheckBoxShowXpStatus = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		thirdWidth, 
		left, 
		movingTop, 
		L["ShowXP"],
		AJM.SettingsToggleShowXpStatus,
		L["Show the Team Experience bar"]
	)	
	AJM.settingsControl.displayOptionsCheckBoxShowArtifactStatus = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		thirdWidth, 
		left2, 
		movingTop, 
		L["ShowArtifactXP"],
		AJM.SettingsToggleShowArtifactStatus,
		L["Show the Team Artifact XP bar"]
	)		
	AJM.settingsControl.displayOptionsCheckBoxShowHonorStatus = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		thirdWidth, 
		left3, 
		movingTop, 
		L["ShowHonorXP"],
		AJM.SettingsToggleShowHonorStatus,
		L["Show the Team Honor XP Bar"]
	)
	movingTop = movingTop - checkBoxHeight - verticalSpacing	
	AJM.settingsControl.displayOptionsCheckBoxShowRepStatus = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		thirdWidth, 
		left, 
		movingTop, 
		L["ShowReputation"],
		AJM.SettingsToggleShowRepStatus,
		L["Show the Team Reputation Bar"]
	)	
	movingTop = movingTop - checkBoxHeight - verticalSpacing
	AJM.settingsControl.displayOptionsExperienceStatusWidthSlider = JambaHelperSettings:CreateSlider( 
		AJM.settingsControl, 
		halfWidthSlider, 
		left, 
		movingTop, 
		L["Width"]
	)
	AJM.settingsControl.displayOptionsExperienceStatusWidthSlider:SetSliderValues( 15, 300, 1 )
	AJM.settingsControl.displayOptionsExperienceStatusWidthSlider:SetCallback( "OnValueChanged", AJM.SettingsChangeExperienceStatusWidth )
	AJM.settingsControl.displayOptionsExperienceStatusHeightSlider = JambaHelperSettings:CreateSlider( 
		AJM.settingsControl, 
		halfWidthSlider, 
		column2left, 
		movingTop, 
		L["Height"]
	)
	AJM.settingsControl.displayOptionsExperienceStatusHeightSlider:SetSliderValues( 15, 100, 1 )
	AJM.settingsControl.displayOptionsExperienceStatusHeightSlider:SetCallback( "OnValueChanged", AJM.SettingsChangeExperienceStatusHeight )
	movingTop = movingTop - sliderHeight - sectionSpacing	
	-- Create health status.
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Health Bar"], movingTop, true )
	movingTop = movingTop - headingHeight
	AJM.settingsControl.displayOptionsCheckBoxShowHealthStatus = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		thirdWidth, 
		left, 
		movingTop, 
		L["Show"],
		AJM.SettingsToggleShowHealthStatus,
		L["Show the Teams Health Bars"]
	)	
	AJM.settingsControl.displayOptionsCheckBoxShowHealthStatusValues = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		thirdWidth, 
		left2, 
		movingTop, 
		L["Values"],
		AJM.SettingsToggleShowHealthStatusValues,
		L["Show Values"]
	)	
	AJM.settingsControl.displayOptionsCheckBoxShowHealthStatusPercentage = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		thirdWidth, 
		left3, 
		movingTop, 
		L["Percentage"],
		AJM.SettingsToggleShowHealthStatusPercentage,
		L["Show Percentage"]
	)
	movingTop = movingTop - checkBoxHeight - verticalSpacing		
	AJM.settingsControl.displayOptionsCheckBoxShowClassColors = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		thirdWidth, 
		left, 
		movingTop, 
		L["Show Class Colors"],
		AJM.SettingsToggleShowClassColors,
		L["Show class Coulor on Health Bar"]
	)	
	movingTop = movingTop - checkBoxHeight - verticalSpacing
	AJM.settingsControl.displayOptionsHealthStatusWidthSlider = JambaHelperSettings:CreateSlider( 
		AJM.settingsControl, 
		halfWidthSlider, 
		left, 
		movingTop, 
		L["Width"]
	)
	AJM.settingsControl.displayOptionsHealthStatusWidthSlider:SetSliderValues( 15, 300, 1 )
	AJM.settingsControl.displayOptionsHealthStatusWidthSlider:SetCallback( "OnValueChanged", AJM.SettingsChangeHealthStatusWidth )
	AJM.settingsControl.displayOptionsHealthStatusHeightSlider = JambaHelperSettings:CreateSlider( 
		AJM.settingsControl, 
		halfWidthSlider, 
		column2left, 
		movingTop, 
		L["Height"]
	)
	AJM.settingsControl.displayOptionsHealthStatusHeightSlider:SetSliderValues( 15, 100, 1 )
	AJM.settingsControl.displayOptionsHealthStatusHeightSlider:SetCallback( "OnValueChanged", AJM.SettingsChangeHealthStatusHeight )
	movingTop = movingTop - sliderHeight - sectionSpacing	
	-- Create power status.
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Power Bar"], movingTop, true )
	movingTop = movingTop - headingHeight
	AJM.settingsControl.displayOptionsCheckBoxShowPowerStatus = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		thirdWidth, 
		left, 
		movingTop, 
		L["Show"],
		AJM.SettingsToggleShowPowerStatus,
		L["Show the Team Power Bar\n\nMana, Rage, Etc..."]
	)	
	AJM.settingsControl.displayOptionsCheckBoxShowPowerStatusValues = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		thirdWidth, 
		left2, 
		movingTop, 
		L["Values"],
		AJM.SettingsToggleShowPowerStatusValues,
		L["Show Values"]
	)	
	AJM.settingsControl.displayOptionsCheckBoxShowPowerStatusPercentage = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		thirdWidth, 
		left3, 
		movingTop, 
		L["Percentage"],
		AJM.SettingsToggleShowPowerStatusPercentage,
		L["Show Percentage"]
	)			
	movingTop = movingTop - checkBoxHeight - verticalSpacing
	AJM.settingsControl.displayOptionsPowerStatusWidthSlider = JambaHelperSettings:CreateSlider( 
		AJM.settingsControl, 
		halfWidthSlider, 
		left, 
		movingTop, 
		L["Width"]
	)
	AJM.settingsControl.displayOptionsPowerStatusWidthSlider:SetSliderValues( 15, 300, 1 )
	AJM.settingsControl.displayOptionsPowerStatusWidthSlider:SetCallback( "OnValueChanged", AJM.SettingsChangePowerStatusWidth )
	AJM.settingsControl.displayOptionsPowerStatusHeightSlider = JambaHelperSettings:CreateSlider( 
		AJM.settingsControl, 
		halfWidthSlider, 
		column2left, 
		movingTop, 
		L["Height"]
	)
	AJM.settingsControl.displayOptionsPowerStatusHeightSlider:SetSliderValues( 10, 100, 1 )
	AJM.settingsControl.displayOptionsPowerStatusHeightSlider:SetCallback( "OnValueChanged", AJM.SettingsChangePowerStatusHeight )
	movingTop = movingTop - sliderHeight - sectionSpacing
	-- Create Combo Point status.
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Class Power Bar"], movingTop, true )
	movingTop = movingTop - headingHeight
	AJM.settingsControl.displayOptionsCheckBoxShowComboStatus = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		thirdWidth, 
		left, 
		movingTop, 
		L["Show"],
		AJM.SettingsToggleShowComboStatus,
		L["Show the Teams Class Power Bar\n\nComboPoints\nSoulShards\nHoly Power\nRunes\nArcane Charges\nCHI"]
	)	
	AJM.settingsControl.displayOptionsCheckBoxShowComboStatusValues = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		thirdWidth, 
		left2, 
		movingTop, 
		L["Values"],
		AJM.SettingsToggleShowComboStatusValues,
		L["Show Values"]
	)	
	AJM.settingsControl.displayOptionsCheckBoxShowComboStatusPercentage = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		thirdWidth, 
		left3, 
		movingTop, 
		L["Percentage"],
		AJM.SettingsToggleShowComboStatusPercentage,
		L["Show Percentage"]
	)			
	movingTop = movingTop - checkBoxHeight - verticalSpacing
	AJM.settingsControl.displayOptionsComboStatusWidthSlider = JambaHelperSettings:CreateSlider( 
		AJM.settingsControl, 
		halfWidthSlider, 
		left, 
		movingTop, 
		L["Width"]
	)	
	AJM.settingsControl.displayOptionsComboStatusWidthSlider:SetSliderValues( 15, 300, 1 )
	AJM.settingsControl.displayOptionsComboStatusWidthSlider:SetCallback( "OnValueChanged", AJM.SettingsChangeComboStatusWidth )
	AJM.settingsControl.displayOptionsComboStatusHeightSlider = JambaHelperSettings:CreateSlider( 
		AJM.settingsControl, 
		halfWidthSlider, 
		column2left, 
		movingTop, 
		L["Height"]
	)
	AJM.settingsControl.displayOptionsComboStatusHeightSlider:SetSliderValues( 10, 100, 1 )
	AJM.settingsControl.displayOptionsComboStatusHeightSlider:SetCallback( "OnValueChanged", AJM.SettingsChangeComboStatusHeight )
	movingTop = movingTop - sliderHeight - sectionSpacing
	return movingTop
end

local function SettingsCreate()
	AJM.settingsControl = {}
	-- Create the settings panel.
	JambaHelperSettings:CreateSettings( 
		AJM.settingsControl, 
		AJM.moduleDisplayName, 
		AJM.parentDisplayName, 
		AJM.SettingsPushSettingsClick 
	)
	local bottomOfDisplayOptions = SettingsCreateDisplayOptions( JambaHelperSettings:TopOfSettings() )
	AJM.settingsControl.widgetSettings.content:SetHeight( -bottomOfDisplayOptions )
	-- Help
	local helpTable = {}
	JambaHelperSettings:CreateHelp( AJM.settingsControl, helpTable, AJM:GetConfiguration() )		
end

-------------------------------------------------------------------------------------------------------------
-- Settings Populate.
-------------------------------------------------------------------------------------------------------------

function AJM:BeforeJambaProfileChanged()	
	AJM:RefreshTeamListControlsHide()
end

function AJM:OnJambaProfileChanged()	
	AJM:SettingsRefresh()
end

function AJM:SettingsRefresh()
	AJM.settingsControl.displayOptionsCheckBoxShowTeamList:SetValue( AJM.db.showTeamList )
	AJM.settingsControl.displayOptionsCheckBoxShowTeamListOnlyOnMaster:SetValue( AJM.db.showTeamListOnMasterOnly )
	AJM.settingsControl.displayOptionsCheckBoxHideTeamListInCombat:SetValue( AJM.db.hideTeamListInCombat )
	AJM.settingsControl.displayOptionsCheckBoxEnableClique:SetValue( AJM.db.enableClique )
	AJM.settingsControl.displayOptionsCharactersPerBar:SetValue( AJM.db.charactersPerRow )
	AJM.settingsControl.displayOptionsCheckBoxStackVertically:SetValue( AJM.db.barsAreStackedVertically )
--	AJM.settingsControl.displayOptionsCheckBoxTeamHorizontal:SetValue( AJM.db.teamListHorizontal )
	AJM.settingsControl.displayOptionsCheckBoxShowListTitle:SetValue( AJM.db.showListTitle )
	AJM.settingsControl.displayOptionsCheckBoxOlnyShowInParty:SetValue( AJM.db.olnyShowInParty )
	AJM.settingsControl.displayOptionsCheckBoxHpManaOutOfParty:SetValue ( AJM.db.healthManaOutOfParty )
	AJM.settingsControl.displayOptionsTeamListTransparencySlider:SetValue( AJM.db.frameAlpha )
	AJM.settingsControl.displayOptionsTeamListScaleSlider:SetValue( AJM.db.teamListScale )
	AJM.settingsControl.displayOptionsTeamListMediaStatus:SetValue( AJM.db.statusBarTexture ) 
	AJM.settingsControl.displayOptionsTeamListMediaBorder:SetValue( AJM.db.borderStyle )
	AJM.settingsControl.displayOptionsTeamListMediaBackground:SetValue( AJM.db.backgroundStyle )
	AJM.settingsControl.displayOptionsTeamListMediaFont:SetValue( AJM.db.fontStyle )
	AJM.settingsControl.displayOptionsSetFontSize:SetValue( AJM.db.fontSize )
	
	AJM.settingsControl.displayOptionsCheckBoxShowPortrait:SetValue( AJM.db.showCharacterPortrait )
	AJM.settingsControl.displayOptionsPortraitWidthSlider:SetValue( AJM.db.characterPortraitWidth )
	AJM.settingsControl.displayOptionsCheckBoxShowFollowStatus:SetValue( AJM.db.showFollowStatus )
	AJM.settingsControl.displayOptionsCheckBoxShowFollowStatusName:SetValue( AJM.db.followStatusShowName )
	AJM.settingsControl.displayOptionsCheckBoxShowToolTipInfo:SetValue( AJM.db.showToolTipInfo )	
--	AJM.settingsControl.displayOptionsCheckBoxShowFollowStatusLevel:SetValue( AJM.db.followStatusShowLevel )
	AJM.settingsControl.displayOptionsFollowStatusWidthSlider:SetValue( AJM.db.followStatusWidth )
	AJM.settingsControl.displayOptionsFollowStatusHeightSlider:SetValue( AJM.db.followStatusHeight )
	AJM.settingsControl.displayOptionsCheckBoxShowExperienceStatus:SetValue( AJM.db.showExperienceStatus )
	AJM.settingsControl.displayOptionsCheckBoxShowXpStatus:SetValue( AJM.db.showXpStatus )
	AJM.settingsControl.displayOptionsCheckBoxShowArtifactStatus:SetValue( AJM.db.showArtifactStatus )
	AJM.settingsControl.displayOptionsCheckBoxShowHonorStatus:SetValue( AJM.db.showHonorStatus )
	AJM.settingsControl.displayOptionsCheckBoxShowRepStatus:SetValue( AJM.db.showRepStatus )
	AJM.settingsControl.displayOptionsCheckBoxShowExperienceStatusValues:SetValue( AJM.db.experienceStatusShowValues )
	AJM.settingsControl.displayOptionsCheckBoxShowExperienceStatusPercentage:SetValue( AJM.db.experienceStatusShowPercentage )
	AJM.settingsControl.displayOptionsExperienceStatusWidthSlider:SetValue( AJM.db.experienceStatusWidth )
	AJM.settingsControl.displayOptionsExperienceStatusHeightSlider:SetValue( AJM.db.experienceStatusHeight )
	AJM.settingsControl.displayOptionsCheckBoxShowHealthStatus:SetValue( AJM.db.showHealthStatus )
	AJM.settingsControl.displayOptionsCheckBoxShowClassColors:SetValue( AJM.db.showClassColors )
	AJM.settingsControl.displayOptionsCheckBoxShowHealthStatusValues:SetValue( AJM.db.healthStatusShowValues )
	AJM.settingsControl.displayOptionsCheckBoxShowHealthStatusPercentage:SetValue( AJM.db.healthStatusShowPercentage )	
	AJM.settingsControl.displayOptionsHealthStatusWidthSlider:SetValue( AJM.db.healthStatusWidth )
	AJM.settingsControl.displayOptionsHealthStatusHeightSlider:SetValue( AJM.db.healthStatusHeight )	
	AJM.settingsControl.displayOptionsCheckBoxShowPowerStatus:SetValue( AJM.db.showPowerStatus )
	AJM.settingsControl.displayOptionsCheckBoxShowPowerStatusValues:SetValue( AJM.db.powerStatusShowValues )
	AJM.settingsControl.displayOptionsCheckBoxShowPowerStatusPercentage:SetValue( AJM.db.powerStatusShowPercentage )
	AJM.settingsControl.displayOptionsPowerStatusWidthSlider:SetValue( AJM.db.powerStatusWidth )
	AJM.settingsControl.displayOptionsPowerStatusHeightSlider:SetValue( AJM.db.powerStatusHeight )
	AJM.settingsControl.displayOptionsCheckBoxShowComboStatus:SetValue( AJM.db.showComboStatus )
	AJM.settingsControl.displayOptionsCheckBoxShowComboStatusValues:SetValue( AJM.db.comboStatusShowValues )
	AJM.settingsControl.displayOptionsCheckBoxShowComboStatusPercentage:SetValue( AJM.db.comboStatusShowPercentage )
	AJM.settingsControl.displayOptionsComboStatusWidthSlider:SetValue( AJM.db.comboStatusWidth )
	AJM.settingsControl.displayOptionsComboStatusHeightSlider:SetValue( AJM.db.comboStatusHeight )	
	AJM.settingsControl.displayOptionsBackgroundColourPicker:SetColor( AJM.db.frameBackgroundColourR, AJM.db.frameBackgroundColourG, AJM.db.frameBackgroundColourB, AJM.db.frameBackgroundColourA )
	AJM.settingsControl.displayOptionsBorderColourPicker:SetColor( AJM.db.frameBorderColourR, AJM.db.frameBorderColourG, AJM.db.frameBorderColourB, AJM.db.frameBorderColourA )
--	AJM.settingsControl.displayOptionsCheckBoxShowEquippedOnly:SetValue( AJM.db.ShowEquippedOnly )	
	-- State.
	-- Trying to change state in combat lockdown causes taint. Let's not do that. Eventually it would be nice to have a "proper state driven team display",
	-- but this workaround is enough for now.
	if not InCombatLockdown() then
		AJM.settingsControl.displayOptionsCheckBoxShowTeamListOnlyOnMaster:SetDisabled( not AJM.db.showTeamList )
		AJM.settingsControl.displayOptionsCheckBoxHideTeamListInCombat:SetDisabled( not AJM.db.showTeamList )
		AJM.settingsControl.displayOptionsCheckBoxEnableClique:SetDisabled( not AJM.db.showTeamList )
		AJM.settingsControl.displayOptionsCharactersPerBar:SetDisabled(not AJM.db.showTeamList )
		AJM.settingsControl.displayOptionsCheckBoxStackVertically:SetDisabled( not AJM.db.showTeamList )
		--AJM.settingsControl.displayOptionsCheckBoxTeamHorizontal:SetDisabled( not AJM.db.showTeamList )
		AJM.settingsControl.displayOptionsCheckBoxShowListTitle:SetDisabled( not AJM.db.showTeamList )
		AJM.settingsControl.displayOptionsCheckBoxOlnyShowInParty:SetDisabled( not AJM.db.showTeamList )
		AJM.settingsControl.displayOptionsCheckBoxHpManaOutOfParty:SetDisabled( not AJM.db.showTeamList)
		AJM.settingsControl.displayOptionsTeamListScaleSlider:SetDisabled( not AJM.db.showTeamList )
		AJM.settingsControl.displayOptionsTeamListTransparencySlider:SetDisabled( not AJM.db.showTeamList )
		AJM.settingsControl.displayOptionsTeamListMediaStatus:SetDisabled( not AJM.db.showTeamList )
		AJM.settingsControl.displayOptionsTeamListMediaBorder:SetDisabled( not AJM.db.showTeamList )
		AJM.settingsControl.displayOptionsTeamListMediaBackground:SetDisabled( not AJM.db.showTeamList )
		AJM.settingsControl.displayOptionsTeamListMediaFont:SetDisabled( not AJM.db.showTeamList )
		AJM.settingsControl.displayOptionsSetFontSize:SetDisabled( not AJM.db.showTeamList )
		
		
		AJM.settingsControl.displayOptionsCheckBoxShowPortrait:SetDisabled( not AJM.db.showTeamList )
		AJM.settingsControl.displayOptionsPortraitWidthSlider:SetDisabled( not AJM.db.showTeamList or not AJM.db.showCharacterPortrait )
		AJM.settingsControl.displayOptionsCheckBoxShowFollowStatus:SetDisabled( not AJM.db.showTeamList)
		AJM.settingsControl.displayOptionsCheckBoxShowFollowStatusName:SetDisabled( not AJM.db.showTeamList or not AJM.db.showFollowStatus )
--		AJM.settingsControl.displayOptionsCheckBoxShowFollowStatusLevel:SetDisabled( not AJM.db.showTeamList or not AJM.db.showFollowStatus )
		AJM.settingsControl.displayOptionsFollowStatusWidthSlider:SetDisabled( not AJM.db.showTeamList or not AJM.db.showFollowStatus )
		AJM.settingsControl.displayOptionsFollowStatusHeightSlider:SetDisabled( not AJM.db.showTeamList or not AJM.db.showFollowStatus)
		AJM.settingsControl.displayOptionsCheckBoxShowExperienceStatus:SetDisabled( not AJM.db.showTeamList )
		AJM.settingsControl.displayOptionsCheckBoxShowXpStatus:SetDisabled( not AJM.db.showTeamList or not AJM.db.showExperienceStatus)
		AJM.settingsControl.displayOptionsCheckBoxShowArtifactStatus:SetDisabled( not AJM.db.showTeamList or not AJM.db.showExperienceStatus)
		AJM.settingsControl.displayOptionsCheckBoxShowHonorStatus:SetDisabled( not AJM.db.showTeamList or not AJM.db.showExperienceStatus)
		AJM.settingsControl.displayOptionsCheckBoxShowRepStatus:SetDisabled( not AJM.db.showTeamList or not AJM.db.showExperienceStatus )
		AJM.settingsControl.displayOptionsCheckBoxShowExperienceStatusValues:SetDisabled( not AJM.db.showTeamList or not AJM.db.showExperienceStatus )
		AJM.settingsControl.displayOptionsCheckBoxShowExperienceStatusPercentage:SetDisabled( not AJM.db.showTeamList or not AJM.db.showExperienceStatus )
		AJM.settingsControl.displayOptionsExperienceStatusWidthSlider:SetDisabled( not AJM.db.showTeamList or not AJM.db.showExperienceStatus)
		AJM.settingsControl.displayOptionsExperienceStatusHeightSlider:SetDisabled( not AJM.db.showTeamList or not AJM.db.showExperienceStatus )
		AJM.settingsControl.displayOptionsCheckBoxShowHealthStatus:SetDisabled( not AJM.db.showTeamList )
		AJM.settingsControl.displayOptionsCheckBoxShowClassColors:SetDisabled( not AJM.db.showTeamList or not AJM.db.showHealthStatus )
		AJM.settingsControl.displayOptionsCheckBoxShowHealthStatusValues:SetDisabled( not AJM.db.showTeamList or not AJM.db.showHealthStatus )
		AJM.settingsControl.displayOptionsCheckBoxShowHealthStatusPercentage:SetDisabled( not AJM.db.showTeamList or not AJM.db.showHealthStatus )
		AJM.settingsControl.displayOptionsHealthStatusWidthSlider:SetDisabled( not AJM.db.showTeamList or not AJM.db.showHealthStatus )
		AJM.settingsControl.displayOptionsHealthStatusHeightSlider:SetDisabled( not AJM.db.showTeamList or not AJM.db.showHealthStatus )
		AJM.settingsControl.displayOptionsCheckBoxShowPowerStatus:SetDisabled( not AJM.db.showTeamList )
		AJM.settingsControl.displayOptionsCheckBoxShowPowerStatusValues:SetDisabled( not AJM.db.showTeamList or not AJM.db.showPowerStatus )
		AJM.settingsControl.displayOptionsCheckBoxShowPowerStatusPercentage:SetDisabled( not AJM.db.showTeamList or not AJM.db.showPowerStatus )
		AJM.settingsControl.displayOptionsPowerStatusWidthSlider:SetDisabled( not AJM.db.showTeamList or not AJM.db.showPowerStatus )
		AJM.settingsControl.displayOptionsPowerStatusHeightSlider:SetDisabled( not AJM.db.showTeamList or not AJM.db.showPowerStatus )
		AJM.settingsControl.displayOptionsCheckBoxShowComboStatus:SetDisabled( not AJM.db.showTeamList )
		AJM.settingsControl.displayOptionsCheckBoxShowComboStatusValues:SetDisabled( not AJM.db.showTeamList or not AJM.db.showComboStatus )
		AJM.settingsControl.displayOptionsCheckBoxShowComboStatusPercentage:SetDisabled( not AJM.db.showTeamList or not AJM.db.showComboStatus)
		AJM.settingsControl.displayOptionsComboStatusWidthSlider:SetDisabled( not AJM.db.showTeamList or not AJM.db.showComboStatus)
		AJM.settingsControl.displayOptionsComboStatusHeightSlider:SetDisabled( not AJM.db.showTeamList or not AJM.db.showComboStatus)
		AJM.settingsControl.displayOptionsBackgroundColourPicker:SetDisabled( not AJM.db.showTeamList )
		AJM.settingsControl.displayOptionsBorderColourPicker:SetDisabled( not AJM.db.showTeamList )
		AJM.settingsControl.displayOptionsCheckBoxShowToolTipInfo:SetDisabled( not AJM.db.showTeamList or not AJM.db.showFollowStatus )
--		AJM.settingsControl.displayOptionsCheckBoxShowEquippedOnly:SetDisabled( not AJM.db.showTeamList or not AJM.db.showFollowStatus )
		if AJM.teamListCreated == true then
			AJM:RefreshTeamListControls()
			AJM:SettingsUpdateBorderStyle()
			AJM:SettingsUpdateStatusBarTexture()
			AJM:SettingsUpdateFontStyle()
			AJM:SetTeamListVisibility()	
			AJM:SettingsUpdateFollowTextAll()
			AJM:SettingsUpdateExperienceAll()
			AJM:SettingsUpdateReputationAll()
			AJM:SettingsUpdateHealthAll()
			AJM:SettingsUpdatePowerAll()
			AJM:SettingsUpdateComboAll()
		end
	else
		AJM.updateSettingsAfterCombat = true
	end
end

-- Settings received.
function AJM:JambaOnSettingsReceived( characterName, settings )	
	if characterName ~= AJM.characterName then
		-- Update the settings.
		AJM.db.showTeamList = settings.showTeamList
		AJM.db.showTeamListOnMasterOnly = settings.showTeamListOnMasterOnly
		AJM.db.hideTeamListInCombat = settings.hideTeamListInCombat
		AJM.db.enableClique = settings.enableClique
		AJM.db.charactersPerRow = settings.charactersPerRow
		AJM.db.barsAreStackedVertically = settings.barsAreStackedVertically
		AJM.db.teamListHorizontal = settings.teamListHorizontal
		AJM.db.showListTitle = settings.showListTitle
		AJM.db.olnyShowInParty = settings.olnyShowInParty
		AJM.db.healthManaOutOfParty = settings.healthManaOutOfParty
		AJM.db.teamListScale = settings.teamListScale
		AJM.db.statusBarTexture = settings.statusBarTexture
		AJM.db.borderStyle = settings.borderStyle
		AJM.db.backgroundStyle = settings.backgroundStyle
		AJM.db.fontStyle = settings.fontStyle
		AJM.db.fontSize = settings.fontSize
		AJM.db.showCharacterPortrait = settings.showCharacterPortrait
		AJM.db.characterPortraitWidth = settings.characterPortraitWidth
		AJM.db.showFollowStatus = settings.showFollowStatus
		AJM.db.followStatusWidth = settings.followStatusWidth
		AJM.db.followStatusHeight = settings.followStatusHeight
		AJM.db.followStatusShowName = settings.followStatusShowName
		AJM.db.showToolTipInfo = settings.showToolTipInfo	
		AJM.db.showExperienceStatus = settings.showExperienceStatus
		AJM.db.showXpStatus = settings.showXpStatus
		AJM.db.showArtifactStatus = settings.showArtifactStatus
		AJM.db.showHonorStatus = settings.showHonorStatus
		AJM.db.showRepStatus = settings.showRepStatus
		AJM.db.experienceStatusWidth = settings.experienceStatusWidth
		AJM.db.experienceStatusHeight = settings.experienceStatusHeight
		AJM.db.experienceStatusShowValues = settings.experienceStatusShowValues
		AJM.db.experienceStatusShowPercentage = settings.experienceStatusShowPercentage
		AJM.db.showHealthStatus = settings.showHealthStatus
		AJM.db.showClassColors = settings.showClassColors
		AJM.db.healthStatusWidth = settings.healthStatusWidth
		AJM.db.healthStatusHeight = settings.healthStatusHeight
		AJM.db.healthStatusShowValues = settings.healthStatusShowValues
		AJM.db.healthStatusShowPercentage = settings.healthStatusShowPercentage
		AJM.db.showPowerStatus = settings.showPowerStatus
		AJM.db.powerStatusWidth = settings.powerStatusWidth
		AJM.db.powerStatusHeight = settings.powerStatusHeight		
		AJM.db.powerStatusShowValues = settings.powerStatusShowValues
		AJM.db.powerStatusShowPercentage = settings.powerStatusShowPercentage
		AJM.db.showComboStatus = settings.showComboStatus
		AJM.db.comboStatusWidth = settings.comboStatusWidth
		AJM.db.comboStatusHeight = settings.comboStatusHeight		
		AJM.db.comboStatusShowValues = settings.comboStatusShowValues
		AJM.db.comboStatusShowPercentage = settings.comboStatusShowPercentage
--		AJM.db.ShowEquippedOnly = settings.ShowEquippedOnly	
		AJM.db.frameAlpha = settings.frameAlpha
		AJM.db.framePoint = settings.framePoint
		AJM.db.frameRelativePoint = settings.frameRelativePoint
		AJM.db.frameXOffset = settings.frameXOffset
		AJM.db.frameYOffset = settings.frameYOffset
		AJM.db.frameBackgroundColourR = settings.frameBackgroundColourR
		AJM.db.frameBackgroundColourG = settings.frameBackgroundColourG
		AJM.db.frameBackgroundColourB = settings.frameBackgroundColourB
		AJM.db.frameBackgroundColourA = settings.frameBackgroundColourA
		AJM.db.frameBorderColourR = settings.frameBorderColourR
		AJM.db.frameBorderColourG = settings.frameBorderColourG
		AJM.db.frameBorderColourB = settings.frameBorderColourB
		AJM.db.frameBorderColourA = settings.frameBorderColourA		
		-- Refresh the settings.
		AJM:SettingsRefresh()
		-- Tell the player.
		AJM:Print( L["Settings received from A."]( characterName ) )
		-- Tell the team?
		--AJM:JambaSendMessageToTeam( AJM.db.messageArea,  L["Settings received from A."]( characterName ), false )
	end
end

-------------------------------------------------------------------------------------------------------------
-- Settings Callbacks.
-------------------------------------------------------------------------------------------------------------

function AJM:SettingsPushSettingsClick( event )
	AJM:JambaSendSettings()
end

function AJM:SettingsToggleShowTeamList( event, checked )
	AJM.db.showTeamList = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleShowTeamListOnMasterOnly( event, checked )
	AJM.db.showTeamListOnMasterOnly = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleHideTeamListInCombat( event, checked )
	AJM.db.hideTeamListInCombat = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleEnableClique( event, checked )
	AJM.db.enableClique = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeCharactersPerBar( event, value )
	AJM.db.charactersPerRow = tonumber( value )
	AJM:SettingsRefresh()
end


function AJM:SettingsToggleStackVertically( event, checked )
	AJM.db.barsAreStackedVertically = checked;
	AJM.db.teamListHorizontal = checked;
	AJM:SettingsRefresh();
end
--[[
function AJM:SettingsToggleTeamHorizontal( event, checked )
	AJM.db.teamListHorizontal = checked
	AJM:SettingsRefresh()
end
]]

function AJM:SettingsToggleShowTeamListTitle( event, checked )
	AJM.db.showListTitle = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleOlnyShowinParty( event, checked )
	AJM.db.olnyShowInParty = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleHpManaOutOfParty( event, checked )
	AJM.db.healthManaOutOfParty = checked
	AJM:SettingsRefresh()
end


function AJM:SettingsChangeScale( event, value )
	AJM.db.teamListScale = tonumber( value )
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeTransparency( event, value )
	AJM.db.frameAlpha = tonumber( value )
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeStatusBarTexture( event, value )
	AJM.db.statusBarTexture = value
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeBorderStyle( event, value )
	AJM.db.borderStyle = value
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeBackgroundStyle( event, value )
	AJM.db.backgroundStyle = value
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeFontStyle( event, value )
	AJM.db.fontStyle = value
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeFontSize( event, value )
	AJM.db.fontSize = value
	AJM:SettingsRefresh()
end


function AJM:SettingsToggleShowPortrait( event, checked )
	AJM.db.showCharacterPortrait = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsChangePortraitWidth( event, value )
	AJM.db.characterPortraitWidth = tonumber( value )
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleShowFollowStatus( event, checked )
	AJM.db.showFollowStatus = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleShowFollowStatusName( event, checked )
	AJM.db.followStatusShowName = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleShowToolTipInfo( event, checked )
	AJM.db.showToolTipInfo = checked
	AJM:SettingsRefresh()
end

--[[
function AJM:SettingsToggleShowFollowStatusLevel( event, checked )
	AJM.db.followStatusShowLevel = checked
	AJM:SettingsRefresh()
end]]

function AJM:SettingsChangeFollowStatusWidth( event, value )
	AJM.db.followStatusWidth = tonumber( value )
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeFollowStatusHeight( event, value )
	AJM.db.followStatusHeight = tonumber( value )
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleShowExperienceStatus( event, checked )
	AJM.db.showExperienceStatus = checked
	AJM:SettingsRefresh()
end
--

function AJM:SettingsToggleShowXpStatus( event, checked )
	AJM.db.showXpStatus = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleShowArtifactStatus( event, checked )
	AJM.db.showArtifactStatus = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleShowHonorStatus( event, checked )
	AJM.db.showHonorStatus = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleShowRepStatus( event, checked )
	AJM.db.showRepStatus = checked
	AJM:SettingsRefresh()
end
--

function AJM:SettingsToggleShowExperienceStatusValues( event, checked )
	AJM.db.experienceStatusShowValues = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleShowExperienceStatusPercentage( event, checked )
	AJM.db.experienceStatusShowPercentage = checked
	AJM.SettingsRefresh()
end

function AJM:SettingsChangeExperienceStatusWidth( event, value )
	AJM.db.experienceStatusWidth = tonumber( value )
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeExperienceStatusHeight( event, value )
	AJM.db.experienceStatusHeight = tonumber( value )
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleShowHealthStatus( event, checked )
	AJM.db.showHealthStatus = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleShowClassColors( event, checked )
	AJM.db.showClassColors = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleShowHealthStatusValues( event, checked )
	AJM.db.healthStatusShowValues = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleShowHealthStatusPercentage( event, checked )
	AJM.db.healthStatusShowPercentage = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeHealthStatusWidth( event, value )
	AJM.db.healthStatusWidth = tonumber( value )
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeHealthStatusHeight( event, value )
	AJM.db.healthStatusHeight = tonumber( value )
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleShowPowerStatus( event, checked )
	AJM.db.showPowerStatus = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleShowPowerStatusValues( event, checked )
	AJM.db.powerStatusShowValues = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleShowPowerStatusPercentage( event, checked )
	AJM.db.powerStatusShowPercentage = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsChangePowerStatusWidth( event, value )
	AJM.db.powerStatusWidth = tonumber( value )
	AJM:SettingsRefresh()
end

function AJM:SettingsChangePowerStatusHeight( event, value )
	AJM.db.powerStatusHeight = tonumber( value )
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleShowComboStatus( event, checked )
	AJM.db.showComboStatus = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleShowComboStatusValues( event, checked )
	AJM.db.comboStatusShowValues = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleShowComboStatusPercentage( event, checked )
	AJM.db.comboStatusShowPercentage = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeComboStatusWidth( event, value )
	AJM.db.comboStatusWidth = tonumber( value )
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeComboStatusHeight( event, value )
	AJM.db.comboStatusHeight = tonumber( value )
	AJM:SettingsRefresh()
end

function AJM:SettingsBackgroundColourPickerChanged( event, r, g, b, a )
	AJM.db.frameBackgroundColourR = r
	AJM.db.frameBackgroundColourG = g
	AJM.db.frameBackgroundColourB = b
	AJM.db.frameBackgroundColourA = a
	AJM:SettingsRefresh()
end

function AJM:SettingsBorderColourPickerChanged( event, r, g, b, a )
	AJM.db.frameBorderColourR = r
	AJM.db.frameBorderColourG = g
	AJM.db.frameBorderColourB = b
	AJM.db.frameBorderColourA = a
	AJM:SettingsRefresh()
end

--[[
function AJM:SettingsToggleShowEquippedOnly( event, checked )
	AJM.db.ShowEquippedOnly = checked
	AJM:SettingsRefresh()
end ]]


-------------------------------------------------------------------------------------------------------------
-- Commands.
-------------------------------------------------------------------------------------------------------------

-- A Jamba command has been recieved.
function AJM:JambaOnCommandReceived( characterName, commandName, ... )
	AJM:DebugMessage( "JambaOnCommandReceived", characterName )
	--AJM:Print("DebugCommandReceived", characterName, commandName )
	if commandName == AJM.COMMAND_FOLLOW_STATUS_UPDATE then
		AJM:ProcessUpdateFollowStatusMessage( characterName, ... )
	end
	if commandName == AJM.COMMAND_EXPERIENCE_STATUS_UPDATE then
		AJM:ProcessUpdateExperienceStatusMessage( characterName, ... )
	end
	if commandName == AJM.COMMAND_REPUTATION_STATUS_UPDATE then
		AJM:ProcessUpdateReputationStatusMessage( characterName, ... )
	end
	if commandName == AJM.COMMAND_TOONINFORMATION_UPDATE then
		AJM:ProcessUpdateToonInformationMessage ( characterName, ... )
	end
	if commandName == AJM.COMMAND_COMBO_STATUS_UPDATE then
		AJM:ProcessUpdateComboStatusMessage( characterName, ... )
	end	
	if commandName == AJM.COMMAND_COMBAT_STATUS_UPDATE then
		AJM:ProcessUpdateCombatStatusMessage( characterName, ... )
	end
	if commandName == AJM.COMMAND_HEALTH_STATUS_UPDATE then
		AJM:ProcessUpdateHealthStatusMessage( characterName, ... )
	end
	if commandName == AJM.COMMAND_POWER_STATUS_UPDATE then
		AJM:ProcessUpdatePowerStatusMessage(characterName, ... )
	end																		  	
	if commandName == AJM.COMMAND_REQUEST_INFO then
		AJM.SendInfomationUpdateCommand()
	end
end	

-------------------------------------------------------------------------------------------------------------
-- Shared Media Callbacks
-------------------------------------------------------------------------------------------------------------

function AJM:LibSharedMedia_Registered()
end

function AJM:LibSharedMedia_SetGlobal()
end

-------------------------------------------------------------------------------------------------------------
-- Status Bar Updates.
-------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------
-- Range Status Bar Updates.
-------------------------------------------------------------------------------------------------------------

function AJM:RangeUpdateCommand()
	for characterName, characterStatusBar in pairs( AJM.characterStatusBar ) do			
		--AJM:Print("name", characterName )
		local name = Ambiguate( characterName, "none" )
		local range = UnitInRange( name )

	end				
end

-------------------------------------------------------------------------------------------------------------
-- ToolTip Information Updates.
-------------------------------------------------------------------------------------------------------------

function AJM:JambaRequestUpdate()		
	AJM:JambaSendCommandToTeam( AJM.COMMAND_REQUEST_INFO )
end

function AJM:SendInfomationUpdateCommand()
		-- Item Level	
		local _, iLevel = GetAverageItemLevel()
		-- characterLevel
		local characterLevel = UnitLevel("player")
		--Max Level
		local characterMaxLevel = GetMaxPlayerLevel()
		-- gold
		local gold = GetMoney()
		-- Bag information
		local slotsFree, totalSlots = LibBagUtils:CountSlots( "BAGS", 0 )
		-- durability
		local curTotal, maxTotal, broken = 0, 0, 0
		for i = 1, 18 do
			local curItemDurability, maxItemDurability = GetInventoryItemDurability(i)
			if curItemDurability and maxItemDurability then
				curTotal = curTotal + curItemDurability
				maxTotal = maxTotal + maxItemDurability
					if maxItemDurability > 0 and curItemDurability == 0 then
						broken = broken + 1
					end
			end
		end
		if curTotal == 0 then
			curTotal = 1
			maxTotal = 1
		end	
		local durability = curTotal / maxTotal * 100
		--Mail (blizzard minimap code)
		mailText = "nothing"
		if HasNewMail() == true then
			local sender1,sender2,sender3 = GetLatestThreeSenders()
			if( sender1 or sender2 or sender3 ) then
				if( sender1 ) then
					mailText = sender1
				end
				if( sender2 ) then
					mailText = mailText.."\n"..sender2
				end
				if( sender3 ) then
					mailText = mailText.."\n"..sender3
				end
			else
				mailText = L["Unknown Sender"]
			end
		end
		--mailText = text
		--local name, count, icon, currencyID
		currText = "currNothing"
		local name, count, icon, currencyID = GetBackpackCurrencyInfo(1)
			if ( name ) then
				--AJM:Print("test", name, count)
				currText = name.." ".." |T"..icon..":16|t".." "..count
			end
		local name, count, icon, currencyID = GetBackpackCurrencyInfo(2)
			if ( name ) then
				--AJM:Print("test2", name, count)
				currText = currText.."\n"..name.." ".." |T"..icon..":16|t".." "..count
			end
		local name, count, icon, currencyID = GetBackpackCurrencyInfo(3)
			if ( name ) then
				--AJM:Print("test3", name, count)
				currText = currText.."\n"..name.." ".." |T"..icon..":16|t".." "..count
			end
			if AJM.db.showTeamListOnMasterOnly == true then
				AJM:JambaSendCommandToMaster( AJM.COMMAND_TOONINFORMATION_UPDATE, characterLevel, characterMaxLevel, iLevel, gold, durability, slotsFree, totalSlots, currName, currCout, mailText, currText)
			else
				AJM:JambaSendCommandToTeam( AJM.COMMAND_TOONINFORMATION_UPDATE, characterLevel, characterMaxLevel, iLevel, gold, durability, slotsFree, totalSlots, currName, currCout, mailText, currText)
			end
end

function AJM:ProcessUpdateToonInformationMessage( characterName, characterLevel, characterMaxLevel, iLevel, gold, durability, slotsFree, totalSlots, mailText, currText )
	AJM:SettingsUpdateToonInfomation( characterName, characterLevel, characterMaxLevel, iLevel, gold, durability, slotsFree, totalSlots, mailText, currText )
end


function AJM:SettingsUpdateToonInfomationAll()
	for characterName, characterStatusBar in pairs( AJM.characterStatusBar ) do			
		AJM:SettingsUpdateToonInfomation( characterName, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil )
	end
end

function AJM:SettingsUpdateToonInfomation( characterName, characterLevel, characterMaxLevel, iLevel, gold, durability, slotsFree, totalSlots, mailText, currText )
	--AJM:Print("toonInfoUpdate", characterName, characterLevel, characterMaxLevel, iLevel, gold, durability, slotsFree, totalSlots, mailText, currText )
	if CanDisplayTeamList() == false then
		return
	end
	characterName = JambaUtilities:AddRealmToNameIfMissing( characterName )
	local characterStatusBar = AJM.characterStatusBar[characterName]
	if characterStatusBar == nil then
		return
	end
	local followBar = characterStatusBar["followBar"]
	if iLevel == nil then
		iLevel = followBar.ArgIlvl
	end
	if characterLevel == nil then
		characterLevel = followBar.CharacterLevel
	end
	if characterMaxLevel == nil then
		characterMaxLevel = followBar.MaxCharacterLevel
	end	
	if gold == nil then
		gold = followBar.Gold 
	end
	if durability == nil then
		durability = followBar.Durability
	end
	if slotsFree == nil then
		slotsFree = followBar.FreeBagSpace
	end
	if totalSlots == nil then
		totalSlots = followBar.TotalBagSpace
	end
	if mailText == nil then
		mailText = followBar.Mail
	end	
	if currText == nil then
		currText = followBar.CurrText
	end		
	
	followBar.ArgIlvl = iLevel
	followBar.CharacterLevel = characterLevel
	followBar.MaxCharacterLevel = characterMaxLevel
	followBar.Gold = gold
	followBar.Durability = durability
	followBar.FreeBagSpace = slotsFree
	followBar.TotalBagSpace = totalSlots
	followBar.Mail = mailText
	followBar.CurrText = currText
end

-------------------------------------------------------------------------------------------------------------
-- Follow Status Bar Updates.
-------------------------------------------------------------------------------------------------------------
AJM.isFollowing = false
 
function AJM:AUTOFOLLOW_BEGIN( event, name, ... )	
	if AJM.isFollowing == false then
		AJM:ScheduleTimer( "SendFollowStatusUpdateCommand", 1 , true)
		AJM.isFollowing = true
	end
end

function AJM:AUTOFOLLOW_END( event, ... )	
	AJM:ScheduleTimer( "SendFollowStatusUpdateCommand", 1 , false )	
end


function AJM:SendFollowStatusUpdateCommand( isFollowing )
	if AJM.db.showTeamList == true and AJM.db.showFollowStatus == true then	
		local canSend = false
		local alpha = AutoFollowStatus:GetAlpha()
		--AJM:Print("testA", alpha)
		if alpha < 1 then
			canSend = true
			AJM.isFollowing = false
		end
		if isFollowing == true then
			canSend = true	
		end	
		-- Check to see if JambaFollow is enabled and follow strobing is on.  If this is the case then
		-- do not send the follow update.
		if JambaApi.Follow ~= nil then
			if JambaApi.Follow.IsFollowingStrobing() == true then
				canSend = false
			end
		end	
		--AJM:Print("canSend", canSend )
		if canSend == true then
			if AJM.db.showTeamListOnMasterOnly == true then
				AJM:JambaSendCommandToMaster( AJM.COMMAND_FOLLOW_STATUS_UPDATE, isFollowing )
			else
				AJM:JambaSendCommandToTeam( AJM.COMMAND_FOLLOW_STATUS_UPDATE, isFollowing )
			end
		end
	end
end


function AJM:ProcessUpdateFollowStatusMessage( characterName, isFollowing )
	AJM:UpdateFollowStatus( characterName, isFollowing )
end

function AJM:UpdateFollowStatus( characterName, isFollowing )
	--AJM:Print("follow", characterName, "follow", isFollowing)
	if CanDisplayTeamList() == false then
		return
	end
	if AJM.db.showFollowStatus == false then
		return
	end
	characterName = JambaUtilities:AddRealmToNameIfMissing( characterName )
	local characterStatusBar = AJM.characterStatusBar[characterName]
	if characterStatusBar == nil then
		return
	end
	local followBar = characterStatusBar["followBar"]
	if isFollowing == true then
		-- Following.
		followBar:SetStatusBarColor( 0.05, 0.85, 0.05, 1.00 )
		LibButtonGlow.HideOverlayGlow(followBar)
	else
		if isFollowLeader == true then
			-- Follow leader.
			followBar:SetStatusBarColor( 0.55, 0.15, 0.15, 0.25 )
			LibButtonGlow.HideOverlayGlow(followBar)
		else
			-- Not following.
		LibButtonGlow.ShowOverlayGlow(followBar)
		followBar:SetStatusBarColor( 0.85, 0.05, 0.05, 1.00 )
		AJM:ScheduleTimer("EndGlowFollowBar", 2 , followBar)
		end
	end
end

function AJM:EndGlowFollowBar(frame)
	LibButtonGlow.HideOverlayGlow(frame)
end

-- TEXT and Combat updates

function AJM:SendCombatStatusUpdateCommand()
	local inCombat = UnitAffectingCombat("player")
	--AJM:Print("canSend", inCombat)
	if AJM.db.showTeamListOnMasterOnly == true then
		AJM:JambaSendCommandToMaster( AJM.COMMAND_COMBAT_STATUS_UPDATE, inCombat )
	else
		AJM:JambaSendCommandToTeam( AJM.COMMAND_COMBAT_STATUS_UPDATE, inCombat )
	end
end

function AJM:SettingsUpdateFollowTextAll()
	for characterName, characterStatusBar in pairs( AJM.characterStatusBar ) do			
		AJM:SettingsUpdateFollowText( characterName, nil )
	end
end


function AJM:ProcessUpdateCombatStatusMessage( characterName, inCombat )
--	AJM:Print("test", characterName, inCombat )
	AJM:SettingsUpdateFollowText( characterName, inCombat )
end


function AJM:SettingsUpdateFollowText( characterName, inCombat )
	--AJM:Print("FollowTextInfo", characterName, inCombat) -- debug
	if CanDisplayTeamList() == false then
		return
	end
	if AJM.db.showFollowStatus == false then
		return
	end
	characterName = JambaUtilities:AddRealmToNameIfMissing( characterName )
	local characterStatusBar = AJM.characterStatusBar[characterName]
	if characterStatusBar == nil then
		return
	end
	local followBarText = characterStatusBar["followBarText"]

--[[	if inCombat == true then 
	--AJM:Print("change stuff here")
		local _, _, icon = GetCurrencyInfo( "1356" )
		local text = followBarText:GetText()
		local iconTextureString = strconcat(" |T"..icon..":14|t")
		followBarText:SetText( iconTextureString.." "..text )
	else
		local text = ""
		text = text..Ambiguate( characterName, "none" )
		followBarText:SetText( text )
	end
]]	
	if inCombat == true then
		followBarText:SetTextColor(1.0, 0.5, 0.25)
	else
		followBarText:SetTextColor( 1.00, 1.00, 1.00, 1.00 )
	end
	
	local text = ""
	if AJM.db.followStatusShowName == true then
		text = text..Ambiguate( characterName, "none" )
	end
	followBarText:SetText( text )
end


-------------------------------------------------------------------------------------------------------------
-- Experience Status Bar Updates.
-------------------------------------------------------------------------------------------------------------

function AJM:PLAYER_XP_UPDATE( event, ... )
	AJM:SendExperienceStatusUpdateCommand()	
end

function AJM:UPDATE_EXHAUSTION( event, ... )
	AJM:SendExperienceStatusUpdateCommand()	
end

function AJM:PLAYER_LEVEL_UP( event, ... )
	AJM:SendExperienceStatusUpdateCommand()	
end

function AJM:HONOR_XP_UPDATE(event, arg1, agr2, ...)
	AJM:SendExperienceStatusUpdateCommand()	
end

function AJM:ARTIFACT_XP_UPDATE(event, ...)
	AJM:SendExperienceStatusUpdateCommand()	
end

function AJM:HONOR_LEVEL_UPDATE(event, arg1, agr2, ...)
	AJM:SendExperienceStatusUpdateCommand()	
end

function AJM:HONOR_PRESTIGE_UPDATE(event, arg1, agr2, ...)
	AJM:SendExperienceStatusUpdateCommand()	
end

function AJM:SendExperienceStatusUpdateCommand()
	if AJM.db.showTeamList == true and AJM.db.showExperienceStatus == true then
		--Player XP
		local playerExperience = UnitXP( "player" )
		local playerMaxExperience = UnitXPMax( "player" )
		local playerMaxLevel = GetMaxPlayerLevel()	
		local playerLevel = UnitLevel("player")
		local exhaustionStateID, exhaustionStateName, exhaustionStateMultiplier = GetRestState()
		--Artifact XP	
		local artifactName = "n/a"
		local artifactXP = 0
		local artifactForNextPoint = 100
		local artifactPointsAvailable = 0
		local artifactPointsSpent = 0
			if ArtifactWatchBar:IsShown() == true then
			--local itemID, altItemID, name, icon, totalXP, pointsSpent, quality, artifactAppearanceID, appearanceModID, itemAppearanceID, altItemAppearanceID, altOnTop = C_ArtifactUI.GetEquippedArtifactInfo()
			--local numPointsAvailableToSpend, xp, xpForNextPoint = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP)
			local artifactItemID, _, name, _, artifactTotalXP, artifactPointsSpent, _, _, _, _, _, _, artifactTier = C_ArtifactUI.GetEquippedArtifactInfo()
			local numPointsAvailableToSpend, xp, xpForNextPoint = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(artifactPointsSpent, artifactTotalXP, artifactTier)
			artifactName = name
			artifactXP = xp
			artifactForNextPoint = xpForNextPoint
			artifactPointsAvailable = numPointsAvailableToSpend
			artifactPointsSpent	= pointsSpent
			end
		local honorXP = UnitHonor("player")
		local prestigeLevel = UnitPrestige("Player")	
		local honorMax = UnitHonorMax("player")
		-- A DityDityHack if capped --Ebony
		if honorMax == 0 then
			honorMax = 10000
		end
		local HonorLevel = UnitHonorLevel("player")		
		local honorExhaustionStateID = GetHonorRestState()		
		if not (honorexhaustionStateID == 1) then
			honorExhaustionStateID = 0
		end	
	--	AJM:Print("testSend", honorXP, honorMax, HonorLevel, honorExhaustionStateID)
		if AJM.db.showTeamListOnMasterOnly == true then
				--AJM:Print("Test", characterName, name, xp, xpForNextPoint, numPointsAvailableToSpend)
				AJM:JambaSendCommandToMaster( AJM.COMMAND_EXPERIENCE_STATUS_UPDATE, playerExperience, playerMaxExperience, exhaustionStateID, playerLevel, artifactName, artifactPointsSpent, artifactXP, artifactForNextPoint, artifactPointsAvailable, honorXP, honorMax, HonorLevel, prestigeLevel, honorExhaustionStateID )			
			else
				AJM:DebugMessage( "SendExperienceStatusUpdateCommand TO TEAM!" )
				--AJM:Print("Test", characterName, name, xp, xpForNextPoint, numPointsAvailableToSpend)
				AJM:JambaSendCommandToTeam( AJM.COMMAND_EXPERIENCE_STATUS_UPDATE, playerExperience, playerMaxExperience, exhaustionStateID, playerLevel, artifactName, artifactXP, artifactPointsSpent, artifactForNextPoint, artifactPointsAvailable, honorXP, honorMax, HonorLevel, prestigeLevel, honorExhaustionStateID)
			end
	end
end

function AJM:ProcessUpdateExperienceStatusMessage( characterName, playerExperience, playerMaxExperience, exhaustionStateID, playerLevel, artifactName, artifactXP, artifactForNextPoint, artifactPointsSpent, artifactPointsAvailable, honorXP, honorMax, HonorLevel, prestigeLevel, honorExhaustionStateID)
	AJM:UpdateExperienceStatus( characterName, playerExperience, playerMaxExperience, exhaustionStateID, playerLevel, artifactName, artifactXP, artifactForNextPoint, artifactPointsSpent, artifactPointsAvailable, honorXP, honorMax, HonorLevel, prestigeLevel, honorExhaustionStateID )
end

function AJM:SettingsUpdateExperienceAll()
	for characterName, characterStatusBar in pairs( AJM.characterStatusBar ) do			
		AJM:UpdateExperienceStatus( characterName, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil )
	end
end

function AJM:UpdateExperienceStatus( characterName, playerExperience, playerMaxExperience, exhaustionStateID, playerLevel, artifactName, artifactXP, artifactPointsSpent, artifactForNextPoint, artifactPointsAvailable, honorXP, honorMax, HonorLevel, prestigeLevel, honorExhaustionStateID )
--AJM:Print( "UpdateExperienceStatus", characterName, playerExperience, playerMaxExperience, exhaustionStateID, playerLevel)
--	AJM:Print("ArtTest", characterName, "name", artifactName, "xp", artifactXP, "Points", artifactForNextPoint, artifactPointsAvailable)
--	AJM:Print("honorTest", characterName, honorXP, honorMax, HonorLevel, prestigeLevel, honorExhaustionStateID)
	if CanDisplayTeamList() == false then
		return
	end
	if AJM.db.showExperienceStatus == false then
		return
	end
	characterName = JambaUtilities:AddRealmToNameIfMissing( characterName )
	local characterStatusBar = AJM.characterStatusBar[characterName]
	if characterStatusBar == nil then
		return
	end
	
	local experienceBarText = characterStatusBar["experienceBarText"]	
	local experienceBar = characterStatusBar["experienceBar"]	
	
	local experienceArtBarText = characterStatusBar["experienceArtBarText"]	
	if characterStatusBar["experienceArtBarText"] == nil then
		return
	end
	local experienceArtBar = characterStatusBar["experienceArtBar"]
	if characterStatusBar["experienceArtBar"] == nil then
		return
	end	
	local experienceHonorBarText = characterStatusBar["experienceHonorBarText"]
	if characterStatusBar["experienceHonorBarText"] == nil then
		return
	end
	local experienceHonorBar = characterStatusBar["experienceHonorBar"]
	if characterStatusBar["experienceHonorBar"] == nil then
		return
	end	
	
	if playerExperience == nil then
		playerExperience = experienceBarText.playerExperience
	end
	if playerMaxExperience == nil then
		playerMaxExperience = experienceBarText.playerMaxExperience
	end
	if exhaustionStateID == nil then
		exhaustionStateID = experienceBarText.exhaustionStateID
	end	
	if playerLevel == nil then
		playerLevel = experienceBarText.playerLevel
	end	
	if artifactName == nil then 
		artifactName = experienceArtBarText.artifactName
	end
	
	if artifactXP == nil then
		artifactXP = experienceArtBarText.artifactXP
	end
	if artifactPointsSpent == nil then
		artifactPointsSpent = experienceArtBarText.artifactPointsSpent
	end	
	if artifactForNextPoint == nil then
		artifactForNextPoint = experienceArtBarText.artifactForNextPoint
	end
	
	if artifactPointsAvailable == nil then
		artifactPointsAvailable = experienceArtBarText.artifactPointsAvailable
	end	
	
	if honorXP == nil then
		honorXP = experienceHonorBarText.honorXP
	end	
	
	if honorMax == nil then
		honorMax = experienceHonorBarText.honorMax
	end
	
	if HonorLevel == nil then
		honorLevel = experienceHonorBarText.honorLevel
	end
	
	if honorExhaustionStateID == nil then
		honorExhaustionStateID = experienceHonorBarText.honorExhaustionStateID
	end
	
	experienceBarText.playerExperience = playerExperience
	experienceBarText.playerMaxExperience = playerMaxExperience
	experienceBarText.exhaustionStateID = exhaustionStateID
	experienceBarText.playerLevel = playerLevel
	experienceArtBarText.artifactName = artifactName
	experienceArtBarText.artifactXP = artifactXP
	experienceArtBarText.artifactPointsSpent = artifactPointsSpent
	experienceArtBarText.artifactForNextPoint = artifactForNextPoint
	experienceArtBarText.artifactPointsAvailable = artifactPointsAvailable
	experienceHonorBarText.honorXP = honorXP
	experienceHonorBarText.honorMax = honorMax
	experienceHonorBarText.honorLevel = honorLevel
	experienceHonorBarText.honorExhaustionStateID = honorExhaustionStateID
	local min, max = math.min(0, playerExperience), playerMaxExperience

	experienceBar:SetAnimatedValues(playerExperience, min, max , playerLevel)

	experienceArtBar:SetAnimatedValues(artifactXP, 0, artifactForNextPoint, artifactPointsAvailable + artifactPointsSpent)

	experienceHonorBar:SetAnimatedValues(honorXP, 0, honorMax, honorLevel)

	
--[[
	if 	UnitInParty(Ambiguate( characterName, "none" ) ) == true then
		if range == false then
			experienceBar:SetAlpha( 0.5 )
		else
			experienceBar:SetAlpha( 1 )
		end
	else
		experienceBar:SetAlpha( 1 )
	end
--]]	
	
	local text = ""
	if AJM.db.experienceStatusShowValues == true then
		text = text..tostring( AbbreviateLargeNumbers(playerExperience) )..L[" / "]..tostring( AbbreviateLargeNumbers(playerMaxExperience) )..L[" "]
	end
	if AJM.db.experienceStatusShowPercentage == true then
		if AJM.db.experienceStatusShowValues == true then
			text = tostring( AbbreviateLargeNumbers(playerExperience) )..L[" "]..L["("]..tostring( floor( (playerExperience/playerMaxExperience)*100) )..L["%"]..L[")"]
		else
			text = tostring( floor( (playerExperience/playerMaxExperience)*100) )..L["%"]
		end
	end
	experienceBarText:SetText( text )
	if exhaustionStateID == 1 then
		experienceBar:SetStatusBarColor( 0.0, 0.39, 0.88, 1.0 )
		experienceBar.backgroundTexture:SetColorTexture( 0.0, 0.39, 0.88, 0.15 )
	else
		experienceBar:SetStatusBarColor( 0.58, 0.0, 0.55, 1.0 )
		experienceBar.backgroundTexture:SetColorTexture( 0.58, 0.0, 0.55, 0.15 )
	end	
	
--ArtText
	local artText = ""
	if AJM.db.showExpInfo == true then
		if artifactPointsAvailable > 0 then
			artText = artText.."+"..artifactPointsAvailable..L[" "]			
		else
			artText = artText..artifactPointsSpent..L[" "]
		end
	end
	--AJM:Print("TextTest", artifactXP, artifactForNextPoint)
	if AJM.db.experienceStatusShowValues == true and AJM.db.experienceStatusShowPercentage == false then
		artText = artText..tostring( AbbreviateLargeNumbers(artifactXP ) )..L[" / "]..tostring( AbbreviateLargeNumbers(artifactForNextPoint) )..L[" "]
	end
	if AJM.db.experienceStatusShowPercentage == true then
		if AJM.db.experienceStatusShowValues == true then
			artText = artText..L["("]..tostring( AbbreviateLargeNumbers(artifactXP ) )..L[" "]..tostring( floor( (artifactXP/artifactForNextPoint)*100) )..L["%"]..L[")"]
		else
			artText = artText..L["("]..tostring( floor( (artifactXP/artifactForNextPoint)*100) )..L["%"]..L[")"]
		end
	end
		--AJM:Print("arttest", artText)
		experienceArtBarText:SetText( artText )		
		experienceArtBar:SetStatusBarColor( 0.901, 0.8, 0.601, 1.0 )
		experienceArtBar.backgroundTexture:SetColorTexture( 0.901, 0.8, 0.601, 0.20 )
		
		
	--HonorText	
	local honorText = ""
	if AJM.db.showExpInfo == true then
		if prestigeLevel > 0 then
			honorText = honorText..prestigeLevel.."-"..honorLevel..L[" "]
		else
			honorText = honorText..honorLevel..L[" "]
		end	
	end
	if AJM.db.experienceStatusShowValues == true then
		honorText = honorText..tostring( AbbreviateLargeNumbers(honorXP) )..L[" / "]..tostring( AbbreviateLargeNumbers(honorMax) )..L[" "]
	end
	if AJM.db.experienceStatusShowPercentage == true then
		if AJM.db.experienceStatusShowValues == true then
			honorText = honorText..tostring( AbbreviateLargeNumbers(honorXP) )..L[" "]..L["("]..tostring( floor( (honorXP/honorMax)*100) )..L["%"]..L[")"]
		else
			honorText = honorText..L["("]..tostring( floor( (honorXP/honorMax)*100) )..L["%"]..L[")"]
		end
	end
	experienceHonorBarText:SetText( honorText )		
	if honorExhaustionStateID == 1 then
		experienceHonorBar:SetStatusBarColor( 1.0, 0.71, 0.0, 1.0 )
		experienceHonorBar.backgroundTexture:SetColorTexture( 1.0, 0.71, 0.0, 0.20 )
	else
		experienceHonorBar:SetStatusBarColor( 1.0, 0.24, 0.0, 1.0 )
		experienceHonorBar.backgroundTexture:SetColorTexture( 1.0, 0.24, 0.0, 0.20 )
	end		
end	




-------------------------------------------------------------------------------------------------------------
-- Reputation Status Bar Updates.
-------------------------------------------------------------------------------------------------------------

function AJM:CHAT_MSG_COMBAT_FACTION_CHANGE( event, ... )
	AJM:SendReputationStatusUpdateCommand()	
end

function AJM:SetWatchedFactionIndex( index )
	AJM:ScheduleTimer( "SendReputationStatusUpdateCommand", 5 )
end

function AJM:SendReputationStatusUpdateCommand()
	if AJM.db.showTeamList == true and AJM.db.showRepStatus == true then
		local reputationName, reputationStandingID, reputationBarMin, reputationBarMax, reputationBarValue = GetWatchedFactionInfo()
		if AJM.db.showTeamListOnMasterOnly == true then
			AJM:JambaSendCommandToMaster( AJM.COMMAND_REPUTATION_STATUS_UPDATE, reputationName, reputationStandingID, reputationBarMin, reputationBarMax, reputationBarValue )
		else
			AJM:JambaSendCommandToTeam( AJM.COMMAND_REPUTATION_STATUS_UPDATE, reputationName, reputationStandingID, reputationBarMin, reputationBarMax, reputationBarValue )
		end
	end
end

function AJM:ProcessUpdateReputationStatusMessage( characterName, reputationName, reputationStandingID, reputationBarMin, reputationBarMax, reputationBarValue)
	AJM:UpdateReputationStatus( characterName, reputationName, reputationStandingID, reputationBarMin, reputationBarMax, reputationBarValue)
end

function AJM:SettingsUpdateReputationAll()
	for characterName, characterStatusBar in pairs( AJM.characterStatusBar ) do			
		AJM:UpdateReputationStatus( characterName, nil, nil, nil, nil, nil, nil )
	end
end

function AJM:UpdateReputationStatus( characterName, reputationName, reputationStandingID, reputationBarMin, reputationBarMax, reputationBarValue)
	if CanDisplayTeamList() == false then
		return
	end
	if AJM.db.showRepStatus == false then
		return
	end
	characterName = JambaUtilities:AddRealmToNameIfMissing( characterName )
	local characterStatusBar = AJM.characterStatusBar[characterName]
	if characterStatusBar == nil then
		return
	end
	local reputationBarText = characterStatusBar["reputationBarText"]	
	local reputationBar = characterStatusBar["reputationBar"]	
	if reputationName == nil then
		reputationName = reputationBarText.reputationName
	end
	if reputationStandingID == nil then
		reputationStandingID = reputationBarText.reputationStandingID
	end
	if reputationBarMin == nil then
		reputationBarMin = reputationBarText.reputationBarMin
	end
	if reputationBarMax == nil then
		reputationBarMax = reputationBarText.reputationBarMax
	end
	if reputationBarValue == nil then
		reputationBarValue = reputationBarText.reputationBarValue
	end
	reputationBarText.reputationName = reputationName
	reputationBarText.reputationStandingID = reputationStandingID
	reputationBarText.reputationBarMin = reputationBarMin
	reputationBarText.reputationBarMax = reputationBarMax
	reputationBarText.reputationBarValue = reputationBarValue

	--reputationBar:SetMinMaxValues( tonumber( reputationBarMin ), tonumber( reputationBarMax ) )
	--reputationBar:SetValue( tonumber( reputationBarValue ) )
	reputationBar:SetAnimatedValues(reputationBarValue, reputationBarMin, reputationBarMax, 0 )

   if reputationName == 0 then
        reputationBarMin = 0
        reputationBarMax = 100
        reputationBarValue = 100
        reputationStandingID = 1
    end
--[[
	if 	UnitInParty(Ambiguate( characterName, "none" ) ) == true then
		if range == false then
			reputationBar:SetAlpha( 0.5 )
		else
			reputationBar:SetAlpha( 1 )
		end
	else
		reputationBar:SetAlpha( 1 )
	end
--]]	
	local text = ""
	if AJM.db.experienceStatusShowValues == true then
		text = text..tostring( AbbreviateLargeNumbers(reputationBarValue-reputationBarMin) )..L[" / "]..tostring( AbbreviateLargeNumbers(reputationBarMax-reputationBarMin) )..L[" "]
	end
	if AJM.db.experienceStatusShowPercentage == true then
		local textPercentage = tostring( floor( (reputationBarValue-reputationBarMin)/(reputationBarMax-reputationBarMin)*100 ) )..L["%"]
		if AJM.db.experienceStatusShowValues == true then
			text = tostring( AbbreviateLargeNumbers(reputationBarValue-reputationBarMin) )..L[" "]..L["("]..textPercentage..L[")"]
		else
			text = text..textPercentage
		end
	end
	reputationBarText:SetText( text )
	local barColor = _G.FACTION_BAR_COLORS[reputationStandingID]
	if barColor ~= nil then
		reputationBar:SetStatusBarColor( barColor.r, barColor.g, barColor.b, 1.0 )
		reputationBar.backgroundTexture:SetColorTexture( barColor.r, barColor.g, barColor.b, 0.15 )
	end
end

-------------------------------------------------------------------------------------------------------------
-- Health Status Bar Updates.
-------------------------------------------------------------------------------------------------------------

function AJM:UNIT_HEALTH( event, unit, ... )
	--AJM:Print("test2", unit)
	AJM:SendHealthStatusUpdateCommand( unit )
end

function AJM:UNIT_MAXHEALTH( event, unit, ... )
	--AJM:Print("sendtest2", unit )
	AJM:SendHealthStatusUpdateCommand( unit )
end

function AJM:UNIT_HEAL_PREDICTION( event, unit, ... )
	--AJM:Print("test2", unit)
	AJM:SendHealthStatusUpdateCommand( unit )
end


function AJM:SendHealthStatusUpdateCommand(unit)
	--AJM:Print("debugHealthUpd", unit )
	if unit == nil then
		return
	end	
	if AJM.db.showTeamList == true and AJM.db.showHealthStatus == true then
		if AJM.db.healthManaOutOfParty == true then
			if unit == "player" then 
				--AJM:Print("itsme", unit)
				local playerHealth = UnitHealth( unit )
				local playerMaxHealth = UnitHealthMax( unit )
				local inComingHeal = UnitGetIncomingHeals( unit )
				local _, class = UnitClass ("player")
				
				if AJM.db.showTeamListOnMasterOnly == true then
					--AJM:Print( "SendHealthStatusUpdateCommand TO Master!" )
					AJM:JambaSendCommandToMaster( AJM.COMMAND_HEALTH_STATUS_UPDATE, playerHealth, playerMaxHealth, inComingHeal, class )
				else
					--AJM:Print( "SendHealthStatusUpdateCommand TO Team!" )
					AJM:JambaSendCommandToTeam( AJM.COMMAND_HEALTH_STATUS_UPDATE, playerHealth, playerMaxHealth, inComingHeal, class )
				end	
			end
		else
			local playerHealth = UnitHealth( unit )
			local playerMaxHealth = UnitHealthMax( unit )
			local inComingHeal = UnitGetIncomingHeals( unit )
			local characterName, characterRealm = UnitName( unit )
			local _, class = UnitClass ( unit )
			local character = JambaUtilities:AddRealmToNameIfNotNil( characterName, characterRealm )
			--AJM:Print("HeathStats", character, playerHealth, playerMaxHealth)
			AJM:UpdateHealthStatus( character, playerHealth, playerMaxHealth, inComingHeal, class)
		end
	end
end

function AJM:ProcessUpdateHealthStatusMessage( characterName, playerHealth, playerMaxHealth, inComingHeal, class )
	AJM:UpdateHealthStatus( characterName, playerHealth, playerMaxHealth, inComingHeal, class)
end

function AJM:SettingsUpdateHealthAll()
	for characterName, characterStatusBar in pairs( AJM.characterStatusBar ) do			
		AJM:UpdateHealthStatus( characterName, nil, nil, nil, nil )
	end
end

function AJM:UpdateHealthStatus( characterName, playerHealth, playerMaxHealth, inComingHeal, class )
	--AJM:Print("testUpdate", characterName, playerHealth, playerMaxHealth, inComingHeal, class ) 
		if characterName == nil then
		return
	end
	if CanDisplayTeamList() == false then
		return
	end
	if AJM.db.showHealthStatus == false then
		return
	end
	characterName = JambaUtilities:AddRealmToNameIfMissing( characterName )
	local characterStatusBar = AJM.characterStatusBar[characterName]
	if characterStatusBar == nil then
		return
	end
	local healthBarText = characterStatusBar["healthBarText"]	
	local healthBar = characterStatusBar["healthBar"]
	local healthIncomingBar = characterStatusBar["healthIncomingBar"]
	
	if playerMaxHealth == 0 then 
		playerMaxHealth = healthBarText.playerMaxHealth
	end
	if playerHealth == nil then
		playerHealth = healthBarText.playerHealth
	end
	if playerMaxHealth == nil then
		playerMaxHealth = healthBarText.playerMaxHealth
	end	
	if inComingHeal == nil then
		inComingHeal = healthBarText.inComingHeal
	end	
--[[
	if 	UnitInParty(Ambiguate( characterName, "none" ) ) == true then
		if range == false then
			healthBar:SetAlpha( 0.5 )
		else
			healthBar:SetAlpha( 1 )
		end
	else
		healthBar:SetAlpha( 1 )
	end
]]	
	healthBarText.playerHealth = playerHealth
	healthBarText.playerMaxHealth = playerMaxHealth
	healthBarText.inComingHeal = inComingHeal
	-- Set statusBar
	healthBar:SetMinMaxValues( 0, tonumber( playerMaxHealth ) )
	healthBar:SetValue( tonumber( playerHealth ) )
	healthIncomingBar:SetMinMaxValues( 0, tonumber( playerMaxHealth ) )
	healthIncomingBar:SetValue( tonumber( playerHealth ) )	
	
	if inComingHeal > 0 then
--	AJM:Print("incomingHeal", inComingHeal)
		healthIncomingBar:SetValue( tonumber( playerHealth + inComingHeal ) )
		healthIncomingBar:SetStatusBarColor( 0, 1, 0, 1 )
	end
	local text = ""
	if UnitIsDeadOrGhost(Ambiguate( characterName, "none" ) ) == true then
		--AJM:Print("dead", characterName)
		text = text..L["DEAD"]
	else
		if AJM.db.healthStatusShowValues == true then
			text = text..tostring( AbbreviateLargeNumbers(playerHealth) )..L[" / "]..tostring( AbbreviateLargeNumbers(playerMaxHealth) )..L[" "]
		end
		if AJM.db.healthStatusShowPercentage == true then
			if AJM.db.healthStatusShowValues == true then
				text = tostring( AbbreviateLargeNumbers(playerHealth) )..L[" "]..L["("]..tostring( floor( (playerHealth/playerMaxHealth)*100) )..L["%"]..L[")"]
			else
				text = tostring( floor( (playerHealth/playerMaxHealth)*100) )..L["%"]
			end
		end
	end
	healthBarText:SetText( text )		
	AJM:SetStatusBarColourForHealth( healthBar, floor((playerHealth/playerMaxHealth)*100), characterName, class)
end

-- TODO Support for classColors
function AJM:SetStatusBarColourForHealth( statusBar, statusValue, characterName, class )
	--AJM:Print("colour class", statusValue, characterName)
	local classColor = RAID_CLASS_COLORS[class]
	if classColor ~= nil and AJM.db.showClassColors == true then
		-- AJM:Print("test", characterName, class, classColor.r, classColor.g, classColor.b )
		local r = classColor.r
		local g = classColor.g
		local b = classColor.b
		statusBar:SetStatusBarColor( r, g, b, 1 )
	else
		local r, g, b = 0, 0, 0
		statusValue = statusValue / 100
		if( statusValue > 0.5 ) then
			r = (1.0 - statusValue) * 2
			g = 1.0
		else
			r = 1.0
			g = statusValue * 2
		end
		b = b
		statusBar:SetStatusBarColor( r, g, b )
	end
end	

-------------------------------------------------------------------------------------------------------------
-- Power Status Bar Updates.
-------------------------------------------------------------------------------------------------------------

function AJM:UNIT_POWER( event, unit, ... )
	AJM:SendPowerStatusUpdateCommand( unit )
end

function AJM:UNIT_DISPLAYPOWER( event, unit, ... )
	AJM:SendPowerStatusUpdateCommand( unit )
end

function AJM:SendPowerStatusUpdateCommand( unit )
	if AJM.db.showTeamList == true and AJM.db.showPowerStatus == true then
		if AJM.db.healthManaOutOfParty == true then
			if unit == "player" then 
				--AJM:Print("itsme", unit)
				local playerPower = UnitPower( unit )
				local playerMaxPower = UnitPowerMax( unit )
				local _, powerToken = UnitPowerType( unit )
				if AJM.db.showTeamListOnMasterOnly == true then
					--AJM:Print( "SendHealthStatusUpdateCommand TO Master!"  )
					AJM:JambaSendCommandToMaster( AJM.COMMAND_POWER_STATUS_UPDATE, playerPower, powerToken )
				else
					--AJM:Print( "SendHealthStatusUpdateCommand TO Team!", playerPower, playerMaxPower, powerToken )
					AJM:JambaSendCommandToTeam( AJM.COMMAND_POWER_STATUS_UPDATE, playerPower, playerMaxPower, powerToken )
				end	
			end
		else
			local playerPower = UnitPower( unit )
			local playerMaxPower = UnitPowerMax( unit )
			local characterName, characterRealm = UnitName( unit )
			local _, powerToken = UnitPowerType( unit )
			local character = JambaUtilities:AddRealmToNameIfNotNil( characterName, characterRealm )
			--AJM:Print("power", character, playerPower, playerMaxPower )
			AJM:UpdatePowerStatus( character, playerPower, playerMaxPower, powerToken)
		end
	end
end

function AJM:ProcessUpdatePowerStatusMessage( characterName, playerPower, playerMaxPower, powerToken )
	AJM:UpdatePowerStatus( characterName, playerPower, playerMaxPower, powerToken )
end		
																					  
function AJM:SettingsUpdatePowerAll()
	for characterName, characterStatusBar in pairs( AJM.characterStatusBar ) do			
		AJM:UpdatePowerStatus( characterName, nil, nil, nil )
	end
end

function AJM:UpdatePowerStatus( characterName, playerPower, playerMaxPower, powerToken)
	--AJM:Print("testPOwer", characterName, playerPower, playerMaxPower, powerToken )
	if characterName == nil then
		return
	end
	if CanDisplayTeamList() == false then
		return
	end
	if AJM.db.showPowerStatus == false then
		return
	end	
	local originalChatacterName = characterName
	characterName = JambaUtilities:AddRealmToNameIfMissing( characterName )
	local characterStatusBar = AJM.characterStatusBar[characterName]
	if characterStatusBar == nil then
		return
	end
	local powerBarText = characterStatusBar["powerBarText"]	
	local powerBar = characterStatusBar["powerBar"]	
	
	if playerMaxPower == 0 then
		playerMaxPower = powerBarText.playerMaxPower
	end
	
	if playerPower == nil then
		playerPower = powerBarText.playerPower
	end
	if playerMaxPower == nil then
		playerMaxPower = powerBarText.playerMaxPower
	end
--[[
	if 	UnitInParty(Ambiguate( characterName, "none" ) ) == true then
		if range == false then
			powerBar:SetAlpha( 0.5 )
		else
			powerBar:SetAlpha( 1 )
		end	
	else
		powerBar:SetAlpha( 1 )
	end]]
	
	powerBarText.playerPower = playerPower
	powerBarText.playerMaxPower = playerMaxPower
	powerBar:SetMinMaxValues( 0, tonumber( playerMaxPower ) )
	powerBar:SetValue( tonumber( playerPower ) )
	local text = ""
	if AJM.db.powerStatusShowValues == true then
		text = text..tostring( AbbreviateLargeNumbers(playerPower) )..L[" / "]..tostring( AbbreviateLargeNumbers(playerMaxPower) )..L[" "]
	end
	if AJM.db.powerStatusShowPercentage == true then
		if AJM.db.powerStatusShowValues == true then
			text = tostring( AbbreviateLargeNumbers(playerPower) )..L[" "]..L["("]..tostring( floor( (playerPower/playerMaxPower)*100) )..L["%"]..L[")"]
		else
			text = tostring( floor( (playerPower/playerMaxPower)*100) )..L["%"]
		end
	end
	powerBarText:SetText( text )		
	AJM:SetStatusBarColourForPower( powerBar, powerToken )--originalChatacterName )
end

function AJM:SetStatusBarColourForPower( statusBar, powerToken )
	local info = PowerBarColor[powerToken]
	if info ~= nil then
	--	AJM:Print("powertest", powerToken, info.r, info.g, info.b )
		statusBar:SetStatusBarColor( info.r, info.g, info.b, 1 )
		statusBar.backgroundTexture:SetColorTexture( info.r, info.g, info.b, 0.25 )
	
	end
	--unit =  Ambiguate( unit, "none" )
--[[	local powerIndex, powerString, altR, altG, altB = UnitPowerType( powerToken )
	if powerString ~= nil and powerString ~= "" then
		local r = PowerBarColor[powerString].r
		local g = PowerBarColor[powerString].g
		local b = PowerBarColor[powerString].b
		statusBar:SetStatusBarColor( r, g, b, 1 )
		statusBar.backgroundTexture:SetColorTexture( r, g, b, 0.25 )
	end ]]
end		

-------------------------------------------------------------------------------------------------------------
-- Combo Points Status Bar Updates.
-------------------------------------------------------------------------------------------------------------

function AJM:UNIT_POWER_FREQUENT( event, Unit, powerType, ... )
	--TODO there got to be a better way to clean this code up Checking to see if its the event we need and then send the command to the update if it is.	
	--AJM:Print("EventTest", Unit, powerType) 
	if Unit == "player" then
		--AJM:Print("player", Unit, powerType)
		if( event and powerType == "COMBO_POINTS" ) then
			AJM:SendComboStatusUpdateCommand()
		elseif( event and powerType == "SOUL_SHARDS" ) then
			AJM:SendComboStatusUpdateCommand()
		elseif( event and powerType == "HOLY_POWER" ) then
			AJM:SendComboStatusUpdateCommand()
		elseif( event and powerType == "ARCANE_CHARGES" ) then
			AJM:SendComboStatusUpdateCommand()	
		elseif( event and powerType == "CHI" ) then
			AJM:SendComboStatusUpdateCommand()
		else
			return
		end
	end	
end

function AJM:RUNE_POWER_UPDATE( event, ...)
	AJM:SendComboStatusUpdateCommand()
end

function AJM:SendComboStatusUpdateCommand()
	--AJM:Print("test")
	if AJM.db.showTeamList == true and AJM.db.showComboStatus == true then
		-- get powerType from http://wowprogramming.com/docs/api_types#powerType as there no real API to get this infomation as of yet.
		local Class = select(2, UnitClass("player"))
		--AJM:Print("class", Class)
		-- Combo Points
		if Class == "DRUID" then
			PowerType = 4
		-- Combo Points
		elseif Class == "ROGUE" then
			PowerType = 4
		-- Warlock's soulshards
		elseif Class == "WARLOCK" then
				PowerType = 7
		-- Paladin Holy Power
		elseif Class == "PALADIN" then
			PowerType = 9
		-- DEATHKNIGHT Runes
		elseif Class == "DEATHKNIGHT" then
			PowerType = 5
		-- Mage ARCANE_CHARGES
		elseif Class == "MAGE" then
			PowerType = 16
		-- Monk Cil
		elseif Class == "MONK" then
			PowerType = 12
		else
			return
		end		
		
		local playerCombo = UnitPower ( "player", PowerType)
		local playerMaxCombo = UnitPowerMax( "player", PowerType)
		
		--Deathkight Dity Hacky Hacky.
		if Class == "DEATHKNIGHT" then
			for i=1, playerMaxCombo do
				local start, duration, runeReady = GetRuneCooldown(i)
					if not runeReady then
						playerCombo = playerCombo - 1
					end	
			end
		end		
		
		
		--AJM:Print ("PowerType", PowerType, playerCombo, playerMaxCombo, class)
		if AJM.db.showTeamListOnMasterOnly == true then
			AJM:DebugMessage( "SendComboStatusUpdateCommand TO Master!" )
			AJM:JambaSendCommandToMaster( AJM.COMMAND_COMBO_STATUS_UPDATE, playerCombo, playerMaxCombo, class )
		else
			AJM:DebugMessage( "SendComboStatusUpdateCommand TO TEAM!" )
			AJM:JambaSendCommandToTeam( AJM.COMMAND_COMBO_STATUS_UPDATE, playerCombo, playerMaxCombo, class )
		end
	end	
end

function AJM:ProcessUpdateComboStatusMessage( characterName, playerCombo, playerMaxCombo, class )
	AJM:UpdateComboStatus( characterName, playerCombo , playerMaxCombo, class)
end

function AJM:SettingsUpdateComboAll()
	for characterName, characterStatusBar in pairs( AJM.characterStatusBar ) do			
		AJM:UpdateComboStatus( characterName, nil, nil, nil )
	end
end

function AJM:UpdateComboStatus( characterName, playerCombo, playerMaxCombo, class )
	if CanDisplayTeamList() == false then
		return
	end
	
	if AJM.db.showComboStatus == false then
		return
	end
	
	local characterStatusBar = AJM.characterStatusBar[characterName]
	if characterStatusBar == nil then
		return
	end
	
	local comboBarText = characterStatusBar["comboBarText"]	
	local comboBar = characterStatusBar["comboBar"]	
	
	if playerCombo == nil then
		playerCombo = comboBarText.playerCombo
	end
	if playerMaxCombo == 0 then
		playerMaxCombo = comboBarText.playerMaxCombo
	end
	if playerMaxCombo == nil then
		playerMaxCombo = comboBarText.playerMaxCombo
	end
	
	comboBarText.playerCombo = playerCombo
	comboBarText.playerMaxCombo = playerMaxCombo
	comboBar:SetMinMaxValues( 0, tonumber( playerMaxCombo ) )
	comboBar:SetValue( tonumber( playerCombo ) )
--[[	
	if 	UnitInParty(Ambiguate( characterName, "none" ) ) == true then
		if range == false then
			comboBar:SetAlpha( 0.5 )
		else
			comboBar:SetAlpha( 1 )
		end
	else
		comboBar:SetAlpha( 1 )
	end	
]]	
	local text = ""
	
	if AJM.db.comboStatusShowValues == true then
		text = text..tostring( AbbreviateLargeNumbers(playerCombo) )..L[" / "]..tostring( AbbreviateLargeNumbers(playerMaxCombo) )..L[" "]
	end
	
	if AJM.db.ComboStatusShowPercentage == true then
		if AJM.db.comboStatusShowValues == true then
			text = text..tostring( AbbreviateLargeNumbers(playerCombo) )..L[" "]..L["("]..tostring( floor( (playerCombo/playerMaxCombo)*100) )..L["%"]..L[")"]
		else
			text = tostring( floor( (playerCombo/playerMaxCombo)*100) )..L["%"]
		end
	end
	comboBarText:SetText( text )
	AJM:SetStatusBarColourForCombo( comboBar, class )	
end


function AJM:SetStatusBarColourForCombo( comboBar, Class )
	if Class == "WARLOCK" then
		-- Purple
		comboBar:SetStatusBarColor( 0.58, 0.51, 0.79, 1 )
		comboBar.backgroundTexture:SetColorTexture( 0.58, 0.51, 0.79, 0.25) 	
	elseif  Class == "PALADIN" then
		--yellow(gold)
		comboBar:SetStatusBarColor( 0.96, 0.55, 0.73, 1 )
		comboBar.backgroundTexture:SetColorTexture( 0.96, 0.55, 0.73, 0.25) 	
	elseif Class =="DEATHKNIGHT" then
		--Sky Blue?
		comboBar:SetStatusBarColor( 0.60, 0.80, 1.0, 1 )
		comboBar.backgroundTexture:SetColorTexture( 0.60, 0.80, 1.0, 0.25)
	elseif Class =="MAGE" then
		--Very Blue ice?
		comboBar:SetStatusBarColor( 0.07, 0.30, 0.92, 1 )
		comboBar.backgroundTexture:SetColorTexture( 0.07, 0.30, 0.92, 0.25)
	elseif Class =="MONK" then
		--Greenish
		comboBar:SetStatusBarColor( 0.44, 0.79, 0.67, 1 )
		comboBar.backgroundTexture:SetColorTexture( 0.44, 0.79, 0.67, 0.25)
	else
		return
	end	
end	

		
-------------------------------------------------------------------------------------------------------------
-- Addon initialization, enabling and disabling.
-------------------------------------------------------------------------------------------------------------

-- Initialise the module.
function AJM:OnInitialize()
	AJM.previousSlotsFree = 0
	AJM.previousTotalSlots = 0
	-- Create the settings control.
	SettingsCreate()
	-- Initialise the JambaModule part of this module.
	AJM:JambaModuleInitialize( AJM.settingsControl.widgetSettings.frame )
	-- Populate the settings.
	AJM:SettingsRefresh()
	-- Create the team list frame.
	CreateJambaTeamListFrame()
	AJM:SetTeamListVisibility()	
end

-- Called when the addon is enabled.
function AJM:OnEnable()
	AJM:RegisterEvent( "PLAYER_REGEN_ENABLED" )
	AJM:RegisterEvent( "PLAYER_REGEN_DISABLED" )
	AJM:RegisterEvent( "AUTOFOLLOW_BEGIN" )
	AJM:RegisterEvent( "AUTOFOLLOW_END" )
	AJM:RegisterEvent( "PLAYER_XP_UPDATE" )
	AJM:RegisterEvent( "UPDATE_EXHAUSTION" )
	AJM:RegisterEvent( "PLAYER_LEVEL_UP" )		
	AJM:RegisterEvent( "UNIT_HEALTH" )
	AJM:RegisterEvent( "UNIT_MAXHEALTH" )
	AJM:RegisterEvent( "UNIT_HEAL_PREDICTION" )
	AJM:RegisterEvent( "UNIT_POWER", "UNIT_POWER" )
	AJM:RegisterEvent( "UNIT_MAXPOWER", "UNIT_POWER" )
	AJM:RegisterEvent( "PLAYER_ENTERING_WORLD" )
	AJM:RegisterEvent( "UNIT_DISPLAYPOWER" )
	AJM:RegisterEvent( "CHAT_MSG_COMBAT_FACTION_CHANGE" )
	AJM:RegisterEvent( "UNIT_POWER_FREQUENT")
	AJM:RegisterEvent( "RUNE_POWER_UPDATE" )
	AJM:RegisterEvent( "PLAYER_TALENT_UPDATE")
	AJM:RegisterEvent( "HONOR_XP_UPDATE" )
	AJM:RegisterEvent( "HONOR_LEVEL_UPDATE" )
	AJM:RegisterEvent( "HONOR_PRESTIGE_UPDATE" )
	AJM:RegisterEvent( "GROUP_ROSTER_UPDATE" )
	AJM:RegisterEvent( "ARTIFACT_XP_UPDATE" )
	AJM.SharedMedia.RegisterCallback( AJM, "LibSharedMedia_Registered" )
    AJM.SharedMedia.RegisterCallback( AJM, "LibSharedMedia_SetGlobal" )	
	AJM:RegisterMessage( JambaApi.MESSAGE_TEAM_CHARACTER_ADDED, "OnCharactersChanged" )
	AJM:RegisterMessage( JambaApi.MESSAGE_TEAM_CHARACTER_REMOVED, "OnCharactersChanged" )	
	AJM:RegisterMessage( JambaApi.MESSAGE_TEAM_ORDER_CHANGED, "OnCharactersChanged" )
	AJM:RegisterMessage( JambaApi.MESSAGE_TEAM_MASTER_CHANGED, "OnMasterChanged" )
	AJM:RegisterMessage( JambaApi.MESSAGE_CHARACTER_ONLINE, "OnCharactersChanged")
	AJM:RegisterMessage( JambaApi.MESSAGE_CHARACTER_OFFLINE, "OnCharactersChanged")
	
	AJM:SecureHook( "SetWatchedFactionIndex" )
	AJM:ScheduleTimer( "RefreshTeamListControls", 3 )
	AJM:ScheduleTimer( "SendExperienceStatusUpdateCommand", 5 )
	AJM:ScheduleTimer( "SendReputationStatusUpdateCommand", 5 )
	AJM:ScheduleTimer( "SendInfomationUpdateCommand", 5 )
	AJM:ScheduleTimer( "SendHealthStatusUpdateCommand", 5, "player" )
	AJM:ScheduleTimer( "SendPowerStatusUpdateCommand", 5, "player" )
	AJM:ScheduleTimer( "SendComboStatusUpdateCommand", 5 )
	--AJM:ScheduleRepeatingTimer("SendExperienceStatusUpdateCommand", 5)
end

-- Called when the addon is disabled.
function AJM:OnDisable()
end

function AJM:PLAYER_ENTERING_WORLD( event, ... )
	--AJM:ScheduleTimer( "UpdateAll", 3 )
end

function AJM:UpdateAll(event, ...)
	AJM:ScheduleTimer( "RefreshTeamListControls", 3 )
	AJM:ScheduleTimer( "SendExperienceStatusUpdateCommand", 2 )
	AJM:ScheduleTimer( "SendReputationStatusUpdateCommand", 2 )
	AJM:ScheduleTimer( "SendInfomationUpdateCommand", 2 )
	AJM:ScheduleTimer( "SendComboStatusUpdateCommand", 2 )
end


function AJM:OnMasterChanged( message, characterName )
	AJM:SettingsRefresh()
end

function AJM:GROUP_ROSTER_UPDATE()
	AJM:ScheduleTimer( "RefreshTeamListControls", 1 )
	AJM:ScheduleTimer( "SendExperienceStatusUpdateCommand", 1 )
	AJM:ScheduleTimer( "SendReputationStatusUpdateCommand", 1 )
	AJM:ScheduleTimer( "SendInfomationUpdateCommand", 1 )
	AJM:ScheduleTimer( "SendComboStatusUpdateCommand", 1 )
	for index, characterName in JambaApi.TeamListOrderedOnline() do
		unit = Ambiguate( characterName, "none" )
		AJM:ScheduleTimer( "SendHealthStatusUpdateCommand", 2, unit )
		AJM:ScheduleTimer( "SendPowerStatusUpdateCommand", 2, unit )
	end
end

function AJM:PLAYER_REGEN_ENABLED( event, ... )
	if AJM.db.hideTeamListInCombat == true then
		AJM:SetTeamListVisibility()
	end
	if AJM.refreshHideTeamListControlsPending == true then
		AJM:RefreshTeamListControlsHide()
		AJM.refreshHideTeamListControlsPending = false
	end
	if AJM.refreshShowTeamListControlsPending == true then
		AJM:RefreshTeamListControlsShow()
		AJM.refreshShowTeamListControlsPending = false
	end
	if AJM.updateSettingsAfterCombat == true then
		AJM:SettingsRefresh()
		AJM.updateSettingsAfterCombat = false
	end
	-- Ebony added follow bar combat Icon
	if AJM.db.showTeamList == true and AJM.db.showFollowStatus == true then
		AJM:ScheduleTimer( "SendCombatStatusUpdateCommand", 1 )
	end
end

function AJM:PLAYER_REGEN_DISABLED( event, ... )
	if AJM.db.hideTeamListInCombat == true then
		JambaDisplayTeamListFrame:Hide()
	end
	-- Ebony added follow bar combat Icon
	if AJM.db.showTeamList == true and AJM.db.showFollowStatus == true then
		AJM:ScheduleTimer( "SendCombatStatusUpdateCommand", 1 )
	end
end

function AJM:PLAYER_TALENT_UPDATE(event, ...)
	AJM:SendComboStatusUpdateCommand()
	AJM:ScheduleTimer( "SendExperienceStatusUpdateCommand", 1 )
end

function AJM:OnCharactersChanged()
	AJM:RefreshTeamListControls()
end


