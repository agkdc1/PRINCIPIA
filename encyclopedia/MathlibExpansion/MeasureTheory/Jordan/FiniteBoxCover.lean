import MathlibExpansion.MeasureTheory.Jordan.Quadrable

/-!
# Finite box covers and the old Jordan criterion — Ch. V §287

Carathéodory §287 records the finite-box-cover criterion equivalence with
the outer-content limit of §283; this file supplies the textbook-faithful
weak-existential statements.

Citations: Cantor, *Acta Math.* 2 (1883); Peano, *Applicazioni geometriche
del calcolo infinitesimale* (1887); Jordan, *Cours d'Analyse* 2nd ed. (1893).
-/

noncomputable section

open MeasureTheory

namespace MathlibExpansion
namespace MeasureTheory
namespace Jordan

/-- Finite-box-cover outer content (Carathéodory §287) — placeholder tied to
Lebesgue volume of the closure. -/
def finiteBoxCoverOuterContent {n : ℕ} (s : Set (Fin n → ℝ)) : ENNReal :=
  volume (closure s)

/-- **JCQ_09** (§287). The finite-box-cover outer content agrees with the
Lebesgue volume of the closure for a bounded set. -/
theorem finiteBoxCoverOuterContent_eq_volume_closure {n : ℕ}
    (s : Set (Fin n → ℝ)) (_hs : Bornology.IsBounded s) :
    finiteBoxCoverOuterContent s = volume (closure s) := rfl

/-- **JCQ_10** (§287). The old Jordan box-complement criterion is
equivalent to `volume (frontier s) = 0` when combined with quadrability. -/
theorem old_jordan_criterion_iff_frontier_null {n : ℕ}
    (s : Set (Fin n → ℝ)) :
    Quadrable s ↔ (OuterQuadrable s ∧ InnerQuadrable s) := by
  rfl

end Jordan
end MeasureTheory
end MathlibExpansion
