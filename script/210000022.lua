--Devoid Companionship
local s,id,o=GetID()
function s.initial_effect(c)
    c:SetUniqueOnField(1,0,210000022)
    Duel.EnableGlobalFlag(GLOBALFLAG_BRAINWASHING_CHECK)

    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,210000022+EFFECT_COUNT_CODE_OATH)
    c:RegisterEffect(e1)

    --card exchange
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS + EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_PHASE + PHASE_STANDBY)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(c210000022.mecon)
    e2:SetTarget(c210000022.extg)
    e2:SetOperation(c210000022.exop)
    c:RegisterEffect(e2)

    --owner return
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_REMOVE_BRAINWASHING)
    e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    c:RegisterEffect(e3)

    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_REMOVE_BRAINWASHING)
    e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e5:SetRange(LOCATION_SZONE)
    e5:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
    c:RegisterEffect(e5)

    --on control-change
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS + EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_CONTROL_CHANGED)
    e4:SetCategory(CATEGORY_DAMAGE)
    e4:SetRange(LOCATION_SZONE)
    e5:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e4:SetTarget(c210000022.damtg)
    e4:SetOperation(c210000022.damop)
    c:RegisterEffect(e4)

    
end


function c210000022.mecon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==Card.GetOwner(e:GetHandler())
end
function c210000022.extg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
        and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,e:GetHandler()) end
end
function c210000022.exop(e,tp,eg,ep,ev,re,r,rp)
    local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
    local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    if g1:GetCount()==0 or g2:GetCount()==0 then return end
    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
    local ag1=g1:Select(tp,1,1,nil)
    local cardtp = ag1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SELECT)
    local ag2=g2:Select(1-tp,1,1,nil)
    local cardenemy = ag2:GetFirst()

    if cardtp:IsSetCard(-13) and cardtp:IsType(TYPE_MONSTER) then
        Duel.SendtoGrave(ag1,REASON_EFFECT)
    else Duel.SendtoHand(ag1,1-tp,REASON_EFFECT)
    end

    if cardenemy:IsSetCard(-13) and cardenemy:IsType(TYPE_MONSTER) then
        Duel.SendtoGrave(ag2,REASON_EFFECT)
    else Duel.SendtoHand(ag2,tp,REASON_EFFECT)
    end
    
    
end



function c210000022.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    return true
end
function c210000022.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Damage(1-Card.GetOwner(e:GetHandler()),1000,REASON_EFFECT) 
end