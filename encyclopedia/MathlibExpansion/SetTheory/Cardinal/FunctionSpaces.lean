import Mathlib.Data.Real.Cardinality
import Mathlib.SetTheory.Cardinal.Arithmetic

open Cardinal
open scoped Cardinal

namespace MathlibExpansion
namespace SetTheory
namespace Cardinal

/-- Hausdorff's bundled cardinality statement for all real-valued real functions. -/
theorem mk_real_arrow_real : #(ℝ → ℝ) = 2 ^ #(ℝ) := by
  rw [mk_arrow, mk_real]
  simpa [lift_continuum] using (power_self_eq aleph0_le_continuum : 𝔠 ^ 𝔠 = 2 ^ 𝔠)

end Cardinal
end SetTheory
end MathlibExpansion
