object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Kalkulator funkcji sklejanych'
  ClientHeight = 368
  ClientWidth = 837
  Color = 16436871
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 72
    Top = 48
    Width = 8
    Height = 17
    Caption = 'n'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 79
    Top = 122
    Width = 4
    Height = 17
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 27
    Top = 122
    Width = 46
    Height = 17
    Caption = 'Wyniki:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 27
    Top = 25
    Width = 94
    Height = 17
    Caption = 'Podaj warto'#347'ci:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object Label5: TLabel
    Left = 162
    Top = 25
    Width = 222
    Height = 17
    Caption = 'Podaj lewy i prawy koniec przedzia'#322'u'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object Edit1: TEdit
    Left = 144
    Top = 48
    Width = 121
    Height = 22
    TabOrder = 0
  end
  object Edit2: TEdit
    Left = 296
    Top = 48
    Width = 121
    Height = 22
    TabOrder = 1
    Visible = False
  end
  object Button1: TButton
    Left = 448
    Top = 46
    Width = 75
    Height = 25
    Caption = 'Dalej'
    TabOrder = 2
    OnClick = Button1Click
  end
  object CheckBox1: TCheckBox
    Left = 144
    Top = 77
    Width = 313
    Height = 17
    Caption = 'Arytmetyka przedzia'#322'owa'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object CheckBox2: TCheckBox
    Left = 144
    Top = 100
    Width = 313
    Height = 17
    Caption = 'Obliczanie wsp'#243#322'czynnik'#243'w'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
end
