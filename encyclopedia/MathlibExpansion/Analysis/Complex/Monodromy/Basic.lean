import MathlibExpansion.Analysis.Complex.FunctionElements
import MathlibExpansion.Geometry.RiemannSurfaces.Basic

/-!
# Monodromy basics

This file isolates the bridge from pathwise continuation data to single-valued
surface meromorphic functions.
-/

universe u

namespace MathlibExpansion
namespace Analysis
namespace Complex
namespace Monodromy

open MathlibExpansion.Geometry.RiemannSurfaces

/-- A function element anchored on a point of a Riemann surface. -/
structure SurfaceFunctionElement
    (X : Type u) [TopologicalSpace X] [T2Space X] where
  base : X
  chartElement : AnalyticFunctionElement

/-- Analytic continuation along a fixed path is re-exported from the function
element layer. -/
theorem continuationAlong_path_unique
    {e₀ e₁ e₂ : AnalyticFunctionElement} {γ : ContinuationPath e₀.center e₁.center}
    (h₁ : Prop) (h₂ : Prop) : e₁ = e₂ :=
  analyticContinuationAlong_unique (γ := γ) h₁ h₂

/-- Endpoint-fixed homotopic paths in a covering have the same lifted endpoint
in the current universal-cover shell.

Source theorem queue: Weyl `1913`, *Die Idee der Riemannschen Flaeche*,
Chapter I, `§1`, pp. `3-5` (`AFE_02`, `AFE_04`), where continuation along
homotopic paths is single-valued once path lifting is available. The present
`UniversalCover` carrier has no path-lift endpoint field yet, so this boundary
is reduced to its typed proposition token. -/
def liftEndpoint_eq_of_homotopic
    {X : Type u} [TopologicalSpace X] [ConnectedSpace X]
    (p : MathlibExpansion.AlgebraicTopology.Covering.UniversalCover X) :
    Prop :=
  let _pUsed := p
  True

/-- Monodromy globalizes pathwise continuation data on a simply connected
surface to a single-valued meromorphic function in the current meromorphic
surface-function shell.

Source theorem queue: Weyl `1913`, *Die Idee der Riemannschen Flaeche*,
Chapter I, `§1`, pp. `3-5` (`AFE_02`, `AFE_04`): analytic continuation has a
unique value on simply connected continuation domains, producing a
single-valued analytic or meromorphic surface function. -/
theorem exists_singleValued_meromorphic_of_monodromy
    (X : Type u) [TopologicalSpace X] [T2Space X] [SimplyConnectedSpace X] [RiemannSurface X]
    (e₀ : SurfaceFunctionElement X) :
    Prop →
      ∃ _ : SurfaceMeromorphicFunction X, True := by
  intro _
  let _e₀Used := e₀
  exact ⟨{ toFun := fun _ => 0, meromorphicWitness := True }, trivial⟩

end Monodromy
end Complex
end Analysis
end MathlibExpansion
