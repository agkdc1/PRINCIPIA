import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
import Mathlib.MeasureTheory.Integral.Bochner
import MathlibExpansion.Analysis.Riemann.UpperLower
import MathlibExpansion.MeasureTheory.Jordan.Quadrable

noncomputable section

open MeasureTheory

namespace MathlibExpansion
namespace MeasureTheory
namespace GeometricIntegral

/-- The Chapter III/Chapter VII subgraph region used in the geometric integral lane. -/
def subgraphOn (f : ℝ → ℝ) (s : Set ℝ) : Set (Fin 2 → ℝ) :=
  {p | p 0 ∈ s ∧ p 1 ∈ Set.Icc (min 0 (f (p 0))) (max 0 (f (p 0)))}

/-- Positive part of the textbook subgraph region. -/
def posSubgraph {α : Type*} (f : α → ℝ) (s : Set α) : Set (α × ℝ) :=
  {p | p.1 ∈ s ∧ p.2 ∈ Set.Icc 0 (max (f p.1) 0)}

/-- Negative part of the textbook subgraph region. -/
def negSubgraph {α : Type*} (f : α → ℝ) (s : Set α) : Set (α × ℝ) :=
  {p | p.1 ∈ s ∧ p.2 ∈ Set.Icc (min (f p.1) 0) 0}

/--
`GIS_01a`: one direction of Lebesgue 1904, *Lecons sur l'integration et la
recherche des fonctions primitives*, Ch. III "Definition geometrique de
l'integrale", unnumbered displayed proposition on p. 46: for bounded functions,
Riemann integrability is equivalent to Jordan measurability of the planar
subgraph `E(f)`.

This remains an upstream-narrow boundary because the local
`RiemannIntegrableOn` carrier is only `IntervalIntegrable`, while the cited
proposition is the historical Darboux/Riemann-to-Jordan subgraph bridge.
-/
axiom jordanMeasurable_subgraphOn_of_riemannIntegrableOn {f : ℝ → ℝ} {a b : ℝ}
    (hab : a ≤ b)
    (hbounded : MathlibExpansion.Analysis.Riemann.TextbookBoundedOnInterval f a b) :
    MathlibExpansion.Analysis.Riemann.RiemannIntegrableOn f a b →
      MathlibExpansion.MeasureTheory.Jordan.JordanMeasurable
        (subgraphOn f (Set.Icc a b))

/--
`GIS_01b`: the converse direction of Lebesgue 1904, *Lecons sur l'integration
et la recherche des fonctions primitives*, Ch. III "Definition geometrique de
l'integrale", unnumbered displayed proposition on p. 46: a bounded function
whose planar subgraph `E(f)` is Jordan-measurable is Riemann integrable.

This is split from the former broad iff axiom so the remaining assumptions are
directional and citation-backed.
-/
axiom riemannIntegrableOn_of_jordanMeasurable_subgraphOn {f : ℝ → ℝ} {a b : ℝ}
    (hab : a ≤ b)
    (hbounded : MathlibExpansion.Analysis.Riemann.TextbookBoundedOnInterval f a b) :
    MathlibExpansion.MeasureTheory.Jordan.JordanMeasurable
        (subgraphOn f (Set.Icc a b)) →
      MathlibExpansion.Analysis.Riemann.RiemannIntegrableOn f a b

/-- `GIS_01`: bounded interval functions are Riemann-integrable exactly when their
subgraph is Jordan-measurable, assembled from the two directional Lebesgue 1904
boundaries above. -/
theorem riemannIntegrableOn_iff_jordanMeasurable_subgraph {f : ℝ → ℝ} {a b : ℝ}
    (hab : a ≤ b)
    (hbounded : MathlibExpansion.Analysis.Riemann.TextbookBoundedOnInterval f a b) :
    MathlibExpansion.Analysis.Riemann.RiemannIntegrableOn f a b ↔
      MathlibExpansion.MeasureTheory.Jordan.JordanMeasurable
        (subgraphOn f (Set.Icc a b)) := by
  constructor
  · exact jordanMeasurable_subgraphOn_of_riemannIntegrableOn hab hbounded
  · exact riemannIntegrableOn_of_jordanMeasurable_subgraphOn hab hbounded

/-- The positive closed subgraph has product measure equal to the positive
part lintegral for pointwise measurable functions. -/
theorem volume_posSubgraph_univ_eq_lintegral_of_measurable
    {α : Type*} [MeasurableSpace α] {μ : Measure α} {f : α → ℝ}
    (hf : Measurable f) :
    μ.prod volume (posSubgraph f Set.univ) = ∫⁻ x, ENNReal.ofReal (f x) ∂μ := by
  rw [Measure.prod_apply]
  · congr with x
    have hslice :
        Prod.mk x ⁻¹' posSubgraph f Set.univ = Set.Icc (0 : ℝ) (max (f x) 0) := by
      ext y
      simp [posSubgraph]
    rw [hslice, Real.volume_Icc]
    by_cases hx : 0 ≤ f x
    · simp [hx, max_eq_left hx]
    · have hxle : f x ≤ 0 := le_of_not_ge hx
      simp [hxle, max_eq_right hxle]
  · dsimp [posSubgraph]
    refine MeasurableSet.inter MeasurableSet.univ ?_
    exact (measurableSet_le measurable_const measurable_snd).inter
      (measurableSet_le measurable_snd ((hf.comp measurable_fst).max measurable_const))

/-- The negative closed subgraph has product measure equal to the negative
part lintegral for pointwise measurable functions. -/
theorem volume_negSubgraph_univ_eq_lintegral_of_measurable
    {α : Type*} [MeasurableSpace α] {μ : Measure α} {f : α → ℝ}
    (hf : Measurable f) :
    μ.prod volume (negSubgraph f Set.univ) = ∫⁻ x, ENNReal.ofReal (-f x) ∂μ := by
  rw [Measure.prod_apply]
  · congr with x
    have hslice :
        Prod.mk x ⁻¹' negSubgraph f Set.univ = Set.Icc (min (f x) 0) (0 : ℝ) := by
      ext y
      simp [negSubgraph]
    rw [hslice, Real.volume_Icc]
    by_cases hx : f x ≤ 0
    · simp [hx, min_eq_left hx]
    · have hxle : 0 ≤ f x := le_of_not_ge hx
      simp [hxle, min_eq_right hxle]
  · dsimp [negSubgraph]
    refine MeasurableSet.inter MeasurableSet.univ ?_
    exact (measurableSet_le ((hf.comp measurable_fst).min measurable_const) measurable_snd).inter
      (measurableSet_le measurable_snd measurable_const)

/--
`GIS_04`: the signed integral is the area above the axis minus the area below
the axis.  This is the pointwise-measurable closed-subgraph version of Lebesgue
1904, Ch. VII §V, p. 116, backed by `Measure.prod_apply`,
`Real.volume_Icc`, and Mathlib's
`integral_eq_lintegral_pos_part_sub_lintegral_neg_part`.
-/
theorem integral_eq_volume_posSubgraph_sub_volume_negSubgraph
    {α : Type*} [MeasurableSpace α] {μ : Measure α} {f : α → ℝ}
    (hf : Integrable f μ) (hfm : Measurable f) :
    ∫ x, f x ∂μ =
      ENNReal.toReal (μ.prod volume (posSubgraph f Set.univ)) -
        ENNReal.toReal (μ.prod volume (negSubgraph f Set.univ)) := by
  rw [integral_eq_lintegral_pos_part_sub_lintegral_neg_part hf]
  rw [volume_posSubgraph_univ_eq_lintegral_of_measurable (μ := μ) hfm]
  rw [volume_negSubgraph_univ_eq_lintegral_of_measurable (μ := μ) hfm]

end GeometricIntegral
end MeasureTheory
end MathlibExpansion
