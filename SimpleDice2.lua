local rollFrame = CreateFrame("Frame")
rollFrame:SetScript("OnEvent",function(self,event,...)
	local arg1 = select(1,...)
	if arg1 then
		local name,roll,minRoll,maxRoll = arg1:match("^(.+) "..SD2.LocaleTable[SD2.Locale]["Rolls"].." (%d+) %((%d+)%-(%d+)%)$")
    minRoll = tonumber(minRoll)
    maxRoll = tonumber(maxRoll)
    --if maxRoll == SD2.db.char.roll["High"] and minRoll == SD2.db.char.roll["Low"] and name == SD2.PlayerName then SD2.Roll = tonumber(roll) end
    --if maxRoll == SD2.db.char.roll["AttributeHigh"] and minRoll == SD2.db.char.roll["AttributeLow"] and name == SD2.PlayerName then SD2.Roll = tonumber(roll) end
    if name == SD2.PlayerName then SD2.Roll = tonumber(roll) end
	end
end)
rollFrame:RegisterEvent("CHAT_MSG_SYSTEM")


local classIcons = {
  ["Warrior"] = "|TInterface\\WorldStateFrame\\ICONS-CLASSES:0:0:0:0:256:256:0:64:0:64|t",
  ["Mage"] = "|TInterface\\WorldStateFrame\\ICONS-CLASSES:0:0:0:0:256:256:64:128:0:64|t",
  ["Rogue"] = "|TInterface\\WorldStateFrame\\ICONS-CLASSES:0:0:0:0:256:256:128:196:0:64|t",
  ["Druid"] = "|TInterface\\WorldStateFrame\\ICONS-CLASSES:0:0:0:0:256:256:196:256:0:64|t",
  ["Hunter"] = "|TInterface\\WorldStateFrame\\ICONS-CLASSES:0:0:0:0:256:256:0:64:64:128|t",
  ["Shaman"] = "|TInterface\\WorldStateFrame\\ICONS-CLASSES:0:0:0:0:256:256:64:128:64:128|t",
  ["Priest"] = "|TInterface\\WorldStateFrame\\ICONS-CLASSES:0:0:0:0:256:256:128:196:64:128|t",
  ["Warlock"] = "|TInterface\\WorldStateFrame\\ICONS-CLASSES:0:0:0:0:256:256:196:256:64:128|t",
  ["Paladin"] = "|TInterface\\WorldStateFrame\\ICONS-CLASSES:0:0:0:0:256:256:0:64:128:196|t",
}

local raidIcons = {"None","Skull","Cross","Square","Moon","Triangle","Diamond","Circle","Star"}

local function getHighestValue(...)
	local Values = {...}
	table.sort(Values)
	return Values[#Values]
end

local rollChoice = {"Default","D4","D5","D6","D10","D12","D15","D20","D100","Custom 1","Custom 2","Custom 3","Custom 4","Custom 5"}

function getSkillOptions()
  for i = 1,20 do
    local NumberText = SD2.NumberTable[i]
    SD2.FirstSkillTable[NumberText] = {
              type        = "group",
              name        = "Skill "..NumberText,
              cmdHidden   = true,
              inline      = true,
              order       = i,
              childGroups = "tree",
              args        = {

                skillname = {
                    name        = "Skill Name",
                    desc        = "The name for your Skill.",
                    type        = "input",
                    set         = function(info, val) SD2.db.char.skill[i]["Name"] = val; end,
                    get         = function(info) return SD2.db.char.skill[i]["Name"]; end,
                    width       = "normal",
                    cmdHidden   = true,
                    order       = 0
                },

                skillmod = {
                    name        = "Modifier",
                    desc        = "The modifier for your Skill.",
                    type        = "input",
                    set         = function(info, val) if val == "" then val = 0 end; SD2.db.char.skill[i]["Modifier"] = tonumber(val); end,
                    get         = function(info) return tostring(SD2.db.char.skill[i]["Modifier"]); end,
                    width       = "half",
                    cmdHidden   = true,
                    order       = 1
                },

                skilldamage = {
                    name        = "Damage",
                    desc        = "The damage for your Skill.",
                    type        = "input",
                    set         = function(info, val) if val == "" then val = 0 end; SD2.db.char.skill[i]["Damage"] = tonumber(val); end,
                    get         = function(info) return tostring(SD2.db.char.skill[i]["Damage"]); end,
                    width       = "half",
                    cmdHidden   = true,
                    order       = 2
                },
								
                attributeselect = {
                    name        = "Attribute",
                    desc        = "The attribute associated with this skill, set to none if your system doesn't use this.",
                    type        = "select",
                    values      = function() local AttribTable = {};
                      for i = 1,#SD2.db.char.attribute do
                        if SD2.db.char.attribute[i]["Name"] ~= ""
                        then table.insert(AttribTable,SD2.db.char.attribute[i]["Name"]) end
                      end;
                      return AttribTable;
                    end,
                    set         = function(info, val) SD2.db.char.skill[i]["Attribute"] = val; end,
                    get         = function(info) return SD2.db.char.skill[i]["Attribute"]; end,
                    width       = "0.75",
                    cmdHidden   = true,
                    order       = 3
                },
				
        				skilldef = {
                    name        = "Defensive",
                    desc        = "Toggle on for damage calculations with defensive skills.",
                    type        = "toggle",
  				          set         = function(info, val) SD2.db.char.skill[i]["Def"] = val; end,
                    get         = function(info) return SD2.db.char.skill[i]["Def"]; end,
                    cmdHidden   = true,
                    order       = 5
                  },

                rollselect = {
                    name        = "Roll Type",
                    desc        = "The type of roll associated with this skill. It defaults to those set in the options tab.",
                    type        = "select",
                    values      = rollChoice,
                    set         = function(info, val) SD2.db.char.skill[i]["RollType"] = val; end,
                    get         = function(info) return SD2.db.char.skill[i]["RollType"]; end,
                    width       = "half",
                    cmdHidden   = true,
                    order       = 4
                },


              }

            }
  end
  
  for i = 21,40 do
    local NumberText = SD2.NumberTable[i]
    SD2.SecondSkillTable[NumberText] = {
              type        = "group",
              name        = "Skill "..NumberText,
              cmdHidden   = true,
              inline      = true,
              order       = i,
              childGroups = "tree",
              args        = {

                skillname = {
                  name        = "Skill Name",
                  desc        = "The name for your Skill.",
                  type        = "input",
                  set         = function(info, val) SD2.db.char.skill[i]["Name"] = val; end,
                  get         = function(info) return SD2.db.char.skill[i]["Name"]; end,
                  width       = "normal",
                  cmdHidden   = true,
                  order       = 0
                },

                skillmod = {
                  name        = "Modifier",
                  desc        = "The modifier for your Skill.",
                  type        = "input",
                  set         = function(info, val) if val == "" then val = 0 end; SD2.db.char.skill[i]["Modifier"] = tonumber(val); end,
                  get         = function(info) return tostring(SD2.db.char.skill[i]["Modifier"]); end,
                  width       = "half",
                  cmdHidden   = true,
                  order       = 1
                },

                skilldamage = {
                  name        = "Damage",
                  desc        = "The damage for your Skill.",
                  type        = "input",
                  set         = function(info, val) if val == "" then val = 0 end; SD2.db.char.skill[i]["Damage"] = tonumber(val); end,
                  get         = function(info) return tostring(SD2.db.char.skill[i]["Damage"]); end,
                  width       = "half",
                  cmdHidden   = true,
                  order       = 2
                },
								
                attributeselect = {
                  name        = "Attribute",
                  desc        = "The attribute associated with this skill, set to none if your system doesn't use this.",
                  type        = "select",
                  values      = function() local AttribTable = {};
                    for i = 1,#SD2.db.char.attribute do
                      if SD2.db.char.attribute[i]["Name"] ~= ""
                      then table.insert(AttribTable,SD2.db.char.attribute[i]["Name"]) end
                    end;
                    return AttribTable;
                  end,
                  set         = function(info, val) SD2.db.char.skill[i]["Attribute"] = val; end,
                  get         = function(info) return SD2.db.char.skill[i]["Attribute"]; end,
                  width       = "0.75",
                  cmdHidden   = true,
                  order       = 3
                },
				
                skilldef = {
                    name        = "Defensive",
                    desc        = "Toggle on for damage calculations with defensive skills.",
                    type        = "toggle",
                    set         = function(info, val) SD2.db.char.skill[i]["Def"] = val; end,
                    get         = function(info) return SD2.db.char.skill[i]["Def"]; end,
                    cmdHidden   = true,
                    order       = 5
                  },

                rollselect = {
                    name        = "Roll Type",
                    desc        = "The type of roll associated with this skill. It defaults to those set in the options tab.",
                    type        = "select",
                    values      = rollChoice,
                    set         = function(info, val) SD2.db.char.skill[i]["RollType"] = val; end,
                    get         = function(info) return SD2.db.char.skill[i]["RollType"]; end,
                    width       = "half",
                    cmdHidden   = true,
                    order       = 4
                },

                }

            }
  end  
  
end

function getAttributeOptions()
  for i = 2,9 do
    local NumberText = SD2.NumberTable[i-1]
    SD2.FullAttributeTable[NumberText] = {
        type        = "group",
        name        = "Attribute "..NumberText,
        cmdHidden   = true,
        inline      = true,
        order       = i,
        childGroups = "tree",
        args        = {

          attributename = {
            name        = "Attribute Name",
            desc        = "The name for your Attribute.",
            type        = "input",
            set         = function(info, val) SD2.db.char.attribute[i]["Name"] = val; end,
            get         = function(info) return SD2.db.char.attribute[i]["Name"]; end,
            width       = "normal",
            cmdHidden   = true,
            order       = 0
          },

          attributevalue = {
            name        = "Attribute Modifier",
            desc        = "The modifier value for your attribute.",
            type        = "input",
            set         = function(info, val) if val == "" then val = 0 end  SD2.db.char.attribute[i]["Value"] = tonumber(val); end,
            get         = function(info) return tostring(SD2.db.char.attribute[i]["Value"]); end,
            width       = "half",
            cmdHidden   = true,
            order       = 1
          },

          rollselect = {
                    name        = "Roll Type",
                    desc        = "The type of roll associated with this attribute. It defaults to those set in the options tab.",
                    type        = "select",
                    values      = rollChoice,
                    set         = function(info, val) SD2.db.char.attribute[i]["RollType"] = val; end,
                    get         = function(info) return SD2.db.char.attribute[i]["RollType"]; end,
                    width       = "half",
                    cmdHidden   = true,
                    order       = 4
                },

        }

      }
  end
end


local function getRollType(Skill)
  local RollUpper = 100
  local RollLower = 1
  local Type = SD2.db.char.skill[Skill]["RollType"]
  if Type == 1 then
    RollUpper = SD2.db.char.roll["High"]   
    RollLower = SD2.db.char.roll["Low"]      
  elseif Type == 2 then
    RollUpper = 4
    RollLower = 1
  elseif Type == 3 then
    RollUpper = 5
    RollLower = 1    
  elseif Type == 4 then
    RollUpper = 6
    RollLower = 1  
  elseif Type == 5 then
    RollUpper = 10
    RollLower = 1  
  elseif Type == 6 then
    RollUpper = 12
    RollLower = 1  
  elseif Type == 7 then
    RollUpper = 15
    RollLower = 1  
  elseif Type == 8 then
    RollUpper = 20
    RollLower = 1  
  elseif Type == 9 then
    RollUpper = 100
    RollLower = 1  
  elseif Type == 10 then
    RollUpper = SD2.db.char.roll.custom1["High"]
    RollLower = SD2.db.char.roll.custom1["Low"]  
  elseif Type == 11 then
    RollUpper = SD2.db.char.roll.custom2["High"]
    RollLower = SD2.db.char.roll.custom2["Low"]  
  elseif Type == 12 then
    RollUpper = SD2.db.char.roll.custom3["High"]
    RollLower = SD2.db.char.roll.custom3["Low"]  
  elseif Type == 13 then
    RollUpper = SD2.db.char.roll.custom4["High"]
    RollLower = SD2.db.char.roll.custom4["Low"]  
  elseif Type == 13 then
    RollUpper = SD2.db.char.roll.custom5["High"]
    RollLower = SD2.db.char.roll.custom5["Low"]  
  end
  return RollUpper,RollLower
end

local function getAttributeRollType(Skill)
  local RollUpper = 100
  local RollLower = 1
  local Type = SD2.db.char.attribute[Skill]["RollType"]
  if Type == 1 then
    RollUpper = SD2.db.char.roll["AttributeHigh"]  
    RollLower = SD2.db.char.roll["AttributeLow"]     
  elseif Type == 2 then
    RollUpper = 4
    RollLower = 1
  elseif Type == 3 then
    RollUpper = 5
    RollLower = 1    
  elseif Type == 4 then
    RollUpper = 6
    RollLower = 1  
  elseif Type == 5 then
    RollUpper = 10
    RollLower = 1  
  elseif Type == 6 then
    RollUpper = 12
    RollLower = 1  
  elseif Type == 7 then
    RollUpper = 15
    RollLower = 1  
  elseif Type == 8 then
    RollUpper = 20
    RollLower = 1  
  elseif Type == 9 then
    RollUpper = 100
    RollLower = 1  
  elseif Type == 10 then
    RollUpper = SD2.db.char.roll.custom1["High"]
    RollLower = SD2.db.char.roll.custom1["Low"]  
  elseif Type == 11 then
    RollUpper = SD2.db.char.roll.custom2["High"]
    RollLower = SD2.db.char.roll.custom2["Low"]  
  elseif Type == 12 then
    RollUpper = SD2.db.char.roll.custom3["High"]
    RollLower = SD2.db.char.roll.custom3["Low"]  
  elseif Type == 13 then
    RollUpper = SD2.db.char.roll.custom4["High"]
    RollLower = SD2.db.char.roll.custom4["Low"]  
  elseif Type == 13 then
    RollUpper = SD2.db.char.roll.custom5["High"]
    RollLower = SD2.db.char.roll.custom5["Low"]  
  end
  return RollUpper,RollLower
end

local function getPassFail(Total)
  local Outcome = ""
  if SD2.db.char.roll["DC"] == 0 then return Outcome end
  if Total >= SD2.db.char.roll["DC"] then Outcome = "Pass" end
  if Total < SD2.db.char.roll["DC"] then Outcome = "Fail" end
  return string.format("[%s on DC:%s] ",Outcome,SD2.db.char.roll["DC"]), Outcome
end

local function getDamage(damage,target,PF,totalRoll,Def,Crit)
	local totalDamage = damage
	local doubleDamage = ""
	if Def and PF == "Pass" then return "" end
	if Def and PF == "Fail" then 
		if SD2.db.char.roll["DamageInc"] > 0 then
			totalDamage = math.ceil((SD2.db.char.roll["DC"] - totalRoll)/SD2.db.char.roll["DamageInc"])*damage
		end
		return string.format("(-%dHP)",totalDamage)
	end
	if PF == "Fail" or damage == 0 or target == "" then return "" end
	if SD2.db.char.roll["DamageInc"] > 0 then
			totalDamage = damage + (math.floor((totalRoll - SD2.db.char.roll["DC"])/SD2.db.char.roll["DamageInc"]))*damage
	end
	if SD2.db.profile["DblDmg"] then totalDamage = totalDamage * 2; doubleDamage = "[Doubled Damage]" end
  if crit then totalDamage = totalDamage * 2 end
	return string.format("(%d damage%s)%s",totalDamage,target,doubleDamage)
end

local function getTargetString()
  local icon = SD2.db.char.roll["Icon"]
	if SD2.db.char.roll["Target"] == "" and SD2.db.char.roll["Icon"] == 1 then return "" 
  elseif SD2.db.char.roll["Target"] ~= "" and SD2.db.char.roll["Icon"] == 1 then return " on "..SD2.db.char.roll["Target"]
  elseif SD2.db.char.roll["Target"] == "" and SD2.db.char.roll["Icon"] > 1 then return " on {"..raidIcons[icon].."}"
  elseif SD2.db.char.roll["Target"] ~= "" and SD2.db.char.roll["Icon"] > 1 then return " on {"..raidIcons[icon].."} "..SD2.db.char.roll["Target"]
  end
  return ""
	
end

local function formatModifier(modifier)
  if modifier == 0 then return "" end;
  if modifier < 0 then return modifier end;
  return string.format("+%i", modifier);
end

local function formatAttribute(attribute)
  if attribute == "None" then return "" end
  return "("..attribute..")"
end

local function formatRollOutput(roll, totalRoll, skill, attribute, temp)
	if roll == totalRoll then return roll end
	return string.format("%s%s%s%s=%s",roll,skill,attribute,temp,totalRoll)
end

local function formatOutputMessage(reCalc, skillName, abType, target, dcCheck, output, damage, crit, crittype)
  if crit == true then 
    return string.format("%sRolling %s%s%s. %s%s(%s)%s",reCalc,skillName,abType,target,dcCheck,crittype,output,damage) 
  end
	return string.format("%sRolling %s%s%s. %s(%s)%s",reCalc,skillName,abType,target,dcCheck,output,damage)
end

local function SendOutputMessage(Message)
	if SD2.db.profile["Silent"] then
		SELECTED_CHAT_FRAME:AddMessage(Message);
		return;
	end
	if IsInRaid() then
		SendChatMessage(Message, "RAID");
		return;
	end;
	if IsInGroup(LE_PARTY_CATEGORY_HOME) then
		SendChatMessage(Message, "PARTY");
		return;
	end;
	SELECTED_CHAT_FRAME:AddMessage(Message);
end

local function roll(Type,Number)
  local RollUpper = SD2.db.char.roll["High"]
  local RollLower = SD2.db.char.roll["Low"]
  if IsModifierKeyDown() then
    SD2.Recalc = "[ReCalc]"
    SD2.Roll = SD2.Roll
  else
    SD2.Recalc = ""
    if Type == "Attribute" then
      local RollUpper,RollLower = getAttributeRollType(Number)
      RandomRoll(RollLower, RollUpper)
    else 
      local RollUpper,RollLower = getRollType(Number)
      RandomRoll(RollLower, RollUpper)
    end
  end
end

local function minSkillRoll(Type,Number)
	local minRoll = SD2.db.char.roll["Low"]
	if Type == "Skill" then print("1")
	elseif Type == "Attribute" then print("2")
	end
	SD2.Recalc = ""
	RandomRoll(minRoll, SD2.db.char.roll["High"])
end

local function rollChoice(Type,Number)
	if SD2.db.char.roll["Type"] == 1 then roll(Type,Number) end
	if SD2.db.char.roll["Type"] == 2 then roll(Type,Number) end
  if SD2.db.char.roll["Type"] == 3 then roll(Type,Number) end
end

local function attribCriticalCheck(Roll,AttribValue,Temp,Attribute)
  local Crit = false
  local CritType = ""
  local RollUpper,RollLower = getAttributeRollType(Attribute)   
  if Roll == RollUpper and SD2.db.profile["CritSuccess"] == true then Crit = true; CritType = "[Critical Success!]" return Roll, Crit, CritType end
  if Roll == RollLower and SD2.db.profile["CritFail"] == true then Crit = true; CritType = "[Critical Failure!]" return Roll, Crit, CritType end
  local Total = Roll + AttribValue + Temp
  return Total, Crit, CritType
end

local function skillCriticalCheck(Roll,Modifier,Attribute,Temp,Skill)
  local Crit = false
  local CritType = ""
  local RollUpper,RollLower = getRollType(Skill)  
  if Roll == RollUpper and SD2.db.profile["CritSuccess"] == true then Crit = true; CritType = "[Critical Success!]" return Roll, Crit, CritType end
  if Roll == RollLower and SD2.db.profile["CritFail"] == true then Crit = true; CritType = "[Critical Failure!]" return Roll, Crit, CritType end
  local Total = Roll + Modifier + Attribute + Temp
  return Total, Crit, CritType
end


local function attributeCalculation(Attribute)
  local AttribName, AttribValue, Temp = SD2.db.char.attribute[Attribute]["Name"], SD2.db.char.attribute[Attribute]["Value"], SD2.db.char.roll["Temp"]
  local Target = getTargetString()
  local TotalRoll, Crit, CritType = attribCriticalCheck(SD2.Roll,AttribValue,Temp,Attribute)
  local Outcome = getPassFail(TotalRoll)
  local TempText = formatModifier(Temp)
  local AttribText = formatModifier(AttribValue)
  local AttribType = formatAttribute(AttribName)
  local OutputRoll = formatRollOutput(SD2.Roll, TotalRoll, "", AttribText, TempText)
  local OutputMessage = formatOutputMessage(SD2.Recalc,AttribName,"",Target,Outcome,OutputRoll,"",Crit,CritType)
  SendOutputMessage(OutputMessage)
end

local function skillCalculation(Skill)
  local AttribName, AttribValue = SD2.db.char.attribute[SD2.db.char.skill[Skill]["Attribute"]]["Name"],SD2.db.char.attribute[SD2.db.char.skill[Skill]["Attribute"]]["Value"]
  local Name, Modifier, Damage, Def, Temp = SD2.db.char.skill[Skill]["Name"], SD2.db.char.skill[Skill]["Modifier"], SD2.db.char.skill[Skill]["Damage"], SD2.db.char.skill[Skill]["Def"], SD2.db.char.roll["Temp"]
  local Target = getTargetString()
  local TotalRoll, Crit, CritType = skillCriticalCheck(SD2.Roll,Modifier,AttribValue,Temp,Skill)
  local Outcome, PF = getPassFail(TotalRoll)
  local DamageText = getDamage(Damage,Target,PF,TotalRoll,Def,Crit)
  local ModifierText = formatModifier(Modifier)
  local TempText = formatModifier(Temp)
  local AttribText = formatModifier(AttribValue)
  local AttribType = formatAttribute(AttribName)
  local OutputRoll = formatRollOutput(SD2.Roll, TotalRoll, ModifierText, AttribText, TempText)
  local OutputMessage = formatOutputMessage(SD2.Recalc,Name,AttribType,Target,Outcome,OutputRoll,DamageText,Crit,CritType)
  SendOutputMessage(OutputMessage)
end


local function getIscariPassFail(Total,Def,Crit)
  local Outcome = ""
  --if SD2.db.char.roll["DC"] == 0 then return Outcome end
  if Def then
    if Total == 1 and Crit then Outcome = "Natural 1! [Special Event!]"
    elseif Total == 20 and Crit then Outcome = "Natural 20! [Special Event!]"
    elseif Total <= 5 then Outcome = "Rolled "..Total..". Fail (-6HP)."
    elseif Total <= 10 then Outcome = "Rolled "..Total..". Fail (-2HP)."
    elseif Total <= 16 then Outcome = "Rolled "..Total..". Pass (No Damage)."
    elseif Total >= 17 then Outcome = "Rolled "..Total..". Pass. (Counter 1 Damage or Save Someone)"
    end
  else
    if Total == 1 and Crit then Outcome = "Natural 1! [Special Event!]"
    elseif Total == 20 and Crit then Outcome = "Natural 20! [Special Event!]"
    elseif Total <= 5 then Outcome = "Rolled "..Total..". Fail (Miss)."
    elseif Total <= 10 then Outcome = "Rolled "..Total..". Pass (1 Damage/2HP Heal)."
    elseif Total <= 16 then Outcome = "Rolled "..Total..". Pass (3 Damage/5HP Heal)."
    elseif Total >= 17 then Outcome = "Rolled "..Total..". Pass. (5 Damage/8HP Heal)"
    end
  end
  return Outcome
  --if Total >= SD2.db.char.roll["DC"] then Outcome = "Pass" end
  --if Total < SD2.db.char.roll["DC"] then Outcome = "Fail" end
  --return string.format("[%s on DC:%s] ",Outcome,SD2.db.char.roll["DC"]), Outcome
end

local function iscariaAttributeCalculation(Attribute)
  local AttribName, AttribValue, Temp = SD2.db.char.attribute[Attribute]["Name"], SD2.db.char.attribute[Attribute]["Value"], SD2.db.char.roll["Temp"]
  local Target = getTargetString()
  local TotalRoll, Crit, CritType = attribCriticalCheck(SD2.Roll,AttribValue,Temp,Attribute)
  local Outcome = getIscariPassFail(TotalRoll,Def,Crit)
  local TempText = formatModifier(Temp)
  local AttribText = formatModifier(AttribValue)
  local AttribType = formatAttribute(AttribName)
  local OutputRoll = formatRollOutput(SD2.Roll, TotalRoll, "", AttribText, TempText)
  local OutputMessage = formatOutputMessage(SD2.Recalc,AttribName,"",Target,Outcome,OutputRoll,"",Crit,CritType)
  SendOutputMessage(OutputMessage)
end

local function iscariaSkillCalculation(Skill)
  local AttribName, AttribValue = SD2.db.char.attribute[SD2.db.char.skill[Skill]["Attribute"]]["Name"],SD2.db.char.attribute[SD2.db.char.skill[Skill]["Attribute"]]["Value"]
  local Name, Modifier, Damage, Def, Temp = SD2.db.char.skill[Skill]["Name"], SD2.db.char.skill[Skill]["Modifier"], SD2.db.char.skill[Skill]["Damage"], SD2.db.char.skill[Skill]["Def"], SD2.db.char.roll["Temp"]
  local Target = getTargetString()
  local TotalRoll, Crit, CritType = skillCriticalCheck(SD2.Roll,Modifier,AttribValue,Temp,Skill)
  local Outcome, PF = getIscariPassFail(TotalRoll,Def,Crit)
  local DamageText = ""
  local ModifierText = formatModifier(Modifier)
  local TempText = formatModifier(Temp)
  local AttribText = formatModifier(AttribValue)
  local AttribType = formatAttribute(AttribName)
  local OutputRoll = formatRollOutput(SD2.Roll, TotalRoll, ModifierText, AttribText, TempText)
  local OutputMessage = formatOutputMessage(SD2.Recalc,Name,AttribType,Target,Outcome,OutputRoll,DamageText,Crit,CritType)
  SendOutputMessage(OutputMessage)
end

local function getSuccessPassFail(TotalRoll,DC)
  if TotalRoll >= DC then return "Pass" else return "Fail" end
end

local function formatSuccessRollOutput(roll, totalRoll, skill, attribute, temp)
  if totalRoll == roll then return roll end
  return string.format("%s%s=%s",roll,temp,totalRoll)
end 

local function formatSuccessOutputMessage(reCalc, skillName, abType, target, dcCheck, output, damage, DC)
  return string.format("%sRolling %s%s%s. %s on DC%s(Roll %s)%s",reCalc,skillName,abType,target,dcCheck,DC,output,damage)
end

local function minimumAttributeCalculation(Attribute)
  local AttribName, AttribValue, Temp = SD2.db.char.attribute[Attribute]["Name"], SD2.db.char.attribute[Attribute]["Value"], SD2.db.char.roll["Temp"]
  local Target = getTargetString()
  local TotalRoll = SD2.Roll + Temp
  local DC = AttribValue 
  local Outcome = getSuccessPassFail(TotalRoll,DC)
  local TempText = formatModifier(Temp)
  local AttribText = formatModifier(AttribValue)
  local AttribType = formatAttribute(AttribName)
  local OutputRoll = formatSuccessRollOutput(SD2.Roll, TotalRoll, "", AttribText, TempText)
  local OutputMessage = formatSuccessOutputMessage(SD2.Recalc,AttribName,"",Target,Outcome,OutputRoll,"",DC)
  SendOutputMessage(OutputMessage)
end

local function minimumSkillCalculation(Skill)
  local AttribName, AttribValue = SD2.db.char.attribute[SD2.db.char.skill[Skill]["Attribute"]]["Name"],SD2.db.char.attribute[SD2.db.char.skill[Skill]["Attribute"]]["Value"]
  local Name, Modifier, Damage, Def, Temp = SD2.db.char.skill[Skill]["Name"], SD2.db.char.skill[Skill]["Modifier"], SD2.db.char.skill[Skill]["Damage"], SD2.db.char.skill[Skill]["Def"], SD2.db.char.roll["Temp"]
  local Target = getTargetString()
  local TotalRoll = SD2.Roll + Temp
  local DC = Modifier 
  local Outcome = getSuccessPassFail(TotalRoll,DC)
  local DamageText = getDamage(Damage,Target,Outcome,TotalRoll,Def)
  local TempText = formatModifier(Temp)
  local AttribText = formatModifier(AttribValue)
  local AttribType = formatAttribute(Name)
  local OutputRoll = formatSuccessRollOutput(SD2.Roll, TotalRoll, "", AttribText, TempText)
  local OutputMessage = formatSuccessOutputMessage(SD2.Recalc,Name,AttribType,Target,Outcome,OutputRoll,DamageText,DC)
  SendOutputMessage(OutputMessage)
end

local function disableButtons(type,value,status)
	local value = tonumber(value)
	if type == "Skill" then
		if value <= 20 then
			for i = 1,20 do
				if SD2.db.char.skill[i]["Name"] ~= "" then
				SD2.skillButton[i]:SetDisabled(status)
				end
			end
		else
			for i = 21,40 do
				if SD2.db.char.skill[i]["Name"] ~= "" then
				SD2.skillButton[i]:SetDisabled(status)
				end
			end
		end
	elseif type == "Attribute" then
		for i = 2,9 do
	    if SD2.db.char.attribute[i]["Name"] ~= "" then
	      SD2.attributeButton[i]:SetDisabled(status)
			end
		end
	end
end

local function getLatency()
	local delay = 1
	local bandwidthIn, bandwidthOut, latencyHome, latencyWorld = GetNetStats()
	if latencyHome > latencyWorld then delay = delay + (latencyHome/1000) else delay = delay + (latencyWorld/1000) end
	if SD2.db.profile["Latency"] then return delay + 1.5 end
	return delay
end

local function rollClick(Type,Number)
	SD2.Delay = getLatency()
	disableButtons(Type,Number,true)
  rollChoice(Type,Number)
  C_Timer.After(SD2.Delay, function()
    if SD2.db.char.roll["Type"] == 1 then
      if Type == "Skill" then skillCalculation(Number) end
      if Type == "Attribute" then attributeCalculation(Number) end
    elseif SD2.db.char.roll["Type"] == 2 then
      if Type == "Skill" then minimumSkillCalculation(Number) end
      if Type == "Attribute" then minimumAttributeCalculation(Number) end
    elseif SD2.db.char.roll["Type"] == 3 then
      if Type == "Skill" then iscariaSkillCalculation(Number) end
      if Type == "Attribute" then iscariaAttributeCalculation(Number) end
    end
		disableButtons(Type,Number,false)
  end)
end

local statGroup = {}
local function statisticsButtons(container, stat)
  statGroup[stat] = {}
  local maxstat = "Max"..stat

  statGroup[stat]["group"] = SD2GUI:Create("SimpleGroup")
  statGroup[stat]["group"]:SetLayout("Flow")
  statGroup[stat]["group"]:SetFullWidth(true)

  statGroup[stat]["label"] = SD2GUI:Create("Label")
  statGroup[stat]["label"]:SetText("  "..stat..": "..SD2.db.char.statistics[stat])
  statGroup[stat]["label"]:SetWidth(65)

  statGroup[stat]["sub"] = SD2GUI:Create("Button")
  statGroup[stat]["sub"]:SetText("-")
  statGroup[stat]["sub"]:SetWidth(40)
  statGroup[stat]["sub"]:SetCallback("OnClick", function()
    if IsShiftKeyDown() then
      SD2.db.char.statistics[stat] = SD2.db.char.statistics[stat] - 5
    elseif IsControlKeyDown() then
      SD2.db.char.statistics[stat] = SD2.db.char.statistics[stat] - 10
    else
      SD2.db.char.statistics[stat] = SD2.db.char.statistics[stat] - 1
    end
    if SD2.db.char.statistics[stat] < 0 then SD2.db.char.statistics[stat] = 0 end
    statGroup[stat]["label"]:SetText("  "..stat..": "..SD2.db.char.statistics[stat])
  end)

  statGroup[stat]["add"] = SD2GUI:Create("Button")
  statGroup[stat]["add"]:SetText("+")
  statGroup[stat]["add"]:SetWidth(40)
  statGroup[stat]["add"]:SetCallback("OnClick", function()
    if IsShiftKeyDown() then
      SD2.db.char.statistics[stat] = SD2.db.char.statistics[stat] + 5
    elseif IsControlKeyDown() then
      SD2.db.char.statistics[stat] = SD2.db.char.statistics[stat] + 10
    else
      SD2.db.char.statistics[stat] = SD2.db.char.statistics[stat] + 1
    end
    if SD2.db.char.statistics[stat] > SD2.db.char.statistics[maxstat] then SD2.db.char.statistics[stat] = SD2.db.char.statistics[maxstat] end
    statGroup[stat]["label"]:SetText("  "..stat..": "..SD2.db.char.statistics[stat])
  end)

  container:AddChild(statGroup[stat]["group"])
  statGroup[stat]["group"]:AddChild(statGroup[stat]["sub"])
  statGroup[stat]["group"]:AddChild(statGroup[stat]["label"])
  statGroup[stat]["group"]:AddChild(statGroup[stat]["add"])
end

local function statisticsGroup(container)
  if SD2.db.char.statistics["MaxHP"] > 0 then statisticsButtons(container,"HP") end
  if SD2.db.char.statistics["MaxMP"] > 0 then statisticsButtons(container,"MP") end
  if SD2.db.char.statistics["MaxEnergy"] > 0 then statisticsButtons(container,"Energy") end
end

local function attributeGroup(container)
  SD2.attributeButton = {}
  for i = 2,9 do
    if SD2.db.char.attribute[i]["Name"] ~= "" then
      SD2.attributeButton[i] = SD2GUI:Create("Button")
      SD2.attributeButton[i]:SetText(SD2.db.char.attribute[i]["Name"])
      SD2.attributeButton[i]:SetRelativeWidth(0.5)
      SD2.attributeButton[i]:SetCallback("OnClick", function() rollClick("Attribute",i) end)
      container:AddChild(SD2.attributeButton[i])
    end
  end
end


local function skillGroup(container)
  SD2.skillButton = {}
  for i = 1,20 do
    if SD2.db.char.skill[i]["Name"] ~= "" then
      SD2.skillButton[i] = SD2GUI:Create("Button")
      SD2.skillButton[i]:SetText(SD2.db.char.skill[i]["Name"])
      SD2.skillButton[i]:SetRelativeWidth(0.5)
      SD2.skillButton[i]:SetCallback("OnClick", function() rollClick("Skill",i) end)
      container:AddChild(SD2.skillButton[i])
    end
  end
end

local function secondskillGroup(container)
  SD2.skillButton = {}
  for i = 21,40 do
    if SD2.db.char.skill[i]["Name"] ~= "" then
      SD2.skillButton[i] = SD2GUI:Create("Button")
      SD2.skillButton[i]:SetText(SD2.db.char.skill[i]["Name"])
      SD2.skillButton[i]:SetRelativeWidth(0.5)
      SD2.skillButton[i]:SetCallback("OnClick", function() rollClick("Skill",i) end)
      container:AddChild(SD2.skillButton[i])
    end
  end
end

local function SelectGroup(container, event, group)
  container:ReleaseChildren()
  if group == "attrib" then
    attributeGroup(container)
  elseif group == "skill" then
    skillGroup(container)
  elseif group == "secondskill" then
    secondskillGroup(container)
  elseif group == "stats" then
    statisticsGroup(container)
  end
end

local function rollPanel()
  if SD2.mainWindow then
    SD2.mainWindow:Hide()
    SD2.mainWindow = nil
  else

    local mainHeight = 260
    local primary = 0
    local secondary = -7
    local attribute = 0
  	local count = 0
    local SSkillsEnable = true
      for i = 7,8 do
        if SD2.db.char.attribute[i]["Name"] ~= "" then
          attribute = attribute + 1
        end
      end
      for i = 7,20 do
        if SD2.db.char.skill[i]["Name"] ~= "" then
          primary = primary + 1
        end
      end
      for i = 20,40 do
        if SD2.db.char.skill[i]["Name"] ~= "" then
          secondary = secondary + 1
          SSkillsEnable = false 
        end
      end

  	local count = getHighestValue(primary,secondary,attribute)
    local totalCount = math.ceil(count/2)
    mainHeight = mainHeight + (totalCount * 26)

    SD2.mainWindow = SD2GUI:Create("Window")
    SD2.mainWindow:SetTitle("Simple Dice 2")
    SD2.mainWindow:SetCallback("OnClose", function(widget) SD2GUI:Release(widget) SD2.mainWindow = nil end)
    SD2.mainWindow:SetLayout("Flow")
    SD2.mainWindow:SetWidth(340)
    SD2.mainWindow:SetHeight(mainHeight)
    SD2.mainWindow:SetAutoAdjustHeight(true)
    SD2.mainWindow:EnableResize(false)

    SD2.escapeFrame = CreateFrame("Frame")
    SD2.escapeFrame:EnableKeyboard(true)
    SD2.escapeFrame:SetFrameStrata("DIALOG")
    SD2.escapeFrame:SetPropagateKeyboardInput(true)
    SD2.escapeFrame:SetScript("OnKeyDown", function(self, key) if key == "ESCAPE" and SD2.mainWindow and SD2.db.profile["Escape"] then SD2.mainWindow:Hide() SD2.mainWindow = nil end end)

    local targetIcon = SD2GUI:Create("Dropdown")
    --targetIcon:SetText(SD2.db.char.roll["Icon"])
    targetIcon:SetList({"None","Skull","Cross","Square","Moon","Triangle","Diamond","Circle","Star"})
    targetIcon:SetValue(SD2.db.char.roll["Icon"])
    targetIcon:SetWidth(70)
    targetIcon:SetLabel("Icon:")
    --targetIcon:DisableButton(true)
    targetIcon:SetCallback("OnValueChanged", function(info, callback, val) if val == "" then val = 0 end; SD2.db.char.roll["Icon"] = tonumber(val); end)
    SD2.mainWindow:AddChild(targetIcon)

    local targetBox = SD2GUI:Create("EditBox")
    targetBox:SetText(SD2.db.char.roll["Target"])
    targetBox:SetWidth(130)
    targetBox:SetLabel("Target:")
    targetBox:DisableButton(true)
    targetBox:SetCallback("OnTextChanged", function(info, callback, val) SD2.db.char.roll["Target"] = val end)
    SD2.mainWindow:AddChild(targetBox)

    local dcBox = SD2GUI:Create("EditBox")
    dcBox:SetText(SD2.db.char.roll["DC"])
    dcBox:SetWidth(40)
    dcBox:SetLabel("DC:")
    dcBox:DisableButton(true)
    dcBox:SetCallback("OnTextChanged", function(info, callback, val) if val == "" then val = 0 end; SD2.db.char.roll["DC"] = tonumber(val); end)
    SD2.mainWindow:AddChild(dcBox)

    local tempBox = SD2GUI:Create("EditBox")
    tempBox:SetText(SD2.db.char.roll["Temp"])
    tempBox:SetWidth(55)
    tempBox:SetLabel("Temp Mod:")
    tempBox:DisableButton(true)
    tempBox:SetCallback("OnTextChanged", function(info, callback, val) if val == "" then val = 0 end; SD2.db.char.roll["Temp"] = tonumber(val) end)
    SD2.mainWindow:AddChild(tempBox)
	
    local doubleBox = SD2GUI:Create("CheckBox")
    doubleBox:SetValue(SD2.db.profile["DblDmg"])
    doubleBox:SetWidth(105)
    doubleBox:SetLabel("Double Damage")
    doubleBox:SetCallback("OnValueChanged", function(info, callback, val) SD2.db.profile["DblDmg"] = val; end)
    SD2.mainWindow:AddChild(doubleBox)

    local skillWindow = SD2GUI:Create("SimpleGroup")
    skillWindow:SetLayout("Flow")
    skillWindow:SetFullWidth(true)
    skillWindow:SetFullHeight(true)
    SD2.mainWindow:AddChild(skillWindow)
	
    local tab = SD2GUI:Create("TabGroup")
    tab:SetLayout("Flow")
    tab:SetFullWidth(true)
    tab:SetTabs({{text="Stats", value="stats"}, {text="Attributes", value="attrib"}, {text="P. Skills", value="skill"}, {text="S. Skills", value="secondskill", disabled=SSkillsEnable}})
    tab:SetCallback("OnGroupSelected", SelectGroup)
    tab:SelectTab("stats")
    skillWindow:AddChild(tab)

  end
end

SD2.LDBTable = {
	type = "data source",
	text = "Simple Dice 2",
	icon = "Interface\\Icons\\INV_Misc_Dice_01",
	OnClick = function(self, button)
    if button == "RightButton" then
      InterfaceOptionsFrame_OpenToCategory("Simple Dice 2.0")
    else
      rollPanel()
    end
  end,
}

local SD2LDB = LibStub("LibDataBroker-1.1"):NewDataObject("Simple Dice 2", SD2.LDBTable)

function SD2:OnInitialize()
  -- Code that you want to run when the addon is first loaded goes here.
  self.db = LibStub("AceDB-3.0"):New("SD2DB", self.Preset);
  if self.db.profile.optionA then
      self.db.profile.playerName = UnitName("player")
  end
  getSkillOptions() getAttributeOptions();
  self.ConfigRegistry = LibStub("AceConfig-3.0"):RegisterOptionsTable("SD2", self.Options);
  self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("SD2", "Simple Dice 2.0");
  SD2Icon:Register("Simple Dice 2", SD2LDB, self.db.char.minimap);
	function ResetSD2Profile()
		self.db:ResetDB();
	end
--[[  function ImportSD2Profile(imp)
    local import = SD2:Deserialize(imp)
    if import["header"] ~= "Simple Dice 2 Export" or not success then 
      --return "Error: Incorrect import Data." 
      print("Error: Incorrect import Data." )
    else
      for i = 1,8 do
        if import.attributes[i]["Name"] ~= "" then
          table.insert(SD2.db.char.attribute[i]["Name"],import.attributes[i]["Name"])
        end
      end
      for i = 1,40 do
        if import.skills[i]["Name"] ~= "" then
          table.insert(SD2.db.char.skills[i]["Name"],import.skills[i]["Name"])
          table.insert(SD2.db.char.skills[i]["Damage"],import.skills[i]["Damage"])
          table.insert(SD2.db.char.skills[i]["Attribute"],import.skills[i]["Attribute"])
          table.insert(SD2.db.char.skills[i]["Def"],import.skills[i]["Def"])
        end
      end
    end

  end
  function ExportSD2Profile()
    local export = {
      header = "Simple Dice 2 Export",
      attributes = {},
      skills = {}
    }
    for i = 1,8 do
      if SD2.db.char.attribute[i]["Name"] ~= "" then
        table.insert(export.attributes[i]["Name"],SD2.db.char.attribute[i]["Name"])
      end
    end
    for i = 1,40 do
      if SD2.db.char.skill[i]["Name"] ~= "" then
        table.insert(export.skills[i]["Name"],SD2.db.char.skills[i]["Name"])
        table.insert(export.skills[i]["Damage"],SD2.db.char.skills[i]["Damage"])
        table.insert(export.skills[i]["Attribute"],SD2.db.char.skills[i]["Attribute"])
        table.insert(export.skills[i]["Def"],SD2.db.char.skills[i]["Def"])
      end
    end
    return SD2:Serialize(export)
  end--]]
end

function SD2:OnEnable()
    -- Called when the addon is enabled
end

function SD2:OnDisable()
    -- Called when the addon is disabled
end

SD2:RegisterChatCommand("SimpleDice",rollPanel)
SD2:RegisterChatCommand("SD",rollPanel)
SD2:RegisterChatCommand("SD2",rollPanel)


function SD2_OnAddonCompartmentClick(addonName, button)
    if button == "RightButton" then
      InterfaceOptionsFrame_OpenToCategory("Simple Dice 2.0")
    else
      rollPanel()
    end
end