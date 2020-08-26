function [nodes,r,nodesort,rsort,elements,elsort] = sortelements(model)
%Outputs the coordinates corresponding to each element, the magnitude of
%each node, and a sorted version of these quantities. Then, it rearranges
%the list of elements based on their distance from the origin.

%Extrapolating the coordinates of each node
x = model.Mesh.Nodes(1,:);
y = model.Mesh.Nodes(2,:);
z = model.Mesh.Nodes(3,:);
r = sqrt(x.^2+y.^2+z.^2);

%Assigning the coordinates to an array
nodes = [x; y; z];

%Sorting the coordinates
[rsort,xsort,ysort,zsort] = sortdist(r,x,y,z);
nodesort = [xsort; ysort; zsort];

%Assigning the elements to an array
elements = model.Mesh.Elements;

%Pre-allocating array for elemradius
elemradius = zeros(size(elements));

%Substituting the element index in the elements array by their radius

for i = 1:numel(elements)
    
radius = r(elements(i));    %temporarily getting radius of each node UNNECESSARY LINE
elemradius(i) = radius;     %replacing node by its radius

end

% disp('First 6 columns of elemradius');
% disp(elemradius(:,1:6));

radmin = min(elemradius,[],1);
[radsort,index] = sort(radmin);

% disp('First 6 values of radmin');
% disp(radmin(1:6));

elsort = zeros(size(elements));

for i = 1:size(elements,2)
    elsort(:,i) = elements(:,index(i));
end

end