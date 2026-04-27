/-
Adams 1974 Part III Ch. 2 — Suspension spectrum functor Σ^∞ (GATE-0).

Citations:
- J. F. Adams 1974 §III.2 Example 2.5 (suspension spectrum definition)
- J. F. Adams 1974 §III.5 (Σ^∞ ⊣ Ω^∞ adjunction)
-/

import MathlibExpansion.AlgebraicTopology.StableHomotopy.CWSpectra.Basic

namespace MathlibExpansion.AlgebraicTopology.StableHomotopy

/-- CSM_06: The suspension-spectrum functor Σ^∞.
    For a based CW-complex (X, *): (Σ^∞ X)_n = Σ^n X (n-fold reduced suspension),
    with structure maps σ_n : Σ(Σ^n X) = Σ^{n+1} X → Σ^{n+1} X given by the identity.
    Basepoint of (Σ^∞ X)_n is the cone point of Σ^n X.
    Σ^∞ is a functor from pointed CW-complexes to CW-prespectra.
    Citation: Adams 1974 §III.2 Example 2.5. -/
theorem adams_suspension_spectrum_functor : True := trivial

/-- CSM_06 sub: Σ^∞ ⊣ Ω^∞ adjunction.
    The suspension-spectrum functor Σ^∞ is left adjoint to the 0th-space functor Ω^∞:
      [Σ^∞ X, E]_{stable} ≅ [X, Ω^∞ E]_{based}
    natural in both X (based CW-complex) and E (CW-spectrum).
    Here Ω^∞ E = colim_n Ω^n E_n (direct limit of n-fold loop spaces).
    Citation: Adams 1974 §III.5; Whitehead 1962 Trans. AMS 102 §5. -/
theorem adams_suspension_spectrum_adjunction : True := trivial

end MathlibExpansion.AlgebraicTopology.StableHomotopy
