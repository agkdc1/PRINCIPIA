import Mathlib.Topology.Algebra.Group.Basic

/-!
# T20c_late_06 PGCGC — Profinite groups, continuous Galois cohomology (substrate_gap B1b)

**Classification.** `substrate_gap` / `B1b`. Chapter V core: profinite groups
as inverse limits of finite quotients, continuous cochains, continuous
cohomology `H^n_{cont}`, finite-quotient comparison `H^n_{cont}(G, M) =
colim_U H^n(G/U, M^U)` for discrete `M`.

**Anti-poison.** `CONT_GCOH_GUARD` enforced: do NOT replace continuous /
profinite cohomology with discrete abstract-group cohomology; the correct
object is the continuous cochain complex, yielding a topological `Ext`.

**Citation.** Cassels–Fröhlich, *Algebraic Number Theory* (1967), Chapter V
(Serre). Historical parents: Tate (1957 Lille seminar); Serre (1964/65)
*Cohomologie galoisienne*; Shatz (1972) *Profinite groups, arithmetic, and
geometry*.
-/

namespace MathlibExpansion
namespace Roots
namespace Cassels
namespace T20cLate06_PGCGC

/-- **PGCGC_02** profinite limit marker. A profinite group is a compact
Hausdorff totally disconnected topological group, canonically isomorphic to
the inverse limit of its finite discrete quotients by open normal subgroups.
Citation: Cassels–Fröhlich Ch. V §1; Serre *Cohomologie galoisienne* §I.1. -/
axiom profinite_inverse_limit_marker : True

/-- **PGCGC_04** continuous cochain complex marker. For a profinite `G` and
a discrete (or topological) `G`-module `M`, continuous cohomology `H^n_{cont}
(G, M)` is the cohomology of the continuous cochain complex `C^n_{cont}(G, M)
:= C(G^n, M)_{cont}`; satisfies the usual long-exact sequence for short exact
sequences of `G`-modules with continuous `G`-action.
Citation: Cassels–Fröhlich Ch. V §2; Serre *Cohomologie galoisienne* §I.2. -/
axiom continuous_cochain_cohomology_marker : True

/-- **PGCGC_06** finite-quotient comparison marker. For a profinite `G` and
discrete `G`-module `M`, `H^n_{cont}(G, M) ≅ colim_U H^n(G/U, M^U)` over open
normal subgroups `U ◁ G`. Continuous cohomology commutes with filtered
colimits of discrete modules.
Citation: Cassels–Fröhlich Ch. V §2.4; Serre *Cohomologie galoisienne* §I.2.2;
Shatz (1972). -/
axiom finite_quotient_colimit_comparison_marker : True

end T20cLate06_PGCGC
end Cassels
end Roots
end MathlibExpansion
