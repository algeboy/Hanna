
declare type ParseTree;

declare type TermTkn : ParseTree;
declare attributes TermTkn : var, type, params;

declare type TypeTree : ParseTree;
declare attributes TypeTree : variable, type;

declare type FuncTree : TypeTree;
declare attributes FuncTree : exp;


// Semantic assignment: <var>:<type>, head set at <var>
intrinsic DefTree(name::VarTkn,inType:ParseTree, outType:TypeTkn, exp::ParseTree ) -> ParseTree
{}
    fnc := New(FuncTree);
    fnc`variable := var;
    fnc`type := type;
    tree`
    return tree;
end intrinsic;


/*
    <params> := <params>, 
 */
// <term> := new <type>(<params>)

// Semantic assignment: <var>:<type>, head set at <var>
intrinsic TypeTree(var::VarTkn,type::VarTkn) -> ParseTree
{}
    tree := New(TypeTree);
    tree`variable := var;
    tree`type := type;
    return tree;
end intrinsic;

/*

<var> := [A-z] | <var>;

<type> := Type                  // Primitive types
        | Any                   
        | Nothing
        | <var> : Type          // Type builders...
        | <type> -> <type>      // function type
        | <type> '*' <type>     // product of types
        | <type> '+' <type>     // sum of types
        | <type>^?              // Option monad
        | <type>[<var>*]        // Type with generics.
    

<func> := <var> : <type> -> <type> : <var> -> <exp>
        | def <name> (<var> : <type> ):<type> = <exp>
        

<term> := <var> : <type>

<type> := <> : <>;
*/

intrinsic Parse(thedef::DefTkn, var:: tkns::ConsTkn) -> ParseTree
{}
    fnc := New(FuncTree);
    if ISA(Head(tkns), "VarTkn")
    fnc`variable := var;
    fnc`type := type;
    fnc`exp := 
    return tree;

end instrinsic;

intrinsic Parse(tkns::ConsTkn) -> ParseTree
{}
    oldLine := -1;
    tree := New(ParseTree);
    while ISA( Type(tkns), ConsToken ) do
        tkn := Head(tkns);
        case Type(tkn) :
            when DefTkn :
                tkns := Tail(tkns);
                var := Head(tkns);
                if not ISA( var, "VarTkn" ) then
                    "Syntax error line ", tkns`lineCount, " should be function name.  Given ", var, "\n";
                    break;
                end if;
        
                lparen := Head(tkns);
                if not ISA( lparen, "LParen" ) then
                    "Syntax error line ", tkns`lineCount, ". Expected '(', given ", lparen, "\n";
                    break;
                end if;
                params, tail := SplitAtFirst(tkns, CloseTkn);

                lparen := Head(tkns);
                if not ISA( rparen, "RParen" ) then
                    "Syntax error line ", tkns`lineCount, ". Expected '(', given ", rparen, "\n";
                    break;
                end if;
                
        if ISA( tkn, KeyTkn ) then
            // Now we know exactly what to do.
             tkn`
        end if;
        if tkns`lineCount gt oldLine then 
            prtOut cat:= "\n";
            oldLine := tkns`lineCount;
            prtOut cat:= "#" cat Sprint( oldLine );
        end if;
        prtOut cat:= " " cat Sprint( Head(tkns) );
        tkns := tkns`tail;
    end while;
    return prtOut;
end intrinsic;
