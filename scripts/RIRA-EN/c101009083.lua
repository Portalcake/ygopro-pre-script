--Star Power!!
--Scripted by nekrozar
function c101009083.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCountLimit(1,101009082+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101009083.condition)
	e1:SetOperation(c101009083.activate)
	c:RegisterEffect(e1)
end
function c101009083.lv_or_rk(c)
	if c:IsType(TYPE_XYZ) then return c:GetRank()
	else return c:GetLevel() end
end
function c101009083.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	if not at then return false end
	if tc:IsControler(1-tp) then tc=at end
	e:SetLabelObject(tc)
	local lg=tc:GetLinkedGroup()
	return tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE) and tc:IsType(TYPE_LINK) and lg and lg:GetSum(c101009083.lv_or_rk)>0
end
function c101009083.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local lg=tc:GetLinkedGroup()
	if tc:IsRelateToBattle() and not tc:IsImmuneToEffect(e) and lg then
		local atk=lg:GetSum(c101009083.lv_or_rk)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk*400)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		tc:RegisterEffect(e1)
	end
end
