/*
  
  Magma doesn't compile user defined code, though it might have that
  option in the future.  So in strictly speaking everything done here 
  is meta-programming as it creates programs while running a program.  

  However, in the long run this should be seen as a crude attempt
  at adding generics to the magma language.  For example, it could
  be run ahead of time to create a pile of new types and intrinsics
  that could be loaded as part of a pacakge.  However, some may desire
  the flexibility of some meta-programming tools.  So the usage is
  up to him/her.

==================================================================
DEVELOPMENT NOTE: to maintain (co-)variance in generics will
require that all substitutions of a given type with generics
occur together, so their static substitutions can be wound
together.  This means to recompile the generic list with
ever new package.  This is compile time so fine, but requires
some supervision. 

Unfortunately, my attempt to store these and incremental
recompilation met with a magma issue that intrinsics can't
seem to access global state, such as the generic parse trees.
==================================================================
 */
declare type TemplateType;
declare attributes TemplateType : name, generics, templateCode;

// GLOBAL STATIC LIST OF ALREADY AVAILABLE GENERIC TYPES.
__type_generics_list := [];
update := procedure(t)
    Append(~__type_generics_list, t);
end procedure;

// Used exclusively to for the set of meta types to 
// store exactly one template for each name.
intrinsic 'eq'(a::TemplateType, b::TemplateType) -> BoolElt
{Compare types with generics.}
    return (a`name eq b`name) and (a`generics eq b`generics);
end intrinsic;

intrinsic Sprint( t:: TemplateType)-> MonStgElt 
{}
    return "" cat t`name cat ":" cat &cat(t`generics);
end intrinsic;

intrinsic Print(t::TemplateType)
{}
    print(Sprint(t));
end intrinsic;

intrinsic AttachTemplate( 
    filename::MonStgElt
) -> TemplateType
{Attaches code with generics, stores the build tree.}
    sourceCode := Read(filename);
    
    templateCode := "";
    tail := sourceCode;
    temTy := New(TemplateType);
    while #tail gt 0 do 
        // find declare template Foo$A1,...,An$;
        hasTemplate, res, parts := Regexp( 
                "(.*)declare[ \t]+template[ \t]+(.*);(.*)", tail );
        if hasTemplate then
            templateCode cat:= parts[1];
            nameSegs := Split( parts[2], "$" );
//            hasGenerics, res, nameSegs := Regexp( 
//                "([^\$]*)([\$]([A-z]*)[\$])+(.*)", parts[2] );
//            if hasGenerics then 
                temTy`name := nameSegs[1];
                temTy`generics := Split(nameSegs[2], "," );
 //           else 
//                "SYNTAX ERROR: ", nameSegs[2], 
//                    " not in form declare template <Name>$<Generic1>,...,<Generic2>$";
//            end if;
            templateCode cat:= "declare type " cat parts[2] cat ";";
            tail := parts[3];
        else
            templateCode cat:= tail;
            tail := "";
        end if;
    end while;
    
    temTy`templateCode := templateCode;
    
    // whether new or old, give it the new type definition.
//    temp := &cat[filelines[i] cat "\r\n" : i in [3..#filelines]];
    // In the future should properly remove commented code from template.
//    t`parsetree := Split( temp, "$" );
    return temTy;
end intrinsic;

// a static naming convention that (hopefully) does not polute the namespace.
__name := function (meta_name,types)
    im := &cat[  Sprint(g)  : g in types ];
    return meta_name cat im;// cat Sprint(StringToCode(meta_name cat im ));
end function;


__eval_generic := function( node, generics, generic_map )
    givenGenerics := Split(node, "$,");
    concrete := "";
    for g in givenGenerics do
        if exists(i){i : i in [1..#generics] | g eq generics[i] } then
            concrete cat:= Sprint(generic_map[i]);
        else
            // not a full match.
            return node;
        end if;
    end for;
    return concrete;
end function;

compTemplate := procedure( 
    template,
    generic_map
) 
    code := template`templateCode;
    evaluatedCode := "// MACHINE GENERATED CODE: EDITS WILL BE OVERWRITTEN\n\n";
    while #code gt 0 do
        foundGeneric, total, parts :=  Regexp( "([^\$]*)([\$][A-z,]*[\$])+(.*)", code );
        if foundGeneric then
            evaluatedCode cat:= parts[1];
            evaluatedCode cat:= __eval_generic(
                parts[2],template`generics,generic_map);
            code := parts[3];
        else
            evaluatedCode cat:=code;
            code := "";
        end if;
    end while;

    // Eventually should be in temporary files space.
    filename := __name(template`name, generic_map);
   Write( "magma-meta/" cat filename cat ".m", evaluatedCode :
        Overwrite := true );
    specfilename := "magma-meta/" cat filename cat ".spec";
    Write( specfilename,  
        "{\r\n\t" cat filename cat ".m\r\n }\r\n" :
        Overwrite := true
     );
    AttachSpec( specfilename );
end procedure;

// Want type checking and variadic assume type any.  
// So hardwired.

intrinsic CompileTemplate( 
    template::TemplateType, 
    c1::Cat
) 
{Compiles a new type by substituting the given list of types for the generics.}
    compTemplate(template, [c1] );
end intrinsic;
intrinsic CompileTemplate( 
    template::TemplateType, 
    c1::Cat, c2::Cat
) 
{Compiles a new type by substituting the given list of types for the generics.}
    compTemplate(template, [c1,c2] );
end intrinsic;
intrinsic CompileTemplate( 
    template::TemplateType, 
    c1::Cat, c2::Cat, c3::Cat
) 
{Compiles a new type by substituting the given list of types for the generics.}
    compTemplate(template, [c1,c2,c3] );
end intrinsic;

intrinsic CompileTemplate( 
    template::TemplateType, 
    c1::Cat, c2::Cat, c3::Cat, c4::Cat
) 
{Compiles a new type by substituting the given list of types for the generics.}
    compTemplate(template, [c1,c2,c3,c4] );
end intrinsic;

// after five, it becomes a runtime checked.
intrinsic CompileTemplate( 
    template::TemplateType, 
    c1::Cat, c2::Cat, c3::Cat, c4::Cat, c5::Any, 
    ...
) 
{Compiles a new type by substituting the given list of types for the generics.}
    CompileTemplate(template, [c1,c2,c3,c4] cat c5 );
end intrinsic;



/*


intrinsic CompileGeneric(
    t::TemplateType,  
    generic_map::Any,
    ...
) 
{Compiles a new type by substituting the given list of types for the generics.}
    // Convert tuples into generic map.
 /*   if ISA(generic_map, Cat) then 
        generic_map := [generic_map];
    end if;
    require #generic_map eq #t`generics;
   */ 

    // We require the types provided be actuall types but we use 
    // them here only as strings.
 //   named_generic_map := [ Sprint(g) : g in generic_map];
    // Build a static unique identifier of the type
 //   evaltypename := __name(t`name,named_generic_map);
    // memoized type
//    if evaltypename in __meta_spec_list then
//        return; 
//    end if;

    // replace generics with values.
 //   evaluated_tree := &cat[ __eval_generic(node,t`generics,generic_map)
 //       : node in t`parsetree ];
 //   Write( "magma-meta/" cat evaltypename cat ".m", evaluated_tree :
 //       Overwrite := true );
//    Append(~__meta_spec_list, evaltypename );

    // Write an individual spec for it and attach
//    DetachSpec( __META_SPEC_FILE );
//    __write_meta_spec();   
//    AttachSpec( __META_SPEC_FILE );
/*
    specfilename := "magma-meta/" cat evaltypename cat ".spec";
    Write( specfilename,  "{\r\n\t" cat evaltypename cat ".m\r\n }\r\n" :
        Overwrite := true
     );
    AttachSpec( specfilename );
end intrinsic;
*/


/*
// Have a generic spec which loads 
// 
// List$A$.mt     
//
// it reads in this and converts each into a new generic type.
//
// To keep this roughly compile time, only advertized way to load 
// generic types is with a spec.
intrinsic AttachGenericSpec(
        filename::MonStgElt
) 
{Attaches the generic types in the file.}
    spec := Read(filename);
    lines := Split(spec, "\n");
    for filename in lines do
        try
            gdef := Read(filename);
            filelines := Split(gdef, "\n");
            // For ease sssumes files starts with
            // <name>
            // A,B,C,...
            name := fileline[s1]; 
            generics := Split(filelines[2],",");
            // if there is such a type, match the generic, and blow away the old.
            test := exists(t){g : g in __type_generics_list | g`name eq name };
            if not test then
                t := New(TemplateType);
                t`name := name;
                t`generics := generics;
                update(t);
            end if;
            // whether new or old, give it the new type definition.
            temp := &cat[filelines[i] : i in [3..#filelines]];
            // In the future should properly remove commented code from template.
            t`parsetree := Split( temp, "$" );
        catch
            Print( "Invalid file or format.\n" );
        end try;
    end for;
end intrinsic;

intrinsic AttachSpecWithGenerics(
        filename::MonStgElt
) 
{Attaches the generic types in the file.}
    spec := Read(filename);
    lines := Split(spec, "\n");
    for filename in lines do
        try
            thedef := Read(filename);
            isit, substr, middle := Regexp( thedef, "from-generic(.*);" );
            terms := Split(middle, "$");
            name := terms[1];
            generics := terms[2..#terms];
            
        catch
            Print( "Invalid file or format.\n" );
        end try;
    end for;
end intrinsic;
*/