function [Y,Z] = force(X,iter)

% euclidiana
global xx;
xx = X;

N = size(X,1);

%-----------------------------%
% Nearest-Neighbor Projection %
%-----------------------------%

% projeta os dois primeiros pontos preservando a distancia do espaço
% original
Y = zeros(N,2);
Y(1,:) = [0 0];
Y(2,:) = [dist(1,2) 0];

num_projected_pts = 2;

% para cada ponto x = X(i,:) ainda não projetado
for i = num_projected_pts+1:size(X,1)
  x = X(i,:);
  projected_pts = X(1:num_projected_pts,:);
  % calcula kNN (k=2) com relacao ao ponto x (ie, mais proximos de x) entre
  % os pontos de X que ja foram projetados. retorna p = X(idx(1),:) e q =
  % X(idx(2),:) (pontos mais proximos)
  idx = knnsearch(x,projected_pts,2);
  p = X(idx(1),:);
  q = X(idx(2),:);
  % calcula a intersecao entre o circulo de centro p' = Y(idx(1),:) e
  % raio d(x,p) e o circulo de centro q' = Y(idx(2),:) e raio d(x,q)
  r1 = dist(i,idx(1)); %r1 = dist(x,p);
  r2 = dist(i,idx(2)); %r2 = dist(x,q);
  plin = Y(idx(1),:);
  qlin = Y(idx(2),:);
  % intersecao
  Y(i,:) = intersection_circle(plin, r1, qlin, r2);
  num_projected_pts = num_projected_pts + 1;
end

% retorna a projecao NNP
Z = Y;

% plot NNP
%subplot(1,3,1);
%plot3(X(:,1),X(:,2),X(:,3),'o');
%subplot(1,3,2);
%plot(Y(:,1),Y(:,2),'o');

%--------------%
% Force Scheme %
%--------------%

for k = 1:iter % iteracoes

  % calcula a maior e menor distancias em X
  dmin = bitmax;
  dmax = -1;
  for i = 1:size(X,1)
    for j = i:size(X,1)
      if (i ~= j)
        d = dist(i,j); %dist(X(i,:),X(j,:));
        if (d > dmax)
          dmax = d;
        end
        if (d < dmin)
          dmin = d;
        end
      end
    end
  end
  diff_max_min = dmax - dmin;
  
  % para cada x'
  for i = 1:size(Y,1)
    x = X(i,:);
    xlin = Y(i,:);
    % para cada q' ~= x'
    for j = 1:size(Y,1)
      q = X(j,:);
      qlin = Y(j,:);
      if (i ~= j)
        % calcula a direcao v
        v = qlin-xlin;
        %delta = (dist(x,q)-dmin) / diff_max_min;
        delta = (dist(i,j)-dmin) / diff_max_min;
        delta = delta - norm(xlin-qlin);
        % move q' = Y(j,:) na direcao de v por uma fracao delta
        Y(j,:) = qlin + delta/1000 * v;
      end
    end
  end

end % fim iteracao

% plot Force
%subplot(1,3,3);
%plot(Y(:,1),Y(:,2),'o');

function d = dist(i,j)
  global xx; % euclidiana
  d = norm(xx(i,:)-xx(j,:)); % euclidiana

