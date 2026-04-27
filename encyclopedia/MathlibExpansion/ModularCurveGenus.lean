import Mathlib

/-!
# Index of Γ₀(2) in SL(2,ℤ) from scratch

This file builds the index
`[SL(2,ℤ) : Γ₀(2)] = 3`
from ground truth, starting from Mathlib's `CongruenceSubgroup.Gamma0`
definition and `Subgroup.index` machinery (no ad-hoc axioms, no `sorry`).

The plan:

1. Introduce the upper-triangular subgroup `upperTri2 ≤ SL(2, ZMod 2)` of
   matrices whose lower-left entry is zero (equivalently, the stabiliser of the
   line ⟨e₀⟩ in (ZMod 2)²).
2. Show `SL(2, ZMod 2)` has cardinality 6 and `upperTri2` has cardinality 2,
   hence `upperTri2.index = 3`.
3. Show the reduction map `SLMOD(2) : SL(2, ℤ) →* SL(2, ZMod 2)` is
   surjective by exhibiting a section on the 6 classes.
4. Recognise `Γ₀(2) = upperTri2.comap SLMOD(2)`.
5. Conclude via `Subgroup.index_comap_of_surjective` that the index of
   `Γ₀(2)` in `SL(2,ℤ)` is 3.
-/

namespace MathlibExpansion
namespace ModularCurveGenus

open Matrix Matrix.SpecialLinearGroup CongruenceSubgroup
open scoped MatrixGroups

local notation "SLMOD(" N ")" =>
  @Matrix.SpecialLinearGroup.map (Fin 2) _ _ _ _ _ _ (Int.castRingHom (ZMod N))

/-- The upper-triangular subgroup of `SL(2, ZMod 2)`: matrices whose
lower-left entry is zero. -/
def upperTri2 : Subgroup SL(2, ZMod 2) where
  carrier := { g | g 1 0 = 0 }
  one_mem' := by
    show (1 : SL(2, ZMod 2)) 1 0 = 0
    simp [Matrix.one_apply]
  mul_mem' := by
    rintro a b ha hb
    show (a * b : SL(2, ZMod 2)) 1 0 = 0
    change (a.1 * b.1) 1 0 = 0
    have hx := (Matrix.two_mul_expl a.1 b.1).2.2.1
    rw [hx, show a.1 1 0 = (0 : ZMod 2) from ha,
            show b.1 1 0 = (0 : ZMod 2) from hb]
    ring
  inv_mem' := by
    rintro a ha
    show (a⁻¹ : SL(2, ZMod 2)) 1 0 = 0
    rw [SL2_inv_expl a]
    -- After SL2_inv_expl, (a⁻¹).1 is `![![a.1 1 1, -a.1 0 1], ![-a.1 1 0, a.1 0 0]]`.
    -- The element at (1,0) is `-a.1 1 0`, which we need to show is zero.
    change (-a.1 1 0 : ZMod 2) = 0
    rw [show a.1 1 0 = (0 : ZMod 2) from ha]
    ring

@[simp] theorem mem_upperTri2 {M : SL(2, ZMod 2)} :
    M ∈ upperTri2 ↔ M 1 0 = 0 := Iff.rfl

instance : DecidablePred (· ∈ upperTri2) := by
  intro g
  change Decidable (g 1 0 = 0)
  infer_instance

/-! ### Cardinality of SL(2, ZMod 2) and upperTri2 -/

/-- `SL(2, ZMod 2)` has exactly 6 elements. -/
theorem card_SL2_ZMod2 : Fintype.card SL(2, ZMod 2) = 6 := by
  decide

/-- The upper-triangular subgroup of `SL(2, ZMod 2)` has exactly 2 elements. -/
theorem card_upperTri2 : Fintype.card upperTri2 = 2 := by
  decide

/-! ### Index of `upperTri2` in `SL(2, ZMod 2)` -/

/-- The index `[SL(2, ZMod 2) : upperTri2] = 3`. -/
theorem index_upperTri2 : upperTri2.index = 3 := by
  have hmul : upperTri2.index * Nat.card upperTri2 = Nat.card SL(2, ZMod 2) :=
    Subgroup.index_mul_card upperTri2
  have hG : Nat.card SL(2, ZMod 2) = 6 := by
    simpa [Nat.card_eq_fintype_card] using card_SL2_ZMod2
  have hH : Nat.card upperTri2 = 2 := by
    simpa [Nat.card_eq_fintype_card] using card_upperTri2
  rw [hG, hH] at hmul
  omega

/-! ### `Γ₀(2) = upperTri2.comap SLMOD(2)` -/

theorem gamma0Two_eq_comap :
    Gamma0 2 = upperTri2.comap (SLMOD(2)) := by
  ext A
  constructor
  · intro hA
    rw [Gamma0_mem] at hA
    rw [Subgroup.mem_comap, mem_upperTri2]
    rw [SL_reduction_mod_hom_val 2 A]
    exact hA
  · intro hA
    rw [Subgroup.mem_comap, mem_upperTri2] at hA
    rw [Gamma0_mem]
    rw [SL_reduction_mod_hom_val 2 A] at hA
    exact hA

/-! ### Surjectivity of `SLMOD(2)` -/

/-- Explicit section `SL(2, ZMod 2) → SL(2, ℤ)` for the reduction map at 2.
Dispatches on the 6 elements of `SL(2, ZMod 2)` using its entries. -/
private def lift2 (M : SL(2, ZMod 2)) : SL(2, ℤ) :=
  let a00 := M 0 0
  let a01 := M 0 1
  let a10 := M 1 0
  let a11 := M 1 1
  if a10 = 0 then
    if a01 = 0 then
      -- Identity
      ⟨!![1, 0; 0, 1], by simp [Matrix.det_fin_two]⟩
    else
      -- T = (1 1; 0 1)
      ⟨!![1, 1; 0, 1], by simp [Matrix.det_fin_two]⟩
  else if a00 = 0 then
    if a11 = 0 then
      -- S' = (0 1; 1 0) mod 2, lift (0 -1; 1 0), det = 1
      ⟨!![0, -1; 1, 0], by simp [Matrix.det_fin_two]⟩
    else
      -- (0 1; 1 1) mod 2, lift (0 -1; 1 1), det = 1
      ⟨!![0, -1; 1, 1], by simp [Matrix.det_fin_two]⟩
  else
    -- a00 = 1, a10 = 1
    if a11 = 0 then
      -- (1 1; 1 0) mod 2, lift (1 -1; 1 0), det = 1
      ⟨!![1, -1; 1, 0], by simp [Matrix.det_fin_two]⟩
    else
      -- (1 0; 1 1) mod 2, lift (1 0; 1 1), det = 1
      ⟨!![1, 0; 1, 1], by simp [Matrix.det_fin_two]⟩

/-- The reduction map `SL(2, ℤ) →* SL(2, ZMod 2)` at 2 is surjective. -/
theorem slmod2_surjective : Function.Surjective (SLMOD(2)) := by
  intro M
  refine ⟨lift2 M, Subtype.ext ?_⟩
  -- Reduce the claim to equality of underlying matrices.  Both sides are
  -- in `Matrix (Fin 2) (Fin 2) (ZMod 2)`; equality there is decidable, so
  -- once we revert `M`, the statement ranges over the 6 elements of
  -- `SL(2, ZMod 2)` and `native_decide` enumerates them.
  revert M
  native_decide

/-! ### Main theorem -/

/-- The index of the congruence subgroup `Γ₀(2)` in `SL(2, ℤ)` equals 3. -/
theorem gamma0_two_index_eq_three : (Gamma0 2).index = 3 := by
  rw [gamma0Two_eq_comap]
  rw [Subgroup.index_comap_of_surjective _ slmod2_surjective]
  exact index_upperTri2

#check @gamma0_two_index_eq_three

/-! ### Genus of X₀(N): combinatorial formula

The genus formula for the modular curve X₀(N) from Diamond–Shurman 3.1.1:
`g = 1 + μ/12 − ν₂/4 − ν₃/3 − c∞/2`,
where μ = [SL(2,ℤ) : Γ₀(N)], ν₂ and ν₃ count elliptic points of orders 2
and 3 on X₀(N), and c∞ is the number of cusps.

For N = 2: μ = 3 (proven above), ν₂ = 1, ν₃ = 0, c∞ = 2, giving g = 0.
-/

/-- The four combinatorial inputs to the genus formula for X₀(N). -/
structure X0GenusData where
  /-- The index `[SL(2,ℤ) : Γ₀(N)]`. -/
  index  : ℕ
  /-- Number of elliptic points of order 2 on X₀(N). -/
  nu2    : ℕ
  /-- Number of elliptic points of order 3 on X₀(N). -/
  nu3    : ℕ
  /-- Number of cusps of X₀(N). -/
  cusps  : ℕ

/-- Genus of X₀(N) as a rational number from its combinatorial inputs:
  `g = 1 + μ/12 − ν₂/4 − ν₃/3 − c∞/2`. -/
def X0GenusData.genusQ (d : X0GenusData) : ℚ :=
  1 + (d.index : ℚ)/12 - (d.nu2 : ℚ)/4 - (d.nu3 : ℚ)/3 - (d.cusps : ℚ)/2

/-- Concrete combinatorial data for X₀(2): μ = 3, ν₂ = 1, ν₃ = 0, c∞ = 2.
The index matches `gamma0_two_index_eq_three`. The values ν₂ = 1, ν₃ = 0,
c∞ = 2 are the standard values for level 2 (Diamond–Shurman 3.7, 3.8). -/
def x0GenusData_two : X0GenusData :=
  { index := 3, nu2 := 1, nu3 := 0, cusps := 2 }

/-- The rational genus of X₀(2) from combinatorial data is 0. -/
theorem x0GenusData_two_genusQ : x0GenusData_two.genusQ = 0 := by
  unfold X0GenusData.genusQ x0GenusData_two
  norm_num

/-- The genus is integer-valued for X₀(2): 0. -/
theorem x0GenusData_two_genusQ_num : x0GenusData_two.genusQ.num = 0 := by
  rw [x0GenusData_two_genusQ]
  decide

/-! ### Weight-two valence budget at level 2 -/

/-- A compact arithmetic obstruction behind the classical valence argument for
weight-two cusp forms on `Γ₀(2)`: if a nonzero form had total valence budget
`1 / 2`, then vanishing at the two cusps alone would already contribute at
least `2`, impossible.

This is only the combinatorial part.  Connecting an arbitrary bundled
`CuspForm (Γ₀(2)) 2` to these cusp/elliptic/ordinary vanishing counts requires
an order-at-cusp and valence-formula API for modular curves. -/
theorem valence_impossible_two_cusps
    (nc ne2 nz : ℕ)
    (h : (nc : ℚ) + (ne2 : ℚ) / 2 + (nz : ℚ) = 1 / 2)
    (hc : 2 ≤ nc) : False := by
  have hnc : (2 : ℚ) ≤ nc := by exact_mod_cast hc
  have hne2 : (0 : ℚ) ≤ ne2 := by exact_mod_cast (Nat.zero_le ne2)
  have hnz : (0 : ℚ) ≤ nz := by exact_mod_cast (Nat.zero_le nz)
  nlinarith

/-! ### Riemann–Roch bridge (relocated)

The former Riemann–Roch bridge, previously stated in this file as an unproved
`axiom` named `cuspform_dim_eq_genus_weight_two` of statement
`(Module.finrank ℂ (CuspForm (CongruenceSubgroup.Gamma0 2) 2) : ℚ) =
x0GenusData_two.genusQ`, together with its derived
`theorem dim_S2_Gamma0_two_eq_zero`, has been moved downstream to
`MathlibExpansion.ModularCurveGenusClosure` and is now a real theorem
consuming
`MathlibExpansion.RiemannRochBridge.Gamma0TwoCuspFormValenceIdentityPrimitive`
(the width-weighted weight-two valence identity at the cusp `0` of `Γ₀(2)`,
Diamond–Shurman §3.1).  The closure module re-opens
`namespace MathlibExpansion.ModularCurveGenus` so the fully-qualified names
`MathlibExpansion.ModularCurveGenus.cuspform_dim_eq_genus_weight_two` and
`MathlibExpansion.ModularCurveGenus.dim_S2_Gamma0_two_eq_zero` are preserved
for existing consumers. -/

end ModularCurveGenus
end MathlibExpansion
