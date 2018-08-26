--require 'jass.console'.enable=true
local jass = require 'jass.common'
local message = require 'jass.message'

local dummyTypeId=2020304249
--xkey
local dummyPlayer=15

--typecast
local table=jass.InitHashtable()

local function int2Trigger(id)
    jass.SaveFogStateHandle(table,0,0,jass.ConvertFogState(id))
    return jass.LoadTriggerHandle(table,0,0)
end

local function int2Unit(id)
    jass.SaveFogStateHandle(table,0,0,jass.ConvertFogState(id))
    return jass.LoadUnitHandle(table,0,0)
end

--init
local keyTypeSender=jass.CreateUnit(jass.Player(dummyPlayer),dummyTypeId,0.0,0.0,0.0)
jass.SetUnitUserData(keyTypeSender, 1954115685)
jass.ShowUnit(keyTypeSender,false)
local keyCodeSender=jass.CreateUnit(jass.Player(dummyPlayer),dummyTypeId,0.0,0.0,0.0)
jass.SetUnitUserData(keyCodeSender, 1668244581)
jass.ShowUnit(keyCodeSender,false)
local triggerReceiver=jass.CreateUnit(jass.Player(dummyPlayer),dummyTypeId,0.0,0.0,0.0)
jass.SetUnitUserData(triggerReceiver, 1953655143)
jass.ShowUnit(triggerReceiver,false)
local triggerHandle=0
local trigger=nil

--keyboard hook
function message.hook(msg)
    if(msg.type=='key_down')then
        jass.SetUnitUserData(keyTypeSender,1)
    elseif(msg.type=='key_up')then
        jass.SetUnitUserData(keyTypeSender,2)
    else
        return true
    end
    jass.SetUnitUserData(keyCodeSender,msg.code)
    if(triggerHandle~=0)then
        jass.TriggerEvaluate(trigger)
    else
        triggerHandle=jass.GetUnitUserData(triggerReceiver)
        if(triggerHandle~=0)then
            trigger=int2Trigger(triggerHandle)
            jass.TriggerEvaluate(trigger)
        end
    end
    return true
end
