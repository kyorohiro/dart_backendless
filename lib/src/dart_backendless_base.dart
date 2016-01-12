// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of hetima_backendless;


abstract class Builder {
  Future<HetimaRequester> createRequester();
}

abstract class HetimaRequester {
   Future<HetimaResponse> request();
}

class HetimaResponse {

}
