import MathlibExpansion.NumberTheory.BinaryQuadraticForm.Equiv

/-!
# Negative-discriminant reduction boundary

This file fixes the honest theorem boundary for Gauss's negative-discriminant
reduction theory.  The reduction existence theorem itself is still upstream-
narrow architecture work, so it is recorded as an axiom rather than hidden
behind placeholders.
-/

namespace MathlibExpansion.NumberTheory

namespace BinaryQuadraticForm

/-- Standard reducedness predicate for positive-definite integral binary
quadratic forms.  The sign convention is classical: `|b| ≤ a ≤ c`, with the
usual tie-break when equality occurs. -/
def IsReducedNeg (f : BinaryQuadraticForm) : Prop :=
  f.disc < 0 ∧
    0 < f.a ∧
    Int.natAbs f.b ≤ Int.natAbs f.a ∧
    Int.natAbs f.a ≤ Int.natAbs f.c ∧
    (Int.natAbs f.b = Int.natAbs f.a ∨ Int.natAbs f.a = Int.natAbs f.c → 0 ≤ f.b)

theorem disc_neg_of_isReducedNeg {f : BinaryQuadraticForm} (hf : f.IsReducedNeg) :
    f.disc < 0 :=
  hf.1

/-- Proper equivalence is reflexive. -/
theorem properlyEquivalent_refl (f : BinaryQuadraticForm) : f.ProperlyEquivalent f := by
  refine ⟨1, ?_, ?_⟩
  · simp
  · rcases f with ⟨a, b, c⟩
    simp [act]

/-- A form that is already reduced is its own reduced representative. -/
theorem exists_reduced_of_isReducedNeg {f : BinaryQuadraticForm} (hf : f.IsReducedNeg) :
    ∃ g : BinaryQuadraticForm, g.IsReducedNeg ∧ f.ProperlyEquivalent g :=
  ⟨f, hf, f.properlyEquivalent_refl⟩

/-- The old no-positivity boundary is false for the present `IsReducedNeg`
convention: the negative-definite form `-x^2 - y^2` has negative discriminant
but cannot be properly equivalent to a form with `0 < a`.

This is the sign correction behind the sharpened Gauss/Dirichlet reduction
boundary below. -/
theorem not_exists_reduced_neg_sumSquares :
    ¬ ∃ g : BinaryQuadraticForm,
      g.IsReducedNeg ∧ (⟨-1, 0, -1⟩ : BinaryQuadraticForm).ProperlyEquivalent g := by
  rintro ⟨g, hg, γ, _hγ, hact⟩
  rw [← hact] at hg
  have hpos : 0 < (act γ (⟨-1, 0, -1⟩ : BinaryQuadraticForm)).a := hg.2.1
  simp [act] at hpos
  exact (not_lt_of_ge
    (le_trans (neg_nonpos.mpr (sq_nonneg (γ 0 0))) (sq_nonneg (γ 1 0)))) hpos

/-- Upstream-narrow boundary for the positive-definite negative-discriminant
reduction theorem: every positive-definite proper class has a reduced
representative.

Citation: Carl Friedrich Gauss, *Disquisitiones Arithmeticae* (1801), Section V,
Articles 171-181; P. G. Lejeune Dirichlet, *Vorlesungen ueber Zahlentheorie*
(1863), Vierter Abschnitt, Articles 163-164, pp. 164-167. These are the
classical negative-determinant reduction articles; the Lean boundary records the
needed positive-definite sign hypothesis as `0 < f.a`. -/
axiom exists_reduced_of_disc_neg_of_pos_a
    (f : BinaryQuadraticForm) (hD : f.disc < 0) (ha : 0 < f.a) :
    ∃ g : BinaryQuadraticForm, g.IsReducedNeg ∧ f.ProperlyEquivalent g

/-- Gauss/Dirichlet negative-discriminant reduction with the necessary
positive-definite sign hypothesis. -/
theorem exists_reduced_of_disc_neg
    (f : BinaryQuadraticForm) (hD : f.disc < 0) (ha : 0 < f.a) :
    ∃ g : BinaryQuadraticForm, g.IsReducedNeg ∧ f.ProperlyEquivalent g :=
  exists_reduced_of_disc_neg_of_pos_a f hD ha

end BinaryQuadraticForm

end MathlibExpansion.NumberTheory
