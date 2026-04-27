import Mathlib.CategoryTheory.Sites.Sheaf

/-! # T20c_late_10 FBSG_CORE — Fibre Bundle Spectral Sequence & Gysin (Bott–Tu 1982 §III.17-18, novel_theorem, B6)
    **Classification.** novel_theorem — the fibre-bundle Serre SS + oriented-sphere-bundle Gysin
    sequence are Bott–Tu's capstone Chapter III theorems. Quarantines: `SPECTRAL_OVERREACH_Q`,
    `LOCAL_COEFF_Q`.
    **Citation.** Bott–Tu §III.17 (Serre spectral sequence of fibre bundle), §III.18 (Gysin
    sequence for oriented sphere bundle); Serre 1951 *Homologie singulière des espaces fibrés*;
    Gysin 1942 *Zur Homologietheorie der Abbildungen und Faserungen*. -/
namespace MathlibExpansion
namespace Roots
namespace Bott
namespace T20cLate10_FBSG_CORE

/-- **FBSG_01** Serre spectral sequence for fibre bundle `F → E → B` with simply-connected `B`:
    `E_2^{p,q} = H^p(B; H^q(F)) ⇒ H^{p+q}(E)` (Bott–Tu §III.17, Thm 17.3; Serre 1951). -/
axiom fbsg_serre_spectral_sequence_marker : True

/-- **FBSG_02** Gysin sequence for oriented sphere bundle `S^{r-1} → S(E) → M`:
    `… → H^k(M) →^{∧ e(E)} H^{k+r}(M) →^{π*} H^{k+r}(S(E)) →^{π_*} H^{k+1}(M) → …`
    (Bott–Tu §III.18, Prop 18.9; Gysin 1942). -/
axiom fbsg_oriented_sphere_bundle_gysin_marker : True

/-- **FBSG_03** multiplicativity + edge homomorphism: Serre SS for `F → E → B` is multiplicative,
    edge `H^*(B) → H^*(E)` is `π*` and `H^*(E) ↠ H^*(F)` is fibre restriction (Bott–Tu §III.17,
    Thm 17.11; Serre 1951). -/
axiom fbsg_serre_multiplicativity_edge_marker : True

end T20cLate10_FBSG_CORE
end Bott
end Roots
end MathlibExpansion
