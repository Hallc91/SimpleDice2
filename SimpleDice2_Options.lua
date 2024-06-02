SD2.NumberTable = {"One","Two","Three","Four","Five","Six","Seven","Eight","Nine","Ten","Eleven","Twelve","Thirteen","Fourteen","Fifteen","Sixteen","Seventeen","Eighteen","Nineteen","Twenty","Twenty-One","Twenty-Two","Twenty-Three","Twenty-Four","Twenty-Five","Twenty-Six","Twenty-Seven","Twenty-Eight","Twenty-Nine","Thirty","Thirty-One","Thirty-Two","Thirty-Three","Thirty-Four","Thirty-Five","Thirty-Six","Thirty-Seven","Thirty-Eight","Thirty-Nine","Forty"}
SD2.FirstSkillTable = {skillheader = {name = "Skills",type = "header",order = 0},}
SD2.SecondSkillTable = {skillheader = {name = "Skills",type = "header",order = 0},}
SD2.FullAttributeTable = {attributeheader = {name = "Attributes",type = "header",order = 0},}

SD2.Options = {
  name = "Simple Dice 2",
  handler = SD2,
  type = 'group',
  childGroups = "tab",

  args = {

    stats = {

      type        = "group",
      name        = "Statistics",
      cmdHidden   = true,
      order       = 0,
      childGroups = "tree",
      args        = {

        statsheader = {
          name       = "Statistics",
          type       = "header",
          order      = 0
        },

        maxhp = {

          name        = "Maximum HP",
          desc        = "Your Maximum HP Value.",
          type        = "input",
          set         = function(info, val) SD2.db.char.statistics["MaxHP"] = tonumber(val); SD2.db.char.statistics["HP"] = tonumber(val); end,
          get         = function(info) return tostring(SD2.db.char.statistics["MaxHP"]); end,
          cmdHidden   = true,
          width       = "half",
          order       = 1

        },

        maxmp = {

          name        = "Maximum MP",
          desc        = "Your Maximum MP Value.",
          type        = "input",
          set         = function(info, val) SD2.db.char.statistics["MaxMP"] = tonumber(val); SD2.db.char.statistics["MP"] = tonumber(val); end,
          get         = function(info) return tostring(SD2.db.char.statistics["MaxMP"]); end,
          cmdHidden   = true,
          width       = "half",
          order       = 2

        },

        maxenergy = {

          name        = "Maximum Energy",
          desc        = "Your Maximum Energy Value.",
          type        = "input",
          set         = function(info, val) SD2.db.char.statistics["MaxEnergy"] = tonumber(val); SD2.db.char.statistics["Energy"] = tonumber(val); end,
          get         = function(info) return tostring(SD2.db.char.statistics["MaxEnergy"]); end,
          cmdHidden   = true,
          width       = "half",
          order       = 3

        },

        statsdesc = {

          name        = "Please note these statistics are only for your own personal tracking purposes right now, more functionality may be added in the future. To track your current HP please use the Statistics Tab in the main addon window.",
          type        = "description",
          order       = 4

        }



      }

    },

    attributeconfig = {

      type        = "group",
      name        = "Attribute Settings",
      cmdHidden   = true,
      order       = 1,
      childGroups = "tree",
      args        = SD2.FullAttributeTable

    },

    skillconfig = {

      type        = "group",
      name        = "Primary Skills",
      cmdHidden   = true,
      order       = 2,
      childGroups = "tree",
      args        = SD2.FirstSkillTable
    },
	
	secondskillconfig = {

      type        = "group",
      name        = "Secondary Skills",
      cmdHidden   = true,
      order       = 3,
      childGroups = "tree",
      args        = SD2.SecondSkillTable
    },

  rollsettings = {

      type        = "group",
      name        = "Custom Roll Settings",
      cmdHidden   = true,
      order       = 4,
      childGroups = "tree",
      args        = {

        rollheader1 = {
          name       = "Custom Roll One",
          type       = "header",
          order      = 0
        },

        rollcustom1_low = {

          name        = "Lower Roll Range",
          desc        = "The lower value for your skill dice rolls.",
          type        = "range",
          min         = 1,
          max         = 100,
          softMin     = 1,
          softMax     = 100,
          step        = 1,
          set         = function(info, val)
            if val >= SD2.db.char.roll.custom1["High"]
            then SD2.db.char.roll.custom1["Low"] = SD2.db.char.roll.custom1["High"] - 1
            else SD2.db.char.roll.custom1["Low"] = val
            end;
          end,
          get         = function(info) return SD2.db.char.roll.custom1["Low"]; end,
          cmdHidden   = true,
          order       = 1

        },

        rollcustom1_high = {

          name        = "Upper Roll Range",
          desc        = "The upper value for your skill dice rolls.",
          type        = "range",
          min         = 1,
          max         = 100,
          softMin     = 1,
          softMax     = 100,
          step        = 1,
          set         = function(info, val)
            if val <= SD2.db.char.roll.custom1["Low"]
            then SD2.db.char.roll.custom1["High"] = SD2.db.char.roll.custom1["Low"] + 1
            else SD2.db.char.roll.custom1["High"] = val
            end;
          end,
          get         = function(info) return SD2.db.char.roll.custom1["High"]; end,
          cmdHidden   = true,
          order       = 2

        },

        rollheader2 = {
          name       = "Custom Roll Two",
          type       = "header",
          order      = 3
        },

        rollcustom2_low = {

          name        = "Lower Roll Range",
          desc        = "The lower value for your skill dice rolls.",
          type        = "range",
          min         = 1,
          max         = 100,
          softMin     = 1,
          softMax     = 100,
          step        = 1,
          set         = function(info, val)
            if val >= SD2.db.char.roll.custom2["High"]
            then SD2.db.char.roll.custom2["Low"] = SD2.db.char.roll.custom2["High"] - 1
            else SD2.db.char.roll.custom2["Low"] = val
            end;
          end,
          get         = function(info) return SD2.db.char.roll.custom2["Low"]; end,
          cmdHidden   = true,
          order       = 4

        },

        rollcustom2_high = {

          name        = "Upper Roll Range",
          desc        = "The upper value for your skill dice rolls.",
          type        = "range",
          min         = 1,
          max         = 100,
          softMin     = 1,
          softMax     = 100,
          step        = 1,
          set         = function(info, val)
            if val <= SD2.db.char.roll.custom2["Low"]
            then SD2.db.char.roll.custom2["High"] = SD2.db.char.roll.custom2["Low"] + 1
            else SD2.db.char.roll.custom2["High"] = val
            end;
          end,
          get         = function(info) return SD2.db.char.roll.custom2["High"]; end,
          cmdHidden   = true,
          order       = 5

        },

        rollheader3 = {
          name       = "Custom Roll Three",
          type       = "header",
          order      = 6
        },

        rollcustom3_low = {

          name        = "Lower Roll Range",
          desc        = "The lower value for your skill dice rolls.",
          type        = "range",
          min         = 1,
          max         = 100,
          softMin     = 1,
          softMax     = 100,
          step        = 1,
          set         = function(info, val)
            if val >= SD2.db.char.roll.custom3["High"]
            then SD2.db.char.roll.custom3["Low"] = SD2.db.char.roll.custom3["High"] - 1
            else SD2.db.char.roll.custom3["Low"] = val
            end;
          end,
          get         = function(info) return SD2.db.char.roll.custom3["Low"]; end,
          cmdHidden   = true,
          order       = 7
        },

        rollcustom3_high = {

          name        = "Upper Roll Range",
          desc        = "The upper value for your skill dice rolls.",
          type        = "range",
          min         = 1,
          max         = 100,
          softMin     = 1,
          softMax     = 100,
          step        = 1,
          set         = function(info, val)
            if val <= SD2.db.char.roll.custom3["Low"]
            then SD2.db.char.roll.custom3["High"] = SD2.db.char.roll.custom3["Low"] + 1
            else SD2.db.char.roll.custom3["High"] = val
            end;
          end,
          get         = function(info) return SD2.db.char.roll.custom3["High"]; end,
          cmdHidden   = true,
          order       = 8

        },

        rollheader4 = {
          name       = "Custom Roll Four",
          type       = "header",
          order      = 9
        },

        rollcustom4_low = {

          name        = "Lower Roll Range",
          desc        = "The lower value for your skill dice rolls.",
          type        = "range",
          min         = 1,
          max         = 100,
          softMin     = 1,
          softMax     = 100,
          step        = 1,
          set         = function(info, val)
            if val >= SD2.db.char.roll.custom4["High"]
            then SD2.db.char.roll.custom4["Low"] = SD2.db.char.roll.custom4["High"] - 1
            else SD2.db.char.roll.custom4["Low"] = val
            end;
          end,
          get         = function(info) return SD2.db.char.roll.custom4["Low"]; end,
          cmdHidden   = true,
          order       = 10

        },

        rollcustom4_high = {

          name        = "Upper Roll Range",
          desc        = "The upper value for your skill dice rolls.",
          type        = "range",
          min         = 1,
          max         = 100,
          softMin     = 1,
          softMax     = 100,
          step        = 1,
          set         = function(info, val)
            if val <= SD2.db.char.roll.custom4["Low"]
            then SD2.db.char.roll.custom4["High"] = SD2.db.char.roll.custom4["Low"] + 1
            else SD2.db.char.roll.custom4["High"] = val
            end;
          end,
          get         = function(info) return SD2.db.char.roll.custom4["High"]; end,
          cmdHidden   = true,
          order       = 11

        },

        rollheader5 = {
          name       = "Custom Roll Five",
          type       = "header",
          order      = 12
        },

        rollcustom5_low = {

          name        = "Lower Roll Range",
          desc        = "The lower value for your skill dice rolls.",
          type        = "range",
          min         = 1,
          max         = 100,
          softMin     = 1,
          softMax     = 100,
          step        = 1,
          set         = function(info, val)
            if val >= SD2.db.char.roll.custom5["High"]
            then SD2.db.char.roll.custom5["Low"] = SD2.db.char.roll.custom5["High"] - 1
            else SD2.db.char.roll.custom5["Low"] = val
            end;
          end,
          get         = function(info) return SD2.db.char.roll.custom5["Low"]; end,
          cmdHidden   = true,
          order       = 13

        },

        rollcustom5_high = {

          name        = "Upper Roll Range",
          desc        = "The upper value for your skill dice rolls.",
          type        = "range",
          min         = 1,
          max         = 100,
          softMin     = 1,
          softMax     = 100,
          step        = 1,
          set         = function(info, val)
            if val <= SD2.db.char.roll.custom5["Low"]
            then SD2.db.char.roll.custom5["High"] = SD2.db.char.roll.custom5["Low"] + 1
            else SD2.db.char.roll.custom5["High"] = val
            end;
          end,
          get         = function(info) return SD2.db.char.roll.custom5["High"]; end,
          cmdHidden   = true,
          order       = 14

        },


        rolldescription = {
          name       = "There are also a range of defaults already coded in. These are: D4, D5, D6, D10, D12, D15, D20, D100",
          type       = "description",
          fontSize   = "large",
          order      = 15
        },

      },
    },

  options = {

      type        = "group",
      name        = "Options",
      cmdHidden   = true,
      order       = 5,
      childGroups = "tree",
      args        = {

        diceheader = {
          name       = "Roll Settings",
          type       = "header",
          order      = 0
        },

        dicelow = {

          name        = "Lower Skill Roll Range",
          desc        = "The lower value for your skill dice rolls.",
          type        = "range",
          min         = 1,
          max         = 100,
          softMin     = 1,
          softMax     = 100,
          step        = 1,
          set         = function(info, val)
            if val >= SD2.db.char.roll["High"]
            then SD2.db.char.roll["Low"] = SD2.db.char.roll["High"] - 1
            else SD2.db.char.roll["Low"] = val
            end;
          end,
          get         = function(info) return SD2.db.char.roll["Low"]; end,
          cmdHidden   = true,
          order       = 1

        },

        dicehigh = {

          name        = "Upper Skill Roll Range",
          desc        = "The upper value for your skill dice rolls.",
          type        = "range",
          min         = 1,
          max         = 100,
          softMin     = 1,
          softMax     = 100,
          step        = 1,
          set         = function(info, val)
            if val <= SD2.db.char.roll["Low"]
            then SD2.db.char.roll["High"] = SD2.db.char.roll["Low"] + 1
            else SD2.db.char.roll["High"] = val
            end;
          end,
          get         = function(info) return SD2.db.char.roll["High"]; end,
          cmdHidden   = true,
          order       = 2

        },

        attdicelow = {

          name        = "Lower Attribute Roll Range",
          desc        = "The lower value for your attribute dice rolls.",
          type        = "range",
          min         = 1,
          max         = 100,
          softMin     = 1,
          softMax     = 100,
          step        = 1,
          set         = function(info, val)
            if val >= SD2.db.char.roll["AttributeHigh"]
            then SD2.db.char.roll["AttributeLow"] = SD2.db.char.roll["AttributeHigh"] - 1
            else SD2.db.char.roll["AttributeLow"] = val
            end;
          end,
          get         = function(info) return SD2.db.char.roll["AttributeLow"]; end,
          cmdHidden   = true,
          order       = 4

        },

        attdicehigh = {

          name        = "Upper Attribute Roll Range",
          desc        = "The upper value for your attribute dice rolls.",
          type        = "range",
          min         = 1,
          max         = 100,
          softMin     = 1,
          softMax     = 100,
          step        = 1,
          set         = function(info, val)
            if val <= SD2.db.char.roll["AttributeLow"]
            then SD2.db.char.roll["AttributeHigh"] = SD2.db.char.roll["AttributeLow"] + 1
            else SD2.db.char.roll["AttributeHigh"] = val
            end;
          end,
          get         = function(info) return SD2.db.char.roll["AttributeHigh"]; end,
          cmdHidden   = true,
          order       = 5

        },

        dmginc = {

          name        = "Damage Increment",
          desc        = "Use this if your system rewards extra damage for X over the DC.\nFor Example, If for every 2 over the DC you roll you deal an extra damage you would set this to 2.",
          type        = "range",
          min         = 0,
          max         = 20,
          step        = 1,
          set         = function(info, val) SD2.db.char.roll["DamageInc"] = tonumber(val) end,
          get         = function(info) return SD2.db.char.roll["DamageInc"]; end,
          cmdHidden   = true,
          order       = 3

        },

        desc = {

          name        = " ",
          type        = "description",
          order       = 6
        },

        critsuccess = {
           name        = "Critical Success",
           desc        = "Enable critical successes. If your roll is equal to the highest value possible a critical success will be announced. Will also automatically double listed damage.",
           type        = "toggle",
           set         = function(info, val) SD2.db.profile["CritSuccess"] = val; end,
           get         = function(info) return SD2.db.profile["CritSuccess"]; end,
           cmdHidden   = true,
           order       = 7

         },

        critfail = {
           name        = "Critical Failures",
           desc        = "Enable critical failures. If your roll is equal to the lowest possible value a critical fail will be announced.",
           type        = "toggle",
           set         = function(info, val) SD2.db.profile["CritFail"] = val; end,
           get         = function(info) return SD2.db.profile["CritFail"]; end,
           cmdHidden   = true,
           order       = 8

         },

        rolltype = {
          name        = "Roll Type",
          desc        = "",
          type        = "select",
          values      = {"Default","Minimum Skill","Iscaria"};
          set         = function(info, val) SD2.db.char.roll["Type"] = val; end,
          get         = function(info) return SD2.db.char.roll["Type"]; end,
          width       = "0.75",
          cmdHidden   = true,
          order       = 9

        },

        optheader = {
            name       = "Options",
            type       = "header",
            order      = 10
          },
		  
          minimap = {
             name        = "Hide Minimap Button",
             desc        = "Hide or show the Minimap Button",
             type        = "toggle",
             set         = function(info, val) SD2.db.char.minimap.hide = val; if val then SD2Icon:Hide("Simple Dice 2") else SD2Icon:Show("Simple Dice 2") end; end,
             get         = function(info) return SD2.db.char.minimap.hide; end,
             cmdHidden   = true,
             order       = 11
           },

           latency = {
              name        = "High Latency Mode",
              desc        = "Enable this if you're suffering from an abnormally high ping. (Typically over 1000)",
              type        = "toggle",
              set         = function(info, val) SD2.db.profile["Latency"] = val; end,
              get         = function(info) return SD2.db.profile["Latency"]; end,
              cmdHidden   = true,
              order       = 12
            },

            silentmode = {
               name        = "Silent Mode",
               desc        = "The Output message will no longer be displayed in party/raid chat even when you're in a party.",
               type        = "toggle",
               set         = function(info, val) SD2.db.profile["Silent"] = val; end,
               get         = function(info) return SD2.db.profile["Silent"]; end,
               cmdHidden   = true,
               order       = 13
             },

            escape = {
               name        = "Obey Escape Button",
               desc        = "If disabled the addon will no longer vanish from your screen when escape is pressed. (Not Recommended)",
               type        = "toggle",
               set         = function(info, val) SD2.db.profile["Escape"] = val; end,
               get         = function(info) return SD2.db.profile["Escape"]; end,
               cmdHidden   = true,
               order       = 13
             },

             resetheader = {
               name       = "Reset",
               type       = "header",
               order      = 15
             },

             reset = {
                name        = "Reset Database",
                desc        = "Will clear and reset all of your options across every character. NOTHING will be saved.",
                type        = "execute",
                func        = function() ResetSD2Profile() end,
                cmdHidden   = true,
                order       = 17
              },

--[[              import = {
                name        = "Import",
                desc        = "Used to Import a profile from another copy of Simple Dice 2.\nWill overwrite ALL Attributes and Skills.",
                type        = "input",
                multiline   = true,
                set         = function(info,val) ImportSD2Profile(info) end,
                cmdHidden   = true,
                order       = 10,
              },

              export = {
                name        = "Export",
                desc        = "Exports all currently set Attribute and Skill names to be imported into another copy of Simple Dice 2.\nWill NOT export Modifier Values.",
                type        = "execute",
                func        = function() ExportSD2Profile() end,
                cmdHidden   = true,
                order       = 11,
              },

              profile = {
                name        = "Profile",
                desc        = "",
                type        = "select",
                values      = function() return SD2.db:GetProfiles() end,
                set         = function(info, val) SD2.db:SetProfile(info); end,
                get         = function(info) return SD2.db:GetCurrentProfile(); end,
                width       = "0.75",
                cmdHidden   = true,
                order       = 13,

              }--]]

      }

    }

  }

}

SD2.Preset = {

  profile = {

    ["Latency"] = false,
    ["Silent"] = false,
    ["Escape"] = true,

  },

  char = {

    minimap = {
      hide = true,
    },

    roll = {
      ["Low"] = 1,
      ["High"] = 100,
      ["AttributeLow"] = 1,
      ["AttributeHigh"] = 100,
      ["Temp"] = 0,
      ["Target"] = "",
      ["DamageInc"] = 0,
      ["DC"] = 0,
      ["Icon"] = 1,
      ["Type"] = 1,
      custom1 = {
        ["Low"] = 1,
        ["High"] = 100,
      },
      custom2 = {
        ["Low"] = 1,
        ["High"] = 100,
      },
      custom3 = {
        ["Low"] = 1,
        ["High"] = 100,
      },
      custom4 = {
        ["Low"] = 1,
        ["High"] = 100,
      },
      custom5 = {
        ["Low"] = 1,
        ["High"] = 100,
      },
    },

    attribute = {

      {
        ["Name"] = "None",
        ["Value"] = 0,
      }

    },

    skill = {},

    statistics = {
      ["HP"] = 10,
      ["MaxHP"] = 10,
      ["MP"] = 0,
      ["MaxMP"] = 0,
      ["Energy"] = 0,
      ["MaxEnergy"] = 0,

    },

  }

}
local skilltable = {["Name"] = "",["Attribute"] = 1,["Modifier"] = 0,["Damage"] = 0,["Def"] = false,["Heal"] = false,["RollType"] = 1,}
local attributetable = {["Name"] = "",["Value"] = 0,["RollType"] = 1,}
for i = 1,40 do
  table.insert(SD2.Preset.char.skill,skilltable)
end
for i = 2,9 do
  table.insert(SD2.Preset.char.attribute,i,attributetable)
end

local testvar1 = "yes"


SD2.Delay = 1
SD2.Recalc = ""
SD2.Roll = 0
SD2.PlayerName = UnitName("Player")
SD2.Locale = GetLocale()
SD2.LocaleTable = {

  ["deDE"] = {
    ["Rolls"] = "würfelt. Ergebnis:"
  },
  ["esES"] = {
    ["Rolls"] = "tira los dados y obtiene"
  },
  ["esMX"] = {
    ["Rolls"] = "tira los dados y obtiene"
  },
  ["frFR"] = {
    ["Rolls"] = "obtient un"
  },
  ["itIT"] = {
    ["Rolls"] = "tira"
  },
  ["ptBR"] = {
    ["Rolls"] = "tira"
  },
  ["enUS"] = {
    ["Rolls"] = "rolls"
  },

}
