part of hetima_mbaas_backendless;

class BackendlessData {
  TinyNetBuilder builder;
  String applicationId;
  String secretKey;
  BackendlessData(this.builder, this.applicationId, this.secretKey) {}

  Future<SaveDataResult> saveData(String tableName, Map<String, Object> body, {String objectId: null, String userToken: null, String version: "v1"}) async {
    TinyNetRequester requester = await this.builder.createRequester();
    Map<String, String> headers = {
      "application-id": applicationId, //
      "secret-key": secretKey, //
      "application-type": "REST", //
      "Content-Type": "application/json" //
    };
    if (userToken != null) {
      headers["user-token"] = userToken;
    }
    String opt = "";
    if (objectId != null) {
      opt = "/${objectId}";
    }
    String url = "https://api.backendless.com/${version}/data/${tableName}${opt}";
    print("########URL### ${url}");
    TinyNetRequesterResponse resonse = await requester.request(
        TinyNetRequester.TYPE_POST, //
        url, //
        headers: headers, //
        data: JSON.encode(body));

    return new SaveDataResult.fromResponse(resonse);
  }

  Future<SaveDataResult> updateData(String tableName, Map<String, Object> body, String objectId, {String userToken: null, String version: "v1"}) async {
    TinyNetRequester requester = await this.builder.createRequester();
    Map<String, String> headers = {
      "application-id": applicationId, //
      "secret-key": secretKey, //
      "application-type": "REST", //
      "Content-Type": "application/json" //
    };
    if (userToken != null) {
      headers["user-token"] = userToken;
    }
    String opt = "";
    if (objectId != null) {
      opt = "/${objectId}";
    }
    String url = "https://api.backendless.com/${version}/data/${tableName}${opt}";
    print("########URL### ${url}");
    TinyNetRequesterResponse resonse = await requester.request(
        TinyNetRequester.TYPE_PUT, //
        url, //
        headers: headers, //
        data: JSON.encode(body));

    return new SaveDataResult.fromResponse(resonse);
  }

  Future<SaveDataResult> retrieveSchemeDefinition(String tableName, {String userToken: null, String version: "v1"}) async {
    TinyNetRequester requester = await this.builder.createRequester();
    Map<String, String> headers = {
      "application-id": applicationId, //
      "secret-key": secretKey, //
      "application-type": "REST", //
      "Content-Type": "application/json" //
    };
    if (userToken != null) {
      headers["user-token"] = userToken;
    }
    TinyNetRequesterResponse resonse = await requester.request(
        TinyNetRequester.TYPE_GET, //
        "https://api.backendless.com/${version}/data/${tableName}/properties", //
        headers: headers);

    return new SaveDataResult.fromResponse(resonse);
  }

  Future<SearchBasicDataResult> searchBasicDataFromFirst(String tableName, {String command: null, String userToken: null, String version: "v1"}) async {
    return await searchBasicData(tableName, userToken: userToken, command: "first", version: version);
  }

  Future<SearchBasicDataResult> searchBasicDataFromLast(String tableName, {String command: null, String userToken: null, String version: "v1"}) async {
    return await searchBasicData(tableName, userToken: userToken, command: "last", version: version);
  }

  Future<SearchBasicDataResult> searchBasicDataFromObjectId(String tableName, String objectId, {String command: null, String userToken: null, String version: "v1"}) async {
    return await searchBasicData(tableName, userToken: userToken, command: "${objectId}", version: version);
  }

  Future<SearchBasicDataResult> searchBasicDataCollection(String tableName, {String advance: "", String nextPage: null, String command: null, String userToken: null, String version: "v1"}) async {
    return await searchBasicData(tableName, userToken: userToken, command: null, version: version, nextPage: nextPage, advance: advance);
  }

  Future<SearchBasicDataResult> searchBasicData(String tableName, {String advance: "", String command: null, String userToken: null, String version: "v1", String nextPage: null}) async {
    TinyNetRequester requester = await this.builder.createRequester();
    Map<String, String> headers = {
      "application-id": applicationId, //
      "secret-key": secretKey, //
      "application-type": "REST", //
      "Content-Type": "application/json" //
    };
    if (userToken != null) {
      headers["user-token"] = userToken;
    }

    String commandProp = "";
    if (command != null) {
      commandProp = "/${command}";
    }
    String url = "";
    if (nextPage == null) {
      url = "https://api.backendless.com/${version}/data/${tableName}${commandProp}";
    } else {
      url = nextPage;
    }
    if (advance != null && advance.length != 0) {
      print("#### ad:${advance}");
      if (url.contains("?") == true) {
        url += "&${advance}";
      } else {
        url += "?${advance}";
      }
    }

    print("#### ${url}");
    TinyNetRequesterResponse resonse = await requester.request(
        TinyNetRequester.TYPE_GET, //
        url, //
        headers: headers);

    return new SearchBasicDataResult.fromResponse(resonse);
  }

  Future<DeleteDataResult> deleteData(String tableName, String objectId, {String userToken: null, String version: "v1"}) async {
    TinyNetRequester requester = await this.builder.createRequester();
    Map<String, String> headers = {
      "application-id": applicationId, //
      "secret-key": secretKey, //
      "application-type": "REST" //
    };
    if (userToken != null) {
      headers["user-token"] = userToken;
    }
    TinyNetRequesterResponse resonse = await requester.request(
        TinyNetRequester.TYPE_DELETE, //
        "https://api.backendless.com/${version}/data/${tableName}/${objectId}", //
        headers: headers);

    return new DeleteDataResult.fromResponse(resonse);
  }
}

class DeleteDataResult extends BackendlessResultBase {
  List<Map<String, Object>> data = [];

  DeleteDataResult.fromResponse(TinyNetRequesterResponse r) : super.fromResponse(r) {
    if (keyValues.containsKey("data")) {
      try {
        data = keyValues["data"];
      } catch (e) {}
    }
  }
}

class SearchBasicDataResult extends BackendlessResultBase {
  List<Map<String, Object>> data = [];
  String nextPage = "";
  int offset = 0;
  int totalObjects = 0;

  SearchBasicDataResult.fromResponse(TinyNetRequesterResponse r) : super.fromResponse(r) {
    if (keyValues.containsKey("data")) {
      try {
        data = keyValues["data"];
      } catch (e) {}
    }

    if (keyValues.containsKey("nextPage")) {
      nextPage = keyValues["nextPage"];
    }
    if (keyValues.containsKey("offset")) {
      offset = keyValues["offset"];
    }
    if (keyValues.containsKey("totalObjects")) {
      totalObjects = keyValues["totalObjects"];
    }
  }
}

class RetrieveSchemeDefinitionResultItem {
  bool autoLoad = null;
  String customRegex = null;
  String defaultValue = null;
  bool isPrimaryKey = null;
  String name = null;
  String relatedTable = null;
  bool required = null;
  String type = null;
  RetrieveSchemeDefinitionResultItem.fromMap(Map m) {
    var t = null;
    t = m["autoLoad"];
    autoLoad = (t is bool ? t : null);

    t = m["customRegex"];
    customRegex = (t is String ? t : null);

    t = m["defaultValue"];
    defaultValue = (t is String ? t : null);

    t = m["isPrimaryKey"];
    isPrimaryKey = (t is bool ? t : null);

    t = m["name"];
    name = (t is String ? t : null);

    t = m["relatedTable"];
    relatedTable = (t is String ? t : null);

    t = m["required"];
    required = (t is bool ? t : null);

    t = m["type"];
    type = (t is String ? t : null);
  }
}

class RetrieveSchemeDefinitionResult extends BackendlessResultBase {
  List<RetrieveSchemeDefinitionResultItem> columns = [];
  RetrieveSchemeDefinitionResult.fromResponse(TinyNetRequesterResponse r) : super.fromResponse(r) {
    String utf8binary = UTF8.decode(r.response.asUint8List());
    try {
      var t = JSON.decode(utf8binary);
      if (t is List) {
        List<Map<Object, Object>> columnSources = t;
        for (Map m in columnSources) {
          columns.add(new RetrieveSchemeDefinitionResultItem.fromMap(m));
        }
      }
    } catch (e) {}
  }
}

class SaveDataResult extends BackendlessResultBase {
  SaveDataResult.fromResponse(TinyNetRequesterResponse r) : super.fromResponse(r) {
  }
}
