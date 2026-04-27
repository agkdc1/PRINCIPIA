import Mathlib.Algebra.Lie.TraceForm
import Mathlib.Algebra.Lie.Solvable

/-!
# Cartan criterion — forward direction (Cartan 1894, CKF_02)

For a finite-dimensional Lie algebra `L` over a field of characteristic zero,
if `L` is solvable, then the Killing-form trace of `ad x ∘ ad y` vanishes
whenever `y ∈ [L, L]`.

This is the forward direction of Cartan's criterion for solvability. The
converse is the CKF_03 axiom (see `CartanCriterion.lean`).

Source: É. Cartan, *Sur la structure des groupes de transformations finis et
continus* (1894), Ch. IV §1, Théorème I, pp. 51–52; with Killing (1888-90),
*Die Zusammensetzung der stetigen endlichen Transformationsgruppen*,
Parts III-IV, as precursor.

## Diagnostic for upstream narrowness

The classical proof chain is:

1. Base-change to an algebraic closure (reduces to `K = K̄`).
2. Apply Lie's theorem (`LieModule.exists_forall_lie_eq_smul_of_isSolvable`,
   already in Mathlib) to simultaneously triangularize the adjoint action.
3. In the triangular basis, elements of the derived ideal `[L, L]` act as
   strictly upper-triangular operators (weights vanish on commutators).
4. Trace of a triangular × strictly triangular product is `0`.

All four steps have Mathlib substrate, but Mathlib currently lacks the
"closure + descent" Cartan assembly. Hence this file files the upstream-narrow
axiom and cites the exact proof chain.
-/

noncomputable section

open LieAlgebra LieModule

universe u v

namespace MathlibExpansion.Lie.Killing

/--
Upstream-narrow axiom: forward direction of Cartan's criterion.

Source: É. Cartan 1894, Ch. IV §1, Théorème I. The Mathlib chain relies on
`LieModule.exists_forall_lie_eq_smul_of_isSolvable` (Lie's theorem) but has
not assembled the closure-and-descent step that turns Lie's theorem into
vanishing of the Killing-trace on `L × [L, L]`.
-/
axiom traceForm_ad_eq_zero_of_isSolvable
    {K : Type u} {L : Type v}
    [Field K] [CharZero K]
    [LieRing L] [LieAlgebra K L] [FiniteDimensional K L]
    [LieAlgebra.IsSolvable L]
    (x y : L) (_hy : y ∈ derivedSeries K L 1) :
    LinearMap.trace K _ ((LieAlgebra.ad K L x).comp (LieAlgebra.ad K L y)) = 0

end MathlibExpansion.Lie.Killing
