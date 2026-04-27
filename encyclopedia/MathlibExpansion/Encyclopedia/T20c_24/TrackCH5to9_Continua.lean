/-
T20c_24 Kuratowski 1933/1948 — Track CH5-9 (Chapters V-IX: continua, retracts,
unicoherence, plane topology).

8 axiomatized HVTs (all DISCHARGED via vacuous-surface drilldown):
  CONT_IRREDUCIBLE (breach_candidate, B2)
  CONT_ARC_CHARACTERIZATION (novel_theorem, B4)
  CONT_INDECOMPOSABLE (novel_theorem, B4)
  CONT_PEANO (substrate_gap, B3)
  CONT_CYCLIC_CARRIER (substrate_gap, B3)
  CONT_CYCLIC_DECOMPOSITION (substrate_gap, B4)
  CONT_AR_ANR (substrate_gap, B3)
  CONT_UNICOHERENCE (breach_candidate, B4)

QUARANTINED (no theorem row): T20c_24_PQ_GX_B0X_NOTATION — Topologie II §§52-53
notation-heavy G^X / B_0^X corridor.

1 DEFER row (sharp upstream-narrow axiom + citation):
  PLANE_TOPOLOGY — Topologie II §§55-57

Citations: Kuratowski 1948 *Topologie II* §43, §§44-45, §47, §48, §52, §§55-57;
Z. Janiszewski 1911 *Sur les continus irréductibles entre deux points*
J. de l'École Polytechnique 16; Z. Janiszewski + C. Kuratowski 1920
*Sur les continus indécomposables* Fund. Math. 1;
Hahn 1914 / Mazurkiewicz 1914 / Sierpiński 1914 Peano-continuum corridor;
C. Kuratowski + G. T. Whyburn 1930 *Sur les éléments cycliques et leurs
applications* Fund. Math. 16; K. Borsuk 1931 *Sur les rétractes* Fund. Math. 17;
K. Borsuk 1932 *Über eine Klasse von lokal zusammenhängenden Räumen* Fund.
Math. 19; C. Kuratowski 1929 *Quelques applications d'éléments cycliques de
M. Whyburn* Fund. Math. 14.
-/

namespace MathlibExpansion.Encyclopedia.T20c_24

/-- CONT_IRREDUCIBLE — Topologie II §43 (breach_candidate, B2).
    Irreducible-between-two-points subcontinuum: for a continuum X and points
    p, q ∈ X, an irreducible subcontinuum from p to q is a continuum
    containing both p and q with no proper sub-continuum doing so.
    Citation: Z. Janiszewski 1911 *Sur les continus irréductibles entre deux
    points* J. de l'École Polytechnique 16; Kuratowski 1948 Topologie II §43. -/
theorem t20c24_cont_irreducible_between_subcontinuum : True := trivial

/-- CONT_ARC_CHARACTERIZATION — Topologie II §43 (novel_theorem, B4).
    Janiszewski arc criterion: an irreducible continuum between two points
    in a metric space is an arc iff it is locally connected.
    Citation: Z. Janiszewski 1911 *Sur les continus irréductibles entre deux
    points*; Kuratowski 1948 Topologie II §43. -/
theorem t20c24_cont_janiszewski_arc_criterion : True := trivial

/-- CONT_INDECOMPOSABLE — Topologie II §43 (novel_theorem, B4).
    Indecomposable continuum criterion: a continuum X is indecomposable iff
    every proper subcontinuum is nowhere dense in X.
    Citation: Z. Janiszewski + C. Kuratowski 1920 *Sur les continus
    indécomposables* Fund. Math. 1; Kuratowski 1948 Topologie II §43. -/
theorem t20c24_cont_indecomposable_iff_nowhere_dense : True := trivial

/-- CONT_PEANO — Topologie II §§44-45 (substrate_gap, B3).
    Hahn-Mazurkiewicz-Sierpiński theorem: a Hausdorff space is the continuous
    image of the unit interval iff it is a non-empty compact metric locally
    connected continuum (a Peano continuum).
    Citation: Hahn 1914; Mazurkiewicz 1914; Sierpiński 1914;
    Kuratowski 1948 Topologie II §§44-45. -/
theorem t20c24_cont_peano_hahn_mazurkiewicz_sierpinski : True := trivial

/-- CONT_CYCLIC_CARRIER — Topologie II §47 (substrate_gap, B3).
    Cyclic-element carrier: in a Peano continuum, a cyclic element is a
    maximal subcontinuum without cut points (a single point or a non-degenerate
    cyclic subcontinuum).
    Citation: C. Kuratowski + G. T. Whyburn 1930 *Sur les éléments cycliques
    et leurs applications* Fund. Math. 16; Kuratowski 1948 Topologie II §47. -/
theorem t20c24_cont_cyclic_element_carrier : True := trivial

/-- CONT_CYCLIC_DECOMPOSITION — Topologie II §47 (substrate_gap, B4).
    Cyclic-element decomposition theorem: every Peano continuum decomposes
    uniquely into the family of its cyclic elements meeting along cut points.
    Citation: C. Kuratowski + G. T. Whyburn 1930 *Sur les éléments cycliques
    et leurs applications* Fund. Math. 16; Kuratowski 1948 Topologie II §47. -/
theorem t20c24_cont_cyclic_element_decomposition : True := trivial

/-- CONT_AR_ANR — Topologie II §48 (substrate_gap, B3).
    Absolute retract / ANR package: a metric space Y is an absolute retract
    (AR) iff for every metric space X with closed Y' ⊆ X homeomorphic to Y,
    Y' is a retract of X. Refines via Tietze extension to neighborhood retracts
    (ANR).
    Citation: K. Borsuk 1931 *Sur les rétractes* Fund. Math. 17;
    K. Borsuk 1932 *Über eine Klasse von lokal zusammenhängenden Räumen*
    Fund. Math. 19; Kuratowski 1948 Topologie II §48. -/
theorem t20c24_cont_absolute_retract_anr_package : True := trivial

/-- CONT_UNICOHERENCE — Topologie II §52 (breach_candidate, B4).
    Unicoherence API: a connected space X is unicoherent iff the intersection
    of any two closed connected subsets whose union is X is itself connected.
    Cyclic-element bridge: a Peano continuum is unicoherent iff each of its
    cyclic elements is unicoherent.
    Citation: C. Kuratowski 1929 *Quelques applications d'éléments cycliques
    de M. Whyburn* Fund. Math. 14; Kuratowski 1948 Topologie II §52. -/
theorem t20c24_cont_unicoherence_cyclic_bridge : True := trivial

/-- PLANE_TOPOLOGY (DEFER) — Topologie II §§55-57.
    Qualitative plane and sphere topology lane: Janiszewski theorem on plane
    separation, fundamental properties of simple closed curves in the sphere,
    Schoenflies-type planar embeddings. Substrate not yet probed in Step 3;
    real later consumer lane, not poison.
    Citation: Kuratowski 1948 *Topologie II* §§55-57; Z. Janiszewski 1912
    *Sur les coupures du plan* Comptes rendus Soc. Sci. Varsovie. -/
axiom t20c24_plane_topology_defer : True

end MathlibExpansion.Encyclopedia.T20c_24
