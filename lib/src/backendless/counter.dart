part of hetima_mbaas_backendless;

class BackendlessCounter {
  TinyNetBuilder builder;
  String applicationId;
  String secretKey;
  BackendlessCounter(this.builder, this.applicationId, this.secretKey) {}
  Future<IncrementGetCounterResult> incrementGet(String counterName, {String userToken: null, String version: "v1"}) async {
    TinyNetRequester requester = await this.builder.createRequester();
    Map<String, String> headers = {
      "application-id": applicationId, //
      "secret-key": secretKey, //
      "application-type": "REST"
    };
    if (userToken != null) {
      headers["user-token"] = userToken;
    }
    String url = "https://api.backendless.com/${version}/counters/${counterName}/increment/get";
    print("########URL### ${url}");
    TinyNetRequesterResponse resonse = await requester.request(
        TinyNetRequester.TYPE_PUT, //
        url, //
        headers: headers);
    return new IncrementGetCounterResult.fromResponse(resonse);
  }
}

class IncrementGetCounterResult extends BackendlessResultBase {
  int count = 0;
  IncrementGetCounterResult.fromResponse(TinyNetRequesterResponse r) : super.fromResponse(r, isJson: false) {
    try {
      String r = UTF8.encode(this.binary);
      count = int.parseInt(r);
    } catch(e) {
      isOk = false;
    }
  }
}
