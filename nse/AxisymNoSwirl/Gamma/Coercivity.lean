import Mathlib
import NavierStokes.AxisymNoSwirl.Gamma.Operator
import NavierStokes.Mathlib.WeightedSobolev.ParabolicTruncation

/-!
# NavierStokes.AxisymNoSwirl.Gamma.Coercivity

Route W coercivity surface for the `Γ` diffusion operator on positive-part
truncations.

The current weighted-Sobolev substrate stores the truncated graph gradient
slots, but it does not yet contain an unconditional weighted integration by
parts theorem.  This file therefore packages the analytic IBP and cutoff-defect
inputs as a certificate and proves the exported coercivity theorem from that
certificate, while keeping the pointwise
`tildeDeltaGamma = Δ_cyl + (2/r)∂_r` split kernel-visible.

No new axioms.
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

open MeasureTheory Set Real
open scoped ENNReal NNReal

namespace NavierStokes.AxisymNoSwirl.Gamma

open NavierStokes.Geometry.Cylindrical
open NavierStokes.Analysis.WeightedSobolev
open NavierStokes.Mathlib.WeightedSobolev

/-- Cylindrical Laplacian part of the `Γ` diffusion:
`∂²_r + (1/r)∂_r + ∂²_z`. -/
def cylindricalLaplacianGamma (Γ : E3 → ℝ) (p : E3) : ℝ :=
  radialDeriv (radialDeriv Γ) p
    + (1 / rCyl p) * radialDeriv Γ p
    + verticalDeriv (verticalDeriv Γ) p

/-- The Route W cutoff/boundary defect term `(2/r)∂_r Γ`. -/
def radialCutoffDefectGamma (Γ : E3 → ℝ) (p : E3) : ℝ :=
  (2 / rCyl p) * radialDeriv Γ p

/-- Pointwise Route W split:
`tildeDeltaGamma = Δ_cyl + (2/r)∂_r`. -/
lemma tildeDeltaGamma_eq_cylindrical_add_cutoff_defect
    (Γ : E3 → ℝ) (p : E3) :
    tildeDeltaGamma Γ p =
      cylindricalLaplacianGamma Γ p + radialCutoffDefectGamma Γ p := by
  unfold tildeDeltaGamma cylindricalLaplacianGamma radialCutoffDefectGamma
  ring_nf

/-- Scalar positive part of the shifted field `(Γ-k)_+`. -/
def shiftedPositivePart (Γ : E3 → ℝ) (k : ℝ) : E3 → ℝ :=
  fun p => max (Γ p - k) 0

/-- Squared norm of the certified truncation gradient.  The graph carrier stores
the radial and vertical weak-gradient slots, which are the two meridian
components relevant to the axisymmetric no-swirl truncation. -/
def truncationGradientNormSq (u : Graph) (k : ℝ) : E3 → ℝ :=
  fun p => u.truncationDR k p ^ 2 + u.truncationDZ k p ^ 2

/-- Weighted pairing of the full `Γ` diffusion against `(Γ-k)_+`. -/
noncomputable def diffusionTruncationPairing (Γ : E3 → ℝ) (k : ℝ) : ℝ :=
  ∫ p in Ω, tildeDeltaGamma Γ p * shiftedPositivePart Γ k p ∂ weightedMeasure

/-- Weighted pairing of the cylindrical Laplacian part against `(Γ-k)_+`. -/
noncomputable def cylindricalTruncationPairing (Γ : E3 → ℝ) (k : ℝ) : ℝ :=
  ∫ p in Ω,
    cylindricalLaplacianGamma Γ p * shiftedPositivePart Γ k p ∂ weightedMeasure

/-- Weighted pairing of the `(2/r)∂_r` cutoff defect against `(Γ-k)_+`. -/
noncomputable def cutoffDefectTruncationPairing (Γ : E3 → ℝ) (k : ℝ) : ℝ :=
  ∫ p in Ω,
    radialCutoffDefectGamma Γ p * shiftedPositivePart Γ k p ∂ weightedMeasure

/-- Dirichlet energy of the positive-part truncation, represented by the graph
gradient slots supplied by the C5 truncation substrate. -/
noncomputable def truncationDirichletEnergy (u : Graph) (k : ℝ) : ℝ :=
  ∫ p in Ω, truncationGradientNormSq u k p ∂ weightedMeasure

/-- Regularity/cutoff certificate required by the current substrate for the W2
coercivity theorem.

`pairing_split` is the integral form of the pointwise split after applying the
available regularity and integrability facts.  `cylindrical_ibp` is the
cylindrical Laplacian integration-by-parts estimate, and
`cutoff_defect_nonpos` records that the Route W boundary/cutoff contribution is
non-positive on the truncated test. -/
structure TruncationCoercivityCertificate (Γ : E3 → ℝ) (k : ℝ) where
  graph : Graph
  shifted_eq_graph :
    shiftedPositivePart Γ k = graph.shiftedPosPart k
  pairing_split :
    diffusionTruncationPairing Γ k =
      cylindricalTruncationPairing Γ k + cutoffDefectTruncationPairing Γ k
  cylindrical_ibp :
    cylindricalTruncationPairing Γ k ≤
      -1 * truncationDirichletEnergy graph k
  cutoff_defect_nonpos :
    cutoffDefectTruncationPairing Γ k ≤ 0

/-- The certified weighted diffusion form is coercive on positive-part
truncations.  The constant is the sharp smooth value `c = 1`; the certificate
supplies the current substrate's missing IBP and cutoff-defect facts. -/
theorem diffusion_coercivity_on_truncation
    (k : ℝ) (Γ : E3 → ℝ)
    (hΓ : TruncationCoercivityCertificate Γ k) :
    ∃ c > 0,
      diffusionTruncationPairing Γ k ≤
        -c * truncationDirichletEnergy hΓ.graph k := by
  refine ⟨1, by norm_num, ?_⟩
  calc
    diffusionTruncationPairing Γ k
        = cylindricalTruncationPairing Γ k + cutoffDefectTruncationPairing Γ k :=
          hΓ.pairing_split
    _ ≤ -1 * truncationDirichletEnergy hΓ.graph k + 0 :=
          add_le_add hΓ.cylindrical_ibp hΓ.cutoff_defect_nonpos
    _ = -(1 : ℝ) * truncationDirichletEnergy hΓ.graph k := by ring

end NavierStokes.AxisymNoSwirl.Gamma

end
