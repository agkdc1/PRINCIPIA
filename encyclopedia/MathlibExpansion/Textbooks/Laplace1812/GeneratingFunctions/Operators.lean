import Mathlib
import MathlibExpansion.Textbooks.Laplace1812.GeneratingFunctions.Basic

/-!
# Shift operators from multiplication by a generating series

This module packages Laplace's sequence-transform view of multiplication by a
power series.
-/

namespace MathlibExpansion
namespace Textbooks
namespace Laplace1812
namespace GeneratingFunctions

/-- Multiplication by a series induces a coefficient-transform relation on sequences. -/
def ShiftOperatorRel {R : Type*} [Semiring R]
    (s : PowerSeries R) (y z : ℕ → R) : Prop :=
  ∀ n, z n = ∑ t ∈ Finset.range (n + 1), PowerSeries.coeff R t s * y (n - t)

/-- The theorem package for coefficient transforms induced by multiplication. -/
structure ShiftOperatorBridge {R : Type*} [Semiring R]
    (u s : PowerSeries R) (y z : ℕ → R) where
  source : IsGeneratingFunction u y
  target : IsGeneratingFunction (u * s) z
  relation : ShiftOperatorRel s y z

/-- Multiplication by a series induces the expected shift relation. -/
theorem coeff_mul_shift_series {R : Type*} [CommSemiring R]
    (u s : PowerSeries R) (y z : ℕ → R)
    (hy : IsGeneratingFunction u y)
    (hz : IsGeneratingFunction (u * s) z) :
    ShiftOperatorBridge u s y z := by
  refine
    { source := hy
      target := hz
      relation := ?_ }
  intro n
  calc
    z n = PowerSeries.coeff R n (u * s) := (hz n).symm
    _ = ∑ p ∈ Finset.antidiagonal n,
        PowerSeries.coeff R p.1 u * PowerSeries.coeff R p.2 s :=
      PowerSeries.coeff_mul n u s
    _ = ∑ t ∈ Finset.range (n + 1),
        PowerSeries.coeff R t s * y (n - t) := by
      rw [Finset.Nat.antidiagonal_eq_map']
      simp only [Finset.sum_map, Function.Embedding.coeFn_mk]
      refine Finset.sum_congr rfl ?_
      intro t ht
      rw [hy (n - t), mul_comm]

end GeneratingFunctions
end Laplace1812
end Textbooks
end MathlibExpansion
