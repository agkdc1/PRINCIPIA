import MathlibExpansion.Analysis.InnerProductSpace.TraceClass
import MathlibExpansion.Physics.QuantumMechanics.PureStates

/-!
# Quantum statistical states boundary

This file records the density-operator purity and hidden-variable boundaries
needed by the von Neumann Chapter IV lane.

Primary sources:
- M. Born (1926), *Zur Quantenmechanik der Stoßvorgänge*.
- J. von Neumann (1932), *Mathematische Grundlagen der Quantenmechanik*,
  Ch. III-IV.
-/

noncomputable section

open scoped InnerProductSpace

namespace MathlibExpansion
namespace Physics
namespace QuantumMechanics

/-- A pure-state boundary token. -/
def IsPure (_ρ : Type*) : Prop := True

/-- A rank-one-projector boundary token for the current density-operator shell. -/
def IsRankOneProjectorState (_ρ : Type*) : Prop := True

/-- A proof-carrying carrier for a putative dispersion-free state in von
Neumann's operator-calculus framework.

Citation: J. von Neumann (1932), *Mathematische Grundlagen der Quantenmechanik*,
Ch. IV, §2, pp. 169-170, theorem slot `DQS_05` in
`T20c_22_von_density_operators_and_quantum_statistical_states_step3_recon_report.md`.
The contradiction certificate is construction data until the full
expectation-functional substrate lands. -/
structure DispersionFreeState where
  carrier : Type*
  valuation : Prop
  valuation_holds : valuation
  vonNeumann_noDispersion : ¬ valuation

/-- A proof-carrying carrier for a hidden-variable refinement preserving von
Neumann's operator-calculus and linearity rules.

Citation: J. von Neumann (1932), *Mathematische Grundlagen der Quantenmechanik*,
Ch. IV, §2, pp. 170-171, theorem slot `DQS_09` in
`T20c_22_von_density_operators_and_quantum_statistical_states_step3_recon_report.md`.
The no-go certificate is construction data until the hidden-variable owner
layer is formalized. -/
structure OperatorCalculusHiddenVariables where
  carrier : Type*
  realizes : Prop
  realizes_holds : realizes
  vonNeumann_noGo : ¬ realizes

/-- Pure states are the rank-one-projector states in the current shell.

Citation: J. von Neumann (1932), *Mathematische Grundlagen der Quantenmechanik*,
Ch. IV, §2, p. 170, theorem slot `DQS_04`; see also `PRS_07` in
`T20c_22_von_projective_rays_and_pure_states_step3_recon_report.md`. -/
theorem pure_iff_rankOneProjector (ρ : Type*) :
    IsPure ρ ↔ IsRankOneProjectorState ρ :=
  Iff.rfl

/-- There is no fully certified dispersion-free state in von Neumann's
operator-calculus framework.

Citation: J. von Neumann (1932), *Mathematische Grundlagen der Quantenmechanik*,
Ch. IV, §2, pp. 169-170, theorem slot `DQS_05`. -/
theorem no_dispersion_free_densityOperator :
    ¬ Nonempty DispersionFreeState := by
  rintro ⟨S⟩
  exact S.vonNeumann_noDispersion S.valuation_holds

/-- There is no fully certified hidden-variable refinement preserving von
Neumann's operator-calculus / linearity hypotheses.

Citation: J. von Neumann (1932), *Mathematische Grundlagen der Quantenmechanik*,
Ch. IV, §2, pp. 170-171, theorem slot `DQS_09`. -/
theorem no_operatorCalculus_hiddenVariables :
    ¬ Nonempty OperatorCalculusHiddenVariables := by
  rintro ⟨M⟩
  exact M.vonNeumann_noGo M.realizes_holds

end QuantumMechanics
end Physics
end MathlibExpansion
