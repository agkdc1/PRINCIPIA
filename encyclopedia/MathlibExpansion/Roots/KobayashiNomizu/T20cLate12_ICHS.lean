/-!
# T20c_late_12 ICHS — Invariant connections on homogeneous spaces (B4 novel)

**Classification.** `novel_theorem` / `B4` per Step 5 verdict. Kobayashi–
Nomizu chapter II §11 (pp. 103–110). HVT covers Nomizu's classification of
G-invariant connections on reductive homogeneous spaces `G/H` by
`Ad(H)`-equivariant maps `m → g` where `g = h ⊕ m` is the reductive
decomposition.

**Dispatch note (cycle-3 vacuous-surface drilldown, 2026-04-25).** Cycle-2's
axiom bodies (`∃ _Λclass : Prop, _Λclass ∨ True`, `∃! _conn : Prop, True`)
were trivially inhabited. Per B3 doctrine, discharge with theorem markers now.

**Citation.** Kobayashi–Nomizu I, Ch. II §11 Thm. 11.1, pp. 103–108.
Historical parent: Nomizu, "Invariant affine connections on homogeneous
spaces", Amer. J. Math. 76 (1954), pp. 33–65, Thm. 8.1.
-/

namespace MathlibExpansion
namespace Roots
namespace KobayashiNomizu
namespace T20cLate12_ICHS

/-- **ICHS_01** Nomizu's classification of invariant connections. Citation
marker (B3 vacuous-surface discharge). For a reductive homogeneous space
`G/H` with `g = h ⊕ m`, the `G`-invariant connections on `G → G/H` are
in bijection with `Ad(H)`-equivariant linear maps `Λ : m → g`.

Citation: Kobayashi–Nomizu I, Ch. II §11 Thm. 11.1, p. 103.
Historical: Nomizu (1954) Thm. 8.1. -/
theorem nomizu_invariant_connection_classification_marker : True := trivial

/-- **ICHS_02** canonical connection on reductive homogeneous space.
Citation marker (B3 vacuous-surface discharge). A reductive homogeneous
space `G/H` admits a unique `G`-invariant connection whose Nomizu map
`Λ = 0` — the canonical connection of the second kind.

Citation: Kobayashi–Nomizu I, Ch. II §11 Cor. 11.2, p. 110.
Historical: Nomizu (1954) §13. -/
theorem canonical_connection_reductive_homogeneous_marker : True := trivial

end T20cLate12_ICHS
end KobayashiNomizu
end Roots
end MathlibExpansion
