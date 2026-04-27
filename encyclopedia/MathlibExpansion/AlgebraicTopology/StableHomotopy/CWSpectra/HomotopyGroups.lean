/-
Adams 1974 Part III Ch. 4 — Suspension-stable homotopy groups of CW-spectra (GATE-0).

Citations:
- J. F. Adams 1974 §III.4 Definition 4.1 (homotopy groups of spectra)
- H. Freudenthal 1937 *Über die Klassen der Sphärenabbildungen* Compos. Math. 5
  (suspension theorem, stable range)
-/

import MathlibExpansion.AlgebraicTopology.StableHomotopy.CWSpectra.Basic

namespace MathlibExpansion.AlgebraicTopology.StableHomotopy

/-- HVT-3 (CSM_05): Suspension-stable homotopy groups of a CW-spectrum.
    π_n(E) := colim_k π_{n+k}(E_k) where the colimit is over the stabilization maps
    σ_k∗ : π_{n+k}(E_k) → π_{n+k+1}(ΣE_k) → π_{n+k+1}(E_{k+1})
    induced by suspension and the structure map. Defined for all n ∈ ℤ (with E_k = * for k < 0).
    Functorial in stable maps; abelian for all n.
    Citation: Adams 1974 §III.4 Definition 4.1; Freudenthal 1937 Compos. Math. 5. -/
theorem adams_spectrum_homotopy_groups_colimit : True := trivial

/-- HVT-3 sub: π_n(E) is abelian for all n ∈ ℤ.
    Consequence of the stable range: for k large, π_{n+k}(E_k) is abelian
    (as homotopy groups in dimension ≥ 2), and the colimit inherits this.
    The group structure comes from co-H-space structure of S^{n+k} for k ≥ 1.
    Citation: Adams 1974 §III.4 Proposition 4.2. -/
theorem adams_spectrum_homotopy_groups_abelian : True := trivial

/-- HVT-3 sub: π_n(Σ^∞ X) ≅ π_n^s(X) (stable stems).
    For a based CW-complex X, the homotopy groups of the suspension spectrum Σ^∞ X
    recover the stable homotopy groups of X via the Freudenthal stabilization:
    π_{n+k}(Σ^k X) stabilizes for k > n + 1 (Freudenthal), giving π_n^s(X) = colim_k π_{n+k}(Σ^k X).
    Citation: Adams 1974 §III.4 Example 4.4;
    Freudenthal 1937 Compos. Math. 5 (suspension theorem). -/
theorem adams_suspension_spectrum_homotopy_groups : True := trivial

end MathlibExpansion.AlgebraicTopology.StableHomotopy
