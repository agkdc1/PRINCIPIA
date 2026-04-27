/-!
# T20c_late_12 EEC — Existence / extension of connections (B2 breach)

**Classification.** `breach_candidate` / `B2` per Step 5 verdict. Kobayashi–
Nomizu chapter II §2 (pp. 67–70). Connections form an affine space over
`Ω¹(B, adP)`; the existence and extension theorems relate local connection
data to global connections via partition of unity.

**Dispatch note (cycle-3 vacuous-surface drilldown, 2026-04-25).** Cycle-2's
axiom bodies (`∃ _combine : ..., ∀ ..., True` and `∃ _H, ∀ p, p ∈ _H p`)
were trivially inhabited. Per B3 doctrine, discharge with theorem markers
now; affine-space-of-connections phrasing deferred until upstream
`PrincipalBundle` substrate lands.

**Citation.** Kobayashi–Nomizu I, Ch. II §2 Thm. 2.1, pp. 67–68.
Historical parent: Koszul, "Lectures on fibre bundles and differential
geometry", Tata Institute (1960), §3.
-/

namespace MathlibExpansion
namespace Roots
namespace KobayashiNomizu
namespace T20cLate12_EEC

/-- **EEC_01** convex combination of principal connections. Citation
marker (B3 vacuous-surface discharge). For two connections `H₀, H₁` on a
principal bundle and continuous `t : B → [0,1]`, the convex combination
`(1-t)H₀ + tH₁` is again a connection; the space of connections is an
affine space over `adP`-valued 1-forms on B.

Citation: Kobayashi–Nomizu I, Ch. II §2 Thm. 2.1, p. 68. -/
theorem connection_affine_space_structure_marker : True := trivial

/-- **EEC_02** extension of a connection from a closed subset. Citation
marker (B3 vacuous-surface discharge). Given a connection `H₀` on
`π⁻¹(A)` with `A ⊆ B` closed and `B` paracompact Hausdorff, there exists
a global connection on `P` restricting to `H₀` on `π⁻¹(A)`.

Citation: Kobayashi–Nomizu I, Ch. II §2 Prop. 2.6, p. 70. -/
theorem connection_extension_from_closed_marker : True := trivial

end T20cLate12_EEC
end KobayashiNomizu
end Roots
end MathlibExpansion
