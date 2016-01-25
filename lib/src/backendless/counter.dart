part of hetima_mbaas_backendless;

class BackendlessCounter {
  TinyNetBuilder builder;
  String applicationId;
  String secretKey;
  BackendlessCounter(this.builder, this.applicationId, this.secretKey) {}

  Future<IncrementGetCounterResult> incrementGet(String counterName, {String userToken: null, String version: "v1", int value: 1}) async {
    TinyNetRequester requester = await this.builder.createRequester();
    Map<String, String> headers = {
      "application-id": applicationId, //
      "secret-key": secretKey, //
      "application-type": "REST"
    };
    if (userToken != null) {
      headers["user-token"] = userToken;
    }
    String url = "";
    if (value == 1) {
      url = "https://api.backendless.com/${version}/counters/${counterName}/increment/get";
    } else {
      url = "https://api.backendless.com/${version}/counters/${counterName}/incrementby/get?value=${value}";
    }
    print("########URL### ${url}");
    TinyNetRequesterResponse resonse = await requester.request(
        TinyNetRequester.TYPE_PUT, //
        url, //
        headers: headers);
    return new IncrementGetCounterResult.fromResponse(resonse);
  }

  Future<DecrementGetCounterResult> decrementGet(String counterName, {String userToken: null, String version: "v1"}) async {
    TinyNetRequester requester = await this.builder.createRequester();
    Map<String, String> headers = {
      "application-id": applicationId, //
      "secret-key": secretKey, //
      "application-type": "REST"
    };
    if (userToken != null) {
      headers["user-token"] = userToken;
    }
    String url = "https://api.backendless.com/${version}/counters/${counterName}/decrement/get";
    print("########URL### ${url}");
    TinyNetRequesterResponse resonse = await requester.request(
        TinyNetRequester.TYPE_PUT, //
        url, //
        headers: headers);
    return new DecrementGetCounterResult.fromResponse(resonse);
  }

  //compareandset
  Future<GetCompareandsetCounterResult> getCompareandSet(String counterName, int expected, int updated, {String userToken: null, String version: "v1"}) async {
    TinyNetRequester requester = await this.builder.createRequester();
    Map<String, String> headers = {
      "application-id": applicationId, //
      "secret-key": secretKey, //
      "application-type": "REST"
    };
    if (userToken != null) {
      headers["user-token"] = userToken;
    }
    String url = "https://api.backendless.com/${version}/counters/${counterName}/get/compareandset?expected=${expected}&updatedvalue=${updated}";
    print("########URL### ${url}");
    TinyNetRequesterResponse resonse = await requester.request(
        TinyNetRequester.TYPE_PUT, //
        url, //
        headers: headers);
    return new GetCompareandsetCounterResult.fromResponse(resonse);
  }

  //compareandset
  Future<GetCurrentCounterResult> getCurrrent(String counterName, {String userToken: null, String version: "v1"}) async {
    TinyNetRequester requester = await this.builder.createRequester();
    Map<String, String> headers = {
      "application-id": applicationId, //
      "secret-key": secretKey, //
      "application-type": "REST"
    };
    if (userToken != null) {
      headers["user-token"] = userToken;
    }
    String url = "https://api.backendless.com/${version}/counters/${counterName}";
    print("########URL### ${url}");
    TinyNetRequesterResponse resonse = await requester.request(
        TinyNetRequester.TYPE_GET, //
        url, //
        headers: headers);
    return new GetCurrentCounterResult.fromResponse(resonse);
  }

  //compareandset
  Future<ResetCounterResult> resetCurrent(String counterName, {String userToken: null, String version: "v1"}) async {
    TinyNetRequester requester = await this.builder.createRequester();
    Map<String, String> headers = {
      "application-id": applicationId, //
      "secret-key": secretKey, //
      "application-type": "REST"
    };
    if (userToken != null) {
      headers["user-token"] = userToken;
    }
    String url = "https://api.backendless.com/${version}/counters/${counterName}/reset";
    print("########URL### ${url}");
    TinyNetRequesterResponse resonse = await requester.request(
        TinyNetRequester.TYPE_PUT, //
        url, //
        headers: headers);
    return new ResetCounterResult.fromResponse(resonse);
  }
}

class ResetCounterResult  extends BackendlessResultBase {
  ResetCounterResult.fromResponse(TinyNetRequesterResponse r) : super.fromResponse(r, isJson: false) {
  }
}

class GetCurrentCounterResult  extends BackendlessResultBase {
  int count = 0;
  GetCurrentCounterResult.fromResponse(TinyNetRequesterResponse r) : super.fromResponse(r, isJson: false) {
    try {
      String r = UTF8.decode(this.binary);
      count = int.parse(r);
    } catch (e) {
      isOk = false;
    }
  }
}

class GetCompareandsetCounterResult extends BackendlessResultBase {
  bool counterUpdated = false;
  GetCompareandsetCounterResult.fromResponse(TinyNetRequesterResponse r) : super.fromResponse(r, isJson: false) {
    try {
      String r = UTF8.decode(this.binary);
      print("############## ${r}");
      if(r == "true"){
        counterUpdated = true;
      } else {
        counterUpdated = false;
      }
    } catch (e) {
      isOk = false;
    }
  }
}
class DecrementGetCounterResult extends BackendlessResultBase {
  int count = 0;
  DecrementGetCounterResult.fromResponse(TinyNetRequesterResponse r) : super.fromResponse(r, isJson: false) {
    try {
      String r = UTF8.decode(this.binary);
      count = int.parse(r);
    } catch (e) {
      isOk = false;
    }
  }
}

class IncrementGetCounterResult extends BackendlessResultBase {
  int count = 0;
  IncrementGetCounterResult.fromResponse(TinyNetRequesterResponse r) : super.fromResponse(r, isJson: false) {
    try {
      String r = UTF8.decode(this.binary);
      count = int.parse(r);
    } catch (e) {
      isOk = false;
    }
  }
}
