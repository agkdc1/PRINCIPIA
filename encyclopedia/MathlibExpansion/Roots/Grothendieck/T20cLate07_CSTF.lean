import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_07 CSTF — Compact Support + Trace Formalism (SGA 4 Exp. XVII, breach_candidate, B6)

    **Classification.** `breach_candidate` — not a predicate-on-sections shortcut;
    needs `f_!`, `RΓ_c`, localization, and trace maps as a real functorial package.
    **Citation.** Grothendieck–Verdier, *SGA 4* Exp. XVII (Deligne, *Cohomologie à
    supports propres*), §XVII.5 (compactifiable morphism → `f_!`: `D^+(X_ét) → D^+(S_ét)`
    independent of compactification); §XVII.6 (proper trace map `Tr_f : R^{2d} f_! ℤ/nℤ(d) → ℤ/nℤ`).
    Historical parent: Deligne's construction in SGA 4½ (*Cohomologie Etale*). -/
namespace MathlibExpansion
namespace Roots
namespace Grothendieck
namespace T20cLate07_CSTF

/-- **CSTF_01** proper-direct-image `f_! : D^+(X_ét) → D^+(S_ét)` for compactifiable
    morphism, independent of compactification marker (SGA 4 XVII.5.1). -/
axiom f_shriek_compactifiable_marker : True
/-- **CSTF_02** cohomology with compact support `RΓ_c(X, F) := Rf_! F` for `f : X → Spec k`
    compactifiable marker (SGA 4 XVII.5.3). -/
axiom compactly_supported_cohomology_marker : True
/-- **CSTF_03** proper trace map `Tr_f : R^{2d} f_! ℤ/nℤ(d) → ℤ/nℤ` for `f` smooth proper
    of relative dimension `d` marker (SGA 4 XVII.6.2). -/
axiom proper_trace_map_marker : True

end T20cLate07_CSTF
end Grothendieck
end Roots
end MathlibExpansion
