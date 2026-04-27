import Mathlib.AlgebraicGeometry.Scheme

/-!
# T20c_late_02 SIRR — Surface intersection pairing / surface RR (B6 novel_theorem, Ch. V)

**Classification.** `novel_theorem` / `B6` per Step 5 verdict. First real
Chapter V numerical theorem, but only after surface divisor/intersection/duality
carriers exist. Assigned to `opus-ahn max` tier.

**Dispatch note.** Cycle-1 opens the B6 novel-theorem front with marker axioms
for the symmetric bilinear intersection pairing `Div(X) × Div(X) → ℤ`, the
self-intersection, and the surface Riemann-Roch
`χ(D) = (1/2)D·(D-K) + χ(O_X)`. Sharp signatures deferred to cycle-2 once
CWP divisor, SDDS dualizing sheaf, SSHC cohomology, and PMTRP projective
surface carriers stabilize.

**Citation.** Hartshorne, *Algebraic Geometry*, GTM 52 (1977), Ch. V §1,
pp. 357–366 (Thms. 1.1, 1.6). Historical parent: Severi, *Trattato di geometria
algebrica*, Zanichelli (1926); Zariski, "Pencils on an algebraic variety",
Amer. J. Math. 81 (1959); Mumford, *Lectures on Curves on an Algebraic
Surface*, Princeton (1966). Modern: Beauville, *Complex Algebraic Surfaces*,
LMS Student Texts 34 (1996), §§I–II.
-/

namespace MathlibExpansion
namespace Roots
namespace Hartshorne
namespace T20cLate02_SIRR

/-- **SIRR_01** intersection pairing carrier marker (2026-04-24). For a smooth
projective surface `X/k`, there is a symmetric bilinear pairing
`Div(X) × Div(X) → ℤ, (C, D) ↦ C · D`. Marker reserves the B6 novel-theorem slot.

Citation: Hartshorne Ch. V Thm. 1.1, p. 357. -/
axiom surface_intersection_pairing_marker : True

/-- **SIRR_03** self-intersection marker (2026-04-24). For a curve `C` on a
smooth projective surface `X`, the self-intersection `C · C = deg(N_{C/X})`
where `N_{C/X}` is the normal bundle.

Citation: Hartshorne Ch. V §1, p. 361 (Prop. 1.5). -/
axiom self_intersection_formula_marker : True

/-- **SIRR_06** surface Riemann-Roch marker (2026-04-24). For a divisor `D`
on a smooth projective surface `X`,
`χ(D) = (1/2) D · (D - K_X) + χ(O_X)`.

Citation: Hartshorne Ch. V Thm. 1.6, p. 362. -/
axiom surface_riemann_roch_marker : True

end T20cLate02_SIRR
end Hartshorne
end Roots
end MathlibExpansion
