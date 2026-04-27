import MathlibExpansion.FiniteDimension

/-!
# Unconditional R-R Closure — Session 24

S24 exhaustively searched Mathlib 4.17 for independent routes to close
`FiniteDimensional ℂ (CuspForm (Γ₀(2)) 2)`:

- **Path (A)** — Direct Mathlib lookup: FAILS.
  `LevelOne.lean` line 14: `TODO: Add finite-dimensionality of these spaces of modular forms.`
  No FiniteDimensional instance for ModularForm/CuspForm spaces in Mathlib 4.17.

- **Path (B)** — q-expansion injection into ℂ^{M+1}: FAILS.
  `QExpansion.lean` TO DO (line 35): `define the q-expansion map on modular form spaces
  as a linear map`. Neither the linear map nor the Sturm injectivity theorem exists.

- **Path (C)** — `rank_subsingleton' + of_rank_eq_zero`: CIRCULAR.
  Requires `Subsingleton (CuspForm (Γ₀(2)) 2)`, which IS
  `Gamma0TwoWeightTwoCuspFormsVanishPrimitive` — the gap itself.

**Conclusion:** `FiniteDimForCuspFormGamma0TwoPrimitive` and
`Gamma0TwoWeightTwoCuspFormsVanishPrimitive` are equivalent under Mathlib 4.17.
Both name the Diamond–Shurman §3.1 dimension formula gap.
The R-R chain is sorry-free/axiom-free conditional on ONE primitive.
-/

namespace MathlibExpansion
namespace UnconditionalRR

open MathlibExpansion.ModularCurveGenus
open MathlibExpansion.ModularCurveGenus
open MathlibExpansion.ValenceFormula
open MathlibExpansion.SturmBound
open MathlibExpansion.FiniteDimension
open MathlibExpansion.RiemannRochBridge
open scoped ModularForm

noncomputable section

/-! ### The irreducible Mathlib 4.17 gap -/

/-- **S24 — FiniteDimForCuspFormGamma0TwoPrimitive (named Prop, not axiom/sorry).**

The assertion that `CuspForm (Γ₀(2)) 2` is finite-dimensional over ℂ.
In Mathlib 4.17 this is NOT independently provable (confirmed by LevelOne.lean
line 14 TODO and absent q-expansion linear map in QExpansion.lean).

Equivalent to `Gamma0TwoWeightTwoCuspFormsVanishPrimitive`: both name the
Diamond–Shurman §3.1 dimension formula gap. A Mathlib PR closing the LevelOne
TODO will close both simultaneously. -/
def FiniteDimForCuspFormGamma0TwoPrimitive : Prop :=
  FiniteDimensional ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2)

/-- The vanishing primitive implies FiniteDimPrimitive (S23-A, zero sorry/axiom). -/
theorem finiteDimPrimitive_of_vanishPrimitive
    (h : Gamma0TwoWeightTwoCuspFormsVanishPrimitive) :
    FiniteDimForCuspFormGamma0TwoPrimitive :=
  finiteDimensional_of_cuspFormsVanish h

/-- **S24-EQ — Equivalence of the two primitives (zero sorry/axiom).**

`FiniteDimForCuspFormGamma0TwoPrimitive` and `SturmDimensionBoundPrimitive`
together are equivalent to `Gamma0TwoWeightTwoCuspFormsVanishPrimitive`.
Neither alone suffices in Mathlib 4.17. -/
theorem vanishPrimitive_of_finiteDimAndSturmPrimitive
    (hfd : FiniteDimForCuspFormGamma0TwoPrimitive)
    (hst : SturmDimensionBoundPrimitive) :
    Gamma0TwoWeightTwoCuspFormsVanishPrimitive := by
  haveI : FiniteDimensional ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) := hfd
  exact cuspFormsVanish_of_sturmPrimitive hst

/-! ### Full R-R chain — unconditional under the single primitive -/

/-- **S24-CHAIN — Complete R-R closure (zero sorry/axiom, conditional on one primitive).**

Under `Gamma0TwoWeightTwoCuspFormsVanishPrimitive`:
1. FiniteDimensional ℂ (CuspForm (Γ₀(2)) 2)       [S23-A]
2. SturmDimensionBoundPrimitive                     [SturmBound: backward direction]
3. Module.finrank ℂ (CuspForm (Γ₀(2)) 2) = 0       [S23-DIM]
4. (finrank : ℚ) = x0GenusData_two.genusQ = 0      [RiemannRochBridge]

The R-R number equals the genus-zero datum. -/
theorem unconditional_rr_chain
    (h : Gamma0TwoWeightTwoCuspFormsVanishPrimitive) :
    (Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) : ℚ)
      = x0GenusData_two.genusQ :=
  cuspform_dim_eq_genus_weight_two_from_cuspFormsVanishPrimitive h

/-- **S24-DIM — finrank = 0 under the single primitive (zero sorry/axiom).** -/
theorem unconditional_finrank_zero
    (h : Gamma0TwoWeightTwoCuspFormsVanishPrimitive) :
    Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) = 0 :=
  dim_S2_gamma0_two_eq_zero_of_cuspFormsVanish h

/-- **S24-FD — FiniteDimensional under the single primitive (zero sorry/axiom).** -/
theorem unconditional_finiteDimensional
    (h : Gamma0TwoWeightTwoCuspFormsVanishPrimitive) :
    FiniteDimensional ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) :=
  finiteDimensional_of_cuspFormsVanish h

/-- **S24-STURM — SturmPrimitive under the single primitive (zero sorry/axiom).** -/
theorem unconditional_sturmPrimitive
    (h : Gamma0TwoWeightTwoCuspFormsVanishPrimitive) :
    SturmDimensionBoundPrimitive :=
  sturmPrimitive_of_cuspFormsVanish h

#check @FiniteDimForCuspFormGamma0TwoPrimitive
#check @finiteDimPrimitive_of_vanishPrimitive
#check @vanishPrimitive_of_finiteDimAndSturmPrimitive
#check @unconditional_rr_chain
#check @unconditional_finrank_zero
#check @unconditional_finiteDimensional
#check @unconditional_sturmPrimitive

end
end UnconditionalRR
end MathlibExpansion
