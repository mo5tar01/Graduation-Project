
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_recommendation/modules/Travel_app/login/cubit/states.dart';

import '../../../../models/shop_app/login_model.dart';
import '../../../../shared/network/end_point.dart';
import '../../../../shared/network/remote/dio_helper.dart';

class ShopLoginCubit extends Cubit<ShopLoginState>
{
  ShopLoginCubit(ShopLoginState initialState) : super(initialState);
  static ShopLoginCubit get (context) => BlocProvider.of(context);
  ShopLoginModel? loginModel;
      void userLogin({
    required String email,
    required String password,
}){
        emit(ShopLoginLoadingState());
        DioHelper.postData(
          url:LOGIN,
          data:{
            'email' : email,
            'password': password,
          } ,).then((value){
            print(value.data);
           loginModel = ShopLoginModel.fromJson(value.data);
           print(loginModel?.data?.token);
           print(loginModel?.status);
           print(loginModel?.message);
            emit(ShopLoginSuccessState(loginModel!));
        }).catchError((error){
          print(error.toString());
          emit(ShopLoginErrorState(error.toString()));

        });
      }
}