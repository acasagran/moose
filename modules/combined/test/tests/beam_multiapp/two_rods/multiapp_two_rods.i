[Mesh]
  type = FileMesh
  file = beam2_two_rod_1el.e
[]

[AuxVariables]
  [./to_var]
    block = '1'
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
    boundary = '1001'
    value = 0.0
  [../]
  [./fixy1]
    type = DirichletBC
    preset = true
    variable = disp_y
    boundary = '1001'
    value = 0.0
  [../]
  [./fixz1]
    type = DirichletBC
    preset = true
    variable = disp_z
    boundary = '1001'
    value = 0.0
  [../]
  [./fixr1]
    type = DirichletBC
    preset = true
    variable = rot_x
    boundary = '1001'
    value = 0.0
  [../]
  [./fixr2]
    type = DirichletBC
    preset = true
    variable = rot_y
    boundary = '1001'
    value = 0.0
  [../]
  [./fixr3]
    type = DirichletBC
    preset = true
    variable = rot_z
    boundary = '1001'
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
  petsc_options       = '-snes_ksp_ew'
  petsc_options_iname = '-pc_type -ksp_gmres_restart'
  petsc_options_value = 'lu 101'
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
  [./matl]
    area = 9.369021e-5
    Iy = 6.9851959e-10
    Iz = 6.9851959e-10
    block = '1'
    y_orientation = '0.0 0.0 1.0'
   eigenstrain_names = 'thermal'
  [../]
[]

[Materials]
  [./stress]
    type = ComputeBeamResultants
    block = '1'
  [../]
  [./elasticity_1]
    type = ComputeElasticityBeam
    youngs_modulus = 7.5e10
    poissons_ratio = 0.3
    shear_coefficient = 1.0
    block = '1'
  [../]
  [./thermal]
    type = ComputeEigenstrainBeamFromVariable
    block = '1'
    displacement_eigenstrain_variables = 'zero1 to_var zero2'
    eigenstrain_name = thermal
  [../]
[]


[MultiApps]
  [./sub]
    type = TransientMultiApp
    positions_file = rod_positions.csv
    input_files = 'thermal_expansion_2D_RZ.i'
  [../]
[]

[Transfers]
  [./fromsub]
    type = MultiAppUserObjectTransfer
    direction = from_multiapp
    user_object = axial_str
    multi_app = sub
    variable = to_var
  [../]
[]

[Controls]
  [cmdline]
    type = MultiAppFunctionCommandLineControl
    multi_app = sub
    function = linear_test
    param_name = 'Functions/func_scaling/value'
  []
[]

[Functions]
  [./linear_test]
    type = PiecewiseLinear
    x = '0 0.05'
    y = '0.5 1.0'
    axis = x
  [../]
[]

[Outputs]
  exodus = true
  print_linear_residuals=true
  csv=true
[]
