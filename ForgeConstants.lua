MESSAGE_PREFIX = "FORGE"
FORGE = {}

FieldType = {
    NUMBER = "NUM",
    BOOL = "BOOL"
}

PereqReqirementType = {
    ALL = 0,
    ONE = 1
};

SpecVisibility = {
    PRIVATE = "0",
    FRIENDS = "1",
    GUILD = "2",
    PUBLIC = "3"
}

GameModeRewardType = {
    Mount = "0",
    Title = "1",
    Item = "2"
}

CharacterPointType = {
    TALENT_SKILL_TREE = "0",
    FORGE_SKILL_TREE = "1",
    SPEC_COUNT = 2,
    PRESTIGE_TREE = "3",
    RACIAL_TREE = "4",
    SKILL_PAGE = "5",
    PRESTIGE_COUNT = "6",
    LEVEL_10_TAB = "7"
}

ForgeTopic = {
    -- Message Content: tabid
    GET_TALENTS = 0,
    -- Message Content: tabid;talentId
    LEARN_TALENT = 1,
    -- Message Content: tabid;talentId
    -- a single talent.
    UNLEARN_TALENT = 2,
    -- Message Content: CharacterPointType
    -- will re-send all talents with GET_TALENTS topic if sucsessful
    RESPEC_TALENTS = 3,
    RESPEC_TALENT_ERROR = 4,
    UPDATE_SPEC = 5,
    -- Message Content: specId
    ACTIVATE_SPEC = 6,
    PRESTIGE = 7,
    TalentTree_LAYOUT = 8,
    GET_SHOP_ITEMS = 9,
    UPDATE_SPEC_ERROR = 10,
    ACTIVATE_SPEC_ERROR = 11,
    LEARN_TALENT_ERROR = 12,
    BUY_ITEM_ERROR = 13,
    UNLEARN_TALENT_ERROR = 14,
    GET_TALENT_ERROR = 15,
    BUY_ITEMS = 16,
    GET_ITEM_FROM_COLLECTION = 17,
    GET_PLAYER_COLLECTION = 18,
    GET_SHOP_LAYOUT = 19,
    HOLIDAYS = 20,
    GET_CHARACTER_SPECS = 21,
    PRESTIGE_ERROR = 22,
    ACTIVATE_CLASS_SPEC = 23,
    ACTIVATE_CLASS_SPEC_ERROR = 24,
    GET_TOOLTIPS = 25,
    FORGET_TOOLTIP = 26,
    GET_GAME_MODES = 27,
    SET_GAME_MODES = 28,
    SET_GAME_MODES_ERROR = 29,
    END_GAME_MODES = 30,
    COLLECTION_INIT = 31,
    OUTFIT_COST = 32,
    LOAD_XMOG_SET = 33,
    LOAD_XMOG_SET_ERROR = 34,
    SEARCH_XMOG = 35,
    LOAD_XMOG = 36,
    LOAD_MOUNTS = 37,
    LOAD_PETS = 38,
    LOAD_TOYS = 39,
    LOAD_HEIRLOOM = 40,
    MISSING_XMOG = 41,
    PREVIEW_XMOG = 42,
    PLAYER_XMOG = 43,
    LEARN_MOUNT = 44,
    USE_TOY = 45,
    GET_XMOG_COST = 46,
    APPLY_XMOG = 47,
    REMOVE_XMOG_SET = 48,
    SAVE_XMOG_SET = 49,
    RENAME_XMOG_SET = 50,
    MAX_OUTFITS = 51,
    COLLECTION_SETUP_STARTED = 52,
    COLLECTION_SETUP_FINISHED = 53,
    ADD_XMOG = 54,
    APPLY_XMOG_ERROR = 55,
    GET_PERKS = 56,
    LEARN_PERK = 57,
    LEARN_PERK_ERROR = 58,
    REROLL_PERK = 59,
    REROLL_PERK_ERROR = 60,
    RESET_ALL_PERKS = 61,
    OFFER_SELECTION = 62,
    GET_PERK_CATALOGUE = 63,
    GET_INSPECT_PERKS = 64
}

-- These are the object definitions. Keyed by the same forge topic key.
SerializerDefinitions = {
    BUY_ITEMS = {
        OBJECT = ";",
        FIELDS = {
            DELIMITER = "^",
            FIELDS = {{
                NAME = "ShopItemId"
            }, {
                NAME = "Amount"
            }}
        }
    },
    UPDATE_SPEC = {
        DELIMITER = ";",
        FIELDS = {{
            NAME = "Id"
        }, {
            NAME = "Name"
        }, {
            NAME = "Description"
        }, {
            NAME = "Active"
        }, {
            NAME = "SpellIconId"
        }, {
            NAME = "Visability"
        }}
    }
}

-- These are the object definitions. Keyed by the same forge topic key.
DeserializerDefinitions = {
    LOAD_TOYS = {
        NAME = "Toys",
        OBJECT = ";",
        FIELDS = {
            DELIMITER = "^",
            FIELDS = {{
                NAME = "ID",
                TYPE = FieldType.NUMBER
            }, {
                NAME = "itemID",
                TYPE = FieldType.NUMBER
            }, {
                NAME = "flags",
                TYPE = FieldType.NUMBER
            }, {
                NAME = "expansion",
                TYPE = FieldType.NUMBER
            }, {
                NAME = "sourceType",
                TYPE = FieldType.NUMBER
            }, {
                NAME = "sourceText"
            }, {
                NAME = "holiday",
                TYPE = FieldType.NUMBER
            }}
        }
    },
    LOAD_XMOG = {
        OBJECT = ";", -- ItemId
        DICT = "~",
        TYPE = FieldType.NUMBER,
        FIELDS = {
            DELIMITER = "^",
            FIELDS = {{
                NAME = "InventoryType",
                TYPE = FieldType.NUMBER
            }, {
                NAME = "SourceQuests",
                OBJECT = ",",
                TYPE = FieldType.NUMBER
            }, {
                NAME = "SourceBosses",
                OBJECT = "$",
                TYPE = FieldType.NUMBER
            }, {
                NAME = "Holiday",
                TYPE = FieldType.NUMBER
            }, {
                NAME = "Camera",
                TYPE = FieldType.NUMBER
            }, {
                NAME = "Unusable",
                TYPE = FieldType.BOOL
            }, {
                NAME = "Unobtainable",
                TYPE = FieldType.BOOL
            }, {
                NAME = "Weapon",
                TYPE = FieldType.BOOL
            }, {
                NAME = "Enchantable",
                TYPE = FieldType.BOOL
            }, {
                NAME = "Armor",
                TYPE = FieldType.NUMBER
            }, {
                NAME = "SourceMask",
                TYPE = FieldType.NUMBER
            }, {
                NAME = "ClassMask",
                TYPE = FieldType.NUMBER
            }, {
                NAME = "RaceMask",
                TYPE = FieldType.NUMBER
            }, {
                NAME = "Icon",
                TYPE = FieldType.NUMBER
            }}
        }
    },
    HOLIDAYS = {
        NAME = "HOLIDAYS",
        OBJECT = ";",
        DICT = "~"
    },
    PLAYER_XMOG = {
        NAME = "Xmog",
        OBJECT = ";",
        DICT = "~"
    },
    GET_TOOLTIPS = {
        OBJECT = ";",
        FIELDS = {
            DELIMITER = "#",
            FIELDS = {{
                NAME = "Id"
            }, {
                NAME = "AddedTooltipEffects",
                OBJECT = "%"
            }, {
                NAME = "Tokens",
                OBJECT = "*",
                DICT = "~" -- will build dict of basic KVP without fields defined.
            }}
        }
    },
    GET_GAME_MODES = {
        OBJECT = ";",
        FIELDS = {
            DELIMITER = "^",
            FIELDS = {{
                NAME = "GameMode"
            }, {
                NAME = "Rewards",
                OBJECT = "*",
                FIELDS = {
                    DELIMITER = "&",
                    FIELDS = {{
                        NAME = "RewardType"
                    }, {
                        NAME = "Entry"
                    }}
                }
            }}
        }
    },
    GET_PLAYER_COLLECTION_LAYOUT = {
        OBJECT = ";",
        FIELDS = {
            DELIMITER = "^",
            FIELDS = {{
                NAME = "Id"
            }, {
                NAME = "Name"
            }, {
                NAME = "Description"
            }, {
                NAME = "SpellIcon"
            }, {
                NAME = "Subcategories",
                OBJECT = "*",
                FIELDS = {
                    DELIMITER = "&",
                    FIELDS = {{
                        NAME = "Id"
                    }, {
                        NAME = "Category"
                    }, {
                        NAME = "Name"
                    }, {
                        NAME = "Description"
                    }, {
                        NAME = "SpellIcon"
                    }}
                }
            }}
        }
    },
    GET_SHOP_LAYOUT = {
        OBJECT = ";",
        FIELDS = {
            DELIMITER = "^",
            FIELDS = {{
                NAME = "Id"
            }, {
                NAME = "Name"
            }, {
                NAME = "Description"
            }, {
                NAME = "SpellIcon"
            }, {
                NAME = "Subcategories",
                OBJECT = "*",
                FIELDS = {
                    DELIMITER = "&",
                    FIELDS = {{
                        NAME = "Id"
                    }, {
                        NAME = "Category"
                    }, {
                        NAME = "Name"
                    }, {
                        NAME = "Description"
                    }, {
                        NAME = "SpellIcon"
                    }, {
                        NAME = "Items",
                        OBJECT = "@",
                        FIELDS = {
                            DELIMITER = "$",
                            FIELDS = {{
                                NAME = "Id"
                            }, {
                                NAME = "Category"
                            }, {
                                NAME = "Subcategory"
                            }, {
                                NAME = "Name"
                            }, {
                                NAME = "Description"
                            }, {
                                NAME = "SpellIcon"
                            }, {
                                NAME = "Image"
                            }, {
                                NAME = "Cost"
                            }, {
                                NAME = "SaleCost"
                            }, {
                                NAME = "OnSale"
                            }, {
                                NAME = "Listed"
                            }, {
                                NAME = "ItemContents",
                                OBJECT = "<",
                                FIELDS = {
                                    DELIMITER = ">",
                                    FIELDS = {{
                                        NAME = "ForgeShopItemId"
                                    }, {
                                        NAME = "ItemId"
                                    }, {
                                        NAME = "Amount"
                                    }}
                                }
                            }}
                        }
                    }}
                }
            }}
        }
    },
    GET_PLAYER_COLLECTION = {
        NAME = "Collection",
        OBJECT = "%",
        DICT = "~" -- will build dict of basic KVP without fields defined.
    },
    GET_TALENTS = {
        OBJECT = ";",
        FIELDS = {
            DELIMITER = "^",
            FIELDS = {{
                NAME = "TabId"
            }, {
                NAME = "PointType"
            }, {
                NAME = "Talents",
                OBJECT = "*",
                DICT = "~" -- will build dict of basic KVP without fields defined.
            }}
        }
    },
    LEARN_TALENT = {
        OBJECT = ";",
        FIELDS = {
            DELIMITER = "K",
            FIELDS = {{
                NAME = "TabId"
            }, {
                NAME = "SpellId"
            }, {
                NAME = "CurrentRank"
            }}
        }
    },
    LEARN_SPELL_TALENT = {
        OBJECT = ";",
        FIELDS = {
            DELIMITER = "K",
            FIELDS = {{
                NAME = "TabId"
            }, {
                NAME = "SpellId"
            }, {
                NAME = "CurrentRank"
            }}
        }
    },
    TalentTree_LAYOUT = {
        OBJECT = ";",
        FIELDS = {
            DELIMITER = "^",
            FIELDS = {{
                NAME = "Id"
            }, {
                NAME = "Name"
            }, {
                NAME = "SpellIconId"
            }, {
                NAME = "Background"
            }, {
                NAME = "TalentType"
            }, {
                NAME = "TabIndex"
            }, {
                NAME = "Talents",
                OBJECT = "*",
                FIELDS = {
                    DELIMITER = "&",
                    FIELDS = {{
                        NAME = "SpellId"
                    }, {
                        NAME = "ColumnIndex"
                    }, {
                        NAME = "RowIndex"
                    }, {
                        NAME = "RankCost"
                    }, {
                        NAME = "RequiredLevel"
                    }, {
                        NAME = "NumberOfRanks"
                    }, {
                        NAME = "PreReqType"
                    }, {
                        NAME = "Prereqs",
                        OBJECT = "@",
                        FIELDS = {
                            DELIMITER = "$",
                            FIELDS = {{
                                NAME = "Talent"
                            }, {
                                NAME = "TalentTabId"
                            }, {
                                NAME = "RequiredRank"
                            }}
                        }
                    }, {
                        NAME = "ExclusiveWith",
                        OBJECT = "!" -- with just object delimiter this will be treated as a list to the deserializer
                    }, {
                        NAME = "Ranks",
                        OBJECT = "%",
                        DICT = "~" -- will build dict of basic KVP without fields defined.
                    }, {
                        NAME = "UnleanSpellIds",
                        OBJECT = "`" -- with just object delimiter this will be treated as a list to the deserializer
                    }}
                }
            }}
        }

    },
    GET_CHARACTER_SPECS = {
        OBJECT = ";",
        FIELDS = {
            DELIMITER = "^",
            FIELDS = {{
                NAME = "Id"
            }, {
                NAME = "Name"
            }, {
                NAME = "Description"
            }, {
                NAME = "Active"
            }, {
                NAME = "SpellIconId"
            }, {
                NAME = "Visability"
            }, {
                NAME = "CharacterSpecTabId"
            }, {
                NAME = "PointsSpent",
                OBJECT = "%",
                DICT = "~" -- will build dict of basic KVP without fields defined.
            }, {
                NAME = "TalentPoints",
                OBJECT = "@",
                FIELDS = {
                    DELIMITER = "$",
                    FIELDS = {{
                        NAME = "CharacterPointType"
                    }, {
                        NAME = "AvailablePoints"
                    }, {
                        NAME = "Earned"
                    }, {
                        NAME = "MaxPointsForTree"
                    }, {
                        NAME = "MaxPoints"
                    }}
                }
            }}
        }
    }
}

function GetSpecID()
    return GetActiveTalentGroup() - 1
end

function SetTemplate(frame)
    frame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "",
        tile = false,
        tileSize = 0,
        edgeSize = 0,
        insets = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0
        }
    });
    frame:SetBackdropColor(0, 0, 0, 1);
    frame:SetAlpha(.75);
end
