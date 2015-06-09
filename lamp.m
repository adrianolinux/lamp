%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LAMP                                                               %
% Adriano Oliveira Barbosa                                           %
% barbosa.aob@gmail.com                                              %
% 3 de novembro de 2012                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% os conjuntos sao matrizes n x d, onde d eh a dimensao dos dados    %
% e n a quantidade de pontos no data set                             %
% X : conjunto de dados                                              %
% Xs: conjunto com os pontos de controle                             %
% Ys: conjunto com as imagens dos pontos de controle                 %
% retorna os pontos projetados na matriz Y n x p, onde p eh a        %
% dimensao do espaco visual                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Y = lamp(X,Xs,Ys)
  [n,d] = size(X); % d=dimensao dos dados, n=tamanho do data set
  [k,a] = size(Xs); % k=tamanho do conjunto de pto de controle
  p = size(Ys,2); % p=dimensao do espaco visual
  Y = zeros(n,p);
  if d ~= a
    display('Erro: dimensao de X e Xs devem ser iguais');
  end
  
  for pto = 1:n
    % calculo dos pesos alpha
    alpha = zeros(1,k);
    for i = 1:k
      % verifica se o ponto a ser projetado eh um ponto de controle
      % evita divisao por zero
      if norm(Xs(i,:)-X(pto,:))
        alpha(i) = realmax('single'); % nao funcionou com realmax('double')
      else
        alpha(i) = 1 / norm( Xs(i,:)-X(pto,:) )^2;
      end
    end
    
    % calculo de x~ e y~ (eq 3)
    xtil = zeros(1,d);
    ytil = zeros(1,p);
    for i = 1:k
      xtil = xtil + alpha(i)*Xs(i,:);
      ytil = ytil + alpha(i)*Ys(i,:);
    end
    xtil = xtil / sum(alpha);
    ytil = ytil / sum(alpha);
    
    A = zeros(k,d);
    B = zeros(k,p);
    xchapel = zeros(k,d);
    ychapel = zeros(k,p);
    % calculo dos x^ e y^, entradas de A e B (eq 6)
    for i = 1:k
      xchapel(i,:) = Xs(i,:) - xtil;
      ychapel(i,:) = Ys(i,:) - ytil;
      A(i,:) = sqrt(alpha(i))*xchapel(i,:)';
      B(i,:) = sqrt(alpha(i))*ychapel(i,:)';
    end
    
    [U,~,V] = svd(A'*B); % (eq 7)
    % VV eh a matriz V completada ate o tamanho de U com zeros
    VV = zeros(d,p); % size(U)=d, pelo SVD
    for i = 1:p % size(V)=p, pelo SVD
      VV(i,1:p) = V(i,:);
    end
    M = U*VV; % (eq 7)

    Y(pto,:) = (X(pto,:)-xtil)*M + ytil; % (eq 8)
  end

