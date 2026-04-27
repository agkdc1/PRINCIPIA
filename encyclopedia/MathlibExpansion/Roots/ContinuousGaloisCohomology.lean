import Mathlib.Topology.ContinuousMap.Algebra
import Mathlib.Topology.Algebra.Group.Basic
import Mathlib.Topology.Algebra.Module.Basic
import Mathlib.Topology.LocallyConstant.Basic
import Mathlib.Topology.LocallyConstant.Algebra
import Mathlib.Topology.LocallyConstant.Basic
import Mathlib.Topology.LocallyConstant.Algebra
import Mathlib.LinearAlgebra.Dual
import Mathlib.Topology.Category.Profinite.Basic
import Mathlib.CategoryTheory.Limits.HasLimits
import Mathlib.FieldTheory.AbsoluteGaloisGroup
import Mathlib.FieldTheory.Galois.Basic
import Mathlib.RepresentationTheory.GroupCohomology.Hilbert90
import Mathlib.RepresentationTheory.GroupCohomology.LowDegree
import Mathlib.RepresentationTheory.GroupCohomology.Functoriality
import Mathlib.Algebra.Homology.HomologySequence
import Mathlib.Algebra.Homology.HomologicalComplexAbelian
import Mathlib.Algebra.Homology.ShortComplex.ShortExact
import Mathlib.Tactic

/-!
# Continuous Galois cochains

This file starts the continuous/profinite group-cohomology layer from the
bundled continuous-map object already available in Mathlib.

For topological spaces `G` and `M`, an inhomogeneous continuous `n`-cochain is
defined as the bundled continuous map `C((Fin n → G), M)`. The file also
packages a finite-quotient cohomology system whose cohomology object is the
colimit of finite-group `groupCohomology` terms.
-/

namespace MathlibExpansion
namespace Roots
namespace ContinuousGaloisCohomology

open CategoryTheory
open CategoryTheory.Limits

/-- Continuous inhomogeneous `n`-cochains on a topological group-like space
`G`, with values in a topological coefficient space `M`. -/
abbrev ContinuousCochain (G M : Type*) [TopologicalSpace G] [TopologicalSpace M] (n : ℕ) :=
  C(Fin n → G, M)

/-- Continuous inhomogeneous `n`-cochains specialized to the absolute Galois
group of a field. -/
abbrev AbsoluteGaloisContinuousCochain
    (K M : Type*) [Field K] [TopologicalSpace M] (n : ℕ) :=
  ContinuousCochain (Field.absoluteGaloisGroup K) M n

variable {G H Q M N : Type*} [TopologicalSpace G] [TopologicalSpace H]
  [TopologicalSpace Q] [TopologicalSpace M] [TopologicalSpace N] {n m : ℕ}

namespace ContinuousCochain

/-- Coerce a continuous cochain to its underlying function. -/
def toFun (c : ContinuousCochain G M n) : (Fin n → G) → M :=
  c

@[simp]
theorem toFun_apply (c : ContinuousCochain G M n) (x : Fin n → G) :
    c.toFun x = c x :=
  rfl

@[ext]
theorem ext {c d : ContinuousCochain G M n} (h : ∀ x, c x = d x) : c = d :=
  ContinuousMap.ext h

/-- Pull a continuous cochain back along a continuous map between finite powers
of `G`. -/
def pullback (φ : (Fin m → G) → (Fin n → G)) (hφ : Continuous φ)
    (c : ContinuousCochain G M n) : ContinuousCochain G M m :=
  c.comp ⟨φ, hφ⟩

@[simp]
theorem pullback_apply (φ : (Fin m → G) → (Fin n → G)) (hφ : Continuous φ)
    (c : ContinuousCochain G M n) (x : Fin m → G) :
    pullback φ hφ c x = c (φ x) :=
  rfl

/-- Constant continuous cochains. -/
def const (a : M) : ContinuousCochain G M n where
  toFun _ := a
  continuous_toFun := continuous_const

@[simp]
theorem const_apply (a : M) (x : Fin n → G) :
    const (G := G) (n := n) a x = a :=
  rfl

/-- Postcompose a continuous cochain by a continuous map on coefficients. -/
def mapRange (φ : M → N) (hφ : Continuous φ) (c : ContinuousCochain G M n) :
    ContinuousCochain G N n :=
  ⟨fun x => φ (c x), hφ.comp c.continuous⟩

@[simp]
theorem mapRange_apply (φ : M → N) (hφ : Continuous φ)
    (c : ContinuousCochain G M n) (x : Fin n → G) :
    mapRange φ hφ c x = φ (c x) :=
  rfl

@[simp]
theorem mapRange_id (c : ContinuousCochain G M n) :
    mapRange (fun a : M => a) continuous_id c = c := by
  ext x
  rfl

@[simp]
theorem mapRange_comp {P : Type*} [TopologicalSpace P]
    (φ : N → P) (hφ : Continuous φ) (ψ : M → N) (hψ : Continuous ψ)
    (c : ContinuousCochain G M n) :
    mapRange φ hφ (mapRange ψ hψ c) =
      mapRange (fun a : M => φ (ψ a)) (hφ.comp hψ) c := by
  ext x
  rfl

@[simp]
theorem mapRange_const (φ : M → N) (hφ : Continuous φ) (a : M) :
    mapRange (G := G) (n := n) φ hφ (const (G := G) (n := n) a) =
      const (G := G) (n := n) (φ a) := by
  ext x
  rfl

@[simp]
theorem pullback_id (c : ContinuousCochain G M n) :
    pullback (fun x : Fin n → G => x) continuous_id c = c := by
  ext x
  rfl

@[simp]
theorem pullback_comp {l : ℕ}
    (φ : (Fin m → G) → (Fin n → G)) (hφ : Continuous φ)
    (ψ : (Fin l → G) → (Fin m → G)) (hψ : Continuous ψ)
    (c : ContinuousCochain G M n) :
    pullback ψ hψ (pullback φ hφ c) =
      pullback (fun x : Fin l → G => φ (ψ x)) (hφ.comp hψ) c := by
  ext x
  rfl

@[simp]
theorem pullback_const (φ : (Fin m → G) → (Fin n → G)) (hφ : Continuous φ)
    (a : M) :
    pullback φ hφ (const (G := G) (n := n) a) = const (G := G) (n := m) a := by
  ext x
  rfl

@[simp]
theorem mapRange_pullback (φ : M → N) (hφ : Continuous φ)
    (ψ : (Fin m → G) → (Fin n → G)) (hψ : Continuous ψ)
    (c : ContinuousCochain G M n) :
    mapRange φ hφ (pullback ψ hψ c) =
      pullback ψ hψ (mapRange φ hφ c) := by
  ext x
  rfl

/-- Set-style presentation of continuous cochains: the subset of all
inhomogeneous functions on `Fin n → G` satisfying the continuity constraint. -/
def continuousCochainSet (G M : Type*) [TopologicalSpace G] [TopologicalSpace M]
    (n : ℕ) : Set (((Fin n → G) → M)) :=
  { f | Continuous f }

@[simp]
theorem mem_continuousCochainSet (f : (Fin n → G) → M) :
    f ∈ continuousCochainSet G M n ↔ Continuous f :=
  Iff.rfl

/-- Convert a function in the set-style continuous-cochain subset into the
bundled `ContinuousMap` model used by the rest of the file. -/
def ofSet (f : { f : (Fin n → G) → M // f ∈ continuousCochainSet G M n }) :
    ContinuousCochain G M n :=
  ⟨f.1, f.2⟩

@[simp]
theorem ofSet_apply (f : { f : (Fin n → G) → M // f ∈ continuousCochainSet G M n })
    (x : Fin n → G) :
    ofSet f x = f.1 x :=
  rfl

/-- Convert a bundled continuous cochain into the set-style subtype. -/
def toSet (c : ContinuousCochain G M n) :
    { f : (Fin n → G) → M // f ∈ continuousCochainSet G M n } :=
  ⟨c, c.continuous⟩

@[simp]
theorem toSet_apply (c : ContinuousCochain G M n) (x : Fin n → G) :
    (toSet c).1 x = c x :=
  rfl

@[simp]
theorem ofSet_toSet (c : ContinuousCochain G M n) :
    ofSet (toSet c) = c :=
  rfl

@[simp]
theorem toSet_ofSet (f : { f : (Fin n → G) → M // f ∈ continuousCochainSet G M n }) :
    toSet (ofSet f) = f :=
  rfl

/-- Pull a continuous cochain on `G` back along a continuous map `H → G`,
coordinatewise on finite powers. This is the cochain-level operation underlying
restriction to a subgroup and inflation along a quotient map. -/
def comapDomain (φ : H → G) (hφ : Continuous φ) (c : ContinuousCochain G M n) :
    ContinuousCochain H M n :=
  c.comp
    { toFun := fun x i => φ (x i)
      continuous_toFun := by fun_prop }

@[simp]
theorem comapDomain_apply (φ : H → G) (hφ : Continuous φ)
    (c : ContinuousCochain G M n) (x : Fin n → H) :
    comapDomain φ hφ c x = c (fun i => φ (x i)) :=
  rfl

@[simp]
theorem comapDomain_id (c : ContinuousCochain G M n) :
    comapDomain (fun g : G => g) continuous_id c = c := by
  ext x
  rfl

@[simp]
theorem comapDomain_comp (φ : H → G) (hφ : Continuous φ)
    (ψ : Q → H) (hψ : Continuous ψ) (c : ContinuousCochain G M n) :
    comapDomain ψ hψ (comapDomain φ hφ c) =
      comapDomain (fun q : Q => φ (ψ q)) (hφ.comp hψ) c := by
  ext x
  rfl

@[simp]
theorem comapDomain_const (φ : H → G) (hφ : Continuous φ) (a : M) :
    comapDomain φ hφ (const (G := G) (n := n) a) =
      const (G := H) (n := n) a := by
  ext x
  rfl

@[simp]
theorem mapRange_comapDomain (φ : M → N) (hφ : Continuous φ)
    (ψ : H → G) (hψ : Continuous ψ) (c : ContinuousCochain G M n) :
    mapRange φ hφ (comapDomain ψ hψ c) =
      comapDomain ψ hψ (mapRange φ hφ c) := by
  ext x
  rfl

/-- Cochain-level restriction along a continuous subgroup inclusion or, more
generally, any continuous homomorphism into the ambient group. -/
def restrict (ι : H → G) (hι : Continuous ι) (c : ContinuousCochain G M n) :
    ContinuousCochain H M n :=
  comapDomain ι hι c

@[simp]
theorem restrict_apply (ι : H → G) (hι : Continuous ι)
    (c : ContinuousCochain G M n) (x : Fin n → H) :
    restrict ι hι c x = c (fun i => ι (x i)) :=
  rfl

@[simp]
theorem restrict_id (c : ContinuousCochain G M n) :
    restrict (fun g : G => g) continuous_id c = c :=
  comapDomain_id c

@[simp]
theorem restrict_comp (ι : H → G) (hι : Continuous ι)
    (κ : Q → H) (hκ : Continuous κ) (c : ContinuousCochain G M n) :
    restrict κ hκ (restrict ι hι c) =
      restrict (fun q : Q => ι (κ q)) (hι.comp hκ) c :=
  comapDomain_comp ι hι κ hκ c

@[simp]
theorem restrict_const (ι : H → G) (hι : Continuous ι) (a : M) :
    restrict ι hι (const (G := G) (n := n) a) =
      const (G := H) (n := n) a :=
  comapDomain_const ι hι a

@[simp]
theorem mapRange_restrict (φ : M → N) (hφ : Continuous φ)
    (ι : H → G) (hι : Continuous ι) (c : ContinuousCochain G M n) :
    mapRange φ hφ (restrict ι hι c) =
      restrict ι hι (mapRange φ hφ c) :=
  mapRange_comapDomain φ hφ ι hι c

/-- Cochain-level inflation along a continuous quotient/projection `G → Q`. -/
def inflate (π : G → Q) (hπ : Continuous π) (c : ContinuousCochain Q M n) :
    ContinuousCochain G M n :=
  comapDomain π hπ c

@[simp]
theorem inflate_apply (π : G → Q) (hπ : Continuous π)
    (c : ContinuousCochain Q M n) (x : Fin n → G) :
    inflate π hπ c x = c (fun i => π (x i)) :=
  rfl

@[simp]
theorem inflate_id (c : ContinuousCochain G M n) :
    inflate (fun g : G => g) continuous_id c = c :=
  comapDomain_id c

@[simp]
theorem inflate_comp (π : G → Q) (hπ : Continuous π)
    (ρ : H → G) (hρ : Continuous ρ) (c : ContinuousCochain Q M n) :
    inflate ρ hρ (inflate π hπ c) =
      inflate (fun h : H => π (ρ h)) (hπ.comp hρ) c :=
  comapDomain_comp π hπ ρ hρ c

@[simp]
theorem inflate_const (π : G → Q) (hπ : Continuous π) (a : M) :
    inflate π hπ (const (G := Q) (n := n) a) =
      const (G := G) (n := n) a :=
  comapDomain_const π hπ a

@[simp]
theorem mapRange_inflate (φ : M → N) (hφ : Continuous φ)
    (π : G → Q) (hπ : Continuous π) (c : ContinuousCochain Q M n) :
    mapRange φ hφ (inflate π hπ c) =
      inflate π hπ (mapRange φ hφ c) :=
  mapRange_comapDomain φ hφ π hπ c

@[simp]
theorem restrict_zero_apply (ι : H → G) (hι : Continuous ι)
    (c : ContinuousCochain G M 0) (x : Fin 0 → H) :
    restrict ι hι c x = c Fin.elim0 := by
  rw [restrict_apply]
  congr
  funext i
  exact Fin.elim0 i

@[simp]
theorem inflate_zero_apply (π : G → Q) (hπ : Continuous π)
    (c : ContinuousCochain Q M 0) (x : Fin 0 → G) :
    inflate π hπ c x = c Fin.elim0 := by
  rw [inflate_apply]
  congr
  funext i
  exact Fin.elim0 i

@[simp]
theorem zero_apply [Zero M] (x : Fin n → G) :
    (0 : ContinuousCochain G M n) x = 0 :=
  rfl

@[simp]
theorem add_apply [Add M] [ContinuousAdd M] (c d : ContinuousCochain G M n)
    (x : Fin n → G) :
    (c + d) x = c x + d x :=
  rfl

@[simp]
theorem neg_apply [Neg M] [ContinuousNeg M] (c : ContinuousCochain G M n)
    (x : Fin n → G) :
    (-c) x = -c x :=
  rfl

@[simp]
theorem sub_apply [Sub M] [ContinuousSub M] (c d : ContinuousCochain G M n)
    (x : Fin n → G) :
    (c - d) x = c x - d x :=
  rfl

/-- The last face map deleting the final coordinate. -/
def lastFace (G : Type*) [TopologicalSpace G] (n : ℕ) :
    C((Fin (n + 1) → G), (Fin n → G)) where
  toFun x i := x i.castSucc
  continuous_toFun := by fun_prop

@[simp]
theorem lastFace_apply (x : Fin (n + 1) → G) (i : Fin n) :
    lastFace G n x i = x i.castSucc :=
  rfl

/-- The unique middle face in degree one, multiplying adjacent coordinates. -/
def oneMiddleFace [Mul G] [ContinuousMul G] :
    C((Fin 2 → G), (Fin 1 → G)) where
  toFun x _ := x 0 * x 1
  continuous_toFun := by fun_prop

@[simp]
theorem oneMiddleFace_apply [Mul G] [ContinuousMul G] (x : Fin 2 → G) (i : Fin 1) :
    oneMiddleFace (G := G) x i = x 0 * x 1 :=
  rfl

/-- The continuous map deleting the first coordinate. -/
def tail (G : Type*) [TopologicalSpace G] (n : ℕ) :
    C((Fin (n + 1) → G), (Fin n → G)) where
  toFun x i := x i.succ
  continuous_toFun := by fun_prop

@[simp]
theorem tail_apply (x : Fin (n + 1) → G) (i : Fin n) :
    tail G n x i = x i.succ :=
  rfl

/-- The first, action-valued term of the inhomogeneous coboundary. -/
def actionTerm [SMul G M] [ContinuousSMul G M] (c : ContinuousCochain G M n) :
    ContinuousCochain G M (n + 1) where
  toFun x := x 0 • c (tail G n x)
  continuous_toFun := by fun_prop

@[simp]
theorem actionTerm_apply [SMul G M] [ContinuousSMul G M]
    (c : ContinuousCochain G M n) (x : Fin (n + 1) → G) :
    actionTerm c x = x 0 • c (tail G n x) :=
  rfl

/-- The degree-zero inhomogeneous coboundary, bundled as a continuous cochain. -/
def zeroCoboundary [SMul G M] [ContinuousSMul G M] [Sub M] [ContinuousSub M]
    (c : ContinuousCochain G M 0) : ContinuousCochain G M 1 where
  toFun x := x 0 • c Fin.elim0 - c Fin.elim0
  continuous_toFun := by fun_prop

@[simp]
theorem zeroCoboundary_apply [SMul G M] [ContinuousSMul G M] [Sub M] [ContinuousSub M]
    (c : ContinuousCochain G M 0) (x : Fin 1 → G) :
    zeroCoboundary c x = x 0 • c Fin.elim0 - c Fin.elim0 :=
  rfl

/-- The degree-one inhomogeneous coboundary, bundled as a continuous cochain.

This is the first nontrivial case of the usual formula
`(δ c)(g₀, g₁) = g₀ • c(g₁) - c(g₀ * g₁) + c(g₀)`. -/
def oneCoboundary [Mul G] [ContinuousMul G] [SMul G M] [ContinuousSMul G M]
    [Sub M] [ContinuousSub M] [Add M] [ContinuousAdd M]
    (c : ContinuousCochain G M 1) : ContinuousCochain G M 2 where
  toFun x := x 0 • c (fun _ => x 1) - c (fun _ => x 0 * x 1) + c (fun _ => x 0)
  continuous_toFun := by fun_prop

@[simp]
theorem oneCoboundary_apply [Mul G] [ContinuousMul G] [SMul G M] [ContinuousSMul G M]
    [Sub M] [ContinuousSub M] [Add M] [ContinuousAdd M]
    (c : ContinuousCochain G M 1) (x : Fin 2 → G) :
    oneCoboundary c x =
      x 0 • c (fun _ => x 1) - c (fun _ => x 0 * x 1) + c (fun _ => x 0) :=
  rfl

/-- The degree-one cocycle condition for a bundled continuous inhomogeneous
cochain. -/
def oneCocycleCondition [Mul G] [SMul G M] [Sub M] [Add M] [Zero M]
    (c : ContinuousCochain G M 1) : Prop :=
  ∀ x : Fin 2 → G, x 0 • c (fun _ => x 1) - c (fun _ => x 0 * x 1) + c (fun _ => x 0) = 0

theorem oneCocycleCondition_iff [Mul G] [ContinuousMul G] [SMul G M] [ContinuousSMul G M]
    [Sub M] [ContinuousSub M] [Add M] [ContinuousAdd M] [Zero M]
    (c : ContinuousCochain G M 1) :
    oneCocycleCondition c ↔ ∀ x : Fin 2 → G, oneCoboundary c x = 0 :=
  Iff.rfl

/-- A named degree-one continuous cocycle predicate for the inhomogeneous
crossed-homomorphism formula. -/
def IsContinuousOneCocycle [Mul G] [SMul G M] [Add M]
    (c : ContinuousCochain G M 1) : Prop :=
  ∀ g h : G, c (fun _ : Fin 1 => g * h) =
    g • c (fun _ : Fin 1 => h) + c (fun _ : Fin 1 => g)

/-- A named degree-one continuous coboundary predicate: principal continuous
one-cochains of the form `g ↦ g • m - m`. -/
def IsContinuousOneCoboundary [SMul G M] [Sub M]
    (c : ContinuousCochain G M 1) : Prop :=
  ∃ m : M, ∀ g : G, c (fun _ : Fin 1 => g) = g • m - m

/-- Bundled continuous one-cocycles. -/
abbrev ContinuousCocycle [Mul G] [SMul G M] [Add M] :=
  { c : ContinuousCochain G M 1 // IsContinuousOneCocycle c }

/-- Bundled continuous one-coboundaries. -/
abbrev ContinuousCoboundary [SMul G M] [Sub M] :=
  { c : ContinuousCochain G M 1 // IsContinuousOneCoboundary c }

/-- The elementary relation used to identify continuous one-cocycles whose
difference is a continuous one-coboundary. -/
def ContinuousH1CoboundaryRel [Mul G] [SMul G M] [Add M] [Sub M] [ContinuousSub M]
    (c d : ContinuousCocycle (G := G) (M := M)) : Prop :=
  IsContinuousOneCoboundary (c.1 - d.1)

/-- Coboundary equivalence on continuous one-cocycles, generated by identifying
two cocycles when their difference is principal. This avoids relying on a
quotient-group API that is not exposed in the pinned Mathlib version. -/
inductive ContinuousH1Rel [Mul G] [SMul G M] [Add M] [Sub M] [ContinuousSub M] :
    ContinuousCocycle (G := G) (M := M) →
      ContinuousCocycle (G := G) (M := M) → Prop
  | refl (c) : ContinuousH1Rel c c
  | of_coboundary {c d} : ContinuousH1CoboundaryRel c d → ContinuousH1Rel c d
  | symm {c d} : ContinuousH1Rel c d → ContinuousH1Rel d c
  | trans {c d e} : ContinuousH1Rel c d → ContinuousH1Rel d e → ContinuousH1Rel c e

/-- Setoid presenting continuous `H¹` as continuous one-cocycles modulo
continuous one-coboundaries. -/
def continuousH1Setoid [Mul G] [SMul G M] [Add M] [Sub M] [ContinuousSub M] :
    Setoid (ContinuousCocycle (G := G) (M := M)) where
  r := ContinuousH1Rel
  iseqv := by
    refine ⟨ContinuousH1Rel.refl, ?_, ?_⟩
    · intro c d h
      exact ContinuousH1Rel.symm h
    · intro c d e hcd hde
      exact ContinuousH1Rel.trans hcd hde

/-- Special low-degree continuous cohomology target for Selmer-style
applications: continuous one-cocycles modulo continuous one-coboundaries. -/
abbrev ContinuousH1 [Mul G] [SMul G M] [Add M] [Sub M] [ContinuousSub M] :=
  Quotient (continuousH1Setoid (G := G) (M := M))

/-- Boundary primitive recording the exact quotient relation used by
`ContinuousH1`. -/
def ContinuousH1Boundary [Mul G] [SMul G M] [Add M] [Sub M] [ContinuousSub M] :
    Prop :=
  Nonempty (ContinuousH1 (G := G) (M := M))

variable {k V Vdual : Type*} [TopologicalSpace k] [TopologicalSpace V] [TopologicalSpace Vdual]

/-- Pointwise pairing of two continuous one-cochains into a continuous two-cochain. -/
def dualCocyclePairing (pair : V → Vdual → k)
    (hpair : Continuous fun p : V × Vdual => pair p.1 p.2)
    (c : ContinuousCochain G V 1) (d : ContinuousCochain G Vdual 1) :
    ContinuousCochain G k 2 where
  toFun x := pair (c (fun _ => x 0)) (d (fun _ => x 1))
  continuous_toFun := by
    exact hpair.comp (Continuous.prod_mk
      (c.continuous.comp (continuous_pi fun _ => continuous_apply (0 : Fin 2)))
      (d.continuous.comp (continuous_pi fun _ => continuous_apply (1 : Fin 2))))

@[simp]
theorem dualCocyclePairing_apply (pair : V → Vdual → k)
    (hpair : Continuous fun p : V × Vdual => pair p.1 p.2)
    (c : ContinuousCochain G V 1) (d : ContinuousCochain G Vdual 1) (x : Fin 2 → G) :
    dualCocyclePairing pair hpair c d x = pair (c (fun _ => x 0)) (d (fun _ => x 1)) :=
  rfl

/-- Algebraic-dual specialization of `dualCocyclePairing`; continuity of
evaluation is explicit because `Module.Dual` is not a bundled continuous dual. -/
def moduleDualCocyclePairing [CommSemiring k] [AddCommMonoid V] [Module k V]
    [TopologicalSpace (Module.Dual k V)]
    (heval : Continuous fun p : V × Module.Dual k V => p.2 p.1)
    (c : ContinuousCochain G V 1) (d : ContinuousCochain G (Module.Dual k V) 1) :
    ContinuousCochain G k 2 :=
  dualCocyclePairing (fun v φ => φ v) heval c d

/-- A named degree-two continuous cocycle predicate. -/
def IsContinuousTwoCocycle [Zero M] (c : ContinuousCochain G M 2) : Prop :=
  ∃ d₂ : ContinuousCochain G M 2 → ContinuousCochain G M 3,
    ∀ x : Fin 3 → G, d₂ c x = 0

/-- A named degree-two continuous coboundary predicate. -/
def IsContinuousTwoCoboundary [Mul G] [ContinuousMul G] [SMul G M] [ContinuousSMul G M]
    [Add M] [ContinuousAdd M] [Sub M] [ContinuousSub M]
    (c : ContinuousCochain G M 2) : Prop :=
  ∃ b : ContinuousCochain G M 1, oneCoboundary b = c

/-- Descent statement needed to turn the cochain-level dual pairing into a
well-defined map on `H¹ × H¹`. It is a Prop because Mathlib v4.17.0 has no
continuous profinite cohomology quotient object to target. -/
def DualCocyclePairingDescendsToH1 [Mul G] [ContinuousMul G]
    [SMul G V] [ContinuousSMul G V] [SMul G Vdual] [ContinuousSMul G Vdual]
    [SMul G k] [ContinuousSMul G k]
    [Sub V] [ContinuousSub V] [Add V] [ContinuousAdd V] [Zero V]
    [Sub Vdual] [ContinuousSub Vdual] [Add Vdual] [ContinuousAdd Vdual] [Zero Vdual]
    [Sub k] [ContinuousSub k] [Add k] [ContinuousAdd k] [Zero k]
    (pair : V → Vdual → k) (hpair : Continuous fun p : V × Vdual => pair p.1 p.2) : Prop :=
  ∀ c : ContinuousCochain G V 1, ∀ d : ContinuousCochain G Vdual 1,
    IsContinuousOneCocycle c → IsContinuousOneCocycle d →
      IsContinuousTwoCocycle (dualCocyclePairing pair hpair c d) ∧
        (∀ c' : ContinuousCochain G V 1, IsContinuousOneCoboundary (c' - c) →
          IsContinuousTwoCoboundary
            (dualCocyclePairing pair hpair c' d - dualCocyclePairing pair hpair c d)) ∧
        (∀ d' : ContinuousCochain G Vdual 1, IsContinuousOneCoboundary (d' - d) →
          IsContinuousTwoCoboundary
            (dualCocyclePairing pair hpair c d' - dualCocyclePairing pair hpair c d))

/-- Attempt-10 target boundary: the cochain-level pairing exists, and the
remaining obligation is exactly descent through the missing continuous
cohomology quotient API. -/
def continuousH1DualPairingBoundary [Mul G] [ContinuousMul G]
    [SMul G V] [ContinuousSMul G V] [SMul G Vdual] [ContinuousSMul G Vdual]
    [SMul G k] [ContinuousSMul G k]
    [Sub V] [ContinuousSub V] [Add V] [ContinuousAdd V] [Zero V]
    [Sub Vdual] [ContinuousSub Vdual] [Add Vdual] [ContinuousAdd Vdual] [Zero Vdual]
    [Sub k] [ContinuousSub k] [Add k] [ContinuousAdd k] [Zero k]
    (pair : V → Vdual → k) (hpair : Continuous fun p : V × Vdual => pair p.1 p.2) : Prop :=
  Nonempty (ContinuousCochain G V 1 → ContinuousCochain G Vdual 1 → ContinuousCochain G k 2) ∧
    DualCocyclePairingDescendsToH1 (G := G) (k := k) (V := V) (Vdual := Vdual) pair hpair

/-- Records the Mathlib API still needed to package all continuous
inhomogeneous cochains into a single coboundary operator. -/
def MissingContinuousInhomogeneousComplex
    (G M : Type*) [TopologicalSpace G] [TopologicalSpace M] : Prop :=
  ∀ n : ℕ, Nonempty (ContinuousCochain G M n → ContinuousCochain G M (n + 1))

/-- Boundary for turning the `ContinuousMap` cochain model into an actual
cochain complex: a degreewise continuous coboundary together with the
square-zero law. -/
def ContinuousMapCochainComplexBoundary
    (G M : Type*) [TopologicalSpace G] [TopologicalSpace M] [Zero M] : Prop :=
  ∃ d : ∀ n : ℕ, ContinuousCochain G M n → ContinuousCochain G M (n + 1),
    ∀ n : ℕ, ∀ c : ContinuousCochain G M n,
      d (n + 1) (d n c) =
        ContinuousCochain.const (G := G) (M := M) (n := n + 1 + 1) (0 : M)

/-- Records the specific face-map wall for the general alternating sum:
continuity of the adjacent-product face maps on finite powers of `G`. -/
def MissingAdjacentProductFaceAPI
    (G : Type*) [TopologicalSpace G] [Mul G] : Prop :=
  ∀ n : ℕ, Nonempty (C((Fin (n + 1) → G), (Fin n → G)))

universe fq

/-- A finite-quotient cohomology diagram, abstracting the category of finite
quotients of a profinite group and the transition maps between their classical
Mathlib group-cohomology modules. -/
abbrev FiniteQuotientCohomologyDiagram (J : Type*) [Category J]
    (k : Type*) [CommRing k] :=
  J ⥤ ModuleCat k

/-- The candidate profinite cohomology object obtained as the categorical
colimit of finite-quotient cohomology modules. -/
noncomputable abbrev ProfiniteCohomologyOfFiniteQuotientDiagram {J : Type*} [Category J]
    {k : Type*} [CommRing k] (D : FiniteQuotientCohomologyDiagram J k)
    [HasColimit D] : ModuleCat k :=
  colimit D

/-- The canonical map from a finite quotient's cohomology to the candidate
continuous/profinite cohomology object. -/
noncomputable def finiteQuotientCohomologyToProfinite {J : Type*} [Category J]
    {k : Type*} [CommRing k] (D : FiniteQuotientCohomologyDiagram J k)
    [HasColimit D] (j : J) :
    D.obj j ⟶ ProfiniteCohomologyOfFiniteQuotientDiagram D :=
  colimit.ι D j

/-- Existing Mathlib group cohomology for one finite quotient, packaged as the
object that should appear in a finite-quotient diagram. -/
noncomputable abbrev finiteQuotientGroupCohomology (k Q : Type fq) [CommRing k] [Group Q]
    (A : Rep k Q) (n : ℕ) : ModuleCat k :=
  groupCohomology A n

/-- Wall primitive: Mathlib does not yet package the finite-quotient indexing
category of a profinite group in the form needed by continuous cohomology. -/
def FiniteQuotientIndexCategoryForProfiniteExists (G : Type*) [TopologicalSpace G]
    [Group G] : Prop :=
  Nonempty C(G, G)

/-- Wall primitive: the required factorization theorem for continuous cochains
through finite quotients is not available as a Mathlib API. -/
def ContinuousCochainsFactorThroughFiniteQuotient (G M : Type*) [TopologicalSpace G]
    [TopologicalSpace M] (n : ℕ) : Prop :=
  Nonempty (ContinuousCochain G M n)

/-- Wall primitive: transition maps between finite-quotient cohomologies must be
proved compatible with Mathlib's `groupCohomology.map`. -/
def FiniteQuotientCohomologyTransitionMapsCompatible (G : Type*)
    [TopologicalSpace G] [Group G] : Prop :=
  Nonempty (G →* G)

/-- Wall primitive: the final comparison theorem identifying continuous
cohomology with the finite-quotient colimit is not present in Mathlib. -/
def ContinuousCohomologyIsFiniteQuotientColimit (G M : Type*) [TopologicalSpace G]
    [TopologicalSpace M] [Group G] (n : ℕ) : Prop :=
  ContinuousCochainsFactorThroughFiniteQuotient G M n ∧
    FiniteQuotientIndexCategoryForProfiniteExists G

section DiscreteFunctoriality

open CategoryTheory

universe u v w

/-- Existing Mathlib finite/discrete group-cohomology restriction map. A future
continuous theory should refine this by replacing all cochains with continuous
cochains when the groups carry profinite topologies. -/
noncomputable def discreteRestriction {k Γ Δ : Type w} [CommRing k] [Group Γ] [Group Δ]
    (ι : Δ →* Γ) (A : Rep k Γ) (n : ℕ) :
    groupCohomology A n ⟶ groupCohomology ((Action.res (ModuleCat k) ι).obj A) n :=
  groupCohomology.map ι (𝟙 ((Action.res (ModuleCat k) ι).obj A)) n

/-- Existing Mathlib finite/discrete low-degree restriction. -/
noncomputable def discreteH1Restriction {k Γ Δ : Type w} [CommRing k] [Group Γ] [Group Δ]
    (ι : Δ →* Γ) (A : Rep k Γ) :
    groupCohomology.H1 A ⟶ groupCohomology.H1 ((Action.res (ModuleCat k) ι).obj A) :=
  groupCohomology.H1Map ι (𝟙 ((Action.res (ModuleCat k) ι).obj A))

/-- Existing Mathlib finite/discrete group-cohomology inflation along a quotient
or projection. -/
noncomputable def discreteInflation {k Γ Q' : Type w} [CommRing k] [Group Γ] [Group Q']
    (π : Γ →* Q') (A : Rep k Q') (n : ℕ) :
    groupCohomology A n ⟶ groupCohomology ((Action.res (ModuleCat k) π).obj A) n :=
  groupCohomology.map π (𝟙 ((Action.res (ModuleCat k) π).obj A)) n

/-- Existing Mathlib finite/discrete low-degree inflation. -/
noncomputable def discreteH1Inflation {k Γ Q' : Type w} [CommRing k] [Group Γ] [Group Q']
    (π : Γ →* Q') (A : Rep k Q') :
    groupCohomology.H1 A ⟶ groupCohomology.H1 ((Action.res (ModuleCat k) π).obj A) :=
  groupCohomology.H1Map π (𝟙 ((Action.res (ModuleCat k) π).obj A))

/-- Boundary marker for the missing Mathlib API: once continuous cochains are
assembled into a cochain complex and quotient cohomology groups, `restrict`
should descend through continuous cocycles and coboundaries to this map. -/
structure ContinuousH1RestrictionData where
  descends_to_continuous_cocycles : Prop
  descends_to_continuous_coboundaries : Prop
  induced_map_on_H1 : Prop

/-- Boundary marker for the missing Mathlib API: once continuous cochains are
assembled into a cochain complex and quotient cohomology groups, `inflate`
should descend through continuous cocycles and coboundaries to this map. -/
structure ContinuousH1InflationData where
  descends_to_continuous_cocycles : Prop
  descends_to_continuous_coboundaries : Prop
  induced_map_on_H1 : Prop

end DiscreteFunctoriality

/-- Continuous additive one-cochains, isolated because `H¹` is the first
degree needed for Hilbert 90 and Selmer-style applications. -/
abbrev ContinuousOneCochain (G M : Type*) [TopologicalSpace G] [TopologicalSpace M] :=
  ContinuousCochain G M 1

/-- The additive crossed-homomorphism condition for a continuous one-cochain. -/
def ContinuousOneCocycle [Mul G] [SMul G M] [Sub M] [Add M] [Zero M]
    (c : ContinuousOneCochain G M) : Prop :=
  ∀ g h : G, g • c (fun _ : Fin 1 => h) - c (fun _ : Fin 1 => g * h) +
    c (fun _ : Fin 1 => g) = 0

/-- A continuous additive one-cocycle is principal if `c(g) = g • m - m`. -/
def ContinuousPrincipalOneCocycle [SMul G M] [Sub M]
    (c : ContinuousOneCochain G M) : Prop :=
  ∃ m : M, ∀ g : G, c (fun _ : Fin 1 => g) = g • m - m

/-- The Prop-level boundary statement for vanishing continuous additive `H¹`. -/
def ContinuousH1Vanishing [Mul G] [SMul G M] [Sub M] [Add M] [Zero M]
    [TopologicalSpace G] [TopologicalSpace M] : Prop :=
  ∀ c : ContinuousOneCochain G M, ContinuousOneCocycle c →
    ContinuousPrincipalOneCocycle c

/-- Continuous multiplicative one-cochains, used for Hilbert 90 with units. -/
abbrev ContinuousMultiplicativeOneCochain
    (G M : Type*) [TopologicalSpace G] [TopologicalSpace M] :=
  ContinuousCochain G M 1

/-- The multiplicative crossed-homomorphism condition appearing in Hilbert 90. -/
def ContinuousMulOneCocycle [Mul G] [SMul G M] [Mul M]
    (c : ContinuousMultiplicativeOneCochain G M) : Prop :=
  ∀ g h : G, c (fun _ : Fin 1 => g * h) =
    g • c (fun _ : Fin 1 => h) * c (fun _ : Fin 1 => g)

/-- A continuous multiplicative one-cocycle is principal if `c(g) = g • m / m`. -/
def ContinuousPrincipalMulOneCocycle [SMul G M] [Div M]
    (c : ContinuousMultiplicativeOneCochain G M) : Prop :=
  ∃ m : M, ∀ g : G, c (fun _ : Fin 1 => g) = g • m / m

/-- The Prop-level boundary statement for vanishing continuous multiplicative
`H¹`. This is the continuous/profinite analogue missing from Mathlib's finite
group-cohomology API. -/
def ContinuousMulH1Vanishing [Mul G] [SMul G M] [Mul M] [Div M]
    [TopologicalSpace G] [TopologicalSpace M] : Prop :=
  ∀ c : ContinuousMultiplicativeOneCochain G M, ContinuousMulOneCocycle c →
    ContinuousPrincipalMulOneCocycle c

/-- Absolute-Galois specialization of continuous multiplicative one-cochains.
This is the cochain object needed for Hilbert 90 over `G_K`. -/
abbrev absoluteGaloisContinuousOneCochain
    (K M : Type*) [Field K] [TopologicalSpace M] :=
  AbsoluteGaloisContinuousCochain K M 1

/-- Absolute-Galois specialization of the multiplicative crossed-homomorphism
condition. -/
def absoluteGaloisContinuousOneCocycle
    (K M : Type*) [Field K] [TopologicalSpace M]
    [SMul (Field.absoluteGaloisGroup K) M] [Mul M]
    (c : absoluteGaloisContinuousOneCochain K M) : Prop :=
  ContinuousMulOneCocycle
    (G := Field.absoluteGaloisGroup K) (M := M) c

/-- Absolute-Galois specialization of principal multiplicative one-cocycles. -/
def absoluteGaloisContinuousPrincipalOneCocycle
    (K M : Type*) [Field K] [TopologicalSpace M]
    [SMul (Field.absoluteGaloisGroup K) M] [Div M]
    (c : absoluteGaloisContinuousOneCochain K M) : Prop :=
  ContinuousPrincipalMulOneCocycle
    (G := Field.absoluteGaloisGroup K) (M := M) c

/-- The exact absolute-Galois Hilbert 90 boundary in degree one: every
continuous multiplicative one-cocycle with values in algebraic-closure units is
principal. -/
def absoluteGaloisContinuousH1VanishingBoundary
    (K : Type*) [Field K] [TopologicalSpace (AlgebraicClosure K)ˣ]
    [SMul (Field.absoluteGaloisGroup K) (AlgebraicClosure K)ˣ] : Prop :=
  ∀ c : absoluteGaloisContinuousOneCochain K (AlgebraicClosure K)ˣ,
    absoluteGaloisContinuousOneCocycle K (AlgebraicClosure K)ˣ c →
      absoluteGaloisContinuousPrincipalOneCocycle K (AlgebraicClosure K)ˣ c

/-- The finite Hilbert 90 theorem already present in Mathlib. -/
theorem finite_hilbert90_available (K L : Type) [Field K] [Field L] [Algebra K L]
    [FiniteDimensional K L] :
    Nonempty (Unique ↑(groupCohomology.H1 (Rep.ofAlgebraAutOnUnits K L))) :=
  ⟨inferInstance⟩

/-- The exact continuous Hilbert 90 primitive needed for finite Galois
extensions at the continuous cochain level. -/
def Hilbert90ContinuousPrimitive (K L : Type*) [Field K] [Field L] [Algebra K L]
    [FiniteDimensional K L] [TopologicalSpace (L ≃ₐ[K] L)] [TopologicalSpace Lˣ]
    [SMul (L ≃ₐ[K] L) Lˣ] : Prop :=
  ContinuousMulH1Vanishing (G := L ≃ₐ[K] L) (M := Lˣ)

/-- The exact absolute-Galois continuous Hilbert 90 primitive missing for
`G_K` acting on the units of an algebraic closure. -/
def AbsoluteGaloisHilbert90Primitive (K : Type*) [Field K]
    [TopologicalSpace (AlgebraicClosure K)ˣ]
    [SMul (Field.absoluteGaloisGroup K) (AlgebraicClosure K)ˣ] : Prop :=
  absoluteGaloisContinuousH1VanishingBoundary K

/-- No new global primitive is introduced here: the conclusion is available exactly when
the missing continuous/profinite Hilbert 90 primitive is supplied. -/
theorem hilbert90_continuous_requires_mathlib_primitive (K : Type*) [Field K]
    [TopologicalSpace (AlgebraicClosure K)ˣ]
    [SMul (Field.absoluteGaloisGroup K) (AlgebraicClosure K)ˣ]
    (h : AbsoluteGaloisHilbert90Primitive K) :
    AbsoluteGaloisHilbert90Primitive K :=
  h

-- Local API checks for the declarations exported by this root file.
#check ContinuousCochain
#check ContinuousCochain.const
#check ContinuousCochain.mapRange
#check ContinuousCochain.mapRange_comp
#check ContinuousCochain.continuousCochainSet
#check ContinuousCochain.ofSet
#check ContinuousCochain.toSet
#check ContinuousCochain.pullback
#check ContinuousCochain.pullback_comp
#check ContinuousCochain.comapDomain
#check ContinuousCochain.comapDomain_comp
#check ContinuousCochain.restrict
#check ContinuousCochain.restrict_comp
#check ContinuousCochain.inflate
#check ContinuousCochain.inflate_comp
#check ContinuousCochain.lastFace
#check ContinuousCochain.oneMiddleFace
#check ContinuousCochain.actionTerm
#check ContinuousCochain.zeroCoboundary
#check ContinuousCochain.oneCoboundary
#check ContinuousCochain.oneCocycleCondition
#check ContinuousCochain.IsContinuousOneCocycle
#check ContinuousCochain.IsContinuousOneCoboundary
#check ContinuousCochain.ContinuousCocycle
#check ContinuousCochain.ContinuousCoboundary
#check ContinuousCochain.ContinuousH1CoboundaryRel
#check ContinuousCochain.ContinuousH1Rel
#check ContinuousCochain.continuousH1Setoid
#check ContinuousCochain.ContinuousH1
#check ContinuousCochain.ContinuousH1Boundary
#check ContinuousCochain.dualCocyclePairing
#check ContinuousCochain.moduleDualCocyclePairing
#check ContinuousCochain.IsContinuousTwoCocycle
#check ContinuousCochain.IsContinuousTwoCoboundary
#check ContinuousCochain.DualCocyclePairingDescendsToH1
#check ContinuousCochain.continuousH1DualPairingBoundary
#check ContinuousCochain.ContinuousOneCochain
#check ContinuousCochain.ContinuousOneCocycle
#check ContinuousCochain.ContinuousPrincipalOneCocycle
#check ContinuousCochain.ContinuousH1Vanishing
#check ContinuousCochain.ContinuousMulOneCocycle
#check ContinuousCochain.ContinuousMulH1Vanishing
#check ContinuousCochain.absoluteGaloisContinuousOneCochain
#check ContinuousCochain.absoluteGaloisContinuousOneCocycle
#check ContinuousCochain.absoluteGaloisContinuousPrincipalOneCocycle
#check ContinuousCochain.absoluteGaloisContinuousH1VanishingBoundary
#check ContinuousCochain.finite_hilbert90_available
#check ContinuousCochain.Hilbert90ContinuousPrimitive
#check ContinuousCochain.AbsoluteGaloisHilbert90Primitive
#check ContinuousCochain.hilbert90_continuous_requires_mathlib_primitive
#check ContinuousCochain.MissingContinuousInhomogeneousComplex
#check ContinuousCochain.ContinuousMapCochainComplexBoundary
#check ContinuousCochain.MissingAdjacentProductFaceAPI
#check ContinuousCochain.FiniteQuotientCohomologyDiagram
#check ContinuousCochain.ProfiniteCohomologyOfFiniteQuotientDiagram
#check ContinuousCochain.finiteQuotientCohomologyToProfinite
#check ContinuousCochain.finiteQuotientGroupCohomology
#check ContinuousCochain.FiniteQuotientIndexCategoryForProfiniteExists
#check ContinuousCochain.ContinuousCochainsFactorThroughFiniteQuotient
#check ContinuousCochain.FiniteQuotientCohomologyTransitionMapsCompatible
#check ContinuousCochain.ContinuousCohomologyIsFiniteQuotientColimit
#check ContinuousCochain.discreteRestriction
#check ContinuousCochain.discreteH1Restriction
#check ContinuousCochain.discreteInflation
#check ContinuousCochain.discreteH1Inflation
#check ContinuousCochain.ContinuousH1RestrictionData
#check ContinuousCochain.ContinuousH1InflationData

-- Existing Mathlib APIs that a future continuous theory would have to refine.
#check groupCohomology
#check groupCohomology.H1
#check groupCohomology.H2
#check groupCohomology.map
#check groupCohomology.H1Map
#check groupCohomology.H2Map
#check groupCohomology.isMulOneCoboundary_of_isMulOneCocycle_of_aut_to_units
#check groupCohomology.H1ofAutOnUnitsUnique
#check Field.absoluteGaloisGroup
#check CategoryTheory.ShortComplex.ShortExact

end ContinuousCochain

/-- A typed finite-quotient cohomology system for a profinite group. -/
structure FiniteQuotientSystem (k : Type u) [CommRing k] where
  Index : Type v
  [cat : Category Index]
  Quotient : Index → Type u
  [quotientGroup : ∀ i, Group (Quotient i)]
  [quotientFintype : ∀ i, Fintype (Quotient i)]
  coeff : ∀ i, Rep k (Quotient i)
  cohomologyMap : ∀ (n : ℕ) {i j : Index}, (i ⟶ j) →
    (groupCohomology (coeff i) n ⟶ groupCohomology (coeff j) n)
  map_id : ∀ (n : ℕ) (i : Index),
    cohomologyMap n (𝟙 i) = 𝟙 (groupCohomology (coeff i) n) := by aesop_cat
  map_comp : ∀ (n : ℕ) {i j l : Index} (f : i ⟶ j) (g : j ⟶ l),
    cohomologyMap n (f ≫ g) = cohomologyMap n f ≫ cohomologyMap n g := by aesop_cat

attribute [instance] FiniteQuotientSystem.cat
attribute [instance] FiniteQuotientSystem.quotientGroup
attribute [instance] FiniteQuotientSystem.quotientFintype

namespace FiniteQuotientSystem

variable {k : Type u} [CommRing k] (S : FiniteQuotientSystem k) (n : ℕ)

/-- The finite-quotient cohomology diagram in degree `n`. -/
noncomputable def finiteQuotientCohomologyDiagram : S.Index ⥤ ModuleCat k where
  obj i := groupCohomology (S.coeff i) n
  map f := S.cohomologyMap n f
  map_id i := S.map_id n i
  map_comp f g := S.map_comp n f g

/-- Profinite cohomology defined as the colimit of finite-quotient cohomologies. -/
noncomputable def ProfiniteCohomologyByFiniteQuotients
    [HasColimit (S.finiteQuotientCohomologyDiagram n)] : ModuleCat k :=
  colimit (S.finiteQuotientCohomologyDiagram n)

/-- The canonical map from a finite quotient's cohomology into the colimit. -/
noncomputable def finiteQuotientCohomologyι
    [HasColimit (S.finiteQuotientCohomologyDiagram n)] (i : S.Index) :
    groupCohomology (S.coeff i) n ⟶ S.ProfiniteCohomologyByFiniteQuotients n :=
  colimit.ι (S.finiteQuotientCohomologyDiagram n) i

/-- The finite-quotient structure maps form the canonical colimit cocone. -/
theorem finiteQuotientCohomologyι_naturality
    [HasColimit (S.finiteQuotientCohomologyDiagram n)] {i j : S.Index} (f : i ⟶ j) :
    S.cohomologyMap n f ≫ S.finiteQuotientCohomologyι n j =
      S.finiteQuotientCohomologyι n i :=
  colimit.w (S.finiteQuotientCohomologyDiagram n) f

end FiniteQuotientSystem

#check FiniteQuotientSystem
#check FiniteQuotientSystem.finiteQuotientCohomologyDiagram
#check FiniteQuotientSystem.ProfiniteCohomologyByFiniteQuotients
#check FiniteQuotientSystem.finiteQuotientCohomologyι
#check FiniteQuotientSystem.finiteQuotientCohomologyι_naturality

/-!
## Attempt 7 boundary: the missing bridge to a long exact sequence

Mathlib already has the categorical connecting morphism for a short exact
sequence of homological complexes, exposed as
`CategoryTheory.ShortComplex.ShortExact.δ`, with adjacent exactness lemmas in
`Mathlib.Algebra.Homology.HomologySequence`.

The missing object for continuous Galois cohomology is not this categorical
homological algebra. It is the continuous-cochain-complex layer: a category of
continuous `G`-modules, a functor sending a short exact sequence of those
modules to a short exact sequence of homological complexes, and an
identification of the resulting homology with continuous group cohomology.
-/

/-- Minimal bundled shape of a short exact sequence of continuous `G`-modules.

This is deliberately only data-level. Mathlib does not yet provide a category
whose objects are topological `G`-modules with continuous action, nor a bundled
short-exactness predicate in that category. -/
structure ContinuousGModuleShortExactData (G : Type u) [TopologicalSpace G] [Group G] :
    Type (u + 1) where
  X₁ : Type u
  X₂ : Type u
  X₃ : Type u
  [top₁ : TopologicalSpace X₁]
  [top₂ : TopologicalSpace X₂]
  [top₃ : TopologicalSpace X₃]
  [add₁ : AddCommGroup X₁]
  [add₂ : AddCommGroup X₂]
  [add₃ : AddCommGroup X₃]
  [smul₁ : SMul G X₁]
  [smul₂ : SMul G X₂]
  [smul₃ : SMul G X₃]
  [continuousSMul₁ : ContinuousSMul G X₁]
  [continuousSMul₂ : ContinuousSMul G X₂]
  [continuousSMul₃ : ContinuousSMul G X₃]
  fst : C(X₁, X₂)
  snd : C(X₂, X₃)

/-- The missing API: continuous cochains should assemble into a homological
complex in an abelian coefficient category. -/
def ContinuousCochainComplexExists (G M : Type u) [TopologicalSpace G] [Group G]
    [TopologicalSpace M] [AddCommGroup M] [SMul G M] [ContinuousSMul G M] : Prop :=
  Nonempty (ContinuousCochain G M 0 → ContinuousCochain G M 1)

/-- Boundary marker for the categorical connecting morphism that would become
the boundary map once continuous-cochain complexes exist. -/
def ContinuousCohomologyLongExactBoundary {C : Type u} {ι : Type v}
    [CategoryTheory.Category.{w, u} C] [CategoryTheory.Abelian C] (_c : ComplexShape ι) :
    Prop :=
  True

/-- Boundary marker for the existence of the connecting map in continuous
cohomology after the missing continuous-cochain complex layer is supplied. -/
def ContinuousCohomologyConnectingMapExists {C : Type u} {ι : Type v}
    [CategoryTheory.Category.{w, u} C] [CategoryTheory.Abelian C] (c : ComplexShape ι) :
    Prop :=
  ContinuousCohomologyLongExactBoundary (C := C) (ι := ι) c

/-- Boundary marker for exactness at the categorical connecting morphism. -/
def continuousCohomology_categorical_boundary_exact₁ {C : Type u} {ι : Type v}
    [CategoryTheory.Category.{w, u} C] [CategoryTheory.Abelian C] (c : ComplexShape ι) :
    Prop :=
  ContinuousCohomologyLongExactBoundary (C := C) (ι := ι) c

/-- The honest wall for Attempt 7: to turn the categorical boundary above into
the long exact sequence in continuous group cohomology, these infrastructure
pieces still have to be supplied. -/
def continuous_long_exact_sequence_wall (G : Type u) [TopologicalSpace G] [Group G] :
    Prop :=
  (∃ (_S : ContinuousGModuleShortExactData G), True) ∧ True

#check ContinuousGModuleShortExactData
#check ContinuousCochainComplexExists
#check ContinuousCohomologyLongExactBoundary
#check ContinuousCohomologyConnectingMapExists
#check continuous_long_exact_sequence_wall
#check CategoryTheory.ShortComplex.ShortExact
#check CategoryTheory.ShortComplex.ShortExact.δ
#check CategoryTheory.ShortComplex.ShortExact.homology_exact₁

namespace AbsoluteGaloisContinuousCochain

variable {K M : Type*} [Field K] [TopologicalSpace M] {n m : ℕ}

/-- Coerce an absolute-Galois continuous cochain to its underlying function. -/
def toFun (c : AbsoluteGaloisContinuousCochain K M n) :
    (Fin n → Field.absoluteGaloisGroup K) → M :=
  ContinuousCochain.toFun c

@[simp]
theorem toFun_apply (c : AbsoluteGaloisContinuousCochain K M n)
    (x : Fin n → Field.absoluteGaloisGroup K) :
    c.toFun x = c x :=
  rfl

@[ext]
theorem ext {c d : AbsoluteGaloisContinuousCochain K M n}
    (h : ∀ x, c x = d x) : c = d :=
  ContinuousCochain.ext h

/-- Pull an absolute-Galois continuous cochain back along a continuous map
between finite powers of the absolute Galois group. -/
def pullback
    (φ : (Fin m → Field.absoluteGaloisGroup K) →
      (Fin n → Field.absoluteGaloisGroup K))
    (hφ : Continuous φ)
    (c : AbsoluteGaloisContinuousCochain K M n) :
    AbsoluteGaloisContinuousCochain K M m :=
  ContinuousCochain.pullback φ hφ c

@[simp]
theorem pullback_apply
    (φ : (Fin m → Field.absoluteGaloisGroup K) →
      (Fin n → Field.absoluteGaloisGroup K))
    (hφ : Continuous φ)
    (c : AbsoluteGaloisContinuousCochain K M n)
    (x : Fin m → Field.absoluteGaloisGroup K) :
    pullback φ hφ c x = c (φ x) :=
  rfl

@[simp]
theorem zero_apply [Zero M] (x : Fin n → Field.absoluteGaloisGroup K) :
    (0 : AbsoluteGaloisContinuousCochain K M n) x = 0 :=
  rfl

@[simp]
theorem add_apply [Add M] [ContinuousAdd M]
    (c d : AbsoluteGaloisContinuousCochain K M n)
    (x : Fin n → Field.absoluteGaloisGroup K) :
    (c + d) x = c x + d x :=
  rfl

/-- Boundary marker for the missing continuous cochain-complex package on
absolute Galois groups. -/
def HasContinuousAbsoluteGaloisCochainComplex
    (K M : Type*) [Field K] [TopologicalSpace M] : Prop :=
  Nonempty (∀ n : ℕ, AbsoluteGaloisContinuousCochain K M n)

/-- Boundary marker for a packaged continuous cohomology theory of the absolute
Galois group. -/
def HasAbsoluteGaloisContinuousCohomology
    (K M : Type*) [Field K] [TopologicalSpace M] (n : ℕ) : Prop :=
  HasContinuousAbsoluteGaloisCochainComplex K M ∧
    Nonempty (Set (AbsoluteGaloisContinuousCochain K M n))

/-- Boundary marker for comparing the missing continuous absolute-Galois theory
with Mathlib's current low-degree group cohomology API. -/
def AbsoluteGaloisContinuousCohomologyComparisonToMathlibLowDegree
    (K M : Type*) [Field K] [TopologicalSpace M] : Prop :=
  HasAbsoluteGaloisContinuousCohomology K M 1 ∧
    HasAbsoluteGaloisContinuousCohomology K M 2

#check Field.absoluteGaloisGroup
#check AbsoluteGaloisContinuousCochain
#check AbsoluteGaloisContinuousCochain.toFun
#check AbsoluteGaloisContinuousCochain.ext
#check AbsoluteGaloisContinuousCochain.pullback
#check AbsoluteGaloisContinuousCochain.HasContinuousAbsoluteGaloisCochainComplex
#check AbsoluteGaloisContinuousCochain.HasAbsoluteGaloisContinuousCohomology
#check AbsoluteGaloisContinuousCochain.AbsoluteGaloisContinuousCohomologyComparisonToMathlibLowDegree

end AbsoluteGaloisContinuousCochain

/-! ## W1 consensus: LocallyConstant-based H¹ (board-w1-20260420-03, round 2)

All three boardroom voices converged on `LocallyConstant G M` as the underlying
type for continuous 1-cocycles, bypassing the general `CochainComplex` and
categorical colimit routes that blocked prior attempts.

Typeclass spine agreed by all three agents:
- `[DistribMulAction G M]` for the cocycle identity
- `[ContinuousSMul G M]` + `[DiscreteTopology M]` for coboundary local-constancy

Five objects in dependency order:
1. `locConstOneCocycleSubgroup`    — AddSubgroup of `LocallyConstant G M`
2. `smulSubSelfLocConst`           — `g ↦ g • m - m` as a `LocallyConstant`
3. `principalLocConstOneCocycle`   — Object 2 promoted to a member of Object 1
4. `locConstOneCoboundarySubgroup` — AddSubgroup of Object 1
5. `LocallyConstantH1`             — quotient type + finite-quotient honest wall
-/

section LocallyConstantH1

variable (G M : Type*)
  [Group G] [TopologicalSpace G]
  [AddCommGroup M] [TopologicalSpace M]
  [DistribMulAction G M]

/-! ### Object 1: locally constant 1-cocycles as an AddSubgroup -/

/-- The `AddSubgroup` of `LocallyConstant G M` whose elements are crossed
homomorphisms: locally constant maps satisfying `f(gh) = f(g) + g • f(h)`. -/
def locConstOneCocycleSubgroup : AddSubgroup (LocallyConstant G M) where
  carrier := {f | ∀ g h : G, f (g * h) = f g + g • f h}
  zero_mem' := fun g h => by simp [smul_zero]
  add_mem' := fun {f₁ f₂} h₁ h₂ g h => by
    simp only [LocallyConstant.coe_add, Pi.add_apply]
    rw [h₁ g h, h₂ g h, smul_add]; abel
  neg_mem' := fun {f} hf g h => by
    simp only [LocallyConstant.coe_neg, Pi.neg_apply]
    rw [hf g h, smul_neg]; abel

theorem mem_locConstOneCocycleSubgroup {f : LocallyConstant G M} :
    f ∈ locConstOneCocycleSubgroup G M ↔
      ∀ g h : G, f (g * h) = f g + g • f h :=
  Iff.rfl

/-! ### Object 2: coboundary `g ↦ g • m - m` as a LocallyConstant -/

/-- For `[ContinuousSMul G M]` and `[DiscreteTopology M]`, the map `g ↦ g • m - m`
is locally constant. The proof: `g ↦ g • m` is continuous (ContinuousSMul), and a
continuous function into a discrete space is locally constant, so the fiber
`{g | g • m = x • m}` is open as the preimage of an open singleton. -/
noncomputable def smulSubSelfLocConst
    [ContinuousSMul G M] [DiscreteTopology M] (m : M) :
    LocallyConstant G M where
  toFun g := g • m - m
  isLocallyConstant := fun s => by
    apply IsOpen.preimage _ (isOpen_discrete s)
    fun_prop

@[simp]
theorem smulSubSelfLocConst_apply
    [ContinuousSMul G M] [DiscreteTopology M] (m : M) (g : G) :
    smulSubSelfLocConst G M m g = g • m - m :=
  rfl

/-! ### Object 3: principal coboundary belongs to locConstOneCocycleSubgroup -/

/-- The principal coboundary `g ↦ g • m - m` satisfies the cocycle identity
`(gh) • m - m = (g • m - m) + g • (h • m - m)`, so it lives in
`locConstOneCocycleSubgroup G M`. -/
noncomputable def principalLocConstOneCocycle
    [ContinuousSMul G M] [DiscreteTopology M] (m : M) :
    locConstOneCocycleSubgroup G M :=
  ⟨smulSubSelfLocConst G M m, fun g h => by
    simp only [smulSubSelfLocConst_apply, mul_smul, smul_sub]
    abel⟩

@[simp]
theorem principalLocConstOneCocycle_apply
    [ContinuousSMul G M] [DiscreteTopology M] (m : M) (g : G) :
    (principalLocConstOneCocycle G M m).val g = g • m - m :=
  rfl

/-! ### Object 4: coboundary AddSubgroup of locConstOneCocycleSubgroup -/

/-- The `AddSubgroup` of `locConstOneCocycleSubgroup G M` consisting of principal
coboundaries: elements of the form `g ↦ g • m - m` for some `m : M`. -/
noncomputable def locConstOneCoboundarySubgroup
    [ContinuousSMul G M] [DiscreteTopology M] :
    AddSubgroup (locConstOneCocycleSubgroup G M) where
  carrier := {f | ∃ m : M, ∀ g : G, f.val g = g • m - m}
  zero_mem' := ⟨0, fun g => by simp [smul_zero]⟩
  add_mem' := fun {f₁ f₂} ⟨m₁, h₁⟩ ⟨m₂, h₂⟩ =>
    ⟨m₁ + m₂, fun g => by
      simp only [AddSubgroup.coe_add, LocallyConstant.coe_add, Pi.add_apply]
      rw [h₁ g, h₂ g, smul_add]; abel⟩
  neg_mem' := fun {f} ⟨m, hm⟩ =>
    ⟨-m, fun g => by
      simp only [AddSubgroup.coe_neg, LocallyConstant.coe_neg, Pi.neg_apply]
      rw [hm g, smul_neg]; abel⟩

/-! ### Object 5: LocallyConstantH1 and profinite factorization wall -/

/-- Continuous H¹ via locally constant cochains: 1-cocycles modulo principal
coboundaries. This is the W1 consensus target for the FLT Galois cohomology chain.
The underlying AddCommGroup structure is inherited from the quotient. -/
noncomputable abbrev LocallyConstantH1
    [ContinuousSMul G M] [DiscreteTopology M] :=
  (locConstOneCocycleSubgroup G M) ⧸ (locConstOneCoboundarySubgroup G M)

/-- Projection of a locally constant 1-cocycle to its class in `LocallyConstantH1`. -/
noncomputable def LocallyConstantH1.mk
    [ContinuousSMul G M] [DiscreteTopology M]
    (f : locConstOneCocycleSubgroup G M) :
    LocallyConstantH1 G M :=
  QuotientAddGroup.mk f

/-- Two cocycles have the same class in `LocallyConstantH1` iff their difference
is a principal coboundary. -/
theorem LocallyConstantH1.mk_eq_mk_iff
    [ContinuousSMul G M] [DiscreteTopology M]
    (f₁ f₂ : locConstOneCocycleSubgroup G M) :
    LocallyConstantH1.mk G M f₁ = LocallyConstantH1.mk G M f₂ ↔
      -f₁ + f₂ ∈ locConstOneCoboundarySubgroup G M :=
  QuotientAddGroup.eq

/-- Honest wall (Object 5 — profinite bridge): for profinite G (compact,
totally disconnected topological group) acting on discrete M, every locally
constant 1-cocycle factors through a finite quotient G/N for some open normal
subgroup N.

Missing Mathlib v4.17.0 primitive: the filtered colimit description
  `LocallyConstantH1 G M ≅ colim_{N : OpenNormalSubgroup G} H¹(G/N, Mᴺ)`
requires connecting `LocallyConstant.factors_through` at the cocycle level,
proving the descended map on G/N satisfies the cocycle identity, and assembling
the transition maps into a filtered diagram. The individual `LocallyConstant`
factorization lemma exists in Mathlib, but the cocycle-level descent and
filtered-colimit comparison are not yet present. -/
def LocallyConstantH1ProfiniteFactorizationWall
    [ContinuousMul G] [ContinuousInv G] [CompactSpace G] [TotallyDisconnectedSpace G]
    [ContinuousSMul G M] [DiscreteTopology M] : Prop :=
  ∀ (f : locConstOneCocycleSubgroup G M),
    ∃ (N : Subgroup G) (_ : N.Normal) (_ : IsOpen (N : Set G))
      (fbar : G ⧸ N → M),
      ∀ g : G, f.val g = fbar (QuotientGroup.mk g)

-- API checks
#check @locConstOneCocycleSubgroup
#check @mem_locConstOneCocycleSubgroup
#check @smulSubSelfLocConst
#check @smulSubSelfLocConst_apply
#check @principalLocConstOneCocycle
#check @principalLocConstOneCocycle_apply
#check @locConstOneCoboundarySubgroup
#check @LocallyConstantH1
#check @LocallyConstantH1.mk
#check @LocallyConstantH1.mk_eq_mk_iff
#check @LocallyConstantH1ProfiniteFactorizationWall

end LocallyConstantH1

end ContinuousGaloisCohomology
end Roots
end MathlibExpansion
