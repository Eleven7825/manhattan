% build the traffic system in Manhattan

global Na Ns initNc cararr L;
aves = cell(1,Na);
strs = cell(1,Ns);
for i = 1:Na; aves{i} = {}; end % initialize for avenues
for i = 1:Ns; strs{i} = {}; end % initialze for streets

% initialize the cars in Manhattan
if initNc >=1
    
    while size(cararr,2)<=initNc
        car = Car(Na,Ns,L);
        loc = car.depart;
        while any(all(cararr==loc)) % if the new generated loc already exist
            car = Car(Na,Ns,L);
            loc = car.depart;
        end
        cararr = [cararr,loc];
        
        if randi(2)==1 % half chance to put this car on the Avenue
            aves{loc(2,1)+1} = [aves{loc(2,1)+1},car];
        else           % another half chance to put it on the street
            strs{loc(1,1)+1} = [strs{loc(1,1)+1},car];
        end
    end
end


