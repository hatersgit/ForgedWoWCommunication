hooksecurefunc("UpdateMicroButtons", function()
    TalentMicroButton:SetNormalTexture(CONSTANTS.UI.NORMAL_TEXTURE_BTN)
    TalentMicroButton:SetPushedTexture(CONSTANTS.UI.PUSHED_TEXTURE_BTN)
    TalentMicroButton:SetDisabledTexture(CONSTANTS.UI.PUSHED_TEXTURE_BTN)
    TalentMicroButton.tooltipText = MicroButtonTooltipText("Forge Talents", "TOGGLETALENTS");
    TalentMicroButton.newbieText = "View your Character, Priestige, Race and Forged Skill talents";

    TalentMicroButton:Enable()
    TalentMicroButton:SetScript("OnClick", function()
        ToggleMainWindow();
    end);
    if TalentTreeWindow:IsShown() then
        PlaySound("TalentScreenOpen");
        TalentMicroButton:SetButtonState("PUSHED", 1);
    else
        PlaySound("TalentScreenClose");
        TalentMicroButton:SetButtonState("NORMAL");
    end
end);
