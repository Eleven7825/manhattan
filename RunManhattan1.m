% Run manhattan

global Na Ns rate L dt initNc cararr dmin dmax vmax;
Na = 10;     % number of avenues
Ns = 10;     % number of streets
cararr = [Na+1;Ns+1];
rate = 0.75; % incoming rate
dt = 1;      % (second)
initNc = 10; % initial number of car in the city
L = 100; % the length of each block
dmin = 5; % distance within which car stops (meters)
dmax = 100; % distance above which cars goes at max speed (meters)
vmax = 5; % maximum speed (meters/second)
tmax = 10000; %time of simulation (seconds)
clockmax=ceil(tmax/dt);

% initialize the city and see it
BuildManhattan
ViewManhattan(aves,strs)

for i = 1:clockmax 
    if rand<rate*dt % generate a car if the rate satisfies
        [aves,strs] = addCar(aves,strs);
    end
    
    [aves,strs] = MoveManhattan1(aves,strs);
%     if mod(i,10)==0
        ViewManhattan(aves,strs)
        drawnow
%     end
end