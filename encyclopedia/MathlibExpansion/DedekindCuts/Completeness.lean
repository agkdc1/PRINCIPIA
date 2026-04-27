import Mathlib.Data.Real.Archimedean

/-!
# Dedekind-style partition completeness

This file packages Dedekind's partition formulation of completeness for `ℝ`
using Mathlib's existing least-upper-bound API.
-/

namespace MathlibExpansion
namespace DedekindCuts

open Set

theorem existsUnique_partition_point
    (A₁ A₂ : Set ℝ)
    (hA1 : A₁.Nonempty)
    (hA2 : A₂.Nonempty)
    (_hdisj : Disjoint A₁ A₂)
    (_hcover : A₁ ∪ A₂ = Set.univ)
    (hsep : ∀ {x y}, x ∈ A₁ → y ∈ A₂ → x ≤ y) :
    ∃! r : ℝ, IsLUB A₁ r ∧ ∀ y ∈ A₂, r ≤ y := by
  let ub : ℝ := hA2.choose
  have hub : ub ∈ A₂ := hA2.choose_spec
  have hBdd : BddAbove A₁ := ⟨ub, fun x hx => hsep hx hub⟩
  obtain ⟨r, hr⟩ := Real.exists_isLUB hA1 hBdd
  refine ⟨r, ?_, ?_⟩
  · constructor
    · exact hr
    · intro y hy
      exact hr.2 (by
        show y ∈ upperBounds A₁
        intro x hx
        exact hsep hx hy)
  · intro s hs
    exact hs.1.unique hr

end DedekindCuts
end MathlibExpansion
