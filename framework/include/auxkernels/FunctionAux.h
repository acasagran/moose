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

#ifndef FUNCTIONAUX_H
#define FUNCTIONAUX_H

#include "AuxKernel.h"
#include "Function.h"

//Forward Declarations
class FunctionAux;

template<>
InputParameters validParams<FunctionAux>();

/**
 * Function auxiliary value
 */
class FunctionAux : public AuxKernel
{
public:
  /**
   * Factory constructor, takes parameters so that all derived classes can be built using the same
   * constructor.
   */
  FunctionAux(const InputParameters & parameters);
  FunctionAux(const std::string & deprecated_name, InputParameters parameters); // DEPRECATED CONSTRUCTOR

  virtual ~FunctionAux() {}

protected:
  virtual Real computeValue();

  /// Function being used to compute the value of this kernel
  Function & _func;
};

#endif // FUNCTIONAUX_H
