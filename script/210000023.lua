--Devoid Rules
local s,id,o=GetID()
function s.initial_effect(c)
    --When a Link Monster is Summoned the turn this card is activated: You can banish this card from your Graveyard, then destroy all monsters on the field with less ATK than the Link Summoned monster. Your opponent must attack the monster with the highest ATK you control while this card is in your Graveyard. You can only activate 1 “Devoid Rules” per turn.

    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(s.acttg)
    e1:SetOperation(s.actop)
    c:RegisterEffect(e1)

    --destroy by banish
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(210000023,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(s.descon)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(s.destg)
    e2:SetOperation(s.desop)
    c:RegisterEffect(e2)

    --must attack highest
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_MUST_ATTACK)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetTargetRange(0,LOCATION_MZONE)
    e3:SetCondition(s.macon)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_MUST_ATTACK_MONSTER)
    e4:SetValue(s.atklimit)
    c:RegisterEffect(e4)

end


function s.filter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(-13) and c:IsLocation(LOCATION_GRAVE) and c:GetOwner() == tp
end
function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and s.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.actop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
        local c=e:GetHandler()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_SUMMON)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
        e1:SetReset(RESET_PHASE+PHASE_END)
        e1:SetTargetRange(1,0)
        Duel.RegisterEffect(e1,tp)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_CANNOT_MSET)
        Duel.RegisterEffect(e2,tp)

    end
    Duel.SpecialSummonComplete()
end



function s.cfilter(c,tp)
    return c:IsSummonPlayer(tp) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.desfilter(c)
    return c:IsFaceup() and c:IsDestructable() and c:IsAttackBelow(2999)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,0,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil)
    if g:GetCount()>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end


function s.mafilter2(c)
    return c:IsCode(210000023)
end
function s.mafilter(c)
    return c:IsFaceup() 
end
function s.macon(e)
    return Duel.IsExistingMatchingCard(s.mafilter2,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end
function s.atklimit(e,c)
    local g=Duel.GetMatchingGroup(s.mafilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil):GetMaxGroup(Card.GetAttack)
    return g and g:IsContains(c)
end

