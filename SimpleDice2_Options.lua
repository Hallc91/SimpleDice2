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

    options = {

      type        = "group",
      name        = "Options",
      cmdHidden   = true,
      order       = 4,
      childGroups = "tree",
      args        = {

        diceheader = {
          name       = "Roll Settings",
          type       = "header",
          order      = 0
        },

        dicelow = {

          name        = "Lower Roll Range",
          desc        = "The lower value for your dice rolls.",
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

          name        = "Upper Roll Range",
          desc        = "The upper value for your dice rolls.",
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

        rolltype = {
          name        = "Roll Type",
          desc        = "",
          type        = "select",
          values      = {"Default","Minimum Skill"};
          set         = function(info, val) SD2.db.char.roll["Type"] = val; end,
          get         = function(info) return SD2.db.char.roll["Type"]; end,
          width       = "0.75",
          cmdHidden   = true,
          order       = 4

        },

        optheader = {
            name       = "Options",
            type       = "header",
            order      = 5
          },
		  
          minimap = {
             name        = "Hide Minimap Button",
             desc        = "The upper value for your dice rolls.",
             type        = "toggle",
             set         = function(info, val) SD2.db.char.minimap.hide = val; if val then SD2Icon:Hide("Simple Dice 2") else SD2Icon:Show("Simple Dice 2") end; end,
             get         = function(info) return SD2.db.char.minimap.hide; end,
             cmdHidden   = true,
             order       = 6
           },

           latency = {
              name        = "High Latency Mode",
              desc        = "Enable this if you're suffering from an abnormally high ping. (Typically over 1000)",
              type        = "toggle",
              set         = function(info, val) SD2.db.profile["Latency"] = val; end,
              get         = function(info) return SD2.db.profile["Latency"]; end,
              cmdHidden   = true,
              order       = 7
            },

            silentmode = {
               name        = "Silent Mode",
               desc        = "The Output message will no longer be displayed in party/raid chat even when you're in a party.",
               type        = "toggle",
               set         = function(info, val) SD2.db.profile["Silent"] = val; end,
               get         = function(info) return SD2.db.profile["Silent"]; end,
               cmdHidden   = true,
               order       = 8
             },

             resetheader = {
               name       = "Reset",
               type       = "header",
               order      = 9
             },

             reset = {
                name        = "Reset Database",
                desc        = "Will clear and reset all of your options across every character. NOTHING will be saved.",
                type        = "execute",
                func        = function() ResetSD2Profile() end,
                cmdHidden   = true,
                order       = 10
              },

      }

    }

  }

}

SD2.Preset = {

  profile = {

    ["Latency"] = false,
    ["Silent"] = false,

  },

  char = {

    minimap = {
      hide = false,
    },

    roll = {
      ["Low"] = 1,
      ["High"] = 100,
      ["Temp"] = 0,
      ["Target"] = "",
      ["DamageInc"] = 0,
      ["DC"] = 0,
      ["Type"] = 1
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
local skilltable = {["Name"] = "",["Attribute"] = 1,["Modifier"] = 0,["Damage"] = 0,["Def"] = false}
local attributetable = {["Name"] = "",["Value"] = 0,}
for i = 1,40 do
  table.insert(SD2.Preset.char.skill,skilltable)
end
for i = 2,9 do
  table.insert(SD2.Preset.char.attribute,i,attributetable)
end

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
