unit UAnimatedPaintBox;

interface

uses
  SysUtils, Windows, Classes, Controls, ExtCtrls, Graphics, SyncObjs,
  UCardinalList;

type

  TAdjustType=(ajFieldResize, ajBitmapResize ,ajNone);
  TShrinkType=(stHighQuality,stHighSpeed);

  //ImageList�����ɗ������A�d���Ȃ������Bitmap�ێ���p���X�g
  TBitmapList = class(TObject)
  protected
    FList:TList;
    FShareImage: Boolean;
    function GetCount: Integer;
    function GetBitmap(Index: Integer): TBitmap;
    function GetHeight: Integer;
    function GetWidth: Integer;
    procedure SetBitmap(Index: Integer; const Value: TBitmap);
  public
    constructor Create;
    destructor Destroy;override;
    function Add(Item:TBitmap):Integer;
    property Bitmap[Index:Integer]:TBitmap read GetBitmap write SetBitmap;default;
    procedure Clear; virtual;
    procedure Delete(Index: Integer);
    procedure Exchange(Index1, Index2: Integer);
    function IndexOf(Item: TBitmap): Integer;
    procedure Insert(Index: Integer; Item: TBitmap);
    procedure Move(CurIndex, NewIndex: Integer);
    property Count: Integer read GetCount;
    property Width:Integer read GetWidth;
    property Height:Integer read GetHeight;
    property ShareImage:Boolean read FShareImage write FShareImage;
  end;

  //�A�j���[�V�����ƃr�b�g�}�b�v�ێ����\��TPaintBox�h���I�u�W�F�N�g
  //HALFTONE���[�h�Ŋg��k�����\
  TAnimatedPaintBox = class(TPaintBox)
  protected
    FBitmap:TBitmap;
    FBitmapCache:TBitmap;
    FAdjust:TAdjustType;
    FShrinkType:TShrinkType;
    FBorder:Integer;
    FCenter:Boolean;

    FOriginalWidth:Integer;
    FOriginalHeight:Integer;

    FImageLeft:Integer;
    FImageTop:Integer;
    FImageWidth:Integer;
    FImageHeight:Integer;

    //��������A�j���[�V�����֌W
    Sync:TCriticalSection;
    FImageList:TBitmapList;
    FImageListCache:TBitmapList;
    FDelayTimeList:TCardinalList;
    FOwnBitmap:Boolean;
    FPaintThread:TThread;    //�{����TTread�ł͂Ȃ�TPaintThread
    FLoopLimit: Cardinal;
    FNotPaintedYet:Boolean;
    FWantToBegin:Boolean;


    function CalcImageBound:Boolean;
    procedure SetAdjust(Value: TAdjustType);
    function GetBitmap:TBitmap;
    procedure SetBitmap(const Value: TBitmap);
    procedure SetShrinkType(const Value: TShrinkType);
    procedure SetBorder(const Value: Integer);
    procedure SetCenter(const Value: Boolean);
    function GetScale:Integer;
    procedure Paint;override;
    procedure Resize;override;
    //��������A�j���[�V�����֌W
    procedure SetLoopLimit(const Value: Cardinal);

  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    //��������A�j���[�V�����֌W
    procedure BeginAnimation;
    procedure EndAnimation;
    procedure SuspendAnimation;
    procedure ResumeAnimation;
    procedure SetImageList(const AImageList: TBitmapList; ADelayTimeList: TCardinalList);

  published
    property OnResize;
    property Bitmap:TBitmap read GetBitmap write SetBitmap;
    property Adjust:TAdjustType read FAdjust write SetAdjust;
    property ShrinkType:TShrinkType read FShrinkType write SetShrinkType;
    property Border:Integer read FBorder write SetBorder;
    property Center:Boolean read FCenter write SetCenter;
    property Scale:Integer read GetScale;
    //��������A�j���[�V�����֌W
    property LoopLimit:Cardinal read FLoopLimit write SetLoopLimit;
  end;

  //Animation���݂̗�O
  EAnimatedPaintBox=Class(Exception);

implementation

//�A�j���[�V�����`��p�̃X���b�h�͉B��
type
  TPaintThread = class(TThread)
  protected
    Event:TEvent;
    FRequestSuspend:Boolean;

    FAnimatedPaintBox:TAnimatedPaintBox;
    FLoopLimit:Cardinal;
    FCurrentFrame:Integer;
    procedure Execute;override;
    procedure SetCurrentFrame(const Value: Integer);
  public
    constructor Create(AAnimatedPaintBox:TAnimatedPaintBox);
    destructor Destroy;override;
    procedure RequestSuspend;
    procedure Terminate;
    property CurrentFrame:Integer read FCurrentFrame write SetCurrentFrame;
  end;

{ TBitmapList }

constructor TBitmapList.Create;
begin
  FList:=TList.Create;
  FShareImage:=True;
end;

destructor TBitmapList.Destroy;
begin
  if not ShareImage then Clear;
  FList.Free;
  inherited;
end;

function TBitmapList.Add(Item: TBitmap): Integer;
begin
  if (Item=nil) or (Count=0) or ((Item.Height=Height) and (Item.width=Width)) then
    Result:=FList.Add(Item)
  else
    raise EAnimatedPaintBox.Create('�r�b�g�}�b�v�̃T�C�Y���قȂ�܂�');
end;

procedure TBitmapList.Clear;
var
  i:Integer;
begin
  if not ShareImage then
    for i:=0 to FList.Count-1 do TBitmap(FList[i]).Free;
  FList.Clear;
end;

procedure TBitmapList.Delete(Index: Integer);
begin
  if not ShareImage then TBitmap(FList[Index]).Free;
  FList.Delete(Index);
end;

procedure TBitmapList.Exchange(Index1, Index2: Integer);
begin
  FList.Exchange(Index1,Index2);
end;

function TBitmapList.GetBitmap(Index: Integer): TBitmap;
begin
  Result:=TBitmap(FList[Index]);
end;

function TBitmapList.GetCount: Integer;
begin
  Result:=FList.Count;
end;

function TBitmapList.GetHeight: Integer;
var
  i:Integer;
begin
  Result:=0;
  for i:=0 to Count-1 do begin
    if Assigned(GetBitmap(i)) then Result:=GetBitmap(0).Height;
    Break;
  end;
end;

function TBitmapList.GetWidth: Integer;
var
  i:Integer;
begin
  Result:=0;
  for i:=0 to Count-1 do begin
    if Assigned(GetBitmap(i)) then Result:=GetBitmap(0).Width;
    Break;
  end;
end;

function TBitmapList.IndexOf(Item: TBitmap): Integer;
begin
  Result:=FList.IndexOf(Item);
end;

procedure TBitmapList.Insert(Index: Integer; Item: TBitmap);
begin
  FList.Insert(Index,Item);
end;

procedure TBitmapList.Move(CurIndex, NewIndex: Integer);
begin
  FList.Move(CurIndex, NewIndex);
end;

procedure TBitmapList.SetBitmap(Index: Integer; const Value: TBitmap);
begin
  if not ShareImage then TBitmap(FList[Index]).Free;
  FList[Index]:=Value;
end;


{ TAnimatedPaintBox }


//����
constructor TAnimatedPaintBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FNotPaintedYet:=True;
  FWantToBegin:=False;
  FAdjust:=ajBitmapResize;
  FShrinkType:=stHighQuality;
  FBorder:=2;
  FCenter:=True;
  FOwnBitmap:=False;
  Sync:=TCriticalSection.Create;

end;

//�j��
destructor TAnimatedPaintBox.Destroy;
begin

  if Assigned(FPaintThread) then begin
    EndAnimation;
    FPaintThread.Free;
  end;
  Sync.Free;

  FBitmapCache.Free;
  FImageListCache.Free;
  if FOwnBitmap then FBitmap.Free;

  inherited;
end;

//�v���p�e�B�֌W

//�k���i��
procedure TAnimatedPaintBox.SetShrinkType(const Value: TShrinkType);
begin
  FShrinkType := Value;
  Paint;
end;
//�摜�ƃy�C���g�{�b�N�X�̐��@����
procedure TAnimatedPaintBox.SetAdjust(Value: TAdjustType);
begin
  FAdjust:=Value;
  if (Align=alNone) and (FAdjust=ajFieldResize) then begin
    if Assigned(FBitmap) then
      SetBounds(Left,Top,FBitmap.Width,FBitmap.Height)
    else if Assigned(FImageList) then
      SetBounds(Left,Top,FImageList.Width,FImageList.Height);
  end;

  if Assigned(Parent) then
    Parent.Update
  else
    raise EAnimatedPaintBox.Create('�e�R���g���[�����ݒ肳��Ă��܂���');

end;
//���͂̋�(�܂Ƃ��ɓ����̂�ajBitmapResize�̎�����)
procedure TAnimatedPaintBox.SetBorder(const Value: Integer);
begin
  FBorder:=Value;
  if Assigned(Parent) then
    Parent.Update
  else
    raise EAnimatedPaintBox.Create('�e�R���g���[�����ݒ肳��Ă��܂���');
end;
//�摜�𒆐S��
procedure TAnimatedPaintBox.SetCenter(const Value: Boolean);
begin
  FCenter:=Value;
  if Assigned(Parent) then
    Parent.Update
  else
    raise EAnimatedPaintBox.Create('�e�R���g���[�����ݒ肳��Ă��܂���');
end;
//���[�v�񐔂��Z�b�g
procedure TAnimatedPaintBox.SetLoopLimit(const Value: Cardinal);
begin
  Sync.Enter;
  FLoopLimit := Value;
  Sync.Leave;
end;
//���݂̏k��
function TAnimatedPaintBox.GetScale:Integer;
begin
  Result:=100;
  if CalcImageBound then
    Result:=FImageWidth *100 div FOriginalWidth;
end;
//�r�b�g�}�b�v�̕Ԓl�A�ێ����̃r�b�g�}�b�v�������ō�������Ȃ�nil��Ԃ�
function TAnimatedPaintBox.GetBitmap: TBitmap;
begin
  if FOwnBitmap then
    Result:=nil
  else
    Result:=FBitmap;
end;


//�r�b�g�}�b�v�̑���@�A�j���[�V���������鎞�͎Q�Ƃ�����
procedure TAnimatedPaintBox.SetBitmap(const Value: TBitmap);
begin

  if FOwnBitmap then begin
    FBitmap.Free;
    FOwnBitmap:=False;
  end;

  FBitmap := Value;

  if Assigned(FImageList) then FImagelist:=nil;
  if Assigned(FDelayTimeList) then FDelayTimeList:=nil;

  FreeAndNil(FBitmapCache);
  FreeAndNil(FImageListCache);

  if Assigned(FBitmap) and (Align=alNone) and (FAdjust=ajFieldResize) then
    SetBounds(Left,Top,FBitmap.Width,FBitmap.Height);

  if Assigned(FBitMapCache) then FreeAndNil(FBitMapCache);
  if Assigned(Parent) then Parent.Refresh;

end;


//�A�j���[�V�����̑��
//FPaintThread�̓��쒆�Ɏ��s���Ă��t���[���̓��Z�b�g����Ȃ��B
//�K�v�Ȃ�EndAnimation��BeginAnimation�̃y�A�����s����
//�r�b�g�}�b�v�����鎞�͏����B�������A�A�j���[�V�������摜�ꖇ�̏ꍇ�͂�����r�b�g�}�b�v�ɑ��
procedure TAnimatedPaintBox.SetImageList(const AImageList: TBitmapList; ADelayTimeList: TCardinalList);
begin

  if AImageList.Count<1 then EAnimatedPaintBox.Create('�摜������܂���');
  if AImageList.Count<>ADelayTimeList.Count then Raise EAnimatedPaintBox.Create('�摜�ƒx�����Ԃ̐����Ⴂ�܂�');

  if Assigned(FBitmap) then begin
    if FOwnBitmap then begin
      FBitmap.Free;
      FOwnBitmap:=False;
    end;
    FBitmap:=nil;
  end;

  FreeAndNil(FBitmapCache);
  FreeAndNil(FImageListCache);

  SuspendAnimation;
  FImageList := AImageList;
  FDelayTimeList:=ADelayTimeList;
  if FImageList.Count=1 then begin
    FBitmap:=TBitmap.Create;
    FBitmap.Assign(FImageList[0]);
    FOwnBitmap:=True;
    FLoopLimit:=1;
  end;

  if Assigned(FImageList) and (Align=alNone) and (FAdjust=ajFieldResize) then
    SetBounds(Left,Top,FImageList.Width,FImageList.Height);

  if Assigned(Parent) then Parent.Refresh;

  ResumeAnimation;
end;


//Bitmap�̕\���ʒu�A�T�C�Y�ݒ�
function TAnimatedPaintBox.CalcImageBound:Boolean;
var
  MaxWidth, MaxHeight:Integer;
begin

  Result:=False;

  if Assigned(FBitmap) and (FBitmap.Height>0) and (FBitmap.Width>0) then begin
    FOriginalWidth:=FBitmap.Width;
    FOriginalHeight:=FBitMap.Height;
  end else if Assigned(FImageList) and (FImageList.Height>0) and (FImageList.Width>0) then begin
    FOriginalWidth:=FImageList.Width;
    FOriginalHeight:=FImageList.Height;
  end else begin
    Exit;
  end;

  FImageWidth:=FOriginalWidth;
  FImageHeight:=FOriginalHeight;

  if FAdjust=ajBitMapResize then begin
    MaxWidth:= Width-FBorder*2;
    if MaxWidth<0 then MaxWidth:=0;
    MaxHeight:=Height-FBorder*2;
    if MaxHeight<0 then MaxHeight:=0;
    if (MaxHeight<FOriginalHeight) or (MaxWidth<FOriginalWidth) then begin
      if (FOriginalHeight * MaxWidth) > (FOriginalWidth*MaxHeight) then begin
        FImageWidth:=(MaxHeight*FOriginalWidth) div FOriginalHeight;
        FImageHeight:=MaxHeight;
      end else begin
        FImageWidth:=MaxWidth;
        FImageHeight:=(MaxWidth*FOriginalHeight) div FOriginalWidth;
      end;
    end;
  end;

  if Center then begin
    FImageLeft:=(Width - FImageWidth) div 2;
    FImageTop:=(Height - FImageHeight) div 2;
  end else begin
    FImageLeft:=Border;
    FImageTop:=Border;
  end;

  Result:=True;

end;


//�\����̃T�C�Y�ύX
procedure TAnimatedPaintBox.Resize;
begin
  CalcImageBound;
  inherited;
end;



//�`��y�яk���摜�̃L���b�V���쐬
procedure TAnimatedPaintBox.Paint;
var
  FrameBitmapCache:TBitmap;
  i:Integer;
  Locked:Boolean;
begin

  Locked:=False;
  if Assigned(FPaintThread) then begin
    Sync.Enter;
    Locked:=True;
  end;

  inherited Paint;

  if not CalcImageBound then begin  //�ʎQ�Ƃ���̃C���[�W���X�g�̒��ڕύX�ɑΉ����邽�ߕ\���O�͏�ɐ��@�`�F�b�N
    if Locked then Sync.Leave;
    Exit;
  end;

  if (FImageWidth=FOriginalWidth) and (FImageHeight=FOriginalHeight) then begin //�I���W�i���g�p

    if Assigned(FBitmap) then begin //�ʏ�̃r�b�g�}�b�v�̏ꍇ
      Canvas.CopyRect(Bounds(FImageLeft,FImageTop,FImageWidth,FImageHeight),FBitmap.Canvas,Rect(0,0,FImageWidth,FImageHeight));
      if Assigned(FBitmapCache) then FreeAndNil(FBitmapCache);
    end else if Assigned(FImageList) then begin //�A�j���[�V�����̏ꍇ
      if Assigned(FPaintThread) then begin
        Canvas.Draw(FImageLeft,FImageTop,FImageList[TPaintThread(FPaintThread).CurrentFrame]);
      end else begin
        Canvas.Draw(FImageLeft,FImageTop,FImageList[0]);
      end;
      if Assigned(FImageListCache) then FreeAndNil(FImageListCache);
    end else begin
      EAnimatedPaintBox.Create('�r�b�g�}�b�v�f�[�^�Ȃ�');
    end;

  end else begin    //�L���b�V�����g�p

    if Assigned(FBitmap) then begin //�ʏ�̃r�b�g�}�b�v�̏ꍇ

      if not(Assigned(FBitmapCache)) or (FImageHeight<>FBitmapCache.Height)
                     or (FImageWidth<>FBitmapCache.Width) then begin  //�L���b�V�����g���Ȃ���΍č\�z
        if Assigned(FBitmapCache) then FreeAndNil(FBitmapCache);
        FBitmapCache:=TBitmap.Create;
        FBitmapCache.Width:=FImageWidth;
        FBitmapCache.Height:=FImageHeight;
        if FShrinkType=stHighQuality then begin
          SetStretchBltMode(FBitmapCache.Canvas.Handle,HALFTONE);
          SetBrushOrgEx(FBitmapCache.Canvas.Handle, 0, 0, nil);
        end else begin
          SetStretchBltMode(FBitmapCache.Canvas.Handle,COLORONCOLOR)
        end;
        FBitmapCache.Canvas.CopyRect(Rect(0,0,FImageWidth,FImageHeight),FBitmap.Canvas,Rect(0,0,FBitmap.Width,FBitmap.Height));
      end;
      Canvas.CopyRect(Bounds(FImageLeft,FImageTop,FImageWidth,FImageHeight),FBitmapCache.Canvas,Rect(0,0,FImageWidth,FImageHeight));
    end else if Assigned(FImageList) then begin //�A�j���[�V�����̏ꍇ

      if not(Assigned(FImageListCache)) or (FImageHeight<>FImageListCache.Height)
                    or (FImageWidth<>FImageListCache.Width) then begin //�L���b�V�����g���Ȃ���΍č\�z

        if assigned(FImageListCache) then begin
          FImageListCache.Clear;
        end else begin
          FImageListCache:=TBitmapList.Create;
          FImageListCache.ShareImage:=False;
        end;

        for i:=0 to FImageList.Count-1 do begin

          FrameBitmapCache:=TBitmap.Create;
          FrameBitmapCache.HandleType:=bmDIB;
          FrameBitmapCache.PixelFormat:=pf24bit;
          FrameBitmapCache.Width:=FImageWidth;
          FrameBitmapCache.Height:=FImageHeight;

          if FShrinkType=stHighQuality then begin
            SetStretchBltMode(FrameBitmapCache.Canvas.Handle,HALFTONE);
            SetBrushOrgEx(FrameBitmapCache.Canvas.Handle, 0, 0, nil);
          end else begin
            SetStretchBltMode(FrameBitmapCache.Canvas.Handle,COLORONCOLOR);
          end;
          FrameBitmapCache.Canvas.CopyRect(Rect(0,0,FImageWidth,FImageHeight),FImageList[i].Canvas,Rect(0,0,FImageList.Width,FImageList.Height));
          FImageListCache.Add(FrameBitmapCache);

        end;
      end;

      if Assigned(FPaintThread) then begin
        Canvas.Draw(FImageLeft,FImageTop,FImageListCache[TPaintThread(FPaintThread).CurrentFrame]);
      end else begin
        Canvas.Draw(FImageLeft,FImageTop,FImageListCache[0]);
      end;

    end else begin
      EAnimatedPaintBox.Create('�r�b�g�}�b�v�f�[�^�Ȃ�');
    end;

  end;

  if Locked then Sync.Leave;

  FNotPaintedYet:=False;
  if FWantToBegin then begin
    BeginAnimation;
    FWantToBegin:=False;
  end;

end;


//�A�j���[�V�����̍Đ����J�n
procedure TAnimatedPaintBox.BeginAnimation;
begin

  if FNotPaintedYet then begin
    FWantToBegin:=True;
  end else begin
    if Assigned(FImageList) and Assigned(FDelayTimeList) and (FImageList.Count>1) then begin
      if Assigned(FPaintThread) then FPaintThread.Free;
      FPaintThread:=TPaintThread.Create(Self);
    end;
  end;
end;

//�A�j���[�V�����̍Đ����I���A�X���b�h��j��
procedure TAnimatedPaintBox.EndAnimation;
begin
  FWantToBegin:=False;
  if Assigned(FPaintThread) then begin
    TPaintThread(FPaintThread).Terminate;
    FPaintThread.WaitFor;
  end;
end;

//�A�j���[�V�������ꎞ��~
procedure TAnimatedPaintBox.SuspendAnimation;
begin
  if Assigned(FPaintThread) then
    TPaintThread(FPaintThread).RequestSuspend;
end;

//�A�j���[�V�������ĊJ
procedure TAnimatedPaintBox.ResumeAnimation;
begin
  if Assigned(FPaintThread) then
    FPaintThread.Resume;
end;





{ TPaintThread }

//������ƃf�[�^�����邩�`�F�b�N
constructor TPaintThread.Create(AAnimatedPaintBox:TAnimatedPaintBox);
begin

  if not Assigned(AAnimatedPaintBox) then
    raise EAnimatedPaintBox.Create('�A�j���[�V�����y�C���g�{�b�N�X���w�肳��Ă��܂���')
  else if not Assigned(AAnimatedPaintBox.FImageList) then
    raise EAnimatedPaintBox.Create('�C���[�W���X�g���ݒ肳��Ă��܂���')
  else if not Assigned(AAnimatedPaintBox.FDelayTimeList) then
    raise EAnimatedPaintBox.Create('�x�����ԃ��X�g���ݒ肳��Ă��܂���');

  FreeOnTerminate:=False;
  Event:=TEvent.Create(nil,False,False,'');

  FAnimatedPaintBox:=AAnimatedPaintBox;
  CurrentFrame:=0;

  inherited Create(False);
end;

destructor TPaintThread.Destroy;
begin
  Event.Free;
  inherited Destroy;
end;


//�����������[�v�̖{��
procedure TPaintThread.Execute;
var
  WantIncrement:Boolean;
  SysTime1,SysTime2:Cardinal;
  DifferencialTime:Cardinal;
  LoopCount:Cardinal;
begin

  WantIncrement:=False;
  LoopCount:=0;
  DifferencialTime:=1;

  while not Terminated do begin
    SysTime1:=GetTickCount;
    FAnimatedPaintBox.Sync.Enter;  //�������烍�b�N
    try
      if WantIncrement then Inc(FCurrentFrame);
      if FCurrentFrame>=FAnimatedPaintBox.FImageList.Count then begin
        if FAnimatedPaintBox.FLoopLimit>0 then begin
          Inc(LoopCount);
          if LoopCount>=FAnimatedPaintBox.FLoopLimit then begin
            Terminate;
            Break;
          end;
        end;
        FCurrentFrame:=0;
      end;

      try
        FAnimatedPaintBox.Canvas.Lock;
        if Assigned(FAnimatedPaintBox.FImageListCache) then begin
          if Assigned(FAnimatedPaintBox.FImageListCache[FCurrentFrame]) then begin
            try
              FAnimatedPaintBox.FImageListCache[FCurrentFrame].Canvas.Lock;
              FAnimatedPaintBox.Canvas.Draw(FAnimatedPaintBox.FImageLeft,FAnimatedPaintBox.FImageTop,FAnimatedPaintBox.FImageListCache[FCurrentFrame]);
            finally
              FAnimatedPaintBox.FImageListCache[FCurrentFrame].Canvas.Unlock;
            end;
          end;
        end else begin
          if Assigned(FAnimatedPaintBox.FImageList[FCurrentFrame]) then begin
            try
              FAnimatedPaintBox.FImageList[FCurrentFrame].Canvas.Lock;
              FAnimatedPaintBox.Canvas.Draw(FAnimatedPaintBox.FImageLeft,FAnimatedPaintBox.FImageTop,FAnimatedPaintBox.FImageList[FCurrentFrame]);
            finally
              FAnimatedPaintBox.FImageList[FCurrentFrame].Canvas.Unlock;
            end;
          end;
        end;
      finally
        FAnimatedPaintBox.Canvas.Unlock;
      end;
      SysTime2:=GetTickCount;
      if SysTime2>=SysTime1 then
        DifferencialTime:=SysTime2-SysTime1
      else
        DifferencialTime:=Cardinal(Int64(SysTime2)+High(Cardinal)+1-Int64(SysTime1));

      if FAnimatedPaintBox.FDelayTimeList[FCurrentFrame]*10>DifferencialTime then
        DifferencialTime:=FAnimatedPaintBox.FDelayTimeList[FCurrentFrame]*10-DifferencialTime
      else
        DifferencialTime:=1;
    finally
      FAnimatedPaintBox.Sync.Leave;  //�����܂Ń��b�N
    end;

    if not(Terminated) and (Event.WaitFor(DifferencialTime)=wrTimeout) then
      WantIncrement:=True
    else
      WantIncrement:=False;

    if not(Terminated) and FRequestSuspend then begin
      FRequestSuspend:=False;
      Suspend;
      Event.ResetEvent;
    end;
  end;

  FCurrentFrame:=0;

end;

//�ꎞ��~�̃��N�G�X�g
procedure TPaintThread.RequestSuspend;
begin
  FRequestSuspend:=True;
  Event.SetEvent;
end;

//�t���[���ԍ����O������ݒ�
procedure TPaintThread.SetCurrentFrame(const Value: Integer);
begin
  if Value>=FAnimatedPaintBox.FImageList.Count then raise EAnimatedPaintBox.Create('�s���ȃt���[�����ł�');
  FCurrentFrame:=Value;
  Event.SetEvent;
end;

//Terminate�̓C�x���g���N�����đ����I��������
procedure TPaintThread.Terminate;
begin
  inherited Terminate;
  if Suspended then
    Resume;
  Event.SetEvent;
end;


end.
