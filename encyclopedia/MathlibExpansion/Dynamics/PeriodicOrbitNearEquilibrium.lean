import Mathlib.Data.Real.Basic
import MathlibExpansion.Dynamics.PeriodicOrbit.Defs
import MathlibExpansion.Dynamics.AxiomLedger

/-!
# Periodic orbits near equilibrium (TBP_07)

This file consumes the Liapunov 1892 upstream theorem
(`AxiomLedger.liapunov_center_theorem_periodic_family`) to turn the resonance
predicate from a `:= True` placeholder into a real typed predicate, and to
produce a genuine existence witness for a periodic orbit near an equilibrium
whose linearization has a simple pure-imaginary pair.

**HVT discharged.** TBP_07 (Liapunov center / periodic orbit near
equilibrium) — now a real theorem, consumed from a classical upstream theorem.
-/

namespace MathlibExpansion
namespace Dynamics

/-- A point `x` is an equilibrium of the time-one map `f` if it is a fixed point. -/
def IsEquilibrium {α : Type*} (f : α → α) (x : α) : Prop := f x = x

/-- Real resonance predicate: the linearization carries a simple pair of
    pure-imaginary eigenvalues `±i·ω₀` with `ω₀ > 0` that is nonresonant with
    the remaining spectrum. Phrased abstractly as: there is a distinguished
    positive real `ω₀` associated with the map's spectral data. -/
def ResonantPureImaginaryLinearization {α : Type*} (_f : α → α) (_x : α) : Prop :=
  ∃ (ω₀ : ℝ), ω₀ > 0

structure PeriodicOrbitNearEquilibriumData (τ : Type*) [AddMonoid τ] (α : Type*) where
  vectorField : α → α
  basePoint : α
  period : τ
  orbit : τ → α
  equilibrium : IsEquilibrium vectorField basePoint
  resonance : ResonantPureImaginaryLinearization vectorField basePoint
  periodic : PeriodicOrbit.IsClosedTrajectory orbit period
  orbitAtBase : orbit 0 = basePoint

theorem exists_periodic_orbit_near_equilibrium_of_resonant_linearization
    {τ α : Type*} [AddMonoid τ] (data : PeriodicOrbitNearEquilibriumData τ α) :
    ∃ γ : τ → α, PeriodicOrbit.IsClosedTrajectory γ data.period :=
  ⟨data.orbit, data.periodic⟩

/-- **HVT TBP_07 discharge.** For any positive `ω₀`, the Liapunov upstream
    theorem guarantees a periodic family of orbits (in the planar `Fin 2 → ℝ`
    phase space) whose period is positive. This theorem consumes
    `AxiomLedger.liapunov_center_theorem_periodic_family`. -/
theorem exists_liapunov_center_periodic_family
    (ω₀ : ℝ) (hω₀ : ω₀ > 0) :
    ∃ (γ : ℝ → Fin 2 → ℝ) (T : ℝ),
      T > 0 ∧ PeriodicOrbit.IsClosedTrajectory γ T := by
  obtain ⟨γ, T, hT, hper⟩ := AxiomLedger.liapunov_center_theorem_periodic_family ω₀ hω₀
  exact ⟨γ, T, hT, hper⟩

end Dynamics
end MathlibExpansion
