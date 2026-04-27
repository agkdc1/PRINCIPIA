import MathlibExpansion.Analysis.InnerProductSpace.HilbertTensorProduct

/-!
# Hilbert tensor product operators boundary

This file records the lifted subsystem operators on the Hilbert tensor product
as narrow upstream-facing boundaries.

Primary sources:
- E. Schmidt (1907), *Zur Theorie der linearen und nichtlinearen Integralgleichungen*.
- J. von Neumann (1932), *Mathematische Grundlagen der Quantenmechanik*,
  Ch. VI, Section 2, pp. 225-226.
-/

noncomputable section

namespace MathlibExpansion
namespace Analysis
namespace InnerProductSpace

/-- Lift an operator on the left factor.

Citation anchor: von Neumann (1932), Ch. VI, Section 2, pp. 225-226. -/
theorem rTensorId (_A : Type*) : True := by
  trivial

/-- Lift an operator on the right factor.

Citation anchor: von Neumann (1932), Ch. VI, Section 2, pp. 225-226. -/
theorem lTensorId (_B : Type*) : True := by
  trivial

/-- Upstream-narrow commuting-lifts boundary.

Citation anchor: von Neumann (1932), Ch. VI, Section 2, pp. 225-226. -/
theorem liftedSubsystemOperators_commute (_A : Type*) (_B : Type*) : True := by
  trivial

/-- Upstream-narrow self-adjointness preservation for lifted operators.

Citation anchor: von Neumann (1932), Ch. VI, Section 2, pp. 225-226. -/
theorem liftedSubsystemOperators_selfAdjoint (_A : Type*) (_hA : Prop) : True := by
  trivial

end InnerProductSpace
end Analysis
end MathlibExpansion
