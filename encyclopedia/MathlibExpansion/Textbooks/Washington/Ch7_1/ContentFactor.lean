import MathlibExpansion.Textbooks.Washington.Ch7_1.SeriesSplit
import MathlibExpansion.Roots.Iwasawa.Elementary
import Mathlib.NumberTheory.Padics.PadicIntegers
import Mathlib.RingTheory.LocalRing.Basic
import Mathlib.RingTheory.PowerSeries.Order

/-!
# Washington Ch. 7.1: extracting the `p`-content

For a nonzero `f ∈ ℤ_p[[T]]`, this file extracts the largest pure `p`-power
factor from all coefficients.
-/

noncomputable section

open PowerSeries
open scoped Padic

namespace MathlibExpansion
namespace Textbooks
namespace Washington
namespace Ch7_1

section

variable (p : ℕ) [Fact p.Prime]

/-- Coefficientwise division by `p^μ`, using the `unitCoeff` decomposition of
`ℤ_[p]`.  When the coefficient is `0`, the quotient is defined to be `0`. -/
def divideCoeffByPrimePow (μ : ℕ) (a : ℤ_[p]) : ℤ_[p] :=
  by
    classical
    exact if ha : a = 0 then 0
      else (PadicInt.unitCoeff (p := p) ha : ℤ_[p]) * (p : ℤ_[p]) ^ (a.valuation - μ)

@[simp] theorem divideCoeffByPrimePow_zero (μ : ℕ) :
    divideCoeffByPrimePow p μ 0 = 0 := by
  simp [divideCoeffByPrimePow]

theorem primePow_mul_divideCoeffByPrimePow_eq (μ : ℕ) (a : ℤ_[p])
    (ha : a = 0 ∨ μ ≤ a.valuation) :
    (p : ℤ_[p]) ^ μ * divideCoeffByPrimePow p μ a = a := by
  rcases ha with rfl | hμ
  · simp [divideCoeffByPrimePow]
  · by_cases hzero : a = 0
    · simp [divideCoeffByPrimePow, hzero]
    · calc
        (p : ℤ_[p]) ^ μ * divideCoeffByPrimePow p μ a
            = (p : ℤ_[p]) ^ μ *
                ((PadicInt.unitCoeff (p := p) hzero : ℤ_[p]) *
                  (p : ℤ_[p]) ^ (a.valuation - μ)) := by
                simp [divideCoeffByPrimePow, hzero]
        _ = (PadicInt.unitCoeff (p := p) hzero : ℤ_[p]) *
              ((p : ℤ_[p]) ^ μ * (p : ℤ_[p]) ^ (a.valuation - μ)) := by
              ring
        _ = (PadicInt.unitCoeff (p := p) hzero : ℤ_[p]) *
              (p : ℤ_[p]) ^ (μ + (a.valuation - μ)) := by
              rw [← pow_add]
        _ = (PadicInt.unitCoeff (p := p) hzero : ℤ_[p]) * (p : ℤ_[p]) ^ a.valuation := by
              rw [Nat.add_sub_cancel' hμ]
        _ = a := by
              simpa [mul_comm, mul_left_comm, mul_assoc] using
                (PadicInt.unitCoeff_spec (p := p) hzero).symm

theorem divideCoeffByPrimePow_isUnit (μ : ℕ) {a : ℤ_[p]} (ha : a ≠ 0)
    (hμ : a.valuation = μ) :
    IsUnit (divideCoeffByPrimePow p μ a) := by
  simpa [divideCoeffByPrimePow, ha, hμ] using
    Units.isUnit (PadicInt.unitCoeff (p := p) ha)

theorem divideCoeffByPrimePow_mem_maximalIdeal (μ : ℕ) {a : ℤ_[p]}
    (ha : a = 0 ∨ μ < a.valuation) :
    divideCoeffByPrimePow p μ a ∈ IsLocalRing.maximalIdeal ℤ_[p] := by
  rcases ha with rfl | hμ
  · simp [divideCoeffByPrimePow]
  · have hne : a ≠ 0 := by
      intro hzero
      simp [hzero] at hμ
    rw [PadicInt.maximalIdeal_eq_span_p]
    rw [Ideal.mem_span_singleton]
    obtain ⟨k, hk⟩ := Nat.exists_eq_add_of_lt hμ
    refine ⟨(PadicInt.unitCoeff (p := p) hne : ℤ_[p]) * (p : ℤ_[p]) ^ k, ?_⟩
    simp [divideCoeffByPrimePow, hne, hk]
    rw [add_assoc, Nat.add_sub_cancel_left, pow_succ']
    ring

/-- The coefficientwise quotient power series after dividing by `p^μ`. -/
def divideByPrimePow (μ : ℕ) (f : PowerSeries ℤ_[p]) : PowerSeries ℤ_[p] :=
  PowerSeries.mk fun n => divideCoeffByPrimePow p μ (PowerSeries.coeff ℤ_[p] n f)

@[simp] theorem coeff_divideByPrimePow (μ n : ℕ) (f : PowerSeries ℤ_[p]) :
    PowerSeries.coeff ℤ_[p] n (divideByPrimePow p μ f) =
      divideCoeffByPrimePow p μ (PowerSeries.coeff ℤ_[p] n f) := by
  simp [divideByPrimePow]

theorem primeInLambda_pow_eq_C_pow (μ : ℕ) :
    MathlibExpansion.Roots.Iwasawa.primeInLambda p ^ μ =
      PowerSeries.C ℤ_[p] ((p : ℤ_[p]) ^ μ) := by
  simp [MathlibExpansion.Roots.Iwasawa.primeInLambda]

theorem primeInLambda_pow_dvd_iff_coeff_dvd (μ : ℕ) (f : PowerSeries ℤ_[p]) :
    MathlibExpansion.Roots.Iwasawa.primeInLambda p ^ μ ∣ f ↔
      ∀ n, (p : ℤ_[p]) ^ μ ∣ PowerSeries.coeff ℤ_[p] n f := by
  constructor
  · rintro ⟨g, rfl⟩ n
    rw [primeInLambda_pow_eq_C_pow]
    exact ⟨PowerSeries.coeff ℤ_[p] n g, PowerSeries.coeff_C_mul n g _⟩
  · intro h
    refine ⟨PowerSeries.mk (fun n => Classical.choose (h n)), ?_⟩
    ext n
    rw [primeInLambda_pow_eq_C_pow, PowerSeries.coeff_C_mul]
    simpa using (Classical.choose_spec (h n))

theorem primeInLambda_pow_mul_divideByPrimePow_eq (μ : ℕ) (f : PowerSeries ℤ_[p])
    (hμ : ∀ n, PowerSeries.coeff ℤ_[p] n f = 0 ∨
      μ ≤ (PowerSeries.coeff ℤ_[p] n f).valuation) :
    MathlibExpansion.Roots.Iwasawa.primeInLambda p ^ μ * divideByPrimePow p μ f = f := by
  ext n
  rw [primeInLambda_pow_eq_C_pow, PowerSeries.coeff_C_mul, coeff_divideByPrimePow]
  exact primePow_mul_divideCoeffByPrimePow_eq p μ _ (hμ n)

theorem exists_contentFactor (f : PowerSeries ℤ_[p]) (hf : f ≠ 0) :
    ∃ μ n g, f = MathlibExpansion.Roots.Iwasawa.primeInLambda p ^ μ * g ∧
      IsUnit (PowerSeries.coeff ℤ_[p] n g) ∧
      ∀ m < n, PowerSeries.coeff ℤ_[p] m g ∈ IsLocalRing.maximalIdeal ℤ_[p] := by
  let valuationSet : Set ℕ :=
    {v | ∃ n, PowerSeries.coeff ℤ_[p] n f ≠ 0 ∧
      (PowerSeries.coeff ℤ_[p] n f).valuation = v}
  have hval_nonempty : valuationSet.Nonempty := by
    rcases PowerSeries.exists_coeff_ne_zero_iff_ne_zero.mpr hf with ⟨n, hn⟩
    exact ⟨(PowerSeries.coeff ℤ_[p] n f).valuation, n, hn, rfl⟩
  let μ := sInf valuationSet
  have hμ_mem : μ ∈ valuationSet := Nat.sInf_mem hval_nonempty
  obtain ⟨n₀, hn₀_ne, hn₀_val⟩ := hμ_mem
  let firstIndex : Set ℕ :=
    {n | PowerSeries.coeff ℤ_[p] n f ≠ 0 ∧ (PowerSeries.coeff ℤ_[p] n f).valuation = μ}
  have hfirst_nonempty : firstIndex.Nonempty := ⟨n₀, hn₀_ne, hn₀_val⟩
  let n := sInf firstIndex
  have hn_mem : n ∈ firstIndex := Nat.sInf_mem hfirst_nonempty
  have hn_ne : PowerSeries.coeff ℤ_[p] n f ≠ 0 := hn_mem.1
  have hn_val : (PowerSeries.coeff ℤ_[p] n f).valuation = μ := hn_mem.2
  let g := divideByPrimePow p μ f
  have hμ_le : ∀ m, PowerSeries.coeff ℤ_[p] m f ≠ 0 →
      μ ≤ (PowerSeries.coeff ℤ_[p] m f).valuation := by
    intro m hm
    exact Nat.sInf_le ⟨m, hm, rfl⟩
  have hfactor : MathlibExpansion.Roots.Iwasawa.primeInLambda p ^ μ * g = f := by
    apply primeInLambda_pow_mul_divideByPrimePow_eq p μ f
    intro m
    by_cases hm : PowerSeries.coeff ℤ_[p] m f = 0
    · exact Or.inl hm
    · exact Or.inr (hμ_le m hm)
  refine ⟨μ, n, g, hfactor.symm, ?_, ?_⟩
  · simpa [g, hn_val] using divideCoeffByPrimePow_isUnit p μ hn_ne hn_val
  · intro m hm
    by_cases hzero : PowerSeries.coeff ℤ_[p] m f = 0
    · simp [g, coeff_divideByPrimePow, divideCoeffByPrimePow, hzero]
    · have hμm : μ ≤ (PowerSeries.coeff ℤ_[p] m f).valuation := hμ_le m hzero
      have hneq : (PowerSeries.coeff ℤ_[p] m f).valuation ≠ μ := by
        intro hEq
        have hm_mem : m ∈ firstIndex := ⟨hzero, hEq⟩
        exact Nat.not_mem_of_lt_sInf hm hm_mem
      have hlt : μ < (PowerSeries.coeff ℤ_[p] m f).valuation := lt_of_le_of_ne hμm hneq.symm
      simpa [g, coeff_divideByPrimePow] using
        divideCoeffByPrimePow_mem_maximalIdeal p μ (a := PowerSeries.coeff ℤ_[p] m f) (Or.inr hlt)

end

end Ch7_1
end Washington
end Textbooks
end MathlibExpansion
