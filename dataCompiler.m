% Gets the amount of unique occurence of each state
function stateCounts = dataCompiler()
    data = readtable('banklist.csv');

    % Defines the start and end dates to read from the csv
    startDate = datetime('01-Jan-00', 'Format', 'dd-MMM-yy', 'PivotYear', 2000);
    endDate = datetime('31-Dec-23', 'Format', 'dd-MMM-yy', 'PivotYear', 2000);

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

                % Updates the count for the current state
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

