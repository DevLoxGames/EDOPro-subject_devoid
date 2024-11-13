--Contrast Devoid
local s,id,o=GetID()
function s.initial_effect(c)
    --Once per turn: Destroy 1 card on the field, then if it was one of your cards: You gain 1000 LP.

    --specific Link Material
    aux.AddLinkProcedure(c,nil,2,2, c210000014.mfilter)
    
    --Link Material banish
    aux.AddFusionProcCode2(c,210000004,210000005,true,true)
    aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_GRAVE,0,Duel.Remove,POS_FACEUP,REASON_COST)

    c:EnableReviveLimit()

    --Subject indes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetTarget(c210000014.indtg)
    e1:SetValue(1)
    c:RegisterEffect(e1)

    --Mandatory Effect
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetCategory(CATEGORY_EQUIP)
    e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c210000014.mecon)
    e2:SetCountLimit(1)
    e2:SetTarget(c210000014.metg)
    e2:SetOperation(c210000014.meop)
    c:RegisterEffect(e2)

    --extra attack
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_EXTRA_ATTACK)
    e3:SetValue(c210000014.raval)
    c:RegisterEffect(e3)

    --must attack
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_MUST_ATTACK)
    c:RegisterEffect(e4)

end

function c210000014.mfilter(g,lc)
    return g:IsExists(Card.IsCode,1,nil,210000004) and g:IsExists(Card.IsCode,1,nil,210000005)
end

function c210000014.indtg(e,c)
    return (c:IsSetCard(-13) and e:GetHandler():GetLinkedGroup():IsContains(c))
end



function c210000014.mecon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c210000014.raval(e,c)
    return c:GetEquipCount()
end





function c210000014.eqfilter(c,tp)
    return c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:IsSetCard(-13) and c:IsType(TYPE_MONSTER)
end
function c210000014.metg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c210000014.eqfilter,tp,LOCATION_DECK,0,1,nil,tp) end
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c210000014.meop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()

    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then 
        return end
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local g=Duel.SelectMatchingCard(tp,c210000014.eqfilter,tp,LOCATION_DECK,0,1,1,tp)
        local tc=g:GetFirst()
        if not Duel.Equip(tp,tc,c) then return end

        --equip limit
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetLabelObject(c)
        e1:SetValue(c210000014.eqlimit)
        tc:RegisterEffect(e1)
        
        
    end
end
function c210000014.eqlimit(e,c)
    return c==e:GetLabelObject()
end
function c210000014.eqcheck(e,tp,eg,ep,ev,re,r,rp)
    if e:GetLabelObject() then e:GetLabelObject():DeleteGroup() end
    local g=e:GetHandler():GetEquipGroup()
    g:KeepAlive()
    e:SetLabelObject(g)
end

