part of hetima_backendless_dartio;

class HetimaDartIOBuilder {
  Future<HetimaRequester> createRequester() async {
    return new HetimaHtml5HttpRequester();
  }
}

class HetimaDartIOHttpRequester extends HetimaRequester {
  Future<HetimaResponse> request(String type, String url, {Object data:null, Map<String, String> headers: null}){
    if (headers == null) {
      headers = {};
    }
    Completer<HetimaResponse> c = new Completer();
    return c.future;
  }
}
