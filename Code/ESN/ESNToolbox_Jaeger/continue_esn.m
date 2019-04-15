function outputSequence = continue_esn(inputSequence, esn, nForgetPoints, horizon, varargin)
% test_esn runs a trained ESN on a particular inputSequence

% input args:  
% inputSequence: is a nTrainingPoints * nInputUnits matrix that contains 
% the input we will run the esn on
% esn: the trained ESN structure 
% nForgetPoints: nr of initial time points to be discarded
%
% optional input argument:
% there may be one optional input, the starting vector by which the esn is
% started. The starting vector must be given as a column vector of
% dimension esn.nInternalUnits + esn.nOutputUnits + esn.nInputUnits  (that
% is, it is a total state, not an internal reservoir state). If this input
% is desired, call test_esn with fourth input 'startingState' and fifth
% input the starting vector.
%
% ouput:
% outputSequence is an array of size (size(inputSequence, 1)-nForgetPoints)
% x esn.nOutputUnits

% Created April 30, 2006, D. Popovici
% Copyright: Fraunhofer IAIS 2006 / Patent pending
% revision 1, June 6, 2006, H. Jaeger
% revision 2, June 23, 2007, H. Jaeger (added optional start state input)

if esn.trained == 0
    error('The ESN is not trained. esn.trained = 1 for a trained network') ; 
end

if nargin == 4 % case where no starting state is specified 
    stateCollection = compute_statematrix(inputSequence, [], esn, nForgetPoints) ;     
else % case where the last (fourth and fifth) input argument gives a starting vector
    args = varargin; 
    nargs= length(args);
    for i=1:2:nargs
        switch args{i},
            case 'startingState', startingState = args{i+1} ;
            otherwise error('the option does not exist');    
        end
    end
    stateCollection = ...
        compute_statematrix(inputSequence, [], esn, nForgetPoints, 'startingState', startingState) ;
end

if horizon
    outputSequence = stateCollection * esn.outputWeights' ;
    startStateCollection_temp = [stateCollection(end, :)'; outputSequence(end)];
    for i = 1:horizon
        stateCollection_temp = ...
            compute_statematrix(outputSequence(end), [], esn, 0, 'startingState', startStateCollection_temp);
        outputSequence = stateCollection_temp * esn.outputWeights' ;
        startStateCollection_temp = [stateCollection_temp(end, :)'; outputSequence(end)];
        stateCollection = [stateCollection;[startStateCollection_temp(1:esn.nInternalUnits, 1)', startStateCollection_temp(end, end)]];
    end
    
end

outputSequence = stateCollection * esn.outputWeights' ; 
%%%% scale and shift the outputSequence back to its original size
nOutputPoints = length(outputSequence(:,1)) ; 
outputSequence = feval(esn.outputActivationFunction, outputSequence); 
outputSequence = outputSequence - repmat(esn.teacherShift',[nOutputPoints 1]) ; 
outputSequence = outputSequence / diag(esn.teacherScaling) ; 
