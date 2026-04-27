import Mathlib.RingTheory.Ideal.Quotient.Operations
import Mathlib.RingTheory.Ideal.Over
import Mathlib.RingTheory.Jacobson.Radical
import Mathlib.RingTheory.Nakayama
import Mathlib.RingTheory.LocalRing.Quotient

namespace MathlibExpansion.Recon.WP06NakayamaCheck

#check Submodule.Quotient.instSMul
#check Submodule.Quotient.mk_smul
#check Ideal.Quotient.mk_smul_mk_quotient_map_quotient
#check Submodule.FG.eq_bot_of_le_jacobson_smul
#check Submodule.eq_bot_of_le_smul_of_le_jacobson_bot
#check Submodule.le_of_le_smul_of_le_jacobson_bot
#check Submodule.smul_le_of_le_smul_of_le_jacobson_bot
#check Submodule.eq_smul_of_le_smul_of_le_jacobson
#check Submodule.sup_smul_eq_sup_smul_of_le_smul_of_le_jacobson

end MathlibExpansion.Recon.WP06NakayamaCheck
