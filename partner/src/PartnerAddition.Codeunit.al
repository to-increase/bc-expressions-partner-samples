codeunit 50142 PartnerAddition implements IInvokable2
{
    procedure Invoke(var return: Variant; p1: Variant; p2: Variant);
    var
        i1, i2 : Integer;
        lib: Codeunit MyLibrary;
    begin
        i1 := p1;
        i2 := p2;

        return := lib.MyAddition(i1, i2);
    end;




}