# Test for eigenstrain from aux variables

# A constant axial eigenstrain of 0.01 is applied to a beam of length
# 4 m. The beam is fixed at one end. The eigenstrain causes a change in
# length of 0.04 m irrespective of the material properties of the beam.

[Mesh]
  type = FileMesh
  file = beam_paper_10.e
  displacements = 'disp_x disp_y disp_z'
[]

[Variables]
  [./disp_x]
    order = FIRST
    family = LAGRANGE
  [../]
  [./disp_y]
    order = FIRST
    family = LAGRANGE
  [../]
  [./disp_z]
    order = FIRST
    family = LAGRANGE
  [../]
  [./rot_x]
    order = FIRST
    family = LAGRANGE
  [../]
  [./rot_y]
    order = FIRST
    family = LAGRANGE
  [../]
  [./rot_z]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxVariables]
  [./thermal_eig]
  [../]
  [./zero1]
  [../]
  [./zero2]
  [../]
[]

[AuxKernels]
  [./thermal_eig]
    type = ConstantAux
    value = 0.01
    variable = thermal_eig
  [../]
[]

[BCs]
  [./fixx1]
    type = DirichletBC
    variable = disp_x
    boundary = 1
    value = 0.0
  [../]
  [./fixy1]
    type = DirichletBC
    variable = disp_y
    boundary = 1
    value = 0.0
  [../]
  [./fixz1]
    type = DirichletBC
    variable = disp_z
    boundary = 1
    value = 0.0
  [../]
  [./fixr1]
    type = DirichletBC
    variable = rot_x
    boundary = 1
    value = 0.0
  [../]
  [./fixr2]
    type = DirichletBC
    variable = rot_y
    boundary = 1
    value = 0.0
  [../]
  [./fixr3]
    type = DirichletBC
    variable = rot_z
    boundary = 1
    value = 0.0
  [../]
[]

[Preconditioning]
  [./smp]
    type = SMP
    full = true
  [../]
[]
[Executioner]
  type = Transient
  solve_type = PJFNK
#  petsc_options_iname = '-pc_type -ksp_gmres_restart'
#  petsc_options_value = 'jacobi   101'
  line_search = 'none'
#  petsc_options = '-snes_check_jacobian -snes_check_jacobian_view'
  nl_max_its = 15
  nl_rel_tol = 1e-10
  nl_abs_tol = 1e-8

  dt = 1
  dtmin = 1
  end_time = 2
[]

[Kernels]
  [./solid_disp_x]
    type = StressDivergenceBeam
    block = '1'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 0
    variable = disp_x
  [../]
  [./solid_disp_y]
    type = StressDivergenceBeam
    block = '1'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 1
    variable = disp_y
  [../]
  [./solid_disp_z]
    type = StressDivergenceBeam
    block = '1'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 2
    variable = disp_z
  [../]
  [./solid_rot_x]
    type = StressDivergenceBeam
    block = '1'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 3
    variable = rot_x
  [../]
  [./solid_rot_y]
    type = StressDivergenceBeam
    block = '1'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 4
    variable = rot_y
  [../]
  [./solid_rot_z]
    type = StressDivergenceBeam
    block = '1'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 5
    variable = rot_z
  [../]
[]

[Materials]
  [./elasticity]
    type = ComputeElasticityBeam
    youngs_modulus = 2.60072400269
    shear_modulus = 1.0e4
    shear_coefficient = 0.85
    block = 1
  [../]
  [./strain]
    type = ComputeIncrementalBeamStrain
    block = '1'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 0.554256
    Ay = 0.0
    Az = 0.0
    Iy = 0.0141889
    Iz = 0.0141889
    y_orientation = '0.0 1.0 0.0'
    eigenstrain_names = 'thermal'
  [../]
  [./stress]
    type = ComputeBeamResultants
    block = 1
  [../]
  [./thermal]
    type = ComputeBeamEigenstrainFromAuxVar
    disp_eigenstrain = 'thermal_eig zero1 zero2'
    eigenstrain_name = thermal
  [../]
[]

[Postprocessors]
  [./disp_x]
    type = PointValue
    point = '4.000447 0.0 0.0'
    variable = disp_x
  [../]
  [./disp_y]
    type = PointValue
    point = '4.000447 0.0 0.0'
    variable = disp_y
  [../]
[]

[Outputs]
  [./out]
    type = Exodus
    hide = 'thermal_eig zero1 zero2'
  [../]
[]