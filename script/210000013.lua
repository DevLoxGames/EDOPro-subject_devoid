--Enemy Devoid
local s,id,o=GetID()
function s.initial_effect(c)
    --Once per turn: Destroy 1 card on the field, then if it was one of your cards: You gain 1000 LP.

    --specific Link Material
    aux.AddLinkProcedure(c,nil,2,2, c210000013.mfilter)
    
    --Link Material banish
    aux.AddFusionProcCode2(c,210000002,210000003,true,true)
    aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_GRAVE,0,Duel.Remove,POS_FACEUP,REASON_COST)

    c:EnableReviveLimit()

    --Subject indes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetTarget(c210000013.indtg)
    e1:SetValue(1)
    c:RegisterEffect(e1)

    --Mandatory Effect
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetCategory(CATEGORY_TODECK)
    e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(c210000013.mecost)
    e2:SetCondition(c210000013.mecon)
    e2:SetCountLimit(1)
    e2:SetTarget(c210000013.metg)
    e2:SetOperation(c210000013.meop)
    c:RegisterEffect(e2)


end

function c210000013.mfilter(g,lc)
    return g:IsExists(Card.IsCode,1,nil,210000002) and g:IsExists(Card.IsCode,1,nil,210000003)
end

function c210000013.indtg(e,c)
    return (c:IsSetCard(-13) and e:GetHandler():GetLinkedGroup():IsContains(c))
end



function c210000013.mecon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c210000013.costfilter(c)
    return c:IsAbleToGraveAsCost() and (c:IsSetCard(-15) or c:IsSetCard(-13))
end

function c210000013.mecost(e,tp,eg,ep,ev,re,r,rp,chk)
    local fe=Duel.IsPlayerAffectedByEffect(tp,210000013)
    local loc=LOCATION_HAND
    if fe then loc=LOCATION_HAND+LOCATION_DECK end
    if chk==0 then return Duel.IsExistingMatchingCard(c210000013.costfilter,tp,loc,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local tc=Duel.SelectMatchingCard(tp,c210000013.costfilter,tp,loc,0,1,1,nil):GetFirst()
    if tc:IsLocation(LOCATION_DECK) then
        Duel.Hint(HINT_CARD,0,210000013)
        fe:UseCountLimit(tp)
    end
    Duel.SendtoGrave(tc,REASON_COST)
end



function c210000013.filter(c)
    return c:IsAbleToDeck()
end
function c210000013.metg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c210000013.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c210000013.filter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c210000013.filter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c210000013.meop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if not tg then return end
    Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
    local g=Duel.GetOperatedGroup()
    if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
    
end





