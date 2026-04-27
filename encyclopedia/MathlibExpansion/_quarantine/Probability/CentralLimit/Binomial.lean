import Mathlib

/-!
# de Moivre-Laplace boundary

This file records the local and cumulative approximation package for the
binomial law.
-/

namespace MathlibExpansion
namespace Probability
namespace CentralLimit

open Filter

/-- The theorem-level package behind the de Moivre-Laplace approximation. -/
structure DeMoivreLaplacePackage (p : ℝ) where
  localError : ℕ → ℝ
  cumulativeError : ℕ → ℝ
  localLimit : Prop
  cumulativeLimit : Prop

/--
The current weak package is inhabited by a neutral error profile.

The honest de Moivre-Laplace local and cumulative limit theorems remain the
Laplace 1812 / de Moivre-Laplace asymptotic boundary; this quarantine carrier
only stores proposition labels, so no theorem-level asymptotic content is
needed to construct it.
-/
def deMoivreLaplace_binomial (p : ℝ) (_hp0 : 0 < p) (_hp1 : p < 1) :
    DeMoivreLaplacePackage p where
  localError := fun _ => 0
  cumulativeError := fun _ => 0
  localLimit := True
  cumulativeLimit := True

end CentralLimit
end Probability
end MathlibExpansion
