--Subject-Six-fight
local s,id,o=GetID()
function s.initial_effect(c)
    --You can destroy this card during any player's turn: Special Summon 1 “Subject” monster with more than 1500 ATK and 1 "Subject" monster with less than 1500 ATK from your Deck. If this card is destroyed by a card effect: You can Set 1 “Subject” Trap from your Deck. You can only activate each effect of “Subject-Six-fight” once per turn.
    
    --summon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1)
    e1:SetTarget(s.selftg)
    e1:SetOperation(s.selfop)
    c:RegisterEffect(e1)

    --sset end phase
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_ANNOUNCE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_PHASE+PHASE_END)
    e2:SetCountLimit(1)
    e2:SetTarget(s.eptg)
    e2:SetOperation(s.epop)
    c:RegisterEffect(e2)

    --destroy itself and summon
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetOperation(s.spop)
    e3:SetTarget(s.sptg)
    c:RegisterEffect(e3)

end

function s.selftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return 
        Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,210000029,0,TYPES_EFFECT_TRAP_MONSTER,3000,0,4,RACE_MACHINE,ATTRIBUTE_LIGHT) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.selfop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not Duel.IsPlayerCanSpecialSummonMonster(tp,210000029,0,TYPES_EFFECT_TRAP_MONSTER,3000,0,4,RACE_MACHINE,ATTRIBUTE_LIGHT) then return end
    c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
    Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP_ATTACK)
end


function s.eptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    return true
end

function s.epop(e,tp,eg,ep,ev,re,r,rp)
    local c = e:GetHandler()
    c:CancelToGrave()
    Duel.ChangePosition(c,POS_FACEDOWN)
    Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
end



function s.spfilter1(c,e,tp)
    return c:IsAttackBelow(1499) and c:IsSetCard(-13) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spfilter2(c,e,tp)
    return c:IsAttackAbove(1501) and c:IsSetCard(-13) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)

    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter1),tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g1:GetCount()>0 then
        Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
    end

    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter2),tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g2:GetCount()>0 then
        Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
    end

    if Duel.Destroy(e:GetHandler(),REASON_EFFECT) then

    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectMatchingCard(tp,s.trapfilter,tp,LOCATION_DECK,0,1,1,nil)
    
    Duel.SSet(tp,g:GetFirst()) end

end

function s.trapfilter(c)
    return c:IsType(TYPE_TRAP) and c:IsSetCard(-13) --and not c:IsType(TYPE_FIELD)
end