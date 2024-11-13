--Subject-Highflier
local s,id,o=GetID()
function s.initial_effect(c)
   
    --summon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,210000026)
    e1:SetTarget(s.selftg)
    e1:SetOperation(s.selfop)
    c:RegisterEffect(e1)
    
    --destroy end phase
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_RELEASE+CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_PHASE+PHASE_END)
    e2:SetCountLimit(1)
    e2:SetTarget(s.destg)
    e2:SetOperation(s.desop)
    c:RegisterEffect(e2)


    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_ANNOUNCE)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1,210000026)
    e3:SetTarget(s.ddtg)
    e3:SetOperation(s.ddop)
    e3:SetCost(s.ddcost)
    c:RegisterEffect(e3)

end

function s.selftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return 
        Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,210000026,0,TYPES_EFFECT_TRAP_MONSTER,0,3000,4,RACE_MACHINE,ATTRIBUTE_DARK) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.selfop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not Duel.IsPlayerCanSpecialSummonMonster(tp,210000026,0,TYPES_EFFECT_TRAP_MONSTER,0,3000,4,RACE_MACHINE,ATTRIBUTE_DARK) then return end
    c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
    Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP_DEFENSE)
end



function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    if not Duel.CheckReleaseGroupEx(tp,nil,1,REASON_EFFECT,false,nil) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
    end
end
function s.spellfilter(c)
    return c:IsType(TYPE_SPELL) and c:IsSetCard(-15) --and not c:IsType(TYPE_FIELD)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Destroy(c,REASON_EFFECT)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectMatchingCard(tp,s.spellfilter,tp,LOCATION_DECK,0,1,1,nil)
    
    Duel.SSet(tp,g:GetFirst())
end



function s.costfilter(c)
    return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER) and c:IsSetCard(-13)
end

function s.ddcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local fe=Duel.IsPlayerAffectedByEffect(tp,210000026)
    local loc=LOCATION_GRAVE
    if fe then loc=LOCATION_GRAVE end
    if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,loc,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local tc=Duel.SelectMatchingCard(tp,s.costfilter,tp,loc,0,1,1,nil):GetFirst()
    Duel.Remove(tc,nil,tc,REASON_COST)
end

function s.ddtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    return true
end

function s.codefilter(c)
    return c:IsType(TYPE_LINK) and c:IsSetCard(-15)
end
function s.ddop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
    local tc=Duel.SelectMatchingCard(tp,s.codefilter,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
    aux.EnableChangeCode(e:GetHandler(),tc:GetCode(),LOCATION_GRAVE)
end