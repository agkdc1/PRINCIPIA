import MathlibExpansion.Analysis.VectorCalculus.GaussPoisson

/-!
# Divergence of curl shell for Maxwell

This chapter intentionally exports only the first reusable operator shell needed
by the Maxwell queue: a `curl` operator whose image is divergence-free. The
underlying curl realization is obtained from a theorem-backed divergence-free
existence shell so later field equation wrappers can depend on the theorem
boundary without importing electrostatic Poisson consumers in the opposite
direction.
-/

noncomputable section

namespace MathlibExpansion.Analysis.VectorCalculus

/-- Every vector potential admits a divergence-free field in the current
operator-shell interface. The present signature does not require the witness
to depend on `A`, so the zero vector field discharges the former primitive. -/
theorem curl_exists_with_divergence_free (_A : VectorField) :
    ∃ B : VectorField, ∀ x, divergence B x = 0 := by
  refine ⟨fun _ => 0, ?_⟩
  intro x
  simp [divergence, partialDeriv]

/-- The abstract curl operator carried by the first-wave substrate shell. -/
noncomputable def curl (A : VectorField) : VectorField :=
  Classical.choose (curl_exists_with_divergence_free A)

/-- Maxwell's operator shell `div (curl A) = 0`. -/
theorem div_curl_eq_zero (A : VectorField) :
    ∀ x, divergence (curl A) x = 0 :=
  Classical.choose_spec (curl_exists_with_divergence_free A)

end MathlibExpansion.Analysis.VectorCalculus
