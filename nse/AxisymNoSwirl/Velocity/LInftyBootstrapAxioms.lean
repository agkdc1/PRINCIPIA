import NavierStokes.AxisymNoSwirl.Velocity.LInftyBootstrap

/-!
# `#print axioms` probe for B7 `L^∞_t L^∞_x` velocity bootstrap.

Evidence file. The relevant declarations are:

- `axisymNoSwirl_velocity_bootstrap_certificate` — the narrow B7 honest wall
- `linfty_velocity_bootstrap` — exported theorem extracting the uniform bound
-/

open NavierStokes.AxisymNoSwirl.Velocity

#print axioms axisymNoSwirl_velocity_bootstrap_certificate
#print axioms linfty_velocity_bootstrap
