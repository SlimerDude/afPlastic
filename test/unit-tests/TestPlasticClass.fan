
internal class TestPlasticClass : PlasticTest {
	
	Void testNonConstProxyCannotOverrideConst() {
		plasticModel := PlasticClassModel("TestImpl", false)
		verifyErrMsg(PlasticMsgs.nonConstTypeCannotSubclassConstType("TestImpl", T_PlasticService01#)) {
			plasticModel.extendMixin(T_PlasticService01#)
		}
	}

	Void testConstProxyCannotOverrideNonConst() {
		plasticModel := PlasticClassModel("TestImpl", true)
		verifyErrMsg(PlasticMsgs.constTypeCannotSubclassNonConstType("TestImpl", T_PlasticService02#)) {
			plasticModel.extendMixin(T_PlasticService02#)
		}
	}

	Void testOverrideMethodsMustBelongToSuperType() {
		plasticModel := PlasticClassModel("TestImpl", true)
		plasticModel.extendMixin(T_PlasticService01#)
		verifyErrMsg(PlasticMsgs.overrideMethodDoesNotBelongToSuperType(Int#abs, [Obj#, T_PlasticService01#])) {
			plasticModel.overrideMethod(Int#abs, "wotever")
		}
	}

	Void testOverrideMethodMayExistInMixinChain() {
		plasticModel := PlasticClassModel("TestImpl", true)
		plasticModel.extendMixin(T_PlasticService10#)
		plasticModel.overrideMethod(T_PlasticService09#deeDee, "wotever")
	}

	Void testOverrideMethodsMustHaveProtectedScope() {
		plasticModel := PlasticClassModel("TestImpl", false)
		plasticModel.extendMixin(T_PlasticService05#)
		verifyErrMsg(PlasticMsgs.overrideMethodHasWrongScope(T_PlasticService05#oops)) {
			plasticModel.overrideMethod(T_PlasticService05#oops, "wotever")
		}
	}

	Void testOverrideMethodsMustBeVirtual() {
		plasticModel := PlasticClassModel("TestImpl", false)
		plasticModel.extendMixin(T_PlasticService06#)
		verifyErrMsg(PlasticMsgs.overrideMethodsMustBeVirtual(T_PlasticService06#oops)) {
			plasticModel.overrideMethod(T_PlasticService06#oops, "wotever")
		}
	}

	Void testOverrideMethodsCanNotHaveDefParams() {
		plasticModel := PlasticClassModel("TestImpl", false)
		plasticModel.extendMixin(T_PlasticService08#)
		verifyErrMsg(PlasticMsgs.overrideMethodsCanNotHaveDefaultValues(T_PlasticService08#redirect)) {
			plasticModel.overrideMethod(T_PlasticService08#redirect, "wotever")
		}
	}
	
	Void testConstTypeCanHaveFields() {
		plasticModel := PlasticClassModel("TestImpl", true)
		plasticModel.addField(Str#, "wotever")
	}

	// @see http://fantom.org/sidewalk/topic/2216
	Void testUnnecessaryMixinsAreNotAdded() {
		plasticModel := PlasticClassModel("TestImpl", true)
		plasticModel.extendMixin(T_PlasticService12#)
		plasticModel.extendMixin(T_PlasticService11#)
		verifyEq(plasticModel.mixins.size, 1)
		verifyEq(plasticModel.mixins.first, T_PlasticService12#)
	}

	// @see http://fantom.org/sidewalk/topic/2216
	Void testLowerOrderMixinsAreRemoved() {
		plasticModel := PlasticClassModel("TestImpl", true)
		plasticModel.extendMixin(T_PlasticService11#)
		plasticModel.extendMixin(T_PlasticService12#)
		verifyEq(plasticModel.mixins.size, 1)
		verifyEq(plasticModel.mixins.first, T_PlasticService12#)
	}

	// @see http://fantom.org/sidewalk/topic/2216
	Void testMixinsAreNotDuped() {
		plasticModel := PlasticClassModel("TestImpl", true)
		plasticModel.extendMixin(T_PlasticService11#)
		plasticModel.extendMixin(T_PlasticService11#)
		verifyEq(plasticModel.mixins.size, 1)
		verifyEq(plasticModel.mixins.first, T_PlasticService11#)
	}
}

@NoDoc
const mixin T_PlasticService01 { }

@NoDoc
mixin T_PlasticService02 { }

@NoDoc
mixin T_PlasticService03 { }

@NoDoc
class T_PlasticService04 { }

@NoDoc
mixin T_PlasticService05 { 
	internal abstract Str oops()
}

@NoDoc
mixin T_PlasticService06 { 
	Str oops() { "oops" }
}

@NoDoc
mixin T_PlasticService07 { 
	internal abstract Str oops
}

@NoDoc
mixin T_PlasticService08 { 
	abstract Void redirect(Uri uri, Int statusCode := 303)
}

@NoDoc
const mixin T_PlasticService09 {
	abstract Void deeDee()
}

@NoDoc
const mixin T_PlasticService10 : T_PlasticService09 { }

@NoDoc
const mixin T_PlasticService11 { }

@NoDoc
const mixin T_PlasticService12 : T_PlasticService11 { }
