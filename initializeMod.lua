local Forgeframe = CreateFrame("Frame")
Forgeframe:RegisterEvent("PLAYER_ENTERING_WORLD")
Forgeframe:SetScript("OnEvent", function(self, event, isLogin, isReload)
    if isLogin or isReload then
        InitializeTalentTree()
        InitializeTooltips()
        InitializePerks()
    end

    PushForgeMessage(ForgeTopic.COLLECTION_INIT, "-1");
end)
