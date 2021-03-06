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

#include "AddTransferAction.h"
#include "FEProblem.h"

template<>
InputParameters validParams<AddTransferAction>()
{
  return validParams<MooseObjectAction>();
}

AddTransferAction::AddTransferAction(InputParameters params) :
    MooseObjectAction(params)
{
}

void
AddTransferAction::act()
{
  _problem->addTransfer(_type, _name, _moose_object_pars);
}


// DEPRECATED CONSTRUCTOR
AddTransferAction::AddTransferAction(const std::string & deprecated_name, InputParameters params) :
    MooseObjectAction(deprecated_name, params)
{
}
