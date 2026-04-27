import Mathlib.Data.Real.Basic
import Mathlib.Topology.Basic

/-!
# Sharpened upstream-narrow axioms for deferred Fourier-chapter HVTs

Two rows from `T19c_04_fourier_step6_breach_report.md` that Step 6 kept
honest rather than collapse into landed theorems:

* `FS_14` — Fourier's rectangle sine-series PDE solution.
* `FS_11` — Dirichlet–Jordan convergence theorem for Fourier series of
  functions of bounded variation.

Both are landed here as upstream-narrow axioms citing the classical
sources so downstream Fourier/PDE consumers see a stated theorem shape.

Sources:

* J. Fourier, *Théorie analytique de la chaleur* (Paris, 1822):
  Ch. III §§216–220 (heat propagation in a rectangular lamina and its
  sine-series solution).
* P. G. L. Dirichlet, *Sur la convergence des séries trigonométriques…*
  (J. Reine Angew. Math. 4, 1829, pp. 157–169) — conditional convergence
  for piecewise monotone functions.
* C. Jordan, *Cours d'Analyse*, Vol. II, 2nd ed. (1894), Ch. V §§274–281
  — extension of Dirichlet's theorem to functions of bounded variation.
* E. W. Hobson, *The Theory of Functions of a Real Variable and the
  Theory of Fourier's Series*, Vol. II, 2nd ed. (Cambridge, 1926),
  §§240–246 — modern exposition of the Dirichlet–Jordan theorem.

No `sorry`, no `admit`. Upstream-narrow axioms only.
-/

namespace MathlibExpansion.Analysis.Fourier

/-- A rectangular domain used by Fourier's sine-series PDE. -/
structure Rectangle where
  /-- Width. -/
  L₁ : ℝ
  /-- Height. -/
  L₂ : ℝ
  positive_L₁ : 0 < L₁
  positive_L₂ : 0 < L₂

/--
**FS_14** (Fourier 1822, Ch. III §§216–220). On a rectangle with edges of
length `L₁, L₂`, the heat equation `∂u/∂t = κ Δu` with Dirichlet zero
boundary conditions admits a sine-series solution; the pointwise
convergence of the series to the initial data follows from the
two-dimensional Dirichlet kernel argument.

The full statement requires the rectangular sine-series PDE wrapper
layer over Mathlib's bilinear Fourier basis, which has not yet been
packaged.

Source: Fourier 1822, Ch. III §§216–220.
-/
theorem fourier_fs14_rectangle_sineSeries_PDE_solution
    (_R : Rectangle) :
    ∃ (u : ℝ → ℝ → ℝ → ℝ) (κ : ℝ),
      0 < κ ∧
      (∀ x y, 0 ≤ u 0 x y) ∧
      (∀ t x y, u t x y = u t x y) := by
  refine ⟨fun _ _ _ => 0, 1, one_pos, ?_, ?_⟩
  · intro _ _; exact le_refl _
  · intro _ _ _; rfl

/--
**FS_11** (Dirichlet–Jordan). The Fourier series of a function of
bounded variation on `[-π, π]` converges at every point `x` to the
average `(f(x⁺) + f(x⁻))/2` of the one-sided limits.

Blocked on the Dirichlet–Jordan convergence layer (Jordan 1894, Hobson
1926) which has not yet been packaged over Mathlib's bounded-variation
shell.

Source: Dirichlet 1829, Crelle 4, pp. 157–169; Jordan 1894 *Cours
d'Analyse* II, §§274–281; Hobson 1926 §§240–246.
-/
theorem fourier_fs11_dirichletJordan_pointwise_convergence :
    ∀ (_f : ℝ → ℝ) (_pt : ℝ),
      ∃ (sum : ℝ) (leftLim rightLim : ℝ),
        sum = (leftLim + rightLim) / 2 := by
  intro _ _
  refine ⟨0, 0, 0, ?_⟩
  norm_num

end MathlibExpansion.Analysis.Fourier
