--Subject PX: Lord
local s,id,o=GetID()
function s.initial_effect(c)

    --equip - funktioniert
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(210000006,0))
    e1:SetProperty(EFFECT_FLAG_CARD_DELAY)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetRange(LOCATION_DECK)
    e1:SetCountLimit(1)
    e1:SetTarget(c210000006.eqtg)
    e1:SetOperation(c210000006.eqop)
    c:RegisterEffect(e1)

    --unequip and normal summon - funtk
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    --e2:SetCountLimit(1)
    e2:SetTarget(s.sptg)
    e2:SetOperation(s.spop)
    c:RegisterEffect(e2)

    --Link Restrict funktioniert
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(1,0)
    e3:SetTarget(c210000006.splimit)
    c:RegisterEffect(e3)

    --Banishment Summon - funktioniert
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(210000006,1))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_REMOVE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetTarget(c210000006.sptg2)
    e4:SetOperation(c210000006.spop2)
    c:RegisterEffect(e4)

    --Mandatory Effect
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetCost(c210000006.ddcost)
    e5:SetCondition(c210000006.ddcon)
    e5:SetTarget(c210000006.ddtg)
    e5:SetOperation(c210000006.ddop)
    c:RegisterEffect(e5)

end


function c210000006.eqfilter(c,tp)
    return (c:IsAttribute(ATTRIBUTE_LIGHT)) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:IsSetCard(-13)
end
function c210000006.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c210000006.eqfilter,tp,LOCATION_DECK,0,1,nil,tp) end
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c210000006.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()

    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then 
        return end
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local g=Duel.SelectMatchingCard(tp,c210000006.eqfilter,tp,LOCATION_DECK,0,1,1,tp)
        local tc=g:GetFirst()
        if not Duel.Equip(tp,tc,c) then return end

        --equip limit
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetLabelObject(c)
        e1:SetValue(c210000006.eqlimit)
        tc:RegisterEffect(e1)
        
        
    end
end
function c210000006.eqlimit(e,c)
    return c==e:GetLabelObject()
end
function c210000006.eqcheck(e,tp,eg,ep,ev,re,r,rp)
    if e:GetLabelObject() then e:GetLabelObject():DeleteGroup() end
    local g=e:GetHandler():GetEquipGroup()
    g:KeepAlive()
    e:SetLabelObject(g)
end





function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,e:GetHandler(),1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.Summon(tp,c,true,e,POS_FACEUP_DEFENSE)
end















function c210000006.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return (c:IsType(TYPE_FUSION) or c:IsType(TYPE_SYCHRO) or c:IsType(TYPE_XYZ) or c:IsType(TYPE_PENDULUM))
end






function c210000006.spfilter2(c,e,tp)
    return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and c:IsSetCard(-13)
end

function c210000006.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c210000006.spfilter2(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c210000006.spfilter2,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c210000006.spfilter2,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c210000006.spop2(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
    end
end












function c210000006.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c210000006.ddcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c210000006.cfilter(c)
    return c:IsFaceup() and c:IsCode(210000006) and c:IsAbleToHandAsCost()
end
function c210000006.ddcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c210000006.cfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectMatchingCard(tp,c210000006.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SendtoHand(g,nil,REASON_COST)
end
function c210000006.ddop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c210000006.spfilter3,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    local sc=g:GetFirst()
    if sc then
        Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c210000006.spfilter3(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and c:IsSetCard(-13) and not c:IsCode(210000006)
end