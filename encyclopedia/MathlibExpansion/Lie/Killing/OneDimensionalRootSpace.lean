import Mathlib.Algebra.Lie.Weights.Killing

/-!
# One-dimensional root spaces (Cartan 1894, CKF_07)

For a finite-dimensional Lie algebra over a field of characteristic zero
with non-degenerate Killing form and a Cartan subalgebra `H`, each non-zero
root space has dimension exactly one.

Source: É. Cartan, *Sur la structure des groupes de transformations finis
et continus* (1894), Ch. IV §2, Théorème III, with Killing (1888-90),
*Die Zusammensetzung der stetigen endlichen Transformationsgruppen*
Parts I-IV, as precursor. The Mathlib statement is Oliver Nash's
`finrank_rootSpace_eq_one` in
`Mathlib.Algebra.Lie.Weights.Killing`.
-/

noncomputable section

open Module LieAlgebra LieModule

universe u v

namespace MathlibExpansion.Lie.Killing

variable {K : Type u} {L : Type v}
  [Field K] [CharZero K] [LieRing L] [LieAlgebra K L] [FiniteDimensional K L]
  [LieAlgebra.IsKilling K L]
  {H : LieSubalgebra K L} [H.IsCartanSubalgebra] [LieModule.IsTriangularizable K H L]

/--
For a Killing Lie algebra in characteristic zero with a Cartan subalgebra `H`
and triangular root data, every non-zero root space `rootSpace H α` has
`K`-dimension `1`.

This is the CKF_07 target of Cartan's 1894 Ch. IV §2 classification,
carried through Mathlib's `LieAlgebra.IsKilling.finrank_rootSpace_eq_one`.
-/
theorem finrank_rootSpace_eq_one_of_isNonZero
    (α : Weight K H L) (hα : α.IsNonZero) :
    Module.finrank K (rootSpace H α) = 1 :=
  LieAlgebra.IsKilling.finrank_rootSpace_eq_one α hα

end MathlibExpansion.Lie.Killing
