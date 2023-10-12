% Implementation of the popular cellular automaton model: Game of Life by John Conway.
% A cell remains alive if it has 2 or 3 live neighbors, and a dead cell becomes alive
% if it has exactly 3 neighbors. Otherwise, cells die or remain dead.
% Initial conditions are read from a data file. 
% To run this example, the following file is needed:
% - game1.txt
% Originally adapted from Benjamin Seibold (http://www.math.temple.edu/~seibold/)
% Edited and Simplified by Will Schenk

% To run the program, you just need to call the function:
game_of_life() 

function game_of_life() 
    %% Define the Agents 
    
    % Parameters
    n = [100,100]; % Number of cells per dimension. 
    
    filename = 'game1.txt';
    pos = [40,40]; % Position of object loaded from file (top corner).
    
    %% Define the Environment 
    
    % Construct initial configuration.
    F = zeros(n); % Initialize empty array.
    S = load_data_file(filename); % Load data file.
    % Add object to 2D array.
    F(pos(1)+(1:size(S,1)), pos(2)+(1:size(S,2))) = S; 
    
    % Initialization.
    shl1 = [n(1),1:n(1)-1]; shr1 = [2:n(1),1]; % Shift index vectors in dimension 1.
    shl2 = [n(2),1:n(2)-1]; shr2 = [2:n(2),1]; % Shift index vectors in dimension 2.
    
...

    %% Define the Agent-Environment Interaction 
    
    clf
    for j = 0:3000 % Time loop.

        % Plotting.
        imagesc(~F') % Plot array of cells.
        axis equal tight; colormap(gray)
        title(sprintf('Game of life after %d steps',j))
        pause(0.5) % Wait a bit (and a bit more initially).

        % Update rule.
        neighbors = F(shl1,shl2) + F(shl1,:) + F(shl1,shr2) + ...
            F(:,shl2) + F(:,shr2) + ...
            F(shr1,shl2) + F(shr1,:) + F(shr1,shr2);

        F = (F & (neighbors == 2 | neighbors == 3)) | ... 
            (~F & neighbors == 3); % Update cells based on neighbors.
    end

end

function S = load_data_file(filename)
    % Read the data file "filename" and assign the information to 2D array "S".
    
    fid = fopen(filename,'r'); % Open data file for reading.
    data = double(fscanf(fid,'%c',inf)); % Read data as single string.
    fclose(fid); % Close file.
    
    data = [10, data, 10]; % Add space at the beginning and end of string.
    ind_data = data == 42 | data == 46; % Indices where actual cell data is stored.
    i_start = find(diff(ind_data) == 1); % Beginning index of row.
    i_end = find(diff(ind_data) == -1); % End index of row.
    row_length = i_end(1) - i_start(1); % Length of each row in data.
    
    data = data(ind_data); % Remove non-cell information.
    data = data == 42; % Convert data to logical for cell states.
    S = reshape(data, row_length, []); % Store object as 2D array.
end 