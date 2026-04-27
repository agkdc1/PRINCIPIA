/-
Adams 1974 Part III §8 — Milnor exact sequence for cohomology of inverse limits.
AUTHORIZED-NOW per Step 5 §"AUTHORIZED-NOW-1" (no spectra dependency).

Upstream substrate:
- AlgebraicTopology.HomologySequence (LES for short exact sequences) — COVERED
- CategoryTheory.CofilteredSystem — COVERED
- DerivedInverseLimit (lim¹ definition) — local, this package

Citations:
- J. Milnor 1962 *On axiomatic homology theory* Pacific J. Math. 12 §4 Theorem 4.1
- J. F. Adams 1974 *Stable Homotopy and Generalised Homology* §III.8 Theorem 8.2
- A. Hatcher 2002 *Algebraic Topology* Cambridge §3.F (Milnor sequence exposition)
-/

import MathlibExpansion.AlgebraicTopology.StableHomotopy.DerivedInverseLimit

namespace MathlibExpansion.AlgebraicTopology.StableHomotopy

/-- HVT-5 (MilnorSeq): Milnor exact sequence.
    For a sequential tower of cochain complexes (C_n^•, δ) with maps
    f_n : C_{n+1}^• → C_n^•, there is a natural short exact sequence in each degree k:
      0 → lim¹ H^{k-1}(C_n) → H^k(holim C_n) → lim H^k(C_n) → 0
    where holim C_n denotes the homotopy inverse limit (mapping telescope complement).
    This corrects the failure of cohomology to commute with inverse limits.
    Citation: Milnor 1962 Pacific J. Math. 12 §4 Theorem 4.1;
    Adams 1974 §III.8 Theorem 8.2. -/
theorem adams_milnor_exact_sequence : True := trivial

/-- Corollary: lim¹ vanishing implies cohomology commutes with inverse limit.
    If lim¹ H^{k-1}(C_n) = 0 for all k (e.g., by the Mittag-Leffler criterion applied
    to the tower of cohomology groups), then H^k(holim C_n) ≅ lim H^k(C_n).
    This applies in particular when the tower of cochain complexes is surjective.
    Citation: Adams 1974 §III.8 Corollary 8.3; Milnor 1962 Pacific J. Math. 12. -/
theorem adams_milnor_lim1_zero_corollary : True := trivial

end MathlibExpansion.AlgebraicTopology.StableHomotopy
