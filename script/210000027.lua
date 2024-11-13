--Subject-Selection
local s,id,o=GetID()
function s.initial_effect(c)
    --If 1 of your opponent's “Subject” monsters battles 1 “Subject” monster you control: You can banish this card from your Graveyard: Negate the attack, and if you do, Special Summon 1 “Subject” monster with the same Attribute as the attacking monster from your Deck.

    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_CONTROL)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,210000027)
    e1:SetTarget(s.cnttg)
    e1:SetOperation(s.cntop)
    c:RegisterEffect(e1)

    --negate and summon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_NEGATE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetTarget(s.atktg)
    e2:SetOperation(s.atkop)
    e2:SetCost(aux.bfgcost)
    c:RegisterEffect(e2)

    
    

end
function s.filter(c)
    local tp=c:GetControler()
    return c:IsAbleToChangeControler() and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0 and c:IsType(TYPE_MONSTER) and c:IsSetCard(-13)
end
function s.cnttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,0,0,0)
end
function s.cntop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
    then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g1=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.HintSelection(g1)
    
    local tc=g1:GetFirst()
    Duel.GetControl(tc,1-tp)
    --Duel.SwapControl(tc,nil,0,0)

    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    Duel.RegisterEffect(e1,1-tp)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_MSET)
    Duel.RegisterEffect(e2,1-tp)

end


function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local a = Duel.GetAttacker()
    local b = Duel.GetAttackTarget()

    if a:IsSetCard(-13) and b:IsSetCard(-13) then
        Duel.NegateAttack()

        Duel.Damage(1-tp,2*a:GetAttack(),REASON_EFFECT)
    end
end
