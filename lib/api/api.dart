import 'package:black_book/api/settings/device_service.dart';
import 'package:black_book/models/banner/detial.dart';
import 'package:black_book/models/banner/response.dart';
import 'package:black_book/models/category/category_detial.dart';
import 'package:black_book/models/category/category_response.dart';
import 'package:black_book/models/default/device_model.dart';
import 'package:black_book/models/default/razmer.dart';
import 'package:black_book/models/friend/detial.dart';
import 'package:black_book/models/friend/response.dart';
import 'package:black_book/models/invitaion/response.dart';
import 'package:black_book/models/notification/response.dart';
import 'package:black_book/models/product/response.dart';
import 'package:black_book/models/sale/sale_detial.dart';
import 'package:black_book/models/sale/sale_response.dart';
import 'package:black_book/models/summery_detial/response.dart';
import 'package:black_book/models/transfer/response.dart';
import 'package:black_book/models/update/response.dart';
import 'package:black_book/models/user_data/user_data_response.dart';
import 'package:black_book/util/utils.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'settings/api_client.dart';

class API {
  static final API _instance = API._internal();
  API._internal();
  factory API() => _instance;
  final client = APIHttpClient();
  final int limit = 40;

  Future<void> addFriendRequest({
    required String phoneNumber,
  }) async {
    var requestBody = <String, String>{
      "countryCode": "976",
      "phoneNumber": phoneNumber,
    };
    await client.post(
      '/v1/invite/create',
      data: requestBody,
    );
  }

  Future<PhoneNumber> getFriendList(int page, String status) async {
    String path = "/v1/invite/my/list?sort=desc&page=$page&limit=40";
    if (status == "Баталгаажсан") {
      path = '/v1/invite/my/list?sort=desc&page=$page&limit=40&status=APPROVED';
    } else if (status == "Хүлээгдэж байна") {
      path = '/v1/invite/my/list?sort=desc&page=$page&limit=40&status=PENDING';
    } else if (status == "Сонгох") {
      path = '/v1/invite/my/list?sort=desc&page=$page&limit=40';
    } else if (status == "Цуцалсан") {
      path = '/v1/invite/my/list?sort=desc&page=$page&limit=40&status=DECLINED';
    }
    return await client.get(path).then((value) {
      PackagesResponse res = PackagesResponse.fromJson(value);
      return res.data!;
    });
  }

  Future<NotficationResponse> getNotification(int page) async {
    return await client.get('/v1/notification/my/list?page=$page&limit=40&sort_type=desc').then((value) async {
      if (value == "auth_token_error") {
        await refreshToken();
        return getNotification(page);
      } else {
        return NotficationResponse.fromJson(value);
      }
    });
  }

  Future<UpdateStatusResponse> getUpdateStatus() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    return await client.get('/v1/misc/version?type=${UDevice().deviceType}&version=$version').then((value) async {
      if (value == "auth_token_error") {
        await refreshToken();
        return getUpdateStatus();
      } else {
        return UpdateStatusResponse.fromJson(value);
      }
    });
  }

  Future<InvitationResponse> checkInvation() async {
    return await client.get('/v1/invite/invitation/list?country_code=976&phone_number=${Utils.getPhone()}&sort=asc').then((value) async {
      if (value == "auth_token_error") {
        await refreshToken();
        return checkInvation();
      } else {
        return InvitationResponse.fromJson(value);
      }
    });
  }

  Future<void> approveInvation(int id) async {
    var requestBody = <String, dynamic>{"countryCode": "976", "phoneNumber": Utils.getPhone(), "id": id};
    return await client.post('/v1/invite/approve', data: requestBody).then((value) async {
      if (value == "auth_token_error") {
        await refreshToken();
        return approveInvation(id);
      }
    });
  }

  Future<void> setNotification(int id) async {
    var requestBody = <String, int>{"id": id};
    await client.post('/v1/notification/seen', data: requestBody).then((value) async {
      if (value == "auth_token_error") {
        await refreshToken();
        return setNotification(id);
      }
    });
  }

  Future<void> setTranferType(bool type, String tid) async {
    var requestBody = <String, String>{"tid": tid};
    String path = type ? '/v1/product/transfer/accept' : '/v1/product/transfer/decline';
    await client.post(path, data: requestBody);
  }

  // Future<CategoryResponseModel> getProductType() async {
  //   await client.get('/v1/category/my/list').then((value) async {
  //     if (value == "auth_token_error") {
  //       await refreshToken();
  //       return getProductType();
  //     } else {
  //       return CategoryResponseModel.fromJson(value);
  //     }
  //   });
  // }
  Future<List<CategoryDetialModel>> getProductType() async {
    return await client.get("/v1/category/my/list").then((value) async {
      if (value == "auth_token_error") {
        await refreshToken();
        return getProductType();
      } else {
        return CategoryResponseModel.fromJson(value).data!;
      }
    });
  }

  Future<List<BannerDetial>> getBanner() async {
    return await client.get('/v1/misc/banner/main').then((value) async {
      if (value == "auth_token_error") {
        await refreshToken();
        return getBanner();
      } else {
        return BannerResponse.fromJson(value).data!;
      }
    });
  }

  Future<void> refreshToken() async {
    DeviceModel model = await UDevice().getDeviceUUID();
    var requestBody = <String, String>{"deviceToken": model.deviceToken, "deviceType": model.deviceInfo, "refreshToken": Utils.getRefreshToken()};
    await client.post('/v1/auth/refresh', data: requestBody).then((value) {
      UserDataResponseModel userData = UserDataResponseModel.fromJson(value);
      Utils.getCommonProvider().setUserInfo(userData.data!);
    });
  }

  Future<void> inviteApprove(int id) async {
    var requestBody = <String, dynamic>{"id": id, "countryCode": "976", "phoneNumber": Utils.getPhone()};
    await client.post('/v1/invite/approve', data: requestBody).then((value) {
      UserDataResponseModel userData = UserDataResponseModel.fromJson(value);
      Utils.getCommonProvider().setUserInfo(userData.data!);
    });
  }

  Future<ProductResponseModel> getProductData(int page, bool searchAgian, String storeId, String category, String searchValue) async {
    String path = "";
    if (Utils.getUserRole() == "BOSS") {
      if (searchAgian) {
        if (storeId == "-1") {
          path = '/v1/product/my/list?page=$page&limit=10&q=$searchValue&parent_category=$category&sort=desc&is_warehouse=1';
        } else {
          path = '/v1/product/my/list?page=$page&limit=10&q=$searchValue&parent_category=$category&store_id=$storeId&sort=desc';
        }
      } else {
        path = '/v1/product/my/list?page=$page&limit=10&sort=desc&is_warehouse=1';
      }
    } else {
      if (searchAgian) {
        if (storeId == "-1") {
          path = '/v1/product/my/list?page=$page&limit=10&q=$searchValue&parent_category=$category&sort=desc&is_warehouse=1';
        } else {
          path = '/v1/product/my/list?page=$page&limit=10&q=$searchValue&parent_category=$category&store_id=$storeId&sort=desc';
        }
      } else {
        path = '/v1/product/my/list?page=$page&limit=10&sort=desc&store_id=${Utils.getStoreId()}';
      }
    }

    return await client.get(path).then((value) async {
      if (value == "auth_token_error") {
        await refreshToken();
        return getProductData(page, searchAgian, storeId, storeId, searchValue);
      } else {
        return ProductResponseModel.fromJson(value);
      }
    });
  }

  Future<ProductResponseModel> getProductDataSearch(int page, bool searchAgian, String storeId, String category, String searchValue) async {
    String path = "";
    if (searchAgian) {
      if (storeId == "-1") {
        path = '/v1/product/my/list?page=$page&limit=10&q=$searchValue&parent_category=$category&sort=desc&is_warehouse=1';
      } else {
        path = '/v1/product/my/list?page=$page&limit=10&q=$searchValue&parent_category=$category&store_id=$storeId&sort=desc';
      }
    } else {
      if (Utils.getUserRole() == "BOSS") {
        path = '/v1/product/my/list?page=$page&limit=10&sort=desc&is_warehouse=1';
      } else {
        path = '/v1/product/my/list?page=$page&limit=10&sort=desc&store_id=${Utils.getStoreId()}';
      }
    }
    return await client.get(path).then((value) async {
      if (value == "auth_token_error") {
        await refreshToken();
        return getProductData(page, searchAgian, storeId, storeId, searchValue);
      } else {
        return ProductResponseModel.fromJson(value);
      }
    });
  }

  Future<ProductResponseModel> getDateProductDataSearch(int page, bool searchAgian, String begindate, String endDate, String searchValue) async {
    String path = "";
    if (searchAgian) {
      path = '/v1/product/my/list?page=$page&limit=$limit&q=$searchValue&sort=desc&created_at_from=$begindate&created_at_to=$endDate';
    } else {
      path = '/v1/product/my/list?page=$page&limit=$limit&sort=desc&created_at_from=$begindate&created_at_to=$endDate';
    }
    return await client.get(path).then((value) async {
      if (value == "auth_token_error") {
        await refreshToken();
        return getDateProductDataSearch(page, searchAgian, begindate, endDate, searchValue);
      } else {
        return ProductResponseModel.fromJson(value);
      }
    });
  }

  Future<TransferDataResponse> getTransferHistory(DateTime beginDate, DateTime endDate, bool searchAgian, String storeId, int page, String sourceId, bool incoming) async {
    DateTime now = DateTime.now();
    String path = "";
    if (sourceId == '') {
      if (Utils.getUserRole() == "BOSS") {
        if (searchAgian) {
          path = '/v1/product/transfer/list?page=$page&limit=$limit&sort=desc&store_id=$storeId&begin_date=${beginDate.year}-${beginDate.month}-${beginDate.day}&end_date=${endDate.year}-${endDate.month}-${endDate.day}&incoming=${incoming ? 1 : -1}';
        } else {
          path = '/v1/product/transfer/list?page=$page&limit=$limit&sort=desc&begin_date=${now.year}-${now.month}-${now.day}&end_date=${now.year}-${now.month}-${now.day}&incoming=${incoming ? 1 : -1}&is_warehouse=1';
        }
      } else {
        if (searchAgian) {
          path = '/v1/product/transfer/list?page=$page&limit=$limit&sort=desc&incoming=${incoming ? 1 : -1}&store_id=$storeId&begin_date=${beginDate.year}-${beginDate.month}-${beginDate.day}&end_date=${endDate.year}-${endDate.month}-${endDate.day}';
        } else {
          path = '/v1/product/transfer/list?limit=$limit&store_id=${Utils.getStoreId()}&begin_date=${now.year}-${now.month}-${now.day}&end_date=${now.year}-${now.month}-${now.day}&page=$page&sort=desc&incoming=${incoming ? 1 : -1}';
        }
      }
    } else {
      path = '/v1/product/transfer/list?limit=$limit&page=$page&sort=desc&tid=$sourceId';
    }
    return await client.get(path).then((value) async {
      if (value == "auth_token_error") {
        await refreshToken();
        return getTransferHistory(beginDate, endDate, searchAgian, storeId, page, sourceId, incoming);
      } else {
        return TransferDataResponse.fromJson(value);
      }
    });
  }

  Future<DetialSaleProductModel> getSoldProduct(int page, DateTime beginDate, DateTime endDate, String storeId, bool searchAgian) async {
    String path = "";
    if (Utils.getUserRole() == "BOSS") {
      if (searchAgian) {
        if (storeId == "-1") {
          path = "/v1/product/sale/list?sort=desc&page=$page&limit=100&from_date=${formatDateTime(beginDate)}&to_date=${formatDateTime(endDate)}&is_warehouse=1";
        } else {
          path = "/v1/product/sale/list?sort=desc&page=$page&limit=100&from_date=${formatDateTime(beginDate)}&to_date=${formatDateTime(endDate)}&store_id=$storeId";
        }
      } else {
        path = '/v1/product/sale/list?sort=desc&page=$page&limit=100&is_warehouse=1';
      }
    } else {
      if (searchAgian) {
        path = '/v1/product/sale/list?sort=desc&page=$page&limit=100&store_id=${Utils.getStoreId()}&from_date=${formatDateTime(beginDate)}&to_date=${formatDateTime(endDate)}';
      } else {
        path = '/v1/product/sale/list?sort=desc&page=$page&limit=100&store_id=${Utils.getStoreId()}';
      }
    }
    return await client.get(path).then((value) async {
      if (value == "auth_token_error") {
        await refreshToken();
        return getSoldProduct(page, beginDate, endDate, storeId, searchAgian);
      } else {
        return MainSaleProductResponseModel.fromJson(value).data!;
      }
    });
  }

  Future<void> addProductSize({
    required List<ProductRazmerModel> list,
  }) async {
    var requestBody = <String, List>{"products": list};
    await client.post(
      '/v1/product/add',
      data: requestBody,
    );
  }

  Future<SummeryDetial> getSummery() async {
    return await client.get('/v1/product/balance/summary').then((value) async {
      if (value == "auth_token_error") {
        await refreshToken();
        return getSummery();
      } else {
        return SummeryResponse.fromJson(value).data!;
      }
    });
  }

  Future<void> changeType(String type, int id) async {
    var requestBody = <String, dynamic>{"name": type, "id": id};
    await client
        .put(
      '/v1/category/update',
      data: requestBody,
    )
        .then((value) async {
      if (value == "auth_token_error") {
        await refreshToken();
        return setNotification(id);
      }
    });
  }
}

String formatDateTime(DateTime dateTime) {
  final formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(dateTime.toLocal());
}
