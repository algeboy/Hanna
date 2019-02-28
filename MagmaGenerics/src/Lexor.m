/*

A bare-bones lexor for the Hanna language.
This one runs on Magma, the point being, to
let folks run Hanna code having only Magma.

*/

declare type ListToken;
declare type NillListToken : ListToken;
declare type ConsToken : ListToken;
declare attributes ConsToken : head, tail, stream, lineCount;

// Delimiters 
__WhiteSpace    := {" ", "\t", "\r", "\n"};
__Punctuation   := {".", ",", ";"};

__OpenGrouping  := {"(", "[", "{", "//", "\""};
__CloseGrouping := {")", "]", "{", "\""};
__Operators     := {"->", ":", ">", "<", "+", "-", "*", "|", "&", "=" };
__Keywords      := {"def", "trait" };

IsDelimiter := function( t )
    return  (t in __WhiteSpace)     or 
            (t in __Punctuation)    or
            (t in __OpenGrouping)   or
            (t in __CloseGrouping)  or
            (t in __Operators);
end function;

ScanUntil := function (stream, Ending )
    head := 1;
    while (head lt #stream) and not Ending(stream[head]) do 
        head +:= 1;
    end while;
    if head ge #stream then 
        return stream[1..(head-1)], ""; 
    else 
        return stream[1..(head-1)], stream[head..#stream];
    end if;
end function;


ScanLongComment := function( stream )
    head := 1; ct := 0;
    while ((head+1) le #stream) do
        if stream[head..(head+1)] eq "*/" then
            return stream[3..(head-1)], stream[(head+2)..#stream], ct;
        end if;
        if stream[head] eq "\n" then ct +:= 1; end if;
        head +:= 1;
    end while;
    // Should raise syntax error.
    return stream, _, ct;
end function;

ScanString := function( stream )
    head := 2; 
    while (head lt #stream) do
        if stream[head] eq "\"" then
            if not ( stream[(head-1)..head] eq "\\\"") then
                return stream[1..head], stream[(head+1)..#stream];
            end if;
        end if;
        head +:= 1;
    end while;
    // Should raise syntax error.
    return stream, 0;
end function;

RemoveWhiteSpace := function (stream )
    head := 1;
    lineCount := 0;
    while head lt #stream and stream[head] in __WhiteSpace do 
        if stream[head] eq "\n" then lineCount +:= 1; end if;
        head +:= 1; 
    end while;
    stream := stream[head..#stream];
    return stream, lineCount;
end function;


intrinsic Tokenize(stream::MonStgElt ) -> ListToken
{Turn string stream into token stream.}
    // trim leading whitespace.
    lineCount := 0;
    if #stream eq 0 then 
        return New(NillListToken); 
    else
        t := New(ConsToken);
        t`stream := stream;  // ideally this would be lazy call 
        t`lineCount := 0;
        // leave tail unset.
        return t;
    end if;
end intrinsic;

// line count is a side effect.
intrinsic Head( ts::ConsToken ) -> Tkn
{Return first token}
    if HasAttribute(ts,"head") then 
        return ts`head; 
    else
        stream := ts`stream;
        // trim leading whitespace.
        lineCount := 0;
//    isLineComment, comments, newstream := Regexp( "//.*\n(.*)", stream[head..length] );
 //   if isLineComment then return Split(newstream); end if;
        while #stream ge 2 and ( stream[1] in __WhiteSpace or stream[1..2] in {"//", "/*"}  ) do
            if #stream ge 2 and stream[1..2] eq "//" then
                comment, stream  := ScanUntil( stream, func<x| x eq "\n"> );
                "", comment;
                lineCount +:= 1;
            end if;
            if #stream ge 2 and stream[1..2] eq "/*" then
                comment, stream, ct := ScanLongComment( stream );
                "", comment;
                lineCount +:= ct;
            end if;
            
            stream, ct := RemoveWhiteSpace(stream);
            lineCount +:= ct;
        end while;
        // don't recurse, it will blow the stack.
        stream, ct := RemoveWhiteSpace(stream);
        lineCount +:= ct;

        // Scan for first token.
        if stream[1] eq "\"" then 
            head, tail := ScanString(stream); 
        else
            head, tail := ScanUntil(stream, IsDelimiter);
        end if;
        if #head eq 0 and #tail gt 0 then 
            if tail[1] in __Punctuation then 
                tail := tail[2..#tail];
            end if;
            if tail[1] in (__OpenGrouping join __CloseGrouping join __Operators ) then
                head := tail[1];
                tail := tail[2..#tail];
            end if;
            if (#tail gt 2) and (tail[1..2] eq "->") then
                head := head[1..2];
                tail := tail[3..#tail];
            end if;
        end if;
        if #tail gt 0 and tail[1] eq "\n" then lineCount +:= 1; end if;
        ts`head := ToToken(head);
        ts`lineCount +:= lineCount;
        ts`tail := Tokenize(tail);  // lazy, so no recursive
        if ISA(Type(ts`tail), ConsToken) then
            ts`tail`lineCount := lineCount;
        end if;
//        "head", head;
//        "tail", tail;
        return ts`head;
    end if;
end intrinsic;


intrinsic Tail(ts::ConsToken) -> ListToken
{Tail of token list.}
    if HasAttribute(ts,"tail") then 
        return ts`tail; 
    else
        Head(ts);  
        // yeah, since I don't have lazy eval need to call head
        return ts`tail;
    end if;
end intrinsic;

intrinsic Sprint(tkns::ConsToken) -> MonStgElt
{}
    oldLine := -1;
    prtOut := "";
    while ISA( Type(tkns), ConsToken ) do
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

intrinsic Print(tkns::ConsToken) 
{Print token list.} 
    print(Sprint(tkns));
end intrinsic;
