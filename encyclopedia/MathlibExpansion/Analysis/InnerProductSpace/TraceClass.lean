import Mathlib.Data.Complex.Basic

import Mathlib.Analysis.InnerProductSpace.StarOrder
import Mathlib.Analysis.Normed.Operator.Compact
import MathlibExpansion.Analysis.OperatorAlgebra.SpectralResolution.BoundedSelfAdjoint

/-!
# Trace-class and density-operator boundary

This file records the trace-class carrier needed by the mixed-state and
composite-system lanes.

Primary sources:
- D. Hilbert (1912), *Grundzüge einer allgemeinen Theorie der linearen Integralgleichungen*.
- E. Hellinger and O. Toeplitz (1927), *Integralgleichungen und Gleichungen
  mit unendlich vielen Unbekannten*, Enzyklopädie der mathematischen
  Wissenschaften, IV C 2.
- J. von Neumann (1932), *Mathematische Grundlagen der Quantenmechanik*,
  Ch. IV.
-/

noncomputable section

open scoped InnerProductSpace

namespace MathlibExpansion
namespace Analysis
namespace InnerProductSpace

variable {E : Type*}
variable [NormedAddCommGroup E] [_root_.InnerProductSpace ℂ E] [CompleteSpace E]

/-- Rank-one operator `x ⊗ y*`, sending `z` to `⟪y, z⟫ • x`. -/
def traceClassRankOne (x y : E) : E →L[ℂ] E :=
  ContinuousLinearMap.smulRight (innerSL ℂ y) x

/-- A concrete nuclear-decomposition witness for a trace-class operator.

Citation anchor: J. von Neumann (1932), *Mathematische Grundlagen der
Quantenmechanik*, Ch. IV, §1, pp. 157-159 and Ch. IV, §3, pp. 173-174;
local theorem slots `DQS_01`, `DQS_03`, and `DQS_06` in
`T20c_22_von_density_operators_and_quantum_statistical_states_step3_recon_report.md`.
The compactness field records the Hellinger--Toeplitz / Hilbert trace-theory
consequence cited by von Neumann in II.11, Anm. 116, until the local compact
operator closure proof is formalized. -/
structure TraceClassDecomposition (T : E →L[ℂ] E) where
  left : ℕ → E
  right : ℕ → E
  summable_norm : Summable (fun n => ‖left n‖ * ‖right n‖)
  summable_trace : Summable (fun n => ⟪right n, left n⟫_ℂ)
  hasSum_operator : HasSum (fun n => traceClassRankOne (left n) (right n)) T
  compact : IsCompactOperator T

/-- Trace-class predicate, realized as a nonempty nuclear decomposition witness.

Citation anchor: J. von Neumann (1932), *Mathematische Grundlagen der
Quantenmechanik*, Ch. IV, §1, pp. 157-159 and Ch. IV, §3, pp. 173-174;
local theorem slots `DQS_01`, `DQS_03`, and `DQS_06`. -/
def IsTraceClass (T : E →L[ℂ] E) : Prop :=
  Nonempty (TraceClassDecomposition T)

/-- The trace value extracted from the chosen trace-class decomposition.

Citation anchor: J. von Neumann (1932), *Mathematische Grundlagen der
Quantenmechanik*, Ch. IV, §1, pp. 157-159, formula `Sp.`, and Ch. IV, §2,
p. 168; local theorem slots `DQS_02` and `DQS_03`.  Decomposition
independence is the next upstream theorem; this definition removes the
opaque trace-value primitive without asserting that independence here. -/
def traceClassValue {T : E →L[ℂ] E} (hT : IsTraceClass T) : ℂ :=
  let d := Classical.choice hT
  ∑' n, ⟪d.right n, d.left n⟫_ℂ

/-- A density operator is a positive trace-class operator of trace `1`. -/
structure DensityOperator where
  toCLM : E →L[ℂ] E
  isPositive : toCLM.IsPositive
  isTraceClass : IsTraceClass toCLM
  trace_eq_one : traceClassValue isTraceClass = 1

/-- The compact self-adjoint spectral package consumed by the trace-class
corridor. -/
structure CompactSelfAdjointSpectralPackage (T : E →L[ℂ] E) where
  compact : IsCompactOperator T
  selfAdjoint : IsSelfAdjoint T
  spectralResolution :
    Nonempty
      (_root_.MathlibExpansion.Analysis.OperatorAlgebra.SpectralResolution.SpectralResolution T)

/-- Positive trace-class operators have the compact self-adjoint spectral
package currently available in the local bounded spectral-resolution corridor.

Citation anchor: J. von Neumann (1932), *Mathematische Grundlagen der
Quantenmechanik*, Ch. IV, §3, pp. 173-174; local theorem slot `DQS_06`.
The bounded spectral-resolution component is supplied by
`exists_spectralResolution_of_isSelfAdjoint`, anchored to von Neumann (1929),
*Allgemeine Eigenwerttheorie Hermitescher Funktionaloperatoren*, and
von Neumann (1931), *Über Funktionen von Funktionaloperatoren*. -/
theorem exists_compactSelfAdjoint_spectralPackage
    {T : E →L[ℂ] E} (hT : T.IsPositive) (htrace : IsTraceClass T) :
    Nonempty (CompactSelfAdjointSpectralPackage T) := by
  classical
  refine ⟨{ compact := ?_, selfAdjoint := ?_, spectralResolution := ?_ }⟩
  · exact (Classical.choice htrace).compact
  · exact hT.isSelfAdjoint
  · exact
      _root_.MathlibExpansion.Analysis.OperatorAlgebra.SpectralResolution.exists_spectralResolution_of_isSelfAdjoint
        hT.isSelfAdjoint

end InnerProductSpace
end Analysis
end MathlibExpansion
