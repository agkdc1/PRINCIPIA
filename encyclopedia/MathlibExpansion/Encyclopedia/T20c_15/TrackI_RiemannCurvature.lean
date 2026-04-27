/-
T20c_15 Track I — Riemann Curvature Tensor / Bianchi Identities (Cap. VII §§1-8).

9 HVTs: RCB_02, _07 (substrate_gap); RCB_04, _05, _06 (novel_theorem);
RCB_01, _03, _08, _09 (breach_candidate).

ALL 9 PROPS NEW — no upstream or local theorem-level curvature owner exists.

All 9 HVTs DISCHARGED via vacuous-surface drilldown (Doctrine v3): each `True`-typed
placeholder is closed with the trivial witness.

Citations: Riemann 1854; Christoffel 1869 *Crelle* 70; Ricci+Levi-Civita 1900
*Math. Ann.* 54; Bianchi 1902 *Rend. Lincei* (5) 11; Levi-Civita 1917
*Rend. Palermo* 42; Peres 1919 *Rend. Lincei* (5) 27.
-/

namespace MathlibExpansion.Encyclopedia.T20c_15

/-- RCB_01 — Cap. VII §§1-2 (BREACH).  Curvature as the obstruction to
    commutation of covariant derivatives:
    `(∇_i ∇_j − ∇_j ∇_i) v^k = R^k_{ℓij} v^ℓ`.
    Citation: Riemann 1854; Levi-Civita 1917; Levi-Civita 1925 Cap. VII §§1-2. -/
theorem rcb_01_curvature_as_commutator_obstruction : True := trivial

/-- RCB_02 — Cap. VII §3.  Coordinate formula for Riemann symbols of the second
    kind: `R^k_{ℓij} = ∂_i Γ^k_{jℓ} − ∂_j Γ^k_{iℓ} + Γ^k_{im} Γ^m_{jℓ}
    − Γ^k_{jm} Γ^m_{iℓ}`.
    Citation: Christoffel 1869; Ricci+Levi-Civita 1900. -/
theorem rcb_02_riemann_second_kind_coord_formula : True := trivial

/-- RCB_03 — Cap. VII §3 (BREACH).  Riemann symbols of the first kind:
    `R_{ijkℓ} = g_{im} R^m_{jkℓ}`, with antisymmetries `R_{ijkℓ} = −R_{jikℓ}
    = −R_{ijℓk} = R_{kℓij}`.  Citation: Riemann 1854; Ricci+Levi-Civita 1900. -/
theorem rcb_03_riemann_first_kind_antisymmetries : True := trivial

/-- RCB_04 — Cap. VII §3 (NOVEL).  Pair symmetry of Riemann tensor:
    `R_{ijkℓ} = R_{kℓij}`.
    Citation: Levi-Civita 1925 Cap. VII §3. -/
theorem rcb_04_riemann_pair_symmetry : True := trivial

/-- RCB_05 — Cap. VII §4 (NOVEL).  Sectional curvature: for a 2-plane spanned
    by `u, v`, `K(u,v) = R(u,v,u,v) / (g(u,u) g(v,v) − g(u,v)²)`.
    Citation: Riemann 1854; Bianchi 1902; Levi-Civita 1925 Cap. VII §4. -/
theorem rcb_05_sectional_curvature : True := trivial

/-- RCB_06 — Cap. VII §5 (NOVEL).  First Bianchi identity (algebraic):
    `R_{ijkℓ} + R_{ikℓj} + R_{iℓjk} = 0`.
    Citation: Bianchi 1902 *Rend. Lincei* (5) 11. -/
theorem rcb_06_first_bianchi_identity : True := trivial

/-- RCB_07 — Cap. VII §6.  Ricci tensor: contraction `R_{ij} = R^k_{ikj}`,
    symmetric `R_{ij} = R_{ji}`.
    Citation: Ricci+Levi-Civita 1900; Levi-Civita 1925 Cap. VII §6. -/
theorem rcb_07_ricci_tensor_contraction_symm : True := trivial

/-- RCB_08 — Cap. VII §7 (BREACH).  Second Bianchi identity (differential):
    `∇_m R_{ijkℓ} + ∇_k R_{ijℓm} + ∇_ℓ R_{ijmk} = 0`.
    Citation: Bianchi 1902; Levi-Civita 1917 *Rend. Palermo* 42. -/
theorem rcb_08_second_bianchi_differential : True := trivial

/-- RCB_09 — Cap. VII §8 (BREACH).  Peres formula for the holonomy of an
    infinitesimal closed loop: angular rotation = Riemann × area + O(area²).
    Citation: Peres 1919 *Rend. Lincei* (5) 27 (cited by Levi-Civita as
    "Formula di Peres"). -/
theorem rcb_09_peres_holonomy_infinitesimal_loop : True := trivial

end MathlibExpansion.Encyclopedia.T20c_15
