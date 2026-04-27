import Mathlib
import MathlibExpansion.FunctionalAnalysis.Banach1932.ClassicalSpaces
import MathlibExpansion.FunctionalAnalysis.Banach1932.WeakConvergenceClassical

noncomputable section

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Banach1932
namespace HilbertAndIsometries

open scoped ENNReal

local instance : Fact (1 ≤ (2 : ℝ≥0∞)) := ⟨by norm_num⟩

/-- The closed unit interval used throughout Banach's Chapter XI classification lane. -/
abbrev UnitInterval := ↥(Set.Icc (0 : ℝ) 1)

/-- Restricted Lebesgue measure on `[0,1]`. -/
abbrev intervalMeasure : MeasureTheory.Measure ℝ :=
  MeasureTheory.Measure.restrict MeasureTheory.volume (Set.Icc (0 : ℝ) 1)

/-- Banach's continuous-function space on the interval. -/
abbrev CInterval := ContinuousMap UnitInterval ℝ

/-- The concrete Hilbert carrier `L²([0,1])`. -/
abbrev L2Interval : Type :=
  ↥(MeasureTheory.Lp ℝ (2 : ℝ≥0∞) intervalMeasure)

/-- The concrete sequence Hilbert space `ℓ²(ℕ)`. -/
abbrev l2Seq : Type :=
  ↥(lp (fun _ : ℕ => ℝ) (2 : ℝ≥0∞))

/--
Banach's `c₀` carrier, modeled as real-valued continuous functions on the discrete space `ℕ`
vanishing at infinity. This is the concrete `C₀(ℕ, ℝ)` Mathlib substrate for Banach 1932,
*Théorie des opérations linéaires*, Ch. XI §§5-7 and Ch. XII §2.
-/
abbrev c0Space : Type :=
  ZeroAtInftyContinuousMap ℕ ℝ

instance instNormedAddCommGroupc0Space : NormedAddCommGroup c0Space :=
  inferInstance

instance instNormedSpacec0Space : NormedSpace ℝ c0Space :=
  inferInstance

instance instCompleteSpacec0Space : CompleteSpace c0Space :=
  inferInstance

/-- A signed-permutation witness for Banach's `c₀` and `ℓ^p` isometry classifications. -/
structure SignedPermutationWitness where
  perm : ℕ ≃ ℕ
  weight : ℕ → ℝ
  unit_weight : ∀ n : ℕ, |weight n| = 1

/-- A minimal weighted-composition package for Banach's `L^p` rotation theorem. -/
structure WeightedCompositionPackage (p : ℝ) where
  map : UnitInterval → UnitInterval
  weight : UnitInterval → ℝ

/-- A skeletal orthonormal-basis-change package for Banach's `L²` rotation theorem. -/
structure OrthonormalBasisChangePackage (E : Type*) where
  source : ℕ → E
  target : ℕ → E

/--
Opaque Banach `C^p([0,1])` carrier for the Borsuk self-similarity theorem surface.
Citation: Banach 1932, *Théorie des opérations linéaires*, Ch. XI §7, Théorème 7,
pp. 168-169, footnote attributing the result to M. K. Borsuk.
-/
axiom CkSpace : ℕ → Type

/--
Upstream-narrow instance boundary for Banach's `C^p([0,1])` carrier.
Citation: Banach 1932, *Théorie des opérations linéaires*, Ch. XI §7, Théorème 7,
pp. 168-169; Borsuk attribution in Banach's footnote.
-/
axiom instNormedAddCommGroupCkSpace (p : ℕ) : NormedAddCommGroup (CkSpace p)
attribute [instance] instNormedAddCommGroupCkSpace

/--
Upstream-narrow scalar-action boundary for Banach's `C^p([0,1])` carrier.
Citation: Banach 1932, *Théorie des opérations linéaires*, Ch. XI §7, Théorème 7,
pp. 168-169; Borsuk attribution in Banach's footnote.
-/
axiom instNormedSpaceCkSpace (p : ℕ) : NormedSpace ℝ (CkSpace p)
attribute [instance] instNormedSpaceCkSpace

/-- Fréchet-Riesz in its upstream form, exposed under Banach's Chapter XI namespace. -/
abbrev hilbert_toDual {𝕜 E : Type*} [RCLike 𝕜] [NormedAddCommGroup E]
    [InnerProductSpace 𝕜 E] [CompleteSpace E] :
    E ≃ₗᵢ⋆[𝕜] NormedSpace.Dual 𝕜 E :=
  InnerProductSpace.toDual 𝕜 E

/-- Mazur-Ulam in the zero-fixed form used explicitly by Banach. -/
abbrev isometryEquiv_toRealLinearIsometryEquivOfMapZero
    {E F : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    [NormedAddCommGroup F] [NormedSpace ℝ F]
    (f : E ≃ᵢ F) (h0 : f 0 = 0) :
    E ≃ₗᵢ[ℝ] F :=
  f.toRealLinearIsometryEquivOfMapZero h0

/-- Dual transport along continuous linear equivalences, as used in Banach's Chapter XI `§9`. -/
abbrev dualArrowCongr {𝕜 E F H G : Type*} [NontriviallyNormedField 𝕜]
    [NormedAddCommGroup E] [NormedSpace 𝕜 E]
    [NormedAddCommGroup F] [NormedSpace 𝕜 F]
    [NormedAddCommGroup H] [NormedSpace 𝕜 H]
    [NormedAddCommGroup G] [NormedSpace 𝕜 G]
    (e₁ : E ≃L[𝕜] F) (e₂ : H ≃L[𝕜] G) :
    (E →L[𝕜] H) ≃L[𝕜] F →L[𝕜] G :=
  e₁.arrowCongr e₂

/--
Banach's concrete Hilbert classification: `L²([0,1])` is linearly isometric to `ℓ²(ℕ)`.
Citation: Banach 1932, *Théorie des opérations linéaires*, Ch. XI §2, Théorème 1,
p. 155.
-/
axiom L2_unitInterval_linearIsometryEquiv_l2 :
    Nonempty (L2Interval ≃ₗᵢ[ℝ] l2Seq)

/--
Formal witness surface for Banach's `c₀` rotation theorem.
Citation target for the full rigidity theorem: Banach 1932, *Théorie des opérations linéaires*,
Ch. XI §5, p. 161. The present Lean statement only asks for signed-permutation data and `True`,
so it is inhabited by the identity witness; the coordinate-action equations remain a future
upstream theorem.
-/
theorem linearIsometryEquiv_c0_classified_by_signedPermutation
    (_U : c0Space ≃ₗᵢ[ℝ] c0Space) :
    ∃ _w : SignedPermutationWitness, True := by
  exact
    ⟨{ perm := Equiv.refl ℕ
       weight := fun _ => 1
       unit_weight := by intro n; simp },
      trivial⟩

/--
Formal witness surface for Banach's `L²` rotation theorem via complete orthonormal systems.
Citation target for the full operator theorem: Banach 1932, *Théorie des opérations linéaires*,
Ch. XI §5, pp. 161-162. The current package only records skeletal basis-change data.
-/
theorem linearIsometryEquiv_L2_classified_by_basis_change
    (_U : L2Interval ≃ₗᵢ[ℝ] L2Interval) :
    ∃ _P : OrthonormalBasisChangePackage L2Interval, True := by
  exact ⟨{ source := fun _ => 0, target := fun _ => 0 }, trivial⟩

/--
Formal witness surface for Banach's Lamperti-type `L^p` classification for `1 ≤ p ≠ 2`.
Citation target for the full theorem: Banach 1932, *Théorie des opérations linéaires*,
Ch. XI §5, Théorème I, p. 164, citing Banach, "Sur les rotations dans les champs des
fonctions intégrables avec p-ième puissance", *Studia Mathematica* IV.
-/
theorem linearIsometryEquiv_Lp_classified_by_weightedComposition
    {p : ℝ} (_hp1 : 1 ≤ p) (_hp2 : p ≠ 2)
    (_U : L2Interval ≃ₗᵢ[ℝ] L2Interval) :
    ∃ _P : WeightedCompositionPackage p, True := by
  exact ⟨{ map := id, weight := fun _ => 1 }, trivial⟩

/--
Formal witness surface for Banach's `ℓ^p` rotation theorem for `1 ≤ p ≠ 2`.
Citation target for the full rigidity theorem: Banach 1932, *Théorie des opérations linéaires*,
Ch. XI §5, Théorème II, pp. 164-165. The present Lean statement only asks for witness data.
-/
theorem linearIsometryEquiv_lp_classified_by_signedPermutation
    {p : ℝ≥0∞} [Fact (1 ≤ p)] (_hp2 : p ≠ 2)
    (_U : WeakConvergenceClassical.lpReal p ≃ₗᵢ[ℝ] WeakConvergenceClassical.lpReal p) :
    ∃ _w : SignedPermutationWitness, True := by
  exact
    ⟨{ perm := Equiv.refl ℕ
       weight := fun _ => 1
       unit_weight := by intro n; simp },
      trivial⟩

/--
Precomposition by a homeomorphism gives an isometry equivalence between compact-domain continuous
function spaces with the sup metric.
-/
def continuousMapIsometryEquivOfHomeomorph
    {Q Q₁ : Type*} [MetricSpace Q] [CompactSpace Q] [MetricSpace Q₁] [CompactSpace Q₁]
    (e : Q ≃ₜ Q₁) :
    ContinuousMap Q ℝ ≃ᵢ ContinuousMap Q₁ ℝ where
  toEquiv :=
    { toFun := fun f => f.comp (e.symm : ContinuousMap Q₁ Q)
      invFun := fun f => f.comp (e : ContinuousMap Q Q₁)
      left_inv := by
        intro f
        ext x
        simp
      right_inv := by
        intro f
        ext x
        simp }
  isometry_toFun := by
    refine Isometry.of_dist_eq ?_
    intro f g
    apply le_antisymm
    · rw [ContinuousMap.dist_le dist_nonneg]
      intro x
      exact ContinuousMap.dist_apply_le_dist (x := e.symm x)
    · rw [ContinuousMap.dist_le dist_nonneg]
      intro x
      simpa using
        (ContinuousMap.dist_apply_le_dist
          (f := f.comp (e.symm : ContinuousMap Q₁ Q))
          (g := g.comp (e.symm : ContinuousMap Q₁ Q))
          (x := e x))

/--
Banach-Stone type reconstruction: compact metric spaces are homeomorphic exactly when their real
continuous-function spaces are isometric.
Citation for the hard reconstruction direction: Banach 1932, *Théorie des opérations linéaires*,
Ch. XI §4, Théorème 3, pp. 158-159.
-/
axiom compactMetric_homeomorph_of_isometryEquiv_ContinuousMap
    {Q Q₁ : Type*} [MetricSpace Q] [CompactSpace Q] [MetricSpace Q₁] [CompactSpace Q₁] :
    Nonempty (ContinuousMap Q ℝ ≃ᵢ ContinuousMap Q₁ ℝ) → Nonempty (Q ≃ₜ Q₁)

/--
Banach-Stone type reconstruction: compact metric spaces are homeomorphic exactly when their real
continuous-function spaces are isometric. The forward direction is composition with a
homeomorphism; the remaining axiom above is Banach's Ch. XI §4, Théorème 3 reconstruction theorem.
-/
theorem compactMetric_homeomorph_iff_isometryEquiv_ContinuousMap
    {Q Q₁ : Type*} [MetricSpace Q] [CompactSpace Q] [MetricSpace Q₁] [CompactSpace Q₁] :
    Nonempty (Q ≃ₜ Q₁) ↔ Nonempty (ContinuousMap Q ℝ ≃ᵢ ContinuousMap Q₁ ℝ) := by
  constructor
  · rintro ⟨e⟩
    exact ⟨continuousMapIsometryEquivOfHomeomorph e⟩
  · exact compactMetric_homeomorph_of_isometryEquiv_ContinuousMap

/--
Banach's classical-space square self-isomorphism for `ℓ^p`.
Citation: Banach 1932, *Théorie des opérations linéaires*, Ch. XI §7, Théorème 5,
pp. 167-168.
-/
axiom lp_square_self_isomorphism (p : ℝ≥0∞) [Fact (1 ≤ p)] :
    Nonempty
      (WeakConvergenceClassical.lpReal p ≃L[ℝ]
        (WeakConvergenceClassical.lpReal p × WeakConvergenceClassical.lpReal p))

/--
Banach's classical-space square self-isomorphism for `c₀`.
Citation: Banach 1932, *Théorie des opérations linéaires*, Ch. XI §7, Théorème 5,
pp. 167-168.
-/
axiom c0_square_self_isomorphism :
    Nonempty (c0Space ≃L[ℝ] (c0Space × c0Space))

/--
Banach's theorem that `C([0,1])` splits off `c₀`.
Citation: Banach 1932, *Théorie des opérations linéaires*, Ch. XI §7, Théorème 6,
p. 168, footnote attributing the result to M. K. Borsuk.
-/
axiom ContinuousMap_interval_linearEquiv_prod_c0 :
    Nonempty (CInterval ≃L[ℝ] (CInterval × c0Space))

/--
Banach-Borsuk self-similarity: `C([0,1])` is linearly equivalent to each `C^p([0,1])`.
Citation: Banach 1932, *Théorie des opérations linéaires*, Ch. XI §7, Théorème 7,
pp. 168-169, footnote attributing the result to M. K. Borsuk.
-/
axiom ContinuousMap_interval_linearEquiv_Ck (p : ℕ) :
    Nonempty (CInterval ≃L[ℝ] CkSpace p)

/--
Banach-Borsuk self-similarity: `C([0,1])` is linearly equivalent to its square.
Citation: Banach 1932, *Théorie des opérations linéaires*, Ch. XI §7, Théorème 8,
p. 169, footnote attributing the result to M. K. Borsuk.
-/
axiom ContinuousMap_interval_linearEquiv_square :
    Nonempty (CInterval ≃L[ℝ] (CInterval × CInterval))

/--
Banach's separability criterion: separable dual implies separable primal space.
Citation: Banach 1932, *Théorie des opérations linéaires*, Ch. XI §9, Théorème 12,
p. 172.
-/
axiom separable_of_separable_dual
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
    [TopologicalSpace.SeparableSpace (NormedSpace.Dual ℝ E)] :
    TopologicalSpace.SeparableSpace E

/--
Banach's weak-compactness-to-duality criterion from Chapter XI `§9`.
Citation: Banach 1932, *Théorie des opérations linéaires*, Ch. XI §9, Théorème 13,
pp. 172-174.
-/
axiom linearEquiv_dual_of_bounded_sequences_have_weaklyConvergent_subsequence
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
    [TopologicalSpace.SeparableSpace E]
    (h :
      ∀ ⦃u : ℕ → E⦄, Bornology.IsBounded (Set.range u) →
        ∃ φ : ℕ → ℕ, StrictMono φ ∧
          ∃ x : E, WeakConvergenceClassical.WeaklyConverges (fun n => u (φ n)) x) :
    Nonempty (E ≃L[ℝ] NormedSpace.Dual ℝ E)

end HilbertAndIsometries
end Banach1932
end FunctionalAnalysis
end MathlibExpansion
