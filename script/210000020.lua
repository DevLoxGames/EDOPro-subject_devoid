--Devoid Area
local s,id,o=GetID()
function s.initial_effect(c)
    

    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,210000020+EFFECT_COUNT_CODE_OATH)
    e1:SetOperation(c210000020.activate)
    c:RegisterEffect(e1)

    --Return to hand
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_PHASE + PHASE_END)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCondition(c210000020.mecon)
    e2:SetCountLimit(1)
    e2:SetTarget(c210000020.returntg)
    e2:SetOperation(c210000020.returnop)
    c:RegisterEffect(e2)

    --ATK/DEF boost
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetRange(LOCATION_FZONE)
    e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e3:SetValue(c210000020.val1)
    c:RegisterEffect(e3)


    local e4= e3:Clone()
    e4:SetValue(c210000020.val2)
    e4:SetCode(EFFECT_UPDATE_DEFENSE)
    --e4:SetCategory(CATEGORY_DEFCHANGE)
    c:RegisterEffect(e4)

    --immune
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EFFECT_IMMUNE_EFFECT)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetTarget(c210000020.indtg)
    e5:SetValue(c210000020.efilter)
    c:RegisterEffect(e5)

    --Enable Union
    local e6=Effect.CreateEffect(c)
    e6:SetCountLimit(1)
    e6:SetCategory(CATEGORY_ANNOUNCE)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_FZONE)
    e6:SetTarget(c210000020.eqtg)
    e6:SetOperation(c210000020.eqop)
    c:RegisterEffect(e6)

    --battle phase effect
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e7:SetCode(EVENT_ATTACK_ANNOUNCE)
    e7:SetRange(LOCATION_FZONE)
    e7:SetCondition(c210000020.atkcon)
    e7:SetCost(c210000020.atkcost)
    e7:SetOperation(c210000020.atkop)
    c:RegisterEffect(e7)

end

function c210000020.returntg(e,c)
    return true
end

function c210000020.thfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(-13) and c:IsAbleToHand()
end
function c210000020.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c210000020.thfilter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()>0 and Duel.SelectYesNo(tp,HINTMSG_ATOHAND) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:Select(tp,1,1,nil)
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
    end
end

function c210000020.mecon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end

function c210000020.returnop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c210000020.spfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
    local sc=g:GetFirst()

    Duel.SendtoHand(sc,tp,REASON_EFFECT)

end
function c210000020.spfilter(c,e,tp)
    return c:IsAbleToHand() and c:IsControler(tp) and c:IsCode(210000020) and c:IsType(TYPE_FIELD)
end

function c210000020.val1(e,c)
    
    if c:GetBaseAttack() < 3000 then
        if c:GetEquipCount() > 0 then
            return (3000 - c:GetAttack())
        else 
            return 0 
        end
        
    elseif c:GetBaseAttack() > 2999 then
        if c:GetEquipCount() > 0 then return 1500
        else return 0 
        end
    end
end

function c210000020.val2(e,c)
    
    if c:GetBaseDefense() < 3000 then
        if c:GetEquipCount() > 0 then
            return (3000 - c:GetDefense())
        else 
           return 0 
        end
    else return 0
    end
end

function c210000020.indtg(e,c)
    return c:IsType(TYPE_LINK) and c:IsSetCard(-15)
end
function c210000020.efilter(e,te,ev)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end



function c210000020.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
    return Duel.IsExistingMatchingCard(c210000020.eqfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp)
end
function c210000020.eqop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
    local g=Duel.SelectMatchingCard(tp,c210000020.eqfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    aux.EnableUnionAttribute(tc,c210000020.eqfilter2)
end

function c210000020.eqfilter1(c,e,tp)
    return c:IsFaceup() and c:IsSetCard(-13) and c:IsType(TYPE_MONSTER)
end
function c210000020.eqfilter2(c,e,tp)
    return (c:IsSetCard(-15) or c:IsSetCard(-13))and c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
end
    

    









function c210000020.cfilter(c)
    return c:IsSetCard(-13) and c:IsControler(tp) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c210000020.atkcon(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    if not a:IsControler(tp) then a,d=d,a end
    e:SetLabelObject(a)
    return a and a:IsSetCard(-13) and a:IsFaceup() and a:IsControler(tp)
end
function c210000020.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c210000020.cfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c210000020.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SendtoGrave(g:GetFirst(),REASON_COST)
end
function c210000020.atkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    if tc:IsFaceup() and tc:IsRelateToBattle() then
        Duel.NegateAttack()
        Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
    end
end
  