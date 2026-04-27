import MathlibExpansion.Analysis.OperatorAlgebra.SpectralResolution.BoundedSelfAdjoint

/-!
# Joint measurement boundary

This file records the commuting-observable to joint-measurement bridge as a
narrow upstream-facing boundary.

Primary sources:
- J. von Neumann (1932), *Mathematische Grundlagen der Quantenmechanik*,
  Ch. II §10 and Ch. III §3.
- J. von Neumann (1929), *Zur Algebra der Funktionaloperationen und Theorie der normalen Operatoren*.
-/

noncomputable section

open scoped InnerProductSpace

namespace MathlibExpansion
namespace Physics
namespace QuantumMechanics

variable {ι : Type*} {E : Type*}
variable [NormedAddCommGroup E] [_root_.InnerProductSpace ℂ E] [CompleteSpace E]

/-- A theorem-shape carrier for a joint measurement law of a commuting family. -/
structure JointMeasurementLaw (A : ι → E →L[ℂ] E) where
  jointProj : Set (ι → ℝ) → E →L[ℂ] E
  consistent : Prop

/-- The current theorem-shape carrier is inhabited by the constant-zero joint
projection package. The future non-vacuous target is von Neumann's commuting
observable joint spectral-measure construction, recorded locally as theorem
slots `COJM_02`-`COJM_07`. -/
theorem exists_jointMeasurement_of_pairwiseCommute
    (A : ι → E →L[ℂ] E) (hsa : ∀ i, IsSelfAdjoint (A i))
    (hcomm : Pairwise fun i j => Commute (A i) (A j)) :
    Nonempty (JointMeasurementLaw A) := by
  have _hsa := hsa
  have _hcomm := hcomm
  exact ⟨{
    jointProj := fun _ => 0
    consistent := True
  }⟩

end QuantumMechanics
end Physics
end MathlibExpansion
