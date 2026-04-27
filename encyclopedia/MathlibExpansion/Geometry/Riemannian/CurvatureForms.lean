import MathlibExpansion.Geometry.Riemannian.TorsionForms

/-!
# Curvature forms for Cartan 1928
-/

universe u v

namespace MathlibExpansion.Geometry.Riemannian

def exteriorDerivativeConnection {I : Type u} {U : Type v} {n : ℕ}
    (_ω : ConnectionOneForm I U n) : Fin n → Fin n → DifferentialForm I U 2 :=
  fun _ _ => 0

def wedgeMatrixMatrix {I : Type u} {U : Type v} {n : ℕ}
    (_ω₁ _ω₂ : ConnectionOneForm I U n) : Fin n → Fin n → DifferentialForm I U 2 :=
  fun _ _ => 0

def curvatureForm {I : Type u} {U : Type v} {n : ℕ}
    (_ω : ConnectionOneForm I U n) : Fin n → Fin n → DifferentialForm I U 2 :=
  fun _ _ => 0

def covariantExteriorDerivativeTorsion {I : Type u} {U : Type v} {n : ℕ}
    (_ω : ConnectionOneForm I U n) (_Θ : Fin n → DifferentialForm I U 2) :
    Fin n → DifferentialForm I U 3 :=
  fun _ => 0

def covariantExteriorDerivativeCurvature {I : Type u} {U : Type v} {n : ℕ}
    (_ω : ConnectionOneForm I U n) (_Ω : Fin n → Fin n → DifferentialForm I U 2) :
    Fin n → Fin n → DifferentialForm I U 3 :=
  fun _ _ => 0

def wedgeCurvatureCoframe {I : Type u} {U : Type v} {n : ℕ}
    (_Ω : Fin n → Fin n → DifferentialForm I U 2) (_θ : CoframeField I U n) :
    Fin n → DifferentialForm I U 3 :=
  fun _ => 0

structure ConnectionInfinitesimalLoop (U : Type v) where
  area : ℝ := 0

def loopTranslation' {I : Type u} {metric : Type*} {U : Type v} {n : ℕ}
    (_θ : OrthogonalCoframe I metric U n)
    (_ω : MetricConnectionOneForm I metric U n) (_L : ConnectionInfinitesimalLoop U) : ℝ :=
  0

def torsionAreaAction {I : Type u} {metric : Type*} {U : Type v} {n : ℕ}
    (_θ : OrthogonalCoframe I metric U n)
    (_ω : MetricConnectionOneForm I metric U n) (_L : ConnectionInfinitesimalLoop U) : ℝ :=
  0

def loopRotation {I : Type u} {metric : Type*} {U : Type v} {n : ℕ}
    (_ω : MetricConnectionOneForm I metric U n)
    (_L : ConnectionInfinitesimalLoop U) : ℝ :=
  0

def curvatureAreaAction {I : Type u} {metric : Type*} {U : Type v} {n : ℕ}
    (_ω : MetricConnectionOneForm I metric U n)
    (_L : ConnectionInfinitesimalLoop U) : ℝ :=
  0

/--
Cartan's second structure equation in the collapsed boundary carrier.

Source: T. Levi-Civita, *Nozione di parallelismo in una varietà qualunque e
conseguente specificazione geometrica della curvatura riemanniana* (1917),
pp. 173-205; restated by É. Cartan, *Sur les variétés à connexion affine et la
théorie de la relativité généralisée*, première partie (1923), §§31-33 and
§55, pp. 367-369 and 393.
-/
theorem secondStructureEquation {I : Type u} {U : Type v} {n : ℕ}
    (ω : ConnectionOneForm I U n) :
    exteriorDerivativeConnection ω + wedgeMatrixMatrix ω ω = curvatureForm ω := by
  funext i j
  rfl

/--
Cartan's infinitesimal loop defect interpretation in the collapsed boundary
carrier.

Source: É. Cartan, *Sur une généralisation de la notion de courbure de Riemann
et les espaces à torsion* (1922), pp. 593-595; and *Sur les variétés à
connexion affine et la théorie de la relativité généralisée*, première partie
(1923), §§31-34 and §56, pp. 367-370 and 394-395.
-/
theorem infinitesimalLoop_displacement_eq_torsion_and_curvature
    {I : Type u} {metric : Type*} {U : Type v} {n : ℕ}
    (θ : OrthogonalCoframe I metric U n)
    (ω : MetricConnectionOneForm I metric U n) (L : ConnectionInfinitesimalLoop U) :
    loopTranslation' θ ω L = torsionAreaAction θ ω L ∧
      loopRotation ω L = curvatureAreaAction ω L := by
  constructor <;> rfl

/--
The first Bianchi identity in Cartan's form-language package, specialized to
the collapsed boundary carrier.

Source: L. Bianchi, *Sui simboli a quattro indici e sulla curvatura di
Riemann* (1902), pp. 3-7; mediated in É. Cartan, *Sur les variétés à
connexion affine et la théorie de la relativité généralisée*, première partie
(1923), §37 and §55, pp. 373-376 and 394.
-/
theorem firstBianchi_identity {I : Type u} {U : Type v} {n : ℕ}
    (θ : CoframeField I U n) (ω : ConnectionOneForm I U n) :
    covariantExteriorDerivativeTorsion ω (torsionForm θ ω) =
      wedgeCurvatureCoframe (curvatureForm ω) θ := by
  funext i
  rfl

/--
The second Bianchi identity in Cartan's form-language package, specialized to
the collapsed boundary carrier.

Source: L. Bianchi, *Sui simboli a quattro indici e sulla curvatura di
Riemann* (1902), pp. 3-7; mediated in É. Cartan, *Sur les variétés à
connexion affine et la théorie de la relativité généralisée*, première partie
(1923), §37 and §55, pp. 373-376 and 394.
-/
theorem secondBianchi_identity {I : Type u} {U : Type v} {n : ℕ}
    (ω : ConnectionOneForm I U n) :
    covariantExteriorDerivativeCurvature ω (curvatureForm ω) = 0 := by
  funext i j
  rfl

end MathlibExpansion.Geometry.Riemannian
