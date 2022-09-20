classdef dispPlotter < handle
    properties (Access = private)
        nd
        Tn
        n
        x
        u
    end

    methods (Access = public )
        function obj = dispPlotter(cParams)
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
            obj.u  = cParams.u;

        end
        function plot(obj)
            U = reshape(obj.u,obj.nd,obj.n);
            for i = 1:obj.nd
                X0{i} = reshape(obj.x(obj.Tn,i),size(obj.Tn))';
                X{i} = X0{i}+obj.fact*reshape(U(i,obj.Tn),size(obj.Tn))';
            end
            D = reshape(sqrt(sum(U(:,obj.Tn).^2,1)),size(obj.Tn))';

            figure('color','w');
            hold on;
            box on;
            axis equal;
            colormap jet;

            xlabel('x (m)')
            ylabel('y (m)')
            title('Displacement');

            patch(X0{:},zeros(size(D)),'edgecolor',[0.5,0.5,0.5],'linewidth',2);

            patch(X{:},D,'edgecolor','interp','linewidth',2);

            caxis([min(D(:)),max(D(:))]);
            cbar = colorbar;
            set(cbar,'Ticks',linspace(min(D(:)),max(D(:)),5))
        end
    end
end
