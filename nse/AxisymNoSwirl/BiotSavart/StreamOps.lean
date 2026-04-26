import Mathlib
import NavierStokes.Geometry.Cylindrical.Basic
import NavierStokes.Geometry.Cylindrical.Frame
import NavierStokes.Geometry.Cylindrical.Gradient
import NavierStokes.AxisymNoSwirl.BiotSavart.Carrier

/-!
# NavierStokes.AxisymNoSwirl.BiotSavart.StreamOps

Concrete (non-opaque) cylindrical scalar operators for the axisymmetric no-swirl
Biot-Savart forward map.

Replaces the post-recon `opaque divergence` and `opaque thetaCurl` placeholders with
direct definitions in terms of `radialDeriv`, `azimuthalDeriv`, and `verticalDeriv`
from `NavierStokes.Geometry.Cylindrical.Gradient` (and ultimately from `fderiv`).

## Operators
- `tildeDelta ψ p`        : Stokes stream-function operator (`E²ψ`-style),
                             `radialDeriv (radialDeriv ψ) - (1/r) * radialDeriv ψ + verticalDeriv (verticalDeriv ψ)`
- `reconstruct ψ p`       : forward map `ψ ↦ (u_r, u_θ, u_z)` in cylindrical components
                             stored in the `(.1, .2.1, .2.2)` slots of `E3 = ℝ × ℝ × ℝ`.
                             `u_r = -∂_z ψ`, `u_θ = 0`, `u_z = (1/r) ∂_r(r ψ)`.
- `divergenceCyl u p`     : cylindrical divergence
                             `(1/r) ∂_r(r u_r) + (1/r) ∂_θ u_θ + ∂_z u_z`
- `thetaCurl u p`         : θ-component of curl, `∂_z u_r - ∂_r u_z`.

All operators are defined for *arbitrary* `u : E3 → E3` and `ψ : E3 → ℝ`; off-axis
hypotheses (`p ∈ puncturedSpace`) are left to the *theorems* that consume them.

## Conventions
The `.1, .2.1, .2.2` slots of the cylindrical carrier `E3 = ℝ × ℝ × ℝ` are *interpreted*
as the cylindrical components `(u_r, u_θ, u_z)` for the breach. They are not the Cartesian
components of an ambient vector field. The B8 forward identities are *cylindrical-component*
identities under that interpretation.

This is the recon-stage convention preserved by the post-recon CONSENSUS; the breach
discipline is to make the *operators* (not their interpretation) concrete.

## Note on no-swirl
For the breach, `reconstruct ψ` produces `u_θ ≡ 0` by construction; the `azimuthalDeriv`
term in `divergenceCyl` then vanishes in the divergence-free identity for any ψ.
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

open Real

namespace NavierStokes.AxisymNoSwirl.BiotSavart

open NavierStokes.Geometry.Cylindrical

/-! ## Stream function carrier and off-axis domain -/

/-- Stream functions live on the ambient cylindrical carrier; off-axis constraints are
    carried by `p ∈ puncturedSpace` hypotheses on the theorems. -/
abbrev StreamFunction := E3 → ℝ

/-- Off-axis domain `Ω = {r > 0}`, a notation for the existing punctured cylindrical set. -/
abbrev Ω : Set E3 := puncturedSpace

/-! ## Cylindrical scalar operators -/

/-- Stokes stream-function operator (also called `E²` in axisymmetric NSE literature):
    `E² ψ = ∂²_{rr} ψ - (1/r) ∂_r ψ + ∂²_{zz} ψ`.

    Definition uses only first/second cylindrical directional derivatives; no chart
    transport, no Mathlib `Laplacian` API (which is absent at v4.17.0 for our setting). -/
def tildeDelta (ψ : StreamFunction) (p : E3) : ℝ :=
  radialDeriv (radialDeriv ψ) p
  - (1 / rCyl p) * radialDeriv ψ p
  + verticalDeriv (verticalDeriv ψ) p

/-- Forward Biot-Savart reconstruction `ψ ↦ u`, recorded in cylindrical-component slots.

    `u_r := -∂_z ψ`, `u_θ := 0`, `u_z := (1/r) ∂_r (r ψ)`.

    The `r ψ` packaging in the `u_z` slot makes the cylindrical divergence vanish exactly,
    independent of axisymmetry of `ψ`. -/
def reconstruct (ψ : StreamFunction) (p : E3) : E3 :=
  ( - verticalDeriv ψ p
  , 0
  , (1 / rCyl p) * radialDeriv (fun q => rCyl q * ψ q) p )

/-- Cylindrical divergence (slot interpretation `(u_r, u_θ, u_z) = (.1, .2.1, .2.2)`). -/
def divergenceCyl (u : E3 → E3) (p : E3) : ℝ :=
  (1 / rCyl p) * radialDeriv (fun q => rCyl q * (u q).1) p
  + (1 / rCyl p) * azimuthalDeriv (fun q => (u q).2.1) p
  + verticalDeriv (fun q => (u q).2.2) p

/-- θ-component of cylindrical curl (slot interpretation as above). -/
def thetaCurl (u : E3 → E3) (p : E3) : ℝ :=
  verticalDeriv (fun q => (u q).1) p
  - radialDeriv (fun q => (u q).2.2) p

/-! ## Trivial structural lemmas (sorry-free, no calculus required) -/

/-- The `θ`-slot of `reconstruct ψ` is identically zero (no-swirl by construction). -/
@[simp] lemma reconstruct_theta_zero (ψ : StreamFunction) (p : E3) :
    (reconstruct ψ p).2.1 = 0 := rfl

/-- The radial slot of `reconstruct ψ`. -/
@[simp] lemma reconstruct_r (ψ : StreamFunction) (p : E3) :
    (reconstruct ψ p).1 = -verticalDeriv ψ p := rfl

/-- The vertical slot of `reconstruct ψ`. -/
@[simp] lemma reconstruct_z (ψ : StreamFunction) (p : E3) :
    (reconstruct ψ p).2.2 = (1 / rCyl p) * radialDeriv (fun q => rCyl q * ψ q) p := rfl

/-- No-swirl in the *slot* interpretation: `u_θ ≡ 0`. This is the cylindrical-slot
    analogue of `NoSwirlPolyCyl` (which is the Cartesian-polynomial form and is
    *not* the right predicate when the `.1, .2.1, .2.2` slots carry `(u_r, u_θ, u_z)`). -/
def NoSwirlSlotCyl (u : E3 → E3) : Prop :=
  ∀ x : E3, (u x).2.1 = 0

/-- `reconstruct ψ` is no-swirl in the slot interpretation by construction. -/
lemma reconstruct_noSwirlSlotCyl (ψ : StreamFunction) :
    NoSwirlSlotCyl (reconstruct ψ) := by
  intro x
  rfl

/-- The `azimuthalDeriv` of the (identically zero) `θ`-slot of `reconstruct ψ` vanishes. -/
lemma azimuthalDeriv_reconstruct_theta_zero (ψ : StreamFunction) (p : E3) :
    azimuthalDeriv (fun q => (reconstruct ψ q).2.1) p = 0 := by
  -- The function being differentiated is the constant zero on E3.
  have hfun : (fun q : E3 => (reconstruct ψ q).2.1) = (fun _ : E3 => (0 : ℝ)) := by
    funext q
    simp [reconstruct]
  rw [hfun]
  -- fderiv of a constant is the zero map; applied to anything yields 0.
  simp [azimuthalDeriv]

/-! ## Reduced divergence (no-swirl form)

For any `ψ`, `divergenceCyl (reconstruct ψ) p` collapses to
  `(1/r) * radialDeriv (fun q => rCyl q * (reconstruct ψ q).1) p
   + verticalDeriv (fun q => (reconstruct ψ q).2.2) p`
because the azimuthal term vanishes identically. We keep this as a *lemma*, not the
definition of `divergenceCyl`, so the operator stays general for non-no-swirl fields. -/

lemma divergenceCyl_reconstruct_no_swirl_collapse (ψ : StreamFunction) (p : E3) :
    divergenceCyl (reconstruct ψ) p
      = (1 / rCyl p) * radialDeriv (fun q => rCyl q * (reconstruct ψ q).1) p
        + verticalDeriv (fun q => (reconstruct ψ q).2.2) p := by
  unfold divergenceCyl
  rw [azimuthalDeriv_reconstruct_theta_zero]
  ring

end NavierStokes.AxisymNoSwirl.BiotSavart

end
