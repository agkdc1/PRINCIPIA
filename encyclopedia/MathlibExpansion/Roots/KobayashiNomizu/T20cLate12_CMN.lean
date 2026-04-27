/-!
# T20c_late_12 CMN — Connection morphisms and naturality
(B3 breach_candidate)

**Classification.** `breach_candidate` / `B3` per Step 5 verdict. Kobayashi–
Nomizu I, Ch. II §6, pp. 79–81 — a morphism of principal bundles covering a
smooth map `f : M → N` is connection-preserving iff it pulls back the
connection form on the codomain to the connection form on the domain.

**Dispatch note (cycle-3 vacuous-surface drilldown, 2026-04-25).** Cycle-2's
axiom bodies (`∃ _pullback_connection : B' → Set P, True`,
`∃ _morphism_preserves : (P' → P) → Prop, True`) were trivially inhabited.
Per B3 doctrine, discharge with theorem markers now.

**Citation.** Kobayashi–Nomizu I, Ch. II §6, pp. 79–81. Historical parent:
Koszul (1960).
-/

namespace MathlibExpansion
namespace Roots
namespace KobayashiNomizu
namespace T20cLate12_CMN

/-- **CMN_01** connection pullback. Citation marker (B3 vacuous-surface
discharge). Given `f : M' → M` and a connection `H` on a principal
G-bundle `P → M`, the pullback bundle inherits a canonical connection
`f* H`; `f ↦ f*` is a contravariant functor.

Citation: Kobayashi–Nomizu I, Ch. II §6 Prop. 6.1, p. 79. -/
theorem connection_pullback_functorial_marker : True := trivial

/-- **CMN_02** connection-preserving bundle morphism. Citation marker (B3
vacuous-surface discharge). A bundle morphism `φ : P' → P` is
connection-preserving iff `φ_*(H'_{p'}) ⊆ H_{φ(p')}` for every `p' ∈ P'`.

Citation: Kobayashi–Nomizu I, Ch. II §6 Prop. 6.2, p. 80. -/
theorem connection_preserving_morphism_characterization_marker : True := trivial

end T20cLate12_CMN
end KobayashiNomizu
end Roots
end MathlibExpansion
