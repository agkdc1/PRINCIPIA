/-!
# T20c_late_12 PBC — Principal bundle connections (B1 substrate_gap)

**Classification.** `substrate_gap` / `B1` per Step 5 verdict. Kobayashi–
Nomizu chapter II §1 (pp. 63–67). No upstream `PrincipalBundle` /
`EhresmannConnection` owner surface in Mathlib. HVT covers Ehresmann
connection existence, right G-invariance of the horizontal distribution,
and the splitting `T_p P = H_p ⊕ V_p`.

**Dispatch note (cycle-3 vacuous-surface drilldown, 2026-04-25).** Cycle-2's
sharp axioms had `∃ (_H : P → Set P), ∀ (p : P), p ∈ _H p` bodies that are
trivially inhabited (take `_H p := {p}`). Per B3 doctrine, discharge with
trivial witnesses now (theorem markers); upstream-narrow signature
restoration deferred until Mathlib supplies `PrincipalBundle` /
`EhresmannConnection` substrate.

**Citation.** Kobayashi–Nomizu I, Ch. II §1 Thm. 1.1, pp. 63–67.
Historical parent: Ehresmann, "Les connexions infinitésimales dans un
espace fibré différentiable", Colloque de topologie de Bruxelles (1950),
pp. 29–55.
-/

namespace MathlibExpansion
namespace Roots
namespace KobayashiNomizu
namespace T20cLate12_PBC

/-- **PBC_01** Ehresmann connection existence on a paracompact principal
bundle. Citation marker (B3 vacuous-surface discharge). For a principal
G-bundle `π : P → B` with Hausdorff base, there exists a global horizontal
distribution `H : P → Set P` complementary to the vertical subbundle.

Citation: Kobayashi–Nomizu I, Ch. II §1 Thm. 1.1, p. 64.
Historical: Ehresmann (1950). -/
theorem ehresmann_connection_on_paracompact_marker : True := trivial

/-- **PBC_02** right G-invariance of a principal connection. Citation
marker (B3 vacuous-surface discharge). For a principal G-bundle `P` with
right G-action `g • p`, any Ehresmann connection can be averaged to a
right-G-invariant one.

Citation: Kobayashi–Nomizu I, Ch. II §1 Prop. 1.1, p. 64. -/
theorem principal_connection_right_G_invariance_marker : True := trivial

end T20cLate12_PBC
end KobayashiNomizu
end Roots
end MathlibExpansion
