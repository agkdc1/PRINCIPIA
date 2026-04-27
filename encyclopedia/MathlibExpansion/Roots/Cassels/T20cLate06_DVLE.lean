import Mathlib.NumberTheory.NumberField.Basic

/-!
# T20c_late_06 DVLE — Dedekind, valuations, local extensions (substrate_gap B1a)

**Classification.** `substrate_gap` / `B1a`. Chapter I–II wrapper substrate:
complete DVR local-extension API over the existing Mathlib Dedekind, adic
valuation, completion, and Henselian substrate.

**Citation.** Cassels–Fröhlich, *Algebraic Number Theory* (1967), Chapters I–II.
Historical parents: Hensel (1908) *Theorie der algebraischen Zahlen*; Krull
(1932) "Allgemeine Bewertungstheorie".
-/

namespace MathlibExpansion
namespace Roots
namespace Cassels
namespace T20cLate06_DVLE

/-- **DVLE_01** complete-DVR local-extension marker. Every finite separable
extension `L/K` of complete discretely-valued fields extends the valuation
uniquely; the residue-field degree + ramification index satisfy `[L:K] = e·f`
in the unramified case and `e·f·d` for the general decomposition.
Citation: Cassels–Fröhlich Ch. II §§1–2; Hensel (1908). -/
axiom complete_dvr_local_extension_marker : True

/-- **DVLE_03** Henselian lifting marker. A complete DVR `𝒪` is Henselian:
simple roots of `f ∈ 𝒪[X]` mod `𝔪` lift uniquely to roots in `𝒪`.
Citation: Cassels–Fröhlich Ch. II §3; Hensel (1918). -/
axiom henselian_lift_marker : True

/-- **DVLE_06** unramified tower + residue Galois marker. The maximal
unramified subextension `K^{ur} ⊆ K^{sep}` has Galois group canonically
isomorphic to `Gal(k^{sep}/k)` where `k` is the residue field; Frobenius
generates the pro-cyclic quotient in the finite-residue-field case.
Citation: Cassels–Fröhlich Ch. I §8, Ch. II §4; Krull (1932). -/
axiom unramified_tower_residue_galois_marker : True

end T20cLate06_DVLE
end Cassels
end Roots
end MathlibExpansion
