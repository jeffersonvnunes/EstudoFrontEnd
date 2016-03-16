unit UsuarioDomain;

interface

uses MVCFramework, MVCFramework.Commons, System.SysUtils, System.Classes;

type

  [MVCPath('/')]
  TUsuarioDomain = class(TMVCController)
  public
    [MVCHTTPMethod([httpGET])]
    [MVCPath('/usuario')]
    procedure ListaUsuarios(CTX:TWebContext);

    [MVCHTTPMethod([httpGET])]
    [MVCPath('/usuario/($cdUsuario)')]
    procedure GetUsuario(CTX:TWebContext);

    [MVCHTTPMethod([httpPOST])]
    [MVCPath('/usuario/($cdUsuario)')]
    procedure GravaUsuario(CTX:TWebContext);

    [MVCHTTPMethod([httpPUT])]
    [MVCPath('/usuario/($cdUsuario)')]
    procedure AlteraUsuario(CTX:TWebContext);

    [MVCHTTPMethod([httpDELETE])]
    [MVCPath('/usuario/($cdUsuario)')]
    procedure ExcluiUsuario(CTX:TWebContext);

    [MVCHTTPMethod([httpOPTIONS])]
    [MVCPath('/usuario/($cdUsuario)')]
    procedure OptionsUsuario(CTX: TWebContext);


  end;

implementation

uses HttpStatus, System.StrUtils, Vcl.Forms, SuperObject, ServiceExceptions;


{ TUsuarioDomain }

procedure TUsuarioDomain.AlteraUsuario(CTX: TWebContext);
var
  vJson: TStringList;
  vArq:String;
begin
  CTX.Response.SetCustomHeader('Access-Control-Allow-Origin','*');
  vArq := 'Usuario_'+CTX.Request.Params['cdUsuario']+'.json';
  vJson := TStringList.Create;

  try
    try
      if FileExists(ExtractFileDir(Application.ExeName)+'/json/'+vArq)then
      begin
        vJson.LoadFromFile(ExtractFileDir(Application.ExeName)+'/json/'+vArq, TEncoding.UTF8);
        vJson.Text := UTF8ToString(CTX.Request.RawWebRequest.Content);
        vJson.SaveToFile(ExtractFileDir(Application.ExeName)+'/json/'+vArq);
        CTX.Response.StatusCode := THttpStatus.HttpSuccess;
      end
      else
      begin
        CTX.Response.SetCustomHeader('Access-Control-Allow-Origin','*');
        CTX.Response.StatusCode             := THttpStatus.HttpBadRequest;
        CTX.Response.RawWebResponse.Content := TServiceException.CreateException('Dados não encontrados').AddDetail('error'
          ,'Não foi possível encontrar Usuario para '+CTX.Request.Params['cdUsuario']+'.').AsJSON;
      end;
    except
      on e: Exception do
      begin
        CTX.Response.StatusCode             := THttpStatus.HttpServerError;
        CTX.Response.RawWebResponse.Content := TServiceException.CreateException('Dados não encontrados').AddDetail('error'
          ,'Não foi possível listar os usuários.').AsJSON;
      end;
    end;

  finally
    vJson.DisposeOf;
  end;
end;

procedure TUsuarioDomain.ExcluiUsuario(CTX: TWebContext);
var
  vJson: TStringList;
  vArq:String;
begin
  CTX.Response.SetCustomHeader('Access-Control-Allow-Origin','*');
  CTX.Response.StatusCode := THttpStatus.HttpSuccess;
  vArq := 'Usuario_'+CTX.Request.Params['cdUsuario']+'.json';

  try
    if FileExists(ExtractFileDir(Application.ExeName)+'/json/'+vArq)then
    begin
      DeleteFile(ExtractFileDir(Application.ExeName)+'/json/'+vArq);
    end;
  except
  on e: Exception do
      begin

        CTX.Response.StatusCode             := THttpStatus.HttpServerError;
        CTX.Response.RawWebResponse.Content := TServiceException.CreateException('Dados não encontrados').AddDetail('error'
          ,'Não foi possível excluir o usuário.').AsJSON;
      end;

  end;

end;

procedure TUsuarioDomain.GetUsuario(CTX: TWebContext);
var
  vJson: TStringList;
  vArq:String;
begin
  CTX.Response.SetCustomHeader('Access-Control-Allow-Origin','*');
  vArq := 'Usuario_'+CTX.Request.Params['cdUsuario']+'.json';
  vJson := TStringList.Create;

  try
    if FileExists(ExtractFileDir(Application.ExeName)+'/json/'+vArq)then
    begin
      vJson.LoadFromFile(ExtractFileDir(Application.ExeName)+'/json/'+vArq, TEncoding.UTF8);

      CTX.Response.StatusCode             := THttpStatus.HttpSuccess;
      CTX.Response.RawWebResponse.Content := vJson.Text;
    end
    else
    begin
      CTX.Response.SetCustomHeader('Access-Control-Allow-Origin','*');
      CTX.Response.StatusCode             := THttpStatus.HttpBadRequest;
      CTX.Response.RawWebResponse.Content := TServiceException.CreateException('Dados não encontrados').AddDetail('error'
        ,'Não foi possível encontrar Usuario para '+CTX.Request.Params['cdUsuario']+'.').AsJSON;
    end;
  finally
    vJson.DisposeOf;
  end;
end;

procedure TUsuarioDomain.GravaUsuario(CTX: TWebContext);
var
  vJson: TStringList;
  vArq:String;
begin
  CTX.Response.SetCustomHeader('Access-Control-Allow-Origin','*');
  vArq := 'Usuario_'+CTX.Request.Params['cdUsuario']+'.json';
  vJson := TStringList.Create;

  try
    try
      if not DirectoryExists(ExtractFileDir(Application.ExeName)+'/json/') then
        CreateDir(ExtractFileDir(Application.ExeName)+'/json/');

      vJson.Text := UTF8ToString(CTX.Request.RawWebRequest.Content);
      vJson.SaveToFile(ExtractFileDir(Application.ExeName)+'/json/'+vArq);

      CTX.Response.StatusCode := THttpStatus.HttpSuccess;
      CTX.Response.RawWebResponse.Content := vJson.Text;
    except
      on e: Exception do
      begin

        CTX.Response.StatusCode             := THttpStatus.HttpServerError;
        CTX.Response.RawWebResponse.Content := TServiceException.CreateException('Dados não encontrados').AddDetail('error'
          ,'Não foi possível listar os usuários.').AsJSON;
      end;
    end;

  finally
    vJson.DisposeOf;
  end;
end;

procedure TUsuarioDomain.ListaUsuarios(CTX: TWebContext);
var
  vSr: TSearchRec;
  vJson: TStringList;
  vCaminho: String;
  vJsonRetorno: String;
begin
  CTX.Response.SetCustomHeader('Access-Control-Allow-Origin','*');
  CTX.Response.ContentType := 'application/json; charset=UTF-8';
  CTX.Response.StatusCode := THttpStatus.HttpSuccess;
  vJson := TStringList.Create;
  vCaminho := ExtractFileDir(Application.ExeName)+'/json/';

  vJsonRetorno := '';

  try
    try
      if FindFirst(vCaminho+'*.*',faAnyFile,vSr) = 0 then
      begin
        repeat
          if (vSr.Name <> '.') and (vSr.Name <> '..') then
          begin
            vJson.LoadFromFile(vCaminho + vSr.Name, TEncoding.UTF8);

            if vJsonRetorno = '' then
            begin
              vJsonRetorno := vJson.Text;
            end
            else
            begin
              vJsonRetorno := vJsonRetorno + ','+ vJson.Text;
            end;
          end;
        until FindNext(vSr) <> 0;
      end;

      CTX.Response.RawWebResponse.Content := '"usuarios":['+vJsonRetorno+']';
    except
      on e: Exception do
      begin
        CTX.Response.SetCustomHeader('Access-Control-Allow-Origin','*');
        CTX.Response.StatusCode             := THttpStatus.HttpServerError;
        CTX.Response.RawWebResponse.Content := TServiceException.CreateException('Dados não encontrados').AddDetail('error'
          ,'Não foi possível encontrar Usuario para '+CTX.Request.Params['cdUsuario']+'.').AsJSON;
      end;
    end;
  finally
    vJson.DisposeOf;
    FindClose(vSr);
  end;
end;

procedure TUsuarioDomain.OptionsUsuario(CTX: TWebContext);
begin
  CTX.Response.ContentType := 'application/json; charset=UTF-8';
  CTX.Response.SetCustomHeader('Access-Control-Allow-Origin','*');
  CTX.Response.SetCustomHeader('Access-Control-Allow-Methods','POST, PUT, GET');
  CTX.Response.SetCustomHeader('Access-Control-Max-Age','3600');
  CTX.Response.SetCustomHeader('Access-Control-Allow-Credentials','false');
  CTX.Response.SetCustomHeader('Access-Control-Allow-Headers','Content-Type, X-Session-Id');
end;

end.
