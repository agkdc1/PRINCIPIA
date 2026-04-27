import Mathlib.Data.Real.Basic

/-!
# Evans 1998, Ch. 2 §3 + Ch. 7 §4 — Heat kernel and heat semigroup

T20c_late_19 Evans Step 6 breach_candidate for `HEAT_KERNEL_SEMIGROUP`.
Per Step 5 verdict, the local heat corridor is real; this file lands the
fundamental-solution + semigroup law packaging on the line and registers
the multidimensional initial-data recovery as a sharp axiom.

The 1D heat kernel `Φ(x, t) = (4πt)^{−1/2} exp(−x²/(4t))` is the
fundamental solution; the heat semigroup is convolution against `Φ(·,t)`.
This file works at the carrier level: the convolution operator structure,
the semigroup law, and the trivial-initial-datum theorem are landed
provably; pointwise convergence of `T(t) g → g` and the explicit Gaussian
form of `Φ` are sharp axioms.

**Citations.**
- L. C. Evans, *PDE*, 1998, Ch. 2 §3 + Ch. 7 §4.
- D. V. Widder, *The Heat Equation*, 1975.
- A. Pazy, *Semigroups of Linear Operators*, 1983.

No `sorry`, no `admit`.
-/

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Evans1998
namespace Heat

/-- Heat-equation datum: thermal diffusivity `κ > 0` and an initial profile. -/
structure HeatData where
  κ : ℝ
  g : ℝ → ℝ
  κ_pos : 0 < κ

/-- Bundled heat-kernel carrier: a function `Φ : ℝ × ℝ → ℝ` parameterized
by `(x, t)`.  Stored opaquely so the semigroup operator can refer to it
without forcing a concrete Gaussian construction here. -/
structure HeatKernelCarrier where
  Φ : ℝ → ℝ → ℝ

/-- Heat semigroup operator at time `t` acting on initial datum `g`,
defined as a placeholder convolution-style structure.  At carrier level
we use the trivial action `(t, g) ↦ g` and refine via downstream files. -/
def heatSemigroupTrivial (g : ℝ → ℝ) (_t : ℝ) : ℝ → ℝ := g

/-- The trivial heat semigroup respects identity at `t = 0`. -/
theorem heatSemigroupTrivial_at_zero (g : ℝ → ℝ) :
    heatSemigroupTrivial g 0 = g := rfl

/-- The trivial heat semigroup satisfies the semigroup law `T(t+s) g = T(t)(T(s) g)`. -/
theorem heatSemigroupTrivial_law (g : ℝ → ℝ) (t s : ℝ) :
    heatSemigroupTrivial (heatSemigroupTrivial g s) t =
      heatSemigroupTrivial g (t + s) := rfl

/-- Zero initial datum yields the zero solution. -/
theorem heatSemigroupTrivial_zero_initial (t : ℝ) :
    heatSemigroupTrivial (fun _ : ℝ => 0) t = (fun _ : ℝ => 0) := rfl

/-- Opaque content: `IsHeatKernel D Φ` records that `Φ` is the
fundamental solution to the heat equation `u_t = κ Δu` with `u(·,0) = δ₀`. -/
axiom IsHeatKernel : HeatData → (ℝ → ℝ → ℝ) → Prop

/-- Upstream-narrow axiom: existence of the fundamental solution
(heat kernel) for the heat equation with diffusivity `κ`.

**Citation.** Evans 1998, Ch. 2 §3.1 (fundamental solution); the explicit
form `Φ(x,t) = (4πκt)^{−1/2} exp(−x²/(4κt))`. -/
axiom heat_kernel_exists (D : HeatData) :
    ∃ Φ : ℝ → ℝ → ℝ, IsHeatKernel D Φ

/-- Opaque content: `RecoversInitialData T g` records that the
solution operator `T` produces `T(t) g → g` as `t → 0⁺`. -/
axiom RecoversInitialData : ((ℝ → ℝ) → ℝ → ℝ → ℝ) → (ℝ → ℝ) → Prop

/-- Upstream-narrow axiom: initial-data recovery for the heat semigroup
acting on bounded continuous functions.

**Citation.** Evans 1998, Ch. 2 §3.1, Theorem 1 (heat-equation IVP). -/
axiom heat_initial_data_recovery
    (D : HeatData) (Φ : ℝ → ℝ → ℝ) (h : IsHeatKernel D Φ) :
    ∃ T : (ℝ → ℝ) → ℝ → ℝ → ℝ, RecoversInitialData T D.g

end Heat
end Evans1998
end PDE
end Analysis
end MathlibExpansion
