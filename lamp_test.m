clear all;
x = load('iris.data');
t = x(:,size(x,2));
x = x(:,1:size(x,2)-1);
n = size(x,1);

choice_size = sqrt(n);
random_choice = randperm(n);
random_choice = random_choice(1:choice_size);
xs = x(random_choice,:);
ty = t(random_choice);

tic
[ys,z] = force(xs,10);
display('Posicionamento dos pontos de controle: ');
toc

tic
y = lamp(x,xs,ys);
display('Projecao: ');
toc

% plot results
figure(1);
clf;
hold on;
plot(ys(ty == 1,1), ys(ty == 1,2), 'ro', 'MarkerSize', 15);
plot(ys(ty == 2,1), ys(ty == 2,2), 'go', 'MarkerSize', 15);
plot(ys(ty == 3,1), ys(ty == 3,2), 'bo', 'MarkerSize', 15);
plot(y(t == 1,1), y(t == 1,2), 'r.', ...
     y(t == 2,1), y(t == 2,2), 'g.', ...
     y(t == 3,1), y(t == 3,2), 'b.');
hold off;

