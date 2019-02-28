
## Hanna

# Using Generics

```
> AttachSpec( "Template.Spec");
> Option := AttachTemplate( "generics/Option.mt" );
> CompileTemplate(Option, RngIntElt);
> CompileTemplate(Option, MonStgElt);
> Some(5);
5

> Some("Five");
Five

> Unapply(Some(5));
5
> Either := AttachTemplate( "generics/Either.mt" );
> CompileTemplate(Either, RngIntElt, MonStgElt);
> Left(5);
```