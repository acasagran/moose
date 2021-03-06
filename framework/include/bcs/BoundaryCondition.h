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

#ifndef BOUNDARYCONDITION_H
#define BOUNDARYCONDITION_H

// MOOSE
#include "MooseObject.h"
#include "SetupInterface.h"
#include "MooseVariable.h"
#include "ParallelUniqueId.h"
#include "MooseArray.h"
#include "FunctionInterface.h"
#include "UserObjectInterface.h"
#include "TransientInterface.h"
#include "PostprocessorInterface.h"
#include "GeometricSearchInterface.h"
#include "BoundaryRestrictableRequired.h"
#include "Assembly.h"
#include "Restartable.h"
#include "ZeroInterface.h"
#include "MeshChangedInterface.h"

// libMesh
#include "libmesh/elem.h"
#include "libmesh/vector_value.h"
#include "libmesh/tensor_value.h"
#include "libmesh/numeric_vector.h"

// Forward declerations
class MooseVariable;
class MooseMesh;
class Problem;
class SubProblem;
class SystemBase;
class BoundaryCondition;

template<>
InputParameters validParams<BoundaryCondition>();

/**
 * Base class for creating new types of boundary conditions
 *
 */
class BoundaryCondition :
  public MooseObject,
  public BoundaryRestrictableRequired,
  public SetupInterface,
  public FunctionInterface,
  public UserObjectInterface,
  public TransientInterface,
  public PostprocessorInterface,
  public GeometricSearchInterface,
  public Restartable,
  public ZeroInterface,
  public MeshChangedInterface
{
public:

  /**
   * Class constructor.
   * @param name The name of the boundary condition object
   * @param parameters The InputParameters for the object
   */
  BoundaryCondition(const InputParameters & parameters);
  BoundaryCondition(const std::string & deprecated_name, InputParameters parameters); // DEPRECATED CONSTRUCTOR

  /**
   * Gets the variable this BC is active on
   * @return the variable
   */
  MooseVariable & variable();

  /**
   * Get a reference to the subproblem
   * @return Reference to SubProblem
   */
  SubProblem & subProblem();

  /**
   * Hook for turning the boundary condition on and off.
   *
   * It is not safe to use variable values in this function, since (a) this is not called inside a quadrature loop,
   * (b) reinit() is not called, thus the variables values are not computed.
   * NOTE: In NodalBC-derived classes, we can use the variable values, since renitNodeFace() was called before calling
   * this method. However, one has to index into the values manually, i.e. not using _qp.
   * @return true if the boundary condition should be applied, otherwise false
   */
  virtual bool shouldApply();

protected:

  /// Reference to SubProblem
  SubProblem & _subproblem;

  /// Reference to FEProblem
  FEProblem & _fe_problem;

  /// Reference to SystemBase
  SystemBase & _sys;

  /// Thread id
  THREAD_ID _tid;

  /// Reference to assembly
  Assembly & _assembly;

  /// variable this BC works on
  MooseVariable & _var;

  /// Mesh this BC is defined on
  MooseMesh & _mesh;
};

#endif /* BOUNDARYCONDITION_H */
