classdef GeometryComputer < handle
    properties (Access = private)
        x
        Tn

        nd
        ni
        n
        nNod
    end
    properties (Access = public)      
        nDof 
        nEl    
        nElDof 
        Td
    end

    methods (Access = public)
        function obj = GeometryComputer(cParams)
            obj.init(cParams);
        end

        function compute(obj)
            obj.computeAdimensionalize()
            obj.connectDOFs()
        end
    end
    methods (Access = private)
        function init(obj,cParams)
            obj.x      = cParams.x;
            obj.Tn     = cParams.Tn;
        end

        function computeAdimensionalize(obj);
            obj.nd = size(obj.x,2);
            obj.ni = obj.nd;
            obj.n = size(obj.x,1);
            obj.nDof = obj.ni*obj.n;
            obj.nEl = size(obj.Tn,1);
            obj.nNod = size(obj.Tn,2);
            obj.nElDof = obj.ni*obj.nNod;
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
        end
        
    end

end