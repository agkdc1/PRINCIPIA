import Mathlib.Data.Real.Cardinality
import Mathlib.SetTheory.Cardinal.Continuum

noncomputable section

open Cardinal
open scoped Cardinal

namespace MathlibExpansion
namespace SetTheory
namespace Cardinal

/-- The countable sequence space `ℕ → ℕ` has cardinality continuum. -/
theorem mk_natSeq : #(ℕ → ℕ) = #(ℝ) := by
  rw [mk_arrow, mk_nat]
  simpa [lift_aleph0, mk_real] using (aleph0_power_aleph0 : ℵ₀ ^ ℵ₀ = 𝔠)

/-- The interval `(0, 1]` and Baire space carry the same cardinality. -/
theorem mk_Ioc_eq_mk_natSeq :
    #(Set.Ioc (0 : ℝ) 1) = #(ℕ → ℕ) := by
  rw [mk_natSeq]
  simpa [mk_real] using (mk_Ioc_real (a := (0 : ℝ)) (b := (1 : ℝ)) (by norm_num))

/--
Hausdorff's interval-to-sequence coding, extracted nonconstructively from the
cardinality equality available in the pinned Mathlib snapshot.
-/
noncomputable def hausdorffIntervalEquivNatSeq :
    Set.Ioc (0 : ℝ) 1 ≃ (ℕ → ℕ) :=
  Classical.choice <| Cardinal.eq.mp mk_Ioc_eq_mk_natSeq

end Cardinal
end SetTheory
end MathlibExpansion
