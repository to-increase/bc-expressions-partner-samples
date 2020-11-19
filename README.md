- [1. How to For Partners: Contribute Your Own Expression Function](#1-how-to-for-partners-contribute-your-own-expression-function)
  - [1.1. About](#11-about)
  - [For existing expression users: what has changed for you?](#for-existing-expression-users-what-has-changed-for-you)
  - [1.2. General procedure to expose your functions as invokable functions in TI Expressions](#12-general-procedure-to-expose-your-functions-as-invokable-functions-in-ti-expressions)


# 1. How to For Partners: Contribute Your Own Expression Function

## 1.1. About

Tis repo contains several sample implementations to expose your functions as invokable functions in TI Expressions.

As the sample shows, you don't have to move existing code around. All you need to add is a light weight facade. 

## For existing expression users: what has changed for you?

1. We simplified the way you hook into our expression system. See [1.2. General procedure to expose your functions as invokable functions in TI Expressions](#1-how-to-for-partners-contribute-your-own-expression-function)

2. The way you reference your exposed function  in an expression has also changed. You now refer to it by this syntax <br>
   ```
   codeunit:<enumid>:<enumvalue>
   ```

## 1.2. General procedure to expose your functions as invokable functions in TI Expressions

Suppose you a as a partner want to use your own code to be invoked from an TI BIS expression.
These are the following things you need to do.

1. Write your function, or identify the function you want to expose to BIS as an invokable expression method.
In this example we need to expose `MyMethod(p1: Integer, p2: Integer) : Integer`.

2. Note the type signature of your method from step 1. The signature consists of 
    1. the return type (if it has any)
    2. the types of the parameters

3. Note the right IInvokable\<n\> interface to implement, n being the number of parameters of your method. As in the exampele the method has 2 arguments, you will need to use interface IInvokable2.

4. Write a codeunit that implements the interface you selected in the previous step. You do this by writing a method Invoke that always accepts a var return Type of Variant type as first argument, and the other arguments as Variants as well. For example

```fortran
codeunit 50145 PartnerMyMethod implements IInvokable2
{

    procedure Invoke(var return: Variant; p1: Variant; p2: Variant);
    var
        i1, i2 : Integer;
    begin
        i1 := p1;
        i2 := p2;

       return := MyMethod(i1, i2);
    end;

    local procedure MyMethod(p1: Integer, p2: Integer) : Integer;
    begin
        exit(p1 * p2);
    end;

} 
```

5. Add your codeunit from the previous step to the extendable enum. There are multiple enums Invokable\<n\>, you need to select the one that corresponds to the number of arguments as done in step 3. To prevent clashes, the enum ID should be the codeunit number from step 4.
To extend the previous example :

```fortran
enumextension 50141 PartnerInvokable2 extends Invokable2
{
    value(50145; PartnerMyMethod)
    {
        Implementation = IInvokable2 = PartnerMyMethod;
    }
}
```
6. Note the enum id from step 1 (which is the same as the codeunit number from step 4), together with the arguments of step 2\. 
<br>Register  your codeunit in table `InvokableExpressionMethods`. You could use an  install type codeunit to automically register your expressions during installation of your BC extension.

**Comments**

Allthough each Invoke\<arity\>  specifies its arguments to be of type Variant, <mark>we type check</mark> the values before we call Invoke(...).<br>
So when we evaluate expression <kbd>Codeunit:51045:PartnerMyMethod(3, "bar" ) + 4</kbd>, we will *not* invoke codeunit `PartnerMyMethod` but will show you instead an error that we expect an Integer instead of text "bar".