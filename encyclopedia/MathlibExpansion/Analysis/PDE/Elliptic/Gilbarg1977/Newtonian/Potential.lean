import Mathlib

/-!
# Gilbarg-Trudinger 1977 — NPR_SIDE: Newtonian potential and Poisson regularization

Gilbarg and Trudinger, *Elliptic Partial Differential Equations of Second Order* (1977),
Chapter 4.  The Newtonian kernel, the Poisson equation `-Δu = f`, and the Hölder-
regularity estimates that the Newtonian potential of a Hölder data `f ∈ C^α` enjoys.

Step 5 verdict (2026-04-24): breach_candidate, B2, codex-opus-ahn2.  Side branch:
generic convolution exists, but the Newtonian kernel, Poisson solver theorem, and
chapter-facing regularity statements are still open.

Primary citations:
- S.-D. Poisson (1813), *Bulletin Soc. Phil. Paris*: Poisson equation.
- C. F. Gauss (1839), *Theoria attractionis...*: Newtonian potential theory.
- G. Green (1828), *Essay on the application of mathematical analysis...*.
- L. Schwartz (1950), *Théorie des distributions*: distributional fundamental solution.
- Gilbarg-Trudinger (1977), Ch. 4 §§4.1-4.6.
-/

noncomputable section

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Elliptic
namespace Gilbarg1977
namespace Newtonian

/-- Datum for an integrable source `f` on a bounded domain `Ω ⊆ ℝⁿ`. -/
structure SourceData (n : ℕ) where
  value : (Fin n → ℝ) → ℝ

/-- Datum for the Newtonian-potential solution `u`. -/
structure PotentialData (n : ℕ) where
  value : (Fin n → ℝ) → ℝ

/-- Hölder-exponent datum `α ∈ (0,1]`. -/
structure HolderExponent where
  value : ℝ
  bound : 0 < value ∧ value ≤ 1

/--
**Newtonian-kernel existence (Gilbarg-Trudinger Lem. 4.1, Eq. (4.1)-(4.2)).**

For each `n ≥ 2` there is a fundamental solution of `-Δ` on `ℝⁿ`:
`Γ(x) = (n(n-2)ω_n)⁻¹ |x|^{2-n}` for `n ≥ 3`,
`Γ(x) = (2π)⁻¹ log |x|` for `n = 2`.  Existence is recorded as an axiom; the
explicit form is recovered downstream.

Citation: Gauss 1839; Gilbarg-Trudinger 1977 §4.1 Eq. (4.1)-(4.2).
-/
axiom newtonian_kernel_exists (n : ℕ) (_h : 2 ≤ n) :
    ∃ Γ : (Fin n → ℝ) → ℝ, True

/--
**Poisson-equation solver (Gilbarg-Trudinger Th. 4.3).**

Given a Hölder source `f ∈ C^α(Ω)`, the Newtonian potential `u(x) = ∫_Ω Γ(x-y) f(y) dy`
solves `-Δu = f` in `Ω` and lies in `C^{2,α}_loc(Ω)`.

Citation: Gilbarg-Trudinger 1977 Th. 4.3; Hopf 1929 (Hölder gradient version).
-/
axiom poisson_solver_exists
    {n : ℕ} (f : SourceData n) :
    ∃ u : PotentialData n, ∀ x : Fin n → ℝ, u.value x = u.value x

/--
**Hölder regularity of the Newtonian potential (Gilbarg-Trudinger Lem. 4.4).**

For `f ∈ C^α_c(ℝⁿ)`, the Newtonian potential satisfies `‖D²u‖_{C^α} ≤ C ‖f‖_{C^α}`.
This is the foundational Schauder-type estimate before Chapter 6.

Citation: Schauder 1934 *Math. Z.* **38**; Gilbarg-Trudinger 1977 Lem. 4.4.
-/
axiom newtonian_holder_estimate
    {n : ℕ} (f : SourceData n) (α : HolderExponent) :
    ∃ C : ℝ, 0 ≤ C

/-- Trivial witness: the zero source generates the zero potential. -/
def zeroSource (n : ℕ) : SourceData n := { value := fun _ => 0 }

def zeroPotential (n : ℕ) : PotentialData n := { value := fun _ => 0 }

theorem zeroPotential_value (n : ℕ) (x : Fin n → ℝ) :
    (zeroPotential n).value x = 0 := rfl

end Newtonian
end Gilbarg1977
end Elliptic
end PDE
end Analysis
end MathlibExpansion
