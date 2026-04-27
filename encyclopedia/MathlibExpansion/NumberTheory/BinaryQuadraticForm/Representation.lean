import MathlibExpansion.NumberTheory.BinaryQuadraticForm.Equivalence

/-!
# Representation transport for binary quadratic forms

The `GL₂(ℤ)` coefficient action is defined so that representing an integer is
invariant under proper equivalence.
-/

namespace MathlibExpansion.NumberTheory

open Matrix

namespace BinaryQuadraticForm

/-- Evaluating the transformed form is the same as evaluating the original form
after the corresponding linear substitution. -/
@[simp] theorem eval_act (γ : Matrix (Fin 2) (Fin 2) ℤ) (f : BinaryQuadraticForm)
    (x y : ℤ) :
    (act γ f).eval x y =
      f.eval (γ 0 0 * x + γ 0 1 * y) (γ 1 0 * x + γ 1 1 * y) := by
  rcases f with ⟨a, b, c⟩
  let p : ℤ := γ 0 0
  let q : ℤ := γ 0 1
  let r : ℤ := γ 1 0
  let s : ℤ := γ 1 1
  simp [act, eval, p, q, r, s]
  ring

/-- The adjugate matrix. For determinant-one matrices this is the inverse in
`SL₂(ℤ)`. -/
def sl2Inv (γ : Matrix (Fin 2) (Fin 2) ℤ) : Matrix (Fin 2) (Fin 2) ℤ :=
  !![γ 1 1, -γ 0 1; -γ 1 0, γ 0 0]

@[simp] theorem det_sl2Inv (γ : Matrix (Fin 2) (Fin 2) ℤ) :
    (sl2Inv γ).det = γ.det := by
  simp [sl2Inv, Matrix.det_fin_two]
  ring

/-- Acting by the adjugate matrix undoes a determinant-one substitution. -/
theorem act_sl2Inv_act_of_det_one (γ : Matrix (Fin 2) (Fin 2) ℤ) (f : BinaryQuadraticForm)
    (hγ : γ.det = 1) :
    act (sl2Inv γ) (act γ f) = f := by
  rcases f with ⟨a, b, c⟩
  have hdet : γ 0 0 * γ 1 1 - γ 0 1 * γ 1 0 = 1 := by
    simpa [Matrix.det_fin_two] using hγ
  have hdet_sq : (γ 0 0 * γ 1 1 - γ 0 1 * γ 1 0) ^ 2 = 1 := by
    calc
      (γ 0 0 * γ 1 1 - γ 0 1 * γ 1 0) ^ 2 = (1 : ℤ) ^ 2 := by rw [hdet]
      _ = 1 := by norm_num
  simp [BinaryQuadraticForm.mk.injEq, act, sl2Inv]
  constructor
  · calc
      (a * γ 0 0 ^ 2 + b * γ 0 0 * γ 1 0 + c * γ 1 0 ^ 2) * γ 1 1 ^ 2 +
            -((2 * a * γ 0 0 * γ 0 1 + b * (γ 0 0 * γ 1 1 + γ 0 1 * γ 1 0) +
                  2 * c * γ 1 0 * γ 1 1) * γ 1 1 * γ 1 0) +
          (a * γ 0 1 ^ 2 + b * γ 0 1 * γ 1 1 + c * γ 1 1 ^ 2) * γ 1 0 ^ 2
          = a * (γ 0 0 * γ 1 1 - γ 0 1 * γ 1 0) ^ 2 := by ring
      _ = a := by rw [hdet_sq]; ring
  · constructor
    · calc
        -(2 * (a * γ 0 0 ^ 2 + b * γ 0 0 * γ 1 0 + c * γ 1 0 ^ 2) * γ 1 1 * γ 0 1) +
              (2 * a * γ 0 0 * γ 0 1 + b * (γ 0 0 * γ 1 1 + γ 0 1 * γ 1 0) +
                  2 * c * γ 1 0 * γ 1 1) *
                (γ 1 1 * γ 0 0 + γ 0 1 * γ 1 0) +
            -(2 * (a * γ 0 1 ^ 2 + b * γ 0 1 * γ 1 1 + c * γ 1 1 ^ 2) * γ 1 0 * γ 0 0)
            = b * (γ 0 0 * γ 1 1 - γ 0 1 * γ 1 0) ^ 2 := by ring
        _ = b := by rw [hdet_sq]; ring
    · calc
        (a * γ 0 0 ^ 2 + b * γ 0 0 * γ 1 0 + c * γ 1 0 ^ 2) * γ 0 1 ^ 2 +
              -((2 * a * γ 0 0 * γ 0 1 + b * (γ 0 0 * γ 1 1 + γ 0 1 * γ 1 0) +
                    2 * c * γ 1 0 * γ 1 1) * γ 0 1 * γ 0 0) +
            (a * γ 0 1 ^ 2 + b * γ 0 1 * γ 1 1 + c * γ 1 1 ^ 2) * γ 0 0 ^ 2
            = c * (γ 0 0 * γ 1 1 - γ 0 1 * γ 1 0) ^ 2 := by ring
        _ = c := by rw [hdet_sq]; ring

/-- Representation by `act γ f` yields representation by `f`. -/
theorem represents_of_act {γ : Matrix (Fin 2) (Fin 2) ℤ}
    {f : BinaryQuadraticForm} {n : ℤ} :
    (act γ f).Represents n → f.Represents n := by
  rintro ⟨x, y, hxy⟩
  refine ⟨γ 0 0 * x + γ 0 1 * y, γ 1 0 * x + γ 1 1 * y, ?_⟩
  simpa [eval_act] using hxy

/-- Proper equivalence is symmetric because determinant-one substitutions are
invertible over `ℤ`. -/
theorem ProperlyEquivalent.symm {f g : BinaryQuadraticForm}
    (hfg : f.ProperlyEquivalent g) : g.ProperlyEquivalent f := by
  rcases hfg with ⟨γ, hγ, rfl⟩
  refine ⟨sl2Inv γ, ?_, ?_⟩
  · rw [det_sl2Inv, hγ]
  · simpa using act_sl2Inv_act_of_det_one γ f hγ

/-- Properly equivalent forms represent the same integers. -/
theorem represents_of_properlyEquivalent {f g : BinaryQuadraticForm} {n : ℤ}
    (hfg : f.ProperlyEquivalent g) : g.Represents n → f.Represents n := by
  rcases hfg with ⟨γ, _, rfl⟩
  exact represents_of_act

/-- Representation is invariant under proper equivalence. -/
theorem represents_iff_of_properlyEquivalent {f g : BinaryQuadraticForm}
    (hfg : f.ProperlyEquivalent g) (n : ℤ) :
    f.Represents n ↔ g.Represents n := by
  constructor
  · exact represents_of_properlyEquivalent (ProperlyEquivalent.symm hfg)
  · exact represents_of_properlyEquivalent hfg

end BinaryQuadraticForm

end MathlibExpansion.NumberTheory
