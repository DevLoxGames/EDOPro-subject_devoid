--Genesis Devoid
local s,id,o=GetID()
function s.initial_effect(c)

    --specific Link Material
    aux.AddLinkProcedure(c,nil,4,4, c210000019.mfilter)
    
    --Link Material banish
    aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsCode,210000019),c210000019.matfilter,true)
    aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_GRAVE,0,Duel.Remove,POS_FACEUP,REASON_COST)

    c:EnableReviveLimit()

    --cannot attack
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ATTACK)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetTarget(c210000019.catg)
    e1:SetValue(1)
    c:RegisterEffect(e1)

    --attack multiple
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_EXTRA_ATTACK)
    e2:SetValue(c210000019.raval)
    c:RegisterEffect(e2)


    --battle cannot activate
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EFFECT_CANNOT_ACTIVATE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0,1)
    e3:SetValue(1)
    e3:SetCondition(c210000019.actcon)
    c:RegisterEffect(e3)

    

    --Returned Banished
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e4:SetCategory(CATEGORY_TODECK)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetTarget(c210000019.tdtg)
    e4:SetOperation(c210000019.tdop)
    c:RegisterEffect(e4)

    --must attack
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_MUST_ATTACK)
    c:RegisterEffect(e5)


end

function c210000019.catg(e,c)
    return (e:GetHandler():GetLinkedGroup():IsContains(c))
end

function c210000019.matfilter(c)
    return c:IsType(TYPE_LINK) and c:IsSetCard(-15)
end


function c210000019.mfilter(g,lc)
    return (g:IsExists(Card.IsCode,1,nil,210000010) or g:IsExists(Card.IsCode,1,nil,210000011) or g:IsExists(Card.IsCode,1,nil,210000012) or g:IsExists(Card.IsCode,1,nil,210000013) or g:IsExists(Card.IsCode,1,nil,210000014) or g:IsExists(Card.IsCode,1,nil,210000015) or g:IsExists(Card.IsCode,1,nil,210000016) or g:IsExists(Card.IsCode,1,nil,210000017) or g:IsExists(Card.IsCode,1,nil,210000018) or g:IsExists(Card.IsCode,1,nil,210000019))
end


function c210000019.actcon(e)
    return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end



function c210000019.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,PLAYER_ALL,LOCATION_REMOVED)
end
function c210000019.tdop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetFieldGroup(tp,LOCATION_REMOVED,LOCATION_REMOVED)
    Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end

function c210000019.raval(e,c)
    return c:GetLinkedGroupCount()
end

