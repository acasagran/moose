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

#include "MeshModifier.h"

template<>
InputParameters validParams<MeshModifier>()
{
  InputParameters params = validParams<MooseObject>();

  params.registerBase("MeshModifier");

  return params;
}

MeshModifier::MeshModifier(const InputParameters & parameters) :
    MooseObject(parameters),
    Restartable(parameters, "MeshModifiers"),
    _mesh_ptr(NULL)
{
}

MeshModifier::~MeshModifier()
{
}


// DEPRECATED CONSTRUCTOR
MeshModifier::MeshModifier(const std::string & deprecated_name, InputParameters parameters) :
    MooseObject(deprecated_name, parameters),
    Restartable(parameters, "MeshModifiers"),
    _mesh_ptr(NULL)
{
}
