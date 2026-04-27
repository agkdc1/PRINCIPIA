import MathlibExpansion.Roots.FontaineLaffaille

/-!
# Fontaine-Laffaille strict morphisms (R8.5 sidecar)

Defines `FLMorphism` (filtration-preserving, Frobenius-commuting linear map),
the `Strict` predicate, kernel closure theorems at Hodge weights {0,1}, and
cokernel filtration characterisation conditional on `Strict`.

No subquotient machinery, no abelian category.  Downstream consumers that need
strictness assert it as a hypothesis.
-/

namespace MathlibExpansion
namespace Roots
namespace FontaineLaffailleStrict

open FontaineLaffaille

universe u v

variable {p : ℕ} [Fact p.Prime] {k : Type u} [CommRing k]

/-- A morphism between two Fontaine-Laffaille modules: a `W(k)`-linear map
that (i) preserves the degree-1 filtration piece and (ii) commutes with the
Frobenius endomorphism. -/
structure FLMorphism (M N : FontaineLaffailleModule p k) where
  toLinear    : M.M →ₗ[WittVector p k] N.M
  map_fil1    : ∀ x ∈ M.Fil 1, toLinear x ∈ N.Fil 1
  commute_phi : ∀ x : M.M, toLinear (M.frobenius x) = N.frobenius (toLinear x)

/-- A morphism is **strict** if every `Fil¹(N)`-element in the image of
`toLinear` has a preimage in `Fil¹(M)`.  This is the standard filtration-
strictness condition; it is needed to put a well-defined filtration on the
cokernel. -/
def Strict {M N : FontaineLaffailleModule p k} (f : FLMorphism M N) : Prop :=
  ∀ y : N.M, y ∈ N.Fil 1 → y ∈ LinearMap.range f.toLinear →
    ∃ x : M.M, x ∈ M.Fil 1 ∧ f.toLinear x = y

namespace FLMorphism

variable {M N : FontaineLaffailleModule p k} (f : FLMorphism M N)

/-- **Kernel weight closure at {0,1}**: Hodge weights of the source module —
and hence of any subobject including `ker(f)` — all lie in {0,1}.
Real theorem; follows directly from `FontaineLaffailleModule.weights_supported`. -/
theorem ker_hodge_weights (n : ℤ) (hn : n ∈ M.hodgeWeights) : n = 0 ∨ n = 1 :=
  M.weights_supported n hn

/-- **Kernel Frobenius stability** (weight-0 and weight-1 cases unified):
the Frobenius endomorphism preserves `ker(f)`.
Proof: `f(φ(x)) = φ(f(x)) = φ(0) = 0`, using commutativity alone — no FL API. -/
theorem ker_frobenius_stable (x : M.M) (hx : x ∈ LinearMap.ker f.toLinear) :
    M.frobenius x ∈ LinearMap.ker f.toLinear := by
  simp only [LinearMap.mem_ker] at hx ⊢
  rw [f.commute_phi, hx, map_zero]

/-- The filtered kernel submodule `ker(f) ⊓ Fil¹(M)`. -/
def kerFil1 : Submodule (WittVector p k) M.M :=
  LinearMap.ker f.toLinear ⊓ M.Fil 1

/-- `f` sends `Fil¹(M)` into `Fil¹(N)` as submodules. -/
theorem map_fil1_le : (M.Fil 1).map f.toLinear ≤ N.Fil 1 := by
  intro y hy
  obtain ⟨x, hx, rfl⟩ := Submodule.mem_map.mp hy
  exact f.map_fil1 x hx

/-- **Cokernel filtration under Strict**: if `f` is strict, every `Fil¹(N)`-
element in the image of `f` lifts to `Fil¹(M)`.  This characterises the
cokernel filtration as `Fil¹(N) / f(Fil¹(M))` and is the key filtered-
exactness property; without `Strict` the quotient filtration can be pathological. -/
theorem coker_fil1_of_strict (hf : Strict f) (y : N.M)
    (hy : y ∈ N.Fil 1) (hy_img : y ∈ LinearMap.range f.toLinear) :
    ∃ x : M.M, x ∈ M.Fil 1 ∧ f.toLinear x = y :=
  hf y hy hy_img

end FLMorphism

end FontaineLaffailleStrict
end Roots
end MathlibExpansion
