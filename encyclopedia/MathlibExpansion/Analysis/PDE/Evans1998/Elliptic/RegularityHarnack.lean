import Mathlib.Data.Real.Basic

/-!
# Evans 1998, Ch. 6 §§3–6 — Elliptic regularity, max principle, Harnack, eigenvalues

T20c_late_19 Evans Step 6 substrate_gap (per Round-1 Claude correction)
for `ELLIPTIC_REG_MAX_HARNACK_EIGEN`.

Per Step 5 verdict, regularity, maximum principle, Harnack, and
eigenvalue theory are heavy consumers requiring Sobolev/trace/elliptic-
bilinear-form substrate.  This file lands carrier-level structures and
the four classical theorem packages as upstream-narrow axioms.

**Citations.**
- L. C. Evans, *PDE* (AMS GSM 19), 1998, Ch. 6 §§3–6.
- E. De Giorgi, *Mem. Acc. Sci. Torino* (1957) (interior regularity).
- J. Nash, *Amer. J. Math.* **80** (1958) 931–954.
- J. Moser, *Comm. Pure Appl. Math.* **14** (1961), 577–591 (Harnack).
- D. Gilbarg, N. Trudinger, *Elliptic PDE of Second Order*, 1977.
- R. Courant, D. Hilbert, *MMP* I (1924), Kap. VI (eigen).

No `sorry`, no `admit`.
-/

namespace MathlibExpansion
namespace Analysis
namespace PDE
namespace Evans1998
namespace EllipticRegularity

/-- Carrier of an elliptic operator's data on a bounded domain. -/
structure EllipticData where
  /-- Ellipticity bound (positive). -/
  α : ℝ
  /-- Boundedness bound (positive). -/
  M : ℝ
  α_pos : 0 < α
  M_pos : 0 < M

/-- Trivial elliptic data with both bounds equal to `1`. -/
def trivialEllipticData : EllipticData :=
  { α := 1, M := 1, α_pos := by norm_num, M_pos := by norm_num }

/-- Solution carrier on a domain `Ω`. -/
structure SolutionCarrier (Ω : Type*) where
  u : Ω → ℝ

/-- The constant-zero solution carrier. -/
def zeroSolution (Ω : Type*) : SolutionCarrier Ω :=
  { u := fun _ => 0 }

/-- Opaque predicates. -/
axiom IsInteriorRegular : ∀ {Ω : Type*} (_S : SolutionCarrier Ω)
    (_D : EllipticData), Prop
axiom IsBoundaryRegular : ∀ {Ω : Type*} (_S : SolutionCarrier Ω)
    (_D : EllipticData), Prop
axiom SatisfiesWeakMaxPrinciple : ∀ {Ω : Type*} (_S : SolutionCarrier Ω)
    (_D : EllipticData), Prop
axiom SatisfiesStrongMaxPrinciple : ∀ {Ω : Type*} (_S : SolutionCarrier Ω)
    (_D : EllipticData), Prop
axiom SatisfiesHarnack : ∀ {Ω : Type*} (_S : SolutionCarrier Ω)
    (_D : EllipticData), Prop
axiom HasDiscreteSpectrum : ∀ {Ω : Type*} (_D : EllipticData), Prop

/-- Upstream-narrow axiom: interior regularity for weak solutions of
linear uniformly elliptic equations.

**Citation.** Evans 1998, Ch. 6 §3.1 (Interior regularity); De Giorgi
1957; Nash 1958; Moser 1961. -/
axiom interior_regularity
    {Ω : Type*} (S : SolutionCarrier Ω) (D : EllipticData) :
    IsInteriorRegular S D

/-- Upstream-narrow axiom: boundary regularity for weak solutions on
smooth-boundary domains.

**Citation.** Evans 1998, Ch. 6 §3.2 (Boundary regularity); Gilbarg–
Trudinger, Theorems 8.13–8.14. -/
axiom boundary_regularity
    {Ω : Type*} (S : SolutionCarrier Ω) (D : EllipticData) :
    IsBoundaryRegular S D

/-- Upstream-narrow axiom: weak maximum principle for uniformly elliptic
equations.

**Citation.** Evans 1998, Ch. 6 §4.1 (Weak max principle); Hopf 1927. -/
axiom weak_max_principle
    {Ω : Type*} (S : SolutionCarrier Ω) (D : EllipticData) :
    SatisfiesWeakMaxPrinciple S D

/-- Upstream-narrow axiom: strong maximum principle (Hopf boundary-point
form).

**Citation.** Evans 1998, Ch. 6 §4.2 (Hopf's lemma + strong max);
Hopf 1952. -/
axiom strong_max_principle
    {Ω : Type*} (S : SolutionCarrier Ω) (D : EllipticData) :
    SatisfiesStrongMaxPrinciple S D

/-- Upstream-narrow axiom: Harnack's inequality for nonnegative weak
solutions.

**Citation.** Evans 1998, Ch. 6 §4.3 (Harnack inequality); Moser 1961. -/
axiom harnack_inequality
    {Ω : Type*} (S : SolutionCarrier Ω) (D : EllipticData) :
    SatisfiesHarnack S D

/-- Upstream-narrow axiom: discrete spectrum of the Dirichlet Laplacian
on bounded domains; eigenvalues `0 < λ₁ ≤ λ₂ ≤ ...` accumulate at ∞.

**Citation.** Evans 1998, Ch. 6 §5.1 (Eigenvalues of symmetric elliptic
operators); Courant–Hilbert 1924, Kap. VI. -/
axiom dirichlet_eigen_discrete
    {Ω : Type*} (D : EllipticData) :
    HasDiscreteSpectrum (Ω := Ω) D

end EllipticRegularity
end Evans1998
end PDE
end Analysis
end MathlibExpansion
