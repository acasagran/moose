[Mesh]
  type = FileMesh
  file = grid_beam_assm_base.e
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
  [./matl2_eig]
    block = '2'
  [../]
  [./matl3_eig]
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
    boundary = '1004 1005'
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
    boundary = '1004 1005'
    value = 0.0
  [../]
  [./fixr1]
    type = DirichletBC
    preset = true
    variable = rot_x
    boundary = '1004 1005'
    value = 0.0
  [../]
  [./fixr2]
    type = DirichletBC
    preset = true
    variable = rot_y
    boundary = '1004 1005'
    value = 0.0
  [../]
  [./fixr3]
    type = DirichletBC
    preset = true
    variable = rot_z
    boundary = '1004 1005'
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
    eigenstrain_names = 'thermal_matl2'
  [../]
  [./matl3]
    area = 1e-4
    Iy = 1e-9
    Iz = 1e-9
    block = '3'
    y_orientation = '0.0 0.0 1.0'
    eigenstrain_names = 'thermal_matl3'
  [../]
[]

[Materials]
  [./stress]
    type = ComputeBeamResultants
    block = '1 2 3'
    outputs = exodus
    output_properties = 'forces moments'
  [../]
  [./elasticity_1]
    type = ComputeElasticityBeam
    youngs_modulus = 7.5e10
    poissons_ratio = 0.3
    shear_coefficient = 1.0
    block = '1 2 3'
  [../]
  [./thermal_matl2]
    type = ComputeEigenstrainBeamFromVariable
    block = '2'
    displacement_eigenstrain_variables = 'zero1 matl2_eig zero2'
    eigenstrain_name = thermal_matl2
  [../]
  [./thermal_matl3]
    type = ComputeEigenstrainBeamFromVariable
    block = '3'
    displacement_eigenstrain_variables = 'zero1 matl3_eig zero2'
    eigenstrain_name = thermal_matl3
  [../]
[]

[Constraints]
  [./tie_y_matl]
    type = NodalStickConstraint
    penalty = 1.2e6
    boundary = 1003
    slave = 1001
    variable = disp_y
  [../]
  [./tie_x_matl]
    type = NodalStickConstraint
    penalty = 1.2e6
    boundary = 1003
    slave = 1001
    variable = disp_x
  [../]
  [./tie_z_matl]
    type = NodalStickConstraint
    penalty = 1.2e6
    boundary = 1003
    slave = 1001
    variable = disp_z
  [../]
  [./tie_ry_matl]
    type = NodalStickConstraint
    penalty = 1.2e6
    boundary = 1003
    slave = 1001
    variable = rot_y
  [../]
  [./tie_rx_matl]
    type = NodalStickConstraint
    penalty = 1.2e6
    boundary = 1003
    slave = 1001
    variable = rot_x
  [../]
  [./tie_rz_matl]
    type = NodalStickConstraint
    penalty = 1.2e6
    boundary = 1003
    slave = 1001
    variable = rot_z
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
  [./matl_tube_disp]
    type = NodalValueSampler
    variable = 'disp_x disp_y disp_z rot_x rot_y rot_z'
    boundary = '1002'
    sort_by = y
    outputs = 'vec2'
  [../]
[]

[AuxKernels]
  [./matl2]
    type = SolutionAux
    variable = matl2_eig
    solution = matl2_soln
    block = 2
    direct = true
  [../]
  [./matl3]
    type = SolutionAux
    variable = matl3_eig
    solution = matl3_soln
    block = 3
    direct = true
  [../]
[]

[UserObjects]
  [./matl2_soln]
    type = SolutionUserObject
    mesh = ../multiapp_2x1_1cons_out.e
    system_variables = to_var_tube1
  [../]
  [./matl3_soln]
    type = SolutionUserObject
    mesh = ../multiapp_2x1_1cons_out.e
    system_variables = to_var_tube2
  [../]
[]

[Postprocessors]
  [./dt]
    type = TimestepSize
  [../]
  [./disp_y4]
    type = NodalVariableValue
    nodeid = 3
    variable = disp_y
  [../]
  [./disp_y7]
    type = NodalVariableValue
    nodeid = 6
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
