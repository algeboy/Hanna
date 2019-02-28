// MACHINE GENERATED CODE: EDITS WILL BE OVERWRITTEN

declare type EitherMonStgEltRngIntElt;

// Left ========================================================
declare type LeftMonStgElt : EitherMonStgEltRngIntElt;

intrinsic Unit(a::MonStgElt) -> LeftMonStgElt 
{}
    left := New( LeftMonStgElt );
    left`__val := a;
    return left;
end intrinsic;

intrinsic Left(a::MonStgElt) -> LeftMonStgElt 
{}
    return Unit(a);
end intrinsic;

intrinsic Unapply(s::LeftMonStgElt) -> MonStgElt
{Unapply to extract the value of left.}
    return s`__val;
end intrinsic;

intrinsic Sprint(a::LeftMonStgElt) -> MonStgElt
{}
    return Sprint(Unapply(a));
end intrinsic;

intrinsic Print(a::LeftMonStgElt)
{}
    print(Sprint(a));
end intrinsic;

// RIGHT =================================================
declare type RightRngIntElt : EitherMonStgEltRngIntElt;

intrinsic Unit(b::RngIntElt) -> RightRngIntElt 
{}
    r := New( RightRngIntElt );
    r`__val := b;
    return r;
end intrinsic;

intrinsic Right(b::RngIntElt) -> RightRngIntElt 
{}
    return Unit(b);
end intrinsic;

intrinsic Unapply(s::RightRngIntElt) -> RngIntElt
{Unapply to extract the value of right.}
    return s`__val;
end intrinsic;

intrinsic Sprint(b::RightRngIntElt) -> MonStgElt
{}
    return Sprint(Unapply(b));
end intrinsic;

intrinsic Print(b::RightRngIntElt)
{}
    print(Sprint(b));
end intrinsic;

