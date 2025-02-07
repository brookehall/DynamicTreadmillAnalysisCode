%% Standard error of the mean

function sem = sem(x)
for i = 1:length(x)
    sem = std(nonzeros(x))/sqrt(length(x));
end
end