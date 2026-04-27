import Mathlib.Algebra.Lie.Weights.Killing

/-!
# Cartan subalgebra restriction of the Killing form (Cartan 1894, CKF_05)

For a Lie algebra with non-degenerate Killing form over a commutative ring, the
restriction of the Killing form to any Cartan subalgebra is non-degenerate.

Source: É. Cartan, *Sur la structure des groupes de transformations finis
et continus* (1894), Ch. III §1, Théorème II, with Killing (1888-90),
*Die Zusammensetzung der stetigen endlichen Transformationsgruppen*,
Part II, as precursor. The Mathlib statement is
`LieAlgebra.IsKilling.ker_restrict_eq_bot_of_isCartanSubalgebra` /
`LieAlgebra.IsKilling.traceForm_cartan_nondegenerate` by Oliver Nash in
`Mathlib.Algebra.Lie.Weights.Killing`.
-/

noncomputable section

open LieAlgebra LieModule

universe u v

namespace MathlibExpansion.Lie.Killing

variable (R : Type u) (L : Type v) [CommRing R]
  [LieRing L] [LieAlgebra R L]
  [LieAlgebra.IsKilling R L] [IsNoetherian R L] [IsArtinian R L]
  (H : LieSubalgebra R L) [H.IsCartanSubalgebra]

/--
The kernel of the Killing form restricted to any Cartan subalgebra of a Killing
Lie algebra is trivial.
-/
theorem ker_restrict_killingForm_cartan :
    LinearMap.ker ((killingForm R L).restrict H) = ⊥ :=
  LieAlgebra.IsKilling.ker_restrict_eq_bot_of_isCartanSubalgebra R L H

/--
Non-degeneracy of the restricted Killing form on a Cartan subalgebra — the CKF_05
surface from Cartan's 1894 Ch. III §1.
-/
theorem restrict_killingForm_cartan_nondegenerate :
    (LieModule.traceForm R H L).Nondegenerate :=
  LieAlgebra.IsKilling.traceForm_cartan_nondegenerate R L H

end MathlibExpansion.Lie.Killing
