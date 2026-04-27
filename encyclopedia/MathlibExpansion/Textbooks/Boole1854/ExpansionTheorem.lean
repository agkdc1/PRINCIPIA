import MathlibExpansion.Textbooks.Boole1854.BooleanFormula

/-!
# Boole 1854 expansion, normal forms, and elimination

This file packages the first-wave HVTs from Boole's Chapters V, VI, and XI
against the owner `BooleanFormula` stack.
-/

namespace MathlibExpansion
namespace Textbooks
namespace Boole1854

section BooleanAlgebra

variable {ι α : Type*} [Fintype ι] [DecidableEq ι] [BooleanAlgebra α]

/-- Boole's finite expansion theorem in extensional truth-table form. -/
theorem finite_expansion (v : ι → α) (φ : BooleanFormula ι) :
    eval v φ = φ.sup (minterm v) :=
  rfl

/-- Coefficients are obtained by reading the truth table at the corresponding valuation. -/
theorem coefficient_eq_truthValue' (φ : BooleanFormula ι) (σ : Assignment ι) :
    coefficient φ σ = truthValue φ σ :=
  coefficient_eq_truthValue φ σ

/-- Distinct constituents are disjoint. -/
theorem constituents_pairwise_disjoint (v : ι → α) :
    Pairwise (fun σ τ : Assignment ι => Disjoint (minterm v σ) (minterm v τ)) := by
  intro σ τ hστ
  exact minterm_disjoint v hστ

/-- The full family of constituents partitions the top element. -/
theorem minterms_partition_top (v : ι → α) :
    (Finset.univ : Finset (Assignment ι)).sup (minterm v) = ⊤ :=
  minterms_sup_univ_eq_top v

/-- Canonical sum-of-products form. -/
theorem canonical_sop (v : ι → α) (φ : BooleanFormula ι) :
    eval v φ = φ.sup (minterm v) :=
  rfl

/-- Canonical product-of-sums form, indexed by the falsifying valuations. -/
theorem canonical_pos (v : ι → α) (φ : BooleanFormula ι) :
    eval v φ = φᶜ.inf (maxterm v) := by
  calc
    eval v φ = ((eval v φ)ᶜ)ᶜ := by simp
    _ = (eval v φᶜ)ᶜ := by rw [eval_compl]
    _ = (φᶜ.sup (minterm v))ᶜ := rfl
    _ = φᶜ.inf (fun σ => (minterm v σ)ᶜ) := by rw [Finset.compl_sup]
    _ = φᶜ.inf (maxterm v) := rfl

/-- A developed equation vanishes exactly when each selected constituent vanishes. -/
theorem equation_zero_iff_vanishing_constituents (v : ι → α) (φ : BooleanFormula ι) :
    eval v φ = ⊥ ↔ ∀ σ ∈ φ, minterm v σ = ⊥ := by
  simp [eval, Finset.sup_eq_bot_iff]

/-- Boole's indefinite multiplier bridge `y = v x`. -/
theorem le_iff_exists_indefinite_multiplier (x y : α) :
    y ≤ x ↔ ∃ v : α, y = v ⊓ x := by
  constructor
  · intro hyx
    refine ⟨y, ?_⟩
    exact (inf_eq_left.mpr hyx).symm
  · rintro ⟨v, rfl⟩
    exact inf_le_right

/-- Elimination is the intersection of the `1`-specialization and the `0`-specialization. -/
theorem elimination_eq_inf_specialize (i : ι) (φ : BooleanFormula ι) :
    eliminate i φ = specialize i true φ ⊓ specialize i false φ :=
  rfl

/-- Pointwise truth-table form of Boole's eliminant `f(1) f(0)`. -/
theorem elimination_membership_iff (i : ι) (φ : BooleanFormula ι) (σ : Assignment ι) :
    σ ∈ eliminate i φ ↔
      Function.update σ i true ∈ φ ∧ Function.update σ i false ∈ φ :=
  mem_eliminate_iff i φ σ

end BooleanAlgebra

end Boole1854
end Textbooks
end MathlibExpansion
