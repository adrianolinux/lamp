function Y = force(varargin)

% force.m - Build a 2D projection using Force Scheme.
%
% y = force(x,iter,frac);
%
%   x is a matrix N x D containing the data organized by rows. N is the
%   number of instances and D is the dimension of the data
%   iter is the number of iterations (optional, default is 50)
%   frac is the fraction of delta (optional, default is 8)
%
%   y is a matrix N x 2 containing the projected data in R^2.

tol = 1e-6;

switch (nargin)
  case 1
    X = varargin{1};
    iter = 50;
    fraction = 8;
  case 2
    X = varargin{1};
    iter = varargin{2};
    fraction = 8;
  case 3
    X = varargin{1};
    iter = varargin{2};
    fraction = varargin{3};
  otherwise
    disp('Force ERROR: wrong number of parameters');
    return;
end

N = size(X,1);

% inicializacao
Y(:,1) = rand(N,1);
Y(:,2) = rand(N,1);

%--------------%
% Force Scheme %
%--------------%

% distancia em R^n
distRn = dist(X');

idx = randperm(N);

for k = 1:iter % iteracoes

  % para cada x'
  for i = 1:N
    inst1 = idx(i);

    % para cada q' ~= x'
    for j = 1:N
      inst2 = idx(j);

      if (inst1 ~= inst2)
        % calcula a direcao v
        v = Y(inst2,:)-Y(inst1,:);
        distR2 = hypot(v(1),v(2));
        if (distR2 < tol)
          distR2 = tol;
        end
        delta = distRn(inst1,inst2) - distR2;
        delta = delta/fraction;
        v = v./distR2;
        % move q' = Y(j,:) na direcao de v por uma fracao delta
        Y(inst2,:) = Y(inst2,:) + delta*v;
      end
    end
  end

end % fim iteracao

