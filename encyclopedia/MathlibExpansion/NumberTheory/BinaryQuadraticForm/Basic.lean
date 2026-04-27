import Mathlib.Data.Int.GCD

/-!
# Integral binary quadratic forms

This is the first arithmetic substrate layer for Gauss Section V.
-/

namespace MathlibExpansion.NumberTheory

/-- An integral binary quadratic form `a x^2 + b x y + c y^2`. -/
structure BinaryQuadraticForm where
  a : ℤ
  b : ℤ
  c : ℤ

namespace BinaryQuadraticForm

/-- The arithmetic discriminant `b^2 - 4ac`. -/
def disc (f : BinaryQuadraticForm) : ℤ :=
  f.b ^ 2 - 4 * f.a * f.c

/-- Evaluation of a binary quadratic form on an integral vector. -/
def eval (f : BinaryQuadraticForm) (x y : ℤ) : ℤ :=
  f.a * x ^ 2 + f.b * x * y + f.c * y ^ 2

/-- The form `f` represents the integer `n`. -/
def Represents (f : BinaryQuadraticForm) (n : ℤ) : Prop :=
  ∃ x y : ℤ, f.eval x y = n

/-- Primitive forms are those whose coefficients have gcd `1`. -/
def IsPrimitive (f : BinaryQuadraticForm) : Prop :=
  Int.gcd f.a (Int.gcd f.b f.c) = 1

@[simp] theorem disc_mk (a b c : ℤ) : disc ⟨a, b, c⟩ = b ^ 2 - 4 * a * c := rfl

@[simp] theorem eval_mk (a b c x y : ℤ) :
    eval ⟨a, b, c⟩ x y = a * x ^ 2 + b * x * y + c * y ^ 2 := rfl

@[simp] theorem eval_zero_left (f : BinaryQuadraticForm) (y : ℤ) :
    f.eval 0 y = f.c * y ^ 2 := by
  simp [eval]

@[simp] theorem eval_zero_right (f : BinaryQuadraticForm) (x : ℤ) :
    f.eval x 0 = f.a * x ^ 2 := by
  simp [eval]

end BinaryQuadraticForm

end MathlibExpansion.NumberTheory
