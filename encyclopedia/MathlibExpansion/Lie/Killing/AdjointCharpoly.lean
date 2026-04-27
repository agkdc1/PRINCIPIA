import Mathlib

/-!
# Adjoint characteristic polynomial invariants

This file records the deferred upstream-facing Cartan 1894 gap for the
characteristic polynomial of the adjoint representation.
-/

universe u v w

namespace MathlibExpansion.Lie.Killing

/--
The characteristic polynomial of the adjoint map is invariant under Lie algebra equivalence.

Source: É. Cartan, *Sur la structure des groupes de transformations finis et
continus* (1894), Ch. II §3, Théorème II, p. 27; with Cartan's cited precursor
references to Killing, *Z. v. G.* I, p. 259 sqq., Umlauf (1891), p. 15 sqq.,
and Engel's shorter proof.
-/
theorem ad_charpoly_coeff_lieEquiv {K : Type u} {L : Type v} {L' : Type w}
    [Field K] [LieRing L] [LieAlgebra K L] [LieRing L'] [LieAlgebra K L']
    [FiniteDimensional K L] [FiniteDimensional K L']
    (e : L ≃ₗ⁅K⁆ L') (x : L) (n : ℕ) :
    (LinearMap.charpoly (LieAlgebra.ad K L' (e x))).coeff n =
      (LinearMap.charpoly (LieAlgebra.ad K L x)).coeff n := by
  rw [← LieAlgebra.conj_ad_apply (R := K) e x, LinearEquiv.charpoly_conj]

end MathlibExpansion.Lie.Killing
