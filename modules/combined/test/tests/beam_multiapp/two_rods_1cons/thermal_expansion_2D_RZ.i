[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 1
  ny = 20
  xmin = 0.0
  xmax = 0.0055
  ymin = 0.0
  ymax = 2.0
  elem_type = QUAD4
[]

[Problem]
  coord_type = RZ
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
[]

[AuxVariables]
  [./temperature]
    initial_condition = 300.0
  [../]
  [./elastic_strain_yy]
  [../]
  [./elastic_strain_xx]
  [../]
  [./elastic_strain_zz]
  [../]
  [./total_strain_yy]
  [../]
  [./total_strain_xx]
  [../]
  [./total_strain_zz]
  [../]
  [./axial_strain]
  [../]
[]

[Functions]
  [./temp_func2]
    type = ParsedFunction
    value = '300.0 +  (scale * 1000.0 - 300.0)/10.0*t'
    vals = 'func_scaling'
    vars = 'scale'
  [../]
  [./func_scaling]
    type = ConstantFunction
    value = 1.0
  [../]
[]


[Modules/TensorMechanics/Master]
  [./all]
    strain = FINITE
    add_variables = true
    eigenstrain_names = thermal_expansion
    generate_output = 'strain_xx strain_yy strain_zz'
  [../]
[]

[AuxKernels]
  [./temp_aux]
    type = FunctionAux
    variable = temperature
    function = temp_func2
  [../]
  [./elastic_strain_yy]
    type = RankTwoAux
    rank_two_tensor = elastic_strain
    variable = elastic_strain_yy
    index_i = 1
    index_j = 1
    execute_on = timestep_end
  [../]
  [./elastic_strain_xx]
    type = RankTwoAux
    rank_two_tensor = elastic_strain
    variable = elastic_strain_xx
    index_i = 0
    index_j = 0
    execute_on = timestep_end
  [../]
  [./elastic_strain_zz]
    type = RankTwoAux
    rank_two_tensor = elastic_strain
    variable = elastic_strain_zz
    index_i = 2
    index_j = 2
    execute_on = timestep_end
  [../]
  [./total_strain_yy]
    type = RankTwoAux
    rank_two_tensor = total_strain
    variable = total_strain_yy
    index_i = 1
    index_j = 1
    execute_on = timestep_end
  [../]
  [./total_strain_xx]
    type = RankTwoAux
    rank_two_tensor = total_strain
    variable = total_strain_xx
    index_i = 0
    index_j = 0
    execute_on = timestep_end
  [../]
  [./total_strain_zz]
    type = RankTwoAux
    rank_two_tensor = total_strain
    variable = total_strain_zz
    index_i = 2
    index_j = 2
    execute_on = timestep_end
  [../]
  [./axial_strain_1]
    type = RankTwoAux
    rank_two_tensor = total_strain
    variable = axial_strain
    index_i = 1
    index_j = 1
    execute_on = timestep_end
  [../]
[]

[BCs]
  [./u_bottom_fix]
    type = DirichletBC
    variable = disp_y
    boundary = 'bottom'
    value = 0.0
  [../]
[]

[Materials]
  [./elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 1e9
    poissons_ratio = 0.3
  [../]
  [./stress]
    type = ComputeFiniteStrainElasticStress
    block = 0
  [../]
  [./thermal_expansion_strain]
    type = ComputeInstantaneousThermalExpansionFunctionEigenstrain
    thermal_expansion_function = 1e-4
    stress_free_temperature = 300.0
    temperature = temperature
    eigenstrain_name = thermal_expansion
    block = 0
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

[Postprocessors]
  [./elastic_strain_xx]
    type = ElementAverageValue
    variable = elastic_strain_xx
  [../]
  [./elastic_strain_yy]
    type = ElementAverageValue
    variable = elastic_strain_yy
  [../]
  [./elastic_strain_zz]
    type = ElementAverageValue
    variable = elastic_strain_zz
  [../]
  [./total_strain_xx]
    type = ElementAverageValue
    variable = total_strain_xx
  [../]
  [./total_strain_yy]
    type = ElementAverageValue
    variable = total_strain_yy
  [../]
  [./total_strain_zz]
    type = ElementAverageValue
    variable = total_strain_zz
  [../]
  [./thermal_strain_xx]
    type = DifferencePostprocessor
    value1 = total_strain_xx
    value2 = elastic_strain_xx
  [../]
  [./thermal_strain_yy]
    type = DifferencePostprocessor
    value1 = total_strain_yy
    value2 = elastic_strain_yy
  [../]
  [./thermal_strain_zz]
    type = DifferencePostprocessor
    value1 = total_strain_zz
    value2 = elastic_strain_zz
  [../]
  [./axial_strain]
    type = ElementAverageValue
    variable = axial_strain
  [../]
  [./temperature]
    type = AverageNodalVariableValue
    variable = temperature
    execute_on = 'initial timestep_end'
  [../]
  [./disp_x41]
    type = NodalVariableValue
    nodeid = 40
    variable = disp_x
  [../]
  [./disp_y41]
    type = NodalVariableValue
    nodeid = 40
    variable = disp_y
  [../]
[]

[VectorPostprocessors]
  [./axial_str]
    type = LineValueSampler
    start_point = '0.00525 0.001 0.0'
    end_point = '0.00525 1.999 0.0'
    variable = axial_strain
    num_points = 200
    sort_by = 'id'
    outputs = 'vec1'
  [../]
  [./axial_disp]
    type = LineValueSampler
    start_point = '0.00525 0.001 0.0'
    end_point = '0.00525 1.999 0.0'
    variable = disp_y
    num_points = 200
    sort_by = 'id'
    outputs = 'vec2'
  [../]
[]

[Outputs]
  csv = true
  [./out]
    type = Exodus
  [../]
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
