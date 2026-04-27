import Mathlib.AlgebraicGeometry.Scheme

/-!
# T20c_late_02 CVST — Classical variety to scheme transport (B1 breach_candidate, Ch. I)

**Classification.** `breach_candidate` / `B1` per Step 5 verdict. Thin Chapter I
wrapper cluster over existing `Scheme`/`Spec`/`Proj`/function-field substrate.
The real boundaries are `Proj` properness (quarantined) and nonsingularity
transport (NSRLB) — NOT a second `Variety` carrier.

**Dispatch note.** Cycle-1 opens the marker front; the Hartshorne I §§1–3
wrappers for affine/quasi-affine/projective/quasi-projective varieties as
facade over scheme substrate are reserved here pending sharp signature
landing once NSRLB + CVST shelf API stabilizes.

**Citation.** Hartshorne, *Algebraic Geometry*, GTM 52 (1977), Ch. I §§1–3,
pp. 1–24. Historical parent: Weil, *Foundations of Algebraic Geometry*,
AMS Coll. 29 (1946); Serre, "Faisceaux algébriques cohérents", Ann. Math.
61 (1955). Modern: Vakil, *The Rising Sea*, §§3–4 (2024 draft).
-/

namespace MathlibExpansion
namespace Roots
namespace Hartshorne
namespace T20cLate02_CVST

/-- **CVST_01** classical-variety-to-scheme transport facade marker
(2026-04-24). For a classical affine/quasi-affine/projective/quasi-projective
variety `V` over an algebraically closed field, there exists a scheme `X(V)`
whose underlying topological space is the classical `V` and whose structure
sheaf recovers the regular-function sheaf. Marker reserves the Chapter I
wrapper front pending cycle-2 sharp signature landing.

Citation: Hartshorne Ch. I Prop. 2.6, p. 16; Prop. 3.4, p. 19. -/
axiom classical_variety_to_scheme_transport_marker : True

end T20cLate02_CVST
end Hartshorne
end Roots
end MathlibExpansion
