# Clean up the directory after the tests
lib_so_files = filter(x -> contains(x,".so"),readdir())
for str in lib_so_files run(`rm $str `) end
run(`rm AUTOMAT.d`)
run(`rm OUTSDIF.d`)
