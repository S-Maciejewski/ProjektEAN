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
  formNumber: Integer;
  tmp: String;
  i: Integer;
  j: Integer;
  xx: Extended;
  Wynik: Extended;

  x2: Ivector;
  f2: Ivector;
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

procedure periodsplinecoeffns (n         : Integer;
                               x,f       : vector;
                               var a     : matrix;
                               var st    : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure periodsplinecoeffns calculates the coefficients of the     }
{  periodic cubic spline interpolant for a function given by its values at  }
{  nodes.                                                                   }
{  Data:                                                                    }
{    n  - number of interpolation nodes minus 1 (the nodes are numbered     }
{         from 0 to n),                                                     }
{    x  - an array containing the values of nodes,                          }
{    f  - an array containing the values of function (the value of f[0]     }
{         should be equal to the value of f[n]).                            }
{  Result:                                                                  }
{    a  - an array of spline coefficients (the element a[k,i] contains the  }
{         coefficient before x^k, where k=0,1,2,3, for the interval         }
{         <x[i], x[i+1]>; i=0,1,...,n-1).                                   }
{  Other parameters:                                                        }
{    st - a variable which within the procedure periodsplinecoeffns is      }
{         assigned the value of:                                            }
{           1, if n<1,                                                      }
{           2, if there exist x[i] and x[j] (i<>j; i,j=0,1,...,n) such      }
{              that x[i]=x[j],                                              }
{           3, if f[0]<>f[n],                                               }
{           0, otherwise.                                                   }
{         Note: If st<>0, then the elements of array a are not calculated.  }
{  Unlocal identifiers:                                                     }
{    vector  - a type identifier of extended array [q0..qn], where q0<=0    }
{              and qn>=n,                                                   }
{    vector1 - a type identifier of extended array [q1..qn], where q1<=1    }
{              and qn>=n,                                                   }
{    vector2 - a type identifier of extended array [q1..qn1], where q1<=1   }
{              and qn1>=n-1,                                                }
{    vector3 - a type identifier of extended array [q2..qn], where q2<=2    }
{              and qn>=n,                                                   }
{    matrix  - a type identifier of extended array [0..3, q0..qn1], where   }
{              q0<=0 and qn1>=n-1.                                          }
{                                                                           }
{---------------------------------------------------------------------------}
var i,k        : Integer;
    w,v,y,z,xi : Extended;
    u          : vector;
    b,c,d      : vector1;
    p          : vector2;
    q          : vector3;
begin
SetLength(b,n);
SetLength(c,n);
SetLength(d,n);
SetLength(u,n);
SetLength(p,n);
SetLength(q,n);
  if n<1
    then st:=1
    else if f[0]<>f[n]
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
           if n>1
             then begin
                    v:=x[1]-x[0];
                    z:=x[n]-x[n-1];
                    b[n]:=v/(z+v);
                    c[n]:=1-b[n];
                    y:=f[n];
                    d[n]:=6*((f[1]-y)/v-(y-f[n-1])/z)/(z+v);
                    for i:=1 to n-1 do
                      begin
                        z:=x[i];
                        y:=x[i+1]-z;
                        z:=z-x[i-1];
                        v:=f[i];
                        b[i]:=y/(y+z);
                        c[i]:=1-b[i];
                        d[i]:=6*((f[i+1]-v)/y-(v-f[i-1])/z)/(y+z)
                      end;
                    if n>2
                      then begin
                             u[1]:=2;
                             c[2]:=c[2]/2;
                             q[2]:=-b[n]/2;
                             for i:=2 to n-2 do
                               begin
                                 v:=2-b[i-1]*c[i];
                                 c[i+1]:=c[i+1]/v;
                                 q[i+1]:=-q[i]*b[i-1]/v;
                                 u[i]:=v
                               end;
                             v:=2-c[n-1]*b[n-2];
                             q[n]:=(c[n]-q[n-1]*b[n-2])/v;
                             u[n-1]:=v;
                             p[1]:=c[1];
                             for i:=2 to n-2 do
                               p[i]:=-c[i]*p[i-1];
                             p[n-1]:=b[n-1]-c[n-1]*p[n-2];
                             v:=2-c[1]*p[2];
                             for i:=2 to n-2 do
                               v:=v-p[i]*p[i+1];
                             u[n]:=v-p[n-1]*q[n];
                             for i:=2 to n-1 do
                               d[i]:=d[i]-c[i]*d[i-1];
                             v:=d[n];
                             for i:=2 to n do
                               v:=v-q[i]*d[i-1];
                             d[n]:=v;
                             u[n]:=d[n]/u[n];
                             u[n-1]:=(d[n-1]-p[n-1]*u[n])/u[n-1];
                             for i:=n-2 downto 1 do
                               u[i]:=(d[i]-b[i]*u[i+1]-p[i]*u[n])/u[i]
                           end
                      else begin
                             y:=d[1];
                             z:=d[2];
                             w:=4-c[2]*b[1];
                             u[1]:=(2*y-b[1]*z)/w;
                             u[2]:=(2*z-c[2]*y)/w;
                           end
                  end
             else u[1]:=0;
           u[0]:=u[n];
           for i:=0 to n-1 do
             begin
               w:=f[i];
               xi:=x[i];
               z:=x[i+1]-xi;
               y:=u[i];
               v:=(f[i+1]-w)/z-(2*y+u[i+1])*z/6;
               z:=(u[i+1]-y)/(6*z);
               y:=y/2;
               a[0,i]:=((-z*xi+y)*xi-v)*xi+w;
               w:=3*z*xi;
               a[1,i]:=(w-2*y)*xi+v;
               a[2,i]:=y-w;
               a[3,i]:=z
             end
         end
end;


procedure intervalperiodsplinecoeffns (n         : Integer;
                               x,f       : Ivector;
                               var a     : Imatrix;
                               var st    : Integer);

var i,k        : Integer;
    w,v,y,z,xi : interval;
    u          : Ivector;
    b,c,d      : Ivector1;
    p          : Ivector2;
    q          : Ivector3;
begin
SetLength(b,n);
SetLength(c,n);
SetLength(d,n);
SetLength(u,n);
SetLength(p,n);
SetLength(q,n);
  if n<1
    then st:=1
    else if not compare_equal(f[0], f[n])
           then st:=3
           else begin
                  st:=0;
                  i:=-1;
                  repeat
                    i:=i+1;
                    for k:=i+1 to n do
                      if compare_equal(x[i], x[k])
                        then st:=2
                  until (i=n-1) or (st=2)
                end;
  if st=0
    then begin
           if n>1
             then begin
                    v:=x[1]-x[0];
                    z:=x[n]-x[n-1];
                    b[n]:=v/(z+v);
                    c[n]:=1-b[n];
                    y:=f[n];
                    d[n]:=6*((f[1]-y)/v-(y-f[n-1])/z)/(z+v);
                    for i:=1 to n-1 do
                      begin
                        z:=x[i];
                        y:=x[i+1]-z;
                        z:=z-x[i-1];
                        v:=f[i];
                        b[i]:=y/(y+z);
                        c[i]:=1-b[i];
                        d[i]:=6*((f[i+1]-v)/y-(v-f[i-1])/z)/(y+z)
                      end;
                    if n>2
                      then begin
                             u[1]:=2;
                             c[2]:=c[2]/2;
                             q[2]:=-b[n]/2;
                             for i:=2 to n-2 do
                               begin
                                 v:=2-b[i-1]*c[i];
                                 c[i+1]:=c[i+1]/v;
                                 q[i+1]:=-q[i]*b[i-1]/v;
                                 u[i]:=v
                               end;
                             v:=2-c[n-1]*b[n-2];
                             q[n]:=(c[n]-q[n-1]*b[n-2])/v;
                             u[n-1]:=v;
                             p[1]:=c[1];
                             for i:=2 to n-2 do
                               p[i]:=-c[i]*p[i-1];
                             p[n-1]:=b[n-1]-c[n-1]*p[n-2];
                             v:=2-c[1]*p[2];
                             for i:=2 to n-2 do
                               v:=v-p[i]*p[i+1];
                             u[n]:=v-p[n-1]*q[n];
                             for i:=2 to n-1 do
                               d[i]:=d[i]-c[i]*d[i-1];
                             v:=d[n];
                             for i:=2 to n do
                               v:=v-q[i]*d[i-1];
                             d[n]:=v;
                             u[n]:=d[n]/u[n];
                             u[n-1]:=(d[n-1]-p[n-1]*u[n])/u[n-1];
                             for i:=n-2 downto 1 do
                               u[i]:=(d[i]-b[i]*u[i+1]-p[i]*u[n])/u[i]
                           end
                      else begin
                             y:=d[1];
                             z:=d[2];
                             w:=4-c[2]*b[1];
                             u[1]:=(2*y-b[1]*z)/w;
                             u[2]:=(2*z-c[2]*y)/w;
                           end
                  end
             else u[1]:=0;
           u[0]:=u[n];
           for i:=0 to n-1 do
             begin
               w:=f[i];
               xi:=x[i];
               z:=x[i+1]-xi;
               y:=u[i];
               v:=(f[i+1]-w)/z-(2*y+u[i+1])*z/6;
               z:=(u[i+1]-y)/(6*z);
               y:=y/2;
               a[0,i]:=((-z*xi+y)*xi-v)*xi+w;
               w:=3*z*xi;
               a[1,i]:=(w-2*y)*xi+v;
               a[2,i]:=y-w;
               a[3,i]:=z
             end
         end
end;



function periodsplinevalue (n      : Integer;
                            x,f    : vector;
                            xx     : Extended;
                            var st : Integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function periodsplinevalue calculates the value of the periodic      }
{  cubic spline interpolant for a function given by its values at nodes.    }
{  Data:                                                                    }
{    n  - number of interpolation nodes minus 1 (the nodes are numbered     }
{         from 0 to n),                                                     }
{    x  - an array containing the values of nodes,                          }
{    f  - an array containing the values of function (the value of f[0]     }
{         should be equal to the value of f[n]),                            }
{    xx - the point at which the value of interpolating spline should       }
{         be calculated.                                                    }
{  Result:                                                                  }
{    periodsplinevalue(n,x,f,xx,st) - the value of periodic spline at xx.   }
{  Other parameters:                                                        }
{    st - a variable which within the function periodsplinevalue is         }
{         assigned the value of:                                            }
{           1, if n<1,                                                      }
{           2, if there exist x[i] and x[j] (i<>j; i,j=0,1,...,n) such      }
{              that x[i]=x[j],                                              }
{           3, if f[0]<>f[n],                                               }
{           4, if xx<x[0] or xx>x[n],                                       }
{           0, otherwise.                                                   }
{         Note: If st<>0, then periodicsplinevalue(n,x,f,xx,st) is not      }
{               calculated.                                                 }
{  Unlocal identifiers:                                                     }
{    vector  - a type identifier of extended array [q0..qn], where q0<=0    }
{              and qn>=n,                                                   }
{    vector1 - a type identifier of extended array [q1..qn], where q1<=1    }
{              and qn>=n,                                                   }
{    vector2 - a type identifier of extended array [q1..qn1], where q1<=1   }
{              and qn1>=n-1,                                                }
{    vector3 - a type identifier of extended array [q2..qn], where q2<=2    }
{              and qn>=n.                                                   }
{                                                                           }
{---------------------------------------------------------------------------}
var i,k   : Integer;
    v,y,z : Extended;
    found : Boolean;
    a     : array [0..3] of Extended;
    u     : vector;
    b,c,d : vector1;
    p     : vector2;
    q     : vector3;
begin
SetLength(b,n);
SetLength(c,n);
SetLength(d,n);
SetLength(u,n);
SetLength(p,n);
SetLength(q,n);
  if n<1
    then st:=1
    else if f[0]<>f[n]
           then st:=3
           else if (xx<x[0]) or (xx>x[n])
                  then st:=4
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
           if n>1
             then begin
                    v:=x[1]-x[0];
                    z:=x[n]-x[n-1];
                    b[n]:=v/(z+v);
                    c[n]:=1-b[n];
                    y:=f[n];
                    d[n]:=6*((f[1]-y)/v-(y-f[n-1])/z)/(z+v);
                    for i:=1 to n-1 do
                      begin
                        z:=x[i];
                        y:=x[i+1]-z;
                        z:=z-x[i-1];
                        v:=f[i];
                        b[i]:=y/(y+z);
                        c[i]:=1-b[i];
                        d[i]:=6*((f[i+1]-v)/y-(v-f[i-1])/z)/(y+z)
                      end;
                    if n>2
                      then begin
                             u[1]:=2;
                             c[2]:=c[2]/2;
                             q[2]:=-b[n]/2;
                             for i:=2 to n-2 do
                               begin
                                 v:=2-b[i-1]*c[i];
                                 c[i+1]:=c[i+1]/v;
                                 q[i+1]:=-q[i]*b[i-1]/v;
                                 u[i]:=v
                               end;
                             v:=2-c[n-1]*b[n-2];
                             q[n]:=(c[n]-q[n-1]*b[n-2])/v;
                             u[n-1]:=v;
                             p[1]:=c[1];
                             for i:=2 to n-2 do
                               p[i]:=-c[i]*p[i-1];
                             p[n-1]:=b[n-1]-c[n-1]*p[n-2];
                             v:=2-c[1]*p[2];
                             for i:=2 to n-2 do
                               v:=v-p[i]*p[i+1];
                             u[n]:=v-p[n-1]*q[n];
                             for i:=2 to n-1 do
                               d[i]:=d[i]-c[i]*d[i-1];
                             v:=d[n];
                             for i:=2 to n do
                               v:=v-q[i]*d[i-1];
                             d[n]:=v;
                             u[n]:=d[n]/u[n];
                             u[n-1]:=(d[n-1]-p[n-1]*u[n])/u[n-1];
                             for i:=n-2 downto 1 do
                               u[i]:=(d[i]-b[i]*u[i+1]-p[i]*u[n])/u[i]
                           end
                      else begin
                             y:=d[1];
                             z:=d[2];
                             v:=4-c[2]*b[1];
                             u[1]:=(2*y-b[1]*z)/v;
                             u[2]:=(2*z-c[2]*y)/v;
                           end
                  end
             else u[1]:=0;
           u[0]:=u[n];
           found:=False;
           i:=-1;
           repeat
             i:=i+1;
             if (xx>=x[i]) and (xx<=x[i+1])
               then found:=True
           until found;
           y:=x[i+1]-x[i];
           z:=u[i+1];
           v:=u[i];
           a[0]:=f[i];
           a[1]:=(f[i+1]-f[i])/y-(2*v+z)*y/6;
           a[2]:=v/2;
           a[3]:=(z-v)/(6*y);
           y:=a[3];
           z:=xx-x[i];
           for i:=2 downto 0 do
             y:=y*z+a[i];
           periodsplinevalue:=y
         end
end;


function intervalperiodsplinevalue (n      : Integer;
                            x,f    : Ivector;
                            xx     : interval;
                            var st : Integer) : interval;

var i,k   : Integer;
    v,y,z : interval;
    found : Boolean;
    a     : array [0..3] of Interval;
    u     : Ivector;
    b,c,d : Ivector1;
    p     : Ivector2;
    q     : Ivector3;
begin
SetLength(b,n);
SetLength(c,n);
SetLength(d,n);
SetLength(u,n);
SetLength(p,n);
SetLength(q,n);
  if n<1
    then st:=1
    else if not compare_equal(f[0],f[n])
           then st:=3
           else if (compare_less(xx, x[0])) or (compare_less(x[n], xx))
                  then st:=4
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
           if n>1
             then begin
                    v:=x[1]-x[0];
                    z:=x[n]-x[n-1];
                    b[n]:=v/(z+v);
                    c[n]:=1-b[n];
                    y:=f[n];
                    d[n]:=6*((f[1]-y)/v-(y-f[n-1])/z)/(z+v);
                    for i:=1 to n-1 do
                      begin
                        z:=x[i];
                        y:=x[i+1]-z;
                        z:=z-x[i-1];
                        v:=f[i];
                        b[i]:=y/(y+z);
                        c[i]:=1-b[i];
                        d[i]:=6*((f[i+1]-v)/y-(v-f[i-1])/z)/(y+z)
                      end;
                    if n>2
                      then begin
                             u[1]:=2;
                             c[2]:=c[2]/2;
                             q[2]:=-b[n]/2;
                             for i:=2 to n-2 do
                               begin
                                 v:=2-b[i-1]*c[i];
                                 c[i+1]:=c[i+1]/v;
                                 q[i+1]:=-q[i]*b[i-1]/v;
                                 u[i]:=v
                               end;
                             v:=2-c[n-1]*b[n-2];
                             q[n]:=(c[n]-q[n-1]*b[n-2])/v;
                             u[n-1]:=v;
                             p[1]:=c[1];
                             for i:=2 to n-2 do
                               p[i]:=-c[i]*p[i-1];
                             p[n-1]:=b[n-1]-c[n-1]*p[n-2];
                             v:=2-c[1]*p[2];
                             for i:=2 to n-2 do
                               v:=v-p[i]*p[i+1];
                             u[n]:=v-p[n-1]*q[n];
                             for i:=2 to n-1 do
                               d[i]:=d[i]-c[i]*d[i-1];
                             v:=d[n];
                             for i:=2 to n do
                               v:=v-q[i]*d[i-1];
                             d[n]:=v;
                             u[n]:=d[n]/u[n];
                             u[n-1]:=(d[n-1]-p[n-1]*u[n])/u[n-1];
                             for i:=n-2 downto 1 do
                               u[i]:=(d[i]-b[i]*u[i+1]-p[i]*u[n])/u[i]
                           end
                      else begin
                             y:=d[1];
                             z:=d[2];
                             v:=4-c[2]*b[1];
                             u[1]:=(2*y-b[1]*z)/v;
                             u[2]:=(2*z-c[2]*y)/v;
                           end
                  end
             else u[1]:=0;
           u[0]:=u[n];
           found:=False;
           i:=-1;
           repeat
             i:=i+1;
             if (compare_less_or_equal(x[i], xx)) and (compare_less_or_equal(xx, x[i+1]))
               then found:=True
           until found;
           y:=x[i+1]-x[i];
           z:=u[i+1];
           v:=u[i];
           a[0]:=f[i];
           a[1]:=(f[i+1]-f[i])/y-(2*v+z)*y/6;
           a[2]:=v/2;
           a[3]:=(z-v)/(6*y);
           y:=a[3];
           z:=xx-x[i];
           for i:=2 downto 0 do
             y:=y*z+a[i];
           intervalperiodsplinevalue:=y
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
    CheckBox1.Enabled := False;
    CheckBox1.Caption := 'Arytmetyka przedziałowa wyłączona';
    Label2.Caption := '';
    if formNumber = 0 then
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
    else if formNumber <= (n+1) then
    begin
      x[formNumber-1] := strToFloat(Edit1.Text);
      if formNumber-1 = n then
        Label1.Caption := 'f[0]'
      else Label1.Caption := 'x[' + intToStr(formNumber) +']'
    end
    else if formNumber <= 2*(n+1) then
    begin
      f[(formNumber-1)mod (n+1)] := strToFloat(Edit1.Text);
      if formNumber = 2*(n+1) then
      begin
        Label1.Caption := 'xx';
      end
      else Label1.Caption := 'f[' + intToStr((formNumber)mod (n+1)) +']'
    end
    else if formNumber = 2*(n+1)+1 then
      begin
        xx := strToFloat(Edit1.Text);
        periodsplinecoeffns(n, x, f, a, st);
        Wynik := periodsplinevalue(n, x, f, xx, st);
        formNumber := -1;
        Label1.Caption := 'n';
        CheckBox1.Enabled := True;
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

          Label2.Caption := Label2.Caption + 'Wynik = ' + tmp;
        end
        else  Label2.Caption := Label2.Caption + 'st = ' + IntToStr(st) + #10+#13;

      end;

    formNumber := formNumber + 1;
  end

  else
  begin
    Edit2.Visible := True;
    Label5.Visible := True;
    CheckBox1.Enabled := False;
    Label2.Caption := '';
    if formNumber = 0 then
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
    else if formNumber <= (n+1) then
    begin
      x2[formNumber-1].a := left_read(Edit1.Text);
      x2[formNumber-1].b := right_read(Edit2.Text);
      if formNumber-1 = n then
        Label1.Caption := 'f[0]'
      else Label1.Caption := 'x[' + intToStr(formNumber) +']'
    end
    else if formNumber <= 2*(n+1) then
    begin
      f2[(formNumber-1)mod (n+1)].a := left_read(Edit1.Text);
      f2[(formNumber-1)mod (n+1)].b := right_read(Edit2.Text);
      if formNumber = 2*(n+1) then
      begin
        Label1.Caption := 'xx';
      end
      else Label1.Caption := 'f[' + intToStr((formNumber)mod (n+1)) +']'
    end
    else if formNumber = 2*(n+1)+1 then
      begin
        xx2.a := left_read(Edit1.Text);
        xx2.b := right_read(Edit2.Text);
        intervalperiodsplinecoeffns(n, x2, f2, a2, st);
        Wynik2 := intervalperiodsplinevalue(n, x2, f2, xx2, st);
        formNumber := -1;
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


    formNumber := formNumber + 1;
  end;

end;


end.
