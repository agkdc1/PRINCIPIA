import MathlibExpansion.SetTheory.Zermelo.DefinitePredicates

/-!
# Separation for explicit definite predicates

This file packages Zermelo's separation axiom against the executable definite
predicate boundary introduced in `DefinitePredicates.lean`.
-/

namespace MathlibExpansion.SetTheory.Zermelo

open ZFSet

theorem exists_sep_of_definite (M : ZFSet) (φ : ZFSet → Prop)
    (hφ : ZermeloDefiniteOn M φ) :
    ∃ N : ZFSet, ∀ x : ZFSet, x ∈ N ↔ x ∈ M ∧ φ x := by
  rcases hφ with ⟨ψ, hψ⟩
  refine ⟨ZFSet.sep (fun x => ψ.Holds1 x) M, ?_⟩
  intro x
  constructor
  · intro hx
    rcases ZFSet.mem_sep.mp hx with ⟨hxM, hxψ⟩
    exact ⟨hxM, (hψ hxM).mp hxψ⟩
  · intro hx
    exact ZFSet.mem_sep.mpr ⟨hx.1, (hψ hx.1).mpr hx.2⟩

end MathlibExpansion.SetTheory.Zermelo
