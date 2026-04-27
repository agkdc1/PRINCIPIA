import Mathlib.AlgebraicGeometry.Scheme

/-!
# T20c_late_02 NSRLB — Nonsingularity / regular-local bridge (B1 substrate, Ch. I)

**Classification.** `substrate_gap` / `B1` per Step 5 verdict. Real bridge from
current smoothness/tangent atoms to Hartshorne nonsingularity language. The
regular-local and tangent-space criteria are still the honest bridge from the
Mathlib smoothness substrate to the Hartshorne nonsingularity language.

**Dispatch note.** Cycle-1 opens the B1 substrate front with marker axioms:
`regular_local_iff_smooth`, `tangent_space_dim_eq_krull_dim`, and
`nonsingular_locus_open`. Sharp signatures land in cycle-2 once the
`MathlibExpansion.Roots.AtiyahMacdonald.T20cLate01_RLH2` regular-local
carriers stabilize — this is the explicit cross-textbook seam.

**Citation.** Hartshorne, *Algebraic Geometry*, GTM 52 (1977), Ch. I §§5–6,
pp. 31–47. Historical parent: Zariski, "The concept of a simple point of
an abstract algebraic variety", Trans. AMS 62 (1947); Auslander & Buchsbaum,
"Homological dimension in local rings", Trans. AMS 85 (1957). Modern:
Matsumura, *Commutative Ring Theory*, Cambridge (1986), §19.
-/

namespace MathlibExpansion
namespace Roots
namespace Hartshorne
namespace T20cLate02_NSRLB

/-- **NSRLB_03** regular-local ↔ smooth bridge marker (2026-04-24). A
scheme `X` is nonsingular at a point `x` iff the local ring `O_{X,x}` is
regular. Marker reserves the bridge pending RLH2 regular-local carrier
stabilization.

Citation: Hartshorne Ch. I Thm. 5.1, p. 32. -/
axiom regular_local_iff_smooth_marker : True

/-- **NSRLB_05** tangent-space dimension identification marker
(2026-04-24). The Zariski tangent space `T_x X := (𝔪_x / 𝔪_x²)^*` has
dimension equal to the embedding dimension, with equality to Krull
dimension iff `X` is nonsingular at `x`.

Citation: Hartshorne Ch. I Thm. 5.1, p. 32. -/
axiom tangent_space_dim_eq_krull_dim_marker : True

/-- **NSRLB_07** nonsingular-locus openness marker (2026-04-24). For a
variety `X` over a field, the nonsingular locus is open and dense.

Citation: Hartshorne Ch. I Thm. 5.3, p. 33. -/
axiom nonsingular_locus_open_marker : True

end T20cLate02_NSRLB
end Hartshorne
end Roots
end MathlibExpansion
