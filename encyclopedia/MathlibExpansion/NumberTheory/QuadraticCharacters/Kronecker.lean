import Mathlib.Data.Complex.Basic
import Mathlib.NumberTheory.DirichletCharacter.Basic
import Mathlib.NumberTheory.LegendreSymbol.JacobiSymbol

/-!
# Discriminant-indexed quadratic characters

This file fixes the typed boundary used by the Dirichlet class-number rewrite.
The actual Kronecker-character construction is honest upstream architecture
work, so the discriminant-indexed character is selected from an explicit
odd-denominator existence boundary. What remains local here is the conductor
shell and the textbook-facing reciprocity API derived from the Jacobi-symbol
value law over odd positive denominators.
-/

open scoped NumberTheorySymbols

namespace MathlibExpansion.NumberTheory

/-- A concrete conductor shell for the discriminant-indexed quadratic character
package. The `4 * |D|` modulus is the standard Jacobi-period shell in the
denominator variable; the outer `max` makes the degenerate `D = 0` case
manifestly nonzero. -/
def quadraticConductor (D : ℤ) : ℕ :=
  max (4 * D.natAbs) 1

theorem quadraticConductor_pos (D : ℤ) : 0 < quadraticConductor D := by
  simp [quadraticConductor]

theorem quadraticConductor_ne_zero (D : ℤ) : quadraticConductor D ≠ 0 :=
  (quadraticConductor_pos D).ne'

instance instNeZeroQuadraticConductor (D : ℤ) : NeZero (quadraticConductor D) :=
  ⟨quadraticConductor_ne_zero D⟩

/-- Upstream-narrow boundary for the odd-denominator Jacobi-symbol Dirichlet
character package attached to a nonzero discriminant parameter.

Classical reference target: Montgomery--Vaughan, *Multiplicative Number Theory I:
Classical Theory* (2007), Theorem 9.13, classifying primitive quadratic
characters as Kronecker-symbol characters of quadratic discriminants. The
present boundary records only the odd positive denominator shadow needed by
this file; it deliberately makes no assertion at even `n` or at `n = 0`, where
the previous all-`n` boundary was incompatible with Mathlib's Dirichlet-character
zero-on-nonunits API and `jacobiSym.zero_right`. -/
axiom exists_quadraticCharacterOfDiscr_odd (D : ℤ) (hD : D ≠ 0) :
    ∃ χ : DirichletCharacter ℂ (quadraticConductor D),
      ∀ n : ℕ, n % 2 = 1 → χ n = (J(D | n) : ℂ)

noncomputable def quadraticCharacterOfDiscr (D : ℤ) :
    DirichletCharacter ℂ (quadraticConductor D) := by
  classical
  by_cases hD : D = 0
  · exact 1
  · exact Classical.choose (exists_quadraticCharacterOfDiscr_odd D hD)

/-- Odd-denominator value law tying the selected character to the Jacobi-symbol
package already available in Mathlib. -/
theorem quadraticCharacterOfDiscr_apply_nat (D : ℤ) (n : ℕ) (hD : D ≠ 0)
    (hn : n % 2 = 1) :
    quadraticCharacterOfDiscr D n = (J(D | n) : ℂ) := by
  classical
  simp [quadraticCharacterOfDiscr, hD,
    Classical.choose_spec (exists_quadraticCharacterOfDiscr_odd D hD), hn]

@[simp] theorem quadraticCharacterOfDiscr_apply_one (D : ℤ) :
    quadraticCharacterOfDiscr D 1 = 1 := by
  by_cases hD : D = 0
  · subst hD
    simp [quadraticCharacterOfDiscr]
  · have h := quadraticCharacterOfDiscr_apply_nat D 1 hD rfl
    simp only [jacobiSym.one_right, Int.cast_one, Nat.cast_one] at h
    exact h

theorem quadraticCharacterOfDiscr_apply_prime (D : ℤ) (p : ℕ) [Fact p.Prime]
    (hD : D ≠ 0) (hp : p ≠ 2) :
    quadraticCharacterOfDiscr D p = (legendreSym p D : ℂ) := by
  have hpodd : p % 2 = 1 :=
    Nat.odd_iff.mp ((Fact.out : p.Prime).eq_two_or_odd'.resolve_left hp)
  rw [quadraticCharacterOfDiscr_apply_nat D p hD hpodd,
    ← jacobiSym.legendreSym.to_jacobiSym]

/-- A textbook-facing reciprocity statement in character language, derived from
the Jacobi-symbol reciprocity theorem. -/
theorem quadraticCharacterOfDiscr_quadraticReciprocity {a b : ℕ}
    (ha : a % 2 = 1) (hb : b % 2 = 1) :
    (if a % 4 = 3 ∧ b % 4 = 3 then -quadraticCharacterOfDiscr (b : ℤ) a
      else quadraticCharacterOfDiscr (b : ℤ) a) =
        quadraticCharacterOfDiscr (a : ℤ) b := by
  have ha0 : a ≠ 0 := by
    rintro rfl
    simp at ha
  have hb0 : b ≠ 0 := by
    rintro rfl
    simp at hb
  have haD : (a : ℤ) ≠ 0 := by exact_mod_cast ha0
  have hbD : (b : ℤ) ≠ 0 := by exact_mod_cast hb0
  rw [quadraticCharacterOfDiscr_apply_nat (b : ℤ) a hbD ha,
    quadraticCharacterOfDiscr_apply_nat (a : ℤ) b haD hb]
  exact_mod_cast jacobiSym.quadratic_reciprocity_if ha hb

end MathlibExpansion.NumberTheory
