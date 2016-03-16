part of hetima_mbaas_backendless;

class BackendlessUser {
  static final String REGIST_NAME = "name";
  static final String REGIST_PASSWORD = "password";
  static final String REGIST_EMAIL = "email";

  TinyNetBuilder builder;
  String applicationId;
  String secretKey;
  BackendlessUser(this.builder, this.applicationId, this.secretKey) {}

  Future<LoginResult> login(String login, String password, {String version: "v1"}) async {
    TinyNetRequester requester = await this.builder.createRequester();
    TinyNetRequesterResponse resonse = await requester.request(
        TinyNetRequester.TYPE_POST, //
        "https://api.backendless.com/${version}/users/login", //
        headers: {
          "application-id": applicationId, //
          "secret-key": secretKey, //
          "application-type": "REST", //
          "Content-Type": "application/json" //
        }, //
        data: """{"login" : "${login}", "password" : "${password}"}""" //
        );
    return new LoginResult.fromResponse(resonse);
  }

  Future<RegistResult> regist(Map<String, Object> properties, {String version: "v1"}) async {
    TinyNetRequester requester = await this.builder.createRequester();
    TinyNetRequesterResponse resonse = await requester.request(
        TinyNetRequester.TYPE_POST, //
        "https://api.backendless.com/${version}/users/register", //
        headers: {
          "application-id": applicationId, //
          "secret-key": secretKey, //
          "application-type": "REST", //
          "Content-Type": "application/json" //
        }, //
        data: JSON.encode(properties) //
        );
    return new RegistResult.fromResponse(resonse);
  }

  Future<LogoutResult> logout(String userToken, {String version: "v1"}) async {
    TinyNetRequester requester = await this.builder.createRequester();
    TinyNetRequesterResponse resonse = await requester.request(
        TinyNetRequester.TYPE_GET, //
        "https://api.backendless.com/${version}/users/logout", //
        headers: {
      "application-id": applicationId, //
      "secret-key": secretKey, //
      "application-type": "REST", //
      "user-token": "${userToken}" //
    } //
        );
    return new LogoutResult.fromResponse(resonse);
  }

  Future<GetUserPropertyResult> getUserProperty(String objectId, List<String> props, {String version: "v1"}) async {
    StringBuffer propsBuffer = new StringBuffer("props=");
    for (int i = 0; i < props.length; i++) {
      if (i != 0) {
        propsBuffer.write(",");
      }
      propsBuffer.write(props[i]);
    }

    TinyNetRequester requester = await this.builder.createRequester();
    TinyNetRequesterResponse resonse = await requester.request(
        TinyNetRequester.TYPE_GET, //
        "https://api.backendless.com/${version}/users/${objectId}?${propsBuffer.toString()}", //
        headers: {
      "application-id": applicationId, //
      "secret-key": secretKey, //
      "application-type": "REST"
    });
    return new GetUserPropertyResult.fromResponse(resonse);
  }

  Future<UpdateUserPropertyResult> updateUserProperty(String objectId, String userToken, Map<String, Object> props, {String version: "v1"}) async {
    TinyNetRequester requester = await this.builder.createRequester();
    TinyNetRequesterResponse resonse = await requester.request(
        TinyNetRequester.TYPE_PUT, //
        "https://api.backendless.com/${version}/users/${objectId}", //
        headers: {
          "application-id": applicationId, //
          "secret-key": secretKey, //
          "Content-Type": "application/json", //
          "application-type": "REST", //
          "user-token": userToken
        },
        data: JSON.encode(props));
    return new UpdateUserPropertyResult.fromResponse(resonse);
  }

  Future<ResetPasswordResult> resetPassword(String userName, {String version: "v1"}) async {
    TinyNetRequester requester = await this.builder.createRequester();
    TinyNetRequesterResponse resonse = await requester.request(
        TinyNetRequester.TYPE_GET, //
        "https://api.backendless.com/${version}/users/restorepassword/${userName}", //
        headers: {
      "application-id": applicationId, //
      "secret-key": secretKey, //
      "application-type": "REST" //
    } //
        );
    return new ResetPasswordResult.fromResponse(resonse);
  }
}

class ResetPasswordResult  extends BackendlessResultBase {
  ResetPasswordResult.fromResponse(TinyNetRequesterResponse r) : super.fromResponse(r) {
  }
}

class UpdateUserPropertyResult extends BackendlessResultBase {
  UpdateUserPropertyResult.fromResponse(TinyNetRequesterResponse r) : super.fromResponse(r) {
  }
}

class GetUserPropertyResult extends BackendlessResultBase {
  GetUserPropertyResult.fromResponse(TinyNetRequesterResponse r) : super.fromResponse(r) {
  }
}

class LogoutResult extends BackendlessResultBase {
  LogoutResult.fromResponse(TinyNetRequesterResponse r) : super.fromResponse(r) {
  }
}

class RegistResult extends BackendlessResultBase {
  RegistResult.fromResponse(TinyNetRequesterResponse r) : super.fromResponse(r) {
  }
}

class LoginResult extends BackendlessResultBase {
  String userToken = "";
  LoginResult.fromResponse(TinyNetRequesterResponse r) : super.fromResponse(r) {
    if (keyValues.containsKey("user-token")) {
      userToken = keyValues["user-token"];
    }
  }
}
