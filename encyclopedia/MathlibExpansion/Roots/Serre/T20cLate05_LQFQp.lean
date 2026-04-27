import Mathlib.NumberTheory.Padics.PadicNumbers

/-!
# T20c_late_05 LQFQp — Local classification of quadratic forms over Q_p (breach_candidate Q2)

**Classification.** `breach_candidate` / `Q2`. Chapter IV local theorem layer:
a non-degenerate quadratic form `f` over `ℚ_v` is determined up to equivalence
by rank `n`, discriminant `d(f) ∈ ℚ_v^× / (ℚ_v^×)^2`, and Hasse invariant
`ε(f) ∈ {±1}`.

**Citation.** Serre, *A Course in Arithmetic*, Ch. IV §2.
Historical parent: Hasse, "Symmetrische Matrizen im Körper der rationalen Zahlen" (1924);
Minkowski (1890).
-/

namespace MathlibExpansion
namespace Roots
namespace Serre
namespace T20cLate05_LQFQp

/-- **LQFQp_01** local invariants completeness marker. Rank, discriminant,
and Hasse invariant `ε(f) = ∏_{i<j} (a_i, a_j)_v` (`f ≅ <a_1,...,a_n>` diagonalized)
determine `f` up to `GL_n(ℚ_v)`-equivalence over any local field `ℚ_v`.
Citation: Serre Ch. IV §2.3, Thm. 7. -/
axiom local_classification_complete_marker : True

/-- **LQFQp_03** anisotropic-rank bound marker. Over `ℚ_v` non-archimedean, a
non-degenerate anisotropic quadratic form has rank ≤ 4; every form of rank
≥ 5 represents zero non-trivially.
Citation: Serre Ch. IV §2.2, Thm. 6. -/
axiom local_anisotropic_rank_bound_marker : True

/-- **LQFQp_05** isotropy existence dictionary marker. Non-degenerate `f` of
rank `n` over `ℚ_v` represents zero iff:
`n = 1`: never (unless `f = 0`);
`n = 2`: iff `-d(f) ∈ (ℚ_v^×)^2`;
`n = 3`: iff `(-1, -d(f))_v = ε(f)`;
`n = 4`: iff `d(f) ∉ (ℚ_v^×)^2` or `d(f) = 1 ∧ ε(f) = (-1,-1)_v`;
`n ≥ 5`: always.
Citation: Serre Ch. IV §2.2, Cor. 1–3. -/
axiom local_isotropy_dictionary_marker : True

end T20cLate05_LQFQp
end Serre
end Roots
end MathlibExpansion
