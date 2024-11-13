--Subject-Blessing
local s,id,o=GetID()
function s.initial_effect(c)
    --When this card is activated: Destroy 1 “Subject” monster you control, then Special Summon a “Devoid” Link Monster with the same Attribute from your Graveyard, also activate one of the following effects based on the Summoned monster's Attribute:
    --● DARK: Set this card face-down instead of sending it to the Graveyard.
    --● LIGHT: Shuffle up to 3 of your “Subject” Link Monsters that are in the Graveyard back into the Extra Deck.
    --You can only activate 1 “Subject-Blessing” per turn.

    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCountLimit(1,210000028+EFFECT_COUNT_CODE_OATH)
    e1:SetCost(s.cost)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)

    
end

function s.costfilter(c,tp)
    return c:IsAbleToGraveAsCost() and c:IsSetCard(-13) and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
    Duel.SendtoGrave(g,REASON_COST)
end

function s.filter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_LINK) and c:IsSetCard(-15)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and s.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and aux.NecroValleyFilter()(tc) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)

        if tc:IsAttribute(ATTRIBUTE_DARK) then
            local c = e:GetHandler()
            c:CancelToGrave()
            Duel.ChangePosition(c,POS_FACEDOWN)
            Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)

        elseif tc:IsAttribute(ATTRIBUTE_LIGHT) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
            local g=Duel.SelectTarget(tp,s.exfilter,tp,LOCATION_GRAVE,0,0,3,nil)
            Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
        end
    end
end



function s.exfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and c:IsType(TYPE_LINK) and c:IsSetCard(-15)
end
