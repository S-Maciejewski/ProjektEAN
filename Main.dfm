object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 310
  ClientWidth = 785
  Color = clBtnFace
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
    Top = 35
    Width = 6
    Height = 13
    Caption = 'n'
  end
  object Label2: TLabel
    Left = 235
    Top = 176
    Width = 22
    Height = 25
  end
  object Label5: TLabel
    Left = 64
    Top = 8
    Width = 164
    Height = 13
    Caption = 'Arytmetka przedzia'#322'owa w'#322#261'czona'
    Visible = False
  end
  object Label3: TLabel
    Left = 152
    Top = 176
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
  object Button1: TButton
    Left = 480
    Top = 30
    Width = 75
    Height = 25
    Caption = 'Dalej'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 152
    Top = 32
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object CheckBox1: TCheckBox
    Left = 272
    Top = 75
    Width = 225
    Height = 14
    Caption = 'Arytmetyka przedzia'#322'owa'
    TabOrder = 2
  end
  object Edit2: TEdit
    Left = 320
    Top = 32
    Width = 121
    Height = 21
    TabOrder = 3
    Visible = False
  end
end
