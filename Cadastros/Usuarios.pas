unit Usuarios;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Buttons, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Vcl.Imaging.jpeg, Vcl.ExtCtrls;

type
  TFrmUsuarios = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    edtBuscar: TEdit;
    Label2: TLabel;
    edtNome: TEdit;
    edtUsuario: TEdit;
    Label3: TLabel;
    edtSenha: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    cbFuncao: TComboBox;
    Label6: TLabel;
    cbMatriz: TComboBox;
    grid: TDBGrid;
    btnNovo: TSpeedButton;
    btnSalvar: TSpeedButton;
    btnEditar: TSpeedButton;
    btnDeletar: TSpeedButton;
    cbFilial: TComboBox;
    Label7: TLabel;
    edtCodigo: TEdit;
    procedure btnNovoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnDeletarClick(Sender: TObject);
    procedure gridCellClick(Column: TColumn);
    procedure FormShow(Sender: TObject);
    procedure edtBuscarChange(Sender: TObject);
    procedure cbFuncaoChange(Sender: TObject);
  private
    { Private declarations }
     procedure limparCampos();
    procedure habilitarCampos();
    procedure desabilitarCampos();
    procedure buscarTudo();
    procedure buscarNome();
    procedure associarCampos();
    procedure carregarComboboxFilial();
    procedure carregarComboboxMatriz();
    procedure carregarComboboxFuncoes();
  public
    { Public declarations }
  end;

var
  FrmUsuarios: TFrmUsuarios;

implementation

{$R *.dfm}

uses Modulo;

{ TFrmUsuarios }

procedure TFrmUsuarios.associarCampos;
begin
dm.tb_usuarios.FieldByName('nome').Value := edtNome.Text;
dm.tb_usuarios.FieldByName('usuario').Value := edtUsuario.Text;
dm.tb_usuarios.FieldByName('senha').Value := edtSenha.Text;
dm.tb_usuarios.FieldByName('funcao').Value := cbFuncao.Text;
dm.tb_usuarios.FieldByName('matriz').Value := cbMatriz.Text;
dm.tb_usuarios.FieldByName('filial').Value := cbFilial.Text;

end;

procedure TFrmUsuarios.btnDeletarClick(Sender: TObject);
begin
if Messagedlg('Deseja excluir o registro?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
   associarCampos;
    dm.query_usuarios.Close;
    dm.query_usuarios.SQL.Clear;
    dm.query_usuarios.SQL.Add('delete from usuarios where id = :id');

    dm.query_usuarios.ParamByName('id').Value := edtCodigo.Text;
    dm.query_usuarios.ExecSql;
     MessageDlg('Excluido com Sucesso!!', mtInformation, mbOKCancel, 0);
    buscarTudo;
    desabilitarCampos;
    btnSalvar.Enabled := false;
    btnEditar.Enabled := false;
    btnDeletar.Enabled := false;
    btnNovo.Enabled := true;
  end;
end;

procedure TFrmUsuarios.btnEditarClick(Sender: TObject);
begin
if (edtNome.Text <> '') then
    begin
    associarCampos;
    dm.tb_usuarios.Edit;

    dm.query_usuarios.Close;
    dm.query_usuarios.SQL.Clear;
    dm.query_usuarios.SQL.Add('update usuarios set nome = :nome, usuario = :usuario, senha = :senha, funcao = :funcao, matriz = :matriz, filial = :filial where id = :id');
    dm.query_usuarios.ParamByName('nome').Value := edtNome.Text;
    dm.query_usuarios.ParamByName('usuario').Value := edtUsuario.Text;
    dm.query_usuarios.ParamByName('senha').Value := edtSenha.Text;
    dm.query_usuarios.ParamByName('funcao').Value := cbFuncao.Text;
    dm.query_usuarios.ParamByName('matriz').Value := cbMatriz.Text;
    dm.query_usuarios.ParamByName('filial').Value := cbFilial.Text;

    dm.query_usuarios.ParamByName('id').Value := edtCodigo.Text;
    dm.query_usuarios.ExecSql;

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

procedure TFrmUsuarios.btnNovoClick(Sender: TObject);
begin
limparCampos;
habilitarCampos;
dm.tb_usuarios.Insert;
BtnSalvar.Enabled := true;
btnNovo.Enabled := false;

btnEditar.Enabled := false;
    btnDeletar.Enabled := false;
end;

procedure TFrmUsuarios.btnSalvarClick(Sender: TObject);
begin
if (edtNome.Text <> '') and (cbFilial.Text <> '') then
  begin
  associarCampos;
  dm.tb_usuarios.Post;
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

procedure TFrmUsuarios.buscarNome;
begin
dm.query_usuarios.Close;
dm.query_usuarios.SQL.Clear;
dm.query_usuarios.SQL.Add('select * from usuarios where nome LIKE :nome order by nome asc');
dm.query_usuarios.ParamByName('nome').Value := edtBuscar.Text + '%';
dm.query_usuarios.Open;
end;

procedure TFrmUsuarios.buscarTudo;
begin
dm.query_usuarios.Close;
dm.query_usuarios.SQL.Clear;
dm.query_usuarios.SQL.Add('select * from usuarios order by nome asc');
dm.query_usuarios.Open;
end;

procedure TFrmUsuarios.carregarComboboxFilial;
begin
 if not dm.tb_filial.IsEmpty then
  begin

    while not dm.tb_filial.Eof do
    begin

       cbFilial.Items.Add(dm.tb_filial.FieldByName('nome').AsString);
       dm.tb_filial.next;
    end;
  end;
end;

procedure TFrmUsuarios.carregarComboboxFuncoes;
begin
if not dm.tb_funcoes.IsEmpty then
  begin
    while not dm.tb_funcoes.Eof do
    begin
       cbFuncao.Items.Add(dm.tb_funcoes.FieldByName('nome').AsString);
       dm.tb_funcoes.next;
    end;
  end;
end;

procedure TFrmUsuarios.carregarComboboxMatriz;
begin
 if not dm.tb_matriz.IsEmpty then
  begin
    while not dm.tb_matriz.Eof do
    begin
       cbMatriz.Items.Add(dm.tb_matriz.FieldByName('nome').AsString);
       dm.tb_matriz.next;
    end;
  end;
end;

procedure TFrmUsuarios.cbFuncaoChange(Sender: TObject);
begin
{if cbFuncao.Text = 'Pastor Presidente' then
begin
  cbFilial.Text := 'Todas';
  cbFilial.Enabled := false;
  end
  else
  begin

  carregarComboboxFilial;
  cbFilial.text := '';
  cbFilial.ItemIndex := 0;
  cbFilial.Enabled := true;

end;  }

end;

procedure TFrmUsuarios.desabilitarCampos;
begin
limparcampos();
edtNome.Enabled := false;
edtUsuario.Enabled := false  ;
edtSenha.Enabled := false  ;
cbFuncao.Enabled := false ;
cbMatriz.Enabled := false ;
cbFilial.Enabled := false    ;

end;

procedure TFrmUsuarios.edtBuscarChange(Sender: TObject);
begin
buscarNome;
end;

procedure TFrmUsuarios.FormShow(Sender: TObject);
begin
dm.tb_filial.Active := false;
dm.tb_filial.Active := true;

dm.tb_matriz.Active := false;
dm.tb_matriz.Active := true;

dm.tb_funcoes.Active := false;
dm.tb_funcoes.Active := true;

dm.tb_usuarios.Active := false;
dm.tb_usuarios.Active := true;

buscarTudo;
carregarComboboxFilial;
carregarComboboxMatriz;
carregarComboboxFuncoes;

btnSalvar.Enabled := false;
btnEditar.Enabled := false;
btnDeletar.Enabled := false;
end;

procedure TFrmUsuarios.gridCellClick(Column: TColumn);
begin
dm.tb_usuarios.Edit;
btnEditar.Enabled := true;
btnDeletar.Enabled := true;
habilitarCampos;

if dm.query_usuarios.FieldByName('nome').Value <> null then
edtNome.Text := dm.query_usuarios.FieldByName('nome').Value;

 if dm.query_usuarios.FieldByName('usuario').Value <> null then
edtUsuario.Text := dm.query_usuarios.FieldByName('usuario').Value;

if dm.query_usuarios.FieldByName('senha').Value <> null then
edtsenha.Text := dm.query_usuarios.FieldByName('senha').Value;

if dm.query_usuarios.FieldByName('funcao').Value <> null then
cbfuncao.Text := dm.query_usuarios.FieldByName('funcao').Value;


if dm.query_usuarios.FieldByName('matriz').Value <> null then
cbmatriz.Text := dm.query_usuarios.FieldByName('matriz').Value;

if dm.query_usuarios.FieldByName('filial').Value <> null then
cbfilial.Text := dm.query_usuarios.FieldByName('filial').Value;

if dm.query_usuarios.FieldByName('id').Value <> null then
edtCodigo.Text := dm.query_usuarios.FieldByName('id').Value;

end;

procedure TFrmUsuarios.habilitarCampos;
begin
limparcampos();
edtNome.Enabled := true;
edtUsuario.Enabled := true  ;
edtSenha.Enabled := true  ;
cbFuncao.Enabled := true ;
cbMatriz.Enabled := true ;
cbFilial.Enabled := true    ;
end;

procedure TFrmUsuarios.limparCampos;
begin
edtNome.text := '';
edtUsuario.text := '';
edtSenha.text := '';
cbMatriz.ItemIndex := 0;
cbFilial.ItemIndex := 0;
cbFuncao.ItemIndex := 0;
end;

end.
