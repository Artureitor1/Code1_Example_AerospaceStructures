classdef GeometryComputer < handle
    properties (Access = private)
        coordNodes
        nodalConectivity
    end
    properties (Access = public)      
        geometry
    end

    methods (Access = public)
        function obj = GeometryComputer(cParams)
            obj.init(cParams);
        end

        function compute(obj)
            obj.computeAdimensionalize()
            obj.connectDegressOfFredom()
        end
    end
    methods (Access = private)
        function init(obj,cParams)
            obj.coordNodes  = cParams.coordNodes;
            obj.nodalConectivity = cParams.nodalConectivity;
        end

        function computeAdimensionalize(obj)
            degreeFredomPerNodes = size(obj.coordNodes,2);
            obj.geometry.degreeFredomPerElement = size(obj.coordNodes,2)*2;
            numberNodes = size(obj.coordNodes,1);
            obj.geometry.totalDegresFredom = degreeFredomPerNodes*numberNodes;
            obj.geometry.numberElement = size(obj.nodalConectivity,1);
        end
        function connectDegressOfFredom(obj)
            degressConectivity=zeros(obj.geometry.numberElement,obj.geometry.degreeFredomPerElement);
            numberElement = obj.geometry.numberElement;
            degreeFredomPerElement = obj.geometry.degreeFredomPerElement;
            nodalConectivity = obj.nodalConectivity;

            for i=1:numberElement
                for j=1:degreeFredomPerElement
                    if (-1)^j==1
                        degressConectivity(i,j)=2*nodalConectivity(i,j-j/2);
                    end
                    if (-1)^j==-1
                        degressConectivity(i,j)=2*nodalConectivity(i,j-j*(j-1)/(2*j))-1;
                    end
                end
            end
            obj.geometry.degressConectivity = degressConectivity;
        end
        
    end

end