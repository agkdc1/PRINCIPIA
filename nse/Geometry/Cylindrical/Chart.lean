import Mathlib
import NavierStokes.Geometry.Cylindrical.Basic

/-!
# NavierStokes.Geometry.Cylindrical.Chart

Branch-indexed cylindrical coordinate `PartialHomeomorph`.

## Strategy (Route B, boardroom CONSENSUS round 2)
- `rotZEquiv (a : ℝ) : E3 ≃ₜ E3` — z-rotation fixing z-axis
- `cylCoord₀ : PartialHomeomorph E3 E3` — principal branch via
  `prodAssoc.symm ∘ (polarCoord × refl ℝ) ∘ prodAssoc`
- `cylChart (a : ℝ) : PartialHomeomorph E3 E3` — branch-a chart
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

open MeasureTheory Set Real
open scoped Real

namespace NavierStokes.Geometry.Cylindrical

/-! ## z-axis rotation homeomorphism -/

/-- Forward map: rotate xy-plane by angle `a`, keep z fixed. -/
def rotZFun (a : ℝ) (p : E3) : E3 :=
  (p.1 * Real.cos a - p.2.1 * Real.sin a,
   p.1 * Real.sin a + p.2.1 * Real.cos a,
   p.2.2)

lemma rotZFun_comp_neg (a : ℝ) (p : E3) : rotZFun (-a) (rotZFun a p) = p := by
  simp only [rotZFun, Real.cos_neg, Real.sin_neg]
  refine Prod.ext ?_ (Prod.ext ?_ rfl)
  · ring_nf; linear_combination p.1 * Real.cos_sq_add_sin_sq a
  · ring_nf; linear_combination p.2.1 * Real.cos_sq_add_sin_sq a

lemma rotZFun_neg_comp (a : ℝ) (p : E3) : rotZFun a (rotZFun (-a) p) = p := by
  simp only [rotZFun, Real.cos_neg, Real.sin_neg]
  refine Prod.ext ?_ (Prod.ext ?_ rfl)
  · ring_nf; linear_combination p.1 * Real.cos_sq_add_sin_sq a
  · ring_nf; linear_combination p.2.1 * Real.cos_sq_add_sin_sq a

lemma continuous_rotZFun (a : ℝ) : Continuous (rotZFun a) := by
  unfold rotZFun; fun_prop

/-- The z-axis rotation by angle `a` as a homeomorphism on E3. -/
def rotZEquiv (a : ℝ) : E3 ≃ₜ E3 where
  toFun := rotZFun a
  invFun := rotZFun (-a)
  left_inv := rotZFun_comp_neg a
  right_inv := rotZFun_neg_comp a
  continuous_toFun := continuous_rotZFun a
  continuous_invFun := continuous_rotZFun (-a)

@[simp] lemma rotZEquiv_apply (a : ℝ) (p : E3) : rotZEquiv a p = rotZFun a p := rfl

/-- rotZ preserves rSq (cylindrical radius is rotation-invariant). -/
lemma rotZFun_rSq (a : ℝ) (p : E3) : rSq (rotZFun a p) = rSq p := by
  simp only [rotZFun, rSq]; ring_nf
  nlinarith [Real.cos_sq_add_sin_sq a, sq_nonneg p.1, sq_nonneg p.2.1,
             mul_self_nonneg (Real.cos a), mul_self_nonneg (Real.sin a)]

/-- rotZ maps puncturedSpace into itself. -/
lemma rotZFun_mem_puncturedSpace {a : ℝ} {p : E3} (hp : p ∈ puncturedSpace) :
    rotZFun a p ∈ puncturedSpace := by
  -- rSq is preserved, and rSq > 0 on puncturedSpace
  have hrSq_pos : 0 < rSq (rotZFun a p) := rotZFun_rSq a p ▸ rSq_pos_of_mem hp
  -- If rotZFun a p were in zAxis, then rSq = 0, contradiction
  intro hmem
  simp only [rSq, rotZFun, zAxis, Set.mem_setOf_eq] at hrSq_pos hmem
  nlinarith [hmem.1 ▸ hmem.2 ▸ hrSq_pos, sq_nonneg (0 : ℝ)]

/-! ## Principal-branch cylindrical chart -/

/-- The principal-branch cylindrical chart, built from `polarCoord × refl ℝ`
    composed with product-associativity homeomorphisms. -/
def cylCoord₀ : PartialHomeomorph E3 E3 :=
  ((Homeomorph.prodAssoc ℝ ℝ ℝ).symm.toPartialHomeomorph.trans
    (polarCoord.prod (PartialHomeomorph.refl ℝ))).trans
    (Homeomorph.prodAssoc ℝ ℝ ℝ).toPartialHomeomorph

/-- Source of `cylCoord₀` (lifted from polarCoord.source). -/
lemma cylCoord₀_source :
    cylCoord₀.source = {p : E3 | 0 < p.1 ∨ p.2.1 ≠ 0} := by
  simp only [cylCoord₀, PartialHomeomorph.trans_source, PartialHomeomorph.prod_source,
             Homeomorph.toPartialHomeomorph_source, Set.preimage_univ, Set.inter_univ,
             PartialHomeomorph.refl_source, Set.univ_inter]
  ext ⟨x, y, z⟩; simp [polarCoord, Homeomorph.prodAssoc]

/-- Target of `cylCoord₀`. -/
lemma cylCoord₀_target :
    cylCoord₀.target = Set.Ioi (0 : ℝ) ×ˢ (Set.Ioo (-π) π ×ˢ Set.univ) := by
  simp only [cylCoord₀, PartialHomeomorph.trans_target, PartialHomeomorph.prod_target,
             Homeomorph.toPartialHomeomorph_target, Set.univ_inter,
             PartialHomeomorph.refl_target]
  ext ⟨r, θ, z⟩; simp [polarCoord, Homeomorph.prodAssoc]

/-! ## Branch-a cylindrical chart -/

/-- The branch-`a` cylindrical chart.
    Covers the half-plane obtained by rotating the principal slit by angle `a`. -/
def cylChart (a : ℝ) : PartialHomeomorph E3 E3 :=
  (rotZEquiv (-a)).toPartialHomeomorph.trans cylCoord₀

/-! ## Smoothness -/

/-- Forward map of `cylCoord₀` is C^∞.
    Proof: composition of polarCoord (smooth on source) + smooth associativity homeomorphisms. -/
lemma contDiffOn_cylCoord₀ : ContDiffOn ℝ ⊤ (↑cylCoord₀) cylCoord₀.source := by
  sorry

/-- Inverse of `cylCoord₀` is C^∞ on its target.
    P9 gap: ContDiffAt → ContDiffOn upgrade for PartialHomeomorph.symm not packaged in Mathlib. -/
lemma contDiffOn_cylCoord₀_symm :
    ContDiffOn ℝ ⊤ (↑cylCoord₀.symm) cylCoord₀.target := by
  sorry

/-- Forward map of `cylChart a` is C^∞. -/
lemma contDiffOn_cylChart (a : ℝ) : ContDiffOn ℝ ⊤ (↑(cylChart a)) (cylChart a).source := by
  sorry

/-- Inverse of `cylChart a` is C^∞. -/
lemma contDiffOn_cylChart_symm (a : ℝ) :
    ContDiffOn ℝ ⊤ (↑(cylChart a).symm) (cylChart a).target := by
  sorry

end NavierStokes.Geometry.Cylindrical

end
