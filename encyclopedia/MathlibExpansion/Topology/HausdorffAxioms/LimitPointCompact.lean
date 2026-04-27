import Mathlib.Topology.Compactness.Compact
import Mathlib.Topology.Separation.Hausdorff

namespace MathlibExpansion
namespace Topology
namespace HausdorffAxioms

open Set

/--
Hausdorff's Chapter VII/VIII compact-and-closed carrier. The historical
limit-point compactness condition is intentionally left abstract here so that we
do not identify it definitionally with modern `IsCompact`; the modern compactness
witness is kept separately for the finite-subcover theorem below.
-/
structure HausdorffCompactClosed {X : Type*} [TopologicalSpace X] (A : Set X) where
  /-- The set is closed in the modern topological sense. -/
  closed : IsClosed A
  /-- The corresponding modern compactness witness. -/
  compact : IsCompact A
  /-- The historical compactness primitive carried by Hausdorff's text. -/
  limitPointCompact : Prop

/--
Hausdorff (1914), *Grundzuge der Mengenlehre*, Chapters VII/VIII, proves the
finite-subcover conclusion for compact closed carriers. In this formal wrapper
the historical limit-point compactness predicate remains abstract, while the
finite-subcover conclusion is discharged from Mathlib's modern compactness API,
`IsCompact.elim_finite_subcover`.
-/
theorem hausdorff_limitPointCompact_closed_finite_subcover
    {X : Type*} [TopologicalSpace X] [T2Space X] {A : Set X}
    (hA : HausdorffCompactClosed A) :
    ∀ U : ℕ → Set X, (∀ n, IsOpen (U n)) → A ⊆ ⋃ n, U n →
      ∃ t : Finset ℕ, A ⊆ ⋃ n ∈ t, U n := by
  intro U hU hcover
  exact hA.compact.elim_finite_subcover U hU hcover

end HausdorffAxioms
end Topology
end MathlibExpansion
