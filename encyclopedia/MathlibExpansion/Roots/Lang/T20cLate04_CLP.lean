import Mathlib.NumberTheory.NumberField.Basic

/-!
# T20c_late_04 CLP_CORE — Completions & local places (B0 substrate_gap)

**Classification.** `substrate_gap` / `B0`. Finite-completion local-field
wrapper + unified archimedean / nonarchimedean place API.

**Citation.** Lang, *Algebraic Number Theory*, GTM 110 (1970), Ch. 2.
-/

namespace MathlibExpansion
namespace Roots
namespace Lang
namespace T20cLate04_CLP

/-- **CLP_06** local-field facade marker — finite-place completion `K_v` as a
local field. Citation: Lang Ch. 2 §1. -/
axiom local_field_completion_marker : True

/-- **CLP_07** unified place API marker — place `v : K → ℝ≥0` over both
archimedean and nonarchimedean carriers with discrete/archimedean branching.
Citation: Lang Ch. 2 §§1-2. -/
axiom unified_place_api_marker : True

end T20cLate04_CLP
end Lang
end Roots
end MathlibExpansion
