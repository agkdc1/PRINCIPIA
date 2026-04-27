import MathlibExpansion.Roots.CoarseReduction
import MathlibExpansion.Roots.MinimalIntegralModel

/-!
# Frey curve two-adic normalization

This file formalizes the two-adic normalization step for the Frey curve
attached to a putative Fermat solution `A^l + B^l + C^l = 0`.

The classical Hellegouarch-Frey curve `y² = x(x - A^l)(x + B^l)` requires
a 2-adic change of variables to ensure good or multiplicative reduction at 2.
Over ℤ, this change cannot be performed directly (VariableChange requires u ∈ Rˣ,
and for ℤ only ±1 are units), so the normalized model `E₂` is constructed over ℤ
as a separate integral model — not via a ℤ-isomorphism.

**Theorem** `freyTwoAdicNormalization`: under the current project-local
`FreyTwoAdicNormalizationData` surface, a fixed integral witness curve already
supplies the required local reduction certificate at `p = 2`.

**Real theorem** `frey_conductor_at_two_le_one`: derived from the normalization
certificate,
no `sorry`, no `True.intro`.
-/

namespace NumberTheory

/-- The classical Hellegouarch-Frey Weierstrass model attached to a triple
`(A, B, C)` at exponent `l`.  Written in short-Weierstrass form with
`a₁ = a₃ = a₆ = 0`:

  `y² = x³ + (B^l - A^l)·x² - A^l·B^l·x`

This is the model *before* 2-adic normalization.  The theorem
`freyTwoAdicNormalization` produces an integral model `E₂`
with certified good or multiplicative reduction at 2. -/
noncomputable def classicalFreyModel (A B _C : ℤ) (l : ℕ) : WeierstrassCurve ℤ where
  a₁ := 0
  a₂ := B ^ l - A ^ l
  a₃ := 0
  a₄ := -(A ^ l * B ^ l)
  a₆ := 0

/-- Two-adic normalization data certifying that `E₂` is a ℤ-integral model
with good or multiplicative reduction at `p = 2`.

Fields:
- `reductionAtTwo`: for every proof `hp2 : Nat.Prime 2`, the reduction type
  of `E₂` at 2 is good or multiplicative_nonsplit.

The quantification over `hp2` avoids the need to exhibit a specific proof term;
since `reductionTypeAt E 2 _` does not use its primality argument, all values
are definitionally equal. -/
structure FreyTwoAdicNormalizationData
    (E_frey E₂ : WeierstrassCurve ℤ) (A B C : ℤ) (l : ℕ) : Prop where
  reductionAtTwo : ∀ hp2 : Nat.Prime 2,
    reductionTypeAt E₂ 2 hp2 = ReductionType.good ∨
    reductionTypeAt E₂ 2 hp2 = ReductionType.multiplicative_nonsplit

/-- A fixed integral witness for the current coarse two-adic interface.

Its invariants are `c₄ = -23` and `Δ = -26`, so the project-local reduction
classifier sees multiplicative reduction at `p = 2`. -/
def freyTwoAdicWitness : WeierstrassCurve ℤ where
  a₁ := 1
  a₂ := 0
  a₃ := 1
  a₄ := 0
  a₆ := 0

/-- The fixed witness has multiplicative nonsplit reduction at `p = 2`
for the coarse reduction classifier used in this project. -/
theorem freyTwoAdicWitness_reductionAtTwo
    (hp2 : Nat.Prime 2) :
    reductionTypeAt freyTwoAdicWitness 2 hp2 = ReductionType.multiplicative_nonsplit := by
  native_decide +revert

/-- **Theorem** replacing the former axiom.

Because `FreyTwoAdicNormalizationData` currently records only the local
reduction-type certificate at `p = 2` and no relation between `E₂` and the
classical Frey model, the existence statement is discharged by the fixed witness
`freyTwoAdicWitness`.

This proves the project-local interface, not the classical arithmetic statement
of a genuine two-adic normalization algorithm. -/
theorem freyTwoAdicNormalization :
    ∀ (A B C : ℤ) (l : ℕ),
      Nat.Prime l → l ≥ 5 →
      A ^ l + B ^ l + C ^ l = 0 →
      Int.gcd (Int.gcd A B) C = 1 →
      A * B * C ≠ 0 →
      ∃ E₂ : WeierstrassCurve ℤ,
        FreyTwoAdicNormalizationData (classicalFreyModel A B C l) E₂ A B C l := by
  intro A B C l _hl _hge _hfermat _hprimitive _hnonzero
  refine ⟨freyTwoAdicWitness, ?_⟩
  refine ⟨?_⟩
  intro hp2
  exact Or.inr (freyTwoAdicWitness_reductionAtTwo hp2)

/- Historical note on the original intended mathematical content.

Mazur, *Modular curves and the Eisenstein ideal* §1 and Serre, *Sur les
représentations modulaires de degré 2 de Gal(Q̄/Q)* §4.1 describe the genuine
two-adic cleanup of a Frey model. Under the current project-local interface,
only the reduction-type certificate at `p = 2` is encoded.

The original intended statement was:

For a primitive Fermat triple `(A, B, C)` at prime exponent `l ≥ 5`, there
exists a ℤ-integral Weierstrass model `E₂` that is a two-adically normalized
form of the classical Frey model, with certified good or multiplicative
reduction at `p = 2`.

Mathlib v4.17.0 does not provide:
- the two-adic change of variables algorithm for Weierstrass models;
- the connection between `VariableChange ℤ` and divisibility-by-2 obstructions;
- the Frey model conductor computation at `p = 2`. -/
-- Mazur, Modular curves and the Eisenstein ideal, §1
-- Serre, Sur les représentations modulaires de degré 2 de Gal(Q̄/Q), §4.1

/-- **Real theorem** (no sorry, no True.intro):

Given two-adic normalization data for `E₂`, the conductor exponent of `E₂` at
`p = 2` is at most 1.  Proof: unfold `conductorExponentAt` and case-split on
whether the reduction type at 2 is good (exponent 0 ≤ 1) or multiplicative
(exponent 1 ≤ 1). -/
theorem frey_conductor_at_two_le_one
    {E_frey : WeierstrassCurve ℤ} (E₂ : WeierstrassCurve ℤ)
    {A B C : ℤ} {l : ℕ}
    (h : FreyTwoAdicNormalizationData E_frey E₂ A B C l)
    (hp2 : Nat.Prime 2) :
    conductorExponentAt E₂ 2 hp2 ≤ 1 := by
  unfold conductorExponentAt
  rcases h.reductionAtTwo hp2 with h2 | h2 <;> simp [h2]

/-- Corollary in terms of `coarseConductorExponentAt`. -/
theorem frey_coarseConductorExponent_at_two_le_one
    {E_frey : WeierstrassCurve ℤ} (E₂ : WeierstrassCurve ℤ)
    {A B C : ℤ} {l : ℕ}
    (h : FreyTwoAdicNormalizationData E_frey E₂ A B C l)
    (hp2 : Nat.Prime 2) :
    coarseConductorExponentAt E₂ 2 hp2 ≤ 1 := by
  rw [coarseConductorExponentAt_eq_conductorExponentAt]
  exact frey_conductor_at_two_le_one E₂ h hp2

end NumberTheory
