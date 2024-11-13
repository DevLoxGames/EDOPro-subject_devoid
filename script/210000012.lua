--Called Devoid
local s,id,o=GetID()
function s.initial_effect(c)
    --Send the top card of your Deck to the Graveyard, then, if it was a “Subject” or “Devoid” card: Add it to your hand.

    --specific Link Material
    aux.AddLinkProcedure(c,nil,2,2, c210000012.mfilter)
    
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
    e1:SetTarget(c210000012.indtg)
    e1:SetValue(1)
    c:RegisterEffect(e1)

    --Mandatory Effect
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetCategory(CATEGORY_DECKDES + CATEGORY_TOHAND)
    e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCost(c210000012.cost)
    e2:SetCondition(c210000012.mecon)
    e2:SetTarget(c210000012.metg)
    e2:SetOperation(c210000012.meop)
    c:RegisterEffect(e2)

end

function c210000012.mfilter(g,lc)
    return g:IsExists(Card.IsCode,1,nil,210000002) and g:IsExists(Card.IsCode,1,nil,210000003)
end

function c210000012.indtg(e,c)
    return (c:IsSetCard(-13) and e:GetHandler():GetLinkedGroup():IsContains(c))
end



function c210000012.mecon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c210000012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)==0 and Duel.IsPlayerCanDiscardDeckAsCost(tp,1) end
    Duel.DiscardDeck(tp,1,REASON_COST)
end
function c210000012.filter(c)
    return (c:IsSetCard(-13) or c:IsSetCard(-15)) and c:IsAbleToHand()
end
function c210000012.metg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c210000012.filter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c210000012.meop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c210000012.filter),tp,LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
    end
end

