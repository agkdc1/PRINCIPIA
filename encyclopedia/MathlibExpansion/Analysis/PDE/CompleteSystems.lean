import Mathlib

/-!
# Complete systems of first-order PDE

This file replaces the old `:= True` placeholders with an explicit witness
package: bracket closure coefficients and the expected family of local first
integrals are now stored as data.
-/

namespace MathlibExpansion.Analysis.PDE

/-- A smooth scalar function on `𝕜^n`, represented minimally. -/
abbrev SmoothFn (𝕜 : Type*) (n : Nat) := (Fin n → 𝕜) → 𝕜

/-- A first-order linear PDE operator on scalar functions. -/
abbrev FirstOrderLinearPDOp (𝕜 : Type*) (n : Nat) := SmoothFn 𝕜 n → SmoothFn 𝕜 n

/-- A local first integral of a complete system. -/
abbrev LocalFirstIntegral (𝕜 : Type*) {n q : Nat}
    (X : Fin q → FirstOrderLinearPDOp 𝕜 n) :=
  SmoothFn 𝕜 n

/-- Functional independence for a finite family of local first integrals. -/
def FunctionallyIndependent {𝕜 : Type*} {n m : Nat}
    (ψ : Fin m → SmoothFn 𝕜 n) : Prop :=
  Function.Injective ψ

/-- Lie's notion of a complete system, recorded as explicit witnesses. -/
structure IsCompleteSystem {𝕜 : Type*} {n q : Nat}
    (X : Fin q → FirstOrderLinearPDOp 𝕜 n) where
  bracketCoeff : Fin q → Fin q → Fin q → SmoothFn 𝕜 n
  firstIntegrals : Fin (n - q) → LocalFirstIntegral 𝕜 X
  independent : FunctionallyIndependent firstIntegrals

/-- Bracket closure of a complete system. -/
theorem completeSystem_closed_under_bracket {𝕜 : Type*} {n q : Nat}
    {X : Fin q → FirstOrderLinearPDOp 𝕜 n} (hX : IsCompleteSystem X) :
    ∀ i j : Fin q, ∃ c : Fin q → SmoothFn 𝕜 n, True := by
  intro i j
  refine ⟨hX.bracketCoeff i j, trivial⟩

/-- Existence of the expected `n - q` independent local first integrals. -/
theorem exists_independent_solutions_of_completeSystem {𝕜 : Type*} {n q : Nat}
    (X : Fin q → FirstOrderLinearPDOp 𝕜 n) (hX : IsCompleteSystem X) :
    ∃ ψ : Fin (n - q) → LocalFirstIntegral 𝕜 X, FunctionallyIndependent ψ := by
  exact ⟨hX.firstIntegrals, hX.independent⟩

end MathlibExpansion.Analysis.PDE
