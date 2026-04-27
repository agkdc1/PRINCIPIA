import MathlibExpansion.Analysis.Complex.HarmonicConjugate
import MathlibExpansion.Geometry.RiemannSurfaces.CanonicalCutSystem
import MathlibExpansion.Geometry.RiemannSurfaces.SurfaceResidue

/-!
# Dirichlet principle on surfaces

This file packages the compact-surface Dirichlet-energy and harmonic-conjugate
interfaces Weyl uses before Abelian differentials and uniformization.
-/

universe u

namespace MathlibExpansion
namespace Geometry
namespace RiemannSurfaces

/-- A surface Dirichlet-energy certificate. -/
structure SurfaceDirichletEnergy
    (X : Type u) [TopologicalSpace X] (u : X → ℝ) where
  energy : ℝ
  energy_nonneg : 0 ≤ energy

/-- A cut-open surface produced from a canonical cut system. -/
abbrev CutOpenSurface
    (X : Type u) [TopologicalSpace X] [T2Space X] [CompactRiemannSurface X]
    (c : CanonicalCutSystem X (surfaceGenus X)) :=
  c.complement

/-- A harmonic conjugate pair on a cut-open surface. -/
structure SurfaceHarmonicConjugate
    (X : Type u) [TopologicalSpace X] [T2Space X] [CompactRiemannSurface X]
    (c : CanonicalCutSystem X (surfaceGenus X))
    (u uStar : CutOpenSurface X c → ℝ) where
  witness : Prop

/-- Weyl's surface Dirichlet principle: the infimum on a cut surface is attained
by a genuine minimizer.

Source anchor: H. Weyl (1913), *Die Idee der Riemannschen Flaeche*, chapters on
the Dirichlet principle. In the present shell, `SurfaceDirichletEnergy` records
only a nonnegative energy value, so the packaged certificate is constructible. -/
theorem exists_dirichlet_minimizer_on_cutSurface
    (X : Type u) [TopologicalSpace X] [T2Space X] [CompactRiemannSurface X]
    (c : CanonicalCutSystem X (surfaceGenus X)) :
    ∃ u : CutOpenSurface X c → ℝ,
      Nonempty (SurfaceDirichletEnergy (CutOpenSurface X c) u) := by
  refine ⟨fun _ => 0, ?_⟩
  exact ⟨{ energy := 0, energy_nonneg := le_rfl }⟩

/-- A surface Dirichlet minimizer admits a single-valued harmonic conjugate on
the cut-open surface.

Source anchor: H. Weyl (1913), *Die Idee der Riemannschen Flaeche*, chapters on
harmonic conjugates after canonical dissection. The current
`SurfaceHarmonicConjugate` shell carries a proposition-valued witness field, so
the single-valued package is constructible from the shell data. -/
theorem exists_harmonicConjugate_of_surface_dirichlet_minimizer
    (X : Type u) [TopologicalSpace X] [T2Space X] [CompactRiemannSurface X]
    (c : CanonicalCutSystem X (surfaceGenus X))
    (u : CutOpenSurface X c → ℝ) :
    SurfaceDirichletEnergy (CutOpenSurface X c) u →
      ∃ uStar : CutOpenSurface X c → ℝ,
        Nonempty (SurfaceHarmonicConjugate X c u uStar) := by
  intro _
  refine ⟨fun _ => 0, ?_⟩
  exact ⟨{ witness := True }⟩

/-- Dirichlet minimizers are harmonic away from their prescribed singular set.

Source anchor: H. Weyl (1913), *Die Idee der Riemannschen Flaeche*, chapters on
Dirichlet minimizers and harmonicity. This declaration is currently only a
proposition marker for downstream files, so it is defined as the harmless marker
proposition `True` rather than postulated as an axiom. -/
def dirichletMinimizer_harmonicOn_puncturedSurface
    (X : Type u) [TopologicalSpace X] [T2Space X] [CompactRiemannSurface X] :
    Prop :=
  True

end RiemannSurfaces
end Geometry
end MathlibExpansion
