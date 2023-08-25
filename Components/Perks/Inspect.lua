local targetPerks = {}
UIParentLoadAddOn("Blizzard_InspectUI");
local perkInspectFrame = CreateFrame("Frame", "perkInspectFrame", InspectPaperDollFrame)
perkInspectFrame:SetToplevel(true)
perkInspectFrame:SetSize(180, InspectPaperDollFrame:GetHeight() - 100)
perkInspectFrame:SetPoint("TOPLEFT", InspectPaperDollFrame, "TOPRIGHT", -35, -20)
-- InspectFrame:SetWidth(InspectFrame:GetWidth()*2)--would have to change parent of a few frames to make this work for width
perkInspectFrame:SetScript("OnShow", function(self)
    if (not perkInspectFrame.perks[1]) then
        createInspectPerkFrames();
    end

    local name = UnitName("player") -- target
    -- request perks from server
    targetPerks[name] = {
        [8000000] = {{
            ["rank"] = 1
        }},
        [48469] = {{
            ["rank"] = 2
        }},
        [48441] = {{
            ["rank"] = 3
        }}
    }

end)

-- SubscribeToForgeTopic(ForgeTopic.GET_PERKS, function(msg)
--     print(msg);
--     local perks = DeserializeMessage(PerkDeserializerDefinitions.PERKCHAR, msg);
--     local name = ""
--     targetPerks[name] = {};
--     for specId, perk in ipairs(perks) do
--         if perk then
--             print(dump(perk))
--             for id, spell in pairs(perk["Perk"]) do
--                 -- if not PerkExplorerInternal.PERKS_SPEC[spell["spellId"]] then
--                 --     PerkExplorerInternal.PERKS_SPEC[spell["spellId"]] = {};
--                 -- end
--                 -- table.insert(PerkExplorerInternal.PERKS_SPEC[spell["spellId"]], spell["Meta"][1]);
--             end
--         end
--     end
--     LoadTargetPerks(name)
-- end);

local perkInspectFrameBG = CreateFrame("Frame", "perkInspectFrameBG", perkInspectFrame)
perkInspectFrameBG:SetSize(perkInspectFrame:GetWidth(), perkInspectFrame:GetHeight() + 15)
perkInspectFrameBG:SetPoint("CENTER", perkInspectFrame, "CENTER")
perkInspectFrameBG:SetBackdrop({
    bgFile = "Interface/TutorialFrame/TutorialFrameBackground",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = true,
    edgeSize = 22,
    tileSize = 22,
    insets = {
        left = 4,
        right = 4,
        top = 4,
        bottom = 4
    }
})

perkInspectFrame.perks = {}

function createInspectPerkFrames()
    local columnID = 1;
    local perRow = 4
    local iconSize = (settings.width - settings.gap) / (perRow * 4.8)
    local depth = iconSize;
    for i = 1, 40, 1 do
        if (columnID > perRow) then
            columnID = 1
        end

        local num = math.fmod(i, perRow);
        if (num == 1) then
            depth = depth - (settings.gap + iconSize)
        end

        local iconFrame = CreateFrame("BUTTON", "iconFrame" .. i, perkInspectFrame);
        iconFrame:SetHighlightTexture("Interface\\Buttons\\CheckButtonHilight");
        iconFrame:SetFrameLevel(perkInspectFrame:GetFrameLevel() + 2);
        iconFrame:SetSize(iconSize, iconSize);
        iconFrame:SetPoint("TOPLEFT", 5 + settings.gap * columnID + (columnID - 1) * iconSize, depth);

        local texture = iconFrame:CreateTexture(nil, "ARTWORK", nil, perkInspectFrame:GetFrameLevel() + 3);
        texture:SetAllPoints(iconFrame);
        texture:SetPoint("CENTER", 0, 0);

        iconFrame.Texture = texture;
        perkInspectFrame.perks[i] = iconFrame;
        columnID = columnID + 1;
    end
end

function LoadTargetPerks(targetName)
    for i = 1, 40, 1 do
        perkInspectFrame.perks[i]:Hide();
    end

    local i = 1;
    for spellId, meta in pairs(targetPerks[targetName]) do
        local name, _, icon = GetSpellInfo(spellId);
        local rank = meta[1].rank;
        local current = perkInspectFrame.perks[i]
        current.Texture:SetTexture(icon);
        SetRankTexture(current, rank)

        current:HookScript("OnEnter", function()
            SetUpRankedTooltip(perkInspectFrame, spellId, "ANCHOR_RIGHT");
        end);
        current:SetScript("OnLeave", function()
            clearTooltips()
        end);
        current:Show()
        i = i + 1;
    end
end
