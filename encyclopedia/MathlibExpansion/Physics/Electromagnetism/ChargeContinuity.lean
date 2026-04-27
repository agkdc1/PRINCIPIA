import Mathlib.Analysis.Calculus.Deriv.Add
import MathlibExpansion.Physics.Electromagnetism.GaussElectric
import MathlibExpansion.Physics.Electromagnetism.AmpereMaxwell

/-!
# Charge continuity (Maxwell 1873, Arts. 607, 610, 612)

Derivation shell showing that Maxwell's displacement-current correction forces
the textbook continuity equation `∂ρ/∂t + div K = 0`. This is the
encyclopedia-value theorem: it is the reason Maxwell's correction is not
cosmetic.

Article 607: the total current is solenoidal, `div 𝔠 = 0`.
Article 610: `𝔠 = 𝔎 + ∂𝔇/∂t`.
Article 612: `ρ = div 𝔇`.
Eliminating `𝔇` via Article 612 and `𝔠` via Article 610 gives
`∂ρ/∂t + div 𝔎 = 0`.

Discharges Maxwell queue item `ME-05`.

This file introduces no local axioms. The smooth mixed-derivative fact
`timeDeriv_divergence_commute` is exposed as a theorem from an explicit
proof-obligation hypothesis `TimeDerivDivergenceCommutes`, rather than as a
global no-hypothesis axiom. `direction = upstream`.
-/

noncomputable section

namespace MathlibExpansion.Physics.Electromagnetism

open MathlibExpansion.Analysis.VectorCalculus

/-- Maxwell's charge-continuity law, packaged as a `Prop`:
`∂ρ(x,·)/∂t (t) + div K(·, t) x = 0`. -/
def MaxwellContinuity (ρ : TimeScalarField) (K : TimeVectorField) : Prop :=
  ∀ x t, timeDeriv (scalarPath ρ x) t + divergence (spatialSliceVec K t) x = 0

/-- Proof obligation for the smooth-field commutation used in Maxwell 1873,
Arts. 610 and 612: `∂/∂t div F = div (∂F/∂t)`. This is the Maxwell-shaped
instance of the classical equality of mixed partial derivatives under the
usual smoothness hypotheses. -/
def TimeDerivDivergenceCommutes (F : TimeVectorField) : Prop :=
  ∀ x t,
  timeDeriv (fun τ => divergence (spatialSliceVec F τ) x) t
    = divergence (spatialSliceVec (fun y τ => timeDerivVec (vectorPath F y) τ) t) x

/-- Maxwell-shaped extractor for the smooth-field commutation
`∂/∂t div F = div (∂F/∂t)`. The mathematical content is now an explicit
hypothesis, so this target file carries no local axiom for mixed derivative
exchange. -/
theorem timeDeriv_divergence_commute
    (F : TimeVectorField) (hF : TimeDerivDivergenceCommutes F)
    (x : SpatialPoint) (t : ℝ) :
  timeDeriv (fun τ => divergence (spatialSliceVec F τ) x) t
    = divergence (spatialSliceVec (fun y τ => timeDerivVec (vectorPath F y) τ) t) x :=
  hF x t

/-- The charge-density path `ρ(x,·)` agrees (at the
derivative level) with the path `t ↦ div D(·,t) x`. This is the time-space
slice of Maxwell 1873, Article 612, `ρ = div D`. -/
theorem timeDeriv_gauss_electric
    (ρ : TimeScalarField) (D : TimeVectorField)
    (_hρ : ∀ x t, ρ x t = divergence (spatialSliceVec D t) x)
    (x : SpatialPoint) (t : ℝ) :
  timeDeriv (scalarPath ρ x) t
    = timeDeriv (fun τ => divergence (spatialSliceVec D τ) x) t := by
  unfold timeDeriv scalarPath
  exact congrArg (fun f : ℝ → ℝ => deriv f t) (funext (_hρ x))

/-- Pointwise differentiability hypotheses sufficient for additivity of the
coordinate divergence at `x`. -/
def DivergenceAddDifferentiableAt (F G : VectorField) (x : SpatialPoint) : Prop :=
  ∀ i : Fin 3,
    DifferentiableAt ℝ (fun s : ℝ => F (Function.update x i s) i) (x i) ∧
    DifferentiableAt ℝ (fun s : ℝ => G (Function.update x i s) i) (x i)

/-- The spatial divergence is additive in its vector argument whenever the
two coordinate-line derivatives used by `divergence` exist at the point.
This is the local Mathlib `deriv_add` theorem specialized to the Maxwell
coordinate divergence package. -/
theorem divergence_add_spatial
    (F G : VectorField) (x : SpatialPoint)
    (hFG : DivergenceAddDifferentiableAt F G x) :
  divergence (fun y => F y + G y) x = divergence F x + divergence G x := by
  unfold divergence partialDeriv
  simp only [Pi.add_apply]
  trans ∑ i : Fin 3,
      (deriv (fun s : ℝ => F (Function.update x i s) i) (x i)
        + deriv (fun s : ℝ => G (Function.update x i s) i) (x i))
  · exact Finset.sum_congr rfl (fun i _ => deriv_add (hFG i).1 (hFG i).2)
  · exact Finset.sum_add_distrib

/-- Maxwell 1873, Arts. 607 + 610 + 612: if `ρ = div D` in space and time and
if the total current `C = K + ∂D/∂t` is divergence-free at every moment,
then the conduction current `K` and the charge density `ρ` satisfy the
continuity equation `∂ρ/∂t + div K = 0`. -/
theorem maxwell_continuity_of_displacement_current
    (ρ : TimeScalarField) (K D : TimeVectorField)
    (hρ : ∀ x t, ρ x t = divergence (spatialSliceVec D t) x)
    (hD : TimeDerivDivergenceCommutes D)
    (hC : ∀ x t,
      divergence (spatialSliceVec K t) x
        + divergence (spatialSliceVec
            (fun y τ => timeDerivVec (vectorPath D y) τ) t) x = 0) :
    MaxwellContinuity ρ K := by
  intro x t
  -- Step 1: rewrite `∂ρ/∂t` as `∂/∂t (div D)` using Article 612.
  have h1 : timeDeriv (scalarPath ρ x) t
      = timeDeriv (fun τ => divergence (spatialSliceVec D τ) x) t :=
    timeDeriv_gauss_electric ρ D hρ x t
  -- Step 2: swap ∂/∂t with div via the explicit commutation hypothesis.
  have h2 : timeDeriv (fun τ => divergence (spatialSliceVec D τ) x) t
      = divergence
          (spatialSliceVec (fun y τ => timeDerivVec (vectorPath D y) τ) t) x :=
    timeDeriv_divergence_commute D hD x t
  -- Step 3: div (K + ∂D/∂t) = 0 in Article 607 form.
  have h3 : divergence (spatialSliceVec K t) x
      + divergence
          (spatialSliceVec (fun y τ => timeDerivVec (vectorPath D y) τ) t) x
        = 0 := hC x t
  -- Chain the rewrites and land the continuity equation.
  calc timeDeriv (scalarPath ρ x) t + divergence (spatialSliceVec K t) x
      = timeDeriv (fun τ => divergence (spatialSliceVec D τ) x) t
          + divergence (spatialSliceVec K t) x := by rw [h1]
    _ = divergence
          (spatialSliceVec (fun y τ => timeDerivVec (vectorPath D y) τ) t) x
          + divergence (spatialSliceVec K t) x := by rw [h2]
    _ = divergence (spatialSliceVec K t) x
          + divergence
              (spatialSliceVec
                (fun y τ => timeDerivVec (vectorPath D y) τ) t) x := by
            ring
    _ = 0 := h3

/-- Unfolding lemma: the continuity wrapper is the pointwise identity. -/
theorem maxwell_continuity_iff
    (ρ : TimeScalarField) (K : TimeVectorField) :
    MaxwellContinuity ρ K ↔
      ∀ x t, timeDeriv (scalarPath ρ x) t
        + divergence (spatialSliceVec K t) x = 0 :=
  Iff.rfl

end MathlibExpansion.Physics.Electromagnetism
