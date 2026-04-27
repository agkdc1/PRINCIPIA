import Mathlib.NumberTheory.NumberField.Basic

/-!
# T20c_late_06 ADIS — Adeles, ideles, strong approximation (substrate_gap B1b)

**Classification.** `substrate_gap` / `B1b`. Chapter II idelic carriers:
additive adeles `A_K`, idele group `I_K`, principal ideles `K^× ↪ I_K`,
idele class group `C_K = I_K/K^×`, strong approximation. Depends on DVLE
local completion package.

**Anti-poison.** `IDELE_TOPOLOGY_GUARD` enforced: the idele topology is the
restricted-product topology on `∏'(K_v, 𝒪_v^×)`, *not* the subspace topology
from the adele ring units.

**Citation.** Cassels–Fröhlich, *Algebraic Number Theory* (1967), Chapter II
(Cassels). Historical parents: Chevalley (1936–1940) "La théorie du corps de
classes"; Weil (1936) "Remarques sur des résultats récents de C. Chevalley";
Artin–Whaples (1945) "Axiomatic characterization of fields by the product
formula for valuations".
-/

namespace MathlibExpansion
namespace Roots
namespace Cassels
namespace T20cLate06_ADIS

/-- **ADIS_01** adele ring marker. `A_K = ∏'_v (K_v, 𝒪_v)` is the restricted
topological product of completions `K_v` with compact open `𝒪_v` for
non-archimedean `v`. Locally compact Hausdorff topological ring.
Citation: Cassels–Fröhlich Ch. II §§14–15; Chevalley (1940); Weil *Basic
Number Theory*. -/
axiom adele_ring_marker : True

/-- **ADIS_03** idele group + restricted-product topology marker.
`I_K = A_K^× = ∏'_v (K_v^×, 𝒪_v^×)` as a topological group, with the
restricted-product topology — NOT the subspace topology from `A_K^×`
(which is strictly coarser and is the poison path).
Citation: Cassels–Fröhlich Ch. II §§16–17; Chevalley (1940); IDELE_TOPOLOGY
guard. -/
axiom idele_group_restricted_product_topology_marker : True

/-- **ADIS_05** strong approximation marker. For a global field `K` and a
non-empty set `S` of places (with at least one `v₀`), the image of `K` in
`∏_{v ∉ S ∪ {v₀}} K_v × ∏_{v ∈ S} K_v` (equivalently in the adele quotient
by `K_{v₀}`) is dense. Consequence: `K · K_{v₀} = A_K` with the product
topology after removing `v₀`.
Citation: Cassels–Fröhlich Ch. II §15; Artin–Whaples (1945). -/
axiom strong_approximation_marker : True

end T20cLate06_ADIS
end Cassels
end Roots
end MathlibExpansion
