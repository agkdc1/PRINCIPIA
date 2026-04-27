import Mathlib.Data.Complex.Basic
import Mathlib.NumberTheory.DirichletCharacter.Basic

/-!
# Explicit parameter data for Dirichlet characters

The classical textbook language packages a character by its values on residue
classes prime to the modulus. In Mathlib that datum is exactly a homomorphism on
the unit group `(ZMod q)ˣ`, and `MulChar.ofUnitHom` recovers the modern
`DirichletCharacter`.
-/

namespace MathlibExpansion.NumberTheory

open MulChar

/-- Explicit finite data for a Dirichlet character of modulus `q`: its values on
the unit group of `ℤ/qℤ`. -/
structure IndexData (q : ℕ) where
  toUnitHom : (ZMod q)ˣ →* Units ℂ

/-- Recover a Dirichlet character from its explicit unit-group data. -/
noncomputable def dirichletCharacterOfIndexData {q : ℕ} (data : IndexData q) :
    DirichletCharacter ℂ q :=
  MulChar.ofUnitHom data.toUnitHom

@[simp] theorem dirichletCharacterOfIndexData_toUnitHom {q : ℕ} (data : IndexData q) :
    (dirichletCharacterOfIndexData data).toUnitHom = data.toUnitHom := by
  ext u
  simp [dirichletCharacterOfIndexData]

theorem dirichletCharacterOfIndexData_injective (q : ℕ) :
    Function.Injective (dirichletCharacterOfIndexData (q := q)) := by
  intro data₁ data₂ h
  cases data₁ with
  | mk f₁ =>
    cases data₂ with
    | mk f₂ =>
      have h' : f₁ = f₂ := by
        ext u
        simpa [dirichletCharacterOfIndexData] using congrArg (fun χ => (χ u : ℂ)) h
      cases h'
      rfl

theorem exists_indexData_of_dirichletCharacter {q : ℕ} (χ : DirichletCharacter ℂ q) [NeZero q] :
    ∃ data : IndexData q, dirichletCharacterOfIndexData data = χ := by
  refine ⟨⟨χ.toUnitHom⟩, ?_⟩
  ext u
  simp [dirichletCharacterOfIndexData]

end MathlibExpansion.NumberTheory
