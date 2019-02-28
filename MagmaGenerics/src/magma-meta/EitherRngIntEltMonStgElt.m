// MACHINE GENERATED CODE: EDITS WILL BE OVERWRITTEN

declare type EitherRngIntEltMonStgElt;

// Left ========================================================
declare type LeftRngIntElt : EitherRngIntEltMonStgElt;

intrinsic Unit(a::RngIntElt) -> LeftRngIntElt 
{}
    left := New( LeftRngIntElt );
    left`__val := a;
    return left;
end intrinsic;

intrinsic Left(a::RngIntElt) -> LeftRngIntElt 
{}
    return Unit(a);
end intrinsic;

intrinsic Unapply(s::LeftRngIntElt) -> RngIntElt
{Unapply to extract the value of left.}
    return s`__val;
end intrinsic;

intrinsic Sprint(a::LeftRngIntElt) -> MonStgElt
{}
    return Sprint(Unapply(a));
end intrinsic;

intrinsic Print(a::LeftRngIntElt)
{}
    print(Sprint(a));
end intrinsic;

// RIGHT =================================================
declare type RightMonStgElt : EitherRngIntEltMonStgElt;

intrinsic Unit(b::MonStgElt) -> RightMonStgElt 
{}
    r := New( RightMonStgElt );
    r`__val := b;
    return r;
end intrinsic;

intrinsic Right(b::MonStgElt) -> RightMonStgElt 
{}
    return Unit(b);
end intrinsic;

intrinsic Unapply(s::RightMonStgElt) -> MonStgElt
{Unapply to extract the value of right.}
    return s`__val;
end intrinsic;

intrinsic Sprint(b::RightMonStgElt) -> MonStgElt
{}
    return Sprint(Unapply(b));
end intrinsic;

intrinsic Print(b::RightMonStgElt)
{}
    print(Sprint(b));
end intrinsic;

