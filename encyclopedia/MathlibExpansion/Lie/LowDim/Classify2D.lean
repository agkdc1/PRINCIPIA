import Mathlib

/-!
# Two-dimensional Lie algebras
-/

namespace MathlibExpansion.Lie.LowDim

/--
A basis-like witness for the standard two-dimensional normal form: `e₁` is
nonzero, `e₂` is not on its line, and the two vectors span the algebra.
-/
def BasisLikeTwoDim {K : Type*} {L : Type*} [Field K] [AddCommGroup L] [Module K L]
    (e₁ e₂ : L) : Prop :=
  e₁ ≠ 0 ∧ e₂ ∉ (K ∙ e₁) ∧ ∀ x : L, ∃ a b : K, x = a • e₁ + b • e₂

/--
Non-abelian two-dimensional Lie algebras have the affine normal form.

Citation: Lie--Engel (1893), *Theorie der Transformationsgruppen*, Vol. III,
Chapter 15, Proposition 8, p. 275, together with Chapter 27, Theorem 108,
pp. 596--597.
-/
axiom exists_affine_basis_of_not_isLieAbelian_finrank_two {K : Type*} [Field K] {L : Type*}
    [LieRing L] [LieAlgebra K L] [FiniteDimensional K L]
    (hL : Module.finrank K L = 2) (h : ¬ IsLieAbelian L) :
    ∃ e₁ e₂ : L, BasisLikeTwoDim (K := K) e₁ e₂ ∧ ⁅e₁, e₂⁆ = e₁

/--
Every two-dimensional Lie algebra is abelian or affine.

Citation: Lie--Engel (1893), *Theorie der Transformationsgruppen*, Vol. III,
Chapter 15, Proposition 8, p. 275, together with Chapter 27, Theorem 108,
pp. 596--597.
-/
theorem classify_two_dimensional_lie_algebra {K : Type*} [Field K] {L : Type*}
    [LieRing L] [LieAlgebra K L] [FiniteDimensional K L]
    (hL : Module.finrank K L = 2) :
    IsLieAbelian L ∨
      ∃ e₁ e₂ : L, BasisLikeTwoDim (K := K) e₁ e₂ ∧ ⁅e₁, e₂⁆ = e₁ := by
  by_cases h : IsLieAbelian L
  · exact Or.inl h
  · exact Or.inr (exists_affine_basis_of_not_isLieAbelian_finrank_two hL h)

private def affineLineIdeal {K : Type*} [Field K] {L : Type*}
    [LieRing L] [LieAlgebra K L]
    (e₁ e₂ : L) (hspan : ∀ x : L, ∃ a b : K, x = a • e₁ + b • e₂)
    (hbracket : ⁅e₁, e₂⁆ = e₁) : LieIdeal K L where
  toSubmodule := K ∙ e₁
  lie_mem := by
    intro x m hm
    rcases hspan x with ⟨a, b, rfl⟩
    rcases Submodule.mem_span_singleton.mp hm with ⟨c, rfl⟩
    rw [add_lie]
    apply Submodule.add_mem
    · rw [smul_lie, lie_smul, lie_self, smul_zero, smul_zero]
      exact Submodule.zero_mem _
    · rw [smul_lie, lie_smul]
      apply Submodule.smul_mem
      apply Submodule.smul_mem
      have hneg : -⁅e₂, e₁⁆ ∈ K ∙ e₁ := by
        rw [lie_skew, hbracket]
        exact Submodule.mem_span_singleton_self e₁
      simpa using Submodule.neg_mem (K ∙ e₁) hneg

private theorem not_isSimple_of_affine_basis {K : Type*} [Field K] {L : Type*}
    [LieRing L] [LieAlgebra K L]
    {e₁ e₂ : L} (hbasis : BasisLikeTwoDim (K := K) e₁ e₂) (hbracket : ⁅e₁, e₂⁆ = e₁) :
    ¬ LieAlgebra.IsSimple K L := by
  intro hsimple
  letI : LieAlgebra.IsSimple K L := hsimple
  let I : LieIdeal K L := affineLineIdeal e₁ e₂ hbasis.2.2 hbracket
  have hI_ne_bot : I ≠ ⊥ := by
    intro hI
    apply hbasis.1
    have hmem : e₁ ∈ I := Submodule.mem_span_singleton_self e₁
    rw [hI] at hmem
    simpa using hmem
  have hI_ne_top : I ≠ ⊤ := by
    intro hI
    apply hbasis.2.1
    have hmem : e₂ ∈ I := by
      rw [hI]
      exact LieSubmodule.mem_top (R := K) (L := L) (M := L) e₂
    exact hmem
  rcases LieAlgebra.IsSimple.eq_bot_or_eq_top (R := K) (L := L) I with h | h
  · exact hI_ne_bot h
  · exact hI_ne_top h

/--
No two-dimensional Lie algebra is simple.

Citation: Lie--Engel (1893), *Theorie der Transformationsgruppen*, Vol. III,
Chapter 15, Proposition 9 and the simple/compound definition on p. 276,
using the two-dimensional normal form from Chapter 15, Proposition 8, p. 275,
and Chapter 27, Theorem 108, pp. 596--597.
-/
theorem not_isSimple_of_finrank_two {K : Type*} [Field K] {L : Type*}
    [LieRing L] [LieAlgebra K L] [FiniteDimensional K L]
    (hL : Module.finrank K L = 2) :
    ¬ LieAlgebra.IsSimple K L := by
  intro hsimple
  letI : LieAlgebra.IsSimple K L := hsimple
  have hnonabelian : ¬ IsLieAbelian L := LieAlgebra.IsSimple.non_abelian (R := K) (L := L)
  obtain ⟨e₁, e₂, hbasis, hbracket⟩ :=
    exists_affine_basis_of_not_isLieAbelian_finrank_two hL hnonabelian
  exact not_isSimple_of_affine_basis hbasis hbracket hsimple

end MathlibExpansion.Lie.LowDim
