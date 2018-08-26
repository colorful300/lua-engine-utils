--require 'jass.console'.enable=true
local jass = require 'jass.common'
local message = require 'jass.message'

local pointSenderTypeId=2020635763
--xpts
local immediateSenderTypeId=2020177011
--xits
local unitReceiverTypeId=2020570482
--xour
local idReceiverTypeId=2020567410
--xoir

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
local pointTriggerSender=jass.CreateUnit(jass.Player(dummyPlayer),pointSenderTypeId,0.0,0.0,0.0)
jass.ShowUnit(pointTriggerSender,false)
local immediateTriggerSender=jass.CreateUnit(jass.Player(dummyPlayer),immediateSenderTypeId,0.0,0.0,0.0)
jass.ShowUnit(immediateTriggerSender,false)
local orderUnitReceiver=jass.CreateUnit(jass.Player(dummyPlayer),unitReceiverTypeId,0.0,0.0,0.0)
jass.ShowUnit(orderUnitReceiver,false)
local orderIdReceiver=jass.CreateUnit(jass.Player(dummyPlayer),idReceiverTypeId,0.0,0.0,0.0)
jass.ShowUnit(orderIdReceiver,false)

--point sync
local pointTrigger=jass.CreateTrigger()
jass.SetUnitUserData(pointTriggerSender,jass.GetHandleId(pointTrigger))
jass.TriggerAddCondition(pointTrigger,jass.Condition(function()
    local orderUnit=int2Unit(jass.GetUnitUserData(orderUnitReceiver))
    message.order_point(jass.GetUnitUserData(orderIdReceiver),jass.GetUnitX(orderUnit),jass.GetUnitY(orderUnit))
    return false
end))
jass.SetUnitUserData(pointTriggerSender,jass.GetHandleId(pointTrigger))

--event sync
local immediateTrigger=jass.CreateTrigger()
jass.SetUnitUserData(immediateTriggerSender,jass.GetHandleId(immediateTrigger))
jass.TriggerAddCondition(immediateTrigger,jass.Condition(function()
    local orderUnit=int2Unit(jass.GetUnitUserData(orderUnitReceiver))
    message.order_immediate(jass.GetUnitUserData(orderIdReceiver))
    return false
end))
jass.SetUnitUserData(immediateTriggerSender,jass.GetHandleId(immediateTrigger))
