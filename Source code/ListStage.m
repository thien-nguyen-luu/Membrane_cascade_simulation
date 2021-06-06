function combinations = ListStage(maxStage)
% SHOW THE COMBINATIONS OF ALL CONFIGURATION
x = nchoosek([0:maxStage-1 0:maxStage-1],2);
combinations = unique(x, 'rows');
sumstage = sum(combinations,2);
for i = 1:length(sumstage)
    if sumstage(i) > maxStage-1 || combinations(i,1) > 1
        combinations(i,:) = 0;
    end
end

combinations( all(~combinations,2), : ) = [];
end