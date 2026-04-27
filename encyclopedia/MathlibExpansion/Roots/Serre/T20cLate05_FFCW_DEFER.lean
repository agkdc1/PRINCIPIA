import Mathlib.FieldTheory.Finite.Basic

/-!
# T20c_late_05 FFCW_DEFER — F_q cyclic + Chevalley-Warning (defer)

**Classification.** `defer` / Chapter I. Covered upstream: cyclicity of
`F_q^×` via `FiniteField.instIsCyclic` and Chevalley-Warning via
`Mathlib.FieldTheory.ChevalleyWarning`.

**Citation.** Serre, *A Course in Arithmetic*, Ch. I §2.
Historical parent: Chevalley (1936); Warning (1936).
-/

namespace MathlibExpansion
namespace Roots
namespace Serre
namespace T20cLate05_FFCW

/-- **FFCW_01** citation marker. `F_q^×` is cyclic of order `q-1`; any
polynomial `f ∈ F_q[X_1,...,X_n]` of total degree `< n` has #zeros divisible
by `p`. Fully upstream.
Citation: Serre Ch. I §2 Thm. 2, 3. -/
axiom ff_cyclic_chevalley_warning_marker : True

end T20cLate05_FFCW
end Serre
end Roots
end MathlibExpansion
