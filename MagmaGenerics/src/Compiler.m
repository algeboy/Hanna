/*

*/

/*
    name -> name
*/
intrinsic CompileParseTree( v::VarTkn ) -> MonStgElt
{}
    return " " cat v`name cat " ";
end intrinsic;

/*
    a = new A(x1,...,xn)  ->  
        a := New(A);
        a`x1 := x1;
        ...
        a`xn := xn;
*/
intrinsic CompileNewTerm( newTerm::TermTkn ) -> MonStgElt
{}
    magCode := " " cat newTerm`var cat " := New( " cat newTerm`type " );\r\n";
    for param in newTerm`params do
        magCode cat:= newTerm`var cat "`" cat param`name cat " := " cat param`name cat ";\r\n";
    end for;
    return magCode;
end intrinsic;

/*
    /**
        <first line doc>
        
        Extended doc
     *\/
    def f(xn:An,...,x1:A1):A0 = <exp>  ->  
        intrinsic f(xn::An,...,x1::A1) -> A0
        { <first line doc> }
            return <exp>;
        end instrinsic;
        
*/
intrinsic CompileNewTerm( newTerm::TermTkn ) -> MonStgElt
{}
    magCode := " " cat newTerm`var cat " := New( " cat newTerm`type " );\r\n";
    for param in newTerm`params do
        magCode cat:= newTerm`var cat "`" cat param`name cat " := " cat param`name cat ";\r\n";
    end for;
    return magCode;
end intrinsic;

