unit Movimentacoes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids;

type
  TFrmMovimentacoes = class(TForm)
    grid: TDBGrid;
    Image1: TImage;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure buscarData();
  public
    { Public declarations }
  end;

var
  FrmMovimentacoes: TFrmMovimentacoes;

implementation

{$R *.dfm}

uses Modulo;

{ TFrmMovimentacoes }

procedure TFrmMovimentacoes.buscarData;
begin
dm.query_movimentacoes.Close;
dm.query_movimentacoes.SQL.Clear;
dm.query_movimentacoes.SQL.Add('select * from movimentacoes where data = curDate() order by data desc');

dm.query_movimentacoes.Open;


end;

procedure TFrmMovimentacoes.FormShow(Sender: TObject);
begin
buscarData;
end;

end.
