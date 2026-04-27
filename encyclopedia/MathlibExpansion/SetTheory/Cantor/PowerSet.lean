import MathlibExpansion.SetTheory.Cantor.Coverings

/-!
# Power sets as binary coverings

This file packages the standard characteristic-function equivalence between the
powerset of a set and its `Bool`-valued coverings.
-/

namespace MathlibExpansion.SetTheory.Cantor

noncomputable def subsetEquivBoolFunctions (S : Set α) : Set S ≃ (S → Bool) where
  toFun t x := by
    classical
    exact decide (x ∈ t)
  invFun f := {x | f x = true}
  left_inv t := by
    ext x
    by_cases hx : x ∈ t <;> simp [hx]
  right_inv f := by
    funext x
    cases hfx : f x <;> simp [hfx]

noncomputable def powersetEquivBoolFunctions (S : Set α) : 𝒫 S ≃ (S → Bool) :=
  (Equiv.Set.powerset S).trans (subsetEquivBoolFunctions S)

noncomputable def powersetEquivBoolCoverings (S : Set α) :
    𝒫 S ≃ Set.pi (Set.univ : Set S) (fun _ => (Set.univ : Set Bool)) :=
  (powersetEquivBoolFunctions S).trans (cantorCoveringEquivFun S Bool).symm

theorem mk_powerset_eq_boolCoverings (S : Set α) :
    Cardinal.mk ↥(𝒫 S) = Cardinal.mk (Set.pi (Set.univ : Set S) (fun _ => (Set.univ : Set Bool))) := by
  exact Cardinal.mk_congr (powersetEquivBoolCoverings S)

end MathlibExpansion.SetTheory.Cantor
