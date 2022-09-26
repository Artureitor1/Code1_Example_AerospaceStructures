classdef plotBarStressDefCompute < handle
    properties (Access = private)
        x
        u
        Tn
        sig
    end

    methods (Access = public)
        function obj = plotBarStressDefCompute(cParams)
            obj.init(cParams)
        end

        function compute(obj)
            obj.plot()
        end
    end
    methods (Access = private)
        function init(obj,cParams)
            obj.x = cParams.x;
            obj.u =cParams.u;
            obj.Tn =cParams.Tn;
            obj.sig =cParams.sig;
        end 
        function plot(plot)
            n_d = size(obj.x,2);
            X = obj.x(:,1);
            Y = obj.x(:,2);
            ux = obj.u(1:n_d:end);
            uy = obj.u(2:n_d:end);

            figure('color','w');
            hold on
            box on
            axis equal;
            colormap jet;

            plot(X(obj.Tn)',Y(obj.Tn)','-k','linewidth',0.5);

            patch(X(obj.Tn)'+obj.scale*ux(obj.Tn)',Y(obj.Tn)'+obj.scale*uy(obj.Tn)',[obj.sig';obj.sig'],'edgecolor','flat','linewidth',2);

            xlabel('x (m)')
            ylabel('y (m)')

            title(sprintf('Deformed structure (scale = %g)',obj.scale));

            caxis([min(obj.sig(:)),max(obj.sig(:))]);
            cbar = colorbar;
            set(cbar,'Ticks',linspace(min(obj.sig(:)),max(obj.sig(:)),5));
            title(cbar,{'Stress';'(Pa)'});
        end
    end 
end