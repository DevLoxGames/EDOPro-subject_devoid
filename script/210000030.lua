--Freddy Rizzbear
local s,id,o=GetID()
function s.initial_effect(c)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetOperation(c210000030.winop)
    c:RegisterEffect(e2)

end

function c210000030.winop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Win(tp,REASON_EFFECT)
end

