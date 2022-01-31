function dx = DF_adjoint(x, dy, TEs)
% x    : N1 x N2 x 2
% dy   : Nk x Nc x Ne
% dx   : N1 x N2 x 2
%
% Written by Nam Gyun Lee
% Email: nmgyunl@usc.edu, ggang56@gmail.com (preferred)
% Started: 05/12/2021, Last modified: 05/15/2021

%--------------------------------------------------------------------------
% Calculate dx = DF(x)^H * dy (N1 x N2 x 2)
%--------------------------------------------------------------------------
N1 = size(x,1);
N2 = size(x,2);
Ne = length(TEs);

dx = complex(zeros(N1, N2, 2, 'double', 'gpuArray'));
for m = 1:Ne
    %----------------------------------------------------------------------
    % Calculate psi_m (N1 x N2)
    %----------------------------------------------------------------------
    conj_psi_m = conj(exp(1j * 2 * pi * x(:,:,2) * TEs(m)));

    %----------------------------------------------------------------------
    % Calculate diag(conj(psi_m)) * dy_{m} (N1 x N2)
    %----------------------------------------------------------------------
    dx(:,:,1) = dx(:,:,1) + conj_psi_m .* dy(:,:,m);

    %----------------------------------------------------------------------
    % Calculate diag(conj(rho)) * diag(conj(psi_m)) * dy_{m} (N1 x N2)
    %----------------------------------------------------------------------
    dx(:,:,2) = dx(:,:,2) + (-1j * 2 * pi * TEs(m)) * (conj(x(:,:,1)) .* conj_psi_m .* dy(:,:,m));
end

dx(:,:,2) = real(dx(:,:,2));

end