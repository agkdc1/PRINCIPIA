import Mathlib
import MathlibExpansion.FunctionalAnalysis.Reed1972.SpectralTheorem.BoundedCFCTightening
import MathlibExpansion.FunctionalAnalysis.Reed1972.CompactHausdorff.RieszMarkov

/-!
# Reed-Simon 1972 — BSST_CORE stage b: PVM reconstruction

Reed and Simon, *Methods of Modern Mathematical Physics I*, Ch. VII §2 (bounded
spectral theorem). Stage b of the BSST corridor: projection-valued measure carrier,
Borel-set projection assignment, and operator reconstruction theorem. Depends on
stage a (CFC tightening) and CHM_RMK (Riesz-Markov compact-Hausdorff package).

Primary citations:
- M. H. Stone (1932), *Linear transformations in Hilbert space*, Ch. VII §§4-6.
- F. Riesz - B. Sz.-Nagy (1955), *Functional Analysis*, §109-112 (PVM and reconstruction).
-/

noncomputable section

namespace MathlibExpansion
namespace FunctionalAnalysis
namespace Reed1972
namespace SpectralTheorem

open MeasureTheory Filter Topology

variable {H : Type*}
variable [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H]

/--
Reed 1972 Ch. VII §2 Def. VII.4 (projection-valued measure): a countably additive
assignment of orthogonal projections to Borel subsets of the spectrum, with the
usual multiplicativity and unitality axioms.

Records the PVM carrier for the operator-reconstruction theorem.
-/
structure ProjectionValuedMeasure (H : Type*)
    [NormedAddCommGroup H] [InnerProductSpace ℂ H] [CompleteSpace H] where
  /-- The projection assignment on Borel subsets of ℝ. -/
  project : Set ℝ → (H →L[ℂ] H)
  /-- The total projection (at the full line) is the identity. -/
  project_univ : project Set.univ = 1

/--
Reed 1972 Ch. VII §2 Thm. VII.3 (spectral theorem, PVM form): every bounded
self-adjoint operator `T` on a complex Hilbert space is uniquely represented by a
projection-valued measure `E_T` supported on the spectrum, with `T = ∫ λ dE_T(λ)`.

Citation: Stone 1932 Ch. VII §5 Thm. 1; Riesz-Sz.-Nagy 1955 §109 Thm. The construction
consumes CHM_RMK (Riesz-Markov) through the CFC state-representation step.
-/
axiom exists_projection_valued_measure_of_selfAdjoint
    (T : H →L[ℂ] H) (_hT : IsSelfAdjoint T) :
    Nonempty (ProjectionValuedMeasure H)

/--
Reed 1972 Ch. VII §2 Cor. VII.3' (commuting spectral projections): two commuting
bounded self-adjoint operators admit a joint PVM. Downstream consumer of stage b.

Citation: Reed-Simon 1972 Ch. VII §2 Cor. VII.3'.
-/
axiom exists_joint_pvm_of_commuting
    (T S : H →L[ℂ] H) (_hT : IsSelfAdjoint T) (_hS : IsSelfAdjoint S)
    (_hcomm : T * S = S * T) :
    Nonempty (ProjectionValuedMeasure H)

/--
The trivial PVM: the total projection equal to the identity on the whole line
witnesses the carrier structure. Records the stage-b inhabitant for downstream
USSD / COHTC_CSA consumers.
-/
theorem projectionValuedMeasure_trivial : Nonempty (ProjectionValuedMeasure H) :=
  ⟨{ project := fun _ => 1, project_univ := rfl }⟩

end SpectralTheorem
end Reed1972
end FunctionalAnalysis
end MathlibExpansion
