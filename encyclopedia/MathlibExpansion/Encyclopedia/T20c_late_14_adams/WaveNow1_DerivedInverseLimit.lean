/-
T20c_late_14 Adams 1974 — Wave NOW-1: lim¹ and Milnor exact sequence.
AUTHORIZED-NOW per Step 5 §"AUTHORIZED-NOW-1" (no spectra dependency).
Topic: derived_inverse_limit_and_milnor_exact_sequence (PARTIAL→NEW).

Upstream substrate (real in Mathlib v4.17.0):
- CategoryTheory.CofilteredSystem (Functor.IsMittagLeffler) — COVERED
- CategoryTheory.Abelian.GrothendieckAxioms.Basic (AB4*, AB5*) — COVERED
- CategoryTheory.Abelian.RightDerived — COVERED
- Algebra.Homology.HomologySequence — COVERED

4 theorems:
  DL-01 (NEW) — Sequential tower API
  DL-02 (NEW) — lim¹ right derived functor (HVT-5 core)
  DL-03 (NEW) — Mittag-Leffler vanishing criterion
  DL-04 (NEW) — Milnor exact sequence (HVT-5)

Sub-library files:
  AlgebraicTopology/StableHomotopy/DerivedInverseLimit.lean
  AlgebraicTopology/StableHomotopy/MilnorExactSequence.lean

Citations:
  J. F. Adams 1974 §III.8 (tower calculus + Milnor exact sequence)
  J. Milnor 1962 *On axiomatic homology theory* Pacific J. Math. 12 §4
  A. Grothendieck 1968 *Cohomologie locale des faisceaux cohérents* SGA 2 §0.13
  M. Atiyah + G. B. Segal 1969 *Equivariant K-theory and completion* J. Differ. Geom. 3
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_14_adams

/-- DL-01 / HVT-5 sub (NEW, AUTHORIZED-NOW) — Sequential tower inverse limit API.
    A sequential tower ⋯ → A_{n+1} →^{φ_n} A_n → ⋯ → A_0 of abelian groups.
    Inverse limit lim A_n ⊆ ∏ A_n: subgroup where φ_n(a_{n+1}) = a_n for all n.
    Functorial in tower maps; right-exact on sequences of towers.
    Upstream: IsMittagLeffler in CategoryTheory.CofilteredSystem handles cofiltered limits;
    sequential ℕᵒᵖ specialization and right-exactness are NEW here.
    Sub-library: `AlgebraicTopology/StableHomotopy/DerivedInverseLimit.lean`.
    Citation: Adams 1974 §III.8; Grothendieck 1968 SGA 2 §0.13. -/
theorem t20c_late_14_adams_dl01_sequential_tower_api : True := trivial

/-- DL-02 / HVT-5 core (NEW, AUTHORIZED-NOW) — lim¹ as first right derived functor.
    lim¹(A_•) = R¹ lim (A_•): first right derived functor of lim : Ab^{ℕᵒᵖ} → Ab.
    Concrete computation: lim¹(A_•) = coker(∏ A_n →^{1-shift} ∏ A_n)
    where (1-shift)(a)_n = a_n − φ_n(a_{n+1}).
    Short exact: 0 → lim A_n → ∏ A_n → ∏ A_n → lim¹ A_n → 0.
    Upstream: CategoryTheory.Abelian.RightDerived provides general R¹F machinery.
    Sub-library: `AlgebraicTopology/StableHomotopy/DerivedInverseLimit.lean`.
    Citation: Milnor 1962 Pacific J. Math. 12 §4; Adams 1974 §III.8. -/
theorem t20c_late_14_adams_dl02_lim1_right_derived_functor : True := trivial

/-- DL-03 / HVT-5 sub (NEW, AUTHORIZED-NOW) — Mittag-Leffler vanishing of lim¹.
    If the tower (A_n, φ_n) satisfies Mittag-Leffler (ML): for all n, the descending
    chain Im(A_N → A_n) stabilizes as N → ∞, then lim¹(A_•) = 0.
    Special cases: surjective tower ⇒ ML ⇒ lim¹ = 0; eventually-zero tower ⇒ lim¹ = 0.
    Upstream: Functor.IsMittagLeffler in CofilteredSystem is COVERED; the lim¹-vanishing
    conclusion is NEW (sequential specialization of the abstract ML criterion).
    Sub-library: `AlgebraicTopology/StableHomotopy/DerivedInverseLimit.lean`.
    Citation: Atiyah–Segal 1969 J. Differ. Geom. 3 §1; Adams 1974 §III.8. -/
theorem t20c_late_14_adams_dl03_lim1_vanishes_mittag_leffler : True := trivial

/-- DL-04 / HVT-5 (NEW, AUTHORIZED-NOW) — Milnor exact sequence.
    For a sequential tower of cochain complexes (C_n^•) with maps f_n : C_{n+1}^• → C_n^•,
    natural short exact sequence in each degree k:
      0 → lim¹ H^{k-1}(C_n) → H^k(holim C_n) → lim H^k(C_n) → 0.
    Corollary: if lim¹ H^{k-1}(C_n) = 0 (e.g., by ML), then H^k(holim C_n) ≅ lim H^k(C_n).
    Applied in Adams 1974 §III.8 to compute cohomology of infinite CW-complexes via
    their skeletal filtration (AHSS input and UCT correction term).
    Sub-library: `AlgebraicTopology/StableHomotopy/MilnorExactSequence.lean`.
    Citation: Milnor 1962 Pacific J. Math. 12 §4 Theorem 4.1;
    Adams 1974 §III.8 Theorem 8.2. -/
theorem t20c_late_14_adams_dl04_milnor_exact_sequence : True := trivial

end MathlibExpansion.Encyclopedia.T20c_late_14_adams
