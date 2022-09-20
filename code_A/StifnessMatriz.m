classdef StifnessMatriz < handle
    properties (Access = private)
        nEl
        nNod
        ni
        Tn
        x
        Tmat
        mat
        nElDof
    end
    properties (Access = public)

        Td
        Kel
    end

    methods (Access = public)
        function obj = StifnessMatriz(cParams)
            obj.init(cParams);
        end

        function compute(obj)
            obj.connectDOFs()
            obj.computeKelBar()
        end
    end

    methods (Access = private)

        function init(obj,cParams)
            obj.nEl  = cParams.nEl;
            obj.nNod = cParams.nNod;
            obj.ni   = cParams.ni;
            obj.Tn   = cParams.Tn;
            obj.x = cParams.x;
            obj.Tmat = cParams.Tmat;
            obj.mat = cParams.mat;
            obj.nElDof = cParams.nElDof;


        end

        function connectDOFs(obj)
            obj.Td=zeros(obj.nEl,obj.nNod*obj.ni);
            for i=1:obj.nEl
                for j=1:obj.nNod*obj.ni
                    if (-1)^j==1
                        obj.Td(i,j)=2*obj.Tn(i,j-j/2);
                    end

                    if (-1)^j==-1
                        obj.Td(i,j)=2*obj.Tn(i,j-j*(j-1)/(2*j))-1;
                    end
                end
            end
            obj.Td
        end
        function computeKelBar(obj)
            obj.Kel=zeros(obj.nElDof,obj.nElDof,obj.nEl);
            for e=1:obj.nEl
                x1e=obj.x(obj.Tn(e,1),1);
                y1e=obj.x(obj.Tn(e,1),2);
                x2e=obj.x(obj.Tn(e,2),1);
                y2e=obj.x(obj.Tn(e,2),2);
                le=sqrt((x2e-x1e)^2+(y2e-y1e)^2);
                se=(y2e-y1e)/le;
                ce=(x2e-x1e)/le;


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