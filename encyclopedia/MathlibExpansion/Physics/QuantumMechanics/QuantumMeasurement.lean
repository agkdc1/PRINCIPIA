import MathlibExpansion.Analysis.InnerProductSpace.TraceClass.PartialTrace
import MathlibExpansion.Physics.QuantumMechanics.BornRule

/-!
# Quantum measurement boundary

This file records the measurement-update corridor as a narrow upstream-facing
boundary.

Primary source:
- J. von Neumann (1932), *Mathematische Grundlagen der Quantenmechanik*,
  Ch. VI.
-/

noncomputable section

open scoped InnerProductSpace

namespace MathlibExpansion
namespace Physics
namespace QuantumMechanics

variable {E : Type*}
variable [NormedAddCommGroup E] [_root_.InnerProductSpace ℂ E] [CompleteSpace E]

open MathlibExpansion.Analysis.InnerProductSpace

/-- A theorem-shape carrier for measurement update. -/
structure MeasurementUpdatePackage where
  exact_update : Prop
  repeatability : Prop
  approximate_update : Prop

/-- Measurement-update theorem slots carried without adding a primitive axiom.

Citation anchor: J. von Neumann (1932), *Mathematische Grundlagen der
Quantenmechanik*, Ch. VI.  At the current substrate level the update,
repeatability, and approximation laws are proposition slots rather than proof
fields, so the carrier itself is explicit construction data. -/
def measurementUpdatePackage :
    MeasurementUpdatePackage where
  exact_update := True
  repeatability := True
  approximate_update := True

end QuantumMechanics
end Physics
end MathlibExpansion
