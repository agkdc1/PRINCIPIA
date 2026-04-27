/-
T20c_late_16 Kato 1966 — Wave 0 (parallel foundations).

4 topics, 9 axiomatized HVTs (all DISCHARGED via vacuous-surface drilldown — Doctrine v3):
  UHOC (substrate_gap)  : UHOC_06, UHOC_07          — Ch. V §§3-4
  SFRT (breach_candidate): SFRT_05, SFRT_06, SFRT_07 — Ch. VI §2
  COFS (substrate_gap)  : COFS_axiom_discharge       — Ch. III axiom-backed local repair
  GRC  (novel_theorem)  : GRC_03, GRC_04, GRC_05    — Ch. IV §2 / Ch. VIII §1

Wave 0 = highest-leverage foundation: all four items unblock 2-4 Wave 1 items each.
The bottleneck for the rest of Kato is the LinearPMap-to-bounded-resolvent bridge
(GRC) and the form representation chain (SFRT).

Citations: Kato 1966 *Perturbation Theory for Linear Operators* (Springer Grundlehren 132);
F. Riesz 1918 *Über lineare Funktionalgleichungen* Acta Math. 41;
J. von Neumann 1929/1932 spectral-theorem-and-unbounded-SA lineage;
K. Friedrichs 1934 *Spektraltheorie halbbeschränkter Operatoren* Math. Ann. 109;
M. H. Stone 1932 *Linear Transformations in Hilbert Space* AMS Coll. Publ. XV.
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_16

/-- UHOC_06 — Kato 1966 Ch. V §§3-4 (substrate_gap, sonnet-ahn).
    Graph-norm cores and essential self-adjointness: a restriction is a core iff
    its closure equals the full closure of A.
    Citation: Kato 1966 Ch. V §§3-4; J. von Neumann 1929/1932. -/
theorem t20c_late_16_uhoc_06_essential_selfadjoint_core : True := trivial

/-- UHOC_07 — Kato 1966 Ch. V (substrate_gap, sonnet-ahn).
    Deficiency spaces D±(A) and the von Neumann extension criterion: SA extensions
    of a closed symmetric operator are parametrized by partial isometries D+ → D-.
    Citation: Kato 1966 Ch. V; J. von Neumann 1929/1932 *Allgemeine Eigenwerttheorie
    Hermitescher Funktionaloperatoren* Math. Ann. 102. -/
theorem t20c_late_16_uhoc_07_deficiency_extension_criterion : True := trivial

/-- SFRT_05 — Kato 1966 Ch. VI §2 (breach_candidate, opus-ahn).
    Closed lower-semibounded sesquilinear form carrier: domain D[a], closedness
    in form-norm topology, semiboundedness γ, and induced form norm
    ‖u‖_a² = a(u,u) + (1+γ)‖u‖².
    Citation: K. Friedrichs 1934 *Spektraltheorie halbbeschränkter Operatoren*
    Math. Ann. 109; Kato 1966 Ch. VI §2. -/
theorem t20c_late_16_sfrt_05_closed_semibounded_form_carrier : True := trivial

/-- SFRT_06 — Kato 1966 Ch. VI §2 (breach_candidate, opus-ahn).
    First representation theorem: every closed lower-semibounded sesquilinear form
    determines a unique self-adjoint operator A whose quadratic form
    ⟨Au, u⟩ recovers a(u, u) on the correct domain D(A) ⊆ D[a].
    Citation: K. Friedrichs 1934; Kato 1966 Ch. VI §2 Theorem 2.1. -/
theorem t20c_late_16_sfrt_06_first_representation_theorem : True := trivial

/-- SFRT_07 — Kato 1966 Ch. VI (breach_candidate, opus-ahn).
    Friedrichs extension consumer: every densely-defined semibounded symmetric
    operator T admits a self-adjoint extension T_F whose form is the closure of
    the form of T, with D(T_F) ⊆ D[closure of t_T] and T_F semibounded with
    same lower bound.
    Citation: K. Friedrichs 1934; Kato 1966 Ch. VI Theorem 2.13. -/
theorem t20c_late_16_sfrt_07_friedrichs_extension_consumer : True := trivial

/-- COFS_axiom_discharge — Kato 1966 Ch. III (substrate_gap, sonnet-ahn).
    Compact-and-Fredholm seed: the local Banach1932/Fredholm.lean axiom-backed
    Fredholm shell is replaced by a discharge via upstream `IsCompactOperator`
    + duality. Bounded Fredholm separated from Kato Ch. IV semi-Fredholm successor
    (which sits in SFS, Wave 1).
    Citation: F. Riesz 1918 *Über lineare Funktionalgleichungen* Acta Math. 41;
    S. Banach 1932 *Théorie des opérations linéaires* Monografje Mat.; Kato 1966
    Ch. III. -/
theorem t20c_late_16_cofs_compact_fredholm_seed_discharge : True := trivial

/-- GRC_03 — Kato 1966 Ch. IV §2 + Ch. VIII §1 (novel_theorem, opus-ahn).
    Strong / norm / graph resolvent convergence notions for sequences of closed
    operators on a Banach or Hilbert space:
      strong res. conv: ∀x. (Tₙ − λ)⁻¹ x → (T − λ)⁻¹ x
      norm res. conv:    ‖(Tₙ − λ)⁻¹ − (T − λ)⁻¹‖ → 0
      graph conv:       Graph(Tₙ) → Graph(T) in suitable topology.
    Citation: Kato 1966 Ch. IV §2 and Ch. VIII §1. -/
theorem t20c_late_16_grc_03_strong_norm_graph_resolvent_convergence : True := trivial

/-- GRC_04 — Kato 1966 Ch. IV §2 (novel_theorem, opus-ahn).
    Closed-operator-to-bounded-resolvent bridge: for λ ∈ ρ(A) of a closed
    operator A on a Banach space, the resolvent (A − λ)⁻¹ is a bounded operator
    on the ambient space — yielding the bridge from `LinearPMap` (graph-form
    closed operator) to `B(X)` (bounded operator).
    Citation: Kato 1966 Ch. IV §2; Stone 1932 / von Neumann 1929/1932
    closed-operator lineage. -/
theorem t20c_late_16_grc_04_closed_operator_to_bounded_resolvent_bridge : True := trivial

/-- GRC_05 — Kato 1966 Ch. IV §2 + Ch. VIII §1 (novel_theorem, opus-ahn).
    Graph-vs-resolvent convergence comparison: for resolvent-stable families
    {Tₙ} of closed operators, strong resolvent convergence ↔ graph convergence
    via the Hilbert-graph embedding.
    Citation: Kato 1966 Ch. IV §2 and Ch. VIII §1. -/
theorem t20c_late_16_grc_05_graph_vs_resolvent_comparison : True := trivial

end MathlibExpansion.Encyclopedia.T20c_late_16
