import Mathlib.Data.Rat.Cardinal
import Mathlib.Data.Real.Cardinality
import Mathlib.Topology.ContinuousMap.Basic
import Mathlib.Topology.Instances.Rat

noncomputable section

open Cardinal

namespace MathlibExpansion
namespace Topology
namespace ContinuousMap

/-- Restriction of a continuous real function to the dense subset `ℚ`. -/
def restrictRat : C(ℝ, ℝ) → (ℚ → ℝ) :=
  fun f q => f q

/-- Constant continuous real functions give a continuum-sized subfamily. -/
def constContinuous : ℝ → C(ℝ, ℝ) :=
  fun r => ContinuousMap.const ℝ r

theorem restrictRat_injective : Function.Injective restrictRat := by
  intro f g hfg
  ext x
  exact congr_fun
    (Rat.denseRange_cast.equalizer f.continuous g.continuous
      (by simpa [restrictRat, Function.comp] using hfg)) x

theorem constContinuous_injective : Function.Injective constContinuous := by
  intro r s hrs
  have h0 : constContinuous r 0 = constContinuous s 0 := congrArg (fun f : C(ℝ, ℝ) => f 0) hrs
  simpa [constContinuous] using h0

/-- Upstream-narrow cardinality of the ambient function space `(ℚ → ℝ)`. -/
theorem mk_rat_arrow_real : #(ℚ → ℝ) = Cardinal.mk ℝ := by
  rw [mk_arrow, Cardinal.mkRat]
  simpa [Cardinal.mk_real, lift_aleph0, lift_continuum] using
    (continuum_power_aleph0 : 𝔠 ^ ℵ₀ = 𝔠)

/--
The set of continuous real-valued real functions has cardinality continuum.
Hausdorff's dense-subset argument appears here as the injective restriction to
`ℚ`.
-/
theorem mk_continuousMap_real_real : #(C(ℝ, ℝ)) = Cardinal.mk ℝ := by
  apply le_antisymm
  · calc
      #(C(ℝ, ℝ)) ≤ #(ℚ → ℝ) := Cardinal.mk_le_of_injective restrictRat_injective
      _ = Cardinal.mk ℝ := mk_rat_arrow_real
  · exact Cardinal.mk_le_of_injective constContinuous_injective

end ContinuousMap
end Topology
end MathlibExpansion
