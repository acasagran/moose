[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 4
  ny = 8
  xmin = 0.0
  xmax = 1.0
  ymin = 0.0
  ymax = 2.0
  elem_type = QUAD4
[]

[Modules/TensorMechanics/Master/All]
  strain = FINITE
  add_variables = true
  generate_output = 'stress_xx stress_xy stress_yy strain_xx strain_xy strain_yy'
[]

[BCs]
  [./Pressure]
    [./top]
      boundary = top
      function = '-1000*t'
    [../]
  [../]
  [./InclinedNoDisplacementBC]
    [./right]
      boundary = right
      penalty = 1.0e8
      displacements = 'disp_x disp_y'
    [../]
    [./bottom]
      boundary = bottom
      penalty = 1.0e8
      displacements = 'disp_x disp_y'
    [../]
  [../]
[]

[Materials]
  [./elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 1e6
    poissons_ratio = 0.3
  [../]
  [./stress]
    type = ComputeFiniteStrainElasticStress
  [../]
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu     superlu_dist'

  # controls for linear iterations
  l_max_its = 10
  l_tol = 1e-4

  # controls for nonlinear iterations
  nl_max_its = 100
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-8

  # time control
  start_time = 0.0
  dt = 1
  end_time = 5
[]

[Preconditioning]
  [./smp]
    type = SMP
    full = true
  [../]
[]

[VectorPostprocessors]
  [./stress_xx]
    type = LineMaterialRankTwoSampler
    start = '0.001 1.0 0.0'
    end   = '0.999 1.0 0.0'
    property = stress
    index_i = 0
    index_j = 0
    sort_by = x
    outputs = chk1
  [../]
  [./stress_yy]
    type = LineMaterialRankTwoSampler
    start = '0.001 1.0 0.0'
    end   = '0.999 1.0 0.0'
    property = stress
    index_i = 1
    index_j = 1
    sort_by = x
    outputs = chk2
  [../]
[]

[Outputs]
  exodus = true
  csv = true
  [./chk1]
   type = CSV
   execute_on = 'FINAL'
   create_final_symlink = true
  [../]
  [./chk2]
   type = CSV
   execute_on = 'FINAL'
   create_final_symlink = true
  [../]
[]
