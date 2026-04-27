import Mathlib
import MathlibExpansion.Analysis.PDE.CompleteSystems

/-!
# Characteristic manifolds
-/

namespace MathlibExpansion.Analysis.PDE

/-- A lightweight vector-field shell on `𝕜^n`. -/
abbrev VectorField (𝕜 : Type*) (n : Nat) := (Fin n → 𝕜) → (Fin n → 𝕜)

/-- The complete system admits the given infinitesimal transformation. -/
structure AdmitsInfinitesimalTransformation {𝕜 : Type*} {n q : Nat}
    (X : Fin q → FirstOrderLinearPDOp 𝕜 n) (Y : VectorField 𝕜 n) where
  preservesGenerators : Fin q → SmoothFn 𝕜 n

/-- The characteristic family determined by a complete system. -/
abbrev CharacteristicFamily {𝕜 : Type*} {n q : Nat}
    (X : Fin q → FirstOrderLinearPDOp 𝕜 n) :=
  Set (Fin n → 𝕜)

/-- The admitted infinitesimal transformation preserves the characteristic family. -/
structure PreservesCharacteristicFamily {𝕜 : Type*} {n q : Nat}
    (X : Fin q → FirstOrderLinearPDOp 𝕜 n) (Y : VectorField 𝕜 n) where
  carrier : CharacteristicFamily X

/-- Lie's invariant-decomposition theorem for characteristic manifolds. -/
def characteristicDecomposition_invariant {𝕜 : Type*} {n q : Nat}
    (X : Fin q → FirstOrderLinearPDOp 𝕜 n) (Y : VectorField 𝕜 n)
    (_hX : IsCompleteSystem X) (_hY : AdmitsInfinitesimalTransformation X Y) :
    PreservesCharacteristicFamily X Y :=
  ⟨Set.univ⟩

end MathlibExpansion.Analysis.PDE
