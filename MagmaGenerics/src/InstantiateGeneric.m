// Creates a concrete type from a generic type.
import "GenericType.m" : GenericType;

// CAUTION SIDE EFFECT LAYER===========================================================
//GLOBAL META SPEC FILE.
__META_FOLDER := "magma-meta/";
__META_SPEC_FILE := __META_FOLDER cat "magma-meta";
__meta_spec_list := {MonStgElt| };

__write_meta_spec := procedure()

    temp := "{";
    temp cat:= &cat[ "\t" cat filename cat "\r\n" : filename in __meta_spec_list ];
    temp cat:= "}";
    Write( "magma-meta/meta.spec", temp);
end procedure;
//=====================================================================================

__eval_generic := function( node, generics, generic_map )
    if exists(i){i : i in [1..#generics] | node in generics } then
        return generic_map[i];
    else 
        return seg;
    end if;
end function;

// a static naming convention that (hopefully) does not polute the namespace.
__name := function (meta_name,generics)
    im := &cat[ "$"!g[2] cat "$" : g in generics ];
    return meta_name cat im cat StringToCode(meta_name cat im );
end function;


intrinsic CompileGeneric(
    t::GenericType,  
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
    named_generic_map := [ Sprint(g) : g in generic_map];
    // Build a static unique identifier of the type
    evaltypename := __name(t`name,named_generic_map);
    // memoized type
    if evaltypename in __meta_spec_list then
        return; 
    end if;

    // replace generics with values.
    evaluated_tree := &cat[ __eval(node,t`generics,generic_map) | node in t`biuldtree ];
    WriteFile( "magma-meta/" cat evaltypename cat ".m", evaluated_segments );
    Append(~__meta_spec_list, evaltypename );

    // Write an individual spec for it and attach
//    DetachSpec( __META_SPEC_FILE );
//    __write_meta_spec();   
//    AttachSpec( __META_SPEC_FILE );

    Write( "magma-meta/" cat evaltypename cat ".spec", "{" cat evaltypename cat "}" );
end intrinsic;

