function dataLI = pcs(data, t, t_new)

for i = 1:size(data,1)
    x = data(i,:);
    dataLI(i,:) = interp1(t,x,t_new,'pchip');
end

end
