unit UGIF;

interface

uses
  SysUtils, Windows, Contnrs, Classes, Graphics, Controls, {SPIs, SPIBmp,} ExtCtrls, SyncObjs,
  UAnimatedPaintBox, UCardinalList, GifImage;

type

  //GIFブロックのタイプ
  TGifBlockType=(gifHeader,gifImageBlock,gifAppExt,gifGraphicCntlExt,gifTextExt,gifCommentExt,gifTrailer);

  //TGIFDataの展開進行通知用イベント型
  TGifDataProgress = procedure(Sender:TObject; Progress:Integer) of object;

  //GIFブロックの基本クラス
  TGifBlock=class(TPersistent)
  protected
    FBlockType:TGifBlockType;
    FData:string;
    FBlockLength:Integer;
    function FindTerminater(var AData:string; Position:Integer):Integer;
  public
    constructor Create(var AData:string; const ABlockStart:Integer);
    property BlockLength:Integer read FBlockLength;
    property BlockType:TGifBlocktype read FBlockType;
    property Data:string read FData;
  end;

  //各ブロックの要素にアクセスするための着ぐるみクラス×４
  TGifHeader=class(TGifBlock)
  private
    function GetLogicalScreenWidth: Word;
    function GetLogicalScreenHeight: Word;
    function GetColorTable(Index: Integer): TColor;
    procedure SetLogicalScreenWidth(const Value: Word);
    procedure SetLogicalScreenHeight(const Value: Word);
    procedure SetColorTable(Index: Integer; Value: TColor);
  public
    function ColorTableFlag:Boolean;
    function SizeOfColorTable:Integer;
    function BackgroundColorIndex:Integer;
    property LogicalScreenHeight:Word read GetLogicalScreenHeight write SetLogicalScreenHeight;
    property LogicalScreenWidth:Word read GetLogicalScreenWidth write SetLogicalScreenWidth;
    property ColorTable[Index: Integer]: TColor read GetColorTable write SetColorTable;
  end;
  //
  TGifImageBlock=class(TGifBlock)
  protected
  private
    function GetColorTable(Index:Integer):TColor;
    procedure SetColorTable(Index: Integer; Value: TColor);
  public
    procedure GotoOrigine;
    function Left:Integer;
    function Top:Integer;
    function Width:Integer;
    function Height:Integer;
    function ColorTableFlag:Boolean;
    function SizeOfColorTable:Integer;
    property ColorTable[Index: Integer]: TColor read GetColorTable write SetColorTable;
  end;
  //
  TGifGraphicControlExtention=class(TGifBlock)
  public
    function DisposalMothod:Integer;
    function Transparent:Boolean;
    function DelayTime:Cardinal;
    function TransparentColorIndex:Integer;
  end;
  //
  TGifAppExtention=class(TGifBlock)
  public
    function ApplicationIdentifier:string;
    function ApplicationAuthenticationCode:string;
    function NSExtLoopCount:Cardinal;
  end;

  //GifDataを非ブロックモードで展開するためのスレッド
  TGifThread=class(TThread)
  protected

    Sync:TCriticalSection;

    BlockList:TObjectList;
    ImageList:TBitmapList;
    DelayTimeList:TCardinalList;
    //SpiBMP:TSPIBitmap;
    GifImage: TGifImage;//TOleBITMAP;

    TransparentColor:Integer;
    Header:TGifHeader;
    ValidGrpCntlExt:TGifGraphicControlExtention;
    ImageBlock:TGifImageBlock;

    xFrameGifData:TObject;//本当はTGifData
    FrameImage,tmpFrameImage:TBitmap;
    PreviousFrameImage:TBitmap;

    tmpStream:TStringStream;

    OnProgress:TGifDataProgress;
    CurrentBlock:Integer;

    procedure Execute;override;
    procedure Progress;
  public
    constructor Create(var ABlockList:TObjectList; var AImageList:TBitmapList;
                       var ADelayTimeList:TCardinalList; AOnProgress:TGifDataProgress;
                       AOnTerminate:TNotifyEvent; ASync:TCriticalSection);
    destructor Destroy;override;
  end;


  //GIFデータ全体を管理するクラス
  TGifData=class(TObject)
  protected
    GifThread:TGifThread;
    Sync:TCriticalSection;//どうみてもTBitmapListにも装備すべき
    BlockList:TObjectList;
    FErrorText:string;

    FOnComplete:TNotifyEvent;
    FOnProgress:TGifDataProgress;

    procedure SetOnProgress(Const Value:TGifDataProgress);
    function GetData: string;
    procedure SetData(AData:string);
    function GetBlock(Index:Integer):TGifBlock;
    function GetImageBlockCount:Integer;
    function GetLoopCount:Cardinal;
    procedure ThreadProgress(Sender:TObject; Progress:Integer);
    procedure ThreadTerminated(Sender:TObject);
  public
    constructor Create;
    destructor Destroy;override;
    function Count:Integer;
    function DataLength:Integer;
    procedure MakeImageList(var AImageList:TBitmapList; var ADelayTimeList:TCardinalList);overload;
    procedure MakeImageList(var AImageList:TBitmapList; var ADelayTimeList:TCardinalList; AOnComplete:TNotifyEvent);overload;
    function Add(ABlock:TGifBlock):Integer;
    function AddBlockData(AData:string):TGifBlock;
    property Data:string read GetData write SetData;
    property Block[i:Integer]:TGifBlock read GetBlock; Default;
    property ImageBlockCount:Integer read GetImageBlockCount;
    property LoopCount:Cardinal read GetLoopCount;
    property OnProgress:TGifDataProgress read FOnProgress write SetOnProgress;
    property ErrorText:string read FErrorText;
  end;

  //GIF絡みの例外
  EGifAnalysis=class(Exception);

implementation

const
  Gif87aSignature='GIF87a';
  Gif89aSignature='GIF89a';



{ TGifBlock }

//生成＋与えられたデータから自分の長さと形式を判定する
constructor TGifBlock.Create(var AData:string; const ABlockStart:Integer);
begin

  if Length(AData)<ABlockStart then
    raise EGifAnalysis.Create('ブロックの長さが不正です');

  if (AnsiStrLComp(pchar(@AData[ABlockStart]),pchar(Gif89aSignature),Length(Gif89aSignature))=0)
  or (AnsiStrLComp(pchar(@AData[ABlockStart]),pchar(Gif87aSignature),Length(Gif87aSignature))=0) then begin
    FBlockType:=gifHeader;
    if (ord(AData[11]) and $80)=0 then
      FBlockLength:=13
    else
      FBlockLength:=13+3*(2 shl (ord(AData[11]) and 7));
  end else if AData[ABlockStart]=#$2C then begin  //画像データ領域

    FBlockType:=gifImageBlock;
    if (ord(AData[ABlockStart+9]) and $80)=0 then
      FBlockLength:=FindTerminater(AData,ABlockStart+11)-ABlockStart+1
    else
      FBlockLength:=FindTerminater(AData,ABlockStart+11+3*(2 shl (ord(AData[ABlockStart+9]) mod 8)))-ABlockStart+1;
  end else if AData[ABlockStart]=#$21 then begin //拡張領域

    case AData[ABlockStart+1] of
      #$ff:FBlockType:=gifAppExt;        //アプリケーション拡張
      #$f9:FBlockType:=gifGraphicCntlExt;//グラフィック制御拡張
      #$fe:FBlockType:=gifCommentExt;    //コメント拡張
      #$01:FBlockType:=gifCommentExt;    //テキスト拡張
    end;

    FBlockLength:=FindTerminater(AData, ABlockStart+2)-ABlockStart+1;

  end else if AData[ABlockStart]=#$3b then begin //トレイラー(末端)

    FBlockType:=gifTrailer;
    FBlockLength:=1;

  end else begin

    raise EGifAnalysis.Create('データの内容が不正です');

  end;

  FData:=Copy(AData,ABlockStart,FBlockLength);
  UniqueString(FData);

end;

//拡張領域のターミネータ($00)を探すサブ関数
function TGifBlock.FindTerminater(var AData:string; Position:Integer):Integer;
begin
  while AData[Position]<>#0 do begin
    Inc(Position,ord(AData[Position])+1);
    if Position>Length(AData) then
      raise EGifAnalysis.Create('ブロックの長さが不正です');
  end;

  Result:=Position;

end;




{ TGifHeader }

function TGifHeader.GetLogicalScreenHeight: Word;
begin
  Result:=ord(FData[9])+(ord(FData[10]) shl 8);
end;

function TGifHeader.GetLogicalScreenWidth: Word;
begin
  Result:=ord(FData[7])+(ord(FData[8]) shl 8);
end;

function TGifHeader.BackgroundColorIndex: Integer;
begin
  if not ColorTableFlag then
    raise EGifAnalysis.Create('グローバルカラーテーブルがありません')
  else
    Result:=ord(FData[12]);
end;

procedure TGifHeader.SetLogicalScreenHeight(const Value: Word);
begin
  FData[ 9]:=char(Value and $ff);
  FData[10]:=char(Value shr 8);
end;

procedure TGifHeader.SetLogicalScreenWidth(const Value: Word);
begin
  FData[ 7]:=char(Value and $ff);
  FData[ 8]:=char(Value shr 8);
end;

function TGifHeader.ColorTableFlag:Boolean;
begin
  Result:=((ord(FData[11]) and 128)=128);
end;

function TGifHeader.SizeOfColorTable:Integer;
begin
  if not ColorTableFlag then
    raise EGifAnalysis.Create('グローバルカラーテーブルがありません')
  else
    Result:=2 shl (ord(FData[11]) and 7);
end;


function TGifHeader.GetColorTable(Index:Integer):TColor;
var
  Pos:Integer;
begin
  if Index>SizeOfColorTable then
    raise EGifAnalysis.Create('範囲外のカラーインデックスです');

  Pos:=14+Index*3;
  Result:=ord(FData[Pos])+ord(FData[Pos+1])*$100+ord(FData[Pos+2])*$10000;
end;

procedure TGifHeader.SetColorTable(Index: Integer; Value: TColor);
var
  Pos:Integer;
begin
  if Index > SizeOfColorTable then
    raise EGifAnalysis.Create('範囲外のカラーインデックスです');
  UniqueString(FData);
  Pos := 14 + Index * 3;
  FData[Pos] := Char(Value and $ff);
  FData[Pos + 1] := Char((Value div $100) and $ff);
  FData[Pos + 2] := Char((Value div $10000) and $ff);
end;



{ TGifImageBlock }

procedure TGifImageBlock.GotoOrigine;
begin
  FData[2]:=#0;
  FData[3]:=#0;
  FData[4]:=#0;
  FData[5]:=#0;
end;

function TGifImageBlock.Left: Integer;
begin
  Result:=ord(FData[2])+(ord(FData[3]) shl 8);
end;

function TGifImageBlock.Top: Integer;
begin
  Result:=ord(FData[4])+(ord(FData[5]) shl 8);
end;

function TGifImageBlock.Width: Integer;
begin
  Result:=ord(FData[6])+(ord(FData[7]) shl 8);
end;

function TGifImageBlock.Height: Integer;
begin
  Result:=ord(FData[8])+(ord(FData[9]) shl 8);
end;

function TGifImageBlock.ColorTableFlag:Boolean;
begin
  Result:=((ord(FData[10]) and 128)=128);
end;

function TGifImageBlock.SizeOfColorTable:Integer;
begin
  if not ColorTableFlag then
    raise EGifAnalysis.Create('ローカルカラーテーブルがありません')
  else
    Result:=2 shl (ord(FData[10]) and 7);
end;


function TGifImageBlock.GetColorTable(Index:Integer):TColor;
var
  Pos:Integer;
begin
  if Index > SizeOfColorTable then
    raise EGifAnalysis.Create('範囲外のカラーインデックスです');
  Pos := 11 + Index * 3;
  Result := ord(FData[Pos]) + ord(FData[Pos + 1]) * $100 + ord(FData[Pos + 2]) * $10000;
end;

procedure TGifImageBlock.SetColorTable(Index: Integer; Value: TColor);
var
  Pos:Integer;
begin
  if Index > SizeOfColorTable then
    raise EGifAnalysis.Create('範囲外のカラーインデックスです');
  UniqueString(FData);
  Pos := 11 + Index * 3;
  FData[Pos] := Char(Value and $ff);
  FData[Pos + 1] := Char((Value div $100) and $ff);
  FData[Pos + 2] := Char((Value div $10000) and $ff);
end;



{ TGifGraphicControlExtention }

function TGifGraphicControlExtention.DelayTime: Cardinal;
begin
  Result:=ord(FData[5])+(ord(FData[6]) shl 8);
end;

function TGifGraphicControlExtention.DisposalMothod: Integer;
begin
  Result:=(ord(FData[4]) shr 2) and 7;
end;

function TGifGraphicControlExtention.Transparent: Boolean;
begin
  Result:=((ord(FData[4]) and 1)=1);
end;

function TGifGraphicControlExtention.TransparentColorIndex: Integer;
begin
  if not Transparent then Raise EGifAnalysis.Create('透過が設定されたグラフィック拡張ブロックではありません');
  Result:=ord(FData[7]);
end;




{ TGifAppExtention }

//アプリケーション拡張のアプリ識別子(アニメGIFではNETSCAPE)
function TGifAppExtention.ApplicationIdentifier:string;
begin
  Result:=Copy(FData,4,8);
end;

//アプリケーション拡張のバージョン識別子(アニメGIFでは2.0)
function TGifAppExtention.ApplicationAuthenticationCode:string;
begin
  Result:=Copy(FData,12,3);
end;

//アニメーションGIFのループ回数
function TGifAppExtention.NSExtLoopCount:Cardinal;
var
  Position:Integer;
begin
  Result:=0;
  Position:=15;
  while FData[Position]<>#0 do begin
    if FData[Position]+FData[Position+1]=#3#1 then begin
      Result:=MakeWord(Ord(FData[Position+2]),Ord(FData[Position+3]));
      Break;
    end;
    inc(Position,Ord(FData[Position]));
    if Position>Length(FData) then Break; //エラーにしない
  end;
end;




{ TGifData }

constructor TGifData.Create;
begin
  inherited;
  Sync:=TCriticalSection.Create;
  BlockList:=TObjectList.Create;
  BlockList.OwnsObjects:=True;
end;

destructor TGifData.Destroy;
begin

  if Assigned(GifThread) then begin
    GifThread.Suspend;
    GifThread.FreeOnTerminate:=False;
    GifThread.OnTerminate:=nil;
    GifThread.Terminate;
    GifThread.Resume;
    GifThread.WaitFor;
    GifThread.Free;
  end;

  BlockList.Free;
  Sync.Free;
  inherited;
end;

//ブロックの追加
function TGifData.Add(ABlock: TGifBlock):Integer;
begin
  Result:=BlockList.Add(ABlock);
end;

//生データによるブロックの追加(ブロックを複製して追加する)
function TGifData.AddBlockData(AData:String):TGifBlock;
var
  NewBlock:TGifBlock;
begin
  NewBlock:=TGifBlock.Create(AData,1);
  Add(NewBlock);
  Result:=NewBlock;
end;

//プロパティ参照関係

//ブロックへの直接アクセス
function TGifData.GetBlock(Index: Integer): TGifBlock;
begin
  Sync.Enter;
  Result:=TGifBlock(BlockList[Index]);
  Sync.Leave;
end;

//データ全体のサイズ
function TGifData.DataLength: Integer;
var
  i:Integer;
begin
  Result:=1; //Trailerの分を最初に足しておく
  for i:=0 to BlockList.Count-1 do Inc(Result,TGifBlock(BlockList[i]).BlockLength);
end;

//データ全体を返す
function TGifData.GetData: string;
var
  i:Integer;
  pResult:PChar;
begin

  Sync.Enter;

  SetLength(Result,Self.DataLength);
  pResult:=pchar(Result);
  for i:=0 to BlockList.Count-1 do begin
    system.Move(pchar(TGifBlock(BlockList[i]).Data)^,pResult^,TGifBlock(BlockList[i]).BlockLength);
    Inc(pResult,TGifBlock(BlockList[i]).BlockLength);
  end;
  Result[DataLength]:=#$3b;//末端はTrailer

  Sync.Leave;

end;

//イメージの数を返す
function TGifData.GetImageBlockCount:Integer;
var
  i:Integer;
begin
  Result:=0;
  for i:=0 to BlockList.Count-1 do if Self[i].BlockType=gifImageBlock then Inc(Result);
end;

//再生回数を返す
function TGifData.GetLoopCount:Cardinal;
begin
  Result:=1;
  if (BlockList.Count>2) and (Self[1].BlockType=gifAppExt) then
    with TGifAppExtention(Self[1]) do
      if (ApplicationIdentifier='NETSCAPE') and (ApplicationAuthenticationCode='2.0') then Result:=NSExtLoopCount;
end;


//GIFファイルデータをブロックに分解してリストに貯める
procedure TGifData.SetData(AData:string);
var
  CurrentPos:Integer;
  GifBlock:TGifBlock;
begin

  Sync.Enter;

  BlockList.Clear;
  CurrentPos:=1;
  repeat
    GifBlock:=TGifBlock.Create(AData, CurrentPos);
    if GifBlock.FBlockType<>gifTrailer then
      BlockList.Add(GifBlock);
    Inc(CurrentPos,GifBlock.FBlockLength);
  until GifBlock.FBlockType=gifTrailer;
  GifBlock.Free;

  Sync.Leave;

end;

function TGifData.Count: Integer;
begin
  Result:=BlockList.Count;
end;

//進行イベントの通知
procedure TGifData.SetOnProgress(Const Value:TGifDataProgress);
begin
  FOnProgress:=Value;
end;

//GifImageプラグインを使ってイメージリストに展開
//ブロッキングモード
procedure TGifData.MakeImageList(var AImageList:TBitmapList; var ADelayTimeList:TCardinalList);
begin
  FOnComplete:=nil;
  FErrorText:='';
  GifThread:=TGifThread.Create(BlockList,AImageList,ADelayTimeList,ThreadProgress,nil,Sync);
  GifThread.WaitFor;
  if Assigned(GifThread.FatalException) then begin
    FErrorText:=Exception(GifThread.FatalException).Message;
    raise Exception(GifThread.FatalException);
  end;
  GifThread.Free;

end;

//非ブロッキングモード
//
procedure TGifData.MakeImageList(var AImageList:TBitmapList; var ADelayTimeList:TCardinalList;
                                 AOnComplete:TNotifyEvent);
begin
  FOnComplete:=AOnComplete;
  FErrorText:='';
  GifThread:=TGifThread.Create(BlockList,AImageList,ADelayTimeList,ThreadProgress,ThreadTerminated,Sync);

end;


//非ブロッキングモードのデコード終了イベント
procedure TGifData.ThreadTerminated(Sender:TObject);
begin
  if Assigned(GifThread.FatalException) then
    raise Exception(GifThread.FatalException);
  GifThread:=nil;
  if Assigned(FOnComplete) then FOnComplete(Self);
  //自殺コード(FOnComplete中で自分が解放される)なので、この先は何も書けない
end;


//進行イベント
procedure TGifData.ThreadProgress(Sender:TObject; Progress:Integer);
begin
  if Assigned(FOnProgress) then FOnProgress(Self,Progress);
end;




{ TGifThread }

//生成
constructor TGifThread.Create(var ABlockList:TObjectList; var AImageList:TBitmapList;
                              var ADelayTimeList:TCardinalList; AOnProgress:TGifDataProgress;
                              AOnTerminate:TNotifyEvent ; ASync:TCriticalSection);
begin

  ImageList:=AImageList;
  DelayTimeList:=ADelayTimeList;
  BlockList:=ABlockList;
  OnProgress:=AOnProgress;
  OnTerminate:=AOnTerminate;
  Sync:=ASync;

  if Assigned(OnTerminate) then
    FreeOnTerminate:=True
  else
    FreeOnTerminate:=False;

  ImageList.Clear;
  DelayTimeList.Clear;

  ValidGrpCntlExt:=nil;
  Header:=TGifHeader(BlockList[0]);
  TransparentColor:=$0;

  //SpiBMP:=TSPIBitmap.Create;
  GifImage := TGifImage.Create;
  GifImage.Animate := False;
  FrameImage:=TBitmap.Create;
  PreviousFrameImage:=TBitmap.Create;

  FrameImage.HandleType:=bmDIB;
  FrameImage.PixelFormat:=pf24bit;
  FrameImage.Height:=Header.LogicalScreenHeight;
  FrameImage.Width:=Header.LogicalScreenWidth;

  inherited Create(False);

end;


//破棄
destructor TGifThread.Destroy;
begin
  tmpStream.Free;
  PreviousFrameImage.Free;
  FrameImage.Free;
  //SpiBMP.Free;
  GifImage.Free;
end;


//{Susieプラグイン}GifImageを使ってイメージリストに展開
procedure TGifThread.Execute;
var
  i, j: Integer;
  FrameGifData:TGifData;
  Transparent:Boolean;
  NotUnqTransCol: Boolean;
  ColorUsed: array [0..255] of Boolean;
begin

  ReturnValue:=-1;

  Sync.Enter;

  FrameGifData:=TGifData(xFrameGifData);

  for i:=1 to BlockList.Count-1 do begin
    if Terminated then Break;
    CurrentBlock:=i;
    case TGifBlock(BlockList[i]).BlockType of
      gifGraphicCntlExt:begin
        ValidGrpCntlExt:=TGifGraphicControlExtention(BlockList[i]);
      end;
      gifImageBlock:begin
        ImageBlock:=TGifImageBlock(BlockList[i]);
        Transparent:=False;
        if Assigned(ValidGrpCntlExt) and ValidGrpCntlExt.Transparent then begin
          Transparent:=True;
          try
            if ImageBlock.ColorTableFlag then begin
              TransparentColor := ImageBlock.ColorTable[ValidGrpCntlExt.TransparentColorIndex];
              NotUnqTransCol := False;
              FillChar(ColorUsed, Length(ColorUsed) * Sizeof(Boolean), Byte(False));
              for j := 0 to ImageBlock.SizeOfColorTable - 1 do
                if (j <> ValidGrpCntlExt.TransparentColorIndex) then begin
                  ColorUsed[ImageBlock.ColorTable[j] and 255] := True;
                  if ImageBlock.ColorTable[j] = TransparentColor then
                    NotUnqTransCol := True;
                end;
              if NotUnqTransCol then
                for j := 0 to Sizeof(ColorUsed) do
                  if not ColorUsed[j] then begin
                    TransparentColor := j + j * $100 + j * $10000;
                    Break;
                  end;
            end else begin
              TransparentColor:=Header.ColorTable[ValidGrpCntlExt.TransparentColorIndex];
              NotUnqTransCol := False;
              FillChar(ColorUsed, Length(ColorUsed) * Sizeof(Boolean), Byte(False));
              for j := 0 to Header.SizeOfColorTable - 1 do
                if (j <> ValidGrpCntlExt.TransparentColorIndex) then begin
                  ColorUsed[Header.ColorTable[j] and 255] := True;
                  if Header.ColorTable[j] = TransparentColor then
                    NotUnqTransCol := True;
                end;
              if NotUnqTransCol then
                for j := 0 to Sizeof(ColorUsed) do
                  if not ColorUsed[j] then begin
                    TransparentColor := j + j * $100 + j * $10000;
                    Break;
                  end;
            end;
          except
            Transparent:=False;
          end;
        end;
        FrameGifData:=TGifData.Create;
        with TGifHeader(FrameGifData.AddBlockData(Header.Data)) do begin
          LogicalScreenHeight:=ImageBlock.Height;
          LogicalScreenWidth:=ImageBlock.Width;
          if Transparent and not ImageBlock.ColorTableFlag then
            ColorTable[ValidGrpCntlExt.TransparentColorIndex] := TransparentColor;
        end;
        if Assigned(ValidGrpCntlExt) then
          FrameGifData.AddBlockData(ValidGrpCntlExt.Data);
        with TGifImageBlock(FrameGifData.AddBlockData(ImageBlock.Data)) do begin
          GotoOrigine;
          if Transparent and ImageBlock.ColorTableFlag then
            ColorTable[ValidGrpCntlExt.TransparentColorIndex] := TransparentColor;
        end;
        tmpStream:=TStringStream.Create(FrameGifData.Data);
        //SpiBMP.LoadFromStream(tmpStream);
        GifImage.LoadFromStream(tmpStream);
        FreeAndNil(tmpStream);
        {if Transparent then begin
          SpiBMP.Transparent:=True;
          SpiBMP.TransparentMode:=tmFixed;
          SpiBMP.TransparentColor:=TransparentColor;
        end else begin
          SpiBMP.Transparent:=False;
        end;}
        //SpiBMP.PixelFormat:=pf24bit;

        if Assigned(ValidGrpCntlExt) and (ValidGrpCntlExt.DisposalMothod=3) then PreviousFrameImage.Assign(FrameImage);
        FrameImage.Canvas.Lock;
        //SpiBMP.Canvas.Lock;
        try
          //FrameImage.Canvas.Draw(ImageBlock.Left,ImageBlock.Top,SpiBMP);
          FrameImage.Canvas.Draw(ImageBlock.Left,ImageBlock.Top,GifImage);
        finally
          //SpiBMP.Canvas.Unlock;
          FrameImage.Canvas.Unlock;
        end;
        tmpFrameImage:=TBitmap.Create;
        tmpFrameImage.Assign(FrameImage);
        ImageList.Add(tmpFrameImage);
        if Assigned(ValidGrpCntlExt) then begin
          DelayTimeList.Add(ValidGrpCntlExt.DelayTime);
          case ValidGrpCntlExt.DisposalMothod of
            2:with FrameImage.Canvas do begin
              Lock;
              try
                Brush.Color:=TransparentColor;
                Brush.Bitmap:=nil;
                Brush.Style:=bsSolid;
                FillRect(Bounds(ImageBlock.Left,ImageBlock.Top,ImageBlock.Width,ImageBlock.Height));
              finally
                Unlock;
              end;
            end;
            3:FrameImage.Assign(PreviousFrameImage);
          end;
        end else begin
          DelayTimeList.Add(0);
        end;
        FreeAndNil(FrameGifData);
        if Assigned(OnProgress) then Synchronize(Progress);
      end;
    end;
  end;

  Sync.Leave;

end;


//進行イベント
procedure TGifThread.Progress;
begin
  if Assigned(OnProgress) then OnProgress(Self,CurrentBlock);
end;

end.
