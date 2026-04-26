import Mathlib

/-!
# Pressure bridge into `L^{3/2}`

This file closes the Mathlib-available part of NS-R2: scalar component products
belong to `L^{3/2}` when both factors are in `L^3`, with the sharp Holder
constant inherited from Mathlib's `eLpNorm` Holder inequality.

The Navier-Stokes pressure reconstruction itself is represented by the
`HasCalderonZygmundL32API` structure.  Mathlib v4.17.0 does not package the
Riesz-transform / Calderon-Zygmund pressure operator on `L^{3/2}(R^3)`, so the
primitive is kept as an explicit typeclass parameter rather than as a global assumption.
-/

noncomputable section

open MeasureTheory
open scoped ENNReal NNReal

namespace NavierStokes
namespace Roots
namespace PressureBridgeL32

abbrev Space := Fin 3 → ℝ
abbrev Vec3 := Fin 3 → ℝ
abbrev Tensor3 := Fin 3 → Fin 3 → ℝ
abbrev Time := ℝ≥0

abbrev L3 : ℝ≥0∞ := 3
abbrev L32 : ℝ≥0∞ := 3 / 2

instance holderTriple_three_three_threeHalves :
    ENNReal.HolderTriple L3 L3 L32 where
  inv_add_inv' := by
    apply ENNReal.eq_inv_of_mul_eq_one_left
    rw [add_mul]
    have hterm : (3⁻¹ : ℝ≥0∞) * (3 / 2 : ℝ≥0∞) = 2⁻¹ := by
      rw [mul_comm]
      rw [div_eq_mul_inv]
      rw [mul_right_comm]
      rw [ENNReal.mul_inv_cancel]
      · simp
      · exact three_ne_zero
      · exact ENNReal.ofNat_ne_top
    rw [hterm]
    exact ENNReal.inv_two_add_inv_two

/-- Scalar Holder bridge: `f g ∈ L^3` implies `f * g ∈ L^{3/2}`. -/
theorem componentProduct_memLp_threeHalves
    {α : Type*} [MeasurableSpace α] {μ : Measure α}
    {f g : α → ℝ}
    (hf : MemLp f L3 μ) (hg : MemLp g L3 μ) :
    MemLp (fun x => g x * f x) L32 μ :=
  hf.mul' hg

/-- Norm form of the scalar Holder bridge. -/
theorem componentProduct_norm_le
    {α : Type*} [MeasurableSpace α] {μ : Measure α}
    {f g : α → ℝ}
    (hf : MemLp f L3 μ) (hg : MemLp g L3 μ) :
    ‖((componentProduct_memLp_threeHalves hf hg).toLp
        (fun x => g x * f x))‖
      ≤ ‖hf.toLp f‖ * ‖hg.toLp g‖ := by
  rw [Lp.norm_toLp, Lp.norm_toLp, Lp.norm_toLp]
  have h_e :
      eLpNorm (fun x => g x * f x) L32 μ
        ≤ eLpNorm g L3 μ * eLpNorm f L3 μ := by
    simpa [L3, L32, one_mul] using
      (eLpNorm_le_eLpNorm_mul_eLpNorm'_of_norm
        hg.1 hf.1 (fun a b : ℝ => a * b) 1
        (Filter.Eventually.of_forall fun _ => by
          simp [norm_mul, mul_assoc]) :
        eLpNorm (fun x => g x * f x) L32 μ
          ≤ (1 : ℝ≥0∞) * eLpNorm g L3 μ * eLpNorm f L3 μ)
  have h_top :
      eLpNorm g L3 μ * eLpNorm f L3 μ ≠ ∞ :=
    ENNReal.mul_ne_top hg.eLpNorm_ne_top hf.eLpNorm_ne_top
  calc
    (eLpNorm (fun x => g x * f x) L32 μ).toReal
        ≤ (eLpNorm g L3 μ * eLpNorm f L3 μ).toReal :=
          ENNReal.toReal_mono h_top h_e
    _ = (eLpNorm f L3 μ).toReal * (eLpNorm g L3 μ).toReal := by
          rw [ENNReal.toReal_mul, mul_comm]

/-- A component of a vector-valued `L^3` field is scalar `L^3`. -/
theorem vectorComponent_memLp_L3
    {α : Type*} [MeasurableSpace α] {μ : Measure α}
    {u : α → Vec3} (hu : MemLp u L3 μ) (i : Fin 3) :
    MemLp (fun x => u x i) L3 μ := by
  refine hu.mono ?_ ?_
  · exact
      ((ContinuousLinearMap.proj (R := ℝ) (φ := fun _ : Fin 3 => ℝ) i).continuous
        |>.comp_aestronglyMeasurable hu.aestronglyMeasurable)
  · filter_upwards with x
    exact norm_le_pi_norm (u x) i

/-- The `L^3` norm of a scalar component is bounded by the vector-valued `L^3` norm. -/
theorem vectorComponent_norm_le
    {α : Type*} [MeasurableSpace α] {μ : Measure α}
    {u : α → Vec3} (hu : MemLp u L3 μ) (i : Fin 3) :
    ‖(vectorComponent_memLp_L3 hu i).toLp (fun x => u x i)‖ ≤ ‖hu.toLp u‖ := by
  rw [Lp.norm_toLp, Lp.norm_toLp]
  have hle : eLpNorm (fun x => u x i) L3 μ ≤ eLpNorm u L3 μ :=
    eLpNorm_mono_ae (by
      filter_upwards with x
      exact norm_le_pi_norm (u x) i)
  exact ENNReal.toReal_mono hu.eLpNorm_ne_top hle

/--
Vector-field Holder bridge: for `u : α → ℝ³` in `L^3`, each product
`u_i u_j` belongs to `L^{3/2}`.
-/
theorem vectorComponentProduct_memLp_threeHalves
    {α : Type*} [MeasurableSpace α] {μ : Measure α}
    {u : α → Vec3} (hu : MemLp u L3 μ) (i j : Fin 3) :
    MemLp (fun x => u x i * u x j) L32 μ :=
  componentProduct_memLp_threeHalves
    (vectorComponent_memLp_L3 hu j)
    (vectorComponent_memLp_L3 hu i)

/--
Norm form for the vector-field Holder bridge:
`‖u_i u_j‖_{L^{3/2}} ≤ ‖u‖_{L^3}^2`.
-/
theorem vectorComponentProduct_norm_le
    {α : Type*} [MeasurableSpace α] {μ : Measure α}
    {u : α → Vec3} (hu : MemLp u L3 μ) (i j : Fin 3) :
    ‖(vectorComponentProduct_memLp_threeHalves hu i j).toLp
        (fun x => u x i * u x j)‖
      ≤ ‖hu.toLp u‖ * ‖hu.toLp u‖ := by
  calc
    ‖(vectorComponentProduct_memLp_threeHalves hu i j).toLp
        (fun x => u x i * u x j)‖
        ≤ ‖(vectorComponent_memLp_L3 hu j).toLp (fun x => u x j)‖
          * ‖(vectorComponent_memLp_L3 hu i).toLp (fun x => u x i)‖ :=
            componentProduct_norm_le
              (vectorComponent_memLp_L3 hu j)
              (vectorComponent_memLp_L3 hu i)
    _ ≤ ‖hu.toLp u‖ * ‖hu.toLp u‖ := by
          exact mul_le_mul
            (vectorComponent_norm_le hu j)
            (vectorComponent_norm_le hu i)
            (by
              rw [Lp.norm_toLp]
              exact ENNReal.toReal_nonneg)
            (by
              rw [Lp.norm_toLp]
              exact ENNReal.toReal_nonneg)

/--
Kato `L^3` velocity represented componentwise.  This keeps the NS-R2 root on
the scalar Holder bridge that Mathlib can currently close.
-/
structure KatoL3Velocity where
  component : Fin 3 → Space → ℝ
  component_memLp : ∀ i, MemLp (component i) L3 volume

/-- Build the componentwise Kato velocity surface from a vector-valued `L^3` field. -/
def KatoL3Velocity.ofVector (u : Space → Vec3)
    (hu : MemLp u L3 (volume : Measure Space)) : KatoL3Velocity where
  component := fun i x => u x i
  component_memLp := vectorComponent_memLp_L3 hu

/-- The component tensor `u_i u_j`, typed in `L^{3/2}` by the closed Holder step. -/
def uTensorUComponent (u : KatoL3Velocity) (i j : Fin 3) :
    Lp ℝ L32 (volume : Measure Space) :=
  (componentProduct_memLp_threeHalves
      (u.component_memLp j) (u.component_memLp i)).toLp
    (fun x => u.component i x * u.component j x)

theorem uTensorU_norm_le (u : KatoL3Velocity) (i j : Fin 3) :
    ‖uTensorUComponent u i j‖
      ≤ ‖(u.component_memLp j).toLp (u.component j)‖
        * ‖(u.component_memLp i).toLp (u.component i)‖ :=
  componentProduct_norm_le (u.component_memLp j) (u.component_memLp i)

/--
The nine component products as already-typed `L^{3/2}` scalar fields.  This is
the operator-oriented attempt-5 surface: pressure reconstruction can consume
the component family directly, without first bundling it into a tensor-valued
`Lp` object.
-/
def uTensorUComponents (u : KatoL3Velocity) :
    Fin 3 → Fin 3 → Lp ℝ L32 (volume : Measure Space) :=
  fun i j => uTensorUComponent u i j

theorem uTensorUComponents_norm_le (u : KatoL3Velocity) (i j : Fin 3) :
    ‖uTensorUComponents u i j‖
      ≤ ‖(u.component_memLp j).toLp (u.component j)‖
        * ‖(u.component_memLp i).toLp (u.component i)‖ :=
  uTensorU_norm_le u i j

/--
Typed honest wall for bundling the nine scalar component products into one
`Lp Tensor3 L32 volume` object.  The scalar Holder proof above supplies each
component; Mathlib still lacks the convenient finite-dimensional vector-valued
`Lp` bundling API needed to construct this object without extra plumbing.
-/
class HasBundledTensorL32API where
  uTensorU : KatoL3Velocity → Lp Tensor3 L32 (volume : Measure Space)
  component_agrees : Prop

/-- Bundled tensor product, available once the finite-dimensional `Lp` API is supplied. -/
def uTensorU [api : HasBundledTensorL32API] (u : KatoL3Velocity) :
    Lp Tensor3 L32 (volume : Measure Space) :=
  api.uTensorU u

structure KatoMildSolution where
  velocity : Time → KatoL3Velocity
  stronglyMeasurable_components :
    ∀ i, StronglyMeasurable fun t : Time => (velocity t).component i
  kato_mild_formula : Prop

/--
Typed honest wall for the missing Mathlib v4.17.0 pressure reconstruction API:
the double Riesz-transform / Calderon-Zygmund operator mapping
`∂ᵢ∂ⱼ (-Δ)⁻¹ (u_i u_j)` from tensor components in `L^{3/2}` to pressure in
`L^{3/2}`.
-/
class HasCalderonZygmundL32API where
  pressureFromTensor :
    Lp Tensor3 L32 (volume : Measure Space) →
      Lp ℝ L32 (volume : Measure Space)
  pressure_bound : Prop
  distributional_secondDerivative_identity : Prop

/-- Pressure reconstructed from the typed Calderon-Zygmund primitive. -/
def pressureOf [HasBundledTensorL32API] [cz : HasCalderonZygmundL32API]
    (u : KatoMildSolution) (t : Time) :
    Lp ℝ L32 (volume : Measure Space) :=
  cz.pressureFromTensor (uTensorU (u.velocity t))

/--
Attempt-5 componentwise pressure primitive.  This records the narrower remaining
Mathlib gap: the finite sum of double Riesz transforms
`-∑ᵢⱼ Rᵢ Rⱼ (uᵢ uⱼ)` as a bounded operator from nine scalar
`L^{3/2}` inputs to scalar `L^{3/2}` pressure.
-/
class HasComponentwiseCalderonZygmundL32API where
  pressureFromComponents :
    (Fin 3 → Fin 3 → Lp ℝ L32 (volume : Measure Space)) →
      Lp ℝ L32 (volume : Measure Space)
  componentwise_pressure_bound : Prop
  componentwise_distributional_identity : Prop

/--
Pressure reconstructed directly from the nine closed Holder component products.
This route avoids using the bundled tensor `Lp` wall; it still honestly depends
on the absent componentwise Calderon-Zygmund/Riesz-transform API.
-/
def pressureOfComponentwise [cz : HasComponentwiseCalderonZygmundL32API]
    (u : KatoMildSolution) (t : Time) :
    Lp ℝ L32 (volume : Measure Space) :=
  cz.pressureFromComponents (uTensorUComponents (u.velocity t))

/--
Attempt-2 distributional pressure primitive.  This is intentionally different
from the bundled-tensor and componentwise-operator routes: it names the missing
Mathlib boundary as the distributional solution operator for
`-Δ p = ∂ᵢ∂ⱼ (uᵢuⱼ)`, with the Calderon-Zygmund `L^{3/2}` estimate included
as part of the typed API.
-/
class HasDistributionalPressureL32API where
  pressureFromDistributionalSecondDerivatives :
    (Fin 3 → Fin 3 → Lp ℝ L32 (volume : Measure Space)) →
      Lp ℝ L32 (volume : Measure Space)
  distributional_poisson_identity : Prop
  calderon_zygmund_l32_bound : Prop

/--
Pressure reconstructed via the distributional Poisson equation
`-Δ p = ∂ᵢ∂ⱼ (uᵢuⱼ)`.  The input products are exactly the closed Holder
objects `uTensorUComponents`.
-/
def pressureOfDistributional [dp : HasDistributionalPressureL32API]
    (u : KatoMildSolution) (t : Time) :
    Lp ℝ L32 (volume : Measure Space) :=
  dp.pressureFromDistributionalSecondDerivatives
    (uTensorUComponents (u.velocity t))

end PressureBridgeL32
end Roots
end NavierStokes
