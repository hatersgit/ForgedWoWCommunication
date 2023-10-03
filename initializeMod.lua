local Forgeframe = CreateFrame("Frame")
Forgeframe:RegisterEvent("PLAYER_ENTERING_WORLD")
Forgeframe:RegisterEvent("PLAYER_LOGIN")
Forgeframe:SetScript("OnEvent", function(self, event)
    if (event == "PLAYER_LOGIN") then
        InitializeTalentTree()
        initializeItemTooltips()
        InitializePerks()
        initializeAllStats()
        InitializeTransmog()
    else
        PushForgeMessage(ForgeTopic.OFFER_SELECTION, GetSpecID());
    end
end)