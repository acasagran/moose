/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/


#include "RichardsHalfGaussianSink.h"
#include "Material.h"

#include <iostream>


template<>
InputParameters validParams<RichardsHalfGaussianSink>()
{
  InputParameters params = validParams<IntegratedBC>();
  params.addRequiredParam<Real>("max", "Maximum of the flux (measured in kg.m^-2.s^-1).  Flux out = max*exp((-0.5*(p - centre)/sd)^2) for p<centre, and Flux out = max for p>centre.  Note, to make this a source rather than a sink, let max<0");
  params.addRequiredParam<Real>("sd", "Standard deviation of the Gaussian (measured in Pa).  Flux out = max*exp((-0.5*(p - centre)/sd)^2) for p<centre, and Flux out = max for p>centre.");
  params.addRequiredParam<Real>("centre", "Centre of the Gaussian (measured in Pa).  Flux out = max*exp((-0.5*(p - centre)/sd)^2) for p<centre, and Flux out = max for p>centre.");
  params.addParam<FunctionName>("multiplying_fcn", 1.0, "If this function is provided, the flux will be multiplied by this function.  This is useful for spatially or temporally varying sinks");
  params.addRequiredParam<UserObjectName>("richardsVarNames_UO", "The UserObject that holds the list of Richards variable names.");
  return params;
}

RichardsHalfGaussianSink::RichardsHalfGaussianSink(const InputParameters & parameters) :
    IntegratedBC(parameters),
    _maximum(getParam<Real>("max")),
    _sd(getParam<Real>("sd")),
    _centre(getParam<Real>("centre")),
    _m_func(getFunction("multiplying_fcn")),
    _richards_name_UO(getUserObject<RichardsVarNames>("richardsVarNames_UO")),
    _pvar(_richards_name_UO.richards_var_num(_var.number())),
    _pp(getMaterialProperty<std::vector<Real> >("porepressure")),
    _dpp_dv(getMaterialProperty<std::vector<std::vector<Real> > >("dporepressure_dv"))
{}

Real
RichardsHalfGaussianSink::computeQpResidual()
{
  Real test_fcn_f = _test[_i][_qp]*_m_func.value(_t, _q_point[_qp]);

  if (_pp[_qp][_pvar] >= _centre)
    return test_fcn_f*_maximum;
  else
    return test_fcn_f*_maximum*exp(-0.5*std::pow((_pp[_qp][_pvar] - _centre)/_sd, 2));
}

Real
RichardsHalfGaussianSink::computeQpJacobian()
{
  Real test_fcn_f = _test[_i][_qp]*_m_func.value(_t, _q_point[_qp]);

  if (_pp[_qp][_pvar] >= _centre)
    return 0.0;
  else
    return -test_fcn_f*_maximum*(_pp[_qp][_pvar] - _centre)/std::pow(_sd, 2)*exp(-0.5*std::pow((_pp[_qp][_pvar] - _centre)/_sd, 2))*_phi[_j][_qp]*_dpp_dv[_qp][_pvar][_pvar];
}

Real
RichardsHalfGaussianSink::computeQpOffDiagJacobian(unsigned int jvar)
{
  if (_richards_name_UO.not_richards_var(jvar))
    return 0.0;
  unsigned int dvar = _richards_name_UO.richards_var_num(jvar);

  Real test_fcn_f = _test[_i][_qp]*_m_func.value(_t, _q_point[_qp]);

  if (_pp[_qp][_pvar] >= _centre)
    return 0.0;
  else
    return -test_fcn_f*_maximum*(_pp[_qp][_pvar] - _centre)/std::pow(_sd, 2)*exp(-0.5*std::pow((_pp[_qp][_pvar] - _centre)/_sd, 2))*_phi[_j][_qp]*_dpp_dv[_qp][_pvar][dvar];
}


// DEPRECATED CONSTRUCTOR
RichardsHalfGaussianSink::RichardsHalfGaussianSink(const std::string & deprecated_name, InputParameters parameters) :
    IntegratedBC(deprecated_name, parameters),
    _maximum(getParam<Real>("max")),
    _sd(getParam<Real>("sd")),
    _centre(getParam<Real>("centre")),
    _m_func(getFunction("multiplying_fcn")),
    _richards_name_UO(getUserObject<RichardsVarNames>("richardsVarNames_UO")),
    _pvar(_richards_name_UO.richards_var_num(_var.number())),
    _pp(getMaterialProperty<std::vector<Real> >("porepressure")),
    _dpp_dv(getMaterialProperty<std::vector<std::vector<Real> > >("dporepressure_dv"))
{}
