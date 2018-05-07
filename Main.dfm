object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Kalkulator funkcji sklejanych'
  ClientHeight = 342
  ClientWidth = 681
  Color = 16772817
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 64
    Top = 52
    Width = 33
    Height = 27
    Caption = 'n'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 127
    Top = 168
    Width = 17
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 184
    Top = 24
    Width = 265
    Height = 22
    Caption = 'Arytmetka przedzia'#322'owa w'#322#261'czona'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object Label3: TLabel
    Left = 64
    Top = 168
    Width = 57
    Height = 25
    Caption = 'Wynik:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 16
    Top = 24
    Width = 120
    Height = 22
    Caption = 'Podaj warto'#347'ci:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Button1: TButton
    Left = 488
    Top = 54
    Width = 75
    Height = 25
    Caption = 'Dalej'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 152
    Top = 56
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object CheckBox1: TCheckBox
    Left = 163
    Top = 83
    Width = 286
    Height = 23
    Caption = 'Arytmetyka przedzia'#322'owa'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object Edit2: TEdit
    Left = 328
    Top = 56
    Width = 121
    Height = 21
    TabOrder = 3
    Visible = False
  end
  object CheckBox2: TCheckBox
    Left = 163
    Top = 120
    Width = 286
    Height = 17
    Caption = 'Obliczanie wsp'#243#322'czynnik'#243'w'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
end
