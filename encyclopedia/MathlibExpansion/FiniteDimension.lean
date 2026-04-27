import MathlibExpansion.SturmBound

/-!
# FiniteDimensional instance for `CuspForm(Γ₀(2), 2)` — Session 23

Derives `FiniteDimensional ℂ (CuspForm (Γ₀(2)) 2)` from
`Gamma0TwoWeightTwoCuspFormsVanishPrimitive` (the vanishing primitive from S21/S22),
then chains it with the S22 biconditional to give the unconditional closure:

  given `Gamma0TwoWeightTwoCuspFormsVanishPrimitive`,
  `SturmDimensionBoundPrimitive ↔ Gamma0TwoWeightTwoCuspFormsVanishPrimitive`
  holds without a bare `[FiniteDimensional]` typeclass hole.

Route: vanish primitive → `Subsingleton` → `Module.rank = 0`
       → `FiniteDimensional` (via `rank_subsingleton'` +
       `FiniteDimensional.of_rank_eq_zero`).

This closes the `[FiniteDimensional]` typeclass gap that conditioned S22's
`sturmPrimitive_iff_cuspFormsVanish` and `cuspFormsVanish_of_sturmPrimitive`.

**Mathlib 4.17 status:**
- `rank_subsingleton' [Subsingleton M] : Module.rank R M = 0` — in Mathlib ✓
- `FiniteDimensional.of_rank_eq_zero` — in Mathlib ✓
- `FiniteDimensional ℂ (CuspForm (Γ₀(2)) 2)` unconditionally — NOT in Mathlib
  (LevelOne.lean line 14: TODO). Our version is conditional on the vanishing
  primitive.
-/

namespace MathlibExpansion
namespace FiniteDimension

open MathlibExpansion.ValenceFormula
open MathlibExpansion.SturmBound
open scoped ModularForm

noncomputable section

/-! ### FiniteDimensional from the vanishing primitive -/

/-- **S23-A — FiniteDimensional from Subsingleton (zero sorry/axiom).**

If `Gamma0TwoWeightTwoCuspFormsVanishPrimitive` holds then
`CuspForm (Γ₀(2)) 2` is a `Subsingleton`, hence has `Module.rank = 0`
(via `rank_subsingleton'`), hence is `FiniteDimensional`
(via `FiniteDimensional.of_rank_eq_zero`).

This is the backward gift from the vanishing primitive: once all cusp forms
are known to be zero the space is trivially finite-dimensional, which in turn
lets `finrank_zero_iff_forall_zero` discharge the forward direction of the
S22 biconditional. -/
theorem finiteDimensional_of_cuspFormsVanish
    (h : Gamma0TwoWeightTwoCuspFormsVanishPrimitive) :
    FiniteDimensional ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) := by
  haveI : Subsingleton (CuspForm (CongruenceSubgroup.Gamma0 2) 2) :=
    ⟨fun a b => by rw [h a, h b]⟩
  exact FiniteDimensional.of_rank_eq_zero (rank_subsingleton' ℂ _)

/-- **S23-B — FiniteDimPrimitive (Prop wrapper, zero sorry/axiom).**

Named primitive for the `FiniteDimensional` typeclass on `CuspForm (Γ₀(2)) 2`.
Not a Mathlib gap when derived from `Gamma0TwoWeightTwoCuspFormsVanishPrimitive`;
is a gap if sought unconditionally (Mathlib 4.17 LevelOne.lean TODO). -/
def FiniteDimPrimitive : Prop :=
  FiniteDimensional ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2)

/-- The vanishing primitive implies `FiniteDimPrimitive`. -/
theorem finiteDimPrimitive_of_cuspFormsVanish
    (h : Gamma0TwoWeightTwoCuspFormsVanishPrimitive) :
    FiniteDimPrimitive :=
  finiteDimensional_of_cuspFormsVanish h

/-! ### Unconditional biconditional closure -/

/-- **S23-KEY — Unconditional Iff from the vanishing primitive (zero sorry/axiom).**

Under `Gamma0TwoWeightTwoCuspFormsVanishPrimitive`, the S22 biconditional
`SturmDimensionBoundPrimitive ↔ Gamma0TwoWeightTwoCuspFormsVanishPrimitive`
holds without a bare `[FiniteDimensional]` typeclass hole.
The instance is synthesized locally from the hypothesis via S23-A. -/
theorem sturmPrimitive_iff_cuspFormsVanish_unconditional
    (h : Gamma0TwoWeightTwoCuspFormsVanishPrimitive) :
    SturmDimensionBoundPrimitive ↔
    Gamma0TwoWeightTwoCuspFormsVanishPrimitive := by
  haveI : FiniteDimensional ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) :=
    finiteDimensional_of_cuspFormsVanish h
  exact sturmPrimitive_iff_cuspFormsVanish

/-- **S23-DIM — `finrank S₂(Γ₀(2)) = 0` unconditional from the vanishing primitive
(zero sorry/axiom).**

Combines S23-A with `dim_S2_eq_zero_of_sturm_primitive` and
`sturmPrimitive_of_cuspFormsVanish` for an explicit `finrank = 0` statement. -/
theorem dim_S2_gamma0_two_eq_zero_of_cuspFormsVanish
    (h : Gamma0TwoWeightTwoCuspFormsVanishPrimitive) :
    Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) = 0 := by
  haveI : FiniteDimensional ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) :=
    finiteDimensional_of_cuspFormsVanish h
  exact dim_S2_eq_zero_of_sturm_primitive (sturmPrimitive_of_cuspFormsVanish h)

#check @finiteDimensional_of_cuspFormsVanish
#check @FiniteDimPrimitive
#check @finiteDimPrimitive_of_cuspFormsVanish
#check @sturmPrimitive_iff_cuspFormsVanish_unconditional
#check @dim_S2_gamma0_two_eq_zero_of_cuspFormsVanish

end
end FiniteDimension
end MathlibExpansion
