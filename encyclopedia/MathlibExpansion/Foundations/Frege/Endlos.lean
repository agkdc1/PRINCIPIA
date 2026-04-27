import MathlibExpansion.Foundations.Frege.CardinalNumber
import MathlibExpansion.Foundations.Relations.SimpleSeries

/-!
# Frege's `Endlos` shadow

This consumer layer connects the generic simple endless series substrate back
to Frege's safe concept-cardinal language.
-/

universe u

open MathlibExpansion.Logic.Frege
open MathlibExpansion.Foundations.Relations

namespace MathlibExpansion.Foundations.Frege

/-- A concept has Frege number `ℵ₀` exactly when its carrier supports a simple
endless series. -/
theorem fregeNumber_eq_aleph0_iff_nonempty_simpleEndlessSeries {α : Type u}
    (F : FregeConcept α) :
    FregeNumber F = Cardinal.aleph0 ↔
      Nonempty (SimpleEndlessSeries (conceptSet F)) := by
  simpa [FregeNumber] using
    (mk_eq_aleph0_iff_nonempty_simpleEndlessSeries (conceptSet F))

/-- If a concept can be ordered as a simple endless series, then its Frege
number is `ℵ₀`. -/
theorem fregeNumber_eq_aleph0_of_simpleEndlessSeries {α : Type u}
    (F : FregeConcept α)
    (h : Nonempty (SimpleEndlessSeries (conceptSet F))) :
    FregeNumber F = Cardinal.aleph0 :=
  (fregeNumber_eq_aleph0_iff_nonempty_simpleEndlessSeries F).2 h

end MathlibExpansion.Foundations.Frege
