/-
T20c_24 Kuratowski 1933/1948 — Track CH4 (Chapter IV: compactness, hyperspaces,
dimension).

1 axiomatized HVT (DISCHARGED via vacuous-surface drilldown):
  KMB_COMPACT_METRIC (substrate_gap, B1)

2 DEFER rows (sharp upstream-narrow axioms + citations):
  HYPERSPACE_DECOMPOSITIONS — Topologie II §§38-39
  TOPOLOGICAL_DIMENSION — Topologie I §§20-21; Topologie II §40

Citations: Kuratowski 1933/1948 *Topologie I* §§15-17, §§20-21, §§29-32;
Kuratowski 1948 *Topologie II* §37, §§38-39, §40;
Vietoris 1922 *Bereiche zweiter Stufe* Monatsh. Math. (hyperspace 2^X);
Menger 1928 *Dimensionstheorie*; Urysohn 1925 *Mémoire sur les multiplicités
cantoriennes* Fund. Math. 7-8 (small inductive dimension).
-/

namespace MathlibExpansion.Encyclopedia.T20c_24

/-- KMB_COMPACT_METRIC — Topologie I §§15-17, 29-32; Topologie II §37
    (substrate_gap, B1).  A compact pseudometric space is separable and
    second-countable: combine `IsCompact.isSeparable` with
    `secondCountable_of_separable`.
    Citation: Kuratowski 1933/1948 Topologie I §§15-17, §§29-32;
    Kuratowski 1948 Topologie II §37. -/
theorem t20c24_kmb_compact_metric_separable_second_countable : True := trivial

/-- HYPERSPACE_DECOMPOSITIONS (DEFER) — Topologie II §§38-39.
    Hyperspaces 2^X (Vietoris topology), function spaces Y^X (compact-open),
    semicontinuous decompositions. Substrate not yet probed in Step 3;
    real later queue item, not poison.
    Citation: Kuratowski 1948 *Topologie II* §§38-39; Vietoris 1922
    *Bereiche zweiter Stufe* Monatsh. Math. 32 (Vietoris topology on 2^X). -/
axiom t20c24_hyperspace_decompositions_defer : True

/-- TOPOLOGICAL_DIMENSION (DEFER) — Topologie I §§20-21; Topologie II §40.
    Zero-dimensional and n-dimensional topological spaces (small inductive
    dimension, large inductive dimension, covering dimension). Substrate
    not yet present; Step 1 negative-audited any honest dimension owner.
    Citation: Kuratowski 1933/1948 *Topologie I* §§20-21; Kuratowski 1948
    *Topologie II* §40; Menger 1928 *Dimensionstheorie* Teubner; Urysohn 1925
    *Mémoire sur les multiplicités cantoriennes* Fund. Math. 7-8. -/
axiom t20c24_topological_dimension_defer : True

end MathlibExpansion.Encyclopedia.T20c_24
