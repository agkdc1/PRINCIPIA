import Mathlib.MeasureTheory.Integral.DominatedConvergence
import Mathlib.MeasureTheory.Integral.Lebesgue
import Mathlib.Data.ENNReal.Real

noncomputable section

open MeasureTheory

namespace MathlibExpansion
namespace Textbooks
namespace Lebesgue1904

/--
Deferred inventory stub for the simple-function / indicator lane.

Citation anchor: Lebesgue 1904, Chapter VII §IV, pp. 113-115. The checked
Mathlib snapshot already contains the underlying indicator/simple-function
integral theorems; this theorem records only the textbook-facing inventory seam
kept deferred by the Step 5 verdict.
-/
theorem lebesgue1904_indicator_const_integral {α : Type*} [MeasurableSpace α] {μ : Measure α}
    {s : Set α} (hs : MeasurableSet s) (c : ENNReal) :
    ∫⁻ x, s.indicator (fun _ : α => c) x ∂μ = c * μ s :=
  lintegral_indicator_const hs c

/--
Sharpened inventory theorem for the bounded-remainder series corridor.

Citation anchors: Lebesgue 1904, Chapter VII §IV, p. 126; Osgood 1897 for the
historical bounded-convergence corridor named by Lebesgue in footnote 1.

Mathlib's `tsum` is the unordered/unconditional sum, so the original
bounded-tail-only textbook statement is too broad for this API.  This wrapper
records the existing upstream-dischargeable version: termwise integration under
summable integral norms.
-/
theorem integral_tsum_of_bounded_remainders {α : Type*} [MeasurableSpace α] {μ : Measure α}
    [IsFiniteMeasure μ] {u : ℕ → α → ℝ}
    (hu_meas : ∀ n, AEStronglyMeasurable (u n) μ)
    (_hu_sum : ∀ᵐ x ∂μ, Summable (fun n => u n x))
    (_h_tail : ∃ M, ∀ N, ∀ᵐ x ∂μ, ‖∑' n, u (N + n) x‖ ≤ M)
    (h_norm : (∑' n, (∫⁻ x, ‖u n x‖ₑ ∂μ)) ≠ (⊤ : ENNReal)) :
    ∫ x, ∑' n, u n x ∂μ = ∑' n, ∫ x, u n x ∂μ :=
  integral_tsum hu_meas h_norm

end Lebesgue1904
end Textbooks
end MathlibExpansion
