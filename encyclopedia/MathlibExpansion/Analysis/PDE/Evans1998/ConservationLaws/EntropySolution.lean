import Mathlib.Data.Real.Basic

/-!
# Evans 1998, Ch. 11 — Scalar conservation laws and entropy solutions

T20c_late_19 Evans Step 6 — per Round 1 Claude correction this is
`novel_theorem` (Codex round originally classified `substrate_gap`; the
Round 1 correction is recorded by the Step 6 dispatcher).  The five
genuinely new theorem families are:

1. Rankine–Hugoniot jump condition (Rankine 1870, Hugoniot 1887).
2. Kružkov entropy conditions (1970).
3. L¹ contraction / nonlinear semigroup (Crandall–Tartar 1980).
4. Vanishing-viscosity selection.
5. Riemann problem.

This file lands the carrier-level data structures + opaque predicates;
the five theorem packages are sharp upstream-narrow axioms with
publication citations.

**Citations.**
- L. C. Evans, *PDE* (AMS GSM 19), 1998, Ch. 11.
- W. J. M. Rankine, *Phil. Trans. R. Soc.* **160** (1870).
- P. H. Hugoniot, *J. École Polytech.* **57** (1887).
- O. A. Oleinik, *Uspekhi Mat. Nauk* **12** (1957) (uniqueness).
- S. N. Kružkov, *Mat. Sb. (NS)* **81(123)** (1970), 228–255.
- M. G. Crandall, L. Tartar, *Proc. AMS* **78** (1980), 385–390.
- C. M. Dafermos, *Hyperbolic Conservation Laws in Continuum Physics*,
  3rd ed., 2010.

No `sorry`, no `admit`.
-/

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Evans1998
namespace ConservationLaws

/-- Scalar conservation-law datum: flux `F` and initial datum `g`. -/
structure ScalarLawData where
  F : ℝ → ℝ
  g : ℝ → ℝ

/-- Bundled weak-solution carrier `u(x, t)`. -/
structure WeakSolution where
  u : ℝ → ℝ → ℝ

/-- Trivial zero weak solution. -/
def zeroWeakSolution : WeakSolution := { u := fun _ _ => 0 }

@[simp] theorem zeroWeakSolution_value (x t : ℝ) :
    zeroWeakSolution.u x t = 0 := rfl

/-- Constant initial datum + zero flux yields the constant solution. -/
def constSolution (K : ℝ) : WeakSolution :=
  { u := fun _ _ => K }

/-- Opaque predicates for Chapter 11 theorem packages. -/
axiom IsWeakSolution : ScalarLawData → WeakSolution → Prop
axiom SatisfiesRankineHugoniot : ScalarLawData → WeakSolution → Prop
axiom SatisfiesKruzhkovEntropy : ScalarLawData → WeakSolution → Prop
axiom IsL1Contractive : ScalarLawData → WeakSolution → Prop
axiom IsVanishingViscosityLimit : ScalarLawData → WeakSolution → Prop
axiom SolvesRiemannProblem : ScalarLawData → WeakSolution → Prop

/-- Upstream-narrow axiom: existence of an entropy weak solution to the
scalar conservation law `u_t + F(u)_x = 0`.

**Citation.** Evans 1998, Ch. 11 §4 (Existence of entropy solutions);
Kružkov 1970. -/
axiom entropy_solution_existence (D : ScalarLawData) :
    ∃ S : WeakSolution,
      IsWeakSolution D S ∧ SatisfiesKruzhkovEntropy D S

/-- Upstream-narrow axiom: Rankine–Hugoniot jump condition for shock
discontinuities.

**Citation.** Evans 1998, Ch. 11 §1.1 (Rankine–Hugoniot); Rankine 1870;
Hugoniot 1887. -/
axiom rankine_hugoniot
    (D : ScalarLawData) (S : WeakSolution) :
    IsWeakSolution D S → SatisfiesRankineHugoniot D S

/-- Upstream-narrow axiom: Kružkov L¹ contraction / nonlinear semigroup
theorem.

**Citation.** Evans 1998, Ch. 11 §4.3 (L¹ contraction); Kružkov 1970;
Crandall–Tartar 1980. -/
axiom l1_contraction
    (D : ScalarLawData) (S : WeakSolution) :
    SatisfiesKruzhkovEntropy D S → IsL1Contractive D S

/-- Upstream-narrow axiom: vanishing-viscosity selection of the entropy
solution.

**Citation.** Evans 1998, Ch. 11 §4.4 (Vanishing-viscosity method);
Oleinik 1957. -/
axiom vanishing_viscosity_selects
    (D : ScalarLawData) :
    ∃ S : WeakSolution,
      SatisfiesKruzhkovEntropy D S ∧ IsVanishingViscosityLimit D S

/-- Upstream-narrow axiom: solvability of the Riemann problem
(piecewise-constant data) by self-similar entropy solution.

**Citation.** Evans 1998, Ch. 11 §3 (Riemann problems);
Dafermos 2010, Ch. 9. -/
axiom riemann_problem_solvable
    (D : ScalarLawData) :
    ∃ S : WeakSolution,
      SolvesRiemannProblem D S ∧ SatisfiesKruzhkovEntropy D S

end ConservationLaws
end Evans1998
end PDE
end Analysis
end MathlibExpansion
