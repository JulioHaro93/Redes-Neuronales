classdef tuplitaVectorSalida<handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    properties
        vector=[]
        salida=0
    end

    methods
        function obj = tuplitaVectorSalida(vector, salida)
            obj.vector=vector;
            obj.salida=salida;
        end

        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end