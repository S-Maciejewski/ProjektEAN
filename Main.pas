unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IntervalArithmetic;

type
   TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    CheckBox1: TCheckBox;
    Label5: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    CheckBox2: TCheckBox;

    procedure Button1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

  vector = array of Extended;
  vector1 = array of Extended;
  vector2 = array of Extended;
  vector3 = array of Extended;
  matrix = array of array of Extended;

  Ivector = array of interval;
  Ivector1 = array of interval;
  Ivector2 = array of interval;
  Ivector3 = array of interval;
  Imatrix = array of array of interval;

var
  Form1: TForm1;
  n: Integer;
  x: vector;
  f: vector;
  a: matrix;
  st: Integer;
  inputNumber: Integer;
  tmp: String;
  i: Integer;
  j: Integer;
  f1x0: Extended;
  f1xn: Extended;
  xx: Extended;
  Wynik: Extended;

  x2: Ivector;
  f2: Ivector;
  f1x02: interval;
  f1xn2: interval;
  a2: Imatrix;
  xx2: interval;
  Wynik2: interval;
  Wynik2_lewy: String;
  Wynik2_prawy: String;
  Edit2: TEdit;

  tmp2 : interval;
  tmp3 : interval;
  tmp2_lewy: String;
  tmp2_prawy: String;
  tmp3_lewy: String;
  tmp3_prawy: String;

  t_ex : extended;


implementation

{$R *.dfm}

{---------------------------------------------------------------------------}
{  The procedure clampedsplinecoeffns calculates the coefficients of the    }
{  clamped cubic spline interpolant for a function given by its values at   }
{  nodes and values of its derivative at the ends of interval.              }
{  Data:                                                                    }
{    n    - number of interpolation nodes minus 1 (the nodes are numbered   }
{           from 0 to n),                                                   }
{    x    - an array containing the values of nodes,                        }
{    f    - an array containing the values of function,                     }
{    f1x0 - a value of derivative at x[0],                                  }
{    f1xn - a value of derivative at x[n].                                  }
{  Result:                                                                  }
{    a  - an array of spline coefficients (the element a[k,i] contains the  }
{         coefficient before x^k, where k=0,1,2,3, for the interval         }
{         <x[i], x[i+1]>; i=0,1,...,n-1).                                   }
{  Other parameters:                                                        }
{    st - a variable which within the procedure clampedsplinecoeffns is     }
{         assigned the value of:                                            }
{           1, if n<1,                                                      }
{           2, if there exist x[i] and x[j] (i<>j; i,j=0,1,...,n) such      }
{              that x[i]=x[j],                                              }
{           0, otherwise.                                                   }
{         Note: If st<>0, then the elements of array a are not calculated.  }
{  Unlocal identifiers:                                                     }
{    vector  - a type identifier of extended array [q0..qn], where q0<=0    }
{              and qn>=n,                                                   }
{    vector1 - a type identifier of extended array [q0..qn1], where q0<=0   }
{              and qn1>=n-1,                                                }
{    vector2 - a type identifier of extended array [q1..qn], where q1<=1    }
{              and qn>=n,                                                   }
{    matrix  - a type identifier of extended array [0..3, q0..qn1], where   }
{              q0<=0 and qn1>=n-1.                                          }
{---------------------------------------------------------------------------}

procedure clampedsplinecoeffns (n         : Integer;
                                x,f       : vector;
                                f1x0,f1xn : Extended;
                                var a     : matrix;
                                var st    : Integer);

var i,k        : Integer;
    u,v,y,z,xi : Extended;
    d          : vector;
    b          : vector1;
    c          : vector2;
begin
SetLength(b,n);
SetLength(c,n);
SetLength(d,n);

  if n<1
    then st:=1
    else begin
           st:=0;
           i:=-1;
           repeat
             i:=i+1;
             for k:=i+1 to n do
               if x[i]=x[k]
                 then st:=2
           until (i=n-1) or (st=2)
         end;
  if st=0
    then begin
           b[0]:=1;
           u:=x[1]-x[0];
           d[0]:=6*((f[1]-f[0])/u-f1x0)/u;
           c[n]:=1;
           u:=x[n]-x[n-1];
           d[n]:=6*(f1xn-(f[n]-f[n-1])/u)/u;
           for i:=1 to n-1 do
             begin
               z:=x[i];
               y:=x[i+1]-z;
               z:=z-x[i-1];
               u:=f[i];
               b[i]:=y/(y+z);
               c[i]:=1-b[i];
               d[i]:=6*((f[i+1]-u)/y-(u-f[i-1])/z)/(y+z)
             end;
           u:=2;
           i:=-1;
           y:=d[0]/u;
           d[0]:=y;
           repeat
             i:=i+1;
             z:=b[i]/u;
             b[i]:=z;
             u:=2-z*c[i+1];
             y:=(d[i+1]-y*c[i+1])/u;
             d[i+1]:=y
           until i=n-1;
           u:=d[n];
           for i:=n-1 downto 0 do
             begin
               u:=d[i]-u*b[i];
               d[i]:=u
             end;
           for i:=0 to n-1 do
             begin
               u:=f[i];
               xi:=x[i];
               z:=x[i+1]-xi;
               y:=d[i];
               v:=(f[i+1]-u)/z-(2*y+d[i+1])*z/6;
               z:=(d[i+1]-y)/(6*z);
               y:=y/2;
               a[0,i]:=((-z*xi+y)*xi-v)*xi+u;
               u:=3*z*xi;
               a[1,i]:=(u-2*y)*xi+v;
               a[2,i]:=y-u;
               a[3,i]:=z
             end
         end
end;

procedure intervalclampedsplinecoeffns (n         : Integer;
                                x,f       : Ivector;
                                f1x0,f1xn : interval;
                                var a     : Imatrix;
                                var st    : Integer);

var i,k        : Integer;
    u,v,y,z,xi : interval;
    d          : Ivector;
    b          : Ivector1;
    c          : Ivector2;
begin
SetLength(b,n);
SetLength(c,n);
SetLength(d,n);

  if n<1
    then st:=1
    else begin
           st:=0;
           i:=-1;
           repeat
             i:=i+1;
             for k:=i+1 to n do
               if compare_equal(x[i],x[k])
                 then st:=2
           until (i=n-1) or (st=2)
         end;
  if st=0
    then begin
           b[0]:=1;
           u:=x[1]-x[0];
           d[0]:=6*((f[1]-f[0])/u-f1x0)/u;
           c[n]:=1;
           u:=x[n]-x[n-1];
           d[n]:=6*(f1xn-(f[n]-f[n-1])/u)/u;
           for i:=1 to n-1 do
             begin
               z:=x[i];
               y:=x[i+1]-z;
               z:=z-x[i-1];
               u:=f[i];
               b[i]:=y/(y+z);
               c[i]:=1-b[i];
               d[i]:=6*((f[i+1]-u)/y-(u-f[i-1])/z)/(y+z)
             end;
           u:=2;
           i:=-1;
           y:=d[0]/u;
           d[0]:=y;
           repeat
             i:=i+1;
             z:=b[i]/u;
             b[i]:=z;
             u:=2-z*c[i+1];
             y:=(d[i+1]-y*c[i+1])/u;
             d[i+1]:=y
           until i=n-1;
           u:=d[n];
           for i:=n-1 downto 0 do
             begin
               u:=d[i]-u*b[i];
               d[i]:=u
             end;
           for i:=0 to n-1 do
             begin
               u:=f[i];
               xi:=x[i];
               z:=x[i+1]-xi;
               y:=d[i];
               v:=(f[i+1]-u)/z-(2*y+d[i+1])*z/6;
               z:=(d[i+1]-y)/(6*z);
               y:=y/2;
               a[0,i]:=((-z*xi+y)*xi-v)*xi+u;
               u:=3*z*xi;
               a[1,i]:=(u-2*y)*xi+v;
               a[2,i]:=y-u;
               a[3,i]:=z
             end
         end
end;


{---------------------------------------------------------------------------}
{  The function clampedsplinevalue calculates the value of the clamped      }
{  cubic spline interpolant for a function given by its values at nodes and }
{  values of its derivative at the ends of interval.                        }
{  Data:                                                                    }
{    n    - number of interpolation nodes minus 1 (the nodes are numbered   }
{           from 0 to n),                                                   }
{    x    - an array containing the values of nodes,                        }
{    f    - an array containing the values of function,                     }
{    f1x0 - a value of derivative at x[0],                                  }
{    f1xn - a value of derivative at x[n],                                  }
{    xx   - the point at which the value of interpolating spline should     }
{           be calculated.                                                  }
{  Result:                                                                  }
{    clampedsplinevalue(n,x,f,f1x0,f1xn,xx,st) - the value of clamped       }
{                                                spline at xx.              }
{  Other parameters:                                                        }
{    st - a variable which within the function clampedsplinevalue is        }
{         assigned the value of:                                            }
{           1, if n<1,                                                      }
{           2, if there exist x[i] and x[j] (i<>j; i,j=0,1,...,n) such      }
{              that x[i]=x[j],                                              }
{           3, if xx<x[0] or xx>x[n],                                       }
{           0, otherwise.                                                   }
{         Note: If st<>0, then clampedsplinevalue(n,x,f,xx,st) is not       }
{               calculated.                                                 }
{  Unlocal identifiers:                                                     }
{    vector  - a type identifier of extended array [q0..qn], where q0<=0    }
{              and qn>=n,                                                   }
{    vector1 - a type identifier of extended array [q0..qn1], where q0<=0   }
{              and qn1>=n-1,                                                }
{    vector2 - a type identifier of extended array [q1..qn], where q1<=1    }
{              and qn>=n.                                                   }
{---------------------------------------------------------------------------}

function clampedsplinevalue (n            : Integer;
                             x,f          : vector;
                             f1x0,f1xn,xx : Extended;
                             var st       : Integer) : Extended;

var i,k   : Integer;
    u,y,z : Extended;
    found : Boolean;
    a     : array [0..3] of Extended;
    d     : vector;
    b     : vector1;
    c     : vector2;
begin
SetLength(b,n);
SetLength(c,n);
SetLength(d,n);
  if n<1
    then st:=1
    else if (xx<x[0]) or (xx>x[n])
           then st:=3
           else begin
                  st:=0;
                  i:=-1;
                  repeat
                    i:=i+1;
                    for k:=i+1 to n do
                      if x[i]=x[k]
                        then st:=2
                  until (i=n-1) or (st=2)
                end;
  if st=0
    then begin
           b[0]:=1;
           u:=x[1]-x[0];
           d[0]:=6*((f[1]-f[0])/u-f1x0)/u;
           c[n]:=1;
           u:=x[n]-x[n-1];
           d[n]:=6*(f1xn-(f[n]-f[n-1])/u)/u;
           for i:=1 to n-1 do
             begin
               z:=x[i];
               y:=x[i+1]-z;
               z:=z-x[i-1];
               u:=f[i];


               b[i]:=y/(y+z);
               c[i]:=1-b[i];
               d[i]:=6*((f[i+1]-u)/y-(u-f[i-1])/z)/(y+z)
             end;
           u:=2;
           i:=-1;
           y:=d[0]/u;
           d[0]:=y;
           repeat
             i:=i+1;
             z:=b[i]/u;
             b[i]:=z;
             u:=2-z*c[i+1];
             y:=(d[i+1]-y*c[i+1])/u;
             d[i+1]:=y
           until i=n-1;
           u:=d[n];
           for i:=n-1 downto 0 do
             begin
               u:=d[i]-u*b[i];
               d[i]:=u
             end;
           found:=False;
           i:=-1;
           repeat
             i:=i+1;
             if (xx>=x[i]) and (xx<=x[i+1])
               then found:=True
           until found;
           y:=x[i+1]-x[i];
           z:=d[i+1];
           u:=d[i];
           a[0]:=f[i];
           a[1]:=(f[i+1]-f[i])/y-(2*u+z)*y/6;
           a[2]:=u/2;
           a[3]:=(z-u)/(6*y);
           y:=a[3];
           z:=xx-x[i];
           for i:=2 downto 0 do
             y:=y*z+a[i];
           clampedsplinevalue:=y
         end
end;


function intervalclampedsplinevalue (n            : Integer;
                             x,f          : Ivector;
                             f1x0,f1xn,xx : interval;
                             var st       : Integer) : Extended;

var i,k   : Integer;
    u,y,z : interval;
    found : Boolean;
    a     : array [0..3] of interval;
    d     : Ivector;
    b     : Ivector1;
    c     : Ivector2;
begin
SetLength(b,n);
SetLength(c,n);
SetLength(d,n);
  if n<1
    then st:=1
    else if (compare_less(xx,x[0])) or compare_less(x[n],xx)
           then st:=3
           else begin
                  st:=0;
                  i:=-1;
                  repeat
                    i:=i+1;
                    for k:=i+1 to n do
                      if compare_equal(x[i],x[k])
                        then st:=2
                  until (i=n-1) or (st=2)
                end;
  if st=0
    then begin
           b[0]:=1;
           u:=x[1]-x[0];
           d[0]:=6*((f[1]-f[0])/u-f1x0)/u;
           c[n]:=1;
           u:=x[n]-x[n-1];
           d[n]:=6*(f1xn-(f[n]-f[n-1])/u)/u;
           for i:=1 to n-1 do
             begin
               z:=x[i];
               y:=x[i+1]-z;
               z:=z-x[i-1];
               u:=f[i];


               b[i]:=y/(y+z);
               c[i]:=1-b[i];
               d[i]:=6*((f[i+1]-u)/y-(u-f[i-1])/z)/(y+z)
             end;
           u:=2;
           i:=-1;
           y:=d[0]/u;
           d[0]:=y;
           repeat
             i:=i+1;
             z:=b[i]/u;
             b[i]:=z;
             u:=2-z*c[i+1];
             y:=(d[i+1]-y*c[i+1])/u;
             d[i+1]:=y
           until i=n-1;
           u:=d[n];
           for i:=n-1 downto 0 do
             begin
               u:=d[i]-u*b[i];
               d[i]:=u
             end;
           found:=False;
           i:=-1;
           repeat
             i:=i+1;
             if (xx>=x[i]) and (xx<=x[i+1])
               then found:=True
           until found;
           y:=x[i+1]-x[i];
           z:=d[i+1];
           u:=d[i];
           a[0]:=f[i];
           a[1]:=(f[i+1]-f[i])/y-(2*u+z)*y/6;
           a[2]:=u/2;
           a[3]:=(z-u)/(6*y);
           y:=a[3];
           z:=xx-x[i];
           for i:=2 downto 0 do
             y:=y*z+a[i];
           clampedsplinevalue:=y
         end
end;

{---------------------------------------------------------------------------}
{---------------------------------------------------------------------------}
{---------------------------------------------------------------------------}
{---------------------------------------------------------------------------}

procedure TForm1.Button1Click(Sender: TObject);
begin
 if CheckBox1.State = cbUnchecked then
  begin
    Button1.Caption := 'Dalej';
    CheckBox1.Enabled := False;
    CheckBox1.Caption := 'Arytmetyka przedzia�owa wy��czona';
    Label2.Caption := '';
    if inputNumber = 0 then
    begin
      n := strtoint(Edit1.Text);
      Label1.Caption := 'x[0]';
      SetLength(x, n+1);
      SetLength(f, n+1);
      SetLength(a, 4);
      SetLength(a[0], n);
      SetLength(a[1], n);
      SetLength(a[2], n);
      SetLength(a[3], n);
    end
    else if inputNumber <= (n+1) then
    begin
      x[inputNumber-1] := strToFloat(Edit1.Text);
      if inputNumber-1 = n then
        Label1.Caption := 'f[0]'
      else Label1.Caption := 'x[' + intToStr(inputNumber) +']'
    end
    else if inputNumber <= 2*(n+1) then
    begin
      f[(inputNumber-1)mod (n+1)] := strToFloat(Edit1.Text);
      if inputNumber = 2*(n+1) then
      begin
        Label1.Caption := 'f1x0';
      end
      else Label1.Caption := 'f[' + intToStr((inputNumber)mod (n+1)) +']'
    end

    else if inputNumber = 2*(n+1)+1 then
    begin
       f1x0 := strToFloat(Edit1.Text);
       Label1.Caption := 'f1xn';
       if CheckBox2.State = cbUnchecked then
      begin
        CheckBox2.Enabled := False;
        CheckBox2.Caption := 'Obliczanie warto�ci';
        Button1.Caption := 'Oblicz';
      end;
    end
    else if inputNumber = 2*(n+1)+2 then
    begin
      f1xn := strToFloat(Edit1.Text);
      if CheckBox2.State = cbUnchecked then
      begin
        CheckBox2.Enabled := False;
        CheckBox2.Caption := 'Obliczanie warto�ci';
        Label1.Caption := 'xx';
        Button1.Caption := 'Oblicz';
      end
      else
      begin
        inputNumber := -1;
        Label1.Caption := 'n';
        clampedsplinecoeffns(n, x, f, f1x0, f1xn, a, st);
        if st = 0 then
        begin
        for j := 0 to n-1 do
          for i:=0 to 3 do
          begin
            Str(a[i][j],tmp);
            if i mod 2 = 0 then
              Label2.Caption := Label2.Caption + 'a[' + IntToStr(i) + ', ' + IntToStr(j) + '] = ' + tmp + '     '
            else Label2.Caption := Label2.Caption + 'a[' + IntToStr(i) + ', ' + IntToStr(j) + '] = ' + tmp + #10+#13
          end;
        Label2.Caption := Label2.Caption + 'st = ' + IntToStr(st) + #10+#13;
        Str(Wynik,tmp);
        end
      else  Label2.Caption := 'Nie mo�na obliczy� warto�ci - b��d st = ' + IntToStr(st);
      end;

    end


    else if inputNumber = 2*(n+1)+3 then
    begin
      xx := strToFloat(Edit1.Text);
      Wynik := clampedsplinevalue(n, x, f, f1x0, f1xn, xx, st);
      inputNumber := -1;
      Label1.Caption := 'n';
      CheckBox1.Enabled := True;
      CheckBox2.Enabled := True;
      CheckBox2.Caption := 'Obliczanie wsp�czynnik�w';
      if st = 0 then
      begin
        Label2.Caption := Label2.Caption + 'st = ' + IntToStr(st) + #10+#13;
        Str(Wynik,tmp);

        Label2.Caption := Label2.Caption + 'Wynik = ' + tmp;
      end
      else  Label2.Caption := 'Nie mo�na obliczy� warto�ci - b��d st = ' + IntToStr(st);
      end;

    inputNumber := inputNumber + 1;
  end

  else
  begin
    Edit2.Visible := True;
    //Label5.Visible := True;
    CheckBox1.Enabled := False;
    CheckBox1.Caption := 'Arytmetyka przedzia�owa w��czona';
    Label2.Caption := '';
    if inputNumber = 0 then
    begin
      n := strtoint(Edit1.Text);
      Label1.Caption := 'x[0]';
      SetLength(x2, n+1);
      SetLength(f2, n+1);
      SetLength(a2, 4);
      SetLength(a2[0], n);
      SetLength(a2[1], n);
      SetLength(a2[2], n);
      SetLength(a2[3], n);
    end
    else if inputNumber <= (n+1) then
    begin
      x2[inputNumber-1].a := left_read(Edit1.Text);
      x2[inputNumber-1].b := right_read(Edit2.Text);
      if inputNumber-1 = n then
        Label1.Caption := 'f[0]'
      else Label1.Caption := 'x[' + intToStr(inputNumber) +']'
    end
    else if inputNumber <= 2*(n+1) then
    begin
      f2[(inputNumber-1)mod (n+1)].a := left_read(Edit1.Text);
      f2[(inputNumber-1)mod (n+1)].b := right_read(Edit2.Text);
      if inputNumber = 2*(n+1) then
      begin
        Label1.Caption := 'xx';
      end
      else Label1.Caption := 'f[' + intToStr((inputNumber)mod (n+1)) +']'
    end
    else if inputNumber = 2*(n+1)+1 then
      begin
        xx2.a := left_read(Edit1.Text);
        xx2.b := right_read(Edit2.Text);
        intervalclampedsplinecoeffns(n, x2, f2, a2, st);
        Wynik2 := intervalclampedsplinevalue(n, x2, f2, xx2, st);
        inputNumber := -1;
        Label1.Caption := 'n';
        Edit2.Visible := False;
        Label5.Visible := False;
        CheckBox1.Enabled := True;
        if st = 0 then
        begin
          for j := 0 to n-1 do
            for i:=0 to 3 do
            begin
              iends_to_strings(a2[i][j], tmp2_lewy, tmp2_prawy);
              if i mod 2 = 0 then
                Label2.Caption := Label2.Caption + 'a[' + IntToStr(i) + ', ' + IntToStr(j) + '] = (' + tmp2_lewy + ', ' + tmp2_prawy +')    '
              else Label2.Caption := Label2.Caption + 'a[' + IntToStr(i) + ', ' + IntToStr(j) + '] = (' + tmp2_lewy + ', ' + tmp2_prawy +')' + #10+#13
            end;

          Label2.Caption := Label2.Caption + 'st = ' + IntToStr(st) + #10+#13;
          iends_to_strings(Wynik2, Wynik2_lewy, Wynik2_prawy);

          Label2.Caption := Label2.Caption + 'Wynik = (' + Wynik2_lewy + ', ' + Wynik2_prawy + ')';
        end

        else  Label2.Caption := Label2.Caption + 'st = ' + IntToStr(st) + #10+#13;

      end;


    inputNumber := inputNumber + 1;
  end;

end;

end.
