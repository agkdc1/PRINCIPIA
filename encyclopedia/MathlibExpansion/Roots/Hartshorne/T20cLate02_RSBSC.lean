import Mathlib.AlgebraicGeometry.Scheme

/-!
# T20c_late_02 RSBSC — Ruled surfaces / blowups / classification (B6 breach_candidate, Ch. V)

**Classification.** `breach_candidate` / `B6` per Step 5 verdict. Only the
blowup/blowdown slice is actionable early; ruled/classification claims stay
gated.

**Dispatch note.** Cycle-1 opens the B6 breach with marker axioms for blowup
of a smooth surface at a point, exceptional divisor, and the blowdown
criterion (Castelnuovo). Ruled-surface and Enriques-style classification
claims stay explicitly gated — only the blowup/blowdown slice is opened.

**Citation.** Hartshorne, *Algebraic Geometry*, GTM 52 (1977), Ch. V §§2,3,
pp. 366–386 (Props. 3.1, 3.2; blowdown Thm. 5.7). Historical parent:
Castelnuovo, "Sulla razionalità delle superficie algebriche", Atti Accad.
Torino 36 (1900); Enriques, *Le superficie algebriche*, Zanichelli (1949);
Kodaira, "On compact analytic surfaces II", Ann. Math. 77 (1963). Modern:
Beauville, *Complex Algebraic Surfaces*, LMS 34 (1996), §§II–III.
-/

namespace MathlibExpansion
namespace Roots
namespace Hartshorne
namespace T20cLate02_RSBSC

/-- **RSBSC_01** blowup at a point carrier marker (2026-04-24). For a smooth
projective surface `X` and a point `p ∈ X`, there is a blowup `π : X̃ → X`
with exceptional divisor `E = π^{-1}(p)` isomorphic to `P^1`. Marker reserves
the B6 breach slot (blowup/blowdown only — ruled + classification stay gated).

Citation: Hartshorne Ch. V Prop. 3.1, p. 386. -/
axiom blowup_at_point_carrier_marker : True

/-- **RSBSC_03** exceptional divisor self-intersection marker (2026-04-24).
The exceptional divisor `E` of the blowup of a smooth surface at a point
satisfies `E · E = -1` and `E ≃ P^1`.

Citation: Hartshorne Ch. V Prop. 3.2, p. 386. -/
axiom exceptional_divisor_self_intersection_marker : True

/-- **RSBSC_05** Castelnuovo blowdown criterion marker (2026-04-24). A smooth
irreducible curve `E` on a smooth projective surface `X` with `E ≃ P^1` and
`E^2 = -1` is the exceptional divisor of a unique blowdown `X → X̄`.

Citation: Hartshorne Ch. V Thm. 5.7, p. 414. -/
axiom castelnuovo_blowdown_marker : True

end T20cLate02_RSBSC
end Hartshorne
end Roots
end MathlibExpansion
