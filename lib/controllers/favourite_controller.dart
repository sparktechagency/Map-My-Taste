
import 'package:get/get.dart';
import '../models/add_favourite_model.dart';
import '../models/get_favourite_model.dart';
import '../service/api_client.dart';
import '../service/api_constants.dart';


class FavouriteController extends GetxController {
  var isLoading = false.obs;
  var isFetching = false.obs;
  var isPaginating = false.obs;

  var errorMessage = ''.obs;

  var addFavouriteResponse = AddFavouriteModel().obs;
  var favourites = <FavouriteDataList>[].obs;
  var singleFavourite = Rxn<SingleFavouriteData>();

  /// Pagination fields
  int page = 1;
  final int limit = 10;
  RxBool hasMore = true.obs;

  /// ===============================================================
  /// RESET PAGINATION (call before new fetch)
  /// ===============================================================
  void resetPagination() {
    page = 1;
    favourites.clear();
    hasMore(true);
  }

  /// ===============================================================
  /// GET FAVOURITES (Paginated)
  /// ===============================================================
  Future<void> getFavourites({bool isLoadMore = false}) async {
    // 1. Guard Clause: Don't fetch if already loading or no more data
    if (isLoadMore) {
      if (!hasMore.value || isPaginating.value) return;
      isPaginating(true);
    } else {
      if (isFetching.value) return;
      isFetching(true);
      resetPagination();
    }

    try {
      errorMessage('');
      final response = await ApiClient.getData(
        "${ApiConstants.getFavorites}?page=$page&limit=$limit",
      );

      if (response.statusCode == 200) {
        final model = GetFavouritesModel.fromJson(response.body);
        final List<FavouriteDataList> newData = model.data ?? [];

        if (newData.isEmpty || newData.length < limit) {
          hasMore(false);
        }

        if (isLoadMore) {
          favourites.addAll(newData);
        } else {
          favourites.assignAll(newData);
        }

        // Only increment page on successful fetch of a full page
        if (newData.length == limit) {
          page++;
        }
      } else {
        errorMessage(response.statusText ?? "Unable to fetch favourites");
      }
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isFetching(false);
      isPaginating(false);
    }
  }

  /// ===============================================================
  /// LOAD MORE FAVOURITES
  /// ===============================================================
  Future<void> loadMoreFavourites() async {
    await getFavourites(isLoadMore: true);
  }

  /// ===============================================================
  /// ADD FAVOURITE
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

        resetPagination();
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
        final res = DeleteFavouriteResponse.fromJson(response.body);

        if (res.success == true) {
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

  /// ===============================================================
  /// SINGLE FAVOURITE
  /// ===============================================================
  Future<void> getSingleFavourite(String favouriteId) async {
    try {
      isFetching(true);
      errorMessage('');

      final response = await ApiClient.getData(
        "${ApiConstants.getFavouritesSingle}$favouriteId",
      );

      if (response.statusCode == 200) {
        final model = GetSingleFavouriteModel.fromJson(response.body);
        singleFavourite.value = model.data;
      } else {
        errorMessage(response.statusText ?? "Unable to fetch favourite");
      }
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isFetching(false);
    }
  }
}
