import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tflite/tflite.dart';
import 'package:vantypesapp/features/presentation/bloc/detection/detection_bloc.dart';
import 'package:vantypesapp/features/presentation/bloc/upload/upload_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:vantypesapp/features/presentation/widgets/snackbar.dart';

import '../../../injection_container.dart';

class DetectionPage extends StatefulWidget {
  const DetectionPage({Key key}) : super(key: key);

  @override
  _DetectionPageState createState() => _DetectionPageState();
}

class _DetectionPageState extends State<DetectionPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  DetectionBloc detectionBloc;

  @override
  void initState() {
    detectionBloc = sl<DetectionBloc>();
    super.initState();
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      BlocConsumer<DetectionBloc, DetectionState>(
          bloc: detectionBloc..add(LoadModelEvent()),
          listener: (context, state) {
            if (state is ImageLoadedState) {
              detectionBloc.add(PredictEvent(image: detectionBloc.img));
            } else if (state is CameraPermissionGrantedState) {
              detectionBloc.add(TakeImageEvent());
            } else if (state is StoragePermissionGrantedState) {
              detectionBloc.add(PickGalleryEvent());
            } else if (state is DetectionErrorState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(buildSnackBar(context, state.message));
            } else if (state is PermissionDeniedState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(buildSnackBar(context, state.message));
              detectionBloc.add(PermissionDeniedEvent());
            } else if (state is DetectionErrorState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(buildSnackBar(context, state.message));
            }
          },
          buildWhen: (previous, current) {
            if (current is LoadedModelState ||
                (previous is PredictingState && current is Prediction) ||
                current is PredictingState) {
              return true;
            } else if ((previous is Prediction && current is Prediction)) {
              return false;
            } else {
              return false;
            }
          },
          builder: (context, state) {
            if (state is LoadedModelState) {
              return Container(height: size.height / 3);
            }
            if (state is PredictingState) {
              return Container(
                height: size.height / 3,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (state is Prediction) {
              double factorX;
              double factorY;
              double width;
              double imgH = detectionBloc.imgH;
              double imgW = detectionBloc.imgW;
              Color blue = Color.fromRGBO(37, 213, 253, 1.0);
              //szelesseg

              if (imgH >= imgW) {
                double szam;
                if (imgH > (size.height / 2.2)) {
                  //decrease
                  szam = (imgH - (size.height / 2.2)) / imgH;
                  width = imgW * (1 - szam);
                } else {
                  //increase
                  szam = ((size.height / 2.2) - imgH) / imgH;
                  width = imgW * (1 + szam);
                }
                factorX = width;
                factorY = imgH / imgW * width;
              } else {
                width = size.width;
                factorX = size.width;
                factorY = imgH / imgW * size.width;
              }

              return Column(
                children: [
                  Container(
                    height: size.height / 2.2,
                    width: width,
                    child: Stack(clipBehavior: Clip.none, children: [
                      Positioned(
                        top: 0.0,
                        left: 0.0,
                        width: width,
                        height: size.height / 2.2,
                        child: Container(
                          child: Image.file(
                            detectionBloc.img,
                            fit: BoxFit.contain,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ),
                      state.prediction.isNotEmpty
                          ? Positioned(
                              left: state.prediction[0]["rect"]["x"] * factorX,
                              top: state.prediction[0]["rect"]["y"] * factorY,
                              width: state.prediction[0]["rect"]["w"] * factorX,
                              height:
                                  state.prediction[0]["rect"]["h"] * factorY,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  border: Border.all(
                                    color: blue,
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  "${state.prediction[0]["detectedClass"].toString().tr()} ${(state.prediction[0]["confidenceInClass"] * 100).toStringAsFixed(0)}%",
                                  style: TextStyle(
                                    background: Paint()..color = blue,
                                    color: Colors.white,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ]),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      child: Text(
                          state.prediction.isNotEmpty
                              ? 'detection'.tr() +
                                  '${state.prediction[0]['detectedClass'].toString().tr()}!'
                              : 'no_detection'.tr(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400))),
                  SizedBox(
                    height: 15,
                  ),
                ],
              );
            } else {
              return Container(height: size.height / 2);
            }
          }),
      BlocBuilder<DetectionBloc, DetectionState>(
          bloc: detectionBloc,
          buildWhen: (previous, current) {
            if (current is LoadedModelState || current is Prediction) {
              return true;
            } else {
              return false;
            }
          },
          builder: (context, detectionState) {
            if (detectionState is LoadedModelState) {
              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        detectionBloc.add(CheckCameraPermissionEvent());
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(63, 136, 197, 1),
                          fixedSize:
                              Size(size.width * 0.55, size.height * 0.08),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      child: Text(
                        "take_photo".tr(),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        detectionBloc.add(CheckStoragePermissionEvent());
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(63, 136, 197, 1),
                          fixedSize:
                              Size(size.width * 0.55, size.height * 0.08),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      child: Text(
                        "pick_gallery".tr(),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            }
            if (detectionState is Prediction) {
              UploadBloc uploadBloc = BlocProvider.of<UploadBloc>(context);
              return Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        uploadBloc.add(UploadResetEvent());
                        detectionBloc..add(RestartEvent());
                      },
                      icon: Icon(Icons.replay),
                      label: Text("restart").tr(),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    BlocConsumer<UploadBloc, UploadState>(
                        bloc: uploadBloc,
                        listener: (context, uploadState) {
                          if (uploadState is UploadErrorState) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                buildSnackBar(context, uploadState.message));
                          }
                        },
                        builder: (context, uploadState) {
                          if (uploadState is UploadInitial ||
                              uploadState is UploadErrorState) {
                            return ElevatedButton.icon(
                                onPressed: detectionState.prediction.isNotEmpty
                                    ? () {
                                        uploadBloc.add(UploadImageEvent(
                                            image: detectionBloc.img,
                                            type: detectionState.prediction[0]
                                                ["detectedClass"]));
                                      }
                                    : null,
                                icon: Icon(Icons.file_upload),
                                label: Text("upload_img".tr()),
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.all(20)),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.blue),
                                ));
                          } else if (uploadState is UploadingState) {
                            return Center(child: CircularProgressIndicator());
                          } else if (uploadState is UploadCompleteState) {
                            return Icon(Icons.check);
                          } else {
                            return Container();
                          }
                        }),
                  ],
                ),
              );
            } else {
              return Container();
            }
          })
    ]);
  }
}
