unit Movimentacoes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TFrmMovimentacoes = class(TForm)
    grid: TDBGrid;
    Image1: TImage;
    lblIgreja: TLabel;
    cbIgreja: TComboBox;
    Label1: TLabel;
    dataInicial: TDateTimePicker;
    Label2: TLabel;
    dataFinal: TDateTimePicker;
    lblTotalEntradas: TLabel;
    lblTotalSaidas: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lblTotal: TLabel;
    procedure FormShow(Sender: TObject);
    procedure cbIgrejaChange(Sender: TObject);
    procedure dataInicialChange(Sender: TObject);
    procedure dataFinalChange(Sender: TObject);
  private
    { Private declarations }
    procedure buscarData();
    procedure carregarCombobox();
    procedure totalizarEntradas();
    procedure totalizarSaidas();
    procedure totalizar;
  public
    { Public declarations }
  end;

var
  FrmMovimentacoes: TFrmMovimentacoes;
  totalEntradas : real;
  totalSaidas : real;
implementation

{$R *.dfm}

uses Modulo;

{ TFrmMovimentacoes }

procedure TFrmMovimentacoes.buscarData;
begin
dm.query_movimentacoes.Close;
dm.query_movimentacoes.SQL.Clear;
dm.query_movimentacoes.SQL.Add('select * from movimentacoes where data >= :dataInicial and data <= :dataFinal and igreja = :igreja order by data desc');
dm.query_movimentacoes.ParamByName('dataInicial').Value :=  FormatDateTime('yyyy/mm/dd', dataInicial.Date);
dm.query_movimentacoes.ParamByName('dataFinal').Value :=  FormatDateTime('yyyy/mm/dd', dataFinal.Date);
dm.query_movimentacoes.ParamByName('igreja').Value :=  cbIgreja.Text;
TFloatField(dm.query_movimentacoes.FieldByName('valor')).DisplayFormat := 'R$ #,,,,0.00';
dm.query_movimentacoes.Open;


totalizarEntradas;
totalizarSaidas;
totalizar;

end;

procedure TFrmMovimentacoes.carregarCombobox;
begin
 if not dm.tb_filial.IsEmpty then
  begin
    while not dm.tb_filial.Eof do
    begin
       cbIgreja.Items.Add(dm.tb_filial.FieldByName('nome').AsString);
       dm.tb_filial.next;
    end;
  end;
end;

procedure TFrmMovimentacoes.cbIgrejaChange(Sender: TObject);
begin
buscarData;
end;

procedure TFrmMovimentacoes.dataFinalChange(Sender: TObject);
begin
buscarData;
end;

procedure TFrmMovimentacoes.dataInicialChange(Sender: TObject);
begin
buscarData;
end;

procedure TFrmMovimentacoes.FormShow(Sender: TObject);
begin

if (funcaoPessoa = 'Pastor Presidente') or (funcaoPessoa = 'Administrador') then
begin
dm.tb_filial.Active := false;
dm.tb_filial.Active := true;

carregarCombobox();
cbIgreja.Text := nomeIgreja;
cbIgreja.Enabled := true;
cbIgreja.Visible := true;
lblIgreja.Visible := true;
end
else
begin
cbIgreja.Text := nomeIgreja;
cbIgreja.Visible := false;
lblIgreja.Visible := false;
end;


dataInicial.Date := Date;
dataFinal.Date := Date;
buscarData;

end;



procedure TFrmMovimentacoes.totalizar;
var
tot : real;
begin
tot := totalEntradas - totalSaidas;
if tot < 0 then
begin
lblTotal.Font.Color := clRed;
end
else
begin
lblTotal.Font.Color := clGreen;
end;
lblTotal.Caption := FormatFloat('R$ #,,,,0.00', tot);
end;

procedure TFrmMovimentacoes.totalizarEntradas;
var
tot : real;
begin
dm.query_entradas.Close;
dm.query_entradas.SQL.Clear;
dm.query_entradas.SQL.Add('select sum(valor) as total from entradas where data >= :dataInicial and data <= :dataFinal and igreja = :igreja ') ;
dm.query_entradas.ParamByName('dataInicial').Value :=  FormatDateTime('yyyy/mm/dd', dataInicial.Date);
dm.query_entradas.ParamByName('dataFinal').Value :=  FormatDateTime('yyyy/mm/dd', dataFinal.Date);
dm.query_entradas.ParamByName('igreja').Value :=  cbIgreja.Text;
dm.query_entradas.Open;
tot := dm.query_entradas.FieldByName('total').AsFloat;
totalEntradas := tot;
lblTotalEntradas.Caption := FormatFloat('R$ #,,,,0.00', tot);
end;

procedure TFrmMovimentacoes.totalizarSaidas;
var
tot : real;
begin
dm.query_saidas.Close;
dm.query_saidas.SQL.Clear;
dm.query_saidas.SQL.Add('select sum(valor) as total from saidas where data >= :dataInicial and data <= :dataFinal and igreja = :igreja ') ;
dm.query_saidas.ParamByName('dataInicial').Value :=  FormatDateTime('yyyy/mm/dd', dataInicial.Date);
dm.query_saidas.ParamByName('dataFinal').Value :=  FormatDateTime('yyyy/mm/dd', dataFinal.Date);
dm.query_saidas.ParamByName('igreja').Value :=  cbIgreja.Text;
dm.query_saidas.Open;
tot := dm.query_saidas.FieldByName('total').AsFloat;
totalSaidas := tot;
lblTotalSaidas.Caption := FormatFloat('R$ #,,,,0.00', tot);
end;

end.
