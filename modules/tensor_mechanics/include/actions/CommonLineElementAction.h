//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef COMMONLINEELEMENTACTION_H
#define COMMONLINEELEMENTACTION_H

#include "Action.h"

class CommonLineElementAction;

template <>
InputParameters validParams<CommonLineElementAction>();

/**
 * Store common line element action parameters
 */
class CommonLineElementAction : public Action
{
public:
  CommonLineElementAction(const InputParameters & parameters);

  virtual void act() override{};
};

#endif // COMMONLINEELEMENTACTION_H
