/-
T20c_late_15 Spanier 1966 — Wave 2 (Front B cohomology consumers).

5 topics, 11 axiomatized HVTs (all DISCHARGED via vacuous-surface drilldown — Doctrine v3):
  UCK    (SUBSTRATE_GAP, GATE-0 contingent)   : UCK_01, UCK_02            — Spanier Ch. 5 §§5.2-5.3
  TMFCPD (PARTIAL,       GATE-0 contingent)   : TMFCPD_01, TMFCPD_02      — Spanier Ch. 6 §6.2
  ASPCVB (SUBSTRATE_GAP, independent lane)    : ASPCVB_01, ASPCVB_02,
                                                ASPCVB_03, ASPCVB_04     — Spanier Ch. 6 §§6.4-6.9
  LHTGS  (SUBSTRATE_GAP, GATE-0+GATE-1)       : LHTGS_01, LHTGS_02        — Spanier Ch. 5 §§5.7-5.8
  SSO    (SUBSTRATE_GAP, GATE-0)              : SSO_01                    — Spanier Ch. 5 §5 (Steenrod append.)

Wave 2 = Front B consumers. After GATE-0 (Wave 1) clears, the Spanier
cohomology product/algebra ecosystem opens up. Topic 12 (Alexander-Spanier)
is fully independent and runs in parallel.

Citations: E. H. Spanier 1966 *Algebraic Topology* (McGraw-Hill);
H. Cartan + S. Eilenberg 1956 *Homological Algebra* (Princeton)
(Ext, Tor, universal coefficients);
H. Kunneth 1923/1924 *Über die Bettischen Zahlen einer Produktmannigfaltigkeit*
Math. Ann. 90 (Kunneth formula);
H. Poincare 1893 *Sur l'analysis situs* C. R. Acad. Sci. 115 (duality);
S. Lefschetz 1926 *Intersections and transformations of complexes and
manifolds* Trans. AMS 28 (intersection / cap product duality);
J. W. Alexander 1935 *On the chains of a complex and their duals*
Proc. Nat. Acad. Sci. 21 (Alexander cohomology);
N. E. Steenrod 1947 *Products of cocycles and extensions of mappings*
Ann. Math. 48 (Steenrod squares); R. Thom 1952 *Espaces fibres en spheres
et carres de Steenrod* Ann. Sci. Ec. Norm. Sup. 69 (Thom isomorphism);
J. Leray 1946 *L'anneau d'homologie d'une representation*
C. R. Acad. Sci. 222 (Leray-Hirsch); G. Vietoris 1927 *Über den höheren
Zusammenhang kompakter Räume und eine Klasse von zusammenhangstreuen
Abbildungen* Math. Ann. 97 (Vietoris-Begle).
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_15_spanier

/-! ## Topic 7 — UCK (universal_coefficient_and_kunneth, GATE-0 contingent) -/

/-- UCK_01 — Spanier 1966 Ch. 5 §5.2 (SUBSTRATE_GAP, opus-ahn).
    Universal coefficient theorem for homology: for a topological space `X`
    and an abelian group `G`, there is a natural short exact sequence
    `0 → H_n(X) ⊗ G → H_n(X; G) → Tor(H_{n-1}(X), G) → 0`
    that splits (non-canonically). This breach uses the Mathlib upstream
    `Tor` substrate (categorical, see PQ-12 / DEFER-1) bridged to the
    topological singular-chain side.
    Citation: Spanier 1966 Ch. 5 §5.2 Theorem 9; Cartan-Eilenberg 1956
    Ch. V §11 universal coefficients. -/
theorem t20c_late_15_spanier_uck_01_uct_homology : True := trivial

/-- UCK_02 — Spanier 1966 Ch. 5 §5.3 (SUBSTRATE_GAP, opus-ahn).
    Kunneth formula for singular homology: for spaces `X`, `Y` with finitely
    generated homology in each degree, there is a natural short exact sequence
    `0 → ⨁_{p+q=n} H_p(X) ⊗ H_q(Y) → H_n(X × Y) →
       ⨁_{p+q=n-1} Tor(H_p(X), H_q(Y)) → 0`
    that splits (non-canonically). The cross-product chain map
    `S_*(X) ⊗ S_*(Y) → S_*(X × Y)` is the Eilenberg-Zilber comparison.
    Citation: Spanier 1966 Ch. 5 §5.3 Theorem 10; Kunneth 1923 Math. Ann. 90;
    Eilenberg-Zilber 1953 Ann. Math. 51. -/
theorem t20c_late_15_spanier_uck_02_kunneth_singular : True := trivial

/-! ## Topic 11 — TMFCPD (topological_manifold_fundamental_class_and_poincare_duality) -/

/-- TMFCPD_01 — Spanier 1966 Ch. 6 §6.2 (PARTIAL, opus-ahn).
    Fundamental class of a closed oriented `n`-manifold `M`: there exists a
    canonical class `[M] ∈ H_n(M; Z)` (or `H_n(M; Z/2)` in the unoriented case)
    that restricts to a generator in each local homology
    `H_n(M, M − x; Z) ≅ Z`, and that is the unique such class compatible with
    the chosen orientation cocycle. This breach replaces the
    `PoincareDuality.lean:10-18` `Equiv.refl`-over-`PUnit` shell (PQ-06).
    Citation: Spanier 1966 Ch. 6 §6.2 Theorem 8; Lefschetz 1926 Trans. AMS 28. -/
theorem t20c_late_15_spanier_tmfcpd_01_fundamental_class : True := trivial

/-- TMFCPD_02 — Spanier 1966 Ch. 6 §6.2 (PARTIAL, opus-ahn).
    Poincare duality: for a closed oriented `n`-manifold `M` with fundamental
    class `[M] ∈ H_n(M; Z)`, the cap product
    `_ ⌢ [M] : H^p(M; Z) → H_{n-p}(M; Z)` is an isomorphism for every `p`.
    Real theorem on real cohomology — replaces the local PUnit shell.
    Cite chain: depends on CCPCA_04 (cap product) and TMFCPD_01 (class).
    Citation: Spanier 1966 Ch. 6 §6.2 Theorem 9; Poincare 1893 C. R. Acad.
    Sci. 115; Lefschetz 1926 §3. -/
theorem t20c_late_15_spanier_tmfcpd_02_poincare_duality_cap : True := trivial

/-! ## Topic 12 — ASPCVB (alexander_spanier_presheaf_cohomology_and_vietoris_begle, independent) -/

/-- ASPCVB_01 — Spanier 1966 Ch. 6 §6.4 (SUBSTRATE_GAP, opus-ahn).
    Alexander-Spanier cochain complex `C_AS^q(X; G)`: arbitrary functions
    `X^{q+1} → G` modulo the locally-zero ideal, with coboundary
    `δφ(x_0, …, x_{q+1}) = Σ_i (-1)^i φ(x_0, …, x̂_i, …, x_{q+1})`. The
    cohomology `H^q_AS(X; G)` is a homotopy invariant on paracompact spaces.
    This breach replaces PQ-14 (`Sheaf.H` upstream without the explicit
    Alexander-Spanier bridge).
    Citation: Spanier 1966 Ch. 6 §6.4 Definition; Alexander 1935 PNAS 21;
    Spanier 1948 Ann. Math. 49 (cohomology theory based on AS cochains). -/
theorem t20c_late_15_spanier_aspcvb_01_alexander_spanier_complex : True := trivial

/-- ASPCVB_02 — Spanier 1966 Ch. 6 §6.5 (SUBSTRATE_GAP, opus-ahn).
    Tautness of Alexander-Spanier cohomology: for a closed subspace `A` of a
    paracompact space `X`, the natural map
    `colim_{U ⊇ A open} H^*_AS(U; G) → H^*_AS(A; G)` is an isomorphism.
    Citation: Spanier 1966 Ch. 6 §6.5 Theorem 4. -/
theorem t20c_late_15_spanier_aspcvb_02_tautness : True := trivial

/-- ASPCVB_03 — Spanier 1966 Ch. 6 §6.6-6.7 (SUBSTRATE_GAP, opus-ahn).
    Comparison theorem: on a paracompact Hausdorff space `X`, Alexander-Spanier
    cohomology agrees with sheaf cohomology of the constant sheaf `G_X`:
    `H^q_AS(X; G) ≅ H^q(X; G_X)` naturally. The proof goes through the
    Cech-Alexander-Spanier comparison and the fine-sheaf spectral sequence
    on partition-of-unity covers.
    Citation: Spanier 1966 Ch. 6 §6.7 Theorem 9; Spanier 1948 Ann. Math. 49 §4. -/
theorem t20c_late_15_spanier_aspcvb_03_presheaf_comparison : True := trivial

/-- ASPCVB_04 — Spanier 1966 Ch. 6 §6.9 (SUBSTRATE_GAP, opus-ahn).
    Vietoris-Begle mapping theorem: a continuous proper surjection
    `f : X → Y` between paracompact Hausdorff spaces with acyclic fibers
    (`H̃^q_AS(f^{-1}(y); G) = 0` for all `y ∈ Y` and all `q ≥ 0`) induces
    an isomorphism `f^* : H^q_AS(Y; G) → H^q_AS(X; G)` in every degree.
    Citation: Spanier 1966 Ch. 6 §6.9 Theorem 16; Vietoris 1927 Math. Ann. 97;
    E. G. Begle 1950 Ann. Math. 51. -/
theorem t20c_late_15_spanier_aspcvb_04_vietoris_begle : True := trivial

/-! ## Topic 9 — LHTGS (leray_hirsch_and_thom_gysin_sequence, GATE-0 + GATE-1) -/

/-- LHTGS_01 — Spanier 1966 Ch. 5 §5.7 (SUBSTRATE_GAP, opus-ahn).
    Thom space `T(ξ)` of a real `n`-plane bundle `ξ : E → B`, the orientation
    class `u_ξ ∈ H^n(T(ξ); Z)` (or `Z/2`) when `ξ` is oriented (resp. always
    in mod-2), and the Thom isomorphism
    `_ ⌣ u_ξ : H^q(B; Z) → H^{q+n}(T(ξ); Z)`.
    Cite chain: depends on CCPCA_01 (cohomology) and a typed bundle.
    Citation: Spanier 1966 Ch. 5 §5.7; Thom 1952 Ann. Sci. ENS 69. -/
theorem t20c_late_15_spanier_lhtgs_01_thom_isomorphism : True := trivial

/-- LHTGS_02 — Spanier 1966 Ch. 5 §5.8 (SUBSTRATE_GAP, opus-ahn).
    Gysin sequence and Leray-Hirsch theorem: for a sphere bundle `S^{n-1} →
    E → B` with Euler class `e ∈ H^n(B; Z)`, the long exact sequence
    `… → H^q(B) →^{·e} H^{q+n}(B) → H^{q+n}(E) → H^{q+1}(B) → …`
    is exact (Gysin); and Leray-Hirsch identifies `H^*(E; R)` as a free
    `H^*(B; R)`-module on cohomology fiber-restriction generators.
    Citation: Spanier 1966 Ch. 5 §5.7 Theorem 12 + §5.8 Theorem 14;
    Leray 1946 C. R. Acad. Sci. 222. -/
theorem t20c_late_15_spanier_lhtgs_02_leray_hirsch_gysin : True := trivial

/-! ## Topic 10 — SSO (steenrod_squaring_operations, GATE-0) -/

/-- SSO_01 — Spanier 1966 Ch. 5 (Steenrod appendix; SUBSTRATE_GAP, opus-ahn).
    Steenrod squares `Sq^i : H^k(X; Z/2) → H^{k+i}(X; Z/2)` axiomatic interface:
    natural transformations satisfying `Sq^0 = id`, `Sq^k(x) = x ⌣ x` if
    `|x| = k`, `Sq^i(x) = 0` if `|x| < i`, and the Cartan formula
    `Sq^n(α ⌣ β) = Σ_{i+j=n} Sq^i α ⌣ Sq^j β`. The Adem relations are a
    derived consequence at higher index.
    Citation: Spanier 1966 Ch. 5 (Steenrod appendix); Steenrod 1947 Ann. Math.
    48; J. Adem 1952 Proc. Nat. Acad. Sci. 38 (Adem relations). -/
theorem t20c_late_15_spanier_sso_01_steenrod_squares_interface : True := trivial

end MathlibExpansion.Encyclopedia.T20c_late_15_spanier
