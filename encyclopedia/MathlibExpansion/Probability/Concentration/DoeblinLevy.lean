import MathlibExpansion.Probability.Concentration.Addition

/-!
# Doeblin-Lévy lower bounds

This file records the lower-dispersion theorem for sums of independent laws.
-/

namespace MathlibExpansion
namespace Probability
namespace Concentration

open MeasureTheory
open MathlibExpansion.Probability.MeasureConvolution

/-- Independent-sum law of a finite family of real probability laws, built by iterated
independent convolution. The empty sum is assigned the ambient default probability law. -/
noncomputable def indepSumFamilyLaw : {n : ℕ} → (Fin n → ProbabilityMeasure ℝ) → ProbabilityMeasure ℝ
  | 0, _ => default
  | n + 1, μs =>
      indepSumLaw (indepSumFamilyLaw (fun i : Fin n => μs i.castSucc))
        (μs ⟨n, Nat.lt_succ_self n⟩)

/-- Doeblin-Lévy lower bound with the sharp upstream quantifier shape: for each
`0 < p < 1`, one positive constant `C(p)` works for every finite independent
family and every nonnegative lower dispersion scale.

Exact source boundary: Wolfgang Doeblin and Paul Levy, "Sur les sommes de variables aleatoires
independantes a dispersions bornees inferieurement", *Comptes rendus de l'Academie des sciences*
202 (1936), 2027-2029, article (104), unnumbered main theorem; see also Paul Levy,
*Theorie de l'addition des variables aleatoires* (1937; 2nd ed. 1954), Chapter 6,
"Sommes de termes a dispersions bornees inferieurement". -/
axiom doeblin_levy_dispersion_lower_bound_constant {p : ℝ}
    (hp : 0 < p ∧ p < 1) :
    ∃ C : NNReal, 0 < C ∧
      ∀ {n : ℕ} (μs : Fin n → ProbabilityMeasure ℝ) (L : NNReal),
        (∀ i, (L : ℝ) ≤ dispersionFunction (μs i) ⟨p, hp.1.le, hp.2.le⟩) →
        (C : ℝ) * (L : ℝ) * Real.sqrt n ≤
          dispersionFunction (indepSumFamilyLaw μs) ⟨p, hp.1.le, hp.2.le⟩

/-- Doeblin-Lévy lower bound for dispersion of sums. -/
theorem doeblin_levy_dispersion_lower_bound {n : ℕ} {p : ℝ}
    (hp : 0 < p ∧ p < 1) (μs : Fin n → ProbabilityMeasure ℝ) (L : NNReal)
    (hL : ∀ i, (L : ℝ) ≤ dispersionFunction (μs i) ⟨p, hp.1.le, hp.2.le⟩) :
    ∃ C : NNReal, 0 < C ∧
      (C : ℝ) * (L : ℝ) * Real.sqrt n ≤
        dispersionFunction (indepSumFamilyLaw μs) ⟨p, hp.1.le, hp.2.le⟩ := by
  obtain ⟨C, hC, hbound⟩ := doeblin_levy_dispersion_lower_bound_constant hp
  exact ⟨C, hC, hbound μs L hL⟩

end Concentration
end Probability
end MathlibExpansion
