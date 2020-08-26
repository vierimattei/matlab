function toplot = handletoplot(thehandle)
msystemdim
%Making the function handle a string so we can modify its contents to
%remove the location objects that cannot be plotted.

handlestring = func2str(thehandle);

%Removing every instance of 'location.'. Changing the input of the
%function from (location,state) to (r).

handlegood = erase(handlestring,'location.');
handlegood = strrep(handlegood,'@(location,state)','@(r)');
handlegood = strrep(handlegood,'sqrt(x.^2+y.^2+z.^2)','r');
handlegood = erase(handlegood,'-a*');

%Result is a string, to be able to plot it need to use eval(toplot) outside
%of the function
toplot = handlegood;
end