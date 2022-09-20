classdef plot < handle
    properties (Access = private)
        Tn
        n
        x
        nd
        u
        sig
        
    end

    methods (Access = public)
        function obj = plot(cParams)
            obj.init(cParams)
        end

        function  compute(obj)
            obj.plot()
        end
    end
    methods (Access = private)
        function init(obj,cParams)
            obj.Tn = cParams.Tn;
            obj.n =cParams.n;
            obj.x =cParams.x;
            obj.nd =cParams.nd;
            obj.u =cParams.u;
            obj.sig =cParams.sig;
        end
        function strainStressPlotter(obj)
            s.nd = obj.nd;
            s.Tn =obj.Tn;
            s.n =obj.n;
            s.x =obj.x;
            B = strainStressPlotter(s);
            B.compute()


        end
        function dispPlotter(obj)
            s.nd = obj.nd;
            s.Tn = obj.Tn; 
            s.n  = obj.n;
            s.x  = obj.x;
            s.u  = obj.u;
            B = dispPlotter(s);
            B.compute()

        end
        function plotBarStressDef(obj)
            s.x = obj.x;
            s.u = obj.u;
            s.Tn = obj.Tn;
            s.sig = obj.sig;
            B = plotBarStressDef(s);
            B.compute()

        end
    end
end