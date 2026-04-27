import Mathlib.AlgebraicGeometry.Scheme

/-!
# T20c_late_02 ECPG — Elliptic curve as genus-one projective curve (B6 breach_candidate, Ch. IV)

**Classification.** `breach_candidate` / `B6` per Step 5 verdict. The missing
work is the pointed genus-one bridge into the existing Weierstrass package.

**Dispatch note.** Cycle-1 opens the B6 breach with marker axioms for pointed
genus-one curve definition, Weierstrass embedding via `|3·O|`, and the j-invariant
isomorphism criterion. Sharp signatures deferred to cycle-2 once RRSPC curve
RR and HCCE canonical embedding carriers stabilize.

**Citation.** Hartshorne, *Algebraic Geometry*, GTM 52 (1977), Ch. IV §4,
pp. 316–328. Historical parent: Weierstrass, *Vorlesungen über elliptische
Funktionen*, Teubner (1893); Mordell, "On the rational solutions of
indeterminate equations", Proc. Cambridge Philos. Soc. 21 (1922); Weil,
*Courbes algébriques et variétés abéliennes*, Hermann (1971). Modern:
Silverman, *Arithmetic of Elliptic Curves*, GTM 106 (2009), §§III.1–III.3.
-/

namespace MathlibExpansion
namespace Roots
namespace Hartshorne
namespace T20cLate02_ECPG

/-- **ECPG_01** pointed genus-one curve marker (2026-04-24). A pointed
elliptic curve over `k` is a smooth projective curve `E/k` of genus 1
together with a distinguished `k`-point `O ∈ E(k)`. Marker reserves the B6
breach slot.

Citation: Hartshorne Ch. IV §4, p. 316. -/
axiom pointed_genus_one_curve_marker : True

/-- **ECPG_03** Weierstrass embedding via `|3·O|` marker (2026-04-24). For
a pointed elliptic curve `(E, O)/k`, the linear system `|3·O|` is very ample
and gives an embedding `E → P^2` as a Weierstrass cubic.

Citation: Hartshorne Ch. IV Prop. 4.6, p. 319. -/
axiom weierstrass_embedding_marker : True

/-- **ECPG_06** j-invariant isomorphism criterion marker (2026-04-24). Two
pointed elliptic curves over an algebraically closed field are isomorphic
iff they have the same j-invariant `j(E) ∈ k`.

Citation: Hartshorne Ch. IV Thm. 4.1, p. 317. -/
axiom j_invariant_iso_criterion_marker : True

end T20cLate02_ECPG
end Hartshorne
end Roots
end MathlibExpansion
