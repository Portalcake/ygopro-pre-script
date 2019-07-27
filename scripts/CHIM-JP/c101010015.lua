--星雲龍ネビュラ

--Scripted by nekrozar
function c101010015.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101010015,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101010015)
	e1:SetTarget(c101010015.sptg)
	e1:SetOperation(c101010015.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101010015,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101010015+100)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101010015.thtg)
	e2:SetOperation(c101010015.thop)
	c:RegisterEffect(e2)
end
function c101010015.spfilter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:IsLevel(8) and not c:IsPublic() and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c101010015.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and not c:IsPublic()
		and Duel.IsExistingMatchingCard(c101010015.spfilter,tp,LOCATION_HAND,0,1,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c101010015.spfilter,tp,LOCATION_HAND,0,1,1,c,e,tp)
	local tc=g:GetFirst()
	Duel.ConfirmCards(1-tp,g)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_HAND)
	e2:SetOperation(c101010015.clearop)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
	e2:SetLabel(Duel.GetCurrentChain())
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	tc:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetLabelObject(e3)
	tc:RegisterEffect(e4)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND)
end
function c101010015.clearop(e,tp,eg,ep,ev,re,r,rp)
	if ev~=e:GetLabel() then return end
	e:GetLabelObject():Reset()
	e:Reset()
end
function c101010015.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		c:RegisterEffect(e2,true)
		local e3=e1:Clone()
		tc:RegisterEffect(e3,true)
		local e4=e2:Clone()
		tc:RegisterEffect(e4,true)
		Duel.SpecialSummonComplete()
	end
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetTargetRange(1,0)
	e5:SetTarget(c101010015.splimit)
	e5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e5,tp)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e6,tp)
end
function c101010015.splimit(e,c)
	return not c:IsRace(RACE_DRAGON) or not c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function c101010015.thfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsLevel(4) and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsAbleToHand()
end
function c101010015.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101010015.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101010015.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101010015.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101010015.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
