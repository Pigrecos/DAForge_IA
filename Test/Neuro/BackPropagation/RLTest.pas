unit RLTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Grids,BaseGrid, Math,
  Neuron,FunzAttivazione,Layer,Network,Apprendimento,NeuralNetDef, VCLTee.TeEngine, VCLTee.Series, VCLTee.TeeProcs,
  VCLTee.Chart, VclTee.TeeGDIPlus, Vcl.Buttons;

type
  rAgente = record
    StartX : Integer;
    StartY : Integer;
    StopX  : Integer;
    StopY  : Integer;
  end;

  TfrmMain = class(TForm)
    Chart1: TChart;
    Grafico: TLineSeries;
    grp1: TGroupBox;
    btnStart: TBitBtn;
    bvl1: TBevel;
    stErrore: TStaticText;
    lbl1: TLabel;
    lbl2: TLabel;
    stCiclo: TStaticText;
    bvl2: TBevel;
    lbl3: TLabel;
    edtCicli: TEdit;
    edtErrLim: TEdit;
    lbl4: TLabel;
    lbl5: TLabel;
    edtAlpha: TEdit;
    edtMomento: TEdit;
    lbl6: TLabel;
    lbl7: TLabel;
    edtAppren: TEdit;
    cbTipoSig: TComboBox;
    lbl8: TLabel;
    grp2: TGroupBox;
    mErrori: TMemo;
    btnStop: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
  private
    procedure ShowSetting;
    procedure GetSetting;
    procedure EnableControl(lEnable: Boolean);
    procedure ThReadStartRete;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain      : TfrmMain;    //
  IsStopElab   : Boolean;     // ferma l'apprendimento
  CicliAppren  : Integer ;    // numero di cicli di apprendimento
  FattoreAppr  : Double  ;    // fattore di apprendimento
  Momento      : Double ;     // Momento
  SigValAlpha  : Double ;     // Valore alpha della sigmoide
  ErrLimit     : Double;      // Limite per l'eerore della rete
implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
     mErrori.Clear;
     CicliAppren  := 100;
     FattoreAppr  := 0.1;
     Momento      := 0;
     SigValAlpha  := 2;
     ErrLimit     := 0.1;
     IsStopElab   := False;
     ShowSetting;
end;

procedure TfrmMain.ShowSetting;
begin

     edtAppren.Text := FloatToStr(FattoreAppr);
     edtCicli.Text  := IntToStr(CicliAppren);
     edtMomento.Text:= FloatToStr(Momento);
     edtAlpha.Text  := FloatToStr(SigValAlpha);
     edtErrLim.Text := FloatToStr(ErrLimit);

end;

procedure TfrmMain.GetSetting;
begin
     FattoreAppr :=  StrToFloat(edtAppren.Text);
     CicliAppren :=  StrToInt(edtCicli.Text);
     Momento     :=  StrToFloat(edtMomento.Text);
     SigValAlpha :=  StrToFloat(edtAlpha.Text);
     ErrLimit    :=  StrToFloat(edtErrLim.Text);

end;

procedure TfrmMain.btnStopClick(Sender: TObject);
begin
  IsStopElab := True;
end;

procedure TfrmMain.btnStartClick(Sender: TObject);
begin
    ThReadStartRete
end;

procedure TfrmMain.EnableControl(lEnable: Boolean);
begin

     edtCicli.Enabled   := lEnable;
     cbTipoSig.Enabled  := lEnable;
     edtMomento.Enabled := lEnable;
     edtAppren.Enabled  := lEnable;
     edtAlpha.Enabled   := lEnable;
     edtErrLim.Enabled  := lEnable;

     btnStart.Enabled  := lEnable;
     btnStop.Enabled   := not lEnable;
end;

procedure TfrmMain.ThReadStartRete;
var
 fun  : IActivationFunction;
 net  : TAttivazNetwork;
 add  : TBackPropagationLearning;
 input,output : AADouble;
 Cicli ,i: Integer;
 errore : Double;
begin
    SetLength(input,4,2);
    SetLength(output,4,1);
    mErrori.Clear;
    Cicli      := 0;
    IsStopElab := False;
    GetSetting;
    ShowSetting;
    stCiclo.Caption := '';
    stErrore.Caption:= '';

    // tipo sigmoide unipolare
    if cbTipoSig.ItemIndex = 0  then
    begin
          input[0][0] := 0;  input[0][1] := 0;
		      input[1][0] := 0;  input[1][1] := 1;
		      input[2][0] := 1;  input[2][1] := 0;
		      input[3][0] := 1;  input[3][1] := 1;

		      output[0][0]:= 0;
		      output[1][0]:= 1;
		      output[2][0]:= 1;
		      output[3][0]:= 0;
          // funzione di attivazione
          fun := TFunzioneSigmoide.Create(SigValAlpha);
    end
     // tipo sigmoide bipolare
    else begin
          input[0][0] := -1;   input[0][1] := -1;
		      input[1][0] := -1;   input[1][1] :=  1;
		      input[2][0] :=  1;   input[2][1] := -1;
		      input[3][0] :=  1;   input[3][1] :=  1;

		      output[0][0]:= -1;
		      output[1][0]:=  1;
		      output[2][0]:=  1;
		      output[3][0]:= -1;
          // funzione di attivazione
          fun := TFunzioneSigmoidBipolare.Create(SigValAlpha);
    end;


    // rete con 2 input , 2 layer il primo con 2 neuroni il secondo con 1 neurone
    net := TAttivazNetwork.Create(fun,2,[2,1]);
    // crea l'addestramento
    add := TBackPropagationLearning.Create(net);
    //preleva i valori
    add.FattApprendimento := FattoreAppr;
    add.Momento           := Momento;

    net.GenRandom;

    EnableControl(False);
    Grafico.Clear;

    //Esegue il ciclo di addestramento
    while (Cicli <= CicliAppren) and (not IsStopElab) do
    begin
        errore := add.RunEpoch(input,output);

        stCiclo.Caption := IntToStr(Cicli);
        stErrore.Caption:= FloatToStr(errore);
        mErrori.Lines.Add(FloatToStr(errore));
        Inc(Cicli);
        Application.ProcessMessages;
        if errore <= ErrLimit then  Break;
        grafico.AddXY(errore,Cicli)
    end;
    EnableControl(True);


end;

end.
