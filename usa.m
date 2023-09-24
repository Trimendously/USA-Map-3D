
% Via the banklist.csv file checks the count per state of failed banks
stateCounts = dataCompiler();

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

% My colormap
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
colorMap = colormap(distinct_colors);

% Creates an empty cell array to store legend labels
legendLabels = cell(numel(states), 1);


% Plots each state individually 
for i = 1:numel(states)   
    % Initializes the logical indices for valid coordinates (excludes Nan)
    valid_coords = ~isnan(x{i}) & ~isnan(y{i});
    nan_coords = isnan(x{i}) | isnan(y{i});

    x_coord = x{i}(~nan_coords);
    y_coord = y{i}(~nan_coords);
    z_coord = ones(size(x{i}(valid_coords)));
    
    if isKey(stateCounts, states(i).Name) % Frequency > 0
        z_height = stateCounts(states(i).Name);
        displayName = [states(i).Name, ' (Count: ', num2str(stateCounts(states(i).Name)), ')'];
    else  % Frequency = 0
        z_height = 0;
        displayName = [states(i).Name, ' (Count: ', num2str(0), ')'];
    end

    % Plots the 3d layers for each state (j is the frequency of each state) 
    for j = 0:z_height
        if j == 0
            faceColor = [0, 0, 0]; % 3D map color
        else
            faceColor = colorMap(i, :); % Base map color
        end

        if strcmp(states(i).Name, 'Alaska')
            % Manually divided the regions to avoid messed up edges between disconnected pieces
            regionDividers = [1, 3174, 3380,3461,3575,4561,4907,4967];

            % Iterates over each region and plot the patches
            for region = 1:length(regionDividers) - 1
                s = regionDividers(region); % Start index
                f = regionDividers(region + 1) - 1; % End index
            
                % Plots the patch for the current region
                patch(ax1, x_coord(s:f), y_coord(s:f), j*z_coord(s:f), faceColor,'DisplayName', displayName, 'EdgeColor', 'w');
            end             
        else
            patch(ax1, x_coord, y_coord, j*z_coord, faceColor, 'DisplayName', displayName,'EdgeColor', 'w');  % Plots the state(~Alaska)
        end
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




% Define the position and dimensions for the legend box
legend_box_x = 0.79;
legend_box_y = 0.92 - (numel(legendLabels)+1) * 0.015;
legend_box_width = 0.13;
legend_box_height = 0.06 + (numel(legendLabels)) * 0.015;

% Lgend Title
annotation('textbox', [legend_box_x, 0.9, legend_box_width, 0.05], 'String', 'Legend', 'EdgeColor', 'none', 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');

% Creates a rectangle annotation for the legend box
annotation('rectangle', [legend_box_x, legend_box_y, legend_box_width, legend_box_height], 'EdgeColor', 'k', 'LineWidth', 1.5);


for i = 1:numel(legendLabels)
    text_y_position = 0.9 - i* 0.015;  % Adjusted y_position for single-spaced vertical layout
    rectangle_y_position = 0.92 - i * 0.015;

    % Create a small square with the same color
    annotation('rectangle', [legend_box_x + legend_box_width/2 - 0.034, rectangle_y_position, 0.01, 0.011], 'Color', colorMap(i,:), 'FaceColor', colorMap(i,:));
    
    % Create the legend entry text
    annotation('textbox', [legend_box_x + legend_box_width/2 - 0.02, text_y_position, legend_box_width, 0.05], 'String', legendLabels{i}, 'EdgeColor', 'none', 'FontSize', 10, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle');
end

function proj = createProjection(projectionType,standardParallel1, standardParallel2, centralMeridian, originLat)
    proj = defaultm(projectionType);
    proj.origin = [originLat, 0];
    proj.mapparallels = [standardParallel1, standardParallel2];
    proj.nparallels = 2;
    proj.falseeasting = 0;
    proj.falsenorthing = 0;
    proj.scalefactor = 1;
    proj.falseeasting = 0;
    proj.central_meridian = centralMeridian;
end

% Turns geolocation into cartesian coordinates
function [x,y] = lambert(states)
    % Lambert Conformal Conic projection parameters for USA
    proj = createProjection('lambertstd',33, 45, -96, 39);

    % Initializes arrays to store Cartesian coordinates for each state
    x = cell(numel(states), 1);
    y = cell(numel(states), 1);
    
    % Converts the latitudes and longitudes to Cartesian coordinates for each state
    for i = 1:numel(states)
            [x{i}, y{i}] = projfwd(proj, states(i).Lat, states(i).Lon);
        
    end
end
