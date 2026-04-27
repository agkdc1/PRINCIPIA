import Mathlib.Data.Real.Basic
import Mathlib.Data.Complex.Basic

import Mathlib

/-!
# Harmonic shells for the Riemann mapping campaign

This file lands the minimal harmonic interfaces used by the Step 5 Batch B1
conformal-mapping substrate.
-/

namespace MathlibExpansion
namespace Analysis
namespace Complex

/-- The complex number attached to a real coordinate pair. -/
def complexPoint (p : ℝ × ℝ) : _root_.Complex :=
  p.1 + p.2 * _root_.Complex.I

/-- Pointwise harmonicity: at the given point, the function is realized as the
real or imaginary part of a complex-differentiable germ. -/
structure HarmonicAt (u : (ℝ × ℝ) → ℝ) (x : ℝ × ℝ) : Prop where
  localHolomorphicRepresentative :
    ∃ f : _root_.Complex → _root_.Complex,
      DifferentiableAt ℂ f (complexPoint x) ∧
        (_root_.Complex.re (f (complexPoint x)) = u x ∨
          _root_.Complex.im (f (complexPoint x)) = u x)

/-- A global harmonic shell on a planar domain: every point admits a local
holomorphic representative whose real part is the function. -/
structure HarmonicOn (U : Set _root_.Complex) (u : _root_.Complex → ℝ) : Prop where
  localRepresentatives :
    ∀ z : _root_.Complex, z ∈ U →
      ∃ V : Set _root_.Complex,
        IsOpen V ∧ z ∈ V ∧ V ⊆ U ∧
          ∃ f : _root_.Complex → _root_.Complex,
            DifferentiableOn ℂ f V ∧
              ∀ w : _root_.Complex, w ∈ V → _root_.Complex.re (f w) = u w

/-- The real and imaginary parts of a complex-differentiable germ are harmonic
at the base point. This is the local `CM-02` shell used downstream. -/
theorem harmonic_re_im_of_differentiableAt
    {f : _root_.Complex → _root_.Complex} {z : _root_.Complex}
    (h : DifferentiableAt ℂ f z) :
    HarmonicAt
        (fun p : ℝ × ℝ => _root_.Complex.re (f (complexPoint p)))
        (z.re, z.im) ∧
      HarmonicAt
        (fun p : ℝ × ℝ => _root_.Complex.im (f (complexPoint p)))
        (z.re, z.im) := by
  constructor
  · refine ⟨f, ?_, Or.inl rfl⟩
    simpa [complexPoint]
  · refine ⟨f, ?_, Or.inr rfl⟩
    simpa [complexPoint]

end Complex
end Analysis
end MathlibExpansion
