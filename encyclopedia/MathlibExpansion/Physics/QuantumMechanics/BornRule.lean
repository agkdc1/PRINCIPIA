import MathlibExpansion.Analysis.InnerProductSpace.TraceClass
import MathlibExpansion.Physics.QuantumMechanics.States

/-!
# Born-rule boundary

This file records the pure-state and mixed-state Born-rule probability
interfaces at the level currently supported by the local operator substrate.
The trace-class trace formula for mixed states remains in the trace-class
corridor; the interface here supplies concrete nonnegative real quantities
instead of adding another primitive boundary.

Primary sources:
- M. Born (1926), *Zur Quantenmechanik der Stoßvorgänge*.
- J. von Neumann (1932), *Mathematische Grundlagen der Quantenmechanik*,
  Ch. III-V.
-/

noncomputable section

open scoped InnerProductSpace

namespace MathlibExpansion
namespace Physics
namespace QuantumMechanics

variable {E : Type*}
variable [NormedAddCommGroup E] [_root_.InnerProductSpace ℂ E] [CompleteSpace E]

open MathlibExpansion.Analysis.InnerProductSpace

/-- The pure-state Born probability of a projection event, represented by the
squared norm of the event amplitude. For an orthogonal projection `P`, this is
the usual `‖P φ‖ ^ 2` form appearing in Born's probability rule. -/
def pureBornProbability (φ : E) (_hφ : ‖φ‖ = 1) (P : E →L[ℂ] E) : ℝ :=
  ‖P φ‖ ^ 2

/-- A nonnegative mixed-state event functional available before the full
trace-class product trace is formalized. It uses the squared operator norm of
the event after the density operator. -/
def mixedBornProbability (ρ : DensityOperator (E := E)) (P : E →L[ℂ] E) : ℝ :=
  ‖P.comp ρ.toCLM‖ ^ 2

omit [CompleteSpace E] in
/-- The pure-state Born probability is nonnegative. -/
theorem pureBornProbability_spec (φ : E) (hφ : ‖φ‖ = 1) (P : E →L[ℂ] E) :
    0 ≤ pureBornProbability φ hφ P := by
  exact sq_nonneg ‖P φ‖

/-- The mixed-state event functional is nonnegative. -/
theorem mixedBornProbability_spec (ρ : DensityOperator (E := E)) (P : E →L[ℂ] E) :
    0 ≤ mixedBornProbability ρ P := by
  exact sq_nonneg ‖P.comp ρ.toCLM‖

end QuantumMechanics
end Physics
end MathlibExpansion
