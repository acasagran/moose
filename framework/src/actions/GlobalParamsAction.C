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

#include "GlobalParamsAction.h"

template<>
InputParameters validParams<GlobalParamsAction>()
{
  InputParameters params = validParams<Action>();
  std::vector<std::string> blocks(1, "");

  /* GlobalParams should not have children or other standard public Action attributes */
  params.addPrivateParam<std::vector<std::string> >("active", blocks);
  return params;
}

GlobalParamsAction::GlobalParamsAction(InputParameters params) :
    Action(params)
{
}

void
GlobalParamsAction::act()
{
}

void
GlobalParamsAction::remove(const std::string & name)
{
  parameters().remove(name);
}


// DEPRECATED CONSTRUCTOR
GlobalParamsAction::GlobalParamsAction(const std::string & deprecated_name, InputParameters params) :
    Action(deprecated_name, params)
{
}
