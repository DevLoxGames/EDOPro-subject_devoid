--Devoid Feelings
local s,id,o=GetID()
function s.initial_effect(c)
    --Monster effects of your “Subject” monsters are Quick Effects while this card is in your Graveyard. You can banish this card from your Graveyard: Add 1 “Devoid Area” from your Deck to your hand. You can Link Summon during your opponent's turn while this card is banished. You can only activate 1 “Devoid Feelings” per turn.

    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    e1:SetCost(s.spcost)
    c:RegisterEffect(e1)

    --banish for devoid area
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(210000023,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(s.datg)
    e2:SetOperation(s.daop)
    c:RegisterEffect(e2)

    --link during opponent turn
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_REMOVED)
    e3:SetCondition(s.linkcon)
    e3:SetTarget(s.linktg)
    e3:SetOperation(s.linkop)
    c:RegisterEffect(e3)

    --cannot be negated
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_INACTIVATE)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetValue(s.effectfilter)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_DISEFFECT)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetValue(s.effectfilter)
    c:RegisterEffect(e4)

end

function s.costfilter(c,tp)
    return c:IsAbleToGraveAsCost() and c:IsSetCard(-13) and c:IsType(TYPE_MONSTER)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
    Duel.SendtoGrave(g,REASON_COST)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spfilter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and c:IsSetCard(-13) and c:IsType(TYPE_MONSTER)
end


function s.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g1=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local sc1=g1:GetFirst()
    if sc1 then
        Duel.SpecialSummon(sc1,0,tp,tp,false,false,POS_FACEUP_DEFENSE)

        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_ACTIVATE)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(1,0)
        e1:SetTarget(s.sumlimit)
        e1:SetLabel(sc1:GetCode())
        e1:SetReset(RESET_PHASE+PHASE_END)
        e1:SetValue(s.aclimit)
        Duel.RegisterEffect(e1,tp)
        

    end

    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g2=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local sc2=g2:GetFirst()
    if sc2 then
        Duel.SpecialSummon(sc2,0,tp,tp,false,false,POS_FACEUP_DEFENSE)

        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_ACTIVATE)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(1,0)
        e1:SetTarget(s.sumlimit)
        e1:SetLabel(sc2:GetCode())
        e1:SetReset(RESET_PHASE+PHASE_END)
        e1:SetValue(s.aclimit)
        Duel.RegisterEffect(e1,tp)
    end

end

function s.sumlimit(e,c)
    return c:IsCode(e:GetLabel())
end
function s.aclimit(e,re,tp)
    return re:GetHandler():IsCode(e:GetLabel())
end




function s.dafilter(c)
    return c:IsAbleToHand() and c:IsCode(210000020)
end
function s.datg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.dafilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.daop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.dafilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
    end
end




function s.linkcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end
function s.filter(c)
    return c:IsLinkSummonable(nil)
end
function s.linktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.linkop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.LinkSummon(tp,tc,nil)
    end
end



function s.effectfilter(e,ct)
    local etype=Duel.GetChainInfo(ct,CHAININFO_EXTTYPE)
    return etype&(TYPE_MONSTER)==TYPE_MONSTER
end
