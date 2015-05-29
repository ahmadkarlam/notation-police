program InfixToPostfix;

uses sysutils;

type
	Point = ^Data;
	Data = Record
		Character : String;
		Number : Real;
		Next : Point;
	end;

	PointPostfix = ^DataPostfix;
	DataPostfix = Record
		TOperator : String;
		TOperand : Real;
		Next : PointPostfix;
	End;

	TString = array[1..255] of Char;

var
	Contoh: String;
	Contoh2: Char;

function Validation(Infix : String) : Boolean;

var
	i, Wrong, FoundOperator, FoundDoubleOperand, FoundDoubleOperator: Integer;

begin
	Wrong := 0;
	FoundOperator := 0;
	FoundDoubleOperand := 0;
	FoundDoubleOperator := 0;
	for i := 1 to Length(Infix) do
	begin
		case Infix[i] of
			'(', ')' : FoundOperator := FoundOperator + 1;
			'+', '-', 
			'*', '/', 
			'^'       : begin
							FoundOperator := FoundOperator + 1;
							case Infix[i + 1] of
								'+', '-', 
								'*', '/', 
								'^'       : FoundDoubleOperator := FoundDoubleOperator + 1;
							end;
						end;
			'B', 'C', 
			'D', 'E', 
			'F', 'G', 
			'H', 'I', 
			'J', 'K', 
			'L', 'M', 
			'N', 'O', 
			'P', 'Q', 
			'R', 'S', 
			'T', 'U', 
			'V', 'W', 
			'X', 'Y', 
			'Z', 'A' : begin
							case Infix[i + 1] of
								'B', 'C', 
								'D', 'E', 
								'F', 'G', 
								'H', 'I', 
								'J', 'K', 
								'L', 'M', 
								'N', 'O', 
								'P', 'Q', 
								'R', 'S', 
								'T', 'U', 
								'V', 'W', 
								'X', 'Y', 
								'Z', 'A' : FoundDoubleOperand := FoundDoubleOperand + 1;
							end;
					   end;
			else 
			begin
				If (Infix[i] <> ' ') Then
					Wrong := Wrong + 1;
			end;
		end;
		Writeln(i, ' . ', ' - ', Infix[i], ' - ', Wrong);
	end;
	Validation := True;
	If (Wrong > 0) Or (FoundOperator < 5) Or (FoundDoubleOperand > 0) Or (FoundDoubleOperator > 0) Then
		Validation := False;
end;

function IsEmpty(Stack : Point): Boolean;
begin
	IsEmpty := False;
	If (Stack = nil) Then
		IsEmpty := True;
end;

function OneNode(Stack : Point): Boolean;
begin
	OneNode := False;
	If (Stack^.Next = nil) Then
		OneNode := True;
end;

function Exponent(x, y : Integer): Real;

var
	i: Integer;

begin
	Exponent := 1;
	for i := 1 to y do
	begin
		Exponent := Exponent * x;
	end;
end;

procedure Initialize(var Stack : Point);

begin
	Stack := nil;
end;

procedure InitializePostfix(var Postfix : PointPostfix);

begin
	Postfix := nil;
end;

procedure InitializeArray(var ArrayValue : TString);

var
	i: Integer;

begin
	for i := 1 to 255 do
	begin
		ArrayValue[i] := ' ';
	end;
end;

procedure Push(var Stack : Point; Elemen : String);

var
	Node: Point;

begin
	New(Node);
	Node^.Character := Elemen;
	Node^.Next := Stack;
	Stack := Node;
end;

procedure Pop(var Stack : Point; var Elemen : String);

var
	Node: Point;

begin
	Node := Stack;
	Elemen := Node^.Character;
	if (not OneNode(Stack)) then
	begin
		Stack := Stack^.Next;
	end
	else
	begin
		Stack := nil;
	end;
	Dispose(Node);
end;

procedure AddNodeInLast(var FirstList, LastList : PointPostfix; TOperator : String; TOperand : Real);

var
	Node: PointPostfix;

begin
	New(Node);
	Node^.TOperand := TOperand;
	Node^.TOperator := TOperator;
	If (FirstList = nil) Then
	begin
		FirstList := Node;
	end
	else
	begin
		LastList^.Next := Node;
	end;
	LastList := Node;
end;

procedure ConvertInfixToPostfix(Infix : String; var Postfix : String);

var
	i: Integer;
	Stack: Point;
	LastCharacter : String;
	P : String;

begin
	Initialize(Stack);
	Push(Stack, '(');
	Infix := Infix + ')';
	P := '';
	Writeln('Q : ',Infix);
	for i := 1 to Length(Infix) do
	begin
		case Infix[i] of
			'B', 'C', 
			'D', 'E', 
			'F', 'G', 
			'H', 'I', 
			'J', 'K', 
			'L', 'M', 
			'N', 'O', 
			'P', 'Q', 
			'R', 'S', 
			'T', 'U', 
			'V', 'W', 
			'X', 'Y', 
			'Z', 'A' : P := P + Infix[i];							{ OPERAND KETEMU }
			'('      : Push(Stack, Infix[i]);						{ KURUNG BUKA KETEMU }
			'+', '-', 
			'*', '/', 
			'^'       : begin 										{ OPERATOR KETEMU }
							case Infix[i] of
								'^': Push(Stack, Infix[i]);
								'*',
								'/': begin
										while (Stack^.Character <> '(')	do
										begin
											case Stack^.Character of
												'^',
												'*',
												'/' : begin
															Pop(Stack, LastCharacter);
															P := P + LastCharacter;
														end;
											end;
										end;
										Push(Stack, Infix[i]);
									 end;
								'+',
								'-': begin
										while (Stack^.Character <> '(')	do
										begin
											case Stack^.Character of
												'^',
												'*',
												'/',
												'+',
												'-' : begin
															Pop(Stack, LastCharacter);
															P := P + LastCharacter;
														end;
											end;
										end;
										Push(Stack, Infix[i]);
									 end;
							end;
						end;
			')' : begin
					while (Stack^.Character <> '(')	do
					begin
						Pop(Stack, LastCharacter);
						P := P + LastCharacter;
					end;
					if (i <> Length(Infix)) Then
						Pop(Stack, LastCharacter);
				  end;
		end;
	end;
	Postfix := P;
	Writeln('P : ',Postfix);
end;

procedure InputInfix(var Infix : String);
begin
	Repeat
		Write('Masukkan notasi infix : ');
		Readln(Infix);
	Until Validation(Infix);
end;

procedure ConvertAlphabeticToNumeric(Postfix : String; var ExpressionPFirst, ExpressionPLast : PointPostfix);

var
	Stack: Point;
	x : Real;
	i : Integer;

begin
	for i := 1 to Length(Postfix) do
	begin
		case Postfix[i] of
			'B', 'C', 
			'D', 'E', 
			'F', 'G', 
			'H', 'I', 
			'J', 'K', 
			'L', 'M', 
			'N', 'O', 
			'P', 'Q', 
			'R', 'S', 
			'T', 'U', 
			'V', 'W', 
			'X', 'Y', 
			'Z', 'A' : begin
						Write('Masukkan angka untuk ', Postfix[i], ' : ');
						Readln(x);
						AddNodeInLast(ExpressionPFirst, ExpressionPLast, '', x);
					   end;
			else
					AddNodeInLast(ExpressionPFirst, ExpressionPLast, Postfix[i], 0);
		end;
	end;
end;

procedure Calculate(PostfixFirst, PostfixLast : PointPostfix; var Result : Real);

var
	Stack : Point;
	Transversal : PointPostfix;
	Operand1, Operand2, Total: Real;
	Operand : String;
	Operand1Integer, Operand2Integer : Integer;
	

begin
	Initialize(Stack);
	AddNodeInLast(PostfixFirst, PostfixLast, ')', 0);
	Transversal := PostfixFirst;
	While (Transversal^.TOperator <> ')') do
	begin
		Writeln(Stack^.Character);
		If 	(Transversal^.TOperator = '-') Then
		begin
			Pop(Stack, Operand);
			Operand2 := StrToFloat(Operand);
			Pop(Stack, Operand);
			Operand1 := StrToFloat(Operand);
			Total := Operand1 - Operand2;
		end
		Else If (Transversal^.TOperator = '+') Then
		begin
			Pop(Stack, Operand);
			Operand2 := StrToFloat(Operand);
			Pop(Stack, Operand);
			Operand1 := StrToFloat(Operand);
			Total := Operand1 + Operand2;
		end
		Else If (Transversal^.TOperator = '/') Then
		begin
			Pop(Stack, Operand);
			Operand2 := StrToFloat(Operand);
			Pop(Stack, Operand);
			Operand1 := StrToFloat(Operand);
			Total := Operand1 / Operand2;
		end
		Else If (Transversal^.TOperator = '*') Then
		begin
			Pop(Stack, Operand);
			Operand2 := StrToFloat(Operand);
			Pop(Stack, Operand);
			Operand1 := StrToFloat(Operand);
			Total := Operand1 * Operand2;
		end
		Else If (Transversal^.TOperator = '^') Then
		begin
			Pop(Stack, Operand);
			Operand2Integer := StrToInt(Operand);
			Pop(Stack, Operand);
			Operand1Integer := StrToInt(Operand);
			Total := Exponent(Operand1Integer, Operand2Integer);
		end
		else
		begin
			Push(Stack, FloatToStr(Transversal^.TOperand));
		end;
		Transversal := Transversal^.Next;
	end;
	Pop(Stack, Operand);
	Result := StrToFloat(Operand);
end;

procedure Main();

var
	Infix, Postfix: String;
	PostfixFirst, PostfixLast, Bantu: PointPostfix;
	Total : Real;

begin
	{ Input Infix }
	InputInfix(Infix);
	{ Convert Infix to Postfix }
	ConvertInfixToPostfix(Infix, Postfix);
	{ Memasukkan nilai pada setiap huruf di notasi infix }
	InitializePostfix(PostfixFirst);
	InitializePostfix(PostfixLast);
	ConvertAlphabeticToNumeric(Postfix, PostfixFirst, PostfixLast);
	{ Menghitung hasil dari notasi postfix }
	Calculate(PostfixFirst, PostfixLast, Total);
	Writeln(Total:0:0);
end;

begin
	Main();
	Readln;
end.
