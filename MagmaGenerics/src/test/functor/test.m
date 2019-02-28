from generic Option$Int$;

test := procedure()
    nl := New(List$Integers$);

end procedure;


test := function()
    seg := "declare type Functor$A$;\r\ndeclare attribute Functor$A$ : __apply, __map;\r\n";
    generics := [<"A","ModTupFin">,<"B","AlgMat">];
    NewGeneric("Functor$A,B$", seg, generics);
    NewGeneric("List$A$", seg, generics);
    NewFromGeneric(Functor(ModTupFin,AlgMat));
    return true;
end function;

test2 := function()
    Functor := NewGeneric("Functor$A$");

end function;


UpdateMetaSpec := function( specname, metalist )
    thespec := "// THIS IS MACHINE GENERATED.\n//EDITING MAY RESULT IN ERRORS";
    thespec := "magma-meta {";
    thespec cat:= &cat[ "\t" cat metalist cat ".m\n" ] ;
    tehspec cat:= "}";
    specname := specname cat "-meta.spec";
    Write( specname, thespec : Overwrite := true );
    return specname;
end function;
