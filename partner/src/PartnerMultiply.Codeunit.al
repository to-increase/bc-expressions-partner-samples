codeunit 50145 PartnerMultiply implements IInvokable2
{

    procedure Invoke(var return: Variant; p1: Variant; p2: Variant);
    var
        i1, i2 : Integer;
    begin
        i1 := p1;
        i2 := p2;

        return := MyMultiply(i1, i2);
    end;

    local procedure MyMultiply(p1: Integer; p2: Integer): Integer;
    begin
        exit(p1 * p2);
    end;


}