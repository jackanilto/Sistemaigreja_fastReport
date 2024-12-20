unit RelEntradas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TFrmRelEntradas = class(TForm)
    Label1: TLabel;
    dataInicial: TDateTimePicker;
    Label2: TLabel;
    dataFinal: TDateTimePicker;
    lblIgreja: TLabel;
    cbIgreja: TComboBox;
    Image1: TImage;
    btnRel: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure btnRelClick(Sender: TObject);
  private
    { Private declarations }
    procedure carregarCombobox();
  public
    { Public declarations }
  end;

var
  FrmRelEntradas: TFrmRelEntradas;

implementation

{$R *.dfm}

uses Modulo;

procedure TFrmRelEntradas.btnRelClick(Sender: TObject);
begin
dm.query_filial.Close;
dm.query_filial.SQL.Clear;
dm.query_filial.SQL.Add('select * from filial where nome = :filial');
dm.query_filial.ParamByName('filial').Value := cbIgreja.Text;
dm.query_filial.Open;

dm.query_entradas.Close;
dm.query_entradas.SQL.Clear;
dm.query_entradas.SQL.Add('select * from entradas where data >= :dataInicial and data <= :dataFinal and igreja = :filial order by data asc');
dm.query_entradas.ParamByName('dataInicial').Value := FormatDateTime('yyyy/mm/dd', dataInicial.Date);
dm.query_entradas.ParamByName('dataFinal').Value := FormatDateTime('yyyy/mm/dd', dataFinal.Date);
dm.query_entradas.ParamByName('filial').Value := cbIgreja.Text;
dm.query_entradas.Open;


dm.rel_entradas.LoadFromFile(GetCurrentDir + '\rel\Entradas.fr3');
dm.rel_entradas.Variables['dataInicial'] := dataInicial.Date;
dm.rel_entradas.Variables['dataFinal'] := dataFinal.Date;
dm.rel_entradas.ShowReport();

end;

procedure TFrmRelEntradas.carregarCombobox;
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

procedure TFrmRelEntradas.FormShow(Sender: TObject);
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
end;

end.
