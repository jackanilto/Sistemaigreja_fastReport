unit Filial;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Mask,
  Vcl.Buttons, Vcl.Grids, Vcl.DBGrids, Vcl.Imaging.jpeg, Vcl.ExtCtrls;

type
  TFrmFilial = class(TForm)
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
    Label8: TLabel;
    cbMatriz: TComboBox;
    procedure edtBuscarChange(Sender: TObject);
    procedure gridCellClick(Column: TColumn);
    procedure FormShow(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnDeletarClick(Sender: TObject);
  private
    { Private declarations }
    procedure limparCampos();
    procedure habilitarCampos();
    procedure desabilitarCampos();
    procedure buscarTudo();
    procedure buscarNome();
    procedure associarCampos();
    procedure carregarCombobox();
  public
    { Public declarations }
  end;

var
  FrmFilial: TFrmFilial;
  nomeAntigo: string;
implementation

{$R *.dfm}

uses Modulo;


procedure TFrmFilial.associarCampos;
begin
dm.tb_filial.FieldByName('nome').Value := edtNome.Text;
dm.tb_filial.FieldByName('endereco').Value := edtEndereco.Text;
dm.tb_filial.FieldByName('numero').Value := edtNumero.Text;
dm.tb_filial.FieldByName('bairro').Value := edtBairro.Text;
dm.tb_filial.FieldByName('cidade').Value := edtCidade.Text;
dm.tb_filial.FieldByName('telefone').Value := edtTel.Text;
dm.tb_filial.FieldByName('matriz').Value := cbMatriz.Text;
end;



procedure TFrmFilial.btnDeletarClick(Sender: TObject);
begin
 if Messagedlg('Deseja excluir o registro?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
   associarCampos;
    dm.query_filial.Close;
    dm.query_filial.SQL.Clear;
    dm.query_filial.SQL.Add('delete from filial where id = :id');

    dm.query_filial.ParamByName('id').Value := edtCodigo.Text;
    dm.query_filial.ExecSql;
     MessageDlg('Excluido com Sucesso!!', mtInformation, mbOKCancel, 0);
    buscarTudo;
    desabilitarCampos;
    btnSalvar.Enabled := false;
    btnEditar.Enabled := false;
    btnDeletar.Enabled := false;
    btnNovo.Enabled := true;
  end;
end;

procedure TFrmFilial.btnEditarClick(Sender: TObject);
begin
if (edtNome.Text <> '') and (edtEndereco.Text <> '') then
    begin
    associarCampos;
    dm.tb_filial.Edit;

    dm.query_filial.Close;
    dm.query_filial.SQL.Clear;
    dm.query_filial.SQL.Add('update filial set nome = :nome, endereco = :end, numero = :numero, bairro = :bairro, cidade = :cidade, telefone = :tel, matriz = :matriz where id = :id');
    dm.query_filial.ParamByName('nome').Value := edtNome.Text;
    dm.query_filial.ParamByName('end').Value := edtEndereco.Text;
    dm.query_filial.ParamByName('numero').Value := edtNumero.Text;
    dm.query_filial.ParamByName('bairro').Value := edtBairro.Text;
    dm.query_filial.ParamByName('cidade').Value := edtCidade.Text;
    dm.query_filial.ParamByName('tel').Value := edtTel.Text;
    dm.query_filial.ParamByName('matriz').Value := cbMatriz.Text;
    dm.query_filial.ParamByName('id').Value := edtCodigo.Text;
    dm.query_filial.ExecSql;

    MessageDlg('Editado com Sucesso!!', mtInformation, mbOKCancel, 0);

    if nomeIgreja = nomeAntigo then
    nomeIgreja := edtNome.Text;


    dm.query_pessoas.Close;
    dm.query_pessoas.SQL.Clear;
    dm.query_pessoas.SQL.Add('update pessoas set filial = :nome where filial = :nomeAntigo');
    dm.query_pessoas.ParamByName('nome').Value := edtNome.Text;
    dm.query_pessoas.ParamByName('nomeAntigo').Value := nomeAntigo;
    dm.query_pessoas.ExecSql;

    dm.query_usuarios.Close;
    dm.query_usuarios.SQL.Clear;
    dm.query_usuarios.SQL.Add('update usuarios set filial = :nome where filial = :nomeAntigo');
    dm.query_usuarios.ParamByName('nome').Value := edtNome.Text;
    dm.query_usuarios.ParamByName('nomeAntigo').Value := nomeAntigo;
    dm.query_usuarios.ExecSql;

       dm.query_entradas.Close;
    dm.query_entradas.SQL.Clear;
    dm.query_entradas.SQL.Add('update entradas set igreja = :nome where igreja = :nomeAntigo');
    dm.query_entradas.ParamByName('nome').Value := edtNome.Text;
    dm.query_entradas.ParamByName('nomeAntigo').Value := nomeAntigo;
    dm.query_entradas.ExecSql;

       dm.query_saidas.Close;
    dm.query_saidas.SQL.Clear;
    dm.query_saidas.SQL.Add('update saidas set igreja = :nome where igreja = :nomeAntigo');
    dm.query_saidas.ParamByName('nome').Value := edtNome.Text;
    dm.query_saidas.ParamByName('nomeAntigo').Value := nomeAntigo;
    dm.query_saidas.ExecSql;


       dm.query_movimentacoes.Close;
    dm.query_movimentacoes.SQL.Clear;
    dm.query_movimentacoes.SQL.Add('update movimentacoes set igreja = :nome where igreja = :nomeAntigo');
    dm.query_movimentacoes.ParamByName('nome').Value := edtNome.Text;
    dm.query_movimentacoes.ParamByName('nomeAntigo').Value := nomeAntigo;
    dm.query_movimentacoes.ExecSql;


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

procedure TFrmFilial.btnNovoClick(Sender: TObject);
begin
limparCampos;
habilitarCampos;
dm.tb_filial.Insert;
BtnSalvar.Enabled := true;
btnNovo.Enabled := false;

btnEditar.Enabled := false;
    btnDeletar.Enabled := false;
end;

procedure TFrmFilial.btnSalvarClick(Sender: TObject);
begin
if (edtNome.Text <> '') and (edtEndereco.Text <> '') then
  begin
  associarCampos;
  dm.tb_filial.Post;
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

procedure TFrmFilial.buscarNome;
begin
dm.query_filial.Close;
dm.query_filial.SQL.Clear;
dm.query_filial.SQL.Add('select * from filial where nome LIKE :nome order by nome asc');
dm.query_filial.ParamByName('nome').Value := edtBuscar.Text + '%';
dm.query_filial.Open;
end;

procedure TFrmFilial.buscarTudo;
begin
dm.query_filial.Close;
dm.query_filial.SQL.Clear;
dm.query_filial.SQL.Add('select * from filial order by nome asc');
dm.query_filial.Open;
end;

procedure TFrmFilial.carregarCombobox;
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

procedure TFrmFilial.desabilitarCampos;
begin
limparcampos();
edtNome.Enabled := false;
edtEndereco.Enabled := false  ;
edtNumero.Enabled := false  ;
edtBairro.Enabled := false ;
edtCidade.Enabled := false ;
edtTel.Enabled := false    ;
cbMatriz.Enabled := false;
end;


procedure TFrmFilial.edtBuscarChange(Sender: TObject);
begin
      buscarNome;
end;

procedure TFrmFilial.FormShow(Sender: TObject);
begin
dm.tb_filial.Active := false;
dm.tb_filial.Active := true;

dm.tb_matriz.Active := false;
dm.tb_matriz.Active := true;

buscarTudo;
carregarCombobox;

btnSalvar.Enabled := false;
btnEditar.Enabled := false;
btnDeletar.Enabled := false;
end;

procedure TFrmFilial.gridCellClick(Column: TColumn);
begin
dm.tb_filial.Edit;
btnEditar.Enabled := true;
btnDeletar.Enabled := true;
habilitarCampos;

if dm.query_filial.FieldByName('nome').Value <> null then
edtNome.Text := dm.query_filial.FieldByName('nome').Value;
nomeAntigo := edtNome.Text;

 if dm.query_filial.FieldByName('endereco').Value <> null then
edtEndereco.Text := dm.query_filial.FieldByName('endereco').Value;

 if dm.query_filial.FieldByName('numero').Value <> null then
edtNumero.Text := dm.query_filial.FieldByName('numero').Value;

 if dm.query_filial.FieldByName('bairro').Value <> null then
edtBairro.Text := dm.query_filial.FieldByName('bairro').Value;

 if dm.query_filial.FieldByName('cidade').Value <> null then
edtCidade.Text := dm.query_filial.FieldByName('cidade').Value;

 if dm.query_filial.FieldByName('telefone').Value <> null then
edtTel.Text := dm.query_filial.FieldByName('telefone').Value;

 if dm.query_filial.FieldByName('id').Value <> null then
edtCodigo.Text := dm.query_filial.FieldByName('id').Value;

 if dm.query_filial.FieldByName('matriz').Value <> null then
cbMatriz.Text := dm.query_filial.FieldByName('matriz').Value;

end;

procedure TFrmFilial.habilitarCampos;
begin
limparcampos();
edtNome.Enabled := true;
edtEndereco.Enabled := true  ;
edtNumero.Enabled := true  ;
edtBairro.Enabled := true ;
edtCidade.Enabled := true ;
edtTel.Enabled := true    ;
edtNome.SetFocus;
cbMatriz.Enabled := true;
end;

procedure TFrmFilial.limparCampos;
begin
edtNome.Text := '';
edtEndereco.Text := '';
edtNumero.Text := '';
edtBairro.Text := '';
edtCidade.Text := '';
edtTel.Text := '';
cbMatriz.ItemIndex := 0;
end;

end.
