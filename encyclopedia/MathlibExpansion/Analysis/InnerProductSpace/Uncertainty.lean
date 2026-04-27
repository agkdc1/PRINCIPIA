import Mathlib.Data.Complex.Basic

import MathlibExpansion.Analysis.InnerProductSpace.TraceClass

/-!
# Uncertainty boundary

This file records the bounded operator-state uncertainty corridor as a narrow
upstream-facing boundary.

Primary sources:
- W. Heisenberg (1927), *Über den anschaulichen Inhalt der quantentheoretischen Kinematik und Mechanik*.
- E. H. Kennard (1927), *Zur Quantenmechanik einfacher Bewegungstypen*.
- H. P. Robertson (1929), *The Uncertainty Principle*.
- J. von Neumann (1932), *Mathematische Grundlagen der Quantenmechanik*, Ch. IV.
-/

noncomputable section

open scoped InnerProductSpace

namespace MathlibExpansion
namespace Analysis
namespace InnerProductSpace

variable {E : Type*}
variable [NormedAddCommGroup E] [_root_.InnerProductSpace ℂ E] [CompleteSpace E]

open MathlibExpansion.Analysis.InnerProductSpace

/-- A theorem-shape carrier for the bounded Robertson uncertainty package. -/
structure UncertaintyPackage where
  heisenberg : Prop
  robertson : Prop

/-- Upstream-narrow bounded uncertainty boundary.

The former axiom only asserted existence of a carrier whose fields are
`Prop`-valued theorem slots, not proofs of the Robertson/Kennard inequalities.
We make that carrier explicit here so this boundary no longer contributes a
non-kernel axiom.  The non-vacuous mixed-state variance/commutator theorem is
still the future upstream target cited in Robertson (1929), The Uncertainty
Principle, Eq. (1). -/
def uncertaintyPackage (_ρ : DensityOperator (E := E)) :
    UncertaintyPackage where
  heisenberg := True
  robertson := True

end InnerProductSpace
end Analysis
end MathlibExpansion
