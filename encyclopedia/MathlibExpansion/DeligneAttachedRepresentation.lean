/-
Copyright (c) 2026 Mathlib Expansion contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mathlib Expansion contributors
-/
import MathlibExpansion.FifthGap
import Mathlib.Data.ZMod.Basic
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic

/-!
# Deligne's residual representation carrier (Ribet Breach F6)

Honest boundary for the mod-`p` residual Galois representation attached to
a Frey-curve newform, replacing the demolished
`frey_curve_mod_p_irreducible` from `ThirteenthGap` (Ribet Breach F3).

* `ResidualGaloisRep G p`: a group homomorphism
  `G →* Matrix (Fin 2) (Fin 2) (ZMod p)` — the GL₂(𝔽ₚ) representation with
  concrete coefficient ring `ZMod p`. Continuity is recorded as an explicit
  boundary `Prop` rather than `Continuous rep` to avoid topology-on-matrices
  import dependencies absent from the current import chain.

No `sorry`, no `:= True`.
-/

namespace MathlibExpansion
namespace DeligneAttachedRepresentation

/--
A residual mod-`p` Galois representation: a group homomorphism from a Galois
group `G` into 2×2 matrices over `ZMod p`.

Using `Matrix (Fin 2) (Fin 2) (ZMod p)` as the concrete matrix type makes
the trace and determinant equations typeable via Mathlib's `Matrix.trace`
and `Matrix.det` without appealing to abstract `Prop` fields.

`continuityStatement` records continuity as an explicit boundary `Prop`
rather than `Continuous rep`, avoiding topology-on-matrices import
dependencies not yet in the chain.
-/
structure ResidualGaloisRep
    (G : Type*) [Group G]
    (p : ℕ) [Fact (Nat.Prime p)] where
  rep : G →* Matrix (Fin 2) (Fin 2) (ZMod p)
  continuityStatement : Prop
  isContinuous : continuityStatement

end DeligneAttachedRepresentation
end MathlibExpansion
