import NavierStokes.AxisymNoSwirl.Gamma.Operator
import NavierStokes.Analysis.WeightedSobolev.H1

/-!
# NavierStokes.AxisymNoSwirl.Gamma.Transport

Statement shell for the axisymmetric no-swirl `Γ = ω_θ / r` transport equation.

Scope A only:
- pointwise spatial identity shell
- off-axis test-function surface for weak pairings
- distributional pairing statement for the `Γ` transport equation

No estimates and no existence theory appear here.
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

open MeasureTheory

namespace NavierStokes.AxisymNoSwirl.Gamma

open NavierStokes.Geometry.Cylindrical
open NavierStokes.Analysis.WeightedSobolev
open NavierStokes.AxisymNoSwirl.BiotSavart

/-- Bundled axisymmetric no-swirl fields on the cylindrical carrier. -/
abbrev AxisymNoSwirlField := AxisymNoSwirlFieldCyl

instance : CoeFun AxisymNoSwirlField (fun _ => E3 → E3) := ⟨Subtype.val⟩

/-- The existing weighted-Sobolev test functions already have support contained in `Ω`,
so Scope A re-exports them under an off-axis name. -/
abbrev TestFnOffAxis := TestFn

/-- The scalar `Γ = ω_θ / r = thetaCurl / rCyl`. -/
def Γ (u : AxisymNoSwirlField) (p : E3) : ℝ :=
  thetaCurl u p / rCyl p

/-- Off-axis support for the re-exported test-function surface. -/
lemma tsupport_subset_Ω (φ : TestFnOffAxis) :
    tsupport (φ : E3 → ℝ) ⊆ Ω :=
  φ.2.2.2

/-- The cylindrical transport part `(u_r ∂_r + u_z ∂_z) g`. -/
def gammaAdvection (u : AxisymNoSwirlField) (g : E3 → ℝ) (p : E3) : ℝ :=
  (u p).1 * radialDeriv g p + (u p).2.2 * verticalDeriv g p

/-- The pointwise spatial right-hand side of the `Γ` transport equation. -/
def ΓSpatialRHS (u : AxisymNoSwirlField) (g forcing : E3 → ℝ) (p : E3) : ℝ :=
  tildeDeltaGamma g p - gammaAdvection u g p + forcing p

/-- Explicit shell for the pointwise `Γ` transport identity on `Ω`. -/
def HasΓSpatialIdentity
    (u : AxisymNoSwirlField) (dtGamma forcing : E3 → ℝ) : Prop :=
  ∀ p : E3, p ∈ Ω → dtGamma p = ΓSpatialRHS u (Γ u) forcing p

/-- Scope-A pointwise identity shell:
if a field carries an explicit time-derivative witness and forcing term satisfying the
`Γ` transport identity off-axis, then the right-hand side is exactly
`tildeDeltaGamma Γ - (u · ∇)Γ + forcing`. -/
theorem Γ_spatial_rhs_eq
    (u : AxisymNoSwirlField) (dtGamma forcing : E3 → ℝ)
    (hEq : HasΓSpatialIdentity u dtGamma forcing)
    (p : E3) (hp : p ∈ Ω) :
    dtGamma p = tildeDeltaGamma (Γ u) p - gammaAdvection u (Γ u) p + forcing p := by
  simpa [HasΓSpatialIdentity, ΓSpatialRHS] using hEq p hp

/-- Distributional pairing against off-axis test functions, with the weighted cylindrical
measure used in the B3 Sobolev surface. This is a pairing, not an `H¹` inner product. -/
noncomputable def pairing (f : E3 → ℝ) (φ : TestFnOffAxis) : ℝ :=
  ∫ p, f p * φ p ∂ weightedMeasure

/-- Weak-form shell for the time-dependent `Γ` transport equation.

The divergence-free assumption is carried explicitly as an argument, rather than inferred
from reconstruction lemmas. The statement is packaged as a distributional pairing against
`TestFnOffAxis`; it deliberately does not use `weightedH1`'s inherited `L²` inner product. -/
def SolvesΓTransport
    (U : ℝ → AxisymNoSwirlField)
    (hDivFree : ∀ t, divergenceCyl (U t) = 0) : Prop :=
  ∃ (dtGamma forcing : ℝ → E3 → ℝ),
    ∀ (φ : TestFnOffAxis) (t : ℝ),
      pairing (dtGamma t) φ =
        pairing (fun p => ΓSpatialRHS (U t) (Γ (U t)) (forcing t) p) φ

end NavierStokes.AxisymNoSwirl.Gamma

end
