classdef stressStrainComputer < handle

    properties (Access = private)
        nEl 
        Tn
        Td
        x
        mat
        Tmat
        u
    end
    properties (Access = public)
        sig
        eps
    end 

    methods (Access = public)
        function obj = stressStrainComputer(cParams)
                obj.init(cParams);
        end

        function compute(obj)
            obj.computeGeometry()
            obj.computeStresStrain()
        end
    end
    methods (Access = private)
        function init(obj,cParams)
            obj.Tn =  cParams.Tn;
            obj.x =   cParams.x;
            obj.mat = cParams.mat;
            obj.Tmat = cParams.Tmat;  
            obj.u = cParams.u;
        end 
        function computeGeometry(obj)
            s.x  = obj.x;
            s.Tn = obj.Tn;
            B = geometryComputer(s);
            B.compute();
            obj.nEl = B.nEl;
            obj.Td = B.Td;
        end 
        function computeStresStrain(obj)
            obj.eps=zeros(obj.nEl,1);
            obj.sig=zeros(obj.nEl,1);

            for e=1:obj.nEl
                ue=zeros(2*2,1);

                s.x = obj.x;
                s.Tn = obj.Tn;
                s.e = e;
                B = matrixRotationComputer(s);
                B.compute()
                le   = B.le;
                Re = B.Re;
                
                for i=1:2*2
                    I=obj.Td(e,i);
                    ue(i,1)=obj.u(I);
                end
                uep=Re*ue;
                obj.eps(e,1)=(1/le)*[-1 0 1 0]*uep;
                obj.sig(e,1)=obj.mat(obj.Tmat(e),1)*obj.eps(e,1);
            end
        end

    end 
end