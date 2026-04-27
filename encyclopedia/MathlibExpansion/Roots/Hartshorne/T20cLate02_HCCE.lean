import Mathlib.AlgebraicGeometry.Scheme

/-!
# T20c_late_02 HCCE — Hurwitz / canonical curve embedding (B5 breach_candidate, Ch. IV)

**Classification.** `breach_candidate` / `B5` per Step 5 verdict. Downstream
curve consumer lane after divisor, canonical, and RR infrastructure lands.

**Dispatch note.** Cycle-1 opens the B5 breach with marker axioms for the
Hurwitz formula for finite separable curve morphisms, the canonical embedding
of a non-hyperelliptic curve, and the hyperelliptic trichotomy. Sharp
signatures deferred to cycle-2 once RRSPC curve RR, CWP divisor, and SKD
Kähler carriers stabilize.

**Citation.** Hartshorne, *Algebraic Geometry*, GTM 52 (1977), Ch. IV §§2,5,
pp. 299–308, 340–352. Historical parent: Hurwitz, "Über Riemann'sche Flächen
mit gegebenen Verzweigungspunkten", Math. Ann. 39 (1891); Clifford, "On the
classification of loci", Phil. Trans. Roy. Soc. 169 (1878). Modern: Stacks
Project Tag 0C1B (Hurwitz), Tag 0E8R (canonical embedding).
-/

namespace MathlibExpansion
namespace Roots
namespace Hartshorne
namespace T20cLate02_HCCE

/-- **HCCE_01** Hurwitz ramification formula marker (2026-04-24). For a finite
separable morphism `f : X → Y` of smooth projective curves with ramification
divisor `R`, `2g_X - 2 = deg(f)(2g_Y - 2) + deg(R)`. Marker reserves the B5
breach slot.

Citation: Hartshorne Ch. IV Cor. 2.4, p. 301. -/
axiom hurwitz_ramification_formula_marker : True

/-- **HCCE_03** canonical embedding marker (2026-04-24). For a non-hyperelliptic
smooth projective curve `X` of genus `g ≥ 3`, the canonical linear system
`|K_X|` is very ample, giving a closed embedding `X → P^{g-1}`.

Citation: Hartshorne Ch. IV Prop. 5.2, p. 341. -/
axiom canonical_embedding_marker : True

/-- **HCCE_05** hyperelliptic trichotomy marker (2026-04-24). A smooth
projective curve `X` of genus `g ≥ 2` admits a `2:1` cover `X → P^1` iff
it is hyperelliptic; curves of genus `g ≤ 2` satisfy special cases.

Citation: Hartshorne Ch. IV §5, p. 341. -/
axiom hyperelliptic_trichotomy_marker : True

end T20cLate02_HCCE
end Hartshorne
end Roots
end MathlibExpansion
