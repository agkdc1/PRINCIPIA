import Mathlib.AlgebraicGeometry.Scheme

/-!
# T20c_late_02 SDDS — Serre duality / dualizing sheaf (B4 breach_candidate, Ch. III)

**Classification.** `breach_candidate` / `B4` per Step 5 verdict. Dualizing
sheaf, trace, and Serre pairing are still genuinely absent.

**Dispatch note.** Cycle-1 opens the B4 breach with marker axioms for the
dualizing sheaf `omega_X`, trace map `t : H^n(X, omega_X) → k`, and Serre
duality pairing `H^i(X, F) × Ext^{n-i}(F, omega_X) → k`. Sharp signatures
deferred to cycle-2 once QCP coherent subcategory, SKD Kähler differentials,
PMTRP projective carrier, and PST projective cohomology carriers stabilize.

**Citation.** Hartshorne, *Algebraic Geometry*, GTM 52 (1977), Ch. III §7,
pp. 239–248. Historical parent: Serre, "Un théorème de dualité", Comment.
Math. Helv. 29 (1955); Grothendieck–Hartshorne, *Residues and Duality*,
LNM 20 (1966). Modern: Stacks Project Tag 0A7U (dualizing), Tag 0FVU
(Serre duality).
-/

namespace MathlibExpansion
namespace Roots
namespace Hartshorne
namespace T20cLate02_SDDS

/-- **SDDS_01** dualizing sheaf carrier marker (2026-04-24). For a proper
`n`-dimensional scheme `X` over a field `k`, there exists a dualizing sheaf
`omega_X` — a coherent `O_X`-module with a trace `t : H^n(X, omega_X) → k`.
Marker reserves the B4 owner slot.

Citation: Hartshorne Ch. III §7, p. 241. -/
axiom dualizing_sheaf_carrier_marker : True

/-- **SDDS_04** Serre duality pairing marker (2026-04-24). For `X` a smooth
projective `n`-dimensional variety over `k` and `F` a coherent sheaf, the
pairing `H^i(X, F) ⊗ Ext^{n-i}(F, omega_X) → H^n(X, omega_X) → k` is perfect.

Citation: Hartshorne Ch. III Thm. 7.6, p. 243. -/
axiom serre_duality_pairing_marker : True

/-- **SDDS_06** smooth dualizing = canonical marker (2026-04-24). For `X`
smooth projective of dimension `n`, the dualizing sheaf equals the canonical
sheaf `omega_X ≃ ∧^n Omega_{X/k}`.

Citation: Hartshorne Ch. III Thm. 7.11, p. 246. -/
axiom smooth_dualizing_eq_canonical_marker : True

end T20cLate02_SDDS
end Hartshorne
end Roots
end MathlibExpansion
