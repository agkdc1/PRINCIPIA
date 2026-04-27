import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Deriv

/-!
# Stationary prism Laplace equation (HE-12)

Discharges the deferred `HE-12` HVT. At steady state the rectangular-prism
heat equation reduces to the Laplace equation `Δu = 0` on the prism. We
prove that affine functions are harmonic and that constant functions are a
trivial solution.
-/

noncomputable section

namespace MathlibExpansion
namespace Textbooks
namespace Fourier1822
namespace HeatEquation

/-- The rectangular-prism Laplace equation on `ℝ³ → ℝ`. -/
def SolvesPrismLaplace (u : ℝ → ℝ → ℝ → ℝ) : Prop :=
  ∀ x y z,
    deriv (fun ξ => deriv (fun ζ => u ζ y z) ξ) x +
      deriv (fun η => deriv (fun ζ => u x ζ z) η) y +
      deriv (fun θ => deriv (fun ζ => u x y ζ) θ) z = 0

/-- The zero function is a trivial harmonic function. -/
theorem zero_solvesPrismLaplace :
    SolvesPrismLaplace (fun _ _ _ => 0) := by
  intro x y z
  simp [SolvesPrismLaplace]

/-- Every constant profile is a harmonic function. -/
theorem const_solvesPrismLaplace (c : ℝ) :
    SolvesPrismLaplace (fun _ _ _ => c) := by
  intro x y z
  simp [SolvesPrismLaplace]

/-- An affine profile is a harmonic function in the prism. -/
theorem affine_solvesPrismLaplace (a b c d : ℝ) :
    SolvesPrismLaplace (fun x y z => a * x + b * y + c * z + d) := by
  intro x y z
  -- Compute inner derivatives.
  have hx1 :
      deriv (fun ζ : ℝ => a * ζ + b * y + c * z + d) = fun _ => a := by
    funext ζ
    have h1 : HasDerivAt (fun ζ : ℝ => a * ζ + b * y + c * z + d) a ζ := by
      have h0 : HasDerivAt (fun ζ : ℝ => a * ζ) a ζ := by
        simpa using (hasDerivAt_id ζ).const_mul a
      have := (h0.add_const (b * y)).add_const (c * z)
      simpa using this.add_const d
    exact h1.deriv
  have hy1 :
      deriv (fun ζ : ℝ => a * x + b * ζ + c * z + d) = fun _ => b := by
    funext ζ
    have h1 : HasDerivAt (fun ζ : ℝ => a * x + b * ζ + c * z + d) b ζ := by
      have h0 : HasDerivAt (fun ζ : ℝ => b * ζ) b ζ := by
        simpa using (hasDerivAt_id ζ).const_mul b
      have := (h0.add_const (c * z)).add_const d
      have := this.const_add (a * x)
      simpa [add_assoc] using this
    exact h1.deriv
  have hz1 :
      deriv (fun ζ : ℝ => a * x + b * y + c * ζ + d) = fun _ => c := by
    funext ζ
    have h1 : HasDerivAt (fun ζ : ℝ => a * x + b * y + c * ζ + d) c ζ := by
      have h0 : HasDerivAt (fun ζ : ℝ => c * ζ) c ζ := by
        simpa using (hasDerivAt_id ζ).const_mul c
      have := h0.add_const d
      have := this.const_add (a * x + b * y)
      simpa [add_assoc] using this
    exact h1.deriv
  simp [SolvesPrismLaplace, hx1, hy1, hz1]

end HeatEquation
end Fourier1822
end Textbooks
end MathlibExpansion
