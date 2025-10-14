/*
import 'package:get/get.dart';
import '../service/api_client.dart';
import '../service/api_constants.dart';

class SettingController extends GetxController {
  //==============================> Get Terms and Condition Method <==========================
  var termsConditionLoading = false.obs;
  RxString termContent = ''.obs;
  getTermsCondition() async {
    termsConditionLoading.value = true;
    Map<String, String> header = {'Content-Type': 'application/json'};
    var response = await ApiClient.getData(ApiConstants.termsConditionEndPoint,
        headers: header);
    if (response.statusCode == 200) {
      var data = response.body;
      var attributes = data['data']['attributes'][0]['content'];
      termContent.value = attributes;
      termsConditionLoading.value = false;
    }
  }

//==========================> Get Privacy Policy Method <=======================
  RxBool getPrivacyLoading = false.obs;
  RxString privacyContent = ''.obs;
  getPrivacy() async {
    getPrivacyLoading.value = true;
    Map<String, String> header = {'Content-Type': 'application/json'};
    var response = await ApiClient.getData(ApiConstants.privacyPolicyEndPoint,
        headers: header);
    if (response.statusCode == 200) {
      var data = response.body;
      var attributes = data['data']['attributes'][0]['content'];
      privacyContent.value = attributes;
      getPrivacyLoading.value = false;
    }
  }

  //==============================> Get About Us Method <==========================
  RxBool getAboutUsLoading = false.obs;
  RxString aboutContent = ''.obs;
  getAboutUs() async {
    getAboutUsLoading.value = true;
    Map<String, String> header = {'Content-Type': 'application/json'};
    var response = await ApiClient.getData(ApiConstants.aboutUsEndPoint, headers: header);
    if (response.statusCode == 200) {
      var data = response.body;
      var attributes = data['data']['attributes'][0]['content'];
      aboutContent.value = attributes;
      getAboutUsLoading.value = false;
    }
  }
}
*/
