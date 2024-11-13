--Devoid Scaffolding
local s,id,o=GetID()
function s.initial_effect(c)

    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_HANDDES)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(s.ddtg)
    e1:SetOperation(s.ddop)
    c:RegisterEffect(e1)

    
end

function s.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
        and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,e:GetHandler()) end
end
function s.ddop(e,tp,eg,ep,ev,re,r,rp)
    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
    local g1=Duel.SelectMatchingCard(tp,s.banfilter,tp,LOCATION_HAND,0,1,5,nil,e,tp)
    
    local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
    local ag2=g2:Select(tp,g1:GetCount(),g1:GetCount(),nil)
    
    Duel.Remove(g1,POS_FACEUP,REASON_EFFECT,tp)
    Duel.Remove(ag2,POS_FACEDOWN,REASON_EFFECT,tp)
    
    local g=Duel.GetDecktopGroup(tp,1)
    local tc=g:GetFirst()
    Duel.Draw(tp,1,REASON_EFFECT)
    Duel.Draw(1-tp,3,REASON_EFFECT)

    if tc:IsSetCard(-13) then
        local c=e:GetHandler()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetCode(EFFECT_CANNOT_ACTIVATE)
        e1:SetTargetRange(0,1)
        e1:SetValue(s.aclimit)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,1-tp)
        Duel.RegisterFlagEffect(1-tp,210000025,RESET_PHASE+PHASE_END,0,3)
    end
end

function s.aclimit(e,re,tp)
    return re:GetType() == EFFECT_TYPE_QUICK_F or re:GetType() == EFFECT_TYPE_QUICK_O
end
function s.banfilter(c,e,tp)
    return c:IsSetCard(-13)
end