unit Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TFrmLogin = class(TForm)
    Image1: TImage;
    btnEntrar: TSpeedButton;
    edtUsuario: TEdit;
    edtSenha: TEdit;
    procedure btnEntrarClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    procedure limparCampos();
    procedure login();
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.dfm}

uses Principal, Modulo;

procedure TFrmLogin.btnEntrarClick(Sender: TObject);
begin
login;
end;

procedure TFrmLogin.FormActivate(Sender: TObject);
begin
limparCampos;
end;

procedure TFrmLogin.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 13 then
  login;
end;

procedure TFrmLogin.limparCampos;
begin
edtUsuario.Text := '';
edtSenha.Text := '';
edtUsuario.SetFocus;
end;

procedure TFrmLogin.login;
begin
if (Trim(edtUsuario.Text) <> '') and (Trim(edtSenha.Text) <> '') then
begin
  {VERIFICAR SE O USUÁRIO E A SENHA EXISTEM NO BANCO}
   dm.query_usuarios.SQL.Clear;
   dm.query_usuarios.SQL.Add('select * from usuarios where usuario = :usuario and senha = :senha');
   dm.query_usuarios.ParamByName('usuario').Value := edtUsuario.Text;
   dm.query_usuarios.ParamByName('senha').Value := edtSenha.Text ;
   dm.query_usuarios.Open;

   if not dm.query_usuarios.IsEmpty then
   begin

   nomeUsuario := edtUsuario.Text;
   nomePessoa :=  dm.query_usuarios['nome'];
   funcaoPessoa :=  dm.query_usuarios['funcao'];
   nomeIgreja :=  dm.query_usuarios['filial'];

   FrmPrincipal := TFrmPrincipal.Create(self);
   FrmPrincipal.Show;
   end
   else
   begin
   MessageDlg('Dados Incorretos!!', mtInformation, mbOKCancel, 0);
   edtUsuario.SetFocus;
   end;



end
else
begin
 MessageDlg('Preencha os Campos', mtInformation, mbOKCancel, 0);
end;

end;

end.
