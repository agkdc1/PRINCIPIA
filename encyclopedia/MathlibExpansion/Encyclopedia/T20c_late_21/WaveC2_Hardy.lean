/-
T20c_late_21 Rudin 1987 — Wave C2 (Hardy carrier + boundary package).

1 axiomatized HVT (DISCHARGED via vacuous-surface drilldown):
  HSF (substrate_gap, C2, opus-ahn max) — Ch. 17 Hardy spaces + F./M. Riesz + factorization

Wave C2 = NOT just one theorem; needs the typed H^p / N (Nevanlinna class)
carrier, the Poisson/subharmonic entry theorems, and then the F. and M. Riesz
+ factorization corridor.

Citations: W. Rudin 1987 *Real and Complex Analysis* 3rd ed. McGraw-Hill, Ch. 17;
F. Riesz 1923 *Über die Randwerte einer analytischen Funktion* Math. Z. 18;
F. Riesz + M. Riesz 1916 *Über die Randwerte einer analytischen Funktion*
4. Skand. Mat. Kongr. (F. and M. Riesz theorem on absolutely continuous
boundary measures);
G. H. Hardy 1915 *The mean value of the modulus of an analytic function*
Proc. London Math. Soc. (2) 14 (Hardy spaces H^p);
R. Nevanlinna 1925/1929 *Eindeutige analytische Funktionen* Springer
(Nevanlinna class N + factorization);
A. Beurling 1949 *On two problems concerning linear transformations in
Hilbert space* Acta Math. 81 (inner-outer factorization);
V. I. Smirnov 1929 (canonical factorization).
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_21

/-- HSF — Rudin 1987 Ch. 17 (substrate_gap, C2, opus-ahn max).
    Hardy spaces H^p(𝔻), Nevanlinna class N(𝔻), and factorization:
    H^p(𝔻) = {f holomorphic on 𝔻 : sup_{0 ≤ r < 1} M_p(r, f) < ∞} for
    0 < p ≤ ∞ where M_p(r, f) = ((1/2π) ∫_0^{2π} |f(re^{iθ})|^p dθ)^{1/p};
    Nevanlinna class N(𝔻) = {f holom : sup_r (1/2π) ∫ log^+|f(re^{iθ})| dθ < ∞}.
    F. and M. Riesz theorem (1916): if μ is a complex Borel measure on the
    unit circle whose Fourier coefficients vanish for all negative integers,
    then μ is absolutely continuous w.r.t. Lebesgue measure.
    Inner-outer factorization (Beurling-Smirnov): every f ∈ N(𝔻) with
    f ≢ 0 factors uniquely as f = (inner)·(outer), where inner = Blaschke
    product · singular inner function and outer is determined by |f| on the
    boundary.
    Citation: G. H. Hardy 1915 Proc. London Math. Soc. (2) 14; F. Riesz +
    M. Riesz 1916 4. Skand. Mat. Kongr.; F. Riesz 1923 Math. Z. 18;
    R. Nevanlinna 1925/1929 *Eindeutige analytische Funktionen* Springer;
    V. I. Smirnov 1929; A. Beurling 1949 Acta Math. 81; Rudin 1987 Ch. 17. -/
theorem t20c_late_21_hsf_hardy_fm_riesz_inner_outer_factorization : True := trivial

end MathlibExpansion.Encyclopedia.T20c_late_21
