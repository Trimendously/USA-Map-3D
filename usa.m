% Defines the start and end dates to read from the csv
startDate = datetime('01-Jan-00', 'Format', 'dd-MMM-yy', 'PivotYear', 2000);
endDate = datetime('31-Dec-23', 'Format', 'dd-MMM-yy', 'PivotYear', 2000);

% Via the banklist.csv file checks the count per state of failed banks
stateCounts = dataCompiler(startDate,endDate);

% Gets the screen size
screenSize = get(0, 'ScreenSize');

% Create a figure with the screen size
figure('Position', [screenSize(1), screenSize(2), screenSize(3), screenSize(4)]);
figHandle = gcf;

% Set the title for Figure 1
set(figHandle, 'Name', 'USA Bank Failures');
ax1 = subplot(1, 2, 1);  % Left section for the plot
ax2 = subplot(1, 2, 2);  % Right section for the legend

% Plots the states in the left section
plotBackground = [1, 1, 1]; % RGB values
axes(ax1);
ax1.Color = plotBackground;
hold on;

% Reads state boundaries data
states = shaperead('usastatelo', 'UseGeoCoords', true, 'BoundingBox', [-180, -90; 180, 90]);

% Geolocation to cartesian
[x,y] = lambert(states);

% Creates a color map based on the number of states
colorMap = colormap(colorcube(numel(states)));
lighterMap = brighten(colorcube,0.7);
colorMapLighter = colormap(lighterMap);

% Creates an empty cell array to store legend labels
legendLabels = cell(numel(states), 1);

% Plots each state individually 
for i = 1:numel(states)
    x_state = x{i};
    y_state = y{i};
    
    % Initializes the logical indices for valid coordinates (excludes Nan)
    valid_coords = ~isnan(x_state) & ~isnan(y_state);
    nan_coords = isnan(x_state) | isnan(y_state);

    x_coord = x_state(~nan_coords);
    y_coord = y_state(~nan_coords);
    z_coord = ones(size(x_state(valid_coords)));
    
    % Plots the 3d layers for each state    
    %fprintf('State: %s', states(i).Name);  
    if isKey(stateCounts, states(i).Name)
        %fprintf('- State Count: %d\n', stateCounts(states(i).Name));
        displayName = [states(i).Name, ' (Count: ', num2str(stateCounts(states(i).Name)), ')'];
        % Added a plus 1 if we decide to keep the base map
        for j = 1:(stateCounts(states(i).Name)+1)
            if j == 1
                patch(ax1, x_coord, y_coord, j*z_coord, colorMap(i, :), 'DisplayName', displayName);  
            else
                patch(ax1, x_coord, y_coord, j*z_coord, colorMap(i, :), 'DisplayName', displayName);  
            end
        end
    else
        %fprintf('- State Count: %d\n', 0);
        displayName = [states(i).Name, ' (Count: ', num2str(0), ')'];
        % If the base map is kept
        patch(ax1, x_coord, y_coord, z_coord, colorMap(i, :), 'DisplayName', displayName);       
    end
    
    % Store the legend label for this state
    legendLabels{i} = displayName;
end

% Plot Properties
xlabel('X');
ylabel('Y');
zlabel('Bank Failures');
title('USA Bank Failures');
rotate3d on;
ax = gca;  % Get the current axes
ax.XAxis.Visible = 'off';
ax.YAxis.Visible = 'off';

% Customizes the legend in the right section
axes(ax2);
axis off;  % Hides axes in the legend section

% Displays a custom legend using annotations
annotation('textbox', [0.75, 0.9, 0.2, 0.05], 'String', 'Legend', 'EdgeColor', 'none', 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');

for i = 1:numel(legendLabels)
    text_y_position = 0.9 - i* 0.015;  % Adjusted y_position for single-spaced vertical layout
    rectangle_y_position = 0.92 - i * 0.015;

    % Create a small square with the same color
    annotation('rectangle', [0.786718750000007, rectangle_y_position, 0.0113281249999948, 0.0109314456035766], 'Color', colorMap(i,:), 'FaceColor', colorMap(i,:));
    
    % Create the legend entry text
    annotation('textbox', [0.8, text_y_position, 0.2, 0.05], 'String', legendLabels{i}, 'EdgeColor', 'none', 'FontSize', 10, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle');
end

% Turns geolocation into cartesian coordinates
function [x,y] = lambert(states)
    % Lambert Conformal Conic projection parameters for USA
    standardParallel1 = 33;
    standardParallel2 = 45;
    centralMeridian = -96;
    originLat = 39;
    
    % Creates a Lambert Conformal Conic projection structure
    proj = defaultm('lambertstd');
    proj.origin = [originLat, 0];
    proj.mapparallels = [standardParallel1, standardParallel2];
    proj.nparallels = 2;
    proj.falseeasting = 0;
    proj.falsenorthing = 0;
    proj.scalefactor = 1;
    proj.falseeasting = 0;
    proj.central_meridian = centralMeridian;
    
    % Initializes arrays to store Cartesian coordinates for each state
    x = cell(numel(states), 1);
    y = cell(numel(states), 1);
    
    % Converts the latitudes and longitudes to Cartesian coordinates for each state
    for i = 1:numel(states)
        if strcmp(states(i).Name, 'Alaska')
            % Handle Alaska separately with its own Lambert projection
            [x{i}, y{i}] = lambertAlaska(states(i));
        else
            [x{i}, y{i}] = projfwd(proj, states(i).Lat, states(i).Lon);
        end
    end
end

% Lambert projection for Alaska
function [x, y] = lambertAlaska(state)
    % Lambert Conformal Conic projection parameters for Alaska
    standardParallel1 = 55;
    standardParallel2 = 65;
    centralMeridian = -154;
    originLat = 50;
    
    % Creates a Lambert Conformal Conic projection structure for Alaska
    proj = defaultm('lambertstd');
    proj.origin = [originLat, 0];
    proj.mapparallels = [standardParallel1, standardParallel2];
    proj.nparallels = 2;
    proj.falseeasting = 0;
    proj.falsenorthing = 0;
    proj.scalefactor = 1;
    proj.falseeasting = 0;
    proj.central_meridian = centralMeridian;
    
    % Apply the projection to Alaska's coordinates
    [x, y] = projfwd(proj, state.Lat, state.Lon);
end

% Gets the amount of unique occurence of each state
function stateCounts = dataCompiler(startDate,endDate)
    data = readtable('banklist.csv');

    % Creates a map to convert state acronyms to full names for all 50 states
    stateAcronymToFull = containers.Map( ...
        {'AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA', ...
         'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD', ...
         'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', ...
         'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC', ...
         'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY'}, ...
        {'Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado', 'Connecticut', ...
         'Delaware', 'Florida', 'Georgia', 'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa', ...
         'Kansas', 'Kentucky', 'Louisiana', 'Maine', 'Maryland', 'Massachusetts', 'Michigan', ...
         'Minnesota', 'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada', 'New Hampshire', ...
         'New Jersey', 'New Mexico', 'New York', 'North Carolina', 'North Dakota', 'Ohio', 'Oklahoma', ...
         'Oregon', 'Pennsylvania', 'Rhode Island', 'South Carolina', 'South Dakota', 'Tennessee', ...
         'Texas', 'Utah', 'Vermont', 'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming'});

    numRows = size(data, 1);
    
    % Initializes a map to store the state counts
    stateCounts = containers.Map('KeyType', 'char', 'ValueType', 'double');
    
    for i = 1:numRows     
        % Adjusts the datetime object to have a pivot year of 2000
        currentDate = data.ClosingDate_(i) + years(2000);
        
        isWithinRange =  (currentDate >= startDate) & (currentDate <= endDate);

        currentStateAcronym = strtrim(data.State_{i});

        if isWithinRange
           % Checks if the state acronym is in the dictionary
            if isKey(stateAcronymToFull, currentStateAcronym)
                currentState = stateAcronymToFull(currentStateAcronym);

                % Update the count for the current state
                if isKey(stateCounts, currentState)
                    stateCounts(currentState) = stateCounts(currentState) + 1;
                else
                    stateCounts(currentState) = 1;
                end 
            else
                disp(['State acronym not found in the dictionary: ' currentStateAcronym]);
            end
        end   
    end
end

