/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "TensorMechanicsAxisymmetricRZAction.h"

#include "Factory.h"
#include "FEProblem.h"
#include "Parser.h"

template<>
InputParameters validParams<TensorMechanicsAxisymmetricRZAction>()
{
  InputParameters params = validParams<Action>();
  params.addClassDescription("Set up stress divergence kernels");
  params.addRequiredParam<std::vector<NonlinearVariableName> >("displacements", "The nonlinear displacement variables for the problem");
  params.addParam<std::string>("base_name", "Material property base name");
  params.addParam<bool>("use_displaced_mesh", false, "Whether to use displaced mesh in the kernels");

  return params;
}

TensorMechanicsAxisymmetricRZAction::TensorMechanicsAxisymmetricRZAction(const InputParameters & params) :
    Action(params)
{
}

void
TensorMechanicsAxisymmetricRZAction::act()
{
  std::vector<NonlinearVariableName> displacements = getParam<std::vector<NonlinearVariableName> > ("displacements");
  std::vector<VariableName> coupled_displacements;
  Real dim = displacements.size();

  //Error checking:  Can only take two displacement variables in AxisymmetricRZ
  mooseAssert(dim == 2, "Expected two displacement variables but recieved " << dim);

  for (unsigned int i = 0; i < dim; ++i)
  {
    coupled_displacements.push_back(displacements[i]);
  }

  InputParameters params = _factory.getValidParams("StressDivergenceRZTensors");
  params.set<std::vector<VariableName> >("displacements") = coupled_displacements;

  params.set<bool>("use_displaced_mesh") = getParam<bool>("use_displaced_mesh");

  if (isParamValid("base_name"))
    params.set<std::string>("base_name") = getParam<std::string>("base_name");

  std::string short_name = "TensorMechanicsRZ";


  for (unsigned int i = 0; i < dim; ++i)
  {
    std::stringstream name;
    name << short_name;
    name << i;

    params.set<unsigned int>("component") = i;
    params.set<NonlinearVariableName>("variable") = displacements[i];

    _problem->addKernel("StressDivergenceRZTensors", name.str(), params);
  }
}


// DEPRECATED CONSTRUCTOR
TensorMechanicsAxisymmetricRZAction::TensorMechanicsAxisymmetricRZAction(const std::string & deprecated_name, InputParameters params) :
    Action(deprecated_name, params)
{
}
