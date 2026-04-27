import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_10 FDCSS_CORE — Filtered Double Complex Spectral Sequence (Bott–Tu 1982 §III.14, substrate_gap, B5)
    **Classification.** substrate_gap — concrete convergence machinery for Čech–de Rham / Leray;
    Mathlib has abstract SS but lacks the filtered-double-complex convergence theorem.
    Quarantines: `SPECTRAL_OVERREACH_Q`.
    **Citation.** Bott–Tu §III.14 (spectral sequence of a filtered complex, convergence,
    Čech–de Rham as E₂); Cartan–Eilenberg 1956 *Homological Algebra*. -/
namespace MathlibExpansion
namespace Roots
namespace Bott
namespace T20cLate10_FDCSS_CORE

/-- **FDCSS_01** filtered differential complex `(K^*, d, F^p)` with decreasing filtration
    `F^p K^n ⊇ F^{p+1} K^n`; associated spectral sequence `(E_r^{p,q}, d_r)` with
    `E_1^{p,q} = H^{p+q}(F^p K / F^{p+1} K)` (Bott–Tu §III.14, p.161-163). -/
axiom fdcss_filtered_complex_spectral_sequence_marker : True

/-- **FDCSS_02** convergence: `E_∞^{p,q} ≃ F^p H^{p+q}(K) / F^{p+1} H^{p+q}(K)` for bounded
    filtration — the spectral sequence converges to `H^*(K)` as an associated graded
    (Bott–Tu §III.14, Thm 14.6; Cartan–Eilenberg 1956). -/
axiom fdcss_spectral_sequence_convergence_marker : True

/-- **FDCSS_03** Čech–de Rham spectral sequence: `E_1^{p,q} = Č^p(𝒰; H^q_dR) ⇒ H^{p+q}_dR(M)`
    degenerating at `E_2` for good covers — concrete first instance of the filtered-complex
    recipe (Bott–Tu §III.14, Ex 14.14). -/
axiom fdcss_cech_de_rham_spectral_sequence_marker : True

end T20cLate10_FDCSS_CORE
end Bott
end Roots
end MathlibExpansion
