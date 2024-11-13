--Devoid Deals
local s,id,o=GetID()
function s.initial_effect(c)

    --All “Subject” monsters sent to the Graveyard are banished afterwards. You can only control 1 “Devoid Deals”. 

    c:SetUniqueOnField(1,0,210000021)

    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,210000021+EFFECT_COUNT_CODE_OATH)
    c:RegisterEffect(e1)
    
    --damage
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS + EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_REMOVE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetOperation(c210000021.damop)
    c:RegisterEffect(e2)

    --damage
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS + EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetOperation(c210000021.damop)
    c:RegisterEffect(e3)

    
    --banish afterwards
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
    e4:SetCode(EFFECT_TO_GRAVE_REDIRECT)
    e4:SetRange(LOCATION_SZONE)
    e4:SetTarget(c210000021.rmtarget)
    e4:SetTargetRange(LOCATION_DECK,LOCATION_DECK,LOCATION_HAND,LOCATION_ONFIELD)
    e4:SetValue(LOCATION_REMOVED)
    c:RegisterEffect(e4)

    --trigger destruction - end phase
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e5:SetCategory(CATEGORY_DRAW + CATEGORY_HANDES)
    e5:SetCode(EVENT_PHASE+PHASE_END)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetRange(LOCATION_SZONE)
    e5:SetCountLimit(1)
    e5:SetTarget(c210000021.ddtg)
    e5:SetOperation(c210000021.ddop)
    c:RegisterEffect(e5)
    


end

function c210000021.damfilter(c,tp)
    return c:GetOwner()==tp or c:GetOwner()==1-tp
end
function c210000021.damop(e,tp,eg,ep,ev,re,r,rp)
    local d=eg:FilterCount(c210000021.damfilter,nil,tp)
    Duel.Damage(1-tp,d*500,REASON_EFFECT,true)
    Duel.Damage(tp,d*300,REASON_EFFECT,true)
    Duel.RDComplete()

    
end



function c210000021.rmtarget(e,c)
    return not c:IsSetCard(-13) and not c:IsSetCard(-15)
end



function c210000021.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    
    local number =  Duel.GetMatchingGroupCount(c210000021.ddfilter,tp,LOCATION_MZONE,0,nil)

    Duel.SetTargetParam(number)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,number)
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,number)
end
function c210000021.ddop(e,tp,eg,ep,ev,re,r,rp)
    local d=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
    if Duel.Draw(tp,d,REASON_EFFECT)>=1 then
        Duel.ShuffleHand(tp)
        Duel.BreakEffect()

        local number = Duel.GetMatchingGroupCount(c210000021.ddfilter,tp,LOCATION_MZONE,0,nil)

        Duel.DiscardHand(tp,nil,number,number,REASON_EFFECT+REASON_DISCARD)
    end
end

function c210000021.ddfilter(c,e,tp)
    return c:IsFaceup() and c:IsSetCard(-13) and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_MZONE)
end