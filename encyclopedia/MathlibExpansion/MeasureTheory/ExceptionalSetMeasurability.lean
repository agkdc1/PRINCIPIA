import Mathlib.MeasureTheory.Constructions.BorelSpace.Basic
import Mathlib.MeasureTheory.Integral.IntegrableOn
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
import Mathlib.MeasureTheory.Measure.AEMeasurable
import Mathlib.MeasureTheory.Measure.NullMeasurable

noncomputable section

open MeasureTheory

namespace MathlibExpansion
namespace MeasureTheory

/--
Lebesgue 1904, *Lecons sur l'integration et la recherche des fonctions
primitives*, Chapter VII, Section III, pp. 111-112, unnumbered
continuity-off-null criterion, in its modern completed-measure reading:
a function continuous outside a null set is a.e. Borel measurable.
-/
theorem aemeasurable_of_continuousOn_compl_null {f : ℝ → ℝ} {N : Set ℝ}
    (hN : volume N = 0) (hcont : ContinuousOn f Nᶜ) :
    AEMeasurable f (volume : Measure ℝ) := by
  let μ : Measure ℝ := volume
  have hNcompl : NullMeasurableSet Nᶜ μ := (NullMeasurableSet.of_null hN).compl
  rcases hNcompl.exists_measurable_subset_ae_eq with ⟨M, hM_sub, hM_meas, hM_ae⟩
  have hNcompl_ae_univ : Nᶜ =ᵐ[μ] (Set.univ : Set ℝ) := by
    rw [ae_eq_univ]
    simpa [μ] using hN
  have hM_ae_univ : M =ᵐ[μ] (Set.univ : Set ℝ) := hM_ae.trans hNcompl_ae_univ
  have hM_mem : ∀ᵐ x ∂μ, x ∈ M := by
    change M ∈ ae μ
    rw [mem_ae_iff]
    rwa [ae_eq_univ] at hM_ae_univ
  have hf_restrict : AEMeasurable f (μ.restrict M) :=
    (hcont.mono hM_sub).aemeasurable hM_meas
  rwa [Measure.restrict_eq_self_of_ae_mem hM_mem] at hf_restrict

/-- The honest completion-side carrier for Lebesgue's continuity-off-null argument. -/
theorem nullMeasurable_of_continuousOn_compl_null {f : ℝ → ℝ} {N : Set ℝ}
    (hN : volume N = 0) (hcont : ContinuousOn f Nᶜ) :
    NullMeasurable f (volume : Measure ℝ) :=
  (aemeasurable_of_continuousOn_compl_null hN hcont).nullMeasurable

/--
Lebesgue 1904, *Lecons sur l'integration et la recherche des fonctions
primitives*, Chapter VII, Section III, pp. 111-112, unnumbered
continuity-off-null criterion. This is the Borel-safe form: to conclude
modern `Measurable`, the restriction to the exceptional set must also be
measurable. Without such a hypothesis, arbitrary changes on an arbitrary
null set only imply `AEMeasurable`/`NullMeasurable`.
-/
theorem measurable_of_continuousOn_compl_of_measurable_restrict {f : ℝ → ℝ} {N : Set ℝ}
    (hN : MeasurableSet N) (hN_meas : Measurable (N.restrict f))
    (hcont : ContinuousOn f Nᶜ) : Measurable f := by
  have hcompl_meas : Measurable (Nᶜ.restrict f) :=
    (continuousOn_iff_continuous_restrict.mp hcont).measurable
  exact measurable_of_restrict_of_restrict_compl hN hN_meas hcompl_meas

theorem measurable_of_continuousOn_compl_null {f : ℝ → ℝ} {N : Set ℝ}
    (_hN_null : volume N = 0) (hN : MeasurableSet N)
    (hN_meas : Measurable (N.restrict f)) (hcont : ContinuousOn f Nᶜ) : Measurable f :=
  measurable_of_continuousOn_compl_of_measurable_restrict hN hN_meas hcont

/--
Countable-exception Borel corollary of the same Lebesgue 1904 Chapter VII,
Section III criterion: arbitrary values on a countable exceptional set are
Borel-measurable on that set.
-/
theorem measurable_of_continuousOn_compl_countable {f : ℝ → ℝ} {N : Set ℝ}
    (hN : N.Countable) (hcont : ContinuousOn f Nᶜ) : Measurable f := by
  haveI : Countable N := hN.to_subtype
  exact measurable_of_continuousOn_compl_of_measurable_restrict hN.measurableSet
    (measurable_of_countable (N.restrict f)) hcont

end MeasureTheory
end MathlibExpansion
