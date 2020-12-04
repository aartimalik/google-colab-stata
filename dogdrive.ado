/*
dogdrive.ado
A small utility to run google docs files as stata do files 
for easy collaboration on data analysis.
(c) 2013-2015 Markus Schaffner
*/
cap program drop dogdrive
program dogdrive
	version 13
	syntax anything(name=gtoken)

	tempname inhandle
	tempname outhandle
	tempname val
	
	tempfile txtfile
	tempfile dofile
	
	// download the google colab as text

 copy "https://colab.research.google.com/drive/'gtoken'" 'txtfile', replace text

	// get rid of the first three chars
	file open `inhandle' using `txtfile', read binary
	file seek `inhandle' 3
	file open `outhandle' using `dofile', write binary 
	file read `inhandle' %2bs `val'
	while r(eof)==0 {
	        file write `outhandle' %2bs (`val')
			file read `inhandle' %2bs `val'
	}
	file close `inhandle'
	file close `outhandle'

	do `dofile'
end
