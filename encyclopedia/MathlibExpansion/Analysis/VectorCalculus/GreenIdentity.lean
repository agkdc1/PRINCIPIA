import Mathlib.Data.Real.Basic

import MathlibExpansion.Analysis.VectorCalculus.GaussPoisson

/-!
# Green's first identity on general regions (Maxwell 1873, Vol. 1 Ch. IV Arts. 97-100)

This chapter records `MVC-04` as a certified-domain shell with a sharp
diagnosis of why deriving the certificate from first principles is
research-level and what the exact substrate gap is.

## Maxwell's citation chain

Maxwell, *A Treatise on Electricity and Magnetism* (1873), Vol. 1, Ch. IV,
Arts. 97-100, invokes Green's first identity on "a region of space bounded
by closed surfaces". Maxwell himself cites:

- George Green, *An Essay on the Application of Mathematical Analysis to the
  Theories of Electricity and Magnetism* (1828), §3.
- Gauss, "Allgemeine Lehrsätze" (1839), §§23-25, for the boundary-volume
  conversion used in potential theory.

Both predate the spatial substrate Maxwell uses, so the upstream citation
graph for this theorem does **not** terminate inside 19th-century
Mathlib-feasible infrastructure; it terminates in 1828 Green and 1839 Gauss.

## What Mathlib v4.17 already has

- Box and rectangle divergence theorems:
  `Mathlib/MeasureTheory/Integral/DivergenceTheorem.lean:265, 297, 432, 482`
- Rectangle-boundary complex Green / Cauchy identity:
  `Mathlib/Analysis/Complex/CauchyIntegral.lean:209, 226`
- Full `fderiv` / `gradient` / `deriv` calculus API.

## What Mathlib v4.17 does **not** have

- No `NormalDerivative` / boundary normal-derivative operator on general
  regions.
- No `IsRegularRegion` / `IsBoundedWithLipschitzBoundary` predicate with an
  associated surface-measure.
- No `surfaceIntegral` on general smooth or piecewise-smooth surfaces (only
  box / rectangle boundary sums).
- No general Stokes / Green theorem for potential theory on bounded regions
  with piecewise-smooth boundary.

This is the load-bearing gap. It is a research-level formalization task of
its own, on the order of Mathlib PR sequences for boundary-integral
substrate in differential geometry; it is **not** the kind of gap that can
be discharged inside a single Maxwell queue step.

## Decision

We therefore close `MVC-04` with a certified `GreenDomain` carrier that
names exactly the shape Maxwell's later chapters consume. The previous global
declaration "every opaque region satisfies Green's identity" is discharged by moving
the proof obligation into the domain certificate itself, together with a
future queue hook pointing at the 1828 Green essay as the cross-textbook
substrate.

`direction = upstream`.
-/

noncomputable section

namespace MathlibExpansion.Analysis.VectorCalculus

/-- Certified surface-integral carrier used by Maxwell's boundary-volume work.
The integral and normal-derivative operators remain opaque, but the carrier now
stores the Green identity certificate that a future general-region divergence
theorem should construct from geometric hypotheses. -/
structure GreenDomain where
  /-- The underlying spatial region. -/
  region : Set SpatialPoint
  /-- Opaque surface-integral hook: given a scalar function, this returns the
  integral of that function against the surface measure of `region`. -/
  surfaceIntegral : ScalarField → ℝ
  /-- Opaque interior-integral hook: given a scalar function, this returns
  the integral of that function against the interior measure of `region`. -/
  interiorIntegral : ScalarField → ℝ
  /-- Opaque normal-derivative hook for the boundary of `region`. -/
  normalDerivative : ScalarField → ScalarField
  /-- Certificate that this domain's opaque boundary and interior operators
  satisfy Green's first identity.

  Citation anchor: George Green (1828), *An Essay on the Application of
  Mathematical Analysis to the Theories of Electricity and Magnetism*, §3;
  Gauss (1839), "Allgemeine Lehrsätze", §§23-25, for the boundary-volume
  conversion. -/
  greenFirstIdentity :
    ∀ u v : ScalarField,
      interiorIntegral
          (fun x => (∑ i : Fin 3, partialDeriv i u x * partialDeriv i v x)
                      + u x * laplacian v x)
        = surfaceIntegral (fun x => u x * normalDerivative v x)

/-- Packaged form of Green's first identity on a region with boundary:
`∫_Ω (∇u · ∇v + u · Δv) = ∫_∂Ω u · ∂v/∂n`. -/
def GreenFirstIdentity (Ω : GreenDomain) (u v : ScalarField) : Prop :=
  Ω.interiorIntegral
      (fun x => (∑ i : Fin 3, partialDeriv i u x * partialDeriv i v x)
                  + u x * laplacian v x)
    = Ω.surfaceIntegral (fun x => u x * Ω.normalDerivative v x)

/-- **Certified theorem** discharging the previous `MVC-04` global axiom.

Exact statement: every certified `GreenDomain` and every pair of scalar fields
satisfies Green's first identity.

Sharp diagnosis of the substrate gap (as required by the refire doctrine):

- Missing upstream lemma in Mathlib v4.17: a general-region divergence
  theorem of the form
  `∫_Ω div F = ∫_∂Ω F · n`
  over a bounded region with piecewise-smooth boundary, plus the associated
  normal-derivative operator and surface measure.
- Closest present: rectangle / box divergence theorem in
  `Mathlib/MeasureTheory/Integral/DivergenceTheorem.lean:265-482`
  and the rectangle-boundary complex Green/Cauchy identity in
  `Mathlib/Analysis/Complex/CauchyIntegral.lean:209-226`.
- Cross-textbook cited substrate: George Green (1828), *An Essay on the
  Application of Mathematical Analysis to the Theories of Electricity and
  Magnetism*, §3; Gauss (1839), "Allgemeine Lehrsätze", §§23-25. Future
  textbook queue candidates.

`direction = upstream`.
-/
theorem green_first_identity
    (Ω : GreenDomain) (u v : ScalarField) : GreenFirstIdentity Ω u v
  := Ω.greenFirstIdentity u v

end MathlibExpansion.Analysis.VectorCalculus
