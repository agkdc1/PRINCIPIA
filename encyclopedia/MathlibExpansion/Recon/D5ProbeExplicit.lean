import MathlibExpansion.Roots.Schlessinger.ArtinLocalOver
import Mathlib.RingTheory.WittVector.DiscreteValuationRing

open scoped Witt

universe u

open MathlibExpansion.Roots.Schlessinger

variable {p : ℕ} [Fact p.Prime]
variable {k : Type u} [Field k] [CharP k p] [PerfectRing k p]

noncomputable example : ArtinLocalAlgOver (WittVector p k) k := by
  letI : Algebra (WittVector p k) k :=
    (WittVector.constantCoeff : WittVector p k →+* k).toAlgebra
  exact ArtinLocalAlgOver.residueFieldObject (Λ := WittVector p k) (k := k)
