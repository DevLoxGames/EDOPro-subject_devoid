--Chosen Devoid
local s,id,o=GetID()
function s.initial_effect(c)
    --Once per turn: Destroy 1 card on the field, then if it was one of your cards: You gain 1000 LP.

    --specific Link Material
    aux.AddLinkProcedure(c,nil,2,2, c210000015.mfilter)
    
    --Link Material banish
    aux.AddFusionProcCode2(c,210000006,210000007,true,true)
    aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_GRAVE,0,Duel.Remove,POS_FACEUP,REASON_COST)

    c:EnableReviveLimit()

    --Subject indes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetTarget(c210000015.indtg)
    e1:SetValue(1)
    c:RegisterEffect(e1)

    --Mandatory Effect
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c210000015.mecon)
    e2:SetCountLimit(1)
    e2:SetTarget(c210000015.metg)
    e2:SetOperation(c210000015.meop)
    c:RegisterEffect(e2)

end

function c210000015.mfilter(g,lc)
    return g:IsExists(Card.IsCode,1,nil,210000006) and g:IsExists(Card.IsCode,1,nil,210000007)
end

function c210000015.indtg(e,c)
    return (c:IsSetCard(-13) and e:GetHandler():GetLinkedGroup():IsContains(c))
end



function c210000015.mecon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end






function c210000015.metg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c210000015.spfilter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end


function c210000015.meop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
    local g1=Duel.SelectMatchingCard(1-tp,c210000015.spfilter,1-tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local sc1=g1:GetFirst()
    if sc1 then
        Duel.SpecialSummon(sc1,0,1-tp,1-tp,false,false,POS_FACEUP_DEFENSE)
        
    end

    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g2=Duel.SelectMatchingCard(tp,c210000015.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local sc2=g2:GetFirst()
    if sc2 then
        Duel.SpecialSummon(sc2,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
    end

end

