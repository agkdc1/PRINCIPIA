import Mathlib.Data.Real.Basic
import Mathlib.Data.Complex.Basic

import MathlibExpansion.Analysis.Complex.DirichletPrinciple

/-!
# Harmonic conjugates on cut domains

This file isolates the cut-domain harmonic-conjugate interface needed by the
Riemann-mapping pipeline.
-/

namespace MathlibExpansion
namespace Analysis
namespace Complex

/-- A cut simply connected planar domain. The simply connected witness lives on
the subtype corresponding to the carrier set. -/
structure CutDomain where
  carrier : Set _root_.Complex
  isOpen_carrier : IsOpen carrier
  instSimplyConnectedSpace : SimplyConnectedSpace carrier

attribute [instance] CutDomain.instSimplyConnectedSpace

/-- `v` is a harmonic conjugate of `u` on the cut domain if they assemble into a
holomorphic function on the carrier. -/
structure HarmonicConjugateOn
    (U : CutDomain) (u v : _root_.Complex → ℝ) : Prop where
  holomorphicWitness :
    ∃ f : _root_.Complex → _root_.Complex,
      DifferentiableOn ℂ f U.carrier ∧
        (∀ z : U.carrier, _root_.Complex.re (f z) = u z) ∧
        (∀ z : U.carrier, _root_.Complex.im (f z) = v z)

/-- **QUARANTINED — Tier 0 (T21c_06 Stein Step 6, 2026-04-25).**

Do **not** use this axiom as a substrate for new complex-analysis work.  The
upstream simply-connected branch-logarithm infrastructure (Gate B,
`Analysis/Complex/BranchLogarithm.lean`) has not yet been formalized in
MathlibExpansion or Mathlib.  Once Gate B lands, this axiom must be either
discharged from the simply-connected branch-logarithm theorem or restated as a
named theorem with a proof.  Until then it is treated as a live toxic axiom —
flagged in the Step-5 boardroom verdict (Tier-0 row #1) and tracked in the
Stein Step-6 quarantine ledger.

---

Narrow upstream gap: on a cut simply connected planar domain, every
real-valued harmonic function is the real part of a holomorphic function.

Citation: Sheldon Axler (1986), "Harmonic Functions from a Complex Analysis
Viewpoint", Amer. Math. Monthly 93(4), Logarithmic Conjugation Theorem
(unnumbered named theorem, pp. 248-250), specialized to the simply connected
case with no logarithmic terms. Axler records the same theorem as appearing in
J. L. Walsh (1929), "The approximation of harmonic functions by harmonic
polynomials and by harmonic rational functions", Bull. Amer. Math. Soc. 35,
pp. 518 and 527. -/
axiom exists_holomorphic_real_part_of_harmonicOn_cut_domain
    (U : CutDomain) {u : _root_.Complex → ℝ} (hu : HarmonicOn U.carrier u) :
    ∃ f : _root_.Complex → _root_.Complex,
      DifferentiableOn ℂ f U.carrier ∧
        ∀ z : U.carrier, _root_.Complex.re (f z) = u z

/-- A harmonic function on a cut simply connected domain admits a
single-valued harmonic conjugate. This is a definitional consequence of the
cited holomorphic real-part theorem. -/
theorem exists_harmonicConjugate_on_cut_domain
    (U : CutDomain) {u : _root_.Complex → ℝ} (hu : HarmonicOn U.carrier u) :
    ∃ v : _root_.Complex → ℝ, HarmonicConjugateOn U u v
    := by
  rcases exists_holomorphic_real_part_of_harmonicOn_cut_domain U hu with
    ⟨f, hf_differentiable, hf_re⟩
  refine ⟨fun z => _root_.Complex.im (f z), ?_⟩
  exact ⟨f, hf_differentiable, hf_re, fun z => rfl⟩

end Complex
end Analysis
end MathlibExpansion
