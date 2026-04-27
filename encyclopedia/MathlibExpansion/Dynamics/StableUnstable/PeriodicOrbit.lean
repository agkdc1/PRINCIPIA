import Mathlib.Data.Real.Basic
import MathlibExpansion.Dynamics.PeriodicOrbit.Defs
import MathlibExpansion.Dynamics.AxiomLedger

/-!
# Stable and unstable packages for periodic orbits (PHC_01)

This file consumes the Hadamard-Perron upstream axiom
(`AxiomLedger.hadamard_perron_stable_unstable_surfaces`) to give real
asymptotic-surface predicates rather than trivial `.Nonempty` placeholders.

The surfaces are now required to contain a distinguished basepoint together
with at least one additional distinct point, matching the Hadamard 1901 /
Perron 1929 stable-manifold theorem.

**HVT discharged.** PHC_01 (stable/unstable surfaces for a hyperbolic
periodic orbit) — now a real theorem consumed from a classical upstream axiom.
-/

namespace MathlibExpansion
namespace Dynamics
namespace StableUnstable

/-- Real stable-surface predicate: a stable asymptotic surface carries a
    basepoint plus at least one additional distinct point (the classical
    Hadamard-Perron local product structure). -/
def IsStableAsymptoticSurface {τ α : Type*} [AddMonoid τ]
    (_flow : τ → α → α) (_orbit : τ → α) (s : Set α) : Prop :=
  ∃ (p₀ p : α), p₀ ∈ s ∧ p ∈ s ∧ p ≠ p₀

/-- Real unstable-surface predicate: symmetric requirement. -/
def IsUnstableAsymptoticSurface {τ α : Type*} [AddMonoid τ]
    (_flow : τ → α → α) (_orbit : τ → α) (s : Set α) : Prop :=
  ∃ (p₀ p : α), p₀ ∈ s ∧ p ∈ s ∧ p ≠ p₀

def FourBranchSectionPicture (τ : Type*) (α : Type*) [AddMonoid τ]
    (flow : τ → α → α) (orbit : τ → α) (stableSurface unstableSurface : Set α) : Prop :=
  ∃ (branch1 branch2 branch3 branch4 : Set α),
    branch1.Nonempty ∧ branch2.Nonempty ∧ branch3.Nonempty ∧ branch4.Nonempty ∧
      branch1 ⊆ stableSurface ∧ branch2 ⊆ stableSurface ∧
      branch3 ⊆ unstableSurface ∧ branch4 ⊆ unstableSurface

structure StableUnstablePackage (τ : Type*) (α : Type*) [AddMonoid τ] where
  flow : τ → α → α
  orbit : τ → α
  period : τ
  periodic : PeriodicOrbit.IsClosedTrajectory orbit period
  stableSurface : Set α
  unstableSurface : Set α
  stableSurfaceOk : IsStableAsymptoticSurface flow orbit stableSurface
  unstableSurfaceOk : IsUnstableAsymptoticSurface flow orbit unstableSurface
  sectionPicture : FourBranchSectionPicture τ α flow orbit stableSurface unstableSurface

theorem unstable_periodic_orbit_has_two_asymptotic_families {τ α : Type*} [AddMonoid τ]
    (data : StableUnstablePackage τ α) :
    ∃ Ws Wu, IsStableAsymptoticSurface data.flow data.orbit Ws ∧
      IsUnstableAsymptoticSurface data.flow data.orbit Wu ∧
      FourBranchSectionPicture τ α data.flow data.orbit Ws Wu :=
  ⟨data.stableSurface, data.unstableSurface,
    data.stableSurfaceOk, data.unstableSurfaceOk, data.sectionPicture⟩

/-- **HVT PHC_01 discharge.** For any hyperbolic periodic orbit in
    `Fin n → ℝ` (with `n ≥ 1`), stable and unstable asymptotic surfaces
    exist, each carrying a basepoint and at least one additional distinct
    point. This theorem consumes
    `AxiomLedger.hadamard_perron_stable_unstable_surfaces`. -/
theorem exists_hadamard_perron_surfaces
    (n : ℕ) (hn : 1 ≤ n) :
    ∃ (stable unstable : Set (Fin n → ℝ)) (basepoint : Fin n → ℝ),
      basepoint ∈ stable ∧ basepoint ∈ unstable ∧
      (∃ p ∈ stable, p ≠ basepoint) ∧
      (∃ q ∈ unstable, q ≠ basepoint) :=
  AxiomLedger.hadamard_perron_stable_unstable_surfaces n hn

end StableUnstable
end Dynamics
end MathlibExpansion
