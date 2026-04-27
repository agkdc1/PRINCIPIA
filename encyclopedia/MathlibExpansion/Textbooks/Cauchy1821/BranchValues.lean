import Mathlib

/-!
# Branch-neutral square-root packaging

This module records a textbook-facing real square-root wrapper used in Cauchy's
1821 treatment of multivalued radicals.
-/

namespace MathlibExpansion
namespace Textbooks
namespace Cauchy1821

/-- A real square root of a nonnegative real number is exactly one of the two
possible signs of the principal square root. -/
theorem sq_eq_iff_eq_or_eq_neg_sqrt {a x : ℝ} (ha : 0 ≤ a) :
    x ^ 2 = a ↔ x = Real.sqrt a ∨ x = -Real.sqrt a := by
  constructor
  · intro hx
    have hx' : x ^ 2 = (Real.sqrt a) ^ 2 := by
      simpa [Real.sq_sqrt ha] using hx
    simpa [pow_two] using (sq_eq_sq_iff_eq_or_eq_neg.mp hx')
  · rintro (rfl | rfl)
    · exact Real.sq_sqrt ha
    · calc
        (-Real.sqrt a) ^ 2 = (Real.sqrt a) ^ 2 := by ring
        _ = a := Real.sq_sqrt ha

end Cauchy1821
end Textbooks
end MathlibExpansion
