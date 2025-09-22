classdef PoolWaitbar < handle
    % SOURCE: Posted by Edric Ellis on 10 June 2019 on
    % https://uk.mathworks.com/matlabcentral/answers/465911-parfor-waitbar-how-to-do-this-more-cleanly
    % Accessed, copied and modified by JB 11/04/2025
    
    % Syntax: pw = PoolWaitbar(parfor_increments, 'text of waitbar', start_value_before_parfor, end_value_after_parfor);
    % The added public handle 'ClientHandlePublic' allows accessing the object
    % from outside a parfor loop as well.
    
    properties (SetAccess = immutable, GetAccess = private)
        Queue
        N
        startvalue      % JB 11/04/2025
        endvalue        % JB 11/04/2025
    end
    
    properties (Access = private, Transient)
        ClientHandle = []
        Count = 0
    end
    
    properties (SetAccess = immutable, GetAccess = private, Transient)
        Listener = []
    end
    
    properties
        ClientHandlePublic
    end
    
    methods (Access = private)
        function localIncrement(obj)
            obj.Count = 1 + obj.Count;
            current_value = obj.startvalue + (obj.Count/obj.N)*(obj.endvalue-obj.startvalue);   % JB 11/04/2025
            waitbar(current_value, obj.ClientHandle);                                           % modified JB 11/04/2025
        end
    end
    
    methods
        function obj = PoolWaitbar(N, message, startvalue, endvalue)
            if nargin < 2
                message = 'PoolWaitbar';
            end
            obj.N = N;
            obj.startvalue = startvalue;    % JB 11/04/2025
            obj.endvalue = endvalue;        % JB 11/04/2025
            obj.ClientHandle = waitbar(startvalue, message);
            obj.ClientHandlePublic = obj.ClientHandle;
            obj.Queue = parallel.pool.DataQueue;
            obj.Listener = afterEach(obj.Queue, @(~) localIncrement(obj));
        end
        
        function increment(obj)
            send(obj.Queue, true);
        end
        
        function delete(obj)
            delete(obj.ClientHandle);
            delete(obj.Queue);
        end
    end
    
end