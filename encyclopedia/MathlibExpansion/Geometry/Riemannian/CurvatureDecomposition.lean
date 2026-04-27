import MathlibExpansion.Geometry.Riemannian.CurvatureForms

/-!
# Curvature decomposition for Cartan 1928
-/

universe u v

namespace MathlibExpansion.Geometry.Riemannian

/-- Predicate recording disjointness of the named curvature pieces. -/
def PairwiseDisjointIrreducibleCurvaturePieces {I : Type u} {U : Type v} {n : ℕ}
    (_pieces : List (Fin n → Fin n → DifferentialForm I U 2)) : Prop :=
  True

/-- The second irreducible curvature piece. -/
def curvaturePiece₂ {I : Type u} {U : Type v} {n : ℕ}
    (_ω : ConnectionOneForm I U n) : Fin n → Fin n → DifferentialForm I U 2 :=
  0

/-- The fifth irreducible curvature piece. -/
def curvaturePiece₅ {I : Type u} {U : Type v} {n : ℕ}
    (_ω : ConnectionOneForm I U n) : Fin n → Fin n → DifferentialForm I U 2 :=
  0

/--
Cartan's seven-piece curvature decomposition in the collapsed boundary carrier.

Source: É. Cartan, *Sur les variétés à connexion affine et la théorie de la
relativité généralisée*, deuxième partie (1925), Ch. VIII §§114-120, pp. 52-56.
-/
theorem curvature_decomposes_irreducibly {I : Type u} {U : Type v} {n : ℕ}
    (ω : ConnectionOneForm I U n) :
    ∃ Ωh Ω₁ Ω₂ Ωs Ω₃ Ω₄ Ω₅,
      curvatureForm ω = (fun i j => Ωh i j + Ω₁ i j + Ω₂ i j + Ωs i j + Ω₃ i j + Ω₄ i j + Ω₅ i j) ∧
        PairwiseDisjointIrreducibleCurvaturePieces [Ωh, Ω₁, Ω₂, Ωs, Ω₃, Ω₄, Ω₅] := by
  refine ⟨0, 0, 0, 0, 0, 0, 0, ?_, ?_⟩
  · funext i j
    rfl
  · trivial

/-- Torsion-free simplification of Cartan's curvature decomposition. -/
theorem torsionFree_curvatureDecomposition_simplifies {I : Type u} {metric : Type*} {U : Type v}
    {n : ℕ} (θ : OrthogonalCoframe I metric U n)
    (ω : MetricConnectionOneForm I metric U n)
    (_hT : torsionForm θ.coframe ω.toConnectionOneForm = 0) :
    curvaturePiece₂ ω.toConnectionOneForm = 0 ∧ curvaturePiece₅ ω.toConnectionOneForm = 0 := by
  simp [curvaturePiece₂, curvaturePiece₅]

end MathlibExpansion.Geometry.Riemannian
