function [fitness_tab, models, IO, AIK, dcs] = just_tfest(orders, Ts, data)
%SystemID using tfest() including offset for SISO systems between lines of data matrix
init_opt = 'n4sid'; %Choice between {'iv','svf','gpmf','n4sid','all'}. See doc "tfestoptions"
%opt = tfestOptions('InitMethod','n4sid','Focus',[2*pi/32,2*pi/16]); %Option for system ID ATA initial estimate technique. 
opt = tfestOptions('InitMethod','n4sid'); %Option for system ID ATA initial estimate technique.
warning off;
%Compute iddata's structure from time series, corresponding model and
%fitness
for k = 1:length(orders)
    for i = 1:size(data,1)
        parfor j = 1:size(data,1)
            warning off;
            if i ~= j
                
                if (sum(data(j,:) ~= 0)) && (sum(data(i,:) ~= 0))  %Deal with vectors of 0
                    
                    IO{i,j,k} = iddata(data(j,:)',[data(i,:)' ones(size(data(i,:)'))],Ts); %Include a trivial input for offset
                    models{i,j,k} = tfest(IO{i,j,k}, [orders(k) 0], opt); %0 order model for additional input = offset
                    [~,fit] = compare(IO{i,j,k}, models{i,j,k});
                    if fit < 0
                        fit = 0;
                    end
                    AIK(i,j,k) = aic(models{i,j,k},'AICc');
                    gain = dcgain(models{i,j,k}); 
                    g = gain(1,1);
                    dcs(i,j,k) = g;
                    if abs(g) <= 0.1 %Test to remove low dcgain models (false systems ID...)
                        fitness_tab(i,j,k) = 0;
                    else
                        fitness_tab(i,j,k) = fit;               
                    end
                    
                else                                  
                    
                    IO{i,j,k} = NaN;
                    models{i,j,k} = NaN;
                    fitness_tab(i,j,k) = 0;
                    AIK(i,j,k) = 0;
                    dcs(i,j,k) = 0;
                    
                end
    %             end
                %fprintf('Model identified between genes %d and %d, fitness = %d\n',i,j,fit);
            else
                IO{i,j,k} = NaN;
                models{i,j,k} = NaN;
                fitness_tab(i,j,k) = 0;
                AIK(i,j,k) = 0;
                dcs(i,j,k) = 0;
            end
        end
        fprintf('%d models identified, %d systems left \n',i*size(data,1), size(data,1)*size(data,1) - i*size(data,1));
    end
    
end

end

