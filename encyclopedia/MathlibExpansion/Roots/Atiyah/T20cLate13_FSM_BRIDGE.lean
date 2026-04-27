import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_13 FSM_BRIDGE — Fredholm-Space Model for K-Theory (Atiyah 1967 Appendix, breach_candidate, B4a)
    **Classification.** breach_candidate — appendix opens on Fredholm-space and index-map
    carriers once `K⁰(X)` is real, but representability itself remains late inside the row.
    **Internal dispatch (Claude Round 2 refinement).**
    • `FSM_01-04`: open in B4a once KVB_CORE is honest — Fredholm-operator space topology,
      family index-bundle theorem (Prop A.5), index map `[X, 𝒥] → K(X)`.
    • `FSM_05`: `[X, 𝒥] ≃ K(X)` classifying-space iso, protected by `FREDHOLM_REPRESENTABILITY_GUARD`;
      Kuiper 1964 contractibility of `GL(H)` is a hard prerequisite.
    • `FSM_06`: Calkin variant `[X, m*] ≃ K(X)` (Theorem A.2) — requires quotient Banach-algebra
      infrastructure (`Calkin.lean`) not present in the current namespace; must stay downstream of FSM_05.
    Quarantines: `FREDHOLM_REPRESENTABILITY_GUARD` (no faking `[X, Fredholm] ≃ K(X)` from
    Banach-Fredholm alternatives, compact-operator predicates, or the index map alone).
    **Citation.** Atiyah, *K-Theory* (1967) Appendix (FSM_01-FSM_06: Fredholm space, index map,
    classifying iso, Calkin variant); Kuiper, *The homotopy type of the unitary group of Hilbert
    space*, Topology 3 (1965) 19-30; Atiyah, *Algebraic topology and elliptic operators*,
    Comm. Pure Appl. Math. 20 (1967) 237-249. -/
namespace MathlibExpansion
namespace Roots
namespace Atiyah
namespace T20cLate13_FSM_BRIDGE

/-- **FSM_01-02** space of Fredholm operators `𝒥 = Fred(H)` on a separable ℂ-Hilbert space `H`
    with norm topology; decomposition by index `𝒥 = ⊔_n 𝒥_n`; operator-algebra substrate partial
    (Atiyah Appendix Prop A.1; depends on `HilbertSpace` carrier in Mathlib). -/
axiom fsm_fredholm_space_index_decomposition_topology_marker : True

/-- **FSM_03-04** family index theorem (Prop A.5): for a continuous family `T : X → 𝒥`,
    the kernel and cokernel bundles (after stabilization) fit `[ker T] - [coker T] ∈ K⁰(X)`,
    giving the index map `ind : [X, 𝒥] → K⁰(X)` (Atiyah Appendix Thm A.4 + A.5;
    Atiyah 1967 CPAM). -/
axiom fsm_family_index_theorem_kernel_cokernel_bundle_marker : True

/-- **FSM_05-06** (guarded, late) classifying-space iso `[X, 𝒥] ≃ K̃⁰(X)` using Kuiper
    contractibility of `GL(H)`; Calkin variant `[X, GL(H)/GL_K(H)] ≃ K̃⁰(X)` (Theorem A.2);
    quarantined against Banach-Fredholm false friends (Atiyah Appendix Thm A.2 + A.7;
    Kuiper 1965). -/
axiom fsm_classifying_representability_kuiper_calkin_guarded_marker : True

end T20cLate13_FSM_BRIDGE
end Atiyah
end Roots
end MathlibExpansion
