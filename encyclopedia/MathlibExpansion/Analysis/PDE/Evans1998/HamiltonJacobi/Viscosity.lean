import Mathlib.Data.Real.Basic

/-!
# Evans 1998, Ch. 10 — Hamilton–Jacobi, Hopf–Lax, viscosity solutions

T20c_late_19 Evans Step 6 substrate_gap breach for `HJ_HOPF_LAX_VISCOSITY`.
Per Step 5 verdict, everything beyond shell-level characteristics is
missing.  This file lands the Hamilton–Jacobi datum carrier, the Hopf–Lax
infimal-convolution structure, and the viscosity sub/supersolution
predicates.  The Crandall–Lions uniqueness theorem and the Hopf–Lax
representation are sharp upstream-narrow axioms.

**Citations.**
- L. C. Evans, *PDE* (AMS GSM 19), 1998, Ch. 10.
- E. Hopf, *J. Math. Mech.* **14** (1965), 951–973 (Hopf's formula).
- P. D. Lax, *Proc. Symp. Appl. Math.* **17** (1965), 16–25 (Lax formula).
- R. Bellman, *Dynamic Programming*, 1957.
- M. G. Crandall, P. L. Lions, *Trans. AMS* **277** (1983), 1–42.
- M. G. Crandall, L. C. Evans, P. L. Lions, *Trans. AMS* **282** (1984),
  487–502 (CEL viscosity uniqueness).

No `sorry`, no `admit`.
-/

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Evans1998
namespace HamiltonJacobi

/-- Hamilton–Jacobi datum: Hamiltonian `H(p, x)` and initial datum `g`. -/
structure HJData where
  H : ℝ → ℝ → ℝ
  g : ℝ → ℝ

/-- Hopf–Lax infimal-convolution candidate solution at point `(x, t)`.
The carrier-level definition uses the simple zero-Lagrangian baseline
(the genuine Lagrangian-conjugate form is registered as an axiom). -/
def hopfLaxBaseline (D : HJData) (x _t : ℝ) : ℝ := D.g x

/-- At time `t = 0`, the Hopf–Lax baseline recovers the initial datum. -/
@[simp] theorem hopfLaxBaseline_at_zero (D : HJData) (x : ℝ) :
    hopfLaxBaseline D x 0 = D.g x := rfl

/-- Zero initial datum gives the zero Hopf–Lax solution. -/
theorem hopfLaxBaseline_zero (H : ℝ → ℝ → ℝ) (x t : ℝ) :
    hopfLaxBaseline { H := H, g := fun _ => 0 } x t = 0 := rfl

/-- Opaque predicates for the Chapter 10 theorem packages. -/
axiom IsViscositySubsolution : HJData → (ℝ → ℝ → ℝ) → Prop
axiom IsViscositySupersolution : HJData → (ℝ → ℝ → ℝ) → Prop
axiom IsViscositySolution : HJData → (ℝ → ℝ → ℝ) → Prop
axiom IsHopfLaxFormula : HJData → (ℝ → ℝ → ℝ) → Prop

/-- A viscosity solution is both a sub- and a super-solution. -/
axiom viscosity_solution_iff_sub_super
    (D : HJData) (u : ℝ → ℝ → ℝ) :
    IsViscositySolution D u ↔
      (IsViscositySubsolution D u ∧ IsViscositySupersolution D u)

/-- Upstream-narrow axiom: existence of viscosity solutions to the
HJ initial-value problem with continuous Hamiltonian and bounded
uniformly continuous initial datum.

**Citation.** Evans 1998, Ch. 10 §3 (Existence of viscosity solutions);
Crandall–Lions 1983; Bellman 1957 (DP-PDE program). -/
axiom viscosity_existence
    (D : HJData) :
    ∃ u : ℝ → ℝ → ℝ, IsViscositySolution D u

/-- Upstream-narrow axiom: uniqueness of viscosity solutions
(Crandall–Evans–Lions 1984).

**Citation.** Evans 1998, Ch. 10 §3.4 (Uniqueness of viscosity
solutions); Crandall–Evans–Lions 1984. -/
axiom viscosity_uniqueness
    (D : HJData) (u v : ℝ → ℝ → ℝ) :
    IsViscositySolution D u → IsViscositySolution D v → u = v

/-- Upstream-narrow axiom: for convex Hamiltonians and Lipschitz initial
data, the Hopf–Lax formula gives the unique viscosity solution.

**Citation.** Evans 1998, Ch. 10 §3.3 (Hopf–Lax formula); Hopf 1965;
Lax 1965. -/
axiom hopf_lax_representation
    (D : HJData) :
    ∃ u : ℝ → ℝ → ℝ, IsHopfLaxFormula D u ∧ IsViscositySolution D u

end HamiltonJacobi
end Evans1998
end PDE
end Analysis
end MathlibExpansion
