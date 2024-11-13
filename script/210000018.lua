--Guided Devoid
local s,id,o=GetID()
function s.initial_effect(c)
    --Once per turn: Destroy 1 card on the field, then if it was one of your cards: You gain 1000 LP.

    --specific Link Material
    aux.AddLinkProcedure(c,nil,2,2, c210000018.mfilter)
    
    --Link Material banish
    aux.AddFusionProcCode2(c,210000008,210000009,true,true)
    aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_GRAVE,0,Duel.Remove,POS_FACEUP,REASON_COST)

    c:EnableReviveLimit()

    --Subject indes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetTarget(c210000018.indtg)
    e1:SetValue(1)
    c:RegisterEffect(e1)

    --Mandatory Effect
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetCategory(CATEGORY_TODECK)
    e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCost(c210000018.mecost)
    e2:SetCondition(c210000018.mecon)
    e2:SetTarget(c210000018.metg)
    e2:SetOperation(c210000018.meop)
    c:RegisterEffect(e2)

end

function c210000018.mfilter(g,lc)
    return g:IsExists(Card.IsCode,1,nil,210000008) and g:IsExists(Card.IsCode,1,nil,210000009)
end

function c210000018.indtg(e,c)
    return (c:IsSetCard(-13) and e:GetHandler():GetLinkedGroup():IsContains(c))
end



function c210000018.costfilter(c)
    return c:IsCode(210000018)
end

function c210000018.mecost(e,tp,eg,ep,ev,re,r,rp,chk)
    
    local loc=LOCATION_MZONE
    if chk==0 then return Duel.IsExistingMatchingCard(c210000018.costfilter,tp,loc,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local tc=Duel.SelectMatchingCard(tp,c210000018.costfilter,tp,loc,0,1,1,nil):GetFirst()
    Duel.SendtoDeck(tc,tp,SEQ_DECKSHUFFLE,REASON_COST)
end
function c210000018.mecon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c210000018.metg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,1-tp,0,LOCATION_ONFIELD,1,nil) end
    --vielleicht liegt es hieran
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_ONFIELD)
end

function c210000018.meop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c210000018.spfilter,1-tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
    local sc=g:GetFirst()

    Duel.SendtoDeck(sc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
    Duel.ShuffleDeck(1-tp)

end
function c210000018.spfilter(c,e,tp)
    return c:IsAbleToDeck() and c:IsControler(1-tp)
end
