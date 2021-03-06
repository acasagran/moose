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

#include "AddFunctionAction.h"
#include "FEProblem.h"

template<>
InputParameters validParams<AddFunctionAction>()
{
  return validParams<MooseObjectAction>();
}

AddFunctionAction::AddFunctionAction(InputParameters params) :
    MooseObjectAction(params)
{
}

void
AddFunctionAction::act()
{
  _problem->addFunction(_type, _name, _moose_object_pars);
}


// DEPRECATED CONSTRUCTOR
AddFunctionAction::AddFunctionAction(const std::string & deprecated_name, InputParameters params) :
    MooseObjectAction(deprecated_name, params)
{
}
