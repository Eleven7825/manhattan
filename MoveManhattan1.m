% move the cars in the city in dt time

function [aves,strs] = MoveManhattan1(aves,strs)
global dt vmax L dmax dmin Ns Na;
tol = vmax*dt; % the tolerance considering the two points to be the same

%% Dealing with avenues
for i = 1:length(aves)
    ave = aves{i};% i is the index for the avenue
    
    if isempty(ave)
        continue
    end
    
    locs = [aves{i}.loc];
    locs = locs(1,:); % all the location of the car on this road
    % sorting the locs and aves{i}
    [locs, indx] = sort(locs);
    ave = ave(indx);
    aves{i} = ave;
    delList = []; % the list of element to be deleted
    dir = 1-2*mod(i,2);
    
    for j = 1: length(locs)
        car = ave(j); % the car on ave i and is j's car
        % check whether the car arrives the destiny
        direc = car.destin*L-car.loc; % vector pointing to the destiny
        
        if sum(abs(direc))<tol % if the car reaches the destination
            delList(end+1) = j;
            continue
        end
        
        % calculate the distance to the front car
        if (j+dir<=length(locs))&&(j+dir>0)
            % if the front car exists
            d = abs(locs(j)-locs(j+dir)); 
        else
            d = dmax;
        end
        
        if (mod(locs(j),L)>L-tol)||(mod(locs(j),L)<tol) % if the cars arrives at the cross
            r = round(locs(j)/L)+1; % r: the index of the street at the cross
            dir1 = 2*mod(r,2)-1;
%             if (r==Ns&&i==1)||(r==1&&i==Na)||(r==Ns&&i==Na)||(r==1&&i==1)
%                 % arriving at the four conners
%                 delList(end+1) = j; % delete this car on the str
%                 continue
%             end
            
            if (r==Ns && dir==1) || (r==1 && dir==-1) 
                % if car goes beyond the bound of the ave
                car.loc = [(r-1)*L;(i-1)*L+(dir1)*(tol+v(d)*dt)];
                delList(end+1) = j; % delete this car on the ave
                strs{r} = [strs{r},car]; % reappearing on the str 
                continue
            end
            
            if (dir*direc(1)<(dir1)*direc(2))
                % if the car has a higher tendency to go on str 
                
                % decide whether there is car on the other way:
                if ~isempty(strs{r})
                    sloc = [strs{r}.loc];sloc = sloc(2,:);
                    sspeed = [strs{r}.speed]; 
                    sspeed = sspeed(sloc>(sloc>car.loc(2)-dmin)&(sloc<car.loc(2)+dmin));
                    % speed of cars in the cross zoom on the other road
                    if any((sloc>car.loc(2)-dmin)&(sloc<car.loc(2)+dmin))&&...
                            (mod(locs(j),L)~=0)&&~any(sspeed==0)
                        % if any car is in the entering zoom on the other road
                        aves{i}(j).speed = v(abs(car.loc(1)-(r-1)*L));
                        aves{i}(j).loc = [locs(j)+dt*aves{i}(j).speed*dir;(i-1)*L]; 
                        continue
                    end
                end
                
                % otherwise, enter the other road:
                car.loc = [(r-1)*L;(i-1)*L];           
                delList(end+1) = j; % delete this car on the ave
                strs{r} = [strs{r},car]; % reappearing on the street
            else % else: move the car out of the cross zone
                aves{i}(j).loc = [locs(j)+(dt*v(d)+tol)*dir;(i-1)*L]; 
            end
        else % if not at the cross, continue going
            aves{i}(j).speed = v(d);
            aves{i}(j).loc = [locs(j)+dt*v(d)*dir;(i-1)*L];
        end
        
    end
    if ~isempty(delList)
        aves{i}(delList) = [];
    end
end

%% Dealing with streets
for i = 1:length(strs)
    str = strs{i};% i is the index for the street
    
    if isempty(str)
        continue
    end
    locs = [strs{i}.loc];
    locs = locs(2,:); % all the location of the car on this road
    % sorting the locs and strs{i}
    [locs, indx] = sort(locs);
    str = str(indx);
    strs{i} = str;
    delList = []; % the list of element to be deleted
    dir = 2*mod(i,2)-1;
    
    for j = 1: length(locs)
        car = str(j); % the car on str i and is j's car
        % check whether the car arrives the destiny
        direc = car.destin*L-car.loc; % vector pointing to the destiny
        if sum(abs(direc))<tol % if the car reaches the destination
            delList(end+1) = j;
            continue
        end
        
        % calculate the distance to the front car
        if (j+dir<=length(locs))&&(j+dir>0)
            % if the front car exists
            d = abs(locs(j)-locs(j+dir)); 
        else
            d = dmax;
        end
        
        if (mod(locs(j),L)>L-tol)||(mod(locs(j),L)<tol) % if the cars arrives at the cross
            r = round(locs(j)/L)+1; % r: the index of the ave at the cross
            dir1 = 1-2*mod(r,2);
            
%             if (r==Na&&i==1)||(r==1&&i==Ns)||(r==Na&&i==Ns)||(r==1&&i==1)
%                 % arriving at the four conners
%                 delList(end+1) = j; % delete this car on the str
%                 continue
%             end
            
            if  (r==Na && (dir)==1) || (r==1 && (dir)==-1)
                % if car goes beyond the bound of the street
                car.loc = [(i-1)*L+(dir1)*(tol+v(d)*dt);(r-1)*L];
                delList(end+1) = j; % delete this car on the str
                aves{r} = [aves{r},car]; % reappearing on the ave
                continue
            end
            
            if (dir1)*direc(1)>(dir)*direc(2)
                % if the car has a higher tendency to go on ave 
                
                % decide whether there is car on the other way:
                if ~isempty(aves{r})
                    aloc = [aves{r}.loc];aloc = aloc(1,:);
                    aspeed = [aves{r}.speed]; 
                    aspeed = aspeed(aloc>(aloc>car.loc(1)-dmin)&(aloc<car.loc(1)+dmin));
                    if any((aloc>car.loc(1)-dmin)&(aloc<car.loc(1)+dmin))&&...
                            (mod(locs(j),L)~=0)&&~any(aspeed==0)
                        % if any car is in the entering zoom on the other road
                        strs{i}(j).speed = v(abs(car.loc(2)-(r-1)*L));
                        strs{i}(j).loc = [(i-1)*L;locs(j)+dt*strs{i}(j).speed*(dir)]; 
                        continue
                    end
                end
                
                car.loc = [(i-1)*L;(r-1)*L];
                delList(end+1) = j; % delete this car on the str
                aves{r} = [aves{r},car]; % reappearing on the ave
            
            else % else: move the car out of the cross zone
                strs{i}(j).loc = [(i-1)*L;locs(j)+(dt*v(d)+tol)*(dir)];
            end
        else % if not at the cross, continue going
            strs{i}(j).speed = v(d);
            strs{i}(j).loc = [(i-1)*L;locs(j)+dt*v(d)*(dir)];
        end
        
    end
    if ~isempty(delList)
        strs{i}(delList) = [];
    end
end
end