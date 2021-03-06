#include "CHCpldPFCTrad.h"

template<>
InputParameters validParams<CHCpldPFCTrad>()
{
  InputParameters params = validParams<CHSplitVar>();
  params.addRequiredParam<MaterialPropertyName>("coeff_name", "Name of coefficient");
  return params;
}

CHCpldPFCTrad::CHCpldPFCTrad(const InputParameters & parameters) :
    CHSplitVar(parameters),
    _coeff(getMaterialProperty<Real>("coeff_name"))
{
}

RealGradient
CHCpldPFCTrad::precomputeQpResidual()
{
  RealGradient grad_cpldvar = CHSplitVar::precomputeQpResidual();
  return  _coeff[_qp]*grad_cpldvar;
}

Real
CHCpldPFCTrad::computeQpOffDiagJacobian(unsigned int jvar)
{
  Real grphi_grtst = CHSplitVar::computeQpOffDiagJacobian(jvar);
  return _coeff[_qp]*grphi_grtst;
}


// DEPRECATED CONSTRUCTOR
CHCpldPFCTrad::CHCpldPFCTrad(const std::string & deprecated_name, InputParameters parameters) :
    CHSplitVar(deprecated_name, parameters),
    _coeff(getMaterialProperty<Real>("coeff_name"))
{
}
