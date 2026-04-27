import MathlibExpansion.RiemannRochBridge
import MathlibExpansion.Roots.Valence.ArgumentPrinciple

/-!
# Weight-two level-two valence specialization

This module isolates the remaining analytic transfer surface after the landed
Valence chapters:

- Chapter B supplies branch-log contour lemmas, but not the full meromorphic
  argument principle on the standard fundamental domain;
- Chapter C supplies the `PSL₂(ℤ)` stabilizer cardinalities at `I` and `rho`;
- Chapter D supplies representative-based cusp orders;
- Chapter E supplies the finite-index norm pushforward and explicit
  width-weighted cusp decompositions for `Γ₀(2)` and `Γ(2)`.

The breach reports for Chapters B and E identify the two missing ingredients:

1. the local meromorphic `order → logDeriv` bridge / level-one valence count;
2. multiplicativity of local cusp order for the bundled norm pushforward.

The declarations below package the remaining level-two specialization needed by
`MathlibExpansion.Roots.ValenceFormula`. The old transfer surface is now a
theorem, derived from the narrower upstream statement that
`S₂(Γ(2)) = 0`; the faithful decomposition propositions are then vacuous.
-/

namespace MathlibExpansion
namespace Roots
namespace Valence
namespace Specialization

open MathlibExpansion.RiemannRochBridge
open scoped MatrixGroups ModularForm

noncomputable section

/-- Faithful weight-two `Γ₀(2)` valence decomposition.

For a nonzero weight-two cusp form on `Γ₀(2)`, the missing analytic transfer
from the norm pushforward yields:

- the order at `∞` recorded by `cuspOrderAtGamma0TwoForInfty`;
- a width-two cusp contribution at `0`;
- an order-two elliptic contribution;
- a nonnegative integral contribution from ordinary zeros.

The downstream valence formula only needs a weaker witness statement; the extra
terms are kept here so the primitive matches the actual specialization shape
more closely. -/
def Gamma0TwoWeightTwoValenceDecomposition : Prop :=
  ∀ f : CuspForm (CongruenceSubgroup.Gamma0 2) 2, f ≠ 0 →
    ∃ n0 nEll nReg : ℕ, 1 ≤ n0 ∧
      cuspOrderAtGamma0TwoForInfty f < ⊤ ∧
      ((cuspOrderAtGamma0TwoForInfty f).toNat : ℚ) +
          (n0 : ℚ) / 2 + (nEll : ℚ) / 2 + (nReg : ℚ) = 1 / 2

/-- Faithful weight-two `Γ(2)` valence decomposition.

For a nonzero weight-two cusp form on `Γ(2)`, the three width-two cusp orders
appear explicitly, together with a nonnegative integral contribution from
ordinary zeros. -/
def GammaTwoWeightTwoValenceDecomposition : Prop :=
  ∀ f : CuspForm (CongruenceSubgroup.Gamma 2) 2, f ≠ 0 →
    ∃ n1 n2 n3 nReg : ℕ, 1 ≤ n1 ∧ 1 ≤ n2 ∧ 1 ≤ n3 ∧
      (n1 : ℚ) / 2 + (n2 : ℚ) / 2 + (n3 : ℚ) / 2 + (nReg : ℚ) = 1

/-- Upstream vanishing boundary for weight-two cusp forms on `Γ(2)`.

Classical source: Diamond--Shurman, *A First Course in Modular Forms* (2005),
§3.1, Theorem 3.1.1 (the valence formula), specialized to `Γ(2)` with index
`6` and three width-two cusps. A nonzero cusp form would contribute at least
`1 / 2` at each cusp, hence at least `3 / 2`, contradicting the weight-two
budget `2 * 6 / 12 = 1`.

This is the remaining Mathlib gap: Mathlib has the q-expansion and cusp-order
substrate used above, but not the full congruence-subgroup valence formula. -/
axiom gammaTwoWeightTwoCuspFormsVanish :
    ∀ f : CuspForm (CongruenceSubgroup.Gamma 2) 2, f = 0

/-- The faithful `Γ₀(2)` decomposition is vacuous once
`S₂(Γ(2)) = 0`, because restriction `S₂(Γ₀(2)) → S₂(Γ(2))` is injective. -/
theorem gamma0TwoWeightTwoValenceDecomposition_of_gammaTwoVanish :
    Gamma0TwoWeightTwoValenceDecomposition := by
  intro f hf
  have hres :
      restrictCuspFormGamma0ToGamma2 2 f = 0 :=
    gammaTwoWeightTwoCuspFormsVanish (restrictCuspFormGamma0ToGamma2 2 f)
  have hf_zero : f = 0 :=
    restrictCuspFormGamma0ToGamma2_injective 2 (by simpa using hres)
  exact False.elim (hf hf_zero)

/-- The faithful `Γ(2)` decomposition is vacuous from the same vanishing
boundary. -/
theorem gammaTwoWeightTwoValenceDecomposition_of_gammaTwoVanish :
    GammaTwoWeightTwoValenceDecomposition := by
  intro f hf
  exact False.elim (hf (gammaTwoWeightTwoCuspFormsVanish f))

/-- Remaining Chapter B/E transfer theorem for the weight-two level-two
specializations used downstream by `Roots.ValenceFormula`.

The old combined axiom is discharged into theorem-land from the narrower
upstream vanishing boundary `gammaTwoWeightTwoCuspFormsVanish`. -/
theorem weightTwoLevelTwoValenceTransfer :
    Gamma0TwoWeightTwoValenceDecomposition ∧
      GammaTwoWeightTwoValenceDecomposition :=
  ⟨gamma0TwoWeightTwoValenceDecomposition_of_gammaTwoVanish,
   gammaTwoWeightTwoValenceDecomposition_of_gammaTwoVanish⟩

end
end Specialization
end Valence
end Roots
end MathlibExpansion
