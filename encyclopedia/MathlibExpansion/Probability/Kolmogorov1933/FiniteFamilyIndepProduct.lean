import Mathlib

/-!
# Finite-family independence and product laws

Kolmogorov's Chapter VI first states independence through factorization of the
finite-dimensional law. Mathlib already owns the binary theorem exactly; the
genuinely missing surface is the finite-family `Measure.pi` packaging.
-/

namespace MathlibExpansion
namespace Probability
namespace Kolmogorov1933

open MeasureTheory ProbabilityTheory

theorem indepFun_iff_jointLaw_eq_productMarginals {Ω α β : Type*}
    [MeasurableSpace Ω] [MeasurableSpace α] [MeasurableSpace β]
    {μ : Measure Ω} [IsFiniteMeasure μ] {X : Ω → α} {Y : Ω → β}
    (hX : AEMeasurable X μ) (hY : AEMeasurable Y μ) :
    IndepFun X Y μ ↔ μ.map (fun ω => (X ω, Y ω)) = (μ.map X).prod (μ.map Y) :=
  ProbabilityTheory.indepFun_iff_map_prod_eq_prod_map_map hX hY

/-- Finite-family owner package for the `Measure.pi` version of Kolmogorov's
factorization criterion. -/
structure FiniteFamilyIndepProductPackage {Ω ι : Type*}
    [Fintype ι] [MeasurableSpace Ω] {β : ι → Type*} [∀ i, MeasurableSpace (β i)]
    (μ : Measure Ω) [IsProbabilityMeasure μ] (X : ∀ i, Ω → β i) where
  jointLaw_eq_pi_iff :
    ProbabilityTheory.iIndepFun (fun _ => inferInstance) X μ ↔
      μ.map (fun ω i => X i ω) = Measure.pi (fun i => μ.map (X i))

/-- Finite-family `Measure.pi` version of Kolmogorov's factorization criterion.

The probability-measure hypothesis is essential: Mathlib's `iIndepFun` includes
the empty-family normalization, so the finite-measure-only variant is false for
singleton families over non-probability finite measures.

Source: A. Kolmogorov, *Grundbegriffe der Wahrscheinlichkeitsrechnung* (1933),
Chapter VI, §2, pp. 51-52. -/
theorem finiteFamilyIndepProductPackage {Ω ι : Type*}
    [Fintype ι] [MeasurableSpace Ω] {β : ι → Type*} [∀ i, MeasurableSpace (β i)]
    (μ : Measure Ω) [IsProbabilityMeasure μ] (X : ∀ i, Ω → β i)
    (hX : ∀ i, AEMeasurable (X i) μ) :
    FiniteFamilyIndepProductPackage μ X := by
  classical
  refine ⟨?_⟩
  have hJoint : AEMeasurable (fun ω i => X i ω) μ := by
    refine ⟨fun ω i => (hX i).mk (X i) ω, ?_, ?_⟩
    · exact measurable_pi_iff.mpr fun i => (hX i).measurable_mk
    · exact (ae_all_iff.mpr fun i => (hX i).ae_eq_mk).mono fun ω hω =>
        funext fun i => hω i
  rw [ProbabilityTheory.iIndepFun_iff_measure_inter_preimage_eq_mul]
  constructor
  · intro hIndep
    refine (Measure.pi_eq (μ := fun i => μ.map (X i)) fun s hs => ?_).symm
    have hpre : (fun ω => fun i => X i ω) ⁻¹' Set.pi Set.univ s =
        ⋂ i, X i ⁻¹' s i := by
      ext ω
      simp [Set.mem_univ_pi]
    rw [Measure.map_apply_of_aemeasurable hJoint
      (MeasurableSet.pi Set.countable_univ fun i _ => hs i)]
    rw [hpre]
    simp_rw [Measure.map_apply_of_aemeasurable (hX _) (hs _)]
    simpa using hIndep Finset.univ (sets := s) (by intro i _; exact hs i)
  · intro hEq S sets hsets
    let sets' : ∀ i, Set (β i) := fun i => if i ∈ S then sets i else Set.univ
    have hsets' : ∀ i, MeasurableSet (sets' i) := by
      intro i
      by_cases hi : i ∈ S
      · simp [sets', hi, hsets i hi]
      · simp [sets', hi]
    have hMeasure :
        (Measure.map (fun ω => fun i => X i ω) μ) (Set.pi Set.univ sets') =
          (Measure.pi fun i => μ.map (X i)) (Set.pi Set.univ sets') := by
      simpa using congrArg (fun ν : Measure (∀ i, β i) => ν (Set.pi Set.univ sets')) hEq
    rw [Measure.map_apply_of_aemeasurable hJoint
      (MeasurableSet.pi Set.countable_univ fun i _ => hsets' i)] at hMeasure
    rw [Measure.pi_pi] at hMeasure
    simp_rw [Measure.map_apply_of_aemeasurable (hX _) (hsets' _)] at hMeasure
    have hpreS : (fun ω => fun i => X i ω) ⁻¹' Set.pi Set.univ sets' =
        ⋂ i ∈ S, X i ⁻¹' sets i := by
      ext ω
      simp [sets', Set.mem_univ_pi]
    have hprod : (∏ x : ι, μ (X x ⁻¹' sets' x)) =
        ∏ i ∈ S, μ (X i ⁻¹' sets i) := by
      calc
        (∏ x : ι, μ (X x ⁻¹' sets' x)) =
            ∏ x : ι, if x ∈ S then μ (X x ⁻¹' sets x) else 1 := by
          refine Finset.prod_congr rfl ?_
          intro x _
          by_cases h : x ∈ S <;> simp [sets', h, measure_univ]
        _ = ∏ i ∈ S, μ (X i ⁻¹' sets i) := by
          symm
          calc
            (∏ i ∈ S, μ (X i ⁻¹' sets i)) =
                ∏ i ∈ S, if i ∈ S then μ (X i ⁻¹' sets i) else 1 := by
              refine Finset.prod_congr rfl ?_
              intro x hx
              simp [hx]
            _ = ∏ x : ι, if x ∈ S then μ (X x ⁻¹' sets x) else 1 := by
              refine Finset.prod_subset (s₁ := S) (s₂ := Finset.univ)
                (f := fun x => if x ∈ S then μ (X x ⁻¹' sets x) else 1)
                (by intro x _; exact Finset.mem_univ x) ?_
              intro x _ hxS
              simp [hxS]
    rw [hpreS, hprod] at hMeasure
    exact hMeasure

theorem iIndepFun_iff_jointLaw_eq_pi {Ω ι : Type*}
    [Fintype ι] [MeasurableSpace Ω] {β : ι → Type*} [∀ i, MeasurableSpace (β i)]
    (μ : Measure Ω) [IsProbabilityMeasure μ] (X : ∀ i, Ω → β i)
    (hX : ∀ i, AEMeasurable (X i) μ) :
    ProbabilityTheory.iIndepFun (fun _ => inferInstance) X μ ↔
      μ.map (fun ω i => X i ω) = Measure.pi (fun i => μ.map (X i)) :=
  (finiteFamilyIndepProductPackage μ X hX).jointLaw_eq_pi_iff

end Kolmogorov1933
end Probability
end MathlibExpansion
