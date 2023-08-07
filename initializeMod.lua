local Forgeframe = CreateFrame("Frame")
Forgeframe:RegisterEvent("PLAYER_ENTERING_WORLD")
Forgeframe:SetScript("OnEvent", function(initialLogin,ReloadUI)
    InitializeTalentTree()
    InitializeTooltips()
    InitializePerks()

    --add a reloadUI check to show perks a top
    
    PushForgeMessage(ForgeTopic.COLLECTION_INIT, "-1");
end)