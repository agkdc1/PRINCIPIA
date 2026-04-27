import Mathlib

noncomputable section

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Banach1932
namespace OpenMapping

open Filter Topology

variable {𝕜 E F : Type*}
variable [NontriviallyNormedField 𝕜]
variable [NormedAddCommGroup E] [NormedSpace 𝕜 E] [CompleteSpace E]
variable [NormedAddCommGroup F] [NormedSpace 𝕜 F] [CompleteSpace F]

/--
Deferred Banach `1932` wrapper, Stefan Banach, *Théorie des opérations linéaires*, Ch. III §3,
Théorème 3, p. 51: the range of a continuous linear map between Banach's `F`-spaces is either
meagre or all of the codomain. Banach later points back to the same Chapter III inversion package
and, in his 1931 note *Über metrische Gruppen*, extends the same cluster to separable type `(G)`
spaces.
-/
axiom range_meagre_or_eq_top (f : E →L[𝕜] F) :
    IsMeagre (Set.range f) ∨ LinearMap.range f.toLinearMap = ⊤

/--
Banach `1932` wrapper, Stefan Banach, *Théorie des opérations linéaires*, Ch. III §3, Théorème 4,
p. 53: a convergent target sequence lifting through a surjective continuous linear map can be
realized by a convergent source sequence. This follows from Mathlib's modern Banach open mapping
theorem, via `ContinuousLinearMap.exists_preimage_norm_le`.
-/
theorem exists_tendsto_lift_of_surjective (f : E →L[𝕜] F) (hsurj : Function.Surjective f)
    {u : ℕ → F} {x₀ : E} (hu : Tendsto u atTop (𝓝 (f x₀))) :
    ∃ v : ℕ → E, Tendsto v atTop (𝓝 x₀) ∧ ∀ n : ℕ, f (v n) = u n := by
  rcases ContinuousLinearMap.exists_preimage_norm_le f hsurj with ⟨C, _hCpos, hC⟩
  choose w hw using fun n : ℕ => hC (u n - f x₀)
  refine ⟨fun n => x₀ + w n, ?_, ?_⟩
  · have hconst : Tendsto (fun _ : ℕ => f x₀) atTop (𝓝 (f x₀)) := tendsto_const_nhds
    have hy : Tendsto (fun n : ℕ => u n - f x₀) atTop (𝓝 0) := by
      simpa using hu.sub hconst
    have hw_zero : Tendsto w atTop (𝓝 0) := by
      rw [tendsto_iff_norm_sub_tendsto_zero]
      simp only [sub_zero]
      refine squeeze_zero (fun n => norm_nonneg (w n)) (fun n => (hw n).2) ?_
      have hmul : Tendsto (fun n : ℕ => C * ‖u n - f x₀‖) atTop (𝓝 (C * ‖(0 : F)‖)) :=
        tendsto_const_nhds.mul hy.norm
      simpa using hmul
    simpa using tendsto_const_nhds.add hw_zero
  · intro n
    rw [f.map_add, (hw n).1]
    abel

end OpenMapping
end Banach1932
end FunctionalAnalysis
end MathlibExpansion
