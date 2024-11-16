unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.Menus, Vcl.StdCtrls, Vcl.Buttons, Vcl.Imaging.pngimage, Data.DB,
  Vcl.Grids, Vcl.DBGrids;

type
  TFrmPrincipal = class(TForm)
    Image1: TImage;
    MainMenu1: TMainMenu;
    Cadastros1: TMenuItem;
    Movimentaes1: TMenuItem;
    Relatrios1: TMenuItem;
    Sair1: TMenuItem;
    Usurios1: TMenuItem;
    FunoEclesistica1: TMenuItem;
    Matriz1: TMenuItem;
    Filiais1: TMenuItem;
    Entradas1: TMenuItem;
    Sadas1: TMenuItem;
    ConsultarMovimentaes1: TMenuItem;
    Logout1: TMenuItem;
    Movimentaes2: TMenuItem;
    MembrosFuno1: TMenuItem;
    Entradas2: TMenuItem;
    Sadas2: TMenuItem;
    MembrosFunes1: TMenuItem;
    Timer1: TTimer;
    PainelDireita: TPanel;
    lblUsuario: TLabel;
    lblFuncao: TLabel;
    lblIgreja: TLabel;
    lblHora: TLabel;
    Image2: TImage;
    Label1: TLabel;
    lblData: TLabel;
    Label2: TLabel;
    Image3: TImage;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Image4: TImage;
    Label7: TLabel;
    lblMembros: TLabel;
    Label9: TLabel;
    lblPastors: TLabel;
    Label11: TLabel;
    lblMissionarios: TLabel;
    Label13: TLabel;
    Image5: TImage;
    Label8: TLabel;
    lblEntradas: TLabel;
    Label10: TLabel;
    lblSaidas: TLabel;
    Label12: TLabel;
    lblSaldo: TLabel;
    btnPessoas: TSpeedButton;
    btnEntradas: TSpeedButton;
    btnSaidas: TSpeedButton;
    btnMovimentacoes: TSpeedButton;
    btnRelMov: TSpeedButton;
    Panel1: TPanel;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    grid: TDBGrid;
    Image10: TImage;
    Label14: TLabel;
    Label15: TLabel;
    Image11: TImage;
    grid2: TDBGrid;
    procedure Logout1Click(Sender: TObject);
    procedure Usurios1Click(Sender: TObject);
    procedure Matriz1Click(Sender: TObject);
    procedure Filiais1Click(Sender: TObject);
    procedure FunoEclesistica1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MembrosFuno1Click(Sender: TObject);
    procedure Entradas1Click(Sender: TObject);
    procedure ConsultarMovimentaes1Click(Sender: TObject);
    procedure Sadas1Click(Sender: TObject);
    procedure Entradas2Click(Sender: TObject);
    procedure Movimentaes2Click(Sender: TObject);
    procedure MembrosFunes1Click(Sender: TObject);
    procedure btnPessoasClick(Sender: TObject);
    procedure btnEntradasClick(Sender: TObject);
    procedure btnSaidasClick(Sender: TObject);
    procedure btnMovimentacoesClick(Sender: TObject);
    procedure btnRelMovClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }

    procedure totalMembros;
    procedure totalPastores;
    procedure totalMissionarios;

    procedure totalizarEntradas();
    procedure totalizarSaidas();
    procedure totalizar;

    procedure buscarMov;
    procedure buscarMembros;
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;
  totalEntradas : real;
  totalSaidas : real;

implementation

{$R *.dfm}

uses Login, Usuarios, Matriz, Filial, Funcoes, Modulo, Pessoas, Entradas,
  Movimentacoes, Saidas, RelEntradas, RelMovimentacoes, RelPessoas;


function ConverterRGB(r, g, b : Byte) : TColor;
begin
  Result := RGB(r, g, b);
end;


procedure TFrmPrincipal.btnEntradasClick(Sender: TObject);
begin
FrmEntradas := TFrmEntradas.Create(self);
FrmEntradas.Show;
end;

procedure TFrmPrincipal.btnMovimentacoesClick(Sender: TObject);
begin
FrmMovimentacoes := TFrmMovimentacoes.Create(self);
FrmMovimentacoes.Show;
end;

procedure TFrmPrincipal.btnPessoasClick(Sender: TObject);
begin
FrmMembros := TFrmMembros.Create(self);
FrmMembros.Show;
end;

procedure TFrmPrincipal.btnRelMovClick(Sender: TObject);
begin
FrmRelMov := TFrmRelMov.Create(self);
FrmRelMov.ShowModal;
end;

procedure TFrmPrincipal.btnSaidasClick(Sender: TObject);
begin
FrmSaidas := TFrmSaidas.Create(self);
FrmSaidas.Show;
end;

procedure TFrmPrincipal.buscarMembros;
begin
dm.query_pessoas.Close;
dm.query_pessoas.SQL.Clear;
dm.query_pessoas.SQL.Add('select * from pessoas where filial = :igreja order by id desc limit 5');
dm.query_pessoas.ParamByName('igreja').Value :=  nomeIgreja;
dm.query_pessoas.Open;
end;

procedure TFrmPrincipal.buscarMov;
begin
dm.query_movimentacoes.Close;
dm.query_movimentacoes.SQL.Clear;
dm.query_movimentacoes.SQL.Add('select * from movimentacoes where data = curDate() and igreja = :igreja');

dm.query_movimentacoes.ParamByName('igreja').Value :=  nomeIgreja;
TFloatField(dm.query_movimentacoes.FieldByName('valor')).DisplayFormat := 'R$ #,,,,0.00';
dm.query_movimentacoes.Open;
end;

procedure TFrmPrincipal.ConsultarMovimentaes1Click(Sender: TObject);
begin
FrmMovimentacoes := TFrmMovimentacoes.Create(self);
FrmMovimentacoes.Show;
end;

procedure TFrmPrincipal.Entradas1Click(Sender: TObject);
begin
FrmEntradas := TFrmEntradas.Create(self);
FrmEntradas.Show;
end;

procedure TFrmPrincipal.Entradas2Click(Sender: TObject);
begin
FrmRelEntradas := TFrmRelEntradas.Create(self);
FrmRelEntradas.ShowModal;
end;

procedure TFrmPrincipal.Filiais1Click(Sender: TObject);
begin
FrmFilial := TFrmFilial.Create(self);
FrmFilial.ShowModal;
end;

procedure TFrmPrincipal.FormActivate(Sender: TObject);
begin
totalPastores;
totalMembros;
totalMissionarios;

totalizarEntradas;
totalizarSaidas;
totalizar;

buscarMov;
buscarMembros;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin

lblEntradas.Font.Color := clGreen;

PainelDireita.Color := ConverterRGB(102,139,173);

lblUsuario.Caption := nomePessoa;
lblFuncao.Caption := funcaoPessoa;
lblIgreja.Caption := nomeIgreja;

lblData.Caption := DateTostr(Date);
lblHora.Caption := TimeTostr(Time);


if (funcaoPessoa = 'Administrador') or (funcaoPessoa = 'Pastor Presidente') then
begin
Usurios1.Enabled := true;
end;



end;

procedure TFrmPrincipal.FunoEclesistica1Click(Sender: TObject);
begin
 FrmFuncoes := TFrmFuncoes.Create(self);
FrmFuncoes.ShowModal;
end;

procedure TFrmPrincipal.Logout1Click(Sender: TObject);
begin
if FrmLogin = nil then
begin
FrmLogin := TFrmLogin.Create(self);
FrmLogin.ShowModal;
Close();
end
else
begin
FrmLogin.WindowState := wsNormal;
FrmLogin.BringToFront;
FrmLogin.Focused;
Close();
end;


end;

procedure TFrmPrincipal.Matriz1Click(Sender: TObject);
begin
FrmMatriz := TFrmMatriz.Create(self);
FrmMatriz.ShowModal;
end;

procedure TFrmPrincipal.MembrosFunes1Click(Sender: TObject);
begin
FrmRelPessoas := TFrmRelPessoas.Create(self);
FrmRelPessoas.ShowModal;
end;

procedure TFrmPrincipal.MembrosFuno1Click(Sender: TObject);
begin
FrmMembros := TFrmMembros.Create(self);
FrmMembros.Show;
end;

procedure TFrmPrincipal.Movimentaes2Click(Sender: TObject);
begin
FrmRelMov := TFrmRelMov.Create(self);
FrmRelMov.ShowModal;
end;

procedure TFrmPrincipal.Sadas1Click(Sender: TObject);
begin
FrmSaidas := TFrmSaidas.Create(self);
FrmSaidas.Show;
end;

procedure TFrmPrincipal.Timer1Timer(Sender: TObject);
begin
lblHora.Caption := TimeTostr(Time);
end;

procedure TFrmPrincipal.totalizar;
var
tot : real;
begin
tot := totalEntradas - totalSaidas;
if tot < 0 then
begin
lblSaldo.Font.Color := clRed;
end
else
begin
lblSaldo.Font.Color := clGreen;
end;
lblSaldo.Caption := FormatFloat('R$ #,,,,0.00', tot);

end;

procedure TFrmPrincipal.totalizarEntradas;

var
tot : real;
begin
dm.query_entradas.Close;
dm.query_entradas.SQL.Clear;
dm.query_entradas.SQL.Add('select sum(valor) as total from entradas where data = CurDate() and igreja = :igreja ') ;
dm.query_entradas.ParamByName('igreja').Value :=  nomeIgreja;
dm.query_entradas.Open;
tot := dm.query_entradas.FieldByName('total').AsFloat;
totalEntradas := tot;
lblEntradas.Caption := FormatFloat('R$ #,,,,0.00', tot);
end;

procedure TFrmPrincipal.totalizarSaidas;
var
tot : real;
begin
dm.query_saidas.Close;
dm.query_saidas.SQL.Clear;
dm.query_saidas.SQL.Add('select sum(valor) as total from saidas where data = CurDate() and igreja = :igreja ') ;
dm.query_saidas.ParamByName('igreja').Value :=  nomeIgreja;
dm.query_saidas.Open;
tot := dm.query_saidas.FieldByName('total').AsFloat;
totalSaidas := tot;
lblSaidas.Caption := FormatFloat('R$ #,,,,0.00', tot);

end;

procedure TFrmPrincipal.totalMembros;
begin
dm.query_pessoas.Close;
dm.query_pessoas.SQL.Clear;
dm.query_pessoas.SQL.Add('select * from pessoas where funcao = "Membro" and filial = :filial');
dm.query_pessoas.ParamByName('filial').Value := nomeIgreja;
dm.query_pessoas.Open;
lblMembros.Caption := inttostr(dm.query_pessoas.RecordCount);
end;

procedure TFrmPrincipal.totalMissionarios;
begin
dm.query_pessoas.Close;
dm.query_pessoas.SQL.Clear;
dm.query_pessoas.SQL.Add('select * from pessoas where funcao = "Missionário" and filial = :filial');
dm.query_pessoas.ParamByName('filial').Value := nomeIgreja;
dm.query_pessoas.Open;
lblMissionarios.Caption := inttostr(dm.query_pessoas.RecordCount);
end;

procedure TFrmPrincipal.totalPastores;
begin
dm.query_pessoas.Close;
dm.query_pessoas.SQL.Clear;
dm.query_pessoas.SQL.Add('select * from pessoas where funcao = "Pastor" and filial = :filial or funcao = "Pastor Presidente" and filial = :filial or funcao = "Pastor Dirigente" and filial = :filial');
dm.query_pessoas.ParamByName('filial').Value := nomeIgreja;
dm.query_pessoas.Open;
lblPastors.Caption := inttostr(dm.query_pessoas.RecordCount);
end;

procedure TFrmPrincipal.Usurios1Click(Sender: TObject);
begin
FrmUsuarios := TFrmUsuarios.Create(self);
FrmUsuarios.ShowModal;
end;

end.
