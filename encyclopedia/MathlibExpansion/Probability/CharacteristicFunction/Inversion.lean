import MathlibExpansion.Probability.CharacteristicFunction.Basic
import MathlibExpansion.Probability.CharacteristicFunction.LevyContinuity

/-!
# Fourier-Stieltjes inversion for characteristic functions

This file packages the interval-recovery and uniqueness surfaces for real
probability laws.  The theorem statements below are upstream-narrow boundaries
for Levy's Fourier-Stieltjes inversion corridor; the analytic Dirichlet-kernel
substrate is not yet available in Mathlib.
-/

namespace MathlibExpansion
namespace Probability
namespace CharacteristicFunction

open MeasureTheory Filter
open scoped Topology

/-- Truncated Fourier-Dirichlet inversion integral attached to a law and an interval.

Source boundary: Paul Levy, *Calcul des probabilites* (Gauthier-Villars, 1925),
Part II, Chapter II, subheads "Integrale de Dirichlet" and "Determination
d'une loi de probabilite par sa fonction caracteristique", printed pp. 153 and
168; reconstruction row `T20c_14`/`CFI_01`. -/
opaque truncatedInversionIntegral (μ : ProbabilityMeasure ℝ) (a b T : ℝ) : ℂ

/-- Fourier averaging integral used to recover atom masses from a characteristic
function.

Source boundary: Paul Levy, *Calcul des probabilites* (Gauthier-Villars, 1925),
Part II, Chapter II, subhead "Determination des masses de la premiere classe.
Relation avec la theorie des series de Fourier", printed pp. 153 and 169;
reconstruction row `T20c_14`/`CFI_04`. -/
opaque atomRecoveryIntegral (μ : ProbabilityMeasure ℝ) (x T : ℝ) : ℂ

/-- Interval mass is recovered from the truncated Fourier-Dirichlet inversion integral at
continuity points of the limit CDF.

Source boundary: Paul Levy, *Calcul des probabilites* (Gauthier-Villars, 1925),
Part II, Chapter II, subheads "Integrale de Dirichlet" and "Determination
d'une loi de probabilite par sa fonction caracteristique", printed pp. 153 and
168; reconstruction row `T20c_14`/`CFI_01`. -/
axiom interval_mass_eq_tendsto_fourier_truncation (μ : ProbabilityMeasure ℝ)
    {a b : ℝ}
    (ha : ContinuousAt (ProbabilityTheory.cdf (μ : Measure ℝ)) a)
    (hb : ContinuousAt (ProbabilityTheory.cdf (μ : Measure ℝ)) b) :
    Tendsto (fun T : ℝ ↦ truncatedInversionIntegral μ a b T) atTop
      (𝓝 (((μ : Measure ℝ) (Set.Ioc a b)).toReal : ℂ))

/-- A real probability law is determined by its characteristic function.

This is now theorem-level: apply the fixed-target half of Lévy continuity to
the constant sequence `μs n = μ`, using the assumed equality of characteristic
functions to identify the pointwise limit as `ν`, then use uniqueness of limits
in `ProbabilityMeasure ℝ`.

The upstream analytic input is
`tendsto_of_tendsto_characteristicFunction`, cited to Christian Döbler,
"A short proof of Lévy's continuity theorem without using tightness",
*Statistics & Probability Letters* 185 (2022), 109438, Theorem 1.1,
specialized to `d = 1`. -/
theorem eq_of_characteristicFunction_eq (μ ν : ProbabilityMeasure ℝ)
    (hφ : characteristicFunction μ = characteristicFunction ν) :
    μ = ν := by
  have hlim : Tendsto (fun _ : ℕ => μ) atTop (𝓝 ν) := by
    apply tendsto_of_tendsto_characteristicFunction
    intro t
    rw [hφ]
    exact tendsto_const_nhds
  have hμ : Tendsto (fun _ : ℕ => μ) atTop (𝓝 μ) := tendsto_const_nhds
  exact tendsto_nhds_unique hμ hlim

/-- The mass of an atom is recovered by Fourier averaging.

Source boundary: Paul Levy, *Calcul des probabilites* (Gauthier-Villars, 1925),
Part II, Chapter II, subhead "Determination des masses de la premiere classe.
Relation avec la theorie des series de Fourier", printed pp. 153 and 169;
reconstruction row `T20c_14`/`CFI_04`. -/
axiom atom_eq_tendsto_mean_characteristicFunction (μ : ProbabilityMeasure ℝ) (x : ℝ) :
    Tendsto (fun T : ℝ ↦ atomRecoveryIntegral μ x T) atTop
      (𝓝 (((μ : Measure ℝ) ({x} : Set ℝ)).toReal : ℂ))

end CharacteristicFunction
end Probability
end MathlibExpansion
