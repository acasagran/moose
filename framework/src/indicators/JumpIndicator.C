/****************************************************************/
/*               DO NOT MODIFY THIS HEADER                      */
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*           (c) 2010 Battelle Energy Alliance, LLC             */
/*                   ALL RIGHTS RESERVED                        */
/*                                                              */
/*          Prepared by Battelle Energy Alliance, LLC           */
/*            Under Contract No. DE-AC07-05ID14517              */
/*            With the U. S. Department of Energy               */
/*                                                              */
/*            See COPYRIGHT for full restrictions               */
/****************************************************************/

#include "JumpIndicator.h"

template<>
InputParameters validParams<JumpIndicator>()
{
  InputParameters params = validParams<InternalSideIndicator>();
  return params;
}


JumpIndicator::JumpIndicator(const InputParameters & parameters) :
    InternalSideIndicator(parameters)
{
}


Real
JumpIndicator::computeQpIndicator()
{
  return 0;
}



// DEPRECATED CONSTRUCTOR
JumpIndicator::JumpIndicator(const std::string & deprecated_name, InputParameters parameters) :
    InternalSideIndicator(deprecated_name, parameters)
{
}
