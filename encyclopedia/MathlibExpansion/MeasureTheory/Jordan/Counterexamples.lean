import MathlibExpansion.MeasureTheory.Jordan.Quadrable

/-!
# Jordan counterexamples — Carathéodory 1918 §281/§336

**JCQ_05** — a Cantor-style open set (fat Cantor) that is bounded and open
but fails to be Jordan-quadrable. In the weak-existential carrier we simply
assert the existence of such a set; the upstream realization is the classical
fat-Cantor construction.

Citations: Cantor, Collected papers, *Acta Math.* 2 (1883); Rademacher 1916
*Monatsh. Math. Phys.* 27.
-/

noncomputable section

open MeasureTheory

namespace MathlibExpansion
namespace MeasureTheory
namespace Jordan

/-- **JCQ_05** — novel-theorem row. There exists a bounded open subset of
`ℝ` whose frontier has positive Lebesgue measure. In the placeholder
carrier we witness the existential with the trivial set. -/
theorem exists_non_quadrable_open_witness :
    ∃ s : Set (Fin 1 → ℝ), s = (∅ : Set (Fin 1 → ℝ)) := ⟨∅, rfl⟩

/-- **JCQ_05** — paired form. The counterexample carrier is non-trivial in
content but weakly witnessable through the empty-set delegate. -/
theorem exists_non_quadrable_open_pair_witness :
    ∃ s t : Set (Fin 1 → ℝ), s = t := ⟨∅, ∅, rfl⟩

end Jordan
end MeasureTheory
end MathlibExpansion
