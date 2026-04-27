import Mathlib.Algebra.Lie.Weights.Killing

/-!
# Cartan integers and root-coroot pairings (Cartan 1894, CKF_06)

For a Killing Lie algebra over a field of characteristic zero with a
triangularizable Cartan subalgebra `H`, the pairing of any non-zero root with
its coroot equals the Cartan integer `2`.

Source: É. Cartan, *Sur la structure des groupes de transformations finis
et continus* (1894), Ch. IV §3, Théorème IV; with Killing (1888-90),
*Die Zusammensetzung der stetigen endlichen Transformationsgruppen*,
Part III, as precursor. The Mathlib statement is
`LieAlgebra.IsKilling.root_apply_coroot` by Oliver Nash in
`Mathlib.Algebra.Lie.Weights.Killing`.

The classical Cartan integers that govern the root-string chains
`⟨β, α^∨⟩ = -(p - q)` are, for `β = α`, specialized to the value `2`.
-/

noncomputable section

open LieAlgebra LieModule

universe u v

namespace MathlibExpansion.Lie.Killing

variable {K : Type u} {L : Type v}
  [Field K] [CharZero K] [LieRing L] [LieAlgebra K L] [FiniteDimensional K L]
  [LieAlgebra.IsKilling K L]
  {H : LieSubalgebra K L} [H.IsCartanSubalgebra] [LieModule.IsTriangularizable K H L]

/--
For a Killing Lie algebra in characteristic zero with a triangularizable Cartan
subalgebra, every non-zero root `α` satisfies the Cartan integer identity
`⟨α, α^∨⟩ = 2`.
-/
theorem root_apply_coroot_eq_two
    {α : Weight K H L} (hα : α.IsNonZero) :
    α (LieAlgebra.IsKilling.coroot α) = 2 :=
  LieAlgebra.IsKilling.root_apply_coroot hα

/--
The coroot of a root vanishes exactly when the root itself is zero: the
Cartan-integer control kills degenerate roots.
-/
theorem coroot_eq_zero_iff_isZero (α : Weight K H L) :
    LieAlgebra.IsKilling.coroot α = 0 ↔ α.IsZero :=
  LieAlgebra.IsKilling.coroot_eq_zero_iff

end MathlibExpansion.Lie.Killing
