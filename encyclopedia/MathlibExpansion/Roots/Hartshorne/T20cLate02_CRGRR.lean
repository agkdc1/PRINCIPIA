import Mathlib.AlgebraicGeometry.Scheme

/-!
# T20c_late_02 CRGRR — Chow ring / Chern classes / Grothendieck-RR (B7 breach_candidate, App A)

**Classification.** `breach_candidate` / `B7` per Step 5 verdict. Entirely new
late outgoing corridor `cycles → Chow → Chern → K0/ch/Td → HRR/GRR`.
Assigned to `opus-ahn max` tier.

**Dispatch note.** Cycle-1 opens the B7 breach with marker axioms for the
Chow ring `A^*(X)` of algebraic cycles modulo rational equivalence, Chern
classes `c_i(E)` of a vector bundle, the Chern character `ch`, Todd class
`td`, and Grothendieck-Riemann-Roch `f_!(ch(E) · td(T_f)) = ch(Rf_* E) · td(T_Y)`.
Sharp signatures deferred to cycle-2 once SIRR surface intersection, CWP
divisor, and SDDS duality carriers stabilize.

**Citation.** Hartshorne, *Algebraic Geometry*, GTM 52 (1977), App. A,
pp. 425–437. Historical parent: Grothendieck (seminar notes), "Classes de
faisceaux et théorème de Riemann-Roch", SGA 6 (1966–67); Borel–Serre,
"Le théorème de Riemann-Roch", Bull. Soc. Math. France 86 (1958); Chow,
"On equivalence classes of cycles", Ann. Math. 64 (1956). Modern: Fulton,
*Intersection Theory*, Springer (1998), §§1–15; Stacks Project Tag 0AZ6.
-/

namespace MathlibExpansion
namespace Roots
namespace Hartshorne
namespace T20cLate02_CRGRR

/-- **CRGRR_01** Chow ring carrier marker (2026-04-24). For a smooth variety
`X`, the Chow group `A^k(X)` is codimension-`k` cycles modulo rational
equivalence; intersection product makes `A^*(X) := ⊕_k A^k(X)` a graded
commutative ring. Marker reserves the B7 breach slot.

Citation: Hartshorne App. A §1, p. 425. -/
axiom chow_ring_carrier_marker : True

/-- **CRGRR_03** Chern class carrier marker (2026-04-24). For a rank-`r`
vector bundle `E` on a smooth variety `X`, the Chern classes `c_i(E) ∈ A^i(X)`
satisfy `c_0 = 1`, `c_i(E) = 0` for `i > r`, and the Whitney product formula.

Citation: Hartshorne App. A §3, p. 429. -/
axiom chern_classes_marker : True

/-- **CRGRR_05** Chern character / Todd class marker (2026-04-24). The Chern
character `ch(E) := Σ exp(α_i)` and Todd class `td(E) := Π α_i / (1 - exp(-α_i))`
are defined via formal Chern roots `α_i`.

Citation: Hartshorne App. A §4, p. 432. -/
axiom chern_character_todd_class_marker : True

/-- **CRGRR_07** Grothendieck-Riemann-Roch marker (2026-04-24). For a proper
smooth morphism `f : X → Y` of smooth quasi-projective varieties and a
coherent sheaf `F` on `X`,
`f_*(ch(F) · td(T_{X/Y})) = ch(f_! F) · td(T_{Y})`
in `A^*(Y) ⊗ ℚ`.

Citation: Hartshorne App. A Thm. 5.3, p. 436. -/
axiom grothendieck_riemann_roch_marker : True

end T20cLate02_CRGRR
end Hartshorne
end Roots
end MathlibExpansion
