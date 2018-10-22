function [x,y] = uniquePairs(x_raw,y_raw)

temp = 1;
x = [];
y = [];

for i = 1:length(x_raw)
    temp2 = find(x == x_raw(i));
    if isempty(temp2) %X_raw(i) does not appear in X yet, so we put it there
        x(temp) = x_raw(i);
        y(temp) = y_raw(i);
        temp = temp + 1;
    else %Check if y_raw is there already, because X is.
        idx = find(y == y_raw(i)); 
        if isempty(idx)
            x(temp) = x_raw(i);
            y(temp) = y_raw(i);
            temp = temp + 1;
        end
    end    
    
end

end