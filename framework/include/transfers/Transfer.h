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

#ifndef TRANSFER_H
#define TRANSFER_H

// Moose
#include "ParallelUniqueId.h"
#include "MooseObject.h"
#include "InputParameters.h"
#include "SetupInterface.h"
#include "MooseEnum.h"
#include "Restartable.h"

// libMesh
#include "libmesh/system.h"

class Transfer;
class SubProblem;
class FEProblem;
class SystemBase;

template<>
InputParameters validParams<Transfer>();

/**
 * Base class for all Transfer objects.
 *
 * Transfers are objects that take values from one Application
 * or System and put them in another Application or System.
 */
class Transfer :
  public MooseObject,
  public SetupInterface,
  public Restartable
{
public:
  Transfer(const InputParameters & parameters);
  Transfer(const std::string & deprecated_name, InputParameters parameters); // DEPRECATED CONSTRUCTOR
  virtual ~Transfer() {}

  /**
   * Execute the transfer.
   */
  virtual void execute() = 0;

  /**
   * Method called at the beginning of the simulation for checking integrity or doing
   * one-time setup.
   */
  virtual void initialSetup() {}

protected:
  /**
   * Small helper function for finding the system containing the variable.
   *
   * Note that this implies that variable names are unique across all systems!
   *
   * @param es The EquationSystems object to be searched.
   * @param var_name The name of the variable you are looking for.
   */
  System * find_sys(EquationSystems & es, const std::string & var_name) const;

  SubProblem & _subproblem;
  FEProblem & _fe_problem;
  SystemBase & _sys;

  THREAD_ID _tid;

public:
  const static Number OutOfMeshValue;
};

#endif /* TRANSFER_H */
