import Mathlib.AlgebraicGeometry.Scheme

/-!
# T20c_late_03 TPB_POLARIZATION — Polarization morphism surface (B4 substrate_gap)

**Classification.** `substrate_gap` / `B4` per Step 5 verdict. Split from TPB in
Round 2 consensus: TPB_01-02 carry the `λ_L : A → A^∨` algebraic-polarization
carrier, held separately from TPB_03-06 (theta divisor / ppav) which defer to
`TPB_THETA_DEFER`. Assigned to `codex-opus-ahn2` tier.

**Dispatch note.** Cycle-1 opens the B4 substrate_gap with marker axioms for:
the polarization morphism `λ_L : A → A^∨` arising from a line bundle, and the
principal-polarization criterion `λ_L` an isomorphism ⇔ `L` is a principal
polarization (`deg φ_L = 1`).

**Citation.** Mumford, *Abelian Varieties*, TIFR Studies in Mathematics 5
(Oxford, 1974), §§6, 13, 16, 17. Historical parent: Weil, *Variétés
abéliennes*, Hermann (1948), Ch. VII; Mumford, "On the equations defining
abelian varieties I", Invent. Math. 1 (1966). Modern: Birkenhake–Lange,
*Complex Abelian Varieties*, 2nd ed. (Springer 2004), §§4, 11; Milne,
*Abelian Varieties*, §13.
-/

namespace MathlibExpansion
namespace Roots
namespace Mumford
namespace T20cLate03_TPB_POLARIZATION

/-- **TPB_01** polarization morphism from line bundle marker (2026-04-24). For
a line bundle `L` on an abelian variety `A`, the map `λ_L : A → A^∨`,
`a ↦ t_a^* L ⊗ L^{-1}`, is a morphism of abelian varieties. Algebraic /
scheme-theoretic surface (independent of CTAV_DEFER analytic bridge).

Citation: Mumford §6, Cor. 4, p. 60; §13, p. 125. -/
axiom polarization_morphism_lambda_L_marker : True

/-- **TPB_02** principal-polarization iso criterion marker (2026-04-24). The
polarization `λ_L : A → A^∨` is an isomorphism iff `L` defines a principal
polarization, equivalently `χ(A, L) = ±1` and `deg φ_L = 1`. Algebraic
criterion bypassing the theta-divisor route (TPB_THETA_DEFER).

Citation: Mumford §16, Thm., p. 150; §17, p. 163. -/
axiom principal_polarization_iso_criterion_marker : True

end T20cLate03_TPB_POLARIZATION
end Mumford
end Roots
end MathlibExpansion
