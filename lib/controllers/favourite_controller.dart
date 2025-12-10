
import 'package:get/get.dart';
import '../models/add_favourite_model.dart';
import '../models/get_favourite_model.dart';
import '../service/api_client.dart';
import '../service/api_constants.dart';


class FavouriteController extends GetxController {
  var isLoading = false.obs;
  var isFetching = false.obs;
  var errorMessage = ''.obs;

  var addFavouriteResponse = AddFavouriteModel().obs;
  var favourites = <FavouriteDataList>[].obs;

  /// ===============================================================
  /// ADD TO FAVOURITE
  /// ===============================================================
  Future<void> addToFavourite(String businessId) async {
    try {
      isLoading(true);
      errorMessage('');

      Map<String, String> body = {
        "business": businessId,
      };

      final response = await ApiClient.postData(
        ApiConstants.postFavorites,
        body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        addFavouriteResponse.value =
            AddFavouriteModel.fromJson(response.body);

        /// Reload favourite list after adding
        await getFavourites();
      } else {
        errorMessage(response.statusText ?? "Something went wrong");
      }
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

  /// ===============================================================
  /// GET FAVOURITES LIST
  /// ===============================================================
  Future<void> getFavourites() async {
    try {
      isFetching(true);
      errorMessage('');

      final response = await ApiClient.getData(ApiConstants.getFavorites);

      if (response.statusCode == 200) {
        final model = GetFavouritesModel.fromJson(response.body);
        favourites.assignAll(model.data ?? []);
      } else {
        errorMessage(response.statusText ?? "Unable to fetch favourites");
      }
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isFetching(false);
    }
  }

  /// ===============================================================
  /// REMOVE FAVOURITE
  /// ===============================================================
  Future<void> removeFavourite(String favouriteId) async {
    try {
      isLoading(true);
      errorMessage('');

      final response = await ApiClient.deleteData(
        "${ApiConstants.deleteFavorites}$favouriteId",
      );

      if (response.statusCode == 200) {
        // Parse response
        final res = DeleteFavouriteResponse.fromJson(response.body);

        if (res.success == true) {
          // Remove from local list immediately
          favourites.removeWhere((item) => item.id == favouriteId);

          Get.snackbar('Success', res.message ?? 'Removed successfully');
        } else {
          errorMessage(res.message ?? 'Failed to remove favourite');
        }
      } else {
        errorMessage(response.statusText ?? "Failed to remove favourite");
      }
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
