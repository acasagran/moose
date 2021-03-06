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

#ifndef PRESETBC_H
#define PRESETBC_H

#include "PresetNodalBC.h"

class PresetBC;

template<>
InputParameters validParams<PresetBC>();

/**
 * TODO:
 */
class PresetBC : public PresetNodalBC
{
public:
  PresetBC(const InputParameters & parameters);
  PresetBC(const std::string & deprecated_name, InputParameters parameters); // DEPRECATED CONSTRUCTOR

protected:
  virtual Real computeQpValue();

  const Real & _value;
};

#endif /* PRESETBC_H */
