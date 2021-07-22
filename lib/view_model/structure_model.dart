import 'package:fun_android/provider/view_state_list_model.dart';
import 'package:fun_android/provider/view_state_refresh_list_model.dart';
import 'package:fun_android/service/sfcv_repository.dart';
import 'package:fun_android/service/wan_android_repository.dart';

import 'favourite_model.dart';

class StructureCategoryModel extends ViewStateListModel {
  @override
  Future<List> loadData() async {
    return await SfcvRepository.fetchTreeCategories();
  }
}

class StructureTagModel extends ViewStateListModel {
  @override
  Future<List> loadData() async {
    return await SfcvRepository.fetchTreeTags();
  }
}

class StructureListModel extends ViewStateRefreshListModel {
  final int cid;
  final int type;

  StructureListModel(this.cid, this.type);

  @override
  Future<List> loadData({int pageNum}) async {
    if(type == 0) {
      return await SfcvRepository.fetchArticles(pageNum, cat: cid);
    }
    else if(type == 1) {
      return await SfcvRepository.fetchArticles(pageNum, tag: cid);
    }
    else {
      return await SfcvRepository.fetchArticles(pageNum);
    }
  }

  @override
  onCompleted(List data) {
    GlobalFavouriteStateModel.refresh(data);
  }
}

/// 网址导航
class NavigationSiteModel extends ViewStateListModel {
  @override
  Future<List> loadData() async {
    return await SfcvRepository.fetchNavigationSite();
  }
}

