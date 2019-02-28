
// Have a generic spec which loads 
// 
// List$A$.mt     
//
// it reads in this and converts each into a new generic type.
AttachMetaSpec := procedure(filename) 
    spec := Read(filename);
    lines := Split(spec, "\n");
    for filename in lines do
        // Assume files starts with
        // <name>
        // A,B,C
        try
            metdef := Read(filename);
            name := line[1]; 
            generics := Split(line[2],",");
            // if there is such a type, match the generic, and blow away the old.
            if exists(mt){m : m in __meta_types | m`name eq name } then 
                mt := New(GenericType);
                mt`name := name;
                mt`generics := generics;
                Append(~__, mt);
            end if;

            mt`template := &cat line[3..#line];
        catch
            "Invalid file or format.\n";
        end try;
    end for;
end procedure;