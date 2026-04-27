import Mathlib.AlgebraicGeometry.Scheme

/-!
# T20c_late_02 PST — Projective space cohomology of twists (B3 novel_theorem, Ch. III)

**Classification.** `novel_theorem` / `B3` per Step 5 verdict. Explicit
`H^i(P^n, O(m))` formulas are a genuine theorem lane, not just packaging.
The Chapter III.5 computation engine.

**Dispatch note.** Cycle-1 opens the B3 novel-theorem front with marker
axioms for the three-regime cohomology formula: `H^0(P^n, O(m))` degree-`m`
polynomials for `m ≥ 0`, `H^n(P^n, O(m))` Serre-dual formula for `m ≤ -n-1`,
middle vanishing otherwise. Sharp signatures deferred to cycle-2 once PMTRP
`O(1)` carrier and SSHC derived-functor carriers stabilize.

**Citation.** Hartshorne, *Algebraic Geometry*, GTM 52 (1977), Ch. III §5,
pp. 225–231 (Thm. 5.1). Historical parent: Serre, "Faisceaux algébriques
cohérents", Ann. Math. 61 (1955), §§62–78. Modern: EGA III §§2.1, 3.2;
Stacks Project Tag 01XT.
-/

namespace MathlibExpansion
namespace Roots
namespace Hartshorne
namespace T20cLate02_PST

/-- **PST_01** `H^0(P^n, O(m))` degree-polynomial formula marker (2026-04-24).
For `m ≥ 0`, `H^0(P^n_A, O(m))` is the free `A`-module of degree-`m`
homogeneous polynomials in `n+1` variables, of rank `binom(m+n, n)`.
Marker reserves the B3 novel-theorem slot.

Citation: Hartshorne Ch. III Thm. 5.1(a), p. 225. -/
axiom projective_space_H0_polynomial_marker : True

/-- **PST_03** middle-dimension vanishing marker (2026-04-24). For `0 < i < n`
and any `m`, `H^i(P^n_A, O(m)) = 0`.

Citation: Hartshorne Ch. III Thm. 5.1(b), p. 225. -/
axiom projective_space_middle_vanishing_marker : True

/-- **PST_05** top-dimension Serre-dual formula marker (2026-04-24). For
`m ≤ -n-1`, `H^n(P^n_A, O(m))` is free of rank `binom(-m-1, n)`; dual to
`H^0(P^n, O(-m-n-1))`.

Citation: Hartshorne Ch. III Thm. 5.1(c), p. 225. -/
axiom projective_space_Hn_dual_marker : True

end T20cLate02_PST
end Hartshorne
end Roots
end MathlibExpansion
