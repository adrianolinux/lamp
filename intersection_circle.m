% teste
%r1 = randi(100);
%r2 = randi(100);
%p = randi(10) * randn(1,2);
%q = randi(10) * randn(1,2);
%I = intersection_circle(p, r1, q, r2);
%hold on;
%plot(p(1), p(2), 'b*');
%plot(q(1), q(2), 'r*');
%t = linspace(0, 2*pi, 50);
%plot(r1*cos(t)+p(1), r1*sin(t)+p(2), 'b');
%plot(r2*cos(t)+q(1), r2*sin(t)+q(2), 'r');
%plot(I(1), I(2), 'ko');
%hold off;

% http://stackoverflow.com/questions/3349125/circle-circle-intersection-points
function R = intersection_circle(p, r1, q, r2)
  d = norm(p-q);
  if (r1+r2 < d)
    extreme_c1 = p + r1 * (q-p) / d;
    extreme_c2 = q + r2 * (p-q) / d;
    R = (extreme_c1 + extreme_c2) / 2;
  elseif (abs(r1-r2) > d)
    if (r1-r2 > d)
      v = q-p;
    else
      v = p-q;
    end
    extreme_c1 = p + r1 * v / d;
    extreme_c2 = q + r2 * v / d;
    R = (extreme_c1 + extreme_c2) / 2;
  else
    a = (r1^2 - r2^2 + d^2) / (2*d);
    h = sqrt(r1^2 - a^2);
    P = p + (a * (q-p) / d);
    R = [P(1) + h * (q(2)-p(2)) / d
         P(2) - h * (q(1)-p(1)) / d];
    %R = [P(1) - h * (q(2)-p(2)) / d
    %     P(2) + h * (q(1)-p(1)) / d];
  end

