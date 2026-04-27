import Mathlib.MeasureTheory.Integral.FundThmCalculus

noncomputable section

open MeasureTheory

namespace MathlibExpansion
namespace MeasureTheory
namespace Integral

/--
`FTLI_02`: the indefinite integral of an interval-integrable function
differentiates back to the integrand almost everywhere on the interval.

Citation: Henri Lebesgue, *Lecons sur l'integration et la recherche des
fonctions primitives* (1904), Chapter VII, Section VI, unnumbered terminal
theorem on pp. 124-125: a summable function's indefinite integral has the
function as derivative outside a null set.
-/
axiom ae_hasDerivAt_intervalIntegral_of_intervalIntegrable {f : ℝ → ℝ} {a b : ℝ}
    (hf : IntervalIntegrable f volume a b) :
    ∀ᵐ x ∂volume.restrict (Set.Ioo (min a b) (max a b)),
      HasDerivAt (fun y => ∫ t in a..y, f t) (f x) x

/--
`FTLI_01`: indicator-set atomic case of the indefinite-Lebesgue-integral FTC.

Citation: Henri Lebesgue, *Lecons sur l'integration et la recherche des
fonctions primitives* (1904), Chapter VII, Section VI, pp. 123-124, indicator
case preceding the terminal theorem.
-/
theorem ae_hasDerivAt_intervalIntegral_indicator {s : Set ℝ} {a b : ℝ}
    (hs : MeasurableSet s) (hsub : s ⊆ Set.Icc a b) :
    ∀ᵐ x ∂volume.restrict (Set.Ioo a b),
      HasDerivAt (fun y => ∫ t in a..y, Set.indicator s (fun _ => (1 : ℝ)) t)
        (Set.indicator s (fun _ => (1 : ℝ)) x) x := by
  by_cases hab : a < b
  · have hfinite : volume s < ⊤ :=
      lt_of_le_of_lt (measure_mono hsub) measure_Icc_lt_top
    have hconst : IntegrableOn (fun _ : ℝ => (1 : ℝ)) s volume :=
      integrableOn_const.2 (Or.inr hfinite)
    have hindicator :
        IntervalIntegrable (Set.indicator s (fun _ => (1 : ℝ))) volume a b :=
      ((integrable_indicator_iff hs).2 hconst).intervalIntegrable
    simpa [min_eq_left hab.le, max_eq_right hab.le] using
      ae_hasDerivAt_intervalIntegral_of_intervalIntegrable
        (f := Set.indicator s (fun _ => (1 : ℝ))) (a := a) (b := b) hindicator
  · have hba : b ≤ a := le_of_not_gt hab
    simp [Set.Ioo_eq_empty_of_le hba]

end Integral
end MeasureTheory
end MathlibExpansion
