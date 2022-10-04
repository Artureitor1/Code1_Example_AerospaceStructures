classdef stifnessMatrixComputer < handle
    properties (Access = private)
        nEl
        Tn
        x
        Tmat
        mat
        nElDof
        Td
    end
    properties (Access = public)

        
        Kel
    end

    methods (Access = public)
        function obj = stifnessMatrixComputer(cParams)
            obj.init(cParams);
        end

        function compute(obj)
            obj.computeKelBar()
        end
    end

    methods (Access = private)

        function init(obj,cParams)
            obj.nEl  = cParams.nEl;
            obj.Tn   = cParams.Tn;
            obj.x = cParams.x;
            obj.Tmat = cParams.Tmat;
            obj.mat = cParams.mat;
            obj.nElDof = cParams.nElDof;
            obj.Td = cParams.Td;

        end
        function computeKelBar(obj)
            obj.Kel=zeros(obj.nElDof,obj.nElDof,obj.nEl);
            for e=1:obj.nEl
                s.x = obj.x;
                s.Tn =obj.Tn;
                s.e = e;
                B = lenghtComputer(s);
                B.compute;
                se = B.se;
                ce = B.ce;
                le = B.le;


                Ke=(obj.mat(obj.Tmat(e),2))*(obj.mat(obj.Tmat(e),1))/le * [
                    ce^2 ce*se -(ce)^2 -ce*se
                    ce*se se^2 -ce*se -(se)^2
                    -(ce)^2 -ce*se ce^2 ce*se
                    -ce*se -(se)^2 ce*se se^2
                    ];


                obj.Kel(:,:,e) = Ke(:,:);
            end
        end
        
    end
end