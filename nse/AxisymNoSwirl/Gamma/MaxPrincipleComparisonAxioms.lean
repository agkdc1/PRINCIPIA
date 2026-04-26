import NavierStokes.AxisymNoSwirl.Gamma.MaxPrincipleComparison

/-!
# `#print axioms` probe — Route W crown theorem (`MaxPrincipleComparison.lean`).

Evidence file. Lists the axiom dependencies of the two crown deliverables:

- `maxPrincipleComparison` — a.e. upper comparison / `L^∞` propagation.
- `maxPrincipleCrown`      — Γ comparison ⊕ velocity `L^∞` bootstrap.

`maxPrincipleComparison` must be zero-axiom on top of Mathlib kernel + the
zero-axiom B5 Stampacchia substrate.

`maxPrincipleCrown` is allowed to depend transitively on the single narrow
B7 axiom `axisymNoSwirl_velocity_bootstrap_certificate` (already filed in
`Velocity/LInftyBootstrap.lean`, not introduced by this crown file).
-/

open NavierStokes.AxisymNoSwirl.Gamma

#print axioms maxPrincipleComparison
#print axioms maxPrincipleCrown
