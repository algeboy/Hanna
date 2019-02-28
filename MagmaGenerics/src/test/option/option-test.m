// ========================================================
// In the future want some syntatic sugar like this...
//
// import "generics/Option.mt" : Option$A$;
// declare type Option$RngIntElt$;
//
// Which will expand to something like this...

AttachSpec( "Generic.Spec" );
Option := NewGenericType( "generics/Option.mt" );
CompileGeneric( Option, RngIntElt );
CompileGeneric( Option, RngIntResElt );

//==========================================================

optdiv := function( a,b  )
    if b eq 0 then
        return None();
    else 
        x := a div b;
        return Some(x);
//        return Some(x);
    end if;
end function;

xZ := optdiv(10,5);
yZ := optdiv(10,0);

R := Integers(12);
xR := optdiv(R!10,R!5);
yR := optdiv(R!10,R!0);

yZ eq yR;



