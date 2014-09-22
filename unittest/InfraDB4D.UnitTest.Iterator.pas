unit InfraDB4D.UnitTest.Iterator;

interface

uses
  Data.DB,
  DBClient,
  TestFramework,
  InfraDB4D.Iterator,
  System.SysUtils;

type

  TestTIteratorDataSet = class(TTestCase)
  strict private
    function BuildDataSet(): TClientDataSet;
  published
    procedure TestIteratorWithDataSet();
    procedure TestIteratorWithBuildAsDataSet();
  end;

implementation

uses
  InfraDB4D;

{ TestTIteratorDataSet }

function TestTIteratorDataSet.BuildDataSet: TClientDataSet;
begin
  Result := TClientDataSet.Create(nil);
  Result.FieldDefs.Add('One', ftInteger);
  Result.CreateDataSet();
end;

procedure TestTIteratorDataSet.TestIteratorWithBuildAsDataSet;
var
  Iterator: IIteratorDataSet;
begin

  Iterator := TIteratorDataSetFactory.Get(
    { use metod BuildAsDataSet } BuildDataSet(), True { Parameter TRUE destroy CdsDataSet } );

  CheckTrue(Iterator.IsEmpty());

  while (Iterator.HasNext) do // loop in dataset - Don't is need to use TDataSet.Next
  begin
    Iterator.RecIndex; // get index current record dataset
    // your code
  end;

end;

procedure TestTIteratorDataSet.TestIteratorWithDataSet;
var
  Iterator: IIteratorDataSet;
  CdsDataSet: TClientDataSet;

  procedure AddValueInDataSet(const pCity, pState: string; const pPosition: Integer);
  begin
    CdsDataSet.Insert();
    CdsDataSet.FieldByName('City').AsString := pCity;
    CdsDataSet.FieldByName('State').AsString := pState;
    CdsDataSet.FieldByName('Position').AsInteger := pPosition;
    CdsDataSet.Post();
  end;

begin
  // You can to use any class inherited TDataSet
  // I will create a TClientDataSet for example

  CdsDataSet := TClientDataSet.Create(nil);

  CdsDataSet.FieldDefs.Add('City', ftString, 20);
  CdsDataSet.FieldDefs.Add('State', ftString, 2);
  CdsDataSet.FieldDefs.Add('Position', ftInteger);
  CdsDataSet.CreateDataSet;

  AddValueInDataSet('S�o Paulo', 'SP', 1);
  AddValueInDataSet('Maravilha', 'SC', 2);
  AddValueInDataSet('S�o Miguel do Oeste', 'SC', 3);

  CdsDataSet.IndexFieldNames := 'City'; // order dataset for test

  Iterator := TIteratorDataSetFactory.Get(CdsDataSet, True { Parameter TRUE destroy CdsDataSet } );

  CheckFalse(Iterator.IsEmpty());

  while (Iterator.HasNext) do // loop in dataset - Don't is need to use TDataSet.Next
  begin

    if (Iterator.RecIndex = 1) then // get index current record dataset
    begin
      CheckEquals('Maravilha', Iterator.FieldByName('City').AsString, 'RecIndex = ' + Iterator.RecIndex.ToString); // acess field in dataset
      CheckEquals('SC', Iterator.FieldByName('State').AsString, 'RecIndex = ' + Iterator.RecIndex.ToString);
      CheckEquals(2, Iterator.FieldByName('Position').AsInteger, 'RecIndex = ' + Iterator.RecIndex.ToString);
    end
    else
      if (Iterator.RecIndex = 2) then
    begin
      CheckEquals('S�o Miguel do Oeste', Iterator.FieldByName('City').AsString, 'RecIndex = ' + Iterator.RecIndex.ToString);
      CheckEquals('SC', Iterator.FieldByName('State').AsString, 'RecIndex = ' + Iterator.RecIndex.ToString);
      CheckEquals(3, Iterator.FieldByName('Position').AsInteger, 'RecIndex = ' + Iterator.RecIndex.ToString);
    end
    else
      if (Iterator.RecIndex = 1) then
    begin
      CheckEquals('S�o Paulo', Iterator.FieldByName('City').AsString, 'RecIndex = ' + Iterator.RecIndex.ToString);
      CheckEquals('SP', Iterator.FieldByName('State').AsString, 'RecIndex = ' + Iterator.RecIndex.ToString);
      CheckEquals(1, Iterator.FieldByName('Position').AsInteger, 'RecIndex = ' + Iterator.RecIndex.ToString);
    end;
  end;

end;

initialization

// Register any test cases with the test runner
RegisterTest(TestTIteratorDataSet.Suite);

end.