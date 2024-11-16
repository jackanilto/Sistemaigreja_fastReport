unit RelPessoas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls;

type
  TFrmRelPessoas = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    lblIgreja: TLabel;
    btnRel: TSpeedButton;
    cbIgreja: TComboBox;
    cbFuncao: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure btnRelClick(Sender: TObject);
  private
    { Private declarations }
     procedure carregarComboboxIgreja();
      procedure carregarComboboxFuncoes();
  public
    { Public declarations }
  end;

var
  FrmRelPessoas: TFrmRelPessoas;

implementation

{$R *.dfm}

uses Modulo;

{ TFrmRelPessoas }

procedure TFrmRelPessoas.btnRelClick(Sender: TObject);
begin
dm.query_filial.Close;
dm.query_filial.SQL.Clear;
dm.query_filial.SQL.Add('select * from filial where nome = :filial');
dm.query_filial.ParamByName('filial').Value := cbIgreja.Text;
dm.query_filial.Open;

dm.query_pessoas.Close;
dm.query_pessoas.SQL.Clear;
dm.query_pessoas.SQL.Add('select * from pessoas where funcao = :funcao and filial = :filial order by nome asc');
dm.query_pessoas.ParamByName('funcao').Value := cbFuncao.Text;
dm.query_pessoas.ParamByName('filial').Value := cbIgreja.Text;
dm.query_pessoas.Open;


dm.rel_entradas.LoadFromFile(GetCurrentDir + '\rel\Pessoas.fr3');
dm.rel_entradas.ShowReport();

end;

procedure TFrmRelPessoas.carregarComboboxFuncoes;
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

procedure TFrmRelPessoas.carregarComboboxIgreja;
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

procedure TFrmRelPessoas.FormShow(Sender: TObject);
begin
dm.tb_funcoes.Active := false;
dm.tb_funcoes.Active := true;
carregarComboboxFuncoes;
cbFuncao.ItemIndex := 0;

if (funcaoPessoa = 'Pastor Presidente') or (funcaoPessoa = 'Administrador') then
begin
dm.tb_filial.Active := false;
dm.tb_filial.Active := true;

carregarComboboxIgreja();
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
end;

end.
