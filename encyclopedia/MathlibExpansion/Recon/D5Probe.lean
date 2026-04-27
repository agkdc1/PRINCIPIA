import MathlibExpansion.Roots.Schlessinger.ArtinLocalOver
import Mathlib.RingTheory.WittVector.DiscreteValuationRing

open scoped Witt

universe u

open MathlibExpansion.Roots.Schlessinger

variable {p : ℕ} [Fact p.Prime]
variable {k : Type u} [Field k] [CharP k p] [PerfectRing k p]

#check @ArtinLocalAlgOver
#check (WittVector p k)
#check (WittVector.constantCoeff : WittVector p k →+* k)
#synth CommRing (WittVector p k)
#synth Algebra (WittVector p k) k

#check ArtinLocalAlgOver.residueFieldObject (Λ := WittVector p k) (k := k)

noncomputable example : ArtinLocalAlgOver (WittVector p k) k := by
  letI : Algebra (WittVector p k) k :=
    (WittVector.constantCoeff : WittVector p k →+* k).toAlgebra
  exact ArtinLocalAlgOver.residueFieldObject (Λ := WittVector p k) (k := k)
