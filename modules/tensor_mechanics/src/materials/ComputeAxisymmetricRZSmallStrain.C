/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/
#include "ComputeAxisymmetricRZSmallStrain.h"

template<>
InputParameters validParams<ComputeAxisymmetricRZSmallStrain>()
{
  InputParameters params = validParams<Compute2DSmallStrain>();
  params.addClassDescription("Compute a small strain in an Axisymmetric geometry");
  return params;
}

ComputeAxisymmetricRZSmallStrain::ComputeAxisymmetricRZSmallStrain(const InputParameters & parameters) :
    Compute2DSmallStrain(parameters)
{
}

Real
ComputeAxisymmetricRZSmallStrain::computeStrainZZ()
{
  if (_assembly.coordSystem() != Moose::COORD_RZ)
    mooseError("The coordinate system must be set to RZ for Axisymmetric geometries.");

  if (_q_point[_qp](0) != 0.0)
    return (*_disp[0])[_qp] / _q_point[_qp](0);

  else
    return 0.0;
}


// DEPRECATED CONSTRUCTOR
ComputeAxisymmetricRZSmallStrain::ComputeAxisymmetricRZSmallStrain(const std::string & deprecated_name, InputParameters parameters) :
    Compute2DSmallStrain(deprecated_name, parameters)
{
}
