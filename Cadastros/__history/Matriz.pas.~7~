unit Matriz;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Mask, Vcl.Buttons,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Imaging.jpeg, Vcl.ExtCtrls;

type
  TFrmMatriz = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    edtBuscar: TEdit;
    Label2: TLabel;
    edtNome: TEdit;
    edtEndereco: TEdit;
    Label3: TLabel;
    edtNumero: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    grid: TDBGrid;
    btnNovo: TSpeedButton;
    btnSalvar: TSpeedButton;
    btnEditar: TSpeedButton;
    btnDeletar: TSpeedButton;
    edtBairro: TEdit;
    edtCidade: TEdit;
    Label7: TLabel;
    edtTel: TMaskEdit;
    edtCodigo: TEdit;
    procedure FormShow(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure gridCellClick(Column: TColumn);
    procedure btnEditarClick(Sender: TObject);
    procedure btnDeletarClick(Sender: TObject);
    procedure edtBuscarChange(Sender: TObject);
  private
    { Private declarations }
    procedure limparCampos();
    procedure habilitarCampos();
    procedure desabilitarCampos();
    procedure buscarTudo();
    procedure buscarNome();
    procedure associarCampos();
  public
    { Public declarations }
  end;

var
  FrmMatriz: TFrmMatriz;

implementation

{$R *.dfm}

uses Modulo;

{ TFrmMatriz }

procedure TFrmMatriz.associarCampos;
begin
dm.tb_matriz.FieldByName('nome').Value := edtNome.Text;
dm.tb_matriz.FieldByName('endereco').Value := edtEndereco.Text;
dm.tb_matriz.FieldByName('numero').Value := edtNumero.Text;
dm.tb_matriz.FieldByName('bairro').Value := edtBairro.Text;
dm.tb_matriz.FieldByName('cidade').Value := edtCidade.Text;
dm.tb_matriz.FieldByName('telefone').Value := edtTel.Text;
end;

procedure TFrmMatriz.btnDeletarClick(Sender: TObject);
begin
  if Messagedlg('Deseja excluir o registro?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
   associarCampos;
    dm.tb_matriz.Delete;
     MessageDlg('Excluido com Sucesso!!', mtInformation, mbOKCancel, 0);
    buscarTudo;
    desabilitarCampos;
    btnSalvar.Enabled := false;
    btnEditar.Enabled := false;
    btnDeletar.Enabled := false;
    btnNovo.Enabled := true;
  end;

end;

procedure TFrmMatriz.btnEditarClick(Sender: TObject);
begin
    if (edtNome.Text <> '') and (edtEndereco.Text <> '') then
    begin
    associarCampos;
    dm.tb_matriz.Edit;

    dm.query_matriz.Close;
    dm.query_matriz.SQL.Clear;
    dm.query_matriz.SQL.Add('update matriz set nome = :nome, endereco = :end, numero = :numero, bairro = :bairro, cidade = :cidade, telefone = :tel where id = :id');
    dm.query_matriz.ParamByName('nome').Value := edtNome.Text;
    dm.query_matriz.ParamByName('end').Value := edtEndereco.Text;
    dm.query_matriz.ParamByName('numero').Value := edtNumero.Text;
    dm.query_matriz.ParamByName('bairro').Value := edtBairro.Text;
    dm.query_matriz.ParamByName('cidade').Value := edtCidade.Text;
    dm.query_matriz.ParamByName('tel').Value := edtTel.Text;
    dm.query_matriz.ParamByName('id').Value := edtCodigo.Text;
    dm.query_matriz.ExecSql;

    MessageDlg('Editado com Sucesso!!', mtInformation, mbOKCancel, 0);
    buscarTudo;
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

procedure TFrmMatriz.btnNovoClick(Sender: TObject);
begin
limparCampos;
habilitarCampos;
dm.tb_matriz.Insert;
BtnSalvar.Enabled := true;
btnNovo.Enabled := false;

btnEditar.Enabled := false;
    btnDeletar.Enabled := false;
end;

procedure TFrmMatriz.btnSalvarClick(Sender: TObject);
begin
  if (edtNome.Text <> '') and (edtEndereco.Text <> '') then
  begin
  associarCampos;
  dm.tb_matriz.Post;
  MessageDlg('Salvo com Sucesso!!', mtInformation, mbOKCancel, 0);
  buscarTudo;
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

procedure TFrmMatriz.buscarNome;
begin
dm.query_matriz.Close;
dm.query_matriz.SQL.Clear;
dm.query_matriz.SQL.Add('select * from matriz where nome LIKE :nome order by nome asc');
dm.query_matriz.ParamByName('nome').Value := edtBuscar.Text + '%';
dm.query_matriz.Open;
end;

procedure TFrmMatriz.buscarTudo;
begin
dm.query_matriz.Close;
dm.query_matriz.SQL.Clear;
dm.query_matriz.SQL.Add('select * from matriz order by nome asc');
dm.query_matriz.Open;
end;

procedure TFrmMatriz.desabilitarCampos;
begin
limparcampos();
edtNome.Enabled := false;
edtEndereco.Enabled := false  ;
edtNumero.Enabled := false  ;
edtBairro.Enabled := false ;
edtCidade.Enabled := false ;
edtTel.Enabled := false    ;
end;

procedure TFrmMatriz.edtBuscarChange(Sender: TObject);
begin
buscarNome;
end;

procedure TFrmMatriz.FormShow(Sender: TObject);
begin
buscarTudo;

dm.tb_matriz.Active := true;

btnSalvar.Enabled := false;
btnEditar.Enabled := false;
btnDeletar.Enabled := false;
end;

procedure TFrmMatriz.gridCellClick(Column: TColumn);
begin
dm.tb_matriz.Edit;
btnEditar.Enabled := true;
btnDeletar.Enabled := true;
habilitarCampos;

if dm.query_matriz.FieldByName('nome').Value <> null then
edtNome.Text := dm.query_matriz.FieldByName('nome').Value;

 if dm.query_matriz.FieldByName('endereco').Value <> null then
edtEndereco.Text := dm.query_matriz.FieldByName('endereco').Value;

 if dm.query_matriz.FieldByName('numero').Value <> null then
edtNumero.Text := dm.query_matriz.FieldByName('numero').Value;

 if dm.query_matriz.FieldByName('bairro').Value <> null then
edtBairro.Text := dm.query_matriz.FieldByName('bairro').Value;

 if dm.query_matriz.FieldByName('cidade').Value <> null then
edtCidade.Text := dm.query_matriz.FieldByName('cidade').Value;

 if dm.query_matriz.FieldByName('telefone').Value <> null then
edtTel.Text := dm.query_matriz.FieldByName('telefone').Value;

 if dm.query_matriz.FieldByName('id').Value <> null then
edtCodigo.Text := dm.query_matriz.FieldByName('id').Value;

end;

procedure TFrmMatriz.habilitarCampos;
begin
limparcampos();
edtNome.Enabled := true;
edtEndereco.Enabled := true  ;
edtNumero.Enabled := true  ;
edtBairro.Enabled := true ;
edtCidade.Enabled := true ;
edtTel.Enabled := true    ;
edtNome.SetFocus;
end;

procedure TFrmMatriz.limparCampos;
begin
edtNome.Text := '';
edtEndereco.Text := '';
edtNumero.Text := '';
edtBairro.Text := '';
edtCidade.Text := '';
edtTel.Text := '';
end;

end.
