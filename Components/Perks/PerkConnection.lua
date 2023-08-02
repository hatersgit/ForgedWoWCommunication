PerkDeserializerDefinitions =
{
    PERKSEL = {
        OBJECT = "*",
        FIELDS = {
            DELIMITER = "^",
            FIELDS = {
                {
                    NAME = "SpellId",
                },
                {
                    NAME = "carryover",
                    TYPE = FieldType.NUMBER,
                }
            }
        }
    },
    PERKCHAR = {
        OBJECT = ";",
        FIELDS = {
            DELIMITER = "^",
            FIELDS = {
                {
                    NAME = "SpecId",
                },
                {
                    NAME = "Perk",
                    OBJECT = "*",
                    FIELDS = {
                        DELIMITER = "&",
                        FIELDS = {
                            {
                                NAME = "spellId",
                            },
                            {  
                                NAME = "Meta",
                                OBJECT = "@",
                                FIELDS = {
                                    DELIMITER = "~",
                                    FIELDS = {
                                        {
                                            NAME = "classMask",
                                            TYPE = FieldType.NUMBER,
                                        },
                                        {
                                            NAME = "group",
                                            TYPE = FieldType.NUMBER,
                                        },
                                        {
                                            NAME = "isAura",
                                            TYPE = FieldType.NUMBER,
                                        },
                                        {
                                            NAME = "unique",
                                            TYPE = FieldType.NUMBER,
                                        },
                                        {
                                            NAME = "tags",
                                        },
                                        {
                                            NAME = "rank",
                                            TYPE = FieldType.NUMBER,
                                        }
                                    }
                                }
                            },
                        },
                    },
                },
            },
        },
    },
    PERKCAT = {
        OBJECT = ";",
        FIELDS = {
            FIELDS = {
                {
                    NAME = "Perk",
                    OBJECT = "*",
                    FIELDS = {
                        DELIMITER = "&",
                        FIELDS = {
                            {
                                NAME = "spellId",
                            },
                            {  
                                NAME = "Meta",
                                OBJECT = "@",
                                FIELDS = {
                                    DELIMITER = "~",
                                    FIELDS = {
                                        {
                                            NAME = "classMask",
                                            TYPE = FieldType.NUMBER,
                                        },
                                        {
                                            NAME = "group",
                                            TYPE = FieldType.NUMBER,
                                        },
                                        {
                                            NAME = "isAura",
                                            TYPE = FieldType.NUMBER,
                                        },
                                        {
                                            NAME = "unique",
                                            TYPE = FieldType.NUMBER,
                                        },
                                        {
                                            NAME = "tags",
                                        },
                                    }
                                }
                            },
                        },
                    },
                },
            },
        }
    },
}



settings = {
    spacer = 90,
    iconCont = 95,
}

PerkExplorerInternal = {
    PERKS_SPEC = nil,
    PERKS_ALL = nil,
    PERKS_SEARCH = nil,
}

function CreateRankedTooltip(id, parent, tt, depth, width, anchor, unique)
    tt:SetOwner(parent, anchor, 0, -1*depth);
    tt:SetHyperlink('spell:' .. id);
    if unique == 1 then
        tt:AddLine("");
        tt:AddLine("|cff990033Unique\124r");
        tt:SetHeight(tt:GetHeight()+10);
    end

    if width == 0 then
        tt:SetSize(tt:GetWidth(), tt:GetHeight());
    else
        tt:SetSize(width, tt:GetHeight());
    end
end

function SetUpRankedTooltip(parent, id, tt1, tt2, tt3, anchor)
    CreateRankedTooltip(id, parent, tt1, 0, 0, anchor, 0);
    CreateRankedTooltip(id+1000000, parent, tt2, tt1:GetHeight(), tt1:GetWidth(), anchor, 0);
    CreateRankedTooltip(id+2000000, parent, tt3, tt1:GetHeight() + tt2:GetHeight(), tt1:GetWidth(), anchor, 0);
end

function SetUpSingleTooltip(parent, id, tt, anchor)
    CreateRankedTooltip(id, parent, tt, 0, 0, anchor, 1);
end

function SetTemplate(frame)
    frame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "",
        tile = false, tileSize = 0, edgeSize = 0,
        insets = {left = 0, right = 0, top = 0, bottom = 0}
    });
    frame:SetBackdropColor(0, 0, 0, 1);
    frame:SetAlpha(.75);
end

function InitializePerks()
    PushForgeMessage(ForgeTopic.GET_PERKS, "-1");
    InitializeSelectionWindow();
    InitializePerkExplorer();

    SubscribeToForgeTopic(ForgeTopic.GET_PERKS,
    function(msg)
        --print(msg);
        if (#msg > 3) then
            PerkExplorerInternal.PERKS_SPEC = {};
            local perks = DeserializeMessage(PerkDeserializerDefinitions.PERKCHAR, msg);
            for specId, perk in ipairs(perks) do
                if PerkExplorerInternal.PERKS_SPEC[specId] == nil then
                    PerkExplorerInternal.PERKS_SPEC[specId] = {};
                end
                if perk then
                    --print(dump(perk))
                    for id, spell in pairs(perk["Perk"]) do
                        if PerkExplorerInternal.PERKS_SPEC[specId][spell["spellId"]] == nil then
                            PerkExplorerInternal.PERKS_SPEC[specId][spell["spellId"]] = {};
                        end
                        table.insert(PerkExplorerInternal.PERKS_SPEC[specId][spell["spellId"]], spell["Meta"][1]);
                    end
                end
            end
            LoadSpecPerks(GetSpecialization());
        end
    end);

    SubscribeToForgeTopic(ForgeTopic.GET_PERK_CATALOGUE,
    function(msg)
        local it = 1;
        --print(msg);
        PerkExplorerInternal.PERKS_ALL = {};
        local perks = DeserializeMessage(PerkDeserializerDefinitions.PERKCAT, msg);
        for i, perk in pairs(perks[1]["Perk"]) do
            if PerkExplorerInternal.PERKS_ALL[perk["spellId"]] == nil then
                PerkExplorerInternal.PERKS_ALL[perk["spellId"]] = {};
            end
            if perk then
                table.insert(PerkExplorerInternal.PERKS_ALL[perk["spellId"]], perk["Meta"][1]);
                it = it + 1;
            end
        end
        LoadAllPerks(it);
        --print(dump(PerkExplorerInternal.PERKS_ALL))
    end);

    SubscribeToForgeTopic(ForgeTopic.OFFER_SELECTION,
    function(msg)
        print(msg);
        local perks = DeserializeMessage(PerkDeserializerDefinitions.PERKSEL, msg);
        PerkSelectionWindow.SelectionPool:SetSize(#perks*settings.spacer + (#perks-1)*settings.spacer, settings.spacer);
        for index, perk in ipairs(perks) do
            AddSelectCard(perk.SpellId, index, #perks, perk.carryover);
        end
        TogglePerkSelectionFrame(false);
    end);
end
