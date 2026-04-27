import Mathlib.AlgebraicGeometry.Scheme

/-!
# T20c_late_02 CWP — Cartier/Weil divisor + Picard bridge (B2 substrate, Ch. II)

**Classification.** `substrate_gap` / `B2` per Step 5 verdict. Typed divisor /
invertible-sheaf / Picard lane is mandatory before curves or surfaces are
honest. Load-bearing typed boundary for curves, surfaces, and Riemann-Roch
consumers.

**Dispatch note.** Cycle-1 opens the B2 substrate with marker axioms for
`WeilDivisor`, `CartierDivisor`, `divisor_of_rational_function`, and
`Picard_group_invertible_sheaves`. Sharp signatures deferred until cycle-2
once the invertible-sheaf-on-`X.Modules` carrier lands.

**Citation.** Hartshorne, *Algebraic Geometry*, GTM 52 (1977), Ch. II §6,
pp. 129–149. Historical parent: Weil, *Sur les courbes algébriques et les
variétés qui s'en déduisent*, Hermann (1948); Cartier, "Questions de
rationalité des diviseurs en géométrie algébrique", Bull. SMF 86 (1958).
Modern: EGA IV §21; Stacks Project Tag 0AUV (Cartier), Tag 01X0 (Weil).
-/

namespace MathlibExpansion
namespace Roots
namespace Hartshorne
namespace T20cLate02_CWP

/-- **CWP_02** Weil divisor carrier marker (2026-04-24). On a Noetherian
integral separated scheme `X` regular in codimension one, `WeilDivisor X`
is the free abelian group on codimension-one prime cycles. Marker reserves
the B2 owner slot.

Citation: Hartshorne Ch. II §6.1, p. 130. -/
axiom weil_divisor_carrier_marker : True

/-- **CWP_04** Cartier divisor carrier marker (2026-04-24). On a scheme `X`,
`CartierDivisor X` is `Γ(X, 𝓚*/𝓞*)` where `𝓚` is the sheaf of total
quotient rings.

Citation: Hartshorne Ch. II §6.11, p. 140. -/
axiom cartier_divisor_carrier_marker : True

/-- **CWP_06** divisor of rational function marker (2026-04-24). For a
nonzero rational function `f` on `X`, `div(f)` is the principal Weil
(resp. Cartier) divisor.

Citation: Hartshorne Ch. II §6.11, p. 141. -/
axiom divisor_of_rational_function_marker : True

/-- **CWP_09** Picard group = invertible sheaves modulo isomorphism marker
(2026-04-24). `Pic X ≃ CartDiv X / principal ≃ CaCl X`; also isomorphic to
`H¹(X, 𝓞_X*)`.

Citation: Hartshorne Ch. II Prop. 6.15, p. 145. -/
axiom picard_group_invertible_sheaves_marker : True

end T20cLate02_CWP
end Hartshorne
end Roots
end MathlibExpansion
