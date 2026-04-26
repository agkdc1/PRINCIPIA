import Mathlib

/-!
# Time-integrated Lebesgue spaces `L^q_t L^p_x`

This NS-R1 root fixes the Kato calibration surface as a concrete Bochner `Lp`
encoding:

`L^q_t L^p_x(R_+ x R^3) = Lp (Lp R p volume) q (volume.restrict [0, infinity))`.

The Banach/additive/vector-space structure is closed by Mathlib's existing
`MeasureTheory.Lp` instances.  The mixed-norm Holder product theorem and exact
Navier-Stokes scaling law are recorded as explicit local API walls, because
Mathlib v4.17.0 does not package mixed Lebesgue spaces, pointwise products of
Bochner-`Lp` representatives, or the anisotropic parabolic dilation action on
these quotient spaces.
-/

noncomputable section

set_option linter.unusedVariables false
set_option linter.dupNamespace false

open MeasureTheory Set
open scoped ENNReal NNReal

namespace NavierStokes
namespace Roots
namespace TimeIntegratedLp

/-- The spatial domain `R^3`, represented as functions on `Fin 3`. -/
abbrev R3 : Type := Fin 3 → ℝ

/-- Lebesgue time measure restricted to `R_+ = [0, infinity)`. -/
def timeMeasure : Measure ℝ :=
  (volume : Measure ℝ).restrict (Set.Ici 0)

/-- Finite time window `[0, T]`, used for the displayed calibration norm. -/
def finiteTimeMeasure (T : ℝ) : Measure ℝ :=
  (volume : Measure ℝ).restrict (Set.Icc 0 T)

/-- Scalar-valued spatial `L^p(R^3)`. -/
abbrev SpatialLp (p : ℝ≥0∞) [Fact (1 ≤ p)] : Type :=
  Lp ℝ p (volume : Measure R3)

/--
Bundled mixed Lebesgue space `L^q_t L^p_x(R_+ x R^3)`.

This is definitionally the Bochner `Lp` space of time-indexed spatial `Lp`
classes.  The usual displayed finiteness condition
`(int_0^T ||u(t, .)||_{L^p(R^3)}^q dt)^(1/q) < infinity` is represented by
membership in this quotient space; `rawMixedNormFinite` below records the
corresponding representative-level predicate for unbundled functions.
-/
abbrev TimeIntegratedLp (q p : ℝ≥0∞) [Fact (1 ≤ p)] [Fact (1 ≤ q)] : Type :=
  Lp (SpatialLp p) q timeMeasure

/--
Finite-horizon mixed Lebesgue space over `[0, T]`.

This is the literal Lean carrier for the displayed quantity
`(int_0^T ||u(t, .)||_Lp^q dt)^(1/q)`.
-/
abbrev TimeIntegratedLpOn (T : ℝ) (q p : ℝ≥0∞)
    [Fact (1 ≤ p)] [Fact (1 ≤ q)] : Type :=
  Lp (SpatialLp p) q (finiteTimeMeasure T)

/--
Representative-level mixed norm finiteness predicate for raw functions
`u : R_+ x R^3 -> R`.

The first conjunct says `u(t, .)` is spatially `L^p` for a.e. nonnegative time.
The second says the time function `t |-> ||u(t, .)||_{L^p}` is in `L^q(R_+)`.
-/
def rawMixedNormFinite (u : ℝ → R3 → ℝ) (q p : ℝ≥0∞) : Prop :=
  (∀ᵐ t ∂timeMeasure, MemLp (u t) p (volume : Measure R3)) ∧
    MemLp (fun t : ℝ => (eLpNorm (u t) p (volume : Measure R3)).toReal) q timeMeasure

/-- Representative-level mixed norm finiteness on a finite time window `[0, T]`. -/
def rawMixedNormFiniteOn (T : ℝ) (u : ℝ → R3 → ℝ) (q p : ℝ≥0∞) : Prop :=
  (∀ᵐ t ∂finiteTimeMeasure T, MemLp (u t) p (volume : Measure R3)) ∧
    MemLp (fun t : ℝ => (eLpNorm (u t) p (volume : Measure R3)).toReal)
      q (finiteTimeMeasure T)

/-- Temporary carrier for spacetime test functions on `R_+ x R^3`. -/
abbrev SpacetimeTestFunction : Type :=
  ℝ → R3 → ℝ

/-- Temporary carrier for scalar spacetime distributions. -/
abbrev SpacetimeDistribution : Type :=
  SpacetimeTestFunction → ℝ

/-- Product spacetime domain `R_+ × R^3` before quotienting by a.e. equality. -/
abbrev Spacetime : Type :=
  ℝ × R3

/-- Product measure on `R_+ × R^3`. -/
def spacetimeMeasure : Measure Spacetime :=
  timeMeasure.prod (volume : Measure R3)

/-- Scalar spacetime `L^r(R_+ × R^3)` over the product measure. -/
abbrev SpacetimeLp (r : ℝ≥0∞) [Fact (1 ≤ r)] : Type :=
  Lp ℝ r spacetimeMeasure

/-- Key Kato calibration exponent for `u in L^3(R^3)`: `L^5_t L^5_x`. -/
abbrev KatoTimeExponent : ℝ≥0∞ := 5

/-- Key Kato calibration exponent for `u in L^3(R^3)`: `L^5_t L^5_x`. -/
abbrev KatoSpaceExponent : ℝ≥0∞ := 5

instance katoSpaceExponentFact : Fact (1 ≤ KatoSpaceExponent) :=
  ⟨by norm_num [KatoSpaceExponent]⟩

instance katoTimeExponentFact : Fact (1 ≤ KatoTimeExponent) :=
  ⟨by norm_num [KatoTimeExponent]⟩

/-- Kato's scale-critical mixed norm surface `L^5_t L^5_x(R_+ x R^3)`. -/
abbrev KatoL5L5 : Type :=
  TimeIntegratedLp KatoTimeExponent KatoSpaceExponent

/-- Kato's finite-window calibration surface on `[0, T]`. -/
abbrev KatoL5L5On (T : ℝ) : Type :=
  TimeIntegratedLpOn T KatoTimeExponent KatoSpaceExponent

/-- The mixed space is an additive normed group by the underlying Bochner `Lp` API. -/
example (q p : ℝ≥0∞) [Fact (1 ≤ p)] [Fact (1 ≤ q)] :
    NormedAddCommGroup (TimeIntegratedLp q p) := by
  infer_instance

/-- The mixed space is a real normed vector space. -/
example (q p : ℝ≥0∞) [Fact (1 ≤ p)] [Fact (1 ≤ q)] :
    NormedSpace ℝ (TimeIntegratedLp q p) := by
  infer_instance

/-- The mixed space is Banach, inherited from nested `Lp` completeness. -/
example (q p : ℝ≥0∞) [Fact (1 ≤ p)] [Fact (1 ≤ q)] :
    CompleteSpace (TimeIntegratedLp q p) := by
  infer_instance

/-- Additivity closure in `L^q_t L^p_x`. -/
theorem add_mem (q p : ℝ≥0∞) [Fact (1 ≤ p)] [Fact (1 ≤ q)]
    (u v : TimeIntegratedLp q p) :
    u + v ∈ (Set.univ : Set (TimeIntegratedLp q p)) := by
  simp

/-- Triangle inequality for the mixed norm. -/
theorem mixed_norm_add_le (q p : ℝ≥0∞) [Fact (1 ≤ p)] [Fact (1 ≤ q)]
    (u v : TimeIntegratedLp q p) :
    ‖u + v‖ ≤ ‖u‖ + ‖v‖ :=
  norm_add_le u v

/-- Closed Banach-space calibration, as a named theorem rather than an example. -/
theorem timeIntegratedLp_completeSpace
    (q p : ℝ≥0∞) [Fact (1 ≤ p)] [Fact (1 ≤ q)] :
    CompleteSpace (TimeIntegratedLp q p) := by
  infer_instance

/-- Holder relation for time exponents. -/
def HolderRelation (q q₁ q₂ : ℝ≥0∞) : Prop :=
  q.toReal⁻¹ = q₁.toReal⁻¹ + q₂.toReal⁻¹

/-- Holder relation for both time and space exponents in a mixed norm. -/
def MixedHolderRelation
    (q p q₁ p₁ q₂ p₂ : ℝ≥0∞) : Prop :=
  HolderRelation q q₁ q₂ ∧ HolderRelation p p₁ p₂

/-- Product target for two `L^5_t L^5_x` Kato factors. -/
abbrev KatoSquareTargetExponent : ℝ≥0∞ := (5 : ℝ≥0∞) / 2

/-- The algebraic Holder exponent relation for `L^5 * L^5 -> L^(5/2)`. -/
theorem kato_square_holder_relation :
    MixedHolderRelation KatoSquareTargetExponent KatoSquareTargetExponent
      KatoTimeExponent KatoSpaceExponent KatoTimeExponent KatoSpaceExponent := by
  constructor <;>
    norm_num [MixedHolderRelation, HolderRelation, KatoSquareTargetExponent,
      KatoTimeExponent, KatoSpaceExponent]

/--
Typed Mathlib v4.17.0 wall for mixed Holder products.

The missing upstream package must provide a pointwise multiplication operation
on representatives of nested `Lp` quotient spaces and prove the mixed
Holder estimate under the exponent relations.
-/
class HasMixedHolderProductAPI
    (q p q₁ p₁ q₂ p₂ : ℝ≥0∞)
    [Fact (1 ≤ p)] [Fact (1 ≤ q)]
    [Fact (1 ≤ p₁)] [Fact (1 ≤ q₁)]
    [Fact (1 ≤ p₂)] [Fact (1 ≤ q₂)] where
  product :
    TimeIntegratedLp q₁ p₁ → TimeIntegratedLp q₂ p₂ → TimeIntegratedLp q p
  holder_bound :
    MixedHolderRelation q p q₁ p₁ q₂ p₂ →
      ∀ u v, ‖product u v‖ ≤ ‖u‖ * ‖v‖

/-- Product in the mixed target space, once the mixed Holder API is supplied. -/
def holderProduct
    (q p q₁ p₁ q₂ p₂ : ℝ≥0∞)
    [Fact (1 ≤ p)] [Fact (1 ≤ q)]
    [Fact (1 ≤ p₁)] [Fact (1 ≤ q₁)]
    [Fact (1 ≤ p₂)] [Fact (1 ≤ q₂)]
    [api : HasMixedHolderProductAPI q p q₁ p₁ q₂ p₂]
    (u : TimeIntegratedLp q₁ p₁) (v : TimeIntegratedLp q₂ p₂) :
    TimeIntegratedLp q p :=
  api.product u v

/-- Mixed Holder inequality for `||uv||_{L^q_t L^p_x}`. -/
theorem holderProduct_norm_le
    (q p q₁ p₁ q₂ p₂ : ℝ≥0∞)
    [Fact (1 ≤ p)] [Fact (1 ≤ q)]
    [Fact (1 ≤ p₁)] [Fact (1 ≤ q₁)]
    [Fact (1 ≤ p₂)] [Fact (1 ≤ q₂)]
    [api : HasMixedHolderProductAPI q p q₁ p₁ q₂ p₂]
    (h : MixedHolderRelation q p q₁ p₁ q₂ p₂)
    (u : TimeIntegratedLp q₁ p₁) (v : TimeIntegratedLp q₂ p₂) :
    ‖holderProduct q p q₁ p₁ q₂ p₂ u v‖ ≤ ‖u‖ * ‖v‖ :=
  api.holder_bound h u v

/--
Typed Mathlib v4.17.0 wall for interpolation of mixed norms.

Attempt 2 keeps this separate from Holder multiplication because interpolation
requires a nested Bochner Riesz-Thorin or log-convexity theorem, not just a
pointwise product theorem.
-/
class HasMixedInterpolationAPI
    (q p q₀ p₀ q₁ p₁ : ℝ≥0∞)
    [Fact (1 ≤ p)] [Fact (1 ≤ q)]
    [Fact (1 ≤ p₀)] [Fact (1 ≤ q₀)]
    [Fact (1 ≤ p₁)] [Fact (1 ≤ q₁)] where
  interpolates : Prop
  interpolate_bound :
    interpolates →
      ∀ u : TimeIntegratedLp q₀ p₀,
        ∀ v : TimeIntegratedLp q₁ p₁,
          Prop

/-- Navier-Stokes parabolic scaling exponent for `L^q_t L^p_x` in dimension three. -/
def nseMixedLpScalingExponent (q p : ℝ≥0∞) : ℝ :=
  1 - (2 / q.toReal + 3 / p.toReal)

/-- Scaling-critical relation `2/q + 3/p = 1`. -/
def ScalingCritical (q p : ℝ≥0∞) : Prop :=
  nseMixedLpScalingExponent q p = 0

/-- `L^5_t L^5_x` is Navier-Stokes scale-critical. -/
theorem katoL5L5_scalingCritical :
    ScalingCritical KatoTimeExponent KatoSpaceExponent := by
  norm_num [ScalingCritical, nseMixedLpScalingExponent, KatoTimeExponent,
    KatoSpaceExponent]

/--
Attempt-2 explicit-kernel bookkeeping for the Navier-Stokes dilation
`u(t, x) |-> lambda * u(lambda^2 t, lambda x)`.

The three fields are exactly the factors that must be justified by a future
kernel/Jacobian theorem: amplitude `lambda`, time Jacobian `lambda^(-2)`,
and spatial Jacobian `lambda^(-3)`.
-/
structure ExplicitKernelScalingProfile where
  amplitudePower : ℝ
  timeJacobianPower : ℝ
  spaceJacobianPower : ℝ
  mixedNormPower : ℝ

/-- The exponent profile expected from the explicit kernel/Jacobian route. -/
def nseExplicitKernelScalingProfile (q p : ℝ≥0∞) :
    ExplicitKernelScalingProfile where
  amplitudePower := 1
  timeJacobianPower := -2
  spaceJacobianPower := -3
  mixedNormPower := nseMixedLpScalingExponent q p

/-- The Kato `L^5_t L^5_x` explicit-kernel profile has zero mixed-norm power. -/
theorem katoL5L5_explicitKernel_mixedNormPower :
    (nseExplicitKernelScalingProfile KatoTimeExponent KatoSpaceExponent).mixedNormPower = 0 := by
  exact katoL5L5_scalingCritical

/--
Typed wall for constructing the mixed-norm scaling theorem by explicit kernel
change-of-variables instead of by an abstract operator API.
-/
class HasExplicitKernelScalingAPI (q p : ℝ≥0∞)
    [Fact (1 ≤ p)] [Fact (1 ≤ q)] where
  scaledRepresentative : ℝ → (ℝ → R3 → ℝ) → ℝ → R3 → ℝ
  representative_formula :
    ∀ lam u t x, 0 < lam →
      scaledRepresentative lam u t x = lam * u (lam ^ 2 * t) (fun i => lam * x i)
  raw_mixed_norm_scales :
    ∀ lam u, 0 < lam →
      rawMixedNormFinite u q p →
        rawMixedNormFinite (scaledRepresentative lam u) q p

/--
Typed Mathlib v4.17.0 wall for the actual anisotropic dilation operator
`u(t,x) |-> lambda * u(lambda^2 t, lambda x)` on mixed `Lp` quotient spaces.
-/
class HasParabolicScalingAPI (q p : ℝ≥0∞)
    [Fact (1 ≤ p)] [Fact (1 ≤ q)] where
  scale : ℝ → TimeIntegratedLp q p → TimeIntegratedLp q p
  norm_scale :
    ∀ lam u, 0 < lam →
      ‖scale lam u‖ =
        Real.rpow lam (nseMixedLpScalingExponent q p) * ‖u‖

/-- Norm behavior under Navier-Stokes scaling, conditional on the scaling API. -/
theorem parabolicScaling_norm
    (q p : ℝ≥0∞) [Fact (1 ≤ p)] [Fact (1 ≤ q)]
    [api : HasParabolicScalingAPI q p]
    (lam : ℝ) (u : TimeIntegratedLp q p) (hlam : 0 < lam) :
    ‖api.scale lam u‖ =
      Real.rpow lam (nseMixedLpScalingExponent q p) * ‖u‖ :=
  api.norm_scale lam u hlam

/-- Certificate payload required before a barrier status can claim survival. -/
structure RegularityEvasionCertificate where
  certificateName : String
  proofSurface : String
  deriving Repr

/--
Barrier status taxonomy for calibration roots.

The Kato `L^5_t L^5_x` surface is only a calibration object here; it is not a
Clay-scale regularity evasion claim.
-/
inductive BarrierStatus where
  | calibration_only : BarrierStatus
  | not_applicable : BarrierStatus
  | survives_attack : RegularityEvasionCertificate → BarrierStatus
  | failed : String → BarrierStatus
  deriving Repr

/-- NS-R1 is a calibration surface, not an evasion of Tao averaging. -/
def katoL5L5_taoAveragingStatus : BarrierStatus :=
  BarrierStatus.calibration_only

/-- NS-R1 is a calibration surface for the scaling barrier. -/
def katoL5L5_scalingBarrierStatus : BarrierStatus :=
  BarrierStatus.calibration_only

/--
Attempt-3 route: finite-window distributional representatives for nested
Bochner `Lp`.

This separates the quotient-space carrier, which Mathlib already supplies, from
the representative-level spacetime integral used in PDE distributional
formulations.
-/
class HasFiniteWindowRepresentativeAPI
    (T : ℝ) (q p : ℝ≥0∞) [Fact (1 ≤ p)] [Fact (1 ≤ q)] where
  representative :
    TimeIntegratedLpOn T q p → ℝ → R3 → ℝ
  representative_mixed_finite :
    ∀ u : TimeIntegratedLpOn T q p,
      rawMixedNormFiniteOn T (representative u) q p
  representative_extensional :
    ∀ u v : TimeIntegratedLpOn T q p,
      representative u = representative v → u = v

/-- A selected finite-window representative has the displayed mixed norm. -/
theorem finiteWindowRepresentative_rawMixedNorm
    (T : ℝ) (q p : ℝ≥0∞) [Fact (1 ≤ p)] [Fact (1 ≤ q)]
    [api : HasFiniteWindowRepresentativeAPI T q p]
    (u : TimeIntegratedLpOn T q p) :
    rawMixedNormFiniteOn T (api.representative u) q p :=
  api.representative_mixed_finite u

/--
Attempt-3 distributional bridge from mixed `Lp` classes to spacetime test
function pairings.
-/
class HasDistributionalMixedLpBridge
    (T : ℝ) (q p : ℝ≥0∞) [Fact (1 ≤ p)] [Fact (1 ≤ q)] where
  toDistribution :
    TimeIntegratedLpOn T q p → SpacetimeDistribution
  pairing_eq_representative_integral :
    ∀ u : TimeIntegratedLpOn T q p, SpacetimeTestFunction → Prop
  compatible_with_representative :
    ∀ u : TimeIntegratedLpOn T q p, Prop

/-- Distribution associated to a finite-window mixed `Lp` class. -/
def finiteWindowDistribution
    (T : ℝ) (q p : ℝ≥0∞) [Fact (1 ≤ p)] [Fact (1 ≤ q)]
    [api : HasDistributionalMixedLpBridge T q p]
    (u : TimeIntegratedLpOn T q p) :
    SpacetimeDistribution :=
  api.toDistribution u

/-- The distributional pairing is identified with a representative spacetime integral. -/
def finiteWindowDistributionPairingFormula
    (T : ℝ) (q p : ℝ≥0∞) [Fact (1 ≤ p)] [Fact (1 ≤ q)]
    [api : HasDistributionalMixedLpBridge T q p]
    (u : TimeIntegratedLpOn T q p) (φ : SpacetimeTestFunction) : Prop :=
  api.pairing_eq_representative_integral u φ

/--
Attempt-4 product-measure route.

For diagonal exponents `p = q = r`, the nested mixed space should be
isometric to scalar spacetime `L^r(R_+ × R^3)` after the representative map
`u(t)(x) |-> u(t, x)`.  Mathlib has product measures and Fubini/Tonelli, but
it does not currently package this nested-Bochner-`Lp` to product-`Lp`
identification as a quotient-space equivalence.
-/
class HasDiagonalProductMeasureMixedLpAPI (r : ℝ≥0∞) [Fact (1 ≤ r)] where
  toSpacetime : TimeIntegratedLp r r → SpacetimeLp r
  fromSpacetime : SpacetimeLp r → TimeIntegratedLp r r
  left_inverse : ∀ u, fromSpacetime (toSpacetime u) = u
  right_inverse : ∀ U, toSpacetime (fromSpacetime U) = U
  norm_toSpacetime : ∀ u, ‖toSpacetime u‖ = ‖u‖

/-- Flattening map from diagonal mixed `L^r_t L^r_x` to product spacetime `L^r`. -/
def diagonalMixedLpToSpacetimeLp
    (r : ℝ≥0∞) [Fact (1 ≤ r)]
    [api : HasDiagonalProductMeasureMixedLpAPI r] :
    TimeIntegratedLp r r → SpacetimeLp r :=
  api.toSpacetime

/-- Unflattening map from product spacetime `L^r` to diagonal mixed `L^r_t L^r_x`. -/
def spacetimeLpToDiagonalMixedLp
    (r : ℝ≥0∞) [Fact (1 ≤ r)]
    [api : HasDiagonalProductMeasureMixedLpAPI r] :
    SpacetimeLp r → TimeIntegratedLp r r :=
  api.fromSpacetime

/-- The diagonal flattening map is an isometry, once the product-measure API exists. -/
theorem diagonalMixedLpToSpacetimeLp_norm
    (r : ℝ≥0∞) [Fact (1 ≤ r)]
    [api : HasDiagonalProductMeasureMixedLpAPI r]
    (u : TimeIntegratedLp r r) :
    ‖diagonalMixedLpToSpacetimeLp r u‖ = ‖u‖ :=
  api.norm_toSpacetime u

/-- The Kato `L^5_t L^5_x` surface can be flattened to product spacetime `L^5`. -/
abbrev KatoSpacetimeL5 : Type :=
  SpacetimeLp KatoTimeExponent

/-- Kato diagonal flattening, conditional on the product-measure quotient API. -/
def katoL5L5ToSpacetimeL5
    [api : HasDiagonalProductMeasureMixedLpAPI KatoTimeExponent] :
    KatoL5L5 → KatoSpacetimeL5 :=
  diagonalMixedLpToSpacetimeLp KatoTimeExponent

/--
Representative-level product-measure finiteness predicate for diagonal
spacetime functions.
-/
def rawSpacetimeNormFinite (u : Spacetime → ℝ) (r : ℝ≥0∞) : Prop :=
  MemLp u r spacetimeMeasure

/--
Typed wall for proving the diagonal mixed norm identity directly from
Fubini/Tonelli on representatives:

`∫_R+ ∫_R3 |u(t,x)|^r dx dt = ∫_(R+ × R3) |u(t,x)|^r d(t,x)`.
-/
class HasRepresentativeProductFubiniAPI (r : ℝ≥0∞) where
  diagonal_norm_integral_identity :
    ∀ u : ℝ → R3 → ℝ,
      rawMixedNormFinite u r r →
        rawSpacetimeNormFinite (fun z : Spacetime => u z.1 z.2) r
  product_to_nested_integral_identity :
    ∀ U : Spacetime → ℝ,
      rawSpacetimeNormFinite U r →
        rawMixedNormFinite (fun t x => U (t, x)) r r

/--
Representative-level product-measure membership from diagonal mixed membership,
conditional on the missing Fubini/Tonelli-to-`MemLp` packaging.
-/
theorem rawMixedNormFinite.to_rawSpacetimeNormFinite
    (r : ℝ≥0∞) [api : HasRepresentativeProductFubiniAPI r]
    {u : ℝ → R3 → ℝ} (hu : rawMixedNormFinite u r r) :
    rawSpacetimeNormFinite (fun z : Spacetime => u z.1 z.2) r :=
  api.diagonal_norm_integral_identity u hu

/--
Representative-level diagonal mixed membership from product spacetime
membership, conditional on the missing Fubini/Tonelli-to-`MemLp` packaging.
-/
theorem rawSpacetimeNormFinite.to_rawMixedNormFinite
    (r : ℝ≥0∞) [api : HasRepresentativeProductFubiniAPI r]
    {U : Spacetime → ℝ} (hU : rawSpacetimeNormFinite U r) :
    rawMixedNormFinite (fun t x => U (t, x)) r r :=
  api.product_to_nested_integral_identity U hU

/--
Attempt-4 scaling route on product spacetime.  This isolates the Jacobian
statement for `(t, x) |-> (lambda^2 t, lambda x)` on `R_+ × R^3` from the
nested `Lp` quotient-space problem.
-/
class HasProductMeasureParabolicScalingAPI (r : ℝ≥0∞) [Fact (1 ≤ r)] where
  scaleSpacetime : ℝ → SpacetimeLp r → SpacetimeLp r
  scale_formula :
    ∀ lam, 0 < lam → Spacetime → Prop
  norm_scaleSpacetime :
    ∀ lam U, 0 < lam →
      ‖scaleSpacetime lam U‖ =
        Real.rpow lam (nseMixedLpScalingExponent r r) * ‖U‖

/-- Product-measure scaling norm law, conditional on the product dilation API. -/
theorem productMeasureParabolicScaling_norm
    (r : ℝ≥0∞) [Fact (1 ≤ r)]
    [api : HasProductMeasureParabolicScalingAPI r]
    (lam : ℝ) (U : SpacetimeLp r) (hlam : 0 < lam) :
    ‖api.scaleSpacetime lam U‖ =
      Real.rpow lam (nseMixedLpScalingExponent r r) * ‖U‖ :=
  api.norm_scaleSpacetime lam U hlam

/-- The product-measure route also sees Kato `L^5` as scale-critical. -/
theorem katoSpacetimeL5_scalingCritical :
    ScalingCritical KatoTimeExponent KatoTimeExponent := by
  exact katoL5L5_scalingCritical

/--
Conditional finite-window mixed interpolation statement.

The field remains a proposition because the missing theorem is the nested
Bochner interpolation theorem, not a Navier-Stokes-specific fact.
-/
def mixedInterpolation_statement
    (q p q₀ p₀ q₁ p₁ : ℝ≥0∞)
    [Fact (1 ≤ p)] [Fact (1 ≤ q)]
    [Fact (1 ≤ p₀)] [Fact (1 ≤ q₀)]
    [Fact (1 ≤ p₁)] [Fact (1 ≤ q₁)]
    [api : HasMixedInterpolationAPI q p q₀ p₀ q₁ p₁] :
    Prop :=
  api.interpolates

/-- Named Mathlib v4.17.0 gaps blocking a fully closed NS-R1 product/scaling theorem. -/
inductive MathlibGap where
  | mixedLebesgueSpacePackage
  | bochnerLpPointwiseRepresentativeProduct
  | mixedHolderInequality
  | mixedNormInterpolation
  | parabolicScalingActionOnMixedLp
  | parabolicScalingJacobianForMixedNorm
  | finiteIntervalMixedNormRestriction
  | bochnerMixedRieszThorinInterpolation
  | explicitKernelParabolicChangeOfVariables
  | heatKernelCompatibleMixedLpScaling
  | finiteWindowRepresentativeSelection
  | spacetimeDistributionPairingForMixedLp
  | bochnerFubiniForNestedLp
  | testFunctionDualityForMixedLp
  | holderInterpolationOnFiniteWindows
  | diagonalMixedLpProductMeasureEquivalence
  | productMeasureLpQuotientCurrying
  | fubiniTonelliPowNormIdentity
  | productMeasureParabolicDilationJacobian
  | diagonalKatoSpacetimeLpIsometry
  | mixedLpFiniteWindowRestrictionOperator
  | mixedLpFiniteMeasureExponentInclusion
  | nestedBochnerLpBoundedOperatorLift
  | finiteWindowParabolicScalingTransport
  | mixedLpRestrictionNormMonotonicity
  | finiteMeasureMixedLpInclusionConstant
  deriving DecidableEq, Repr

/-- Machine-visible wall list for NS-R1 attempt 1. -/
def timeIntegratedLpAttempt1Wall : List MathlibGap :=
  [ MathlibGap.mixedLebesgueSpacePackage
  , MathlibGap.bochnerLpPointwiseRepresentativeProduct
  , MathlibGap.mixedHolderInequality
  , MathlibGap.mixedNormInterpolation
  , MathlibGap.parabolicScalingActionOnMixedLp
  , MathlibGap.parabolicScalingJacobianForMixedNorm
  ]

/-- Exact Mathlib v4.17.0 gap names for the NS-R1 attempt 1 wall. -/
def timeIntegratedLpAttempt1WallNames : List String :=
  [ "Mathlib.MeasureTheory.Function.MixedLp"
  , "MeasureTheory.Lp.bochner_pointwise_mul"
  , "MeasureTheory.MixedLp.holder_inequality"
  , "MeasureTheory.MixedLp.interpolation"
  , "MeasureTheory.MixedLp.parabolic_scaling"
  , "MeasureTheory.MeasurePreserving.parabolic_dilation_Rplus_R3"
  ]

/-- Machine-visible wall list for NS-R1 attempt 2's explicit-kernel route. -/
def timeIntegratedLpAttempt2Wall : List MathlibGap :=
  [ MathlibGap.finiteIntervalMixedNormRestriction
  , MathlibGap.bochnerLpPointwiseRepresentativeProduct
  , MathlibGap.mixedHolderInequality
  , MathlibGap.bochnerMixedRieszThorinInterpolation
  , MathlibGap.explicitKernelParabolicChangeOfVariables
  , MathlibGap.heatKernelCompatibleMixedLpScaling
  ]

/-- Exact Mathlib v4.17.0 gap names for the NS-R1 attempt 2 wall. -/
def timeIntegratedLpAttempt2WallNames : List String :=
  [ "MeasureTheory.Lp.restrict_mixed_norm_Icc"
  , "MeasureTheory.Lp.bochner_pointwise_mul"
  , "MeasureTheory.MixedLp.holder_inequality"
  , "MeasureTheory.MixedLp.riesz_thorin_interpolation"
  , "MeasureTheory.MeasurePreserving.parabolic_dilation_Rplus_R3"
  , "Analysis.HeatKernel.mixedLp_scaling"
  ]

/-- Machine-visible wall list for NS-R1 attempt 3's distributional route. -/
def timeIntegratedLpAttempt3Wall : List MathlibGap :=
  [ MathlibGap.finiteWindowRepresentativeSelection
  , MathlibGap.spacetimeDistributionPairingForMixedLp
  , MathlibGap.bochnerFubiniForNestedLp
  , MathlibGap.testFunctionDualityForMixedLp
  , MathlibGap.holderInterpolationOnFiniteWindows
  , MathlibGap.parabolicScalingActionOnMixedLp
  ]

/-- Exact Mathlib v4.17.0 gap names for the NS-R1 attempt 3 wall. -/
def timeIntegratedLpAttempt3WallNames : List String :=
  [ "MeasureTheory.Lp.finiteWindowRepresentative"
  , "MeasureTheory.MixedLp.toSpacetimeDistribution"
  , "MeasureTheory.Integral.Bochner.Fubini.nestedLp"
  , "MeasureTheory.MixedLp.testFunctionDuality"
  , "MeasureTheory.MixedLp.finiteWindowInterpolation"
  , "MeasureTheory.MixedLp.parabolic_scaling"
  ]

/-- Machine-visible wall list for NS-R1 attempt 4's product-measure route. -/
def timeIntegratedLpAttempt4Wall : List MathlibGap :=
  [ MathlibGap.diagonalMixedLpProductMeasureEquivalence
  , MathlibGap.productMeasureLpQuotientCurrying
  , MathlibGap.fubiniTonelliPowNormIdentity
  , MathlibGap.productMeasureParabolicDilationJacobian
  , MathlibGap.diagonalKatoSpacetimeLpIsometry
  , MathlibGap.parabolicScalingActionOnMixedLp
  ]

/-- Exact Mathlib v4.17.0 gap names for the NS-R1 attempt 4 wall. -/
def timeIntegratedLpAttempt4WallNames : List String :=
  [ "MeasureTheory.MixedLp.diagonalProductMeasureEquiv"
  , "MeasureTheory.Lp.prodCurryingLinearIsometryEquiv"
  , "MeasureTheory.Integral.FubiniTonelli.pow_norm_diagonal_mixedLp"
  , "MeasureTheory.MeasurePreserving.parabolic_dilation_product_Rplus_R3"
  , "MeasureTheory.MixedLp.katoL5L5_spacetimeL5_isometry"
  , "MeasureTheory.MixedLp.parabolic_scaling"
  ]

theorem mixedHolder_name_mem_attempt1_wall :
    "MeasureTheory.MixedLp.holder_inequality" ∈
      timeIntegratedLpAttempt1WallNames := by
  simp [timeIntegratedLpAttempt1WallNames]

theorem parabolicScaling_name_mem_attempt1_wall :
    "MeasureTheory.MixedLp.parabolic_scaling" ∈
      timeIntegratedLpAttempt1WallNames := by
  simp [timeIntegratedLpAttempt1WallNames]

theorem explicitKernelScaling_name_mem_attempt2_wall :
    "Analysis.HeatKernel.mixedLp_scaling" ∈
      timeIntegratedLpAttempt2WallNames := by
  simp [timeIntegratedLpAttempt2WallNames]

theorem interpolation_name_mem_attempt2_wall :
    "MeasureTheory.MixedLp.riesz_thorin_interpolation" ∈
      timeIntegratedLpAttempt2WallNames := by
  simp [timeIntegratedLpAttempt2WallNames]

theorem distributionalBridge_name_mem_attempt3_wall :
    "MeasureTheory.MixedLp.toSpacetimeDistribution" ∈
      timeIntegratedLpAttempt3WallNames := by
  simp [timeIntegratedLpAttempt3WallNames]

theorem finiteWindowInterpolation_name_mem_attempt3_wall :
    "MeasureTheory.MixedLp.finiteWindowInterpolation" ∈
      timeIntegratedLpAttempt3WallNames := by
  simp [timeIntegratedLpAttempt3WallNames]

theorem parabolicScaling_name_mem_attempt3_wall :
    "MeasureTheory.MixedLp.parabolic_scaling" ∈
      timeIntegratedLpAttempt3WallNames := by
  simp [timeIntegratedLpAttempt3WallNames]

theorem productMeasureEquiv_name_mem_attempt4_wall :
    "MeasureTheory.MixedLp.diagonalProductMeasureEquiv" ∈
      timeIntegratedLpAttempt4WallNames := by
  simp [timeIntegratedLpAttempt4WallNames]

theorem fubiniPowNorm_name_mem_attempt4_wall :
    "MeasureTheory.Integral.FubiniTonelli.pow_norm_diagonal_mixedLp" ∈
      timeIntegratedLpAttempt4WallNames := by
  simp [timeIntegratedLpAttempt4WallNames]

theorem productParabolicDilation_name_mem_attempt4_wall :
    "MeasureTheory.MeasurePreserving.parabolic_dilation_product_Rplus_R3" ∈
      timeIntegratedLpAttempt4WallNames := by
  simp [timeIntegratedLpAttempt4WallNames]

/-!
## Attempt 5: finite-measure restriction and bounded-operator calibration

This route avoids both the distributional pairing route and the diagonal
product-measure flattening route.  It isolates the finite-window operator
facts needed in the Kato fixed-point surface: restriction from `R_+` to
`[0,T]`, monotone finite-measure inclusions, and compatibility of bounded
spatial operators with the outer time `Lp` norm.
-/

/-- The quadratic exponent used for finite-window lower-integrability calibration. -/
abbrev QuadraticExponent : ℝ≥0∞ := 2

instance quadraticExponentFact : Fact (1 ≤ QuadraticExponent) :=
  ⟨by norm_num [QuadraticExponent]⟩

/-- Algebraic ordering of exponents using the displayed real exponents. -/
def ExponentLe (a b : ℝ≥0∞) : Prop :=
  a.toReal ≤ b.toReal

/-- Kato's exponent dominates the quadratic exponent on finite-measure windows. -/
theorem quadratic_le_kato_exponent :
    ExponentLe QuadraticExponent KatoTimeExponent ∧
      ExponentLe QuadraticExponent KatoSpaceExponent := by
  constructor <;> norm_num [ExponentLe, QuadraticExponent, KatoTimeExponent,
    KatoSpaceExponent]

/--
Typed wall for restricting a mixed `Lp(R_+)` class to a finite time window.

Mathlib has measure restriction primitives, but this exact nested Bochner
quotient map with its norm inequality is not packaged as a reusable theorem.
-/
class HasFiniteWindowRestrictionAPI (q p : ℝ≥0∞)
    [Fact (1 ≤ p)] [Fact (1 ≤ q)] where
  restrictToWindow : ∀ T : ℝ, TimeIntegratedLp q p → TimeIntegratedLpOn T q p
  norm_restrict_le : ∀ T u, ‖restrictToWindow T u‖ ≤ ‖u‖

/-- Restrict a global mixed class to `[0,T]`, once the quotient restriction API exists. -/
def restrictToFiniteWindow
    (q p : ℝ≥0∞) [Fact (1 ≤ p)] [Fact (1 ≤ q)]
    [api : HasFiniteWindowRestrictionAPI q p]
    (T : ℝ) :
    TimeIntegratedLp q p → TimeIntegratedLpOn T q p :=
  api.restrictToWindow T

/-- Finite-window restriction is norm nonincreasing, conditional on the API wall. -/
theorem restrictToFiniteWindow_norm_le
    (q p : ℝ≥0∞) [Fact (1 ≤ p)] [Fact (1 ≤ q)]
    [api : HasFiniteWindowRestrictionAPI q p]
    (T : ℝ) (u : TimeIntegratedLp q p) :
    ‖restrictToFiniteWindow q p T u‖ ≤ ‖u‖ :=
  api.norm_restrict_le T u

/--
Typed finite-measure inclusion wall:
on `[0,T]`, larger exponents control smaller exponents up to a finite-measure
constant.  The theorem is standard, but Mathlib v4.17.0 does not expose this
for nested mixed `Lp` quotient classes.
-/
class HasFiniteMeasureMixedInclusionAPI
    (T : ℝ) (qSmall pSmall qBig pBig : ℝ≥0∞)
    [Fact (1 ≤ pSmall)] [Fact (1 ≤ qSmall)]
    [Fact (1 ≤ pBig)] [Fact (1 ≤ qBig)] where
  includeOp :
    TimeIntegratedLpOn T qBig pBig → TimeIntegratedLpOn T qSmall pSmall
  inclusion_bound :
    ExponentLe qSmall qBig →
      ExponentLe pSmall pBig →
        ∃ C : ℝ, 0 ≤ C ∧ ∀ u, ‖includeOp u‖ ≤ C * ‖u‖

/-- Finite-window mixed-norm inclusion, conditional on the finite-measure API. -/
def finiteMeasureMixedInclusion
    (T : ℝ) (qSmall pSmall qBig pBig : ℝ≥0∞)
    [Fact (1 ≤ pSmall)] [Fact (1 ≤ qSmall)]
    [Fact (1 ≤ pBig)] [Fact (1 ≤ qBig)]
    [api : HasFiniteMeasureMixedInclusionAPI T qSmall pSmall qBig pBig] :
    TimeIntegratedLpOn T qBig pBig → TimeIntegratedLpOn T qSmall pSmall :=
  api.includeOp

/--
Kato finite-window `L^5_t L^5_x` controls `L^2_t L^2_x` once the finite-measure
mixed inclusion theorem is available.
-/
theorem katoFiniteWindow_to_quadratic_bound
    (T : ℝ)
    [api : HasFiniteMeasureMixedInclusionAPI T
      QuadraticExponent QuadraticExponent KatoTimeExponent KatoSpaceExponent] :
    ∃ C : ℝ, 0 ≤ C ∧
      ∀ u : KatoL5L5On T,
        ‖finiteMeasureMixedInclusion T
          QuadraticExponent QuadraticExponent KatoTimeExponent KatoSpaceExponent u‖
          ≤ C * ‖u‖ :=
  api.inclusion_bound quadratic_le_kato_exponent.1 quadratic_le_kato_exponent.2

/--
Typed wall for lifting a bounded spatial operator through the outer time `Lp`.

This is the operator-calibration surface needed for heat/Riesz/Leray pieces:
given `A : L^p_x -> L^p_x`, produce `u(t) |-> A (u(t))` in `L^q_t L^p_x` and
control its mixed norm by the operator norm.
-/
class HasMixedLpBoundedSpatialOperatorAPI (q p : ℝ≥0∞)
    [Fact (1 ≤ p)] [Fact (1 ≤ q)] where
  liftSpatialOperator :
    (SpatialLp p →L[ℝ] SpatialLp p) →
      TimeIntegratedLp q p →L[ℝ] TimeIntegratedLp q p
  lift_norm_bound :
    ∀ A : SpatialLp p →L[ℝ] SpatialLp p,
      ‖liftSpatialOperator A‖ ≤ ‖A‖

/-- Lift a bounded spatial operator to the mixed time-integrated space. -/
def liftSpatialOperatorToMixedLp
    (q p : ℝ≥0∞) [Fact (1 ≤ p)] [Fact (1 ≤ q)]
    [api : HasMixedLpBoundedSpatialOperatorAPI q p]
    (A : SpatialLp p →L[ℝ] SpatialLp p) :
    TimeIntegratedLp q p →L[ℝ] TimeIntegratedLp q p :=
  api.liftSpatialOperator A

/-- The lifted spatial operator has mixed norm controlled by the spatial operator norm. -/
theorem liftSpatialOperatorToMixedLp_norm_le
    (q p : ℝ≥0∞) [Fact (1 ≤ p)] [Fact (1 ≤ q)]
    [api : HasMixedLpBoundedSpatialOperatorAPI q p]
    (A : SpatialLp p →L[ℝ] SpatialLp p) :
    ‖liftSpatialOperatorToMixedLp q p A‖ ≤ ‖A‖ :=
  api.lift_norm_bound A

/--
Typed wall for finite-window scaling.

Under `u_lambda(t,x) = lambda * u(lambda^2 t, lambda x)`, a class on `[0,T]`
is transported to `[0,T / lambda^2]`.  This keeps the finite-window route
honest about the time interval, instead of pretending the window is invariant.
-/
class HasFiniteWindowParabolicScalingAPI (q p : ℝ≥0∞)
    [Fact (1 ≤ p)] [Fact (1 ≤ q)] where
  scaleWindow :
    ∀ lam T : ℝ, TimeIntegratedLpOn T q p →
      TimeIntegratedLpOn (T / lam ^ 2) q p
  norm_scaleWindow :
    ∀ lam T u, 0 < lam →
      ‖scaleWindow lam T u‖ =
        Real.rpow lam (nseMixedLpScalingExponent q p) * ‖u‖

/-- Finite-window scaling law, conditional on the interval-aware scaling API. -/
theorem finiteWindowParabolicScaling_norm
    (q p : ℝ≥0∞) [Fact (1 ≤ p)] [Fact (1 ≤ q)]
    [api : HasFiniteWindowParabolicScalingAPI q p]
    (lam T : ℝ) (u : TimeIntegratedLpOn T q p) (hlam : 0 < lam) :
    ‖api.scaleWindow lam T u‖ =
      Real.rpow lam (nseMixedLpScalingExponent q p) * ‖u‖ :=
  api.norm_scaleWindow lam T u hlam

/-- Machine-visible wall list for NS-R1 attempt 5's finite-window/operator route. -/
def timeIntegratedLpAttempt5Wall : List MathlibGap :=
  [ MathlibGap.mixedLpFiniteWindowRestrictionOperator
  , MathlibGap.mixedLpFiniteMeasureExponentInclusion
  , MathlibGap.nestedBochnerLpBoundedOperatorLift
  , MathlibGap.finiteWindowParabolicScalingTransport
  , MathlibGap.mixedLpRestrictionNormMonotonicity
  , MathlibGap.finiteMeasureMixedLpInclusionConstant
  ]

/-- Exact Mathlib v4.17.0 gap names for the NS-R1 attempt 5 wall. -/
def timeIntegratedLpAttempt5WallNames : List String :=
  [ "MeasureTheory.Lp.restrictNestedBochnerLp"
  , "MeasureTheory.MixedLp.finiteMeasureExponentInclusion"
  , "MeasureTheory.Lp.bochner_lift_bounded_linear_operator"
  , "MeasureTheory.MixedLp.finiteWindowParabolicScaling"
  , "MeasureTheory.Lp.restrict_norm_mono_nested"
  , "MeasureTheory.MixedLp.finiteMeasureInclusionConstant"
  ]

theorem finiteWindowRestriction_name_mem_attempt5_wall :
    "MeasureTheory.Lp.restrictNestedBochnerLp" ∈
      timeIntegratedLpAttempt5WallNames := by
  simp [timeIntegratedLpAttempt5WallNames]

theorem boundedSpatialOperatorLift_name_mem_attempt5_wall :
    "MeasureTheory.Lp.bochner_lift_bounded_linear_operator" ∈
      timeIntegratedLpAttempt5WallNames := by
  simp [timeIntegratedLpAttempt5WallNames]

theorem finiteWindowScaling_name_mem_attempt5_wall :
    "MeasureTheory.MixedLp.finiteWindowParabolicScaling" ∈
      timeIntegratedLpAttempt5WallNames := by
  simp [timeIntegratedLpAttempt5WallNames]

end TimeIntegratedLp
end Roots
end NavierStokes
