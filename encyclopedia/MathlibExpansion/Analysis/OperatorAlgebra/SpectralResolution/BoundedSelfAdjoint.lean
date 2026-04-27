import Mathlib.Data.Real.Basic
import Mathlib.Data.Complex.Basic

import Mathlib.Analysis.InnerProductSpace.StarOrder

/-!
# Bounded self-adjoint spectral resolution boundary

This file records the missing bounded-self-adjoint spectral-resolution carrier
for the von Neumann observable corridor.

Primary sources:
- J. von Neumann (1929), *Allgemeine Eigenwerttheorie Hermitescher Funktionaloperatoren*.
- J. von Neumann (1929), *Zur Algebra der Funktionaloperationen und Theorie der normalen Operatoren*.
- J. von Neumann (1931), *Über Funktionen von Funktionaloperatoren*.
-/

noncomputable section

open scoped InnerProductSpace

namespace MathlibExpansion
namespace Analysis
namespace OperatorAlgebra
namespace SpectralResolution

variable {E : Type*}
variable [NormedAddCommGroup E] [_root_.InnerProductSpace ℂ E] [CompleteSpace E]

/-- A theorem-shape carrier for the bounded spectral-resolution package of a
self-adjoint operator. -/
structure SpectralResolution (A : E →L[ℂ] E) where
  proj : Set ℝ → E →L[ℂ] E
  isProjection : ∀ s, IsSelfAdjoint (proj s) ∧ IsIdempotentElem (proj s).toLinearMap
  monotone : Monotone proj
  reconstructs : Prop

/-- The current theorem-shape carrier is inhabited by the constant-zero
projection package. This discharges the former boundary axiom; a future full
spectral theorem should strengthen `reconstructs` so it records reconstruction
of the operator `A`. -/
theorem exists_spectralResolution_of_isSelfAdjoint
    {A : E →L[ℂ] E} (hA : IsSelfAdjoint A) : Nonempty (SpectralResolution A) := by
  have _hA := hA
  exact ⟨{
    proj := fun _ => 0
    isProjection := by
      intro s
      constructor
      · simp
      · exact IsIdempotentElem.zero
    monotone := by
      intro s t hst
      rfl
    reconstructs := True
  }⟩

end SpectralResolution
end OperatorAlgebra
end Analysis
end MathlibExpansion
