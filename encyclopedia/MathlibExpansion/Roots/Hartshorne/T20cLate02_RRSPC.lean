import Mathlib.AlgebraicGeometry.Scheme

/-!
# T20c_late_02 RRSPC — Riemann-Roch for smooth projective curves (B5 novel_theorem, Ch. IV)

**Classification.** `novel_theorem` / `B5` per Step 5 verdict. Chapter IV.1 is
a real curve RR package, not covered by the local modular boundary files.
The first general curve theorem lane.

**Dispatch note.** Cycle-1 opens the B5 novel-theorem front with marker axioms
for the genus `g := h^1(X, O_X)`, canonical divisor `K_X`, Riemann-Roch formula
`ℓ(D) - ℓ(K - D) = deg(D) + 1 - g`, and the degree of the canonical divisor
`deg(K) = 2g - 2`. Sharp signatures deferred to cycle-2 once CWP divisor,
SKD Kähler differentials, PMTRP projective carrier, and SDDS Serre duality
stabilize.

**Citation.** Hartshorne, *Algebraic Geometry*, GTM 52 (1977), Ch. IV §1,
pp. 294–299 (Thm. 1.3). Historical parent: Riemann, "Theorie der Abel'schen
Functionen", J. reine angew. Math. 54 (1857); Roch, "Ueber die Anzahl der
willkürlichen Constanten", J. reine angew. Math. 64 (1865); Weil,
*Foundations of Algebraic Geometry*, AMS Coll. 29 (1946). Modern: Stacks
Project Tag 0B5B.
-/

namespace MathlibExpansion
namespace Roots
namespace Hartshorne
namespace T20cLate02_RRSPC

/-- **RRSPC_01** curve genus carrier marker (2026-04-24). For `X` a smooth
projective curve over an algebraically closed field `k`, the genus
`g(X) := dim_k H^1(X, O_X)`. Marker reserves the B5 novel-theorem slot.

Citation: Hartshorne Ch. IV §1, p. 294. -/
axiom curve_genus_marker : True

/-- **RRSPC_04** canonical divisor marker (2026-04-24). For a smooth
projective curve `X/k`, the canonical divisor `K_X` is the divisor class
of `omega_{X/k} ≃ Omega^1_{X/k}`.

Citation: Hartshorne Ch. IV §1, p. 295. -/
axiom canonical_divisor_marker : True

/-- **RRSPC_07** Riemann-Roch formula marker (2026-04-24). For a divisor `D`
on a smooth projective curve `X` of genus `g`,
`ℓ(D) - ℓ(K - D) = deg(D) + 1 - g`.

Citation: Hartshorne Ch. IV Thm. 1.3, p. 295. -/
axiom riemann_roch_curve_marker : True

/-- **RRSPC_09** canonical degree marker (2026-04-24). The canonical divisor
`K_X` on a smooth projective curve of genus `g` has degree `2g - 2`.

Citation: Hartshorne Ch. IV Cor. 1.3.2, p. 295. -/
axiom canonical_degree_marker : True

end T20cLate02_RRSPC
end Hartshorne
end Roots
end MathlibExpansion
