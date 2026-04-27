import Mathlib.Data.Complex.Basic

import MathlibExpansion.Analysis.InnerProductSpace.HilbertTensorProductOperators
import MathlibExpansion.Analysis.InnerProductSpace.TraceClass

/-!
# Partial trace boundary

This file records the partial-trace / reduced-state corridor as a narrow
upstream-facing boundary.

Primary sources:
- E. Schmidt (1907), *Zur Theorie der linearen und nichtlinearen Integralgleichungen*.
- J. von Neumann (1932), *Mathematische Grundlagen der Quantenmechanik*,
  Ch. VI §2.
-/

noncomputable section

open scoped InnerProductSpace

namespace MathlibExpansion
namespace Analysis
namespace InnerProductSpace
namespace TraceClass

variable {E : Type*} {F : Type*}
variable [NormedAddCommGroup E] [NormedAddCommGroup F]
variable [_root_.InnerProductSpace ℂ E] [_root_.InnerProductSpace ℂ F]
variable [CompleteSpace E] [CompleteSpace F]

open MathlibExpansion.Analysis.InnerProductSpace

/-- Upstream-narrow right partial trace.

Citation anchor: J. von Neumann (1932), *Mathematische Grundlagen der
Quantenmechanik*, Ch. VI, §2, pp. 226-227; local theorem slot `VNTC_03`
in the tensor-product composite-systems reconstruction. -/
axiom partialTraceRight :
    DensityOperator
        (E := HilbertTensorProduct (𝕜 := ℂ) (E := E) (F := F)) →
      DensityOperator (E := E)

/-- Upstream-narrow left partial trace.

Citation anchor: J. von Neumann (1932), *Mathematische Grundlagen der
Quantenmechanik*, Ch. VI, §2, pp. 226-227; local theorem slot `VNTC_03`
in the tensor-product composite-systems reconstruction. -/
axiom partialTraceLeft :
    DensityOperator
        (E := HilbertTensorProduct (𝕜 := ℂ) (E := E) (F := F)) →
      DensityOperator (E := F)

/-- Upstream-narrow right partial-trace expectation characterization boundary.

Citation anchor: J. von Neumann (1932), *Mathematische Grundlagen der
Quantenmechanik*, Ch. VI, §2, pp. 226-227; local theorem slot `VNTC_03`.
The non-vacuous version quantifies over subsystem observables and the
trace-class expectation pairing, which are not yet available in this shell. -/
axiom partialTraceRight_characterized_by_expectation :
    Prop

/-- Upstream-narrow left partial-trace expectation characterization boundary.

Citation anchor: J. von Neumann (1932), *Mathematische Grundlagen der
Quantenmechanik*, Ch. VI, §2, pp. 226-227; local theorem slot `VNTC_03`.
The non-vacuous version quantifies over subsystem observables and the
trace-class expectation pairing, which are not yet available in this shell. -/
axiom partialTraceLeft_characterized_by_expectation :
    Prop

/-- Backward-compatible aggregate partial-trace characterization boundary. -/
def partialTrace_characterized_by_expectation : Prop :=
    partialTraceRight_characterized_by_expectation ∧
      partialTraceLeft_characterized_by_expectation

/-- Upstream-narrow product-vector implies pure-marginals boundary.

Citation anchor: J. von Neumann (1932), *Mathematische Grundlagen der
Quantenmechanik*, Ch. VI, §2, pp. 231-232; local theorem slots `VNTC_08`
and `PRS_09`. Schmidt (1907), *Zur Theorie der linearen und nichtlinearen
Integralgleichungen*, is the upstream decomposition ancestor. -/
axiom product_joint_has_pure_reductions :
    Prop

/-- Upstream-narrow pure-marginals force product-vector boundary.

Citation anchor: J. von Neumann (1932), *Mathematische Grundlagen der
Quantenmechanik*, Ch. VI, §2, pp. 231-232; local theorem slots `VNTC_08`
and `PRS_09`. Schmidt (1907), *Zur Theorie der linearen und nichtlinearen
Integralgleichungen*, is the upstream decomposition ancestor. -/
axiom pure_reductions_force_product_joint :
    Prop

/-- Backward-compatible aggregate product-vector / pure-marginal boundary. -/
def reduced_pure_iff_joint_is_product : Prop :=
    product_joint_has_pure_reductions ∧
      pure_reductions_force_product_joint

end TraceClass
end InnerProductSpace
end Analysis
end MathlibExpansion
