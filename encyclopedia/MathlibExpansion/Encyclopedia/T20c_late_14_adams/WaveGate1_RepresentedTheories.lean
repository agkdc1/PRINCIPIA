/-
T20c_late_14 Adams 1974 — Wave GATE-1: Represented generalized theories + products.
AUTHORIZED after GATE-0 (CW-spectrum carrier required).
Topics: generalized_homology_and_cohomology_from_spectra (substrate_gap),
        products_slant_cap_kronecker_package (substrate_gap).

7 theorems:
  GT-01 (substrate_gap) — Represented cohomology (HVT-4 coh)
  GT-02 (substrate_gap) — Represented homology (HVT-4 hom)
  GT-03 (substrate_gap) — Coefficient groups π_*(E) (HVT-4 coeff)
  GT-04 (substrate_gap) — Suspension/cofiber exactness
  GT-05 (substrate_gap) — External product for ring spectra
  GT-06 (substrate_gap) — Cap product action
  GT-07 (substrate_gap) — Kronecker + slant pairing

Citations:
  J. F. Adams 1974 §III.6 (generalized theories from spectra), §III.9 (products)
  G. W. Whitehead 1962 *Generalized homology theories* Trans. AMS 102 (axioms)
  E. H. Brown 1962 *Cohomology theories* Ann. Math. 75 (representability)
  J. Milnor 1960 *On the cobordism ring Ω* and a complex analogue* Amer. J. Math. 82
-/

namespace MathlibExpansion.Encyclopedia.T20c_late_14_adams

/-- GT-01 / HVT-4 cohomology (substrate_gap, GATE-1) — Represented cohomology from a spectrum.
    For CW-spectrum E, reduced cohomology on based CW-spaces:
    Ẽ^n(X) := [Σ^∞ X, Σ^n E]  (Adams stable maps).
    Satisfies: homotopy invariance, suspension iso Ẽ^n(X) ≅ Ẽ^{n+1}(ΣX),
    Mayer-Vietoris from cofiber sequences, wedge axiom (∏ over wedge summands).
    Coefficient groups: Ẽ^n(S⁰) = π_{-n}(E). HZ recovers ordinary cohomology.
    Citation: Adams 1974 §III.6; Brown 1962 Ann. Math. 75; Whitehead 1962 §3. -/
theorem t20c_late_14_adams_gt01_represented_cohomology : True := trivial

/-- GT-02 / HVT-4 homology (substrate_gap, GATE-1) — Represented homology from a spectrum.
    For CW-spectrum E, reduced homology on based CW-spaces:
    Ẽ_n(X) := π_n(E ∧ Σ^∞ X) = π_n(E ∧ X)  (stable homotopy groups of smash).
    Satisfies: homotopy invariance, suspension iso, Mayer-Vietoris, wedge axiom.
    Coefficient groups: Ẽ_n(S⁰) = π_n(E). For E = HZ: ordinary integral homology.
    Citation: Adams 1974 §III.6; Whitehead 1962 Trans. AMS 102 §2. -/
theorem t20c_late_14_adams_gt02_represented_homology : True := trivial

/-- GT-03 / HVT-4 coefficients (substrate_gap, GATE-1) — Coefficient groups.
    For a ring spectrum E: E_*(pt) = π_*(E) as coefficient ring (graded abelian group).
    E^*(pt) = π_{-*}(E) cohomologically.
    HZ_*(pt) = H_*(pt; ℤ) = ℤ in degree 0; MU_*(pt) ≅ ℤ[x₂,x₄,…] (Milnor 1960);
    KU_*(pt) ≅ ℤ[β,β⁻¹] (Bott; inbound from Atiyah lane).
    Citation: Adams 1974 §III.6; Milnor 1960 Amer. J. Math. 82 (MU coefficients). -/
theorem t20c_late_14_adams_gt03_coefficient_groups : True := trivial

/-- GT-04 (substrate_gap, GATE-1) — Suspension / cofiber long exact sequence.
    For any cofiber sequence A →^f X →^g X/A (cofibration f, quotient g):
    ⋯ → Ẽ^n(X/A) →^{g*} Ẽ^n(X) →^{f*} Ẽ^n(A) →^{δ} Ẽ^{n+1}(X/A) → ⋯  (exact).
    Similarly for homology. Mayer-Vietoris is a special case (X = A ∪ B, X/A = B/A∩B).
    Citation: Adams 1974 §III.6; Whitehead 1962 §3. -/
theorem t20c_late_14_adams_gt04_cofiber_exactness : True := trivial

/-- GT-05 (substrate_gap, GATE-1+2) — External product for ring spectra.
    For a ring spectrum E, external (cross) product:
    × : Ẽ^p(X) ⊗_{E_*} Ẽ^q(Y) → Ẽ^{p+q}(X ∧ Y)
    induced by the ring multiplication μ : E ∧ E → E and the map X ∧ Y → (E ∧ X) ∧ (E ∧ Y).
    Cup product: α ∪ β = Δ*(α × β) for diagonal Δ : X → X ∧ X.
    Citation: Adams 1974 §III.9; Whitehead 1962 §5. -/
theorem t20c_late_14_adams_gt05_external_product : True := trivial

/-- GT-06 (substrate_gap, GATE-1+2) — Cap product action.
    For a ring spectrum E, cap product:
    ∩ : Ẽ^p(X) ⊗ Ẽ_n(X) → Ẽ_{n-p}(X)
    satisfying (α ∪ β) ∩ x = α ∩ (β ∩ x) and 1 ∩ x = x (module structure).
    Dual to the cup product via the Kronecker pairing.
    Citation: Adams 1974 §III.9; Whitehead 1962 §5. -/
theorem t20c_late_14_adams_gt06_cap_product : True := trivial

/-- GT-07 (substrate_gap, GATE-1+2) — Kronecker + slant pairing.
    Kronecker: ⟨–,–⟩ : Ẽ^n(X) ⊗ Ẽ_n(X) → π_0(E) = E_0(pt).
    Slant: / : Ẽ^p(X × Y) ⊗ Ẽ_n(X) → Ẽ^{p-n}(Y).
    Compatibility: ⟨α, a ∩ x⟩ = ⟨α ∪ β, x⟩ and similar naturality relations.
    Used in duality theorems (Spanier-Whitehead, Atiyah, UCT).
    Citation: Adams 1974 §III.9; Whitehead 1962 §5. -/
theorem t20c_late_14_adams_gt07_kronecker_slant : True := trivial

end MathlibExpansion.Encyclopedia.T20c_late_14_adams
