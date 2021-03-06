

function [] = Electron_1D(velocity0, position0, T, num_part, elastic)

    global C
    
    C.q_0 = 1.60217653e-19;             % electron charge
    C.hb = 1.054571596e-34;             % Dirac constant
    C.h = C.hb * 2 * pi;                % Planck constant
    C.m_0 = 9.10938215e-31;             % electron mass
    C.kb = 1.3806504e-23;               % Boltzmann constant
    C.eps_0 = 8.854187817e-12;          % vacuum permittivity
    C.mu_0 = 1.2566370614e-6;           % vacuum permeability
    C.c = 299792458;                    % speed of light
    C.g = 9.80665; %metres (32.1740 ft) per s²
    
    
    %Durration of simulation
    t = 1:T;
    
    %arrays for position and velocity
    velocity = zeros(num_part,T);
    position = zeros(num_part,T);
    
    %initialize initial position and velocity
    velocity(:,1) = velocity0;
    position(:,1) = position0;
    
    v_group = 1/num_part* sum(velocity(:,1));
    
    %time since last collision
    delta_t = zeros(1, num_part);
    
    %desired force
    force = 5; %kept constant for simplicity
    
   
    figure    
    
    for n = 2 : T                           % Duration of simulation
       
        for m = 1 : num_part                % For each of the simulated particles
            
        %Velocity and position continuously update
        velocity(m, n) = force/C.m_0 *delta_t(m) + velocity(m, n-1);
        position(m, n) = force/C.m_0 *delta_t(m)^2 / 2 + velocity(m, n-1) * delta_t(m) + position (m, n-1);
        
        %Group Velocity
        v_group = 1/num_part * sum(velocity(:,n));
        
        %Time since last collision updates
        delta_t(m) = delta_t(m) + 1;

        %5 in 100 chance of collision
        P = randi(100, 1);
        
        %when collision occurs
        if (P < 5)  
        delta_t(m) = 0;    %Time since last collision reset to zero
        
            if (elastic == 0)
                velocity(m, n) = -0.25 * velocity(m, n); %For inelastic
            
            else
                velocity(m, n) = 0; %Velocity reset to zero, for elastic
            end
        end
        
        %Live Plots
      
        row = (m-1)*3; %row or each subplot
        
   
        subplot(num_part,3 ,1 + row) 
        plot(t, velocity(m,:));
        title(sprintf('Particle # %d - Velocity', m))
        xlabel('Time')
        ylabel('Velocity')
        drawnow; %I like this better than holdon because it is faster
        
        subplot(num_part, 3, 2 + row) 
        plot(t, position(m,:));
        title(sprintf('Particle # %d - Postition', m))
        xlabel('Time')
        ylabel('Position')
        drawnow;
      
        subplot(num_part, 3, 3 + row) 
        plot(position(m,:), velocity(m,:));
        title(sprintf('Particle # %d - Velocity vs Postition', m))
        xlabel('Position')
        ylabel('Velocity')
        drawnow;
        
        
        end
        
         
   
    end
    
    sgtitle(sprintf('Group Velocity: %d', v_group)); 
       
 
    
end
    
    