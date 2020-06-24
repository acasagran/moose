[Mesh]
  type = FileMesh
  file = grid_beam_assm_base.e
[]

[AuxVariables]
  [./to_var_tube1]
    block = '2'
  [../]
  [./to_var_tube2]
    block = '3'
  [../]
  [./zero1]
  [../]
  [./zero2]
  [../]
[]

[BCs]
  [./fixx1]
    type = DirichletBC
    preset = true
    variable = disp_x
    boundary = '1004 1001'
    value = 0.0
  [../]
  [./fixy1]
    type = DirichletBC
    preset = true
    variable = disp_y
    boundary = '1004'
    value = 0.0
  [../]
  [./fixz1]
    type = DirichletBC
    preset = true
    variable = disp_z
    boundary = '1004 1005 1001'
    value = 0.0
  [../]
  [./fixr1]
    type = DirichletBC
    preset = true
    variable = rot_x
    boundary = '1004 1005 1001'
    value = 0.0
  [../]
  [./fixr2]
    type = DirichletBC
    preset = true
    variable = rot_y
    boundary = '1004 1005 1001'
    value = 0.0
  [../]
  [./fixr3]
    type = DirichletBC
    preset = true
    variable = rot_z
    boundary = '1004 1005 1001'
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
  solve_type = 'PJFNK'
  petsc_options = '-snes_ksp_ew'
  petsc_options_iname = '-ksp_gmres_restart -pc_type -pc_hypre_type -pc_hypre_boomeramg_max_iter'
  petsc_options_value = '201 hypre boomeramg 4'
  line_search = 'none'

  l_max_its  = 100
  nl_max_its = 100
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-10
  l_tol      = 1e-5
  start_time = 0.0
  end_time   = 10.0
  dt         = 1.0
[]

[Modules/TensorMechanics/LineElementMaster]
  # parameters common to all blocks
  add_variables = true
  displacements = 'disp_x disp_y disp_z'
  rotations = 'rot_x rot_y rot_z'

  # Geometry parameters
  [./matl1]
    area = 1e-2
    Iy = 1e-5
    Iz = 1e-5
    block = '1'
    y_orientation = '0.0 1.0 0.0'
  [../]
  [./matl2]
    area = 1e-4
    Iy = 1e-9
    Iz = 1e-9
    block = '2'
    y_orientation = '0.0 0.0 1.0'
    eigenstrain_names = 'thermal_tube1'
  [../]
  [./matl3]
    area = 1e-4
    Iy = 1e-9
    Iz = 1e-9
    block = '3'
    y_orientation = '0.0 0.0 1.0'
    eigenstrain_names = 'thermal_tube2'
  [../]
[]

[Materials]
  [./stress]
    type = ComputeBeamResultants
    block = '1 2 3'
  [../]
  [./elasticity_1]
    type = ComputeElasticityBeam
    youngs_modulus = 7.5e10
    poissons_ratio = 0.3
    shear_coefficient = 1.0
    block = '1 2 3'
  [../]
  [./thermal_1]
    type = ComputeEigenstrainBeamFromVariable
    block = '2'
    displacement_eigenstrain_variables = 'zero1 to_var_tube1 zero2'
    eigenstrain_name = thermal_tube1
  [../]
  [./thermal_2]
    type = ComputeEigenstrainBeamFromVariable
    block = '3'
    displacement_eigenstrain_variables = 'zero1 to_var_tube2 zero2'
    eigenstrain_name = thermal_tube2
  [../]
[]


[MultiApps]
  [./subtube1]
    type = TransientMultiApp
    positions_file = tube1_positions.csv
    input_files = 'thermal_expansion_2D_RZ_tube1.i'
  [../]
  [./subtube2]
    type = TransientMultiApp
    positions_file = tube2_positions.csv
    input_files = 'thermal_expansion_2D_RZ_tube2.i'
  [../]
[]

[Transfers]
  [./fromtube1]
    type = MultiAppUserObjectTransfer
    direction = from_multiapp
    user_object = axial_str
    multi_app = subtube1
    variable = to_var_tube1
  [../]
  [./fromtube2]
    type = MultiAppUserObjectTransfer
    direction = from_multiapp
    user_object = axial_str
    multi_app = subtube2
    variable = to_var_tube2
  [../]
[]

[Controls]
  [cmdline1]
    type = MultiAppFunctionCommandLineControl
    multi_app = subtube1
    function = linear_test
    param_name = 'Functions/func_scaling/value'
  []
  [cmdline2]
    type = MultiAppFunctionCommandLineControl
    multi_app = subtube2
    function = linear_test
    param_name = 'Functions/func_scaling/value'
  []
[]

[Functions]
  [./linear_test]
    type = PiecewiseLinear
    x = '0.0  0.05'
    y = '0.5  1.0'
    axis = x
  [../]
[]

[Outputs]
  exodus = true
  print_linear_residuals = true
  csv = true
[]
