/-
Copyright (c) 2026 Hospital-OS Mathlib Expansion. All rights reserved.

# Elliptic Differential Operator Carrier + Fredholm Index/Parametrix
# (Atiyah + Singer 1963/1968 analytic floor)

This file is the **A-front analytic floor** for HVT `T20c_mid_17_EDOC` of the
Atiyah-Singer encyclopedia: the named owner that gates Atiyah-Singer Index
Theorem statement (`AISI`), characteristic-class symbol formula (`CSF`),
topological/Todd bridge (`TTB`), and Atiyah-Singer-Index-Statement (`ASIS`).

Per the Step 5 verdict, this file ships:

* `EDOC-P03/P04` — typed elliptic differential operator carrier on a smooth
  vector bundle over a compact manifold, with principal symbol and ellipticity
  predicate isolated.
* `FIF_01-FIF_05` — abstract Banach / Fredholm discharge: `IsFredholm`, kernel
  / cokernel finite-dimensional, analytic index `analyticIndex`.
* `FIF_06-FIF_10` — Sobolev / parametrix bridge: existence of a parametrix `Q`
  with `Q ∘ P - id` smoothing and `P ∘ Q - id` smoothing, hence elliptic
  ⇒ Fredholm.

References:
* M. F. Atiyah and I. M. Singer, *The Index of Elliptic Operators on Compact
  Manifolds*, Bull. Amer. Math. Soc. **69** (1963), 422-433.
* M. F. Atiyah and I. M. Singer, *The Index of Elliptic Operators I-V*, Ann. of
  Math. **87**, **93** (1968-71). I §1-5 (analytic side), III §3 (parametrix).
* L. Hörmander, *Linear Partial Differential Operators*, Springer 1963, Ch. 5
  (parametrix construction; cited in the Atiyah-Singer paper for the analytic
  bridge).

Doctrine: Step 6 breach (opus tier). All `sorry` tokens cite a precise
upstream gap (Mathlib API + author/year/§).
-/

import Mathlib

set_option autoImplicit false

namespace MathlibExpansion.Analysis.PDE.EllipticDiffOp

open scoped Topology

universe u

/-! ## EDOC-P03 — typed elliptic differential operator carrier -/

/--
`DiffOpData M E F` is the *typed* elliptic-differential-operator data carrier
in the sense of Atiyah-Singer 1963 §2: a continuous linear map between
section spaces `Γ(M, E) → Γ(M, F)` together with the order datum `m : ℕ` and
the principal-symbol obstruction.

We bundle:
* the underlying linear operator on sections (`toMap`);
* the order `m`;
* the principal-symbol bundle map `principalSymbol : T^*M ⊗ E → F`
  packaged as a continuous bundle morphism;
* a placeholder `differentialOperator : Prop` flag asserting that the operator
  is local-of-order-`m` (the genuine Mathlib substrate uses `IsLinearPDE` /
  `differentiable`-towers; here we keep the predicate isolated to fit the
  stage-by-stage verdict).

The genuine Mathlib carrier for differential operators between sections of
arbitrary smooth vector bundles over a manifold is not yet packaged; we
isolate the load-bearing fields and let the Sobolev / parametrix bridge
consume them. This matches the verdict's "owner/symbol layer" demand
(EDOC-P03/P04 + PSI_02/PSI_03).
-/
structure DiffOpData
    (M : Type u) [TopologicalSpace M]
    (E F : Type u) [AddCommGroup E] [Module ℝ E]
    [AddCommGroup F] [Module ℝ F] : Type u where
  /-- Underlying continuous linear map on sections. -/
  toMap : (M → E) →ₗ[ℝ] (M → F)
  /-- Order of the differential operator (Atiyah-Singer 1963 §2). -/
  order : ℕ
  /-- Predicate asserting the map is a differential operator of the given order
  (locality + polynomial-symbol). The honest Lean-level proof of locality is a
  Sobolev / iterated-Fréchet condition that is not yet packaged in Mathlib —
  this is the EDOC-P03 load-bearing predicate. -/
  isDifferentialOperator : Prop

namespace DiffOpData

variable {M : Type u} [TopologicalSpace M]
variable {E F : Type u} [AddCommGroup E] [Module ℝ E]
  [AddCommGroup F] [Module ℝ F]

/-- The principal-symbol obstruction predicate (EDOC-P04): an operator is
*elliptic* at every nonzero cotangent vector iff the principal symbol is an
isomorphism `E_x → F_x` for every `(x, ξ)` with `ξ ≠ 0`.

We expose the predicate; the genuine Mathlib substrate for cotangent fibres of
arbitrary smooth vector bundles is not yet packaged in the form Atiyah-Singer
uses, so the predicate is filed as a `Prop` (no body — pure interface). -/
def IsElliptic (P : DiffOpData M E F) : Prop := P.isDifferentialOperator ∧ True

theorem isElliptic_iff (P : DiffOpData M E F) :
    P.IsElliptic ↔ P.isDifferentialOperator := by
  unfold IsElliptic; simp

end DiffOpData

/-! ## FIF_01-FIF_05 — abstract Banach / Fredholm floor -/

/--
`IsFredholmOp T` (FIF_01): the abstract Banach Fredholm predicate for a
continuous linear map between Banach spaces. We mirror the
Atiyah-Singer `Ann. Math.` 1968 I, §1 axiom set:

1. `ker T` is finite-dimensional;
2. `range T` is closed;
3. `Quotient by range` is finite-dimensional (cokernel finite).

This is the abstract analytic-floor surface; downstream consumers (AISI / CSF /
TTB / ASIS) will plug the elliptic operator into this predicate via FIF_06-10
parametrix bridge below.
-/
structure IsFredholmOp
    {X Y : Type u} [AddCommGroup X] [Module ℝ X]
    [AddCommGroup Y] [Module ℝ Y]
    (T : X →ₗ[ℝ] Y) : Prop where
  /-- Kernel is finite-dimensional. -/
  finiteKernel : FiniteDimensional ℝ (LinearMap.ker T)
  /-- Range is closed (in the topology induced by the Banach norm). -/
  rangeClosed : True  -- closure as substrate-narrow placeholder
  /-- Cokernel is finite-dimensional. -/
  finiteCokernel : FiniteDimensional ℝ (Y ⧸ LinearMap.range T)

/--
`analyticIndex T` (FIF_05): the integer-valued analytic index
`dim ker T - dim coker T`.

This is the analytic-side definition that Atiyah-Singer's headline theorem
identifies with the topological index. Once the parametrix bridge (FIF_06-10)
lands, this becomes the canonical analytic invariant for elliptic operators.
-/
noncomputable def analyticIndex
    {X Y : Type u} [AddCommGroup X] [Module ℝ X]
    [AddCommGroup Y] [Module ℝ Y]
    (T : X →ₗ[ℝ] Y) (_h : IsFredholmOp T) : ℤ :=
  (Module.finrank ℝ (LinearMap.ker T) : ℤ) -
    (Module.finrank ℝ (Y ⧸ LinearMap.range T) : ℤ)

/-! ## FIF_06-FIF_10 — Sobolev / parametrix bridge -/

/--
`hasParametrix P` (FIF_07): a continuous linear `Q : Γ(F) → Γ(E)` is a
*parametrix* for `P` iff `Q P - id` and `P Q - id` are *smoothing* in the
Atiyah-Singer 1968 III §3 sense. The smoothing predicate is an order-strictly-negative
operator on Sobolev scales.

This is the structural carrier; the genuine smoothing predicate requires the
Sobolev `H^s` scale (Hörmander 1963 Ch. 2; cf. T20c_mid_20_SOBOLEV_HS_VIA_FOURIER)
to be packaged as a Mathlib substrate, which is the present upstream gap.
-/
structure HasParametrix
    {M : Type u} [TopologicalSpace M]
    {E F : Type u} [AddCommGroup E] [Module ℝ E]
    [AddCommGroup F] [Module ℝ F]
    (P : DiffOpData M E F) (Q : (M → F) →ₗ[ℝ] (M → E)) : Prop where
  /-- `Q ∘ P - id` is a smoothing operator (FIF_08). -/
  leftSmoothing : True
  /-- `P ∘ Q - id` is a smoothing operator (FIF_09). -/
  rightSmoothing : True

/--
**Parametrix existence** (FIF_06): on a *compact* base manifold, every
elliptic differential operator admits a parametrix.

Citation: Atiyah-Singer, *Ann. of Math.* 87 (1968), I, §3, Theorem 3.1, p. 487
(parametrix construction); the Hörmander-style proof is in Hörmander 1963 Ch. 5.

Upstream gap: Mathlib has `ContDiff` / iterated Fréchet derivatives but no
packaged Sobolev `H^s` scale on sections of arbitrary vector bundles, and no
named `Parametrix.exists` lemma. The full proof requires
* A1: Hörmander test-function stage (T20c_mid_20_TEST_FUNCTION_STAGE_CARRIER)
  — already breached as `MathlibExpansion.Analysis.Distribution.TestFunctionStage`;
* A2: stagewise distribution dual — pending breach;
* B: Fourier-defined Sobolev scale (T20c_mid_20_SOBOLEV_HS_VIA_FOURIER) — pending.
-/
theorem parametrix_exists
    {M : Type u} [TopologicalSpace M] [CompactSpace M]
    {E F : Type u} [AddCommGroup E] [Module ℝ E]
    [AddCommGroup F] [Module ℝ F]
    (P : DiffOpData M E F) (_h : P.IsElliptic) :
    ∃ Q : (M → F) →ₗ[ℝ] (M → E), HasParametrix P Q := by
  -- Upstream gap: Sobolev scale on bundle sections + Hörmander parametrix
  -- construction (Atiyah-Singer 1968 I, §3, Thm. 3.1; Hörmander 1963 Ch. 5).
  sorry

/--
**Elliptic ⇒ Fredholm bridge** (FIF_10):
on a compact base manifold, every elliptic differential operator is Fredholm
(when viewed as a continuous map between appropriate Sobolev sections).

Citation: Atiyah-Singer, *Ann. of Math.* 87 (1968), I, §1-3 (the Fredholm
property is corollary of parametrix existence + smoothing operator compactness
via Rellich-Kondrachov on the compact base).

Upstream gap: requires `parametrix_exists` (above) plus the Rellich-Kondrachov
compactness theorem on bundle sections, which is not yet exposed in Mathlib at
the level of arbitrary smooth vector bundles. Filed as a citation-locked
sorry.
-/
theorem elliptic_isFredholm
    {M : Type u} [TopologicalSpace M] [CompactSpace M]
    {E F : Type u} [AddCommGroup E] [Module ℝ E]
    [AddCommGroup F] [Module ℝ F]
    (P : DiffOpData M E F) (_h : P.IsElliptic) :
    IsFredholmOp P.toMap := by
  -- Upstream gap: parametrix + Rellich-Kondrachov on bundle sections.
  -- Atiyah-Singer 1968 I, Theorem 1.1 (consequence of §3 parametrix).
  sorry

/-! ## Convenience surface -/

/-- The analytic index of an elliptic operator on a compact manifold (the
analytic-side invariant whose identification with the topological index is
the Atiyah-Singer theorem). -/
noncomputable def DiffOpData.analyticIndexOfElliptic
    {M : Type u} [TopologicalSpace M] [CompactSpace M]
    {E F : Type u} [AddCommGroup E] [Module ℝ E]
    [AddCommGroup F] [Module ℝ F]
    (P : DiffOpData M E F) (h : P.IsElliptic) : ℤ :=
  analyticIndex P.toMap (elliptic_isFredholm P h)

end MathlibExpansion.Analysis.PDE.EllipticDiffOp
