classdef strainStressPlotCompute < handle
    properties (Access = private)
        nd
        Tn
        n
        x
    end

    methods (Access = public )
        function obj = strainStressPlotCompute(cParams)
            obj.init(cParams)
        end

        function compute(obj)
            obj.plot()
        end
    end
    methods (Access = private)
        function init(obj,cParams)
            obj.nd = cParams.nd;
            obj.Tn = cParams.Tn;
            obj.n  = cParams.n;
            obj.x  = cParams.x;
        end 
        function plot(obj)
                for i = 1:obj.nd
                    X0{i} = reshape(obj.x(obj.Tn,i),size(obj.n))';
                end
                S = repmat(obj.s',size(obj.Tn,2),1);
                
                figure('color','w');
                hold on;       
                box on;        
                axis equal;    
                colormap jet;  
                
                xlabel('x (m)')
                ylabel('y (m)')
                title(obj.title_name{1});
                
                patch(X0{:},S,'edgecolor','flat','linewidth',2);
                
                caxis([min(S(:)),max(S(:))]);
                cbar = colorbar;
                set(cbar,'Ticks',linspace(min(S(:)),max(S(:)),5));
                title(cbar,obj.title_name);
        end 
    end 
end