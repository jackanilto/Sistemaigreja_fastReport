unit Pessoas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Mask, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.Buttons, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.ExtDlgs;

type
  TFrmMembros = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    btnNovo: TSpeedButton;
    btnSalvar: TSpeedButton;
    btnEditar: TSpeedButton;
    btnDeletar: TSpeedButton;
    Label7: TLabel;
    edtBuscar: TEdit;
    edtNome: TEdit;
    cbFuncao: TComboBox;
    cbMatriz: TComboBox;
    grid: TDBGrid;
    cbFilial: TComboBox;
    edtCodigo: TEdit;
    img: TImage;
    btnAdd: TButton;
    Label3: TLabel;
    EdtEndereco: TEdit;
    Label4: TLabel;
    edtTel: TMaskEdit;
    dialog: TOpenPictureDialog;
    btnRel: TSpeedButton;
    lblIgreja: TLabel;
    cbIgreja: TComboBox;
    procedure cbFuncaoChange(Sender: TObject);
    procedure edtBuscarChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure gridCellClick(Column: TColumn);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnDeletarClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnRelClick(Sender: TObject);
    procedure cbIgrejaChange(Sender: TObject);
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
    procedure carregarImagemPadrao();
    procedure salvarFoto();
    procedure carregarComboboxIgrejas();

  public
    { Public declarations }
  end;

var
  FrmMembros: TFrmMembros;
  caminhoImg: string;
  imgPessoa: TPicture;
  alterou: boolean;

implementation

{$R *.dfm}

uses Modulo;

{ TFrmMembros }

procedure TFrmMembros.associarCampos;
begin
dm.tb_pessoas.FieldByName('nome').Value := edtNome.Text;
dm.tb_pessoas.FieldByName('endereco').Value := EdtEndereco.Text;
dm.tb_pessoas.FieldByName('telefone').Value := edtTel.Text;
dm.tb_pessoas.FieldByName('funcao').Value := cbFuncao.Text;
dm.tb_pessoas.FieldByName('matriz').Value := cbMatriz.Text;
dm.tb_pessoas.FieldByName('filial').Value := cbFilial.Text;
end;

procedure TFrmMembros.btnAddClick(Sender: TObject);
begin
dialog.Execute();
img.Picture.LoadFromFile(dialog.filename);
alterou := true;
end;

procedure TFrmMembros.btnDeletarClick(Sender: TObject);
begin
if Messagedlg('Deseja excluir o registro?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
   associarCampos;
    dm.query_pessoas.Close;
    dm.query_pessoas.SQL.Clear;
    dm.query_pessoas.SQL.Add('delete from pessoas where id = :id');

    dm.query_pessoas.ParamByName('id').Value := edtCodigo.Text;
    dm.query_pessoas.ExecSql;
     MessageDlg('Excluido com Sucesso!!', mtInformation, mbOKCancel, 0);
    buscarTudo;
    desabilitarCampos;
    btnSalvar.Enabled := false;
    btnEditar.Enabled := false;
    btnDeletar.Enabled := false;
    btnRel.Enabled := false;
    btnNovo.Enabled := true;
  end;
end;

procedure TFrmMembros.btnEditarClick(Sender: TObject);
begin
if (edtNome.Text <> '') and (cbFilial.Text <> '') then
    begin
    associarCampos;
    dm.tb_pessoas.Edit;

    dm.query_pessoas.Close;
    dm.query_pessoas.SQL.Clear;

    if alterou = false then
    begin
    dm.query_pessoas.SQL.Add('update pessoas set nome = :nome, endereco = :endereco, telefone = :telefone, funcao = :funcao, matriz = :matriz, filial = :filial where id = :id');
    end
    else
    begin
    dm.query_pessoas.SQL.Add('update pessoas set nome = :nome, endereco = :endereco, telefone = :telefone, funcao = :funcao, matriz = :matriz, filial = :filial, imagem = :imagem where id = :id');
    imgPessoa := TPicture.Create;
    imgPessoa.LoadFromFile(dialog.FileName);
    dm.query_pessoas.ParamByName('imagem').Assign(imgPessoa);
    imgPessoa.Free;
    alterou := false;
    end;


    dm.query_pessoas.ParamByName('nome').Value := edtNome.Text;
    dm.query_pessoas.ParamByName('endereco').Value := edtEndereco.Text;
    dm.query_pessoas.ParamByName('telefone').Value := edtTel.Text;
    dm.query_pessoas.ParamByName('funcao').Value := cbFuncao.Text;
    dm.query_pessoas.ParamByName('matriz').Value := cbMatriz.Text;
    dm.query_pessoas.ParamByName('filial').Value := cbFilial.Text;

    dm.query_pessoas.ParamByName('id').Value := edtCodigo.Text;
    dm.query_pessoas.ExecSql;

    MessageDlg('Editado com Sucesso!!', mtInformation, mbOKCancel, 0);
    buscarTudo;
    desabilitarCampos;
    limparCampos;
    btnSalvar.Enabled := false;
    btnEditar.Enabled := false;
    btnDeletar.Enabled := false;
    btnRel.Enabled := false;
    btnNovo.Enabled := true;
    end
    else
    begin
    MessageDlg('Preencha os Campos', mtInformation, mbOKCancel, 0);
    end;
end;

procedure TFrmMembros.btnNovoClick(Sender: TObject);
begin
limparCampos;
habilitarCampos;
dm.tb_pessoas.Insert;
BtnSalvar.Enabled := true;
btnNovo.Enabled := false;
btnAdd.Enabled := true;
btnEditar.Enabled := false;
btnDeletar.Enabled := false;
grid.Enabled := false;
end;

procedure TFrmMembros.btnRelClick(Sender: TObject);
begin


dm.query_pessoas.Close;
dm.query_pessoas.SQL.Clear;
dm.query_pessoas.SQL.Add('select * from pessoas where id = :id');
dm.query_pessoas.ParamByName('id').Value := edtCodigo.Text;
dm.query_pessoas.Open;

dm.query_matriz.Close;
dm.query_matriz.SQL.Clear;
dm.query_matriz.SQL.Add('select * from matriz where nome = :matriz');
dm.query_matriz.ParamByName('matriz').Value := cbMatriz.Text;
dm.query_matriz.Open;

dm.query_filial.Close;
dm.query_filial.SQL.Clear;
dm.query_filial.SQL.Add('select * from filial where nome = :filial');
dm.query_filial.ParamByName('filial').Value := cbFilial.Text;
dm.query_filial.Open;


dm.rel_carteirinha.LoadFromFile(GetCurrentDir + '\rel\Carteirinha.fr3');
dm.rel_carteirinha.ShowReport();
btnRel.Enabled := false;
buscarTudo;
end;

procedure TFrmMembros.btnSalvarClick(Sender: TObject);
begin
if (edtNome.Text <> '') and (cbFilial.Text <> '') then
  begin
  associarCampos;
  salvarFoto;
  dm.tb_pessoas.Post;
  MessageDlg('Salvo com Sucesso!!', mtInformation, mbOKCancel, 0);
  buscarTudo;
  desabilitarCampos;
  btnSalvar.Enabled := false;
  btnNovo.Enabled := true;
  btnEditar.Enabled := false;
  btnDeletar.Enabled := false;
  btnRel.Enabled := false;
  grid.Enabled := true;
  end
  else
  begin
  MessageDlg('Preencha os Campos', mtInformation, mbOKCancel, 0);
  end;
end;

procedure TFrmMembros.buscarNome;
begin
dm.query_pessoas.Close;
dm.query_pessoas.SQL.Clear;
dm.query_pessoas.SQL.Add('select * from pessoas where nome LIKE :nome and filial = :igreja order by nome asc');
dm.query_pessoas.ParamByName('nome').Value := edtBuscar.Text + '%';
dm.query_pessoas.ParamByName('igreja').Value :=  cbIgreja.Text;
dm.query_pessoas.Open;
end;

procedure TFrmMembros.buscarTudo;
begin
dm.query_pessoas.Close;
dm.query_pessoas.SQL.Clear;
dm.query_pessoas.SQL.Add('select * from pessoas where filial = :igreja order by nome asc');
dm.query_pessoas.ParamByName('igreja').Value :=  cbIgreja.Text;
dm.query_pessoas.Open;
end;

procedure TFrmMembros.carregarComboboxFilial;
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

procedure TFrmMembros.carregarComboboxFuncoes;
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

procedure TFrmMembros.carregarComboboxIgrejas;
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

procedure TFrmMembros.carregarComboboxMatriz;
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

procedure TFrmMembros.carregarImagemPadrao;
begin
    caminhoImg  := GetCurrentDir + '\img\sem-foto.jpg';
    img.Picture.LoadFromFile(caminhoImg);
end;

procedure TFrmMembros.cbFuncaoChange(Sender: TObject);
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

end; }

if cbFuncao.Text = 'Pastor Presidente' then
begin
  if (funcaoPessoa <> 'Pastor Presidente') and (funcaoPessoa <> 'Administrador') then
  begin
    MessageDlg('Voc� n�o tem permiss�o para inserir um registro de Pastor Presidente!!', mtInformation, mbOKCancel, 0);
    cbFuncao.ItemIndex := 0;
  end;


end;


end;

procedure TFrmMembros.cbIgrejaChange(Sender: TObject);
begin
buscarTudo();
end;

procedure TFrmMembros.desabilitarCampos;
begin
limparcampos();
edtNome.Enabled := false;
edtEndereco.Enabled := false  ;
edtTel.Enabled := false  ;
cbFuncao.Enabled := false ;
cbMatriz.Enabled := false ;
cbFilial.Enabled := false    ;
end;

procedure TFrmMembros.edtBuscarChange(Sender: TObject);
begin
buscarNome;
end;



procedure TFrmMembros.FormShow(Sender: TObject);
begin

if (funcaoPessoa = 'Pastor Presidente') or (funcaoPessoa = 'Administrador') then
begin
dm.tb_filial.Active := false;
dm.tb_filial.Active := true;

carregarComboboxIgrejas();
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



dm.tb_filial.Active := false;
dm.tb_filial.Active := true;

dm.tb_matriz.Active := false;
dm.tb_matriz.Active := true;

dm.tb_funcoes.Active := false;
dm.tb_funcoes.Active := true;

dm.tb_pessoas.Active := false;
dm.tb_pessoas.Active := true;

buscarTudo;
carregarComboboxFilial;
carregarComboboxMatriz;
carregarComboboxFuncoes;

btnSalvar.Enabled := false;
btnEditar.Enabled := false;
btnDeletar.Enabled := false;
btnRel.Enabled := false;
carregarImagemPadrao();
end;



procedure ExibeFoto(DataSet : TDataSet; BlobFieldName : String; ImageExibicao :
TImage);

 var MemoryStream:TMemoryStream; jpg : TPicture;
 const
  OffsetMemoryStream : Int64 = 0;

begin
  if not(DataSet.IsEmpty) and
  not((DataSet.FieldByName(BlobFieldName) as TBlobField).IsNull) then
    try
      MemoryStream := TMemoryStream.Create;
      Jpg := TPicture.Create;
      (DataSet.FieldByName(BlobFieldName) as
TBlobField).SaveToStream(MemoryStream);
      MemoryStream.Position := OffsetMemoryStream;
      Jpg.LoadFromStream(MemoryStream);
      ImageExibicao.Picture.Assign(Jpg);
    finally
     // Jpg.Free;
      MemoryStream.Free;
    end
  else
    ImageExibicao.Picture := Nil;
end;



procedure TFrmMembros.gridCellClick(Column: TColumn);
begin
dm.tb_pessoas.Edit;
btnEditar.Enabled := true;
btnDeletar.Enabled := true;
btnRel.Enabled := true;
btnAdd.Enabled := true;
habilitarCampos;

if dm.query_pessoas.FieldByName('nome').Value <> null then
edtNome.Text := dm.query_pessoas.FieldByName('nome').Value;

 if dm.query_pessoas.FieldByName('endereco').Value <> null then
edtEndereco.Text := dm.query_pessoas.FieldByName('endereco').Value;

if dm.query_pessoas.FieldByName('telefone').Value <> null then
edtTel.Text := dm.query_pessoas.FieldByName('telefone').Value;

if dm.query_pessoas.FieldByName('funcao').Value <> null then
cbfuncao.Text := dm.query_pessoas.FieldByName('funcao').Value;


if dm.query_pessoas.FieldByName('matriz').Value <> null then
cbmatriz.Text := dm.query_pessoas.FieldByName('matriz').Value;

if dm.query_pessoas.FieldByName('filial').Value <> null then
cbfilial.Text := dm.query_pessoas.FieldByName('filial').Value;

if dm.query_pessoas.FieldByName('id').Value <> null then
edtCodigo.Text := dm.query_pessoas.FieldByName('id').Value;

 if dm.query_pessoas.FieldByName('imagem').Value <> null then
 ExibeFoto(dm.query_pessoas, 'imagem', img);

end;





procedure TFrmMembros.habilitarCampos;
begin
limparcampos();
edtNome.Enabled := true;
EdtEndereco.Enabled := true  ;
edtTel.Enabled := true  ;
cbFuncao.Enabled := true ;
cbMatriz.Enabled := true ;
cbFilial.Enabled := true    ;
end;

procedure TFrmMembros.limparCampos;
begin
edtNome.text := '';
EdtEndereco.text := '';
edtTel.text := '';
cbMatriz.ItemIndex := 0;
cbFilial.ItemIndex := 0;
cbFuncao.ItemIndex := 0;
carregarImagemPadrao();
end;

procedure TFrmMembros.salvarFoto;
begin
 if dialog.FileName <> '' then
  begin
  imgPessoa := TPicture.Create;
  imgPessoa.LoadFromFile(dialog.FileName);
  dm.tb_pessoas.FieldByName('imagem').Assign(imgPessoa);
  imgPessoa.Free;
  dialog.FileName := GetCurrentDir + '\img\sem-foto.jpg';
  alterou := false;
  end
  else
    begin
  dm.tb_pessoas.FieldByName('imagem').Value := GetCurrentDir + '\img\sem-foto.jpg';

  end;
end;

end.
