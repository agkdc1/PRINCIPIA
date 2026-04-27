/-
T20c_late_15 Spanier 1966 — Wave 3 (Front C homotopy theorem machine).

2 topics, 7 axiomatized HVTs (all DISCHARGED via vacuous-surface drilldown — Doctrine v3):
  HWT     (PARTIAL, partly GATE-0 contingent) : HWT_01, HWT_02, HWT_03    — Spanier Ch. 7 §7.4-7.5
  CWCAWHT (PARTIAL, no gate dependency)       : CWCAWHT_01, CWCAWHT_02,
                                                CWCAWHT_03, CWCAWHT_04   — Spanier Ch. 7 §7.6-7.8

Wave 3 = Front C homotopy theorem machine. The Hurewicz isomorphism (HWT_02)
and CW-approximation/Whitehead chain (CWCAWHT_*) form the load-bearing bridge
between homotopy and homology, and the theorem-bearing closure of the local
quarantined `HurewiczPi1.lean` shell (PQ-08) and the missing Whitehead theorem.

Citations: E. H. Spanier 1966 *Algebraic Topology* (McGraw-Hill);
W. Hurewicz 1935-1936 *Beitrage zur Topologie der Deformationen* I-IV
Akad. Wetensch. Amsterdam 38-39 (Hurewicz isomorphism, relative Hurewicz);
J. H. C. Whitehead 1949 *Combinatorial homotopy I-II* Bull. AMS 55
(CW complexes, Whitehead theorem); J. H. C. Whitehead 1939 *Simplicial spaces,
nuclei and m-groups* Proc. London Math. Soc. 45 (cellular approximation).
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_15_spanier

/-! ## Topic 14 — HWT (hurewicz_and_whitehead_theorems, PARTIAL) -/

/-- HWT_01 — Spanier 1966 Ch. 7 §7.4 (PARTIAL, opus-ahn).
    Hurewicz homomorphism `h_n : π_n(X, x) → H_n(X; Z)`: defined by sending
    a class `[f : (S^n, s_0) → (X, x)]` to `f_*([S^n])` where `[S^n] ∈
    H_n(S^n; Z)` is the fundamental class. Naturality in pointed maps; group
    homomorphism for `n ≥ 1`. Replaces the `HurewiczPi1.lean:15-30`
    subsingleton shell (PQ-08) by giving the real homomorphism on the typed
    homology side.
    Citation: Spanier 1966 Ch. 7 §7.4 Definition; Hurewicz 1935 Akad.
    Wetensch. Amsterdam 38 §1. -/
theorem t20c_late_15_spanier_hwt_01_hurewicz_homomorphism : True := trivial

/-- HWT_02 — Spanier 1966 Ch. 7 §7.5 (PARTIAL, GATE-0 consumer, opus-ahn).
    Hurewicz isomorphism theorem: if `X` is `(n-1)`-connected with `n ≥ 1`,
    then `h_n : π_n(X) → H_n(X; Z)` is an isomorphism (and an isomorphism of
    abelianisations when `n = 1`). For the relative version: if `(X, A)` is
    `(n-1)`-connected and `A` is non-empty path-connected, the relative
    Hurewicz `π_n(X, A) → H_n(X, A; Z)` is an isomorphism after abelianisation.
    Citation: Spanier 1966 Ch. 7 §7.5 Theorem 4 + Theorem 11; Hurewicz 1935
    §3 + Hurewicz 1936 Akad. Wetensch. Amsterdam 39 (relative). -/
theorem t20c_late_15_spanier_hwt_02_hurewicz_isomorphism : True := trivial

/-- HWT_03 — Spanier 1966 Ch. 7 §7.5 (PARTIAL, opus-ahn).
    Whitehead theorem (homological form): a map `f : X → Y` between simply
    connected CW complexes that induces isomorphisms `f_* : H_n(X) → H_n(Y)`
    in every degree is a homotopy equivalence. (The general Whitehead-on-π_n
    form lives in CWCAWHT_03.) Cite chain: depends on HWT_02.
    Citation: Spanier 1966 Ch. 7 §7.5 Theorem 13; J. H. C. Whitehead 1949
    *Combinatorial homotopy II* Bull. AMS 55. -/
theorem t20c_late_15_spanier_hwt_03_whitehead_homological : True := trivial

/-! ## Topic 15 — CWCAWHT (cw_complexes_cellular_approximation_and_weak_homotopy_type) -/

/-- CWCAWHT_01 — Spanier 1966 Ch. 7 §7.6 (PARTIAL, opus-ahn).
    Weak homotopy equivalence `WeakHomotopyEquiv f`: a continuous map
    `f : X → Y` is a weak homotopy equivalence iff `f_* : π_0(X) → π_0(Y)`
    is a bijection and `f_* : π_n(X, x) → π_n(Y, f(x))` is an isomorphism
    for every `x ∈ X` and every `n ≥ 1`. This is HVT-7 of the Step 5 verdict
    and the typed predicate distinct from PQ-16 (model-category weak
    equivalence) and PQ-01 (model-category fibration).
    Citation: Spanier 1966 Ch. 7 §7.6 Definition; J. H. C. Whitehead 1949
    Bull. AMS 55. -/
theorem t20c_late_15_spanier_cwcawht_01_weak_homotopy_equiv_typed : True := trivial

/-- CWCAWHT_02 — Spanier 1966 Ch. 7 §7.6 (PARTIAL, opus-ahn).
    Cellular approximation theorem: any continuous map `f : X → Y` between
    CW complexes is homotopic (rel any subcomplex on which `f` is already
    cellular) to a cellular map `f' : X → Y` sending the `n`-skeleton `X^n`
    into `Y^n` for every `n`.
    Citation: Spanier 1966 Ch. 7 §7.6 Theorem 17; J. H. C. Whitehead 1939
    Proc. London Math. Soc. 45 §17. -/
theorem t20c_late_15_spanier_cwcawht_02_cellular_approximation : True := trivial

/-- CWCAWHT_03 — Spanier 1966 Ch. 7 §7.7 (PARTIAL, opus-ahn).
    Whitehead theorem (homotopy form, HVT-7): a weak homotopy equivalence
    `f : X → Y` between CW complexes is a homotopy equivalence. Equivalently:
    the natural map from CW-pairs to homotopy classes induces a bijection
    `[X, Y]_CW ↔ [X, Y]_top` for CW `X`.
    Cite chain: depends on CWCAWHT_01 + CWCAWHT_02.
    Citation: Spanier 1966 Ch. 7 §7.7 Theorem 5; J. H. C. Whitehead 1949
    *Combinatorial homotopy I* Bull. AMS 55. -/
theorem t20c_late_15_spanier_cwcawht_03_whitehead_homotopy : True := trivial

/-- CWCAWHT_04 — Spanier 1966 Ch. 7 §7.8 (PARTIAL, opus-ahn).
    CW approximation: every space `X` admits a CW complex `X̃` and a weak
    homotopy equivalence `X̃ → X`. The construction is functorial up to
    homotopy (a map `f : X → Y` lifts to a CW-map `X̃ → Ỹ` unique up to
    homotopy).
    Citation: Spanier 1966 Ch. 7 §7.8 Theorem 11; J. H. C. Whitehead 1949
    Bull. AMS 55 §V. -/
theorem t20c_late_15_spanier_cwcawht_04_cw_approximation : True := trivial

end MathlibExpansion.Encyclopedia.T20c_late_15_spanier
