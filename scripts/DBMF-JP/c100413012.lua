--斬機超階乗

--Scripted by nekrozar
function c100413012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100413012+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100413012.target)
	e1:SetOperation(c100413012.activate)
	c:RegisterEffect(e1)
end
function c100413012.spfilter1(c,e,tp)
	return c:IsSetCard(0x231) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCanBeEffectTarget(e)
end
function c100413012.fselect1(g,tp)
	return Duel.IsExistingMatchingCard(c100413012.synfilter,tp,LOCATION_EXTRA,0,1,nil,g) and aux.dncheck(g)
end
function c100413012.synfilter(c,g)
	return c:IsSetCard(0x231) and c:IsSynchroSummonable(nil,g,g:GetCount()-1,g:GetCount()-1)
end
function c100413012.fselect2(g,tp)
	return Duel.IsExistingMatchingCard(c100413012.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,g) and aux.dncheck(g)
end
function c100413012.xyzfilter(c,g)
	return c:IsSetCard(0x231) and c:IsXyzSummonable(g,g:GetCount(),g:GetCount())
end
function c100413012.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),3)
	local g=Duel.GetMatchingGroup(c100413012.spfilter1,tp,LOCATION_GRAVE,0,nil,e,tp)
	local b1=g:CheckSubGroup(c100413012.fselect1,1,ft,tp)
	local b2=g:CheckSubGroup(c100413012.fselect2,1,ft,tp)
	if chk==0 then return ft>0 and Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) and (b1 or b2) end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(100413012,0),aux.Stringid(100413012,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(100413012,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(100413012,1))+1
	end
	e:SetLabel(op)
	local sg=nil
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=g:SelectSubGroup(tp,c100413012.fselect1,false,1,ft,tp)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=g:SelectSubGroup(tp,c100413012.fselect2,false,1,ft,tp)
	end
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,sg:GetCount(),0,0)
end
function c100413012.spfilter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100413012.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c100413012.spfilter2,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,182,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		if op==0 then
			local e3=e1:Clone()
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e3:SetValue(LOCATION_DECKBOT)
			tc:RegisterEffect(e3,true)
		end
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
	local og=Duel.GetOperatedGroup()
	if op==0 then
		local tg=Duel.GetMatchingGroup(c100413012.synfilter,tp,LOCATION_EXTRA,0,nil,og)
		if og:GetCount()==g:GetCount() and tg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local rg=tg:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,rg:GetFirst(),nil,og,og:GetCount()-1,og:GetCount()-1)
		end
	else
		local tg=Duel.GetMatchingGroup(c100413012.xyzfilter,tp,LOCATION_EXTRA,0,nil,og)
		if og:GetCount()==g:GetCount() and tg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local rg=tg:Select(tp,1,1,nil)
			Duel.XyzSummon(tp,rg:GetFirst(),og,og:GetCount(),og:GetCount())
		end
	end
end
