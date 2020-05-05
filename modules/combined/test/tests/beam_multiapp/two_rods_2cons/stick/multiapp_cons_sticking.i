[Mesh]
  type = FileMesh
  file = beam2_two_rod_3el_2cons.e
[]

[AuxVariables]
  [./proc_id]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./proc_id]
    type = ProcessorIDAux
    variable = proc_id
  [../]
[]

[AuxVariables]
  [./matl_eig]
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
    eigenstrain_names = 'thermal_matl'
  [../]
[]

[Materials]
  [./stress]
    type = ComputeBeamResultants
    block = '1'
    outputs = exodus
    output_properties = 'forces moments'
  [../]
  [./elasticity_1]
    type = ComputeElasticityBeam
    youngs_modulus = 7.5e10
    poissons_ratio = 0.3
    shear_coefficient = 1.0
    block = '1'
  [../]
  [./thermal_matl]
    type = ComputeEigenstrainBeamFromVariable
    block = '1'
    displacement_eigenstrain_variables = 'zero1 matl_eig zero2'
    eigenstrain_name = thermal_matl
  [../]
[]

[Constraints]
  [./tie_y_matl]
    type = NodalStickConstraint
    penalty = 1.2e6
    boundary = 1004
    slave = 1003
    variable = disp_y
  [../]
[]

[VectorPostprocessors]
  [./nodal_sample]
    type = NodalValueSampler
    variable = 'disp_x disp_y disp_z rot_x rot_y rot_z'
    boundary = '1003'
    sort_by = z
    outputs = 'vec1'
  [../]
  [./matl_rod_disp]
    type = NodalValueSampler
    variable = 'disp_x disp_y disp_z rot_x rot_y rot_z'
    boundary = '1002'
    sort_by = y
    outputs = 'vec2'
  [../]
[]

[AuxKernels]
  [./matl]
    type = SolutionAux
    variable = matl_eig
    solution = matl_soln
    block = 1
    direct = true
  [../]
[]

[UserObjects]
  [./matl_soln]
    type = SolutionUserObject
    mesh = ../multiapp_two_rods_2cons_out.e
    system_variables = to_var
  [../]
[]

[Postprocessors]
  [./dt]
    type = TimestepSize
  [../]
  [./disp_y2]
    type = NodalVariableValue
    nodeid = 1
    variable = disp_y
  [../]
  [./disp_y5]
    type = NodalVariableValue
    nodeid = 4
    variable = disp_y
  [../]
  [./disp_y7]
    type = NodalVariableValue
    nodeid = 6
    variable = disp_y
  [../]
  [./disp_y3]
    type = NodalVariableValue
    nodeid = 2
    variable = disp_y
  [../]
  [./disp_y6]
    type = NodalVariableValue
    nodeid = 5
    variable = disp_y
  [../]
[]

[Outputs]
  exodus = true
  print_linear_residuals=true
  csv=true
  [./vec1]
    type = CSV
    execute_on = 'FINAL'
    create_final_symlink = true
  [../]
  [./vec2]
    type = CSV
    execute_on = 'FINAL'
    create_final_symlink = true
  [../]
[]
