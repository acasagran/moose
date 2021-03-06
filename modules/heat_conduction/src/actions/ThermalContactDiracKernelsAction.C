/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "ThermalContactDiracKernelsAction.h"
#include "Factory.h"
#include "FEProblem.h"

template<>
InputParameters validParams<ThermalContactDiracKernelsAction>()
{
  InputParameters params = validParams<Action>();
  params.addRequiredParam<NonlinearVariableName>("variable", "The variable for thermal contact");
  params.addRequiredParam<BoundaryName>("master", "The master surface");
  params.addRequiredParam<BoundaryName>("slave", "The slave surface");
  params.addParam<Real>("tangential_tolerance", "Tangential distance to extend edges of contact surfaces");
  params.addParam<Real>("normal_smoothing_distance", "Distance from edge in parametric coordinates over which to smooth contact normal");
  params.addParam<std::string>("normal_smoothing_method","Method to use to smooth normals (edge_based|nodal_normal_based)");
  params.addParam<bool>("quadrature", false, "Whether or not to use quadrature point based gap heat transfer");
  return params;
}

ThermalContactDiracKernelsAction::ThermalContactDiracKernelsAction(const InputParameters & params) :
  Action(params)
{
}

void
ThermalContactDiracKernelsAction::act()
{
  if (!getParam<bool>("quadrature"))
  {
    InputParameters params = _factory.getValidParams("GapHeatPointSourceMaster");
    params.set<NonlinearVariableName>("variable") = getParam<NonlinearVariableName>("variable");
    params.set<BoundaryName>("boundary") = getParam<BoundaryName>("master");
    params.set<BoundaryName>("slave") = getParam<BoundaryName>("slave");
    if (isParamValid("tangential_tolerance"))
    {
      params.set<Real>("tangential_tolerance") = getParam<Real>("tangential_tolerance");
    }
    if (isParamValid("normal_smoothing_distance"))
    {
      params.set<Real>("normal_smoothing_distance") = getParam<Real>("normal_smoothing_distance");
    }
    if (isParamValid("normal_smoothing_method"))
    {
      params.set<std::string>("normal_smoothing_method") = getParam<std::string>("normal_smoothing_method");
    }

    _problem->addDiracKernel("GapHeatPointSourceMaster",
                             "GapHeatPointSourceMaster_"+_name,
                             params);
  }
}


// DEPRECATED CONSTRUCTOR
ThermalContactDiracKernelsAction::ThermalContactDiracKernelsAction(const std::string & deprecated_name, InputParameters params) :
  Action(deprecated_name, params)
{
}
