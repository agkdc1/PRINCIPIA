import MathlibExpansion.ValenceFormula

/-!
# Sturm Dimension Bound for `S₂(Γ₀(2))` — Session 22

The Sturm bound for weight-`k` modular forms on a congruence subgroup Γ with
index μ gives `dim S_k(Γ) ≤ floor(k·μ/12)`. For Γ = Γ₀(2), k = 2, μ = 3:

  `dim S₂(Γ₀(2)) ≤ floor(2·3/12) = floor(1/2) = 0`

This file records the Sturm bound arithmetic as real theorems (zero sorry/axiom)
and names `SturmDimensionBoundPrimitive` — the single remaining Mathlib 4.17 gap
on the route to `S₂(Γ₀(2)) = 0` via the Sturm route.

The primitive is equivalent to `Gamma0TwoWeightTwoCuspFormsVanishPrimitive`
(proved in `ValenceFormula.lean`) under `[FiniteDimensional ℂ (CuspForm (Γ₀(2)) 2)]`.
-/

namespace MathlibExpansion
namespace SturmBound

open MathlibExpansion.RiemannRochBridge
open MathlibExpansion.ValenceFormula
open scoped ModularForm

noncomputable section

/-! ### Sturm bound arithmetic -/

/-- The raw Sturm dimension bound: `floor(k·μ/12)` for weight `k` and index `μ`. -/
def sturmDimensionBound (k mu : ℕ) : ℕ := k * mu / 12

/-- For `Γ₀(2)` (index 3) at weight 2: `floor(2·3/12) = 0`. -/
theorem sturmDimensionBound_gamma0_two_weight_two :
    sturmDimensionBound 2 3 = 0 := by
  norm_num [sturmDimensionBound]

/-- `dim ≤ sturmDimensionBound 2 3` forces `dim = 0` since the bound is 0. -/
theorem dim_zero_of_sturm_bound_le
    (h : Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) ≤
         sturmDimensionBound 2 3) :
    Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) = 0 := by
  rw [sturmDimensionBound_gamma0_two_weight_two] at h
  omega

/-- The Sturm budget `0` is strictly less than the `∞`-cusp lower bound `n ≥ 1`. -/
theorem sturmBound_lt_ord_inf_lower_bound (n : ℕ) (hn : 1 ≤ n) :
    sturmDimensionBound 2 3 < n := by
  rw [sturmDimensionBound_gamma0_two_weight_two]
  exact hn

/-! ### SturmDimensionBoundPrimitive -/

/-- **SturmDimensionBoundPrimitive** — the classical Sturm dimension bound
for `S₂(Γ₀(2))`:

  `dim S₂(Γ₀(2)) ≤ floor(2·3/12) = 0`

**Mathlib 4.17 gap:** Requires the weight-`k` dimension formula for `Γ₀(N)`
(Diamond–Shurman §3.1). Named as `Prop`, not `axiom`. Equivalent to
`Gamma0TwoWeightTwoCuspFormsVanishPrimitive` under `[FiniteDimensional]`. -/
def SturmDimensionBoundPrimitive : Prop :=
  Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) ≤
    sturmDimensionBound 2 3

/-- `SturmDimensionBoundPrimitive` directly gives `dim S₂(Γ₀(2)) = 0`. -/
theorem dim_S2_eq_zero_of_sturm_primitive (h : SturmDimensionBoundPrimitive) :
    Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) = 0 :=
  dim_zero_of_sturm_bound_le h

/-! ### Equivalence with ValenceFormula vanishing primitive -/

/-- **Backward direction (zero sorry/axiom).**
`Gamma0TwoWeightTwoCuspFormsVanishPrimitive → SturmDimensionBoundPrimitive`.
`∀ f = 0` → `Subsingleton` → `finrank = 0 ≤ 0 = sturmDimensionBound 2 3`. -/
theorem sturmPrimitive_of_cuspFormsVanish
    (h : Gamma0TwoWeightTwoCuspFormsVanishPrimitive) :
    SturmDimensionBoundPrimitive := by
  unfold SturmDimensionBoundPrimitive
  rw [sturmDimensionBound_gamma0_two_weight_two]
  haveI : Subsingleton (CuspForm (CongruenceSubgroup.Gamma0 2) 2) :=
    ⟨fun a b => by rw [h a, h b]⟩
  have h0 : Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) = 0 :=
    Module.finrank_zero_of_subsingleton
  omega

/-- **Forward direction (conditional on `FiniteDimensional`, zero sorry/axiom).**
`SturmDimensionBoundPrimitive → Gamma0TwoWeightTwoCuspFormsVanishPrimitive`
under `[FiniteDimensional ℂ (CuspForm (Γ₀(2)) 2)]`.
Uses `finrank_zero_iff_forall_zero` (Mathlib `LinearAlgebra.FiniteDimensional.Defs`). -/
theorem cuspFormsVanish_of_sturmPrimitive
    [FiniteDimensional ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2)]
    (h : SturmDimensionBoundPrimitive) :
    Gamma0TwoWeightTwoCuspFormsVanishPrimitive :=
  finrank_zero_iff_forall_zero.mp (dim_S2_eq_zero_of_sturm_primitive h)

/-- Unconditional `Iff` under `[FiniteDimensional]` (zero sorry/axiom). -/
theorem sturmPrimitive_iff_cuspFormsVanish
    [FiniteDimensional ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2)] :
    SturmDimensionBoundPrimitive ↔
    Gamma0TwoWeightTwoCuspFormsVanishPrimitive :=
  ⟨cuspFormsVanish_of_sturmPrimitive, sturmPrimitive_of_cuspFormsVanish⟩

#check @sturmDimensionBound
#check @sturmDimensionBound_gamma0_two_weight_two
#check @SturmDimensionBoundPrimitive
#check @dim_S2_eq_zero_of_sturm_primitive
#check @sturmPrimitive_of_cuspFormsVanish
#check @cuspFormsVanish_of_sturmPrimitive
#check @sturmPrimitive_iff_cuspFormsVanish

end
end SturmBound
end MathlibExpansion
