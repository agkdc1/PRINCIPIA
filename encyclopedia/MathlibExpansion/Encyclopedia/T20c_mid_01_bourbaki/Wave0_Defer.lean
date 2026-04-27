/-
T20c_mid_01 Bourbaki, *Théorie des Ensembles* (1939 fascicle / 1954 Ch.I-II /
1956 Ch.III / 1957 Ch.IV / 1970 combined volume) — Wave 0 (DEFER bundle).

10 DEFER topics — sharp upstream-narrow `axiom : True` per Doctrine v3 §4
("file sharp upstream-narrow axiom + citation-backed doc string"):

  D-SET-RELATIONS    Ch. II §§1-3   pairs, correspondences, set-theoretic relations
  D-FUNCTION-GRAPHS  Ch. II §§1-3   functions as graphs with domain/codomain
  D-FAMILY-OPS       Ch. II §§4-5   indexed unions / intersections / products
  D-EQUIV-QUOTIENTS  Ch. II §6      equivalence relations + quotient sets + partitions
  D-ORDERED-SETS     Ch. III §1     ordered sets and order-type vocabulary
  D-WELL-ORDERS      Ch. III §2     well-orders + transfinite induction (provisional)
  D-CARDINALS        Ch. III §3     equipotence classes + cardinal arithmetic
  D-NAT-FINITE       Ch. III §§4-5  set-theoretic naturals + finite-set reconstruction
  D-INFINITE-COUNTABLE Ch. III §6   infinite + countable + denumerable packaging
  D-ZERMELO-BRIDGE   Ch. II-III     bridge to existing local Zermelo wrappers

Per Step 5 verdict §3 `B0`: these are citation/wrapper lanes that should not
receive expensive deep-theory treatment in Round 1. None of these has a Step 3
recon report; opening any of them now would dilute effort away from Chapter I
(formal-language facade) and Chapter IV (structuralism breach).

QUARANTINE (no Lean axiom row, doctrine controls only):

  POISON LEDGER (verdict §5):
    - `1935_as_full_textbook_date` — theorem-bearing spine is 1954-1957;
      1939 fascicle provenance, 1970 combined-volume witness.
    - `chapter_i_equals_lean_kernel` — Chapter I is object-language
      mathematics, NOT Lean's host logic (kernel of `Prop`).
    - `restricted_derivability_as_chapter_i_owner` — `HilbertAckermann/Restricted`
      collapses theoremhood into Lean truth; cannot own the Bourbaki facade.
    - `functions_as_bare_lambdas_only` — Bourbaki's graph/domain/codomain
      packaging cannot be silently erased.
    - `chapter_iv_already_done_by_category_theory` — Mathlib's category-specific
      universal-property APIs are NOT a Bourbaki `Structures` owner layer.
    - `species_as_untyped_record_folklore` — species require transport and
      invariance data, not ad hoc records.
    - `set_limits_replaced_by_raw_categorical_limits` — Ch. III §7 is phrased
      in systems of sets and mappings; categorical reformulation requires
      explicit translation, not silent identification.
    - `zermelo_rows_reopened_as_greenfield` — existing local Zermelo wrappers
      are to be consumed, not replaced.

Citations (Bourbaki + upstream owners):
N. Bourbaki 1954 *Éléments de mathématique, Théorie des ensembles, Chapitres I-II*
Hermann (Paris), Actualités Sci. Indust. 1212;
N. Bourbaki 1956 *Éléments de mathématique, Théorie des ensembles, Chapitre III*
Hermann (Paris), Actualités Sci. Indust. 1243;
N. Bourbaki 1957 *Éléments de mathématique, Théorie des ensembles, Chapitre IV*
Hermann (Paris), Actualités Sci. Indust. 1258;
N. Bourbaki 1970 *Théorie des ensembles* (combined four-chapter volume)
Hermann (Paris) → Diffusion C.C.L.S.;
G. Cantor 1895 + 1897 *Beiträge zur Begründung der transfiniten Mengenlehre*
Math. Ann. 46 + 49 (cardinal/order-type lineage);
F. Hausdorff 1914 *Grundzüge der Mengenlehre* Veit (Leipzig)
(well-order organization);
E. Zermelo 1908 *Untersuchungen über die Grundlagen der Mengenlehre I*
Math. Ann. 65 (axiomatic set theory + choice);
R. Dedekind 1888 *Was sind und was sollen die Zahlen?* Vieweg
(simply infinite + recursion);
D. Hilbert + W. Ackermann 1928 *Grundzüge der theoretischen Logik* Springer
(predicate calculus comparison);
B. Russell + A. N. Whitehead 1910-1913 *Principia Mathematica* Cambridge
(formal-language shadow comparison).
-/

namespace MathlibExpansion.Encyclopedia.T20c_mid_01_bourbaki

/-! ## D-SET-RELATIONS (DEFER, sonnet-ahn) — Bourbaki Ch. II §§1-3 -/

/-- D-SET-RELATIONS (DEFER) — Bourbaki 1954 Ch. II §§1-3.
    Pairs, correspondences, and set-theoretic relations. COVERED upstream
    in `Mathlib/Data/Set/Defs.lean`, `Mathlib/Data/Prod/Basic.lean`, and
    `Mathlib/Logic/Relation.lean`. Hard boundary: only the Bourbaki naming
    bridge (`correspondance` ↔ `Set.Rel`) is open; not a mainline Bourbaki
    owner. The local axiom row exists only as a sharp citation marker per
    Doctrine v3 §4.
    Citation: Bourbaki 1954 Ch. II §§1-3; upstream `Mathlib/Data/Set/Defs.lean`. -/
axiom t20c_mid_01_bourbaki_d_set_relations_defer_cite_upstream : True

/-! ## D-FUNCTION-GRAPHS (DEFER, sonnet-ahn) — Bourbaki Ch. II §§1-3 -/

/-- D-FUNCTION-GRAPHS (DEFER) — Bourbaki 1954 Ch. II §§1-3.
    Functions as set-theoretic graphs with explicit domain/codomain
    discipline. COVERED upstream by Mathlib's bundled `Function` API plus
    `Set.image` / `Set.preimage`; the textbook-traceable graph form is
    `{(x, f x) : x ∈ Set.univ} ⊆ A × B`. Hard boundary: a graph-vs-lambda
    naming bridge is the only open piece; per Step 5 verdict (§4 B0) do not
    open without a consumer proving graph/domain/codomain packaging is still
    load-bearing. The local axiom row exists only as a sharp citation marker
    per Doctrine v3 §4.
    Citation: Bourbaki 1954 Ch. II §§1-3; upstream `Mathlib/Logic/Function/Basic.lean`. -/
axiom t20c_mid_01_bourbaki_d_function_graphs_defer_cite_upstream : True

/-! ## D-FAMILY-OPS (DEFER, sonnet-ahn) — Bourbaki Ch. II §§4-5 -/

/-- D-FAMILY-OPS (DEFER) — Bourbaki 1954 Ch. II §§4-5.
    Indexed unions, intersections, and products of families of sets.
    COVERED upstream by `Mathlib/Order/SetNotation.lean` (`⋃ i, S i` and
    `⋂ i, S i`) and `Mathlib/Data/Set/Pi.lean` (`Set.pi`). Hard boundary:
    only Bourbaki notation faithfulness remains; the local axiom row exists
    only as a sharp citation marker per Doctrine v3 §4.
    Citation: Bourbaki 1954 Ch. II §§4-5; upstream `Mathlib/Order/SetNotation.lean`
    + `Mathlib/Data/Set/Pi.lean`. -/
axiom t20c_mid_01_bourbaki_d_family_ops_defer_cite_upstream : True

/-! ## D-EQUIV-QUOTIENTS (DEFER, sonnet-ahn) — Bourbaki Ch. II §6 -/

/-- D-EQUIV-QUOTIENTS (DEFER) — Bourbaki 1954 Ch. II §6.
    Equivalence relations, quotient sets, and partition viewpoint. COVERED
    upstream by `Mathlib/Data/Setoid/Basic.lean` (Setoid + Quotient) and
    `Mathlib/Data/Setoid/Partition.lean` (partition equivalence). Hard
    boundary: only a partition-language seam needs a Bourbaki naming bridge;
    the local axiom row exists only as a sharp citation marker per
    Doctrine v3 §4.
    Citation: Bourbaki 1954 Ch. II §6; upstream `Mathlib/Data/Setoid/Basic.lean`. -/
axiom t20c_mid_01_bourbaki_d_equiv_quotients_defer_cite_upstream : True

/-! ## D-ORDERED-SETS (DEFER, sonnet-ahn) — Bourbaki Ch. III §1 -/

/-- D-ORDERED-SETS (DEFER) — Bourbaki 1956 Ch. III §1.
    Ordered sets and order-type vocabulary. COVERED upstream by
    `Mathlib/Order/Defs/PartialOrder.lean`, `Mathlib/Order/Defs/LinearOrder.lean`,
    and the `OrderHom` packaging in `Mathlib/Order/Hom/Basic.lean`. Per
    Step 5 verdict (§3 B0): consume existing order APIs first; do not spawn
    a Bourbaki-specific order front from Step 1 alone. The local axiom row
    exists only as a sharp citation marker per Doctrine v3 §4.
    Citation: Bourbaki 1956 Ch. III §1; F. Hausdorff 1914 *Grundzüge der
    Mengenlehre* Veit Ch. VI; upstream `Mathlib/Order`. -/
axiom t20c_mid_01_bourbaki_d_ordered_sets_defer_cite_upstream : True

/-! ## D-WELL-ORDERS (DEFER, sonnet-ahn) — Bourbaki Ch. III §2 -/

/-- D-WELL-ORDERS (DEFER) — Bourbaki 1956 Ch. III §2.
    Well-orders, induction, and transfinite organization. COVERED upstream
    by `Mathlib/Order/WellFounded.lean` and `Mathlib/SetTheory/Ordinal/Basic.lean`.
    Per Step 5 verdict (§1 row 9): provisional defer — route through the
    Cantor/Hausdorff ordinal infrastructure unless a Step 3 proves a genuine
    wrapper gap. The local axiom row exists only as a sharp citation marker
    per Doctrine v3 §4.
    Citation: Bourbaki 1956 Ch. III §2; G. Cantor 1897 Math. Ann. 49;
    F. Hausdorff 1914 Veit Ch. V. -/
axiom t20c_mid_01_bourbaki_d_well_orders_defer_cite_upstream : True

/-! ## D-CARDINALS (DEFER, sonnet-ahn) — Bourbaki Ch. III §3 -/

/-- D-CARDINALS (DEFER) — Bourbaki 1956 Ch. III §3.
    Equipotence classes and cardinal arithmetic naming bridge. COVERED
    upstream by `Mathlib/SetTheory/Cardinal/Basic.lean` and
    `Mathlib/SetTheory/Cardinal/Aleph.lean`. Hard boundary: pure citation
    lane into Cantor-facing substrate. The local axiom row exists only as
    a sharp citation marker per Doctrine v3 §4.
    Citation: Bourbaki 1956 Ch. III §3; G. Cantor 1895 Math. Ann. 46;
    G. Cantor 1897 Math. Ann. 49. -/
axiom t20c_mid_01_bourbaki_d_cardinals_defer_cite_upstream : True

/-! ## D-NAT-FINITE (DEFER, sonnet-ahn) — Bourbaki Ch. III §§4-5 -/

/-- D-NAT-FINITE (DEFER) — Bourbaki 1956 Ch. III §§4-5.
    Set-theoretic natural numbers and finite-set reconstruction. COVERED
    upstream by `Mathlib/Data/Nat/Defs.lean`, `Mathlib/Data/Finset/Basic.lean`,
    and `Mathlib/Data/Fintype/Basic.lean`. Per Step 5 verdict (§1 row 11):
    consume existing Dedekind/Zermelo infrastructure; no new owner row
    justified. The local axiom row exists only as a sharp citation marker
    per Doctrine v3 §4.
    Citation: Bourbaki 1956 Ch. III §§4-5; R. Dedekind 1888 *Was sind und
    was sollen die Zahlen?* Vieweg §§7-13. -/
axiom t20c_mid_01_bourbaki_d_nat_finite_defer_cite_upstream : True

/-! ## D-INFINITE-COUNTABLE (DEFER, sonnet-ahn) — Bourbaki Ch. III §6 -/

/-- D-INFINITE-COUNTABLE (DEFER) — Bourbaki 1956 Ch. III §6.
    Infinite, countable, and denumerable set packaging. COVERED upstream by
    `Mathlib/Data/Countable/Basic.lean` and the `Set.Countable` API in
    `Mathlib/Data/Set/Countable.lean`. Hard boundary: pure citation lane
    into Cantor/Zermelo/Hausdorff work. The local axiom row exists only as
    a sharp citation marker per Doctrine v3 §4.
    Citation: Bourbaki 1956 Ch. III §6; G. Cantor 1874 J. reine angew. Math. 77;
    G. Cantor 1891 Jahresbericht DMV 1; F. Hausdorff 1914 Veit Ch. III. -/
axiom t20c_mid_01_bourbaki_d_infinite_countable_defer_cite_upstream : True

/-! ## D-ZERMELO-BRIDGE (DEFER, sonnet-ahn) — Bourbaki Ch. II-III cross-cutting -/

/-- D-ZERMELO-BRIDGE (DEFER) — Bourbaki 1954-1956 Ch. II-III cross-cutting.
    Bridge to existing local Zermelo wrappers for choice, separation, and
    number-row infrastructure. COVERED upstream by Mathlib's `Classical.choice`
    + `Set.choose` + `WellFoundedRelation` + the local
    `MathlibExpansion/Foundations/Zermelo*` files. Per Step 5 verdict (§5
    poison ledger): existing local Zermelo wrappers are to be CONSUMED, not
    replaced — opening as greenfield is forbidden. The local axiom row exists
    only as a sharp citation marker per Doctrine v3 §4.
    Citation: Bourbaki 1954 Ch. II + 1956 Ch. III; E. Zermelo 1908
    *Untersuchungen über die Grundlagen der Mengenlehre I* Math. Ann. 65;
    E. Zermelo 1904 Math. Ann. 59 (well-ordering theorem). -/
axiom t20c_mid_01_bourbaki_d_zermelo_bridge_defer_cite_upstream : True

end MathlibExpansion.Encyclopedia.T20c_mid_01_bourbaki
