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
plotBackground = [0, 0, 0]; % RGB values
axes(ax1);
ax1.Color = plotBackground;
hold on;

% Reads state boundaries data
states = shaperead('usastatelo', 'UseGeoCoords', true, 'BoundingBox', [-180, -90; 180, 90]);

% Geolocation to cartesian
[x,y] = lambert(states);


distinct_colors = [
    0.620, 0.125, 0.294;  % Alabama (Crimson)
    0.086, 0.317, 0.482;  % Alaska (Dark Blue)
    0.769, 0.102, 0.125;  % Arizona (Red)
    0.090, 0.184, 0.373;  % Arkansas (Navy Blue)
    0.839, 0.282, 0.098;  % California (Orange-Red)
    0.533, 0.172, 0.227;  % Colorado (Burgundy)
    0.137, 0.235, 0.423;  % Connecticut (Navy Blue)
    0.902, 0.160, 0.235;  % Delaware (Red)
    0.980, 0.349, 0.090;  % Florida (Orange)
    0.612, 0.086, 0.141;  % Georgia (Red)
    0.984, 0.502, 0.118;  % Hawaii (Orange)
    0.278, 0.486, 0.169;  % Idaho (Green)
    0.341, 0.360, 0.690;  % Illinois (Blue)
    0.075, 0.306, 0.267;  % Indiana (Green)
    0.502, 0.000, 0.149;  % Iowa (Dark Red)
    0.906, 0.298, 0.235;  % Kansas (Red)
    0.537, 0.404, 0.145;  % Kentucky (Olive)
    0.541, 0.149, 0.196;  % Louisiana (Maroon)
    0.282, 0.322, 0.619;  % Maine (Blue)
    0.000, 0.361, 0.533;  % Maryland (Navy Blue)
    0.482, 0.569, 0.094;  % Massachusetts (Green)
    0.384, 0.431, 0.435;  % Michigan (Dark Gray)
    0.514, 0.675, 0.757;  % Minnesota (Light Blue)
    0.216, 0.247, 0.271;  % Mississippi (Dark Gray)
    0.506, 0.149, 0.341;  % Missouri (Maroon)
    0.965, 0.855, 0.157;  % Montana (Yellow)
    0.078, 0.388, 0.333;  % Nebraska (Green)
    0.086, 0.176, 0.431;  % Nevada (Dark Blue)
    0.251, 0.541, 0.796;  % New Hampshire (Blue)
    0.937, 0.227, 0.243;  % New Jersey (Red)
    0.275, 0.506, 0.725;  % New Mexico (Blue)
    0.078, 0.361, 0.529;  % New York (Navy Blue)
    0.251, 0.404, 0.698;  % North Carolina (Blue)
    0.000, 0.306, 0.561;  % North Dakota (Dark Blue)
    0.812, 0.196, 0.208;  % Ohio (Red)
    0.094, 0.373, 0.102;  % Oklahoma (Green)
    0.749, 0.196, 0.384;  % Oregon (Red)
    0.145, 0.251, 0.396;  % Pennsylvania (Dark Blue)
    0.000, 0.271, 0.529;  % Rhode Island (Navy Blue)
    0.141, 0.317, 0.470;  % South Carolina (Dark Blue)
    0.086, 0.129, 0.431;  % South Dakota (Dark Blue)
    0.620, 0.125, 0.294;  % Tennessee (Crimson)
    0.000, 0.267, 0.486;  % Texas (Dark Blue)
    0.000, 0.337, 0.620;  % Utah (Navy Blue)
    0.086, 0.227, 0.435;  % Vermont (Dark Blue)
    0.639, 0.086, 0.216;  % Virginia (Maroon)
    0.043, 0.275, 0.557;  % Washington (Blue)
    0.533, 0.102, 0.243;  % West Virginia (Maroon)
    0.000, 0.286, 0.482;  % Wisconsin (Dark Blue)
    0.239, 0.275, 0.435;  % Wyoming (Dark Blue)
    0.737, 0.737, 0.737;  % Washington, D.C. (Light Gray)
];

% Creates a color map based on the number of states
colorMap = colormap(distinct_colors);
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
            p = patch(ax1, x_coord, y_coord, j*z_coord, colorMap(i, :), 'DisplayName', displayName,'EdgeColor', 'w');  
            if j ~= 1
                alpha(p, 1);  % Sets transparency
            end
        end
    else
        %fprintf('- State Count: %d\n', 0);
        displayName = [states(i).Name, ' (Count: ', num2str(0), ')'];
        % If the base map is kept
        patch(ax1, x_coord, y_coord, z_coord, colorMap(i, :), 'DisplayName', displayName,'EdgeColor', 'w');       
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

