import Mathlib
import NavierStokes.AxisymNoSwirl.GammaTransport.FiveDRadialLaplacian
import NavierStokes.AxisymNoSwirl.MaxPrinciple.AxisCompatibility

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

open NavierStokes.Geometry.Cylindrical

namespace NavierStokes.AxisymNoSwirl.MaxPrinciple

open NavierStokes.AxisymNoSwirl.GammaTransport

/-- Local alias for the 5D ambient space used by the radial lift. -/
abbrev E5 := R5

/-- Squared horizontal 4-radius in the lifted 5D model. -/
def liftRadiusSq (x : E5) : ℝ :=
  x 0 ^ 2 + x 1 ^ 2 + x 2 ^ 2 + x 3 ^ 2

/-- Horizontal 4-radius in the lifted 5D model. -/
abbrev liftRadius : E5 → ℝ := radialRadius4

/-- Meridian representative of a cylindrical point: same `(r,z)`, zero angular slot. -/
def meridianRepresentative (p : E3) : E3 :=
  (rCyl p, 0, p.2.2)

/-- Embed the meridian representative into the 5D lift space. -/
abbrev embedMeridian : E3 → E5 := radialEmbed

/-- Radial lift `F(y,z) := Γ(|y|,0,z)`. -/
abbrev gammaLiftTo5D (Γ : GammaField) : E5 → ℝ := radialLift Γ

/-- `Γ` can be recovered from its meridian representative. This is the exact axisymmetric
compatibility hypothesis needed to transfer 5D pointwise bounds back to 3D. -/
def CylindricalRepresentativeInvariant (Γ : GammaField) : Prop :=
  ∀ p : E3, Γ p = Γ (meridianRepresentative p)

@[simp] theorem embedMeridian_zero (p : E3) : embedMeridian p 0 = rCyl p := by
  simp [embedMeridian, radialEmbed]

@[simp] theorem embedMeridian_one (p : E3) : embedMeridian p 1 = 0 := by
  simp [embedMeridian, radialEmbed]

@[simp] theorem embedMeridian_two (p : E3) : embedMeridian p 2 = 0 := by
  simp [embedMeridian, radialEmbed]

@[simp] theorem embedMeridian_three (p : E3) : embedMeridian p 3 = 0 := by
  simp [embedMeridian, radialEmbed]

@[simp] theorem embedMeridian_four (p : E3) : embedMeridian p 4 = p.2.2 := by
  simp [embedMeridian, radialEmbed]

theorem liftRadiusSq_nonneg (x : E5) : 0 ≤ liftRadiusSq x := by
  dsimp [liftRadiusSq]
  positivity

theorem liftRadius_nonneg (x : E5) : 0 ≤ liftRadius x := by
  exact Real.sqrt_nonneg _

@[simp] theorem meridianRepresentative_fst (p : E3) :
    (meridianRepresentative p).1 = rCyl p := rfl

@[simp] theorem meridianRepresentative_snd_fst (p : E3) :
    (meridianRepresentative p).2.1 = 0 := rfl

@[simp] theorem meridianRepresentative_snd_snd (p : E3) :
    (meridianRepresentative p).2.2 = p.2.2 := rfl

@[simp] theorem rCyl_meridianRepresentative (p : E3) :
    rCyl (meridianRepresentative p) = rCyl p := by
  calc
    rCyl (meridianRepresentative p)
      = Real.sqrt ((rCyl p) ^ 2 + 0 ^ 2) := by
          simp [meridianRepresentative, rCyl]
    _ = Real.sqrt ((rCyl p) ^ 2) := by simp
    _ = rCyl p := by rw [Real.sqrt_sq (rCyl_nonneg p)]

@[simp] theorem meridianRepresentative_idempotent (p : E3) :
    meridianRepresentative (meridianRepresentative p) = meridianRepresentative p := by
  refine Prod.ext ?_ ?_
  · exact rCyl_meridianRepresentative p
  · refine Prod.ext ?_ ?_
    · rfl
    · rfl

@[simp] theorem liftRadiusSq_embedMeridian (p : E3) :
    liftRadiusSq (embedMeridian p) = rCyl p ^ 2 := by
  rw [liftRadiusSq, embedMeridian_zero, embedMeridian_one, embedMeridian_two,
    embedMeridian_three]
  ring

@[simp] theorem liftRadius_embedMeridian (p : E3) :
    liftRadius (embedMeridian p) = rCyl p := by
  unfold liftRadius radialRadius4
  rw [show embedMeridian p 0 ^ 2 + embedMeridian p 1 ^ 2 + embedMeridian p 2 ^ 2
      + embedMeridian p 3 ^ 2 = rCyl p ^ 2 from liftRadiusSq_embedMeridian p]
  exact Real.sqrt_sq (rCyl_nonneg p)

@[simp] theorem gammaLiftTo5D_embedMeridian (Γ : GammaField) (p : E3) :
    gammaLiftTo5D Γ (embedMeridian p) = Γ (meridianRepresentative p) := by
  unfold gammaLiftTo5D radialLift
  rw [show radialRadius4 (embedMeridian p) = rCyl p from liftRadius_embedMeridian p]
  simp [meridianRepresentative]

/-- B4's 5D bridge specialized to the canonical lift used by the B5 lane. -/
theorem gammaLift_laplacian_eq_gammaDiffusion
    {Γ : GammaField} {p : E3}
    (hp : p ∈ puncturedSpace)
    (hdata : HasFiveDRadialLaplacianData Γ (gammaLiftTo5D Γ) p) :
    laplacian5 (gammaLiftTo5D Γ) (embedMeridian p) = gammaDiffusion Γ p := by
  refine gammaDiffusion_is_5D_radial_Laplacian Γ (gammaLiftTo5D Γ) ?_ p hp hdata
  intro x
  rfl

theorem cylindrical_bound_of_lifted_bound
    {Γ : GammaField} {B : ℝ}
    (hinv : CylindricalRepresentativeInvariant Γ)
    (hbound : ∀ x : E5, |gammaLiftTo5D Γ x| ≤ B) :
    ∀ p : E3, |Γ p| ≤ B := by
  intro p
  calc
    |Γ p| = |Γ (meridianRepresentative p)| := by rw [hinv p]
    _ = |gammaLiftTo5D Γ (embedMeridian p)| := by rw [gammaLiftTo5D_embedMeridian]
    _ ≤ B := hbound (embedMeridian p)

end NavierStokes.AxisymNoSwirl.MaxPrinciple

end
