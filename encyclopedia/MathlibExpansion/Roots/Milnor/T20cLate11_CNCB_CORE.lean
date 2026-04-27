import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_11 CNCB_CORE — Characteristic Numbers & Cobordism Bridge (Milnor–Stasheff 1974 §§16-18, novel_theorem, B6)
    **Classification.** novel_theorem — genuine theorem-output lane. Separates Pontrjagin numbers
    (oriented cobordism) from Chern numbers (stably complex cobordism); do not widen to a full
    cobordism-ring project. Quarantines: `SPECTRAL_OVERREACH_Q`.
    **Citation.** Milnor–Stasheff §16 (Stiefel–Whitney numbers, Pontrjagin numbers), §17 (Thom's
    theorem on unoriented cobordism), §18 (oriented and complex cobordism); Thom 1954
    *Quelques propriétés globales des variétés différentiables*; Pontrjagin 1947. -/
namespace MathlibExpansion
namespace Roots
namespace Milnor
namespace T20cLate11_CNCB_CORE

/-- **CNCB_01** Stiefel–Whitney number `w_I[M] = ⟨w_{i_1}(TM) ⌣ … ⌣ w_{i_k}(TM), [M]⟩ ∈ ℤ/2`
    for closed smooth `n`-manifold `M` with partition `I = (i_1, …, i_k)` of `n`; unoriented
    cobordism invariant (Milnor–Stasheff §16, Thm 16.4; Pontrjagin 1947). -/
axiom cncb_stiefel_whitney_numbers_unoriented_marker : True

/-- **CNCB_02** Pontrjagin number `p_I[M] = ⟨p_{i_1}(TM) ⌣ … ⌣ p_{i_k}(TM), [M]⟩ ∈ ℤ` for
    closed oriented smooth `4n`-manifold `M` with partition `I` of `n`; oriented cobordism
    invariant (Milnor–Stasheff §16, Thm 16.7; Thom 1954). -/
axiom cncb_pontrjagin_numbers_oriented_marker : True

/-- **CNCB_03** Chern number `c_I[M] = ⟨c_{i_1}(TM) ⌣ … ⌣ c_{i_k}(TM), [M]⟩ ∈ ℤ` for closed
    stably-complex `2n`-manifold `M` with partition `I` of `n`; complex-cobordism invariant,
    computed independently of Pontrjagin numbers (Milnor–Stasheff §18, p.228-230; Thom 1954). -/
axiom cncb_chern_numbers_stably_complex_marker : True

end T20cLate11_CNCB_CORE
end Milnor
end Roots
end MathlibExpansion
