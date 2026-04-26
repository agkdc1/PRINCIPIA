import NavierStokes.Geometry.Cylindrical.Basic

noncomputable section

open scoped Topology

namespace NavierStokes.TestChecks

open NavierStokes.Geometry.Cylindrical

example {p : E3} (hp : p ∈ puncturedSpace) : puncturedSpace ∈ 𝓝 p :=
  isOpen_puncturedSpace.mem_nhds hp

example : Prop := ContDiffOn ℝ 2 rCyl puncturedSpace

end NavierStokes.TestChecks
