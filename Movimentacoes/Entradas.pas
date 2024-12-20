unit Entradas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.Buttons, Vcl.Imaging.jpeg, Vcl.ExtCtrls;

type
  TFrmEntradas = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btnNovo: TSpeedButton;
    btnSalvar: TSpeedButton;
    btnEditar: TSpeedButton;
    btnDeletar: TSpeedButton;
    edtValor: TEdit;
    grid: TDBGrid;
    edtCodigo: TEdit;
    cbMovimento: TComboBox;
    data: TDateTimePicker;
    lblTotal: TLabel;
    lblIgreja: TLabel;
    cbIgreja: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure btnDeletarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure dataChange(Sender: TObject);
    procedure gridCellClick(Column: TColumn);
    procedure cbIgrejaChange(Sender: TObject);
  private
    { Private declarations }
     procedure limparCampos();
    procedure habilitarCampos();
    procedure desabilitarCampos();

    procedure buscarData();
    procedure associarCampos();
    procedure totalizar();
    procedure formatarGrid();
    procedure carregarCombobox();
  public
    { Public declarations }
  end;

var
  FrmEntradas: TFrmEntradas;

implementation

{$R *.dfm}

uses Modulo;

procedure TFrmEntradas.associarCampos;
begin
dm.tb_entradas.FieldByName('movimento').Value := cbMovimento.Text;
dm.tb_entradas.FieldByName('valor').Value := edtValor.Text;
dm.tb_entradas.FieldByName('igreja').Value := nomeIgreja;
dm.tb_entradas.FieldByName('pessoa').Value := nomePessoa;
dm.tb_entradas.FieldByName('data').Value := DateTostr(Date);
end;

procedure TFrmEntradas.btnDeletarClick(Sender: TObject);
begin
if Messagedlg('Deseja excluir o registro?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
   associarCampos;
    dm.query_entradas.Close;
    dm.query_entradas.SQL.Clear;
    dm.query_entradas.SQL.Add('delete from entradas where id = :id');

    dm.query_entradas.ParamByName('id').Value := edtCodigo.Text;
    dm.query_entradas.ExecSql;
     MessageDlg('Excluido com Sucesso!!', mtInformation, mbOKCancel, 0);

     dm.query_movimentacoes.Close;
    dm.query_movimentacoes.SQL.Clear;
    dm.query_movimentacoes.SQL.Add('delete from movimentacoes where id_movimento = :id and tipo = "Entrada"');

    dm.query_movimentacoes.ParamByName('id').Value := edtCodigo.Text;
    dm.query_movimentacoes.ExecSql;

    buscarData;
    desabilitarCampos;
    btnSalvar.Enabled := false;
    btnEditar.Enabled := false;
    btnDeletar.Enabled := false;
    btnNovo.Enabled := true;
  end;
end;

procedure TFrmEntradas.btnEditarClick(Sender: TObject);
begin
if (cbMovimento.Text <> '') and (edtValor.Text <> '') then
    begin
    associarCampos;
    dm.tb_entradas.Edit;

    dm.query_entradas.Close;
    dm.query_entradas.SQL.Clear;
    dm.query_entradas.SQL.Add('update entradas set movimento = :movimento, valor = :valor where id = :id');
    dm.query_entradas.ParamByName('movimento').Value := cbMovimento.Text;
    dm.query_entradas.ParamByName('valor').Value := edtValor.Text;


    dm.query_entradas.ParamByName('id').Value := edtCodigo.Text;
    dm.query_entradas.ExecSql;

    MessageDlg('Editado com Sucesso!!', mtInformation, mbOKCancel, 0);

     dm.query_movimentacoes.Close;
    dm.query_movimentacoes.SQL.Clear;
    dm.query_movimentacoes.SQL.Add('update movimentacoes set valor = :valor where id_movimento = :id and tipo = "Entrada"');
    dm.query_movimentacoes.ParamByName('valor').Value := edtValor.Text;
    dm.query_movimentacoes.ParamByName('id').Value := edtCodigo.Text;
    dm.query_movimentacoes.ExecSql;

    buscarData;
    desabilitarCampos;
    btnSalvar.Enabled := false;
    btnEditar.Enabled := false;
    btnDeletar.Enabled := false;
    btnNovo.Enabled := true;
    end
    else
    begin
    MessageDlg('Preencha os Campos', mtInformation, mbOKCancel, 0);
    end;
end;

procedure TFrmEntradas.btnNovoClick(Sender: TObject);
begin
limparCampos;
habilitarCampos;
dm.tb_entradas.Insert;
BtnSalvar.Enabled := true;
btnNovo.Enabled := false;

btnEditar.Enabled := false;
    btnDeletar.Enabled := false;
end;

procedure TFrmEntradas.btnSalvarClick(Sender: TObject);
var
ultimoId : integer;
begin
if (cbMovimento.Text <> '') and (edtValor.Text <> '') then
  begin
  associarCampos;
  dm.tb_entradas.Post;
  MessageDlg('Salvo com Sucesso!!', mtInformation, mbOKCancel, 0);


  dm.query_entradas.SQL.Clear;
  dm.query_entradas.SQL.Add('select * from entradas order by id desc');
  dm.query_entradas.Open;
  ultimoid :=  dm.query_entradas['id'];

  {SALVANDO DADOS NA TABELA DE MOVIMENTAÇÕES}
   dm.query_movimentacoes.Close;
    dm.query_movimentacoes.SQL.Clear;
    dm.query_movimentacoes.SQL.Add('insert into movimentacoes (tipo, movimento, valor, igreja, pessoa, data, id_movimento) values (:tipo, :movimento, :valor, :igreja, :pessoa, curDate(), :idmovimento)');
    dm.query_movimentacoes.ParamByName('tipo').Value := 'Entrada';
    dm.query_movimentacoes.ParamByName('movimento').Value := cbMovimento.Text;
    dm.query_movimentacoes.ParamByName('valor').Value := edtValor.Text;
    dm.query_movimentacoes.ParamByName('igreja').Value := nomeIgreja;
    dm.query_movimentacoes.ParamByName('pessoa').Value := nomePessoa;
    dm.query_movimentacoes.ParamByName('idmovimento').Value := ultimoid;
    dm.query_movimentacoes.ExecSql;

  buscarData;
  desabilitarCampos;
  btnSalvar.Enabled := false;
  btnNovo.Enabled := true;
  btnEditar.Enabled := false;
  btnDeletar.Enabled := false;
  end
  else
  begin
  MessageDlg('Preencha os Campos', mtInformation, mbOKCancel, 0);
  end;
end;

procedure TFrmEntradas.buscarData;
begin

totalizar;
dm.query_entradas.Close;
dm.query_entradas.SQL.Clear;
dm.query_entradas.SQL.Add('select * from entradas where data = :data and igreja = :igreja order by data desc');
dm.query_entradas.ParamByName('data').Value := FormatDateTime('yyyy/mm/dd', data.Date);
dm.query_entradas.ParamByName('igreja').Value := cbIgreja.Text;
dm.query_entradas.Open;



formatarGrid;

end;



procedure TFrmEntradas.carregarCombobox;
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

procedure TFrmEntradas.cbIgrejaChange(Sender: TObject);
begin
buscarData();
end;

procedure TFrmEntradas.dataChange(Sender: TObject);
begin
buscarData;
end;

procedure TFrmEntradas.desabilitarCampos;
begin
limparcampos();
edtValor.Enabled := false;

cbMovimento.Enabled := false;
end;

procedure TFrmEntradas.formatarGrid;
begin
grid.Columns.Items[0].FieldName := 'id';
grid.Columns.Items[0].Title.Caption := 'Id';
grid.Columns.Items[0].Visible := false;

grid.Columns.Items[1].FieldName := 'movimento';
grid.Columns.Items[1].Title.Caption := 'Movimento';

grid.Columns.Items[2].FieldName := 'valor';
grid.Columns.Items[2].Title.Caption := 'Valor';

grid.Columns.Items[3].FieldName := 'igreja';
grid.Columns.Items[3].Title.Caption := 'Igreja';

grid.Columns.Items[4].FieldName := 'pessoa';
grid.Columns.Items[4].Title.Caption := 'Pessoa';

grid.Columns.Items[5].FieldName := 'data';
grid.Columns.Items[5].Title.Caption := 'Data';

end;

procedure TFrmEntradas.FormShow(Sender: TObject);
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





data.Date := Date;

dm.tb_entradas.Active := false;
dm.tb_entradas.Active := true;


buscarData;


btnSalvar.Enabled := false;
btnEditar.Enabled := false;
btnDeletar.Enabled := false;


end;

procedure TFrmEntradas.gridCellClick(Column: TColumn);
begin
dm.tb_entradas.Edit;
btnEditar.Enabled := true;
btnDeletar.Enabled := true;
habilitarCampos;

if dm.query_entradas.FieldByName('movimento').Value <> null then
cbMovimento.Text := dm.query_entradas.FieldByName('movimento').Value;

 if dm.query_entradas.FieldByName('valor').Value <> null then
edtValor.Text := dm.query_entradas.FieldByName('valor').Value;

 if dm.query_entradas.FieldByName('id').Value <> null then
edtCodigo.Text := dm.query_entradas.FieldByName('id').Value;
end;

procedure TFrmEntradas.habilitarCampos;
begin
limparcampos();
edtValor.Enabled := true;

cbMovimento.Enabled := true;
end;

procedure TFrmEntradas.limparCampos;
begin

edtValor.text := '';

cbMovimento.itemIndex := 0;
end;

procedure TFrmEntradas.totalizar;
var
tot : real;
begin
dm.query_entradas.Close;
dm.query_entradas.SQL.Clear;
dm.query_entradas.SQL.Add('select sum(valor) as total from entradas where data = :data and igreja = :igreja ') ;
dm.query_entradas.ParamByName('data').Value :=  FormatDateTime('yyyy/mm/dd', data.Date);
dm.query_entradas.ParamByName('igreja').Value :=  cbIgreja.Text;
dm.query_entradas.Open;
tot := dm.query_entradas.FieldByName('total').AsFloat;
lblTotal.Caption := FormatFloat('R$ #,,,,0.00', tot);
end;

end.
