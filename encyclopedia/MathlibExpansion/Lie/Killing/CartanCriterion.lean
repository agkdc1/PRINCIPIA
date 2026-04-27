import Mathlib.Algebra.Lie.Killing

/-!
# Cartan criterion converse

This file records the deferred upstream-facing converse direction of Cartan's
criterion in characteristic zero.
-/

universe u v

namespace MathlibExpansion.Lie.Killing

/--
Upstream-narrow deferred axiom.

Source: É. Cartan, *Sur la structure des groupes de transformations finis et
continus* (1894), Ch. IV §1, Théorème I, pp. 51-52. This is exactly the
characteristic-zero converse highlighted by the upstream TODO in
`Mathlib/Algebra/Lie/Killing.lean`.
-/
axiom isKilling_of_isSemisimple {K : Type u} {L : Type v}
    [Field K] [CharZero K] [LieRing L] [LieAlgebra K L] [FiniteDimensional K L]
    [LieAlgebra.IsSemisimple K L] :
    LieAlgebra.IsKilling K L

end MathlibExpansion.Lie.Killing
