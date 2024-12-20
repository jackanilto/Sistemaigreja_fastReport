unit Saidas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.Buttons, Vcl.Imaging.jpeg, Vcl.ExtCtrls;

type
  TFrmSaidas = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btnNovo: TSpeedButton;
    btnSalvar: TSpeedButton;
    btnEditar: TSpeedButton;
    btnDeletar: TSpeedButton;
    lblTotal: TLabel;
    edtValor: TEdit;
    grid: TDBGrid;
    edtCodigo: TEdit;
    data: TDateTimePicker;
    lblIgreja: TLabel;
    cbIgreja: TComboBox;
    edtDescricao: TEdit;
    procedure btnDeletarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure cbIgrejaChange(Sender: TObject);
    procedure dataChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure gridCellClick(Column: TColumn);
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
  FrmSaidas: TFrmSaidas;

implementation

{$R *.dfm}

uses Modulo;

{ TFrmSaidas }

procedure TFrmSaidas.associarCampos;
begin
dm.tb_saidas.FieldByName('movimento').Value := edtDescricao.Text;
dm.tb_saidas.FieldByName('valor').Value := edtValor.Text;
dm.tb_saidas.FieldByName('igreja').Value := nomeIgreja;
dm.tb_saidas.FieldByName('pessoa').Value := nomePessoa;
dm.tb_saidas.FieldByName('data').Value := DateTostr(Date);
end;

procedure TFrmSaidas.btnDeletarClick(Sender: TObject);
begin
if Messagedlg('Deseja excluir o registro?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
   associarCampos;
    dm.query_saidas.Close;
    dm.query_saidas.SQL.Clear;
    dm.query_saidas.SQL.Add('delete from saidas where id = :id');

    dm.query_saidas.ParamByName('id').Value := edtCodigo.Text;
    dm.query_saidas.ExecSql;
     MessageDlg('Excluido com Sucesso!!', mtInformation, mbOKCancel, 0);



     dm.query_movimentacoes.Close;
    dm.query_movimentacoes.SQL.Clear;
    dm.query_movimentacoes.SQL.Add('delete from movimentacoes where id_movimento = :id and tipo = "Sa�da"');

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

procedure TFrmSaidas.btnEditarClick(Sender: TObject);
begin
if (edtDescricao.Text <> '') and (edtValor.Text <> '') then
    begin
    associarCampos;
    dm.tb_saidas.Edit;

    dm.query_saidas.Close;
    dm.query_saidas.SQL.Clear;
    dm.query_saidas.SQL.Add('update saidas set movimento = :movimento, valor = :valor where id = :id');
    dm.query_saidas.ParamByName('movimento').Value := edtDescricao.Text;
    dm.query_saidas.ParamByName('valor').Value := edtValor.Text;


    dm.query_saidas.ParamByName('id').Value := edtCodigo.Text;
    dm.query_saidas.ExecSql;

    MessageDlg('Editado com Sucesso!!', mtInformation, mbOKCancel, 0);


     dm.query_movimentacoes.Close;
    dm.query_movimentacoes.SQL.Clear;
    dm.query_movimentacoes.SQL.Add('update movimentacoes set valor = :valor where id_movimento = :id and tipo = "Sa�da"');
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

procedure TFrmSaidas.btnNovoClick(Sender: TObject);
begin
limparCampos;
habilitarCampos;
dm.tb_saidas.Insert;
BtnSalvar.Enabled := true;
btnNovo.Enabled := false;

btnEditar.Enabled := false;
    btnDeletar.Enabled := false;
end;

procedure TFrmSaidas.btnSalvarClick(Sender: TObject);
var
ultimoId : integer;
begin
if (edtDescricao.Text <> '') and (edtValor.Text <> '') then
  begin
  associarCampos;
  dm.tb_saidas.Post;
  MessageDlg('Salvo com Sucesso!!', mtInformation, mbOKCancel, 0);

   dm.query_saidas.SQL.Clear;
  dm.query_saidas.SQL.Add('select * from saidas order by id desc');
  dm.query_saidas.Open;
  ultimoid :=  dm.query_saidas['id'];

  {SALVANDO DADOS NA TABELA DE MOVIMENTA��ES}
   dm.query_movimentacoes.Close;
    dm.query_movimentacoes.SQL.Clear;
    dm.query_movimentacoes.SQL.Add('insert into movimentacoes (tipo, movimento, valor, igreja, pessoa, data, id_movimento) values (:tipo, :movimento, :valor, :igreja, :pessoa, curDate(), :idmovimento)');
    dm.query_movimentacoes.ParamByName('tipo').Value := 'Sa�da';
    dm.query_movimentacoes.ParamByName('movimento').Value := edtDescricao.Text;
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

procedure TFrmSaidas.buscarData;
begin
totalizar;
dm.query_saidas.Close;
dm.query_saidas.SQL.Clear;
dm.query_saidas.SQL.Add('select * from saidas where data = :data and igreja = :igreja order by data desc');
dm.query_saidas.ParamByName('data').Value := FormatDateTime('yyyy/mm/dd', data.Date);
dm.query_saidas.ParamByName('igreja').Value := cbIgreja.Text;
dm.query_saidas.Open;



formatarGrid;
end;

procedure TFrmSaidas.carregarCombobox;
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

procedure TFrmSaidas.cbIgrejaChange(Sender: TObject);
begin
buscarData();
end;

procedure TFrmSaidas.dataChange(Sender: TObject);
begin
buscarData();
end;

procedure TFrmSaidas.desabilitarCampos;
begin
 limparcampos();
edtValor.Enabled := false;

edtDescricao.Enabled := false;
end;

procedure TFrmSaidas.formatarGrid;
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

procedure TFrmSaidas.FormShow(Sender: TObject);
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

dm.tb_saidas.Active := false;
dm.tb_saidas.Active := true;


buscarData;


btnSalvar.Enabled := false;
btnEditar.Enabled := false;
btnDeletar.Enabled := false;

end;

procedure TFrmSaidas.gridCellClick(Column: TColumn);
begin
dm.tb_saidas.Edit;
btnEditar.Enabled := true;
btnDeletar.Enabled := true;
habilitarCampos;

if dm.query_saidas.FieldByName('movimento').Value <> null then
edtDescricao.Text := dm.query_saidas.FieldByName('movimento').Value;

 if dm.query_saidas.FieldByName('valor').Value <> null then
edtValor.Text := dm.query_saidas.FieldByName('valor').Value;

 if dm.query_saidas.FieldByName('id').Value <> null then
edtCodigo.Text := dm.query_saidas.FieldByName('id').Value;


end;

procedure TFrmSaidas.habilitarCampos;
begin
limparcampos();
edtValor.Enabled := true;

edtDescricao.Enabled := true;
end;

procedure TFrmSaidas.limparCampos;
begin
edtValor.text := '';

edtDescricao.text := '';
end;

procedure TFrmSaidas.totalizar;
var
tot : real;
begin
dm.query_saidas.Close;
dm.query_saidas.SQL.Clear;
dm.query_saidas.SQL.Add('select sum(valor) as total from saidas where data = :data and igreja = :igreja ') ;
dm.query_saidas.ParamByName('data').Value :=  FormatDateTime('yyyy/mm/dd', data.Date);
dm.query_saidas.ParamByName('igreja').Value :=  cbIgreja.Text;
dm.query_saidas.Open;
tot := dm.query_saidas.FieldByName('total').AsFloat;
lblTotal.Caption := FormatFloat('R$ #,,,,0.00', tot);
end;

end.
