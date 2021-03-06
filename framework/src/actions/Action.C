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

#include "Action.h"
#include "ActionWarehouse.h"
#include "MooseMesh.h"
#include "MooseApp.h"

template<>
InputParameters validParams<Action>()
{
  InputParameters params;
  std::vector<std::string> blocks(1);
  blocks[0] = "__all__";
  // Add the "active" parameter to all blocks to support selective child visitation (turn blocks on and off without comments)
  params.addParam<std::vector<std::string> >("active", blocks, "If specified only the blocks named will be visited and made active");

  params.addPrivateParam<std::string>("task");
  params.addPrivateParam<std::string>("registered_identifier");
  params.addPrivateParam<std::string>("action_type");
  params.addPrivateParam<ActionWarehouse *>("awh", NULL);

  return params;
}

Action::Action(InputParameters parameters) :
    ConsoleStreamInterface(*parameters.getCheckedPointerParam<MooseApp *>("_moose_app", "In Action constructor")),
    _pars(parameters),
    _name(getParam<std::string>("name")),
    _short_name(MooseUtils::shortName(_name)),
    _registered_identifier(isParamValid("registered_identifier") ? getParam<std::string>("registered_identifier") : ""),
    _action_type(getParam<std::string>("action_type")),
    _app(*parameters.getCheckedPointerParam<MooseApp *>("_moose_app", "In Action constructor")),
    _factory(_app.getFactory()),
    _action_factory(_app.getActionFactory()),
    _specific_task_name(_pars.isParamValid("task") ? getParam<std::string>("task") : ""),
    _awh(*parameters.getCheckedPointerParam<ActionWarehouse *>("awh")),
    _current_task(_awh.getCurrentTaskName()),
    _mesh(_awh.mesh()),
    _displaced_mesh(_awh.displacedMesh()),
    _problem(_awh.problem()),
    _executioner(_awh.executioner())
{
}

std::string
Action::getShortName() const
{
  return _short_name;
}

std::string
Action::getBaseName() const
{
  return _name.substr(0, _name.find_last_of('/') != std::string::npos ? _name.find_last_of('/') : 0);
}


// DEPRECATED CONSTRUCTOR
Action::Action(const std::string & deprecated_name, InputParameters deprecated_parameters) :
    ConsoleStreamInterface(*deprecated_parameters.getCheckedPointerParam<MooseApp *>("_moose_app", "In Action constructor")),
    _pars(deprecated_parameters),
    _name(deprecated_name),
    _short_name(MooseUtils::shortName(_name)),
    _registered_identifier(isParamValid("registered_identifier") ? getParam<std::string>("registered_identifier") : ""),
    _action_type(getParam<std::string>("action_type")),
    _app(*parameters().getCheckedPointerParam<MooseApp *>("_moose_app", "In Action constructor")),
    _factory(_app.getFactory()),
    _action_factory(_app.getActionFactory()),
    _specific_task_name(parameters().isParamValid("task") ? getParam<std::string>("task") : ""),
    _awh(*parameters().getCheckedPointerParam<ActionWarehouse *>("awh")),
    _current_task(_awh.getCurrentTaskName()),
    _mesh(_awh.mesh()),
    _displaced_mesh(_awh.displacedMesh()),
    _problem(_awh.problem()),
    _executioner(_awh.executioner())
{
}
