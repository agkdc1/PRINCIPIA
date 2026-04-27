import MathlibExpansion.Roots.Mazur1977.EisensteinIdeal
import MathlibExpansion.Roots.Mazur1977.LocalizedHecke

namespace MathlibExpansion.Wiles1995

open MathlibExpansion.Roots.Mazur1977

universe u v w x

structure TMin
    (R : Type u) (M : Type v) [CommRing R] [AddCommGroup M] [Module R M]
    (p : ℕ) where
  hecke : PrimeLevelHeckeCarrier.{u,v,w} R M p
  localized : PrimeLevelLocalizedHecke.{u,v,w,x} hecke
  nonEisenstein : IsNonEisenstein hecke localized.maximalIdeal

end MathlibExpansion.Wiles1995
