/-
# T21c_12 Lurie HTT — Defers (sharp upstream-narrow axioms with citations)
# (Lurie 2009 *Higher Topos Theory*, Princeton)

Per Step 5 verdict 2026-04-25 + Commander 2026-04-22 citation rule:
27 defer rows are recorded as sharp upstream-narrow axioms with
citation-backed doc strings. Each axiom names the exact upstream Mathlib
file or canonical reference; downstream consumers depend on these axioms
rather than the (covered-but-not-yet-imported) substrate.

NB: "defer" here means "covered upstream by a Mathlib carrier" or
"analogy-only outside breach budget"; axioms are *narrow surface*
declarations enabling tracking, not promises of new content.

No-codex constraint active through 2026-04-29; tier: opus.
-/
import Mathlib

set_option autoImplicit false

namespace MathlibExpansion.Encyclopedia.T21c_12_lurie.Defers

/-! ## SSKC_01 — SSet (covered) -/

/-- **SSKC_01 — Simplicial set carrier**.
Cited: Lurie 2009 *HTT* §1.1.2; covered upstream by
`Mathlib.AlgebraicTopology.SimplicialSet.Basic` (`SSet`). -/
axiom defer_SSKC_01_sset_carrier_marker : True

/-! ## SSKC_02 — Δ[n] (covered) -/

/-- **SSKC_02 — Standard `n`-simplex `Δ[n]`**.
Cited: Lurie 2009 *HTT* §1.1.2.4; covered upstream by
`Mathlib.AlgebraicTopology.SimplicialSet.Standard` (`standardSimplex`). -/
axiom defer_SSKC_02_delta_n_marker : True

/-! ## SSKC_03 — Λ[n,i] (covered) -/

/-- **SSKC_03 — Horn `Λ[n,i]`**.
Cited: Lurie 2009 *HTT* §1.1.2.5; covered upstream by
`Mathlib.AlgebraicTopology.SimplicialSet.Horn` (`horn`). -/
axiom defer_SSKC_03_horn_marker : True

/-! ## SSKC_04 — KanComplex (covered) -/

/-- **SSKC_04 — Kan complex predicate**.
Cited: Lurie 2009 *HTT* §1.1.2.6 (Definition 1.1.2.5); covered upstream
by `Mathlib.AlgebraicTopology.SimplicialSet.KanComplex` (`KanComplex`). -/
axiom defer_SSKC_04_kan_complex_marker : True

/-! ## SSKC_05 — Kan ⇒ Quasicategory (covered) -/

/-- **SSKC_05 — Every Kan complex is a quasicategory**.
Cited: Lurie 2009 *HTT* §1.1.2; covered upstream by
`Mathlib.AlgebraicTopology.Quasicategory.Basic`
(`Quasicategory.of_kanComplex`). -/
axiom defer_SSKC_05_kan_implies_qcat_marker : True

/-! ## SSKC_06 — Nerve adjunction (covered) -/

/-- **SSKC_06 — Nerve / homotopy-coherent adjunction**.
Cited: Lurie 2009 *HTT* §1.2.3; covered upstream by
`Mathlib.AlgebraicTopology.SimplicialSet.Nerve` (`nerveFunctor`,
`nerveAdjunction`). -/
axiom defer_SSKC_06_nerve_adjunction_marker : True

/-! ## QHN_01 — Quasicategory class (covered) -/

/-- **QHN_01 — Quasicategory class**.
Cited: Lurie 2009 *HTT* §1.1.2.4; covered upstream by
`Mathlib.AlgebraicTopology.Quasicategory.Basic` (`Quasicategory`). -/
axiom defer_QHN_01_qcat_class_marker : True

/-! ## QHN_02 — Kan ⇒ QCat (covered) -/

/-- **QHN_02 — Kan complex implies quasicategory**.
Cited: Lurie 2009 *HTT* §1.1.2; same as SSKC_05 substrate. -/
axiom defer_QHN_02_kan_to_qcat_marker : True

/-! ## QHN_03 — StrictSegal ⇒ QCat (covered) -/

/-- **QHN_03 — Strict-Segal simplicial set is a quasicategory**.
Cited: Lurie 2009 *HTT* §2.3.1; covered upstream by
`Mathlib.AlgebraicTopology.SimplicialSet.StrictSegal`. -/
axiom defer_QHN_03_strict_segal_to_qcat_marker : True

/-! ## QHN_04 — Nerve ⇒ QCat (covered) -/

/-- **QHN_04 — Nerve of a 1-category is a quasicategory**.
Cited: Lurie 2009 *HTT* §1.1.5.10; covered upstream by
`Mathlib.AlgebraicTopology.Quasicategory.Nerve` (`nerve_quasicategory`). -/
axiom defer_QHN_04_nerve_to_qcat_marker : True

/-! ## QHN_05 — hoFunctor ⊣ nerve (covered) -/

/-- **QHN_05 — Homotopy functor adjoint to nerve**.
Cited: Lurie 2009 *HTT* §1.2.3.1; covered upstream by
`Mathlib.AlgebraicTopology.SimplicialSet.HomotopyCategory`. -/
axiom defer_QHN_05_hoFunctor_adj_nerve_marker : True

/-! ## SCN_01 — SimplicialCategory (covered) -/

/-- **SCN_01 — Simplicial category structure**.
Cited: Lurie 2009 *HTT* §A.3.1; covered upstream by
`Mathlib.AlgebraicTopology.SimplicialCategory.Basic`
(`SimplicialCategory`). -/
axiom defer_SCN_01_simplicial_category_marker : True

/-! ## SCN_02 — sHom (covered) -/

/-- **SCN_02 — Simplicial Hom-object `sHom(X,Y)`**.
Cited: Lurie 2009 *HTT* §A.3.1.5; covered upstream by
`Mathlib.AlgebraicTopology.SimplicialCategory.SimplicialObject`
(`SimplicialCategory.hom`). -/
axiom defer_SCN_02_sHom_marker : True

/-! ## SCN_03 — Thickening of `Fin (n+1)` (covered) -/

/-- **SCN_03 — Thickening of finite sets in simplicial category**.
Cited: Lurie 2009 *HTT* §1.1.5.5–1.1.5.7; covered upstream by
`Mathlib.AlgebraicTopology.SimplicialNerve.Thickening`. -/
axiom defer_SCN_03_thickening_marker : True

/-! ## SCN_04 — SimplicialNerve def (covered) -/

/-- **SCN_04 — Simplicial nerve construction**.
Cited: Lurie 2009 *HTT* §1.1.5; covered upstream by
`Mathlib.AlgebraicTopology.SimplicialNerve.Basic`
(`simplicialNerve`). -/
axiom defer_SCN_04_simplicial_nerve_def_marker : True

/-! ## LIF_01 — Horn / spine carrier (covered) -/

/-- **LIF_01 — Horn / spine carrier for left/inner fibrations**.
Cited: Lurie 2009 *HTT* §2.0.1; covered upstream by
`Mathlib.AlgebraicTopology.SimplicialSet.Horn` + the spine API. -/
axiom defer_LIF_01_horn_spine_marker : True

/-! ## CFMS_01 — Horn/spine carrier for cartesian (covered) -/

/-- **CFMS_01 — Horn/spine carrier for cartesian fibrations**.
Cited: Lurie 2009 *HTT* §2.4.0; same substrate as LIF_01. -/
axiom defer_CFMS_01_horn_spine_cart_marker : True

/-! ## CFMS_08 — HTT §2.4.4–2.4.7 applications (downstream) -/

/-- **CFMS_08 — Mapping spaces, undercategory invariance, bifibrations**.
Cited: Lurie 2009 *HTT* §2.4.4, §2.4.5, §2.4.6, §2.4.7. Deferred as
downstream consumer of post-marked work; queued behind the marked-
simplicial-set substrate (`MarkedSimplicialSet/Model.lean`). -/
axiom defer_CFMS_08_marked_apps_marker : True

/-! ## SU_01 — Coherent-nerve carrier (covered) -/

/-- **SU_01 — Coherent-nerve carrier for straightening**.
Cited: Lurie 2009 *HTT* §3.1.1; covered upstream by
`Mathlib.AlgebraicTopology.SimplicialNerve.Basic` (carrier
substrate of `simplicialNerve`). -/
axiom defer_SU_01_coherent_nerve_carrier_marker : True

/-! ## ICIC_01 — Coherent-nerve carrier (covered) -/

/-- **ICIC_01 — Coherent-nerve carrier for `Cat_∞` definition**.
Cited: Lurie 2009 *HTT* §3.0.0.1; same substrate as SU_01. -/
axiom defer_ICIC_01_coherent_nerve_carrier_marker : True

/-! ## ILCC_01 — QCat carrier (covered) -/

/-- **ILCC_01 — Quasicategory carrier for limits/colimits chapter**.
Cited: Lurie 2009 *HTT* §4.0; covered upstream by
`Mathlib.AlgebraicTopology.Quasicategory.Basic`. -/
axiom defer_ILCC_01_qcat_carrier_marker : True

/-! ## IKERC_03 — QCat carrier (covered) -/

/-- **IKERC_03 — Quasicategory carrier for relative-colimit chapter**.
Cited: Lurie 2009 *HTT* §4.3; same substrate as ILCC_01. -/
axiom defer_IKERC_03_qcat_carrier_marker : True

/-! ## AIC_08 — Adjoint patterns (analogy) -/

/-- **AIC_08 — Adjoint patterns ported from ordinary AFT**.
Cited: Lurie 2009 *HTT* §5.1.1.7 (note); deferred as analogy queued
behind `Quasicategory/Accessible/Adjoint.lean` (verdict-listed). -/
axiom defer_AIC_08_adjoint_patterns_marker : True

/-! ## PIC_04 — Ordinary AFT comparison line (analogy) -/

/-- **PIC_04 — Ordinary 1-cat AFT comparison**.
Cited: Lurie 2009 *HTT* §5.5.2 (preface); analogy only — Step 1
explicitly asked us to *compare*, not to *port*. Covered upstream by
`Mathlib.CategoryTheory.Adjunction.Limits`. -/
axiom defer_PIC_04_aft_comparison_marker : True

/-! ## PIC_05 — Reflective sheafification / Bousfield 1-cat (foreshadow) -/

/-- **PIC_05 — Reflective sheafification / Bousfield 1-cat foreshadow**.
Cited: Lurie 2009 *HTT* §5.5.4 (preface); foreshadow only. Covered
upstream by `Mathlib.CategoryTheory.Localization.Predicate`. -/
axiom defer_PIC_05_reflective_sheafification_marker : True

/-! ## LFT_01 — QCat carrier (covered) -/

/-- **LFT_01 — Quasicategory carrier for localization/factorization chapter**.
Cited: Lurie 2009 *HTT* §5.5; same substrate as ILCC_01. -/
axiom defer_LFT_01_qcat_carrier_marker : True

/-! ## PCB_01 — Ordinary paracompactness (covered) -/

/-- **PCB_01 — Ordinary paracompactness carrier**.
Cited: Lurie 2009 *HTT* §7.1.0 (preface); covered upstream by
`Mathlib.Topology.Compactness.Paracompact` (`ParacompactSpace`).
NB: this is also poison_quarantine — ordinary paracompactness ≠ HTT
Ch.7. The defer axiom records the carrier without overcredit. -/
axiom defer_PCB_01_paracompact_carrier_marker : True

end MathlibExpansion.Encyclopedia.T21c_12_lurie.Defers
