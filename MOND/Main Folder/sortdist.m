function [rsort,varargout] = sortdist(r,varargin)
%Use as: [rsort,fsort1,fsort2,...fsortN] = [r,f1,f2,...fN]
%Takes as input an unsorted vector of coordinates (e.g. r) which has to be 
%FIRST INPUT, and an arbitrary # of functions of that coordinate. Sorts the
%coordinate in increasing value, then sorts the other inputs to correspond 
%to their correct values of the coordinate.
%Can take an arbitrary amount of input functions after the coordinates, and
%returns as many sorted outputs alongside the sorted coordinate.
%Can be used to be able to e.g. plot functions (instead of using scatter)
%against the radial distance. 

[rsort,order] = sort(r);

% for i = 1:nargin
%     
% varargout{i} = zeros(length(r),1);
% 
% end 

for i = 1:nargin-1
    varargout{i} = varargin{i}(order);
end

end


