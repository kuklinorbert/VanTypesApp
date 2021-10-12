import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tflite/tflite.dart';
import 'package:vantypesapp/features/presentation/bloc/classification/classification_bloc.dart';

import '../../../injection_container.dart';

class ClassificationPage extends StatefulWidget {
  @override
  _ClassificationPageState createState() => _ClassificationPageState();
}

class _ClassificationPageState extends State<ClassificationPage> {
  ClassificationBloc classificationBloc;

  @override
  void initState() {
    classificationBloc = sl<ClassificationBloc>();
    super.initState();
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(28, 119, 195, 1),
        title: Text(
          'Van types AI',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w200,
              fontSize: 20,
              letterSpacing: 0.8),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        backgroundColor: Color.fromRGBO(28, 119, 195, 1),
        onPressed: () {
          Navigator.of(context).pushNamed('/camera');
        },
      ),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  Widget buildBody(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    File img;
    double imgW;
    double imgH;
    return Column(children: [
      Container(
        height: MediaQuery.of(context).size.width / 1.1,
        child: Column(children: [
          Container(
            child: Center(
                child: BlocListener(
                    cubit: classificationBloc,
                    listener: (context, state) {
                      if (state is ImageLoaded) {
                        classificationBloc
                            .add(PredictEvent(image: File(state.image[0])));
                      } else if (state is CameraPermissionGranted) {
                        classificationBloc.add(TakeImageEvent());
                      } else if (state is StoragePermissionGranted) {
                        classificationBloc.add(PickGalleryEvent());
                      } else if (state is ErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)));
                      } else if (state is PermissionDenied) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)));
                        classificationBloc.add(PermissionDeniedEvent());
                      }
                    },
                    child: BlocBuilder<ClassificationBloc, ClassificationState>(
                        cubit: classificationBloc..add(LoadModelEvent()),
                        builder: (BuildContext context, state) {
                          print(state);
                          if (state is ClassificationInitial ||
                              state is LoadedModel) {
                            return SizedBox(height: 250, width: 250);
                          } else if (state is LoadingModelState) {
                            return Container(
                                width: 250,
                                height: 250,
                                child: CircularProgressIndicator());
                          } else if (state is PredictingState) {
                            return Container(
                                height: 250,
                                width: 250,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ));
                          } else {
                            return Container();
                          }
                        }))),
          ),
          BlocBuilder<ClassificationBloc, ClassificationState>(
              cubit: classificationBloc,
              buildWhen: (previous, current) {
                if (current is ImageLoading ||
                    current is ImageLoaded ||
                    (previous is ImageLoading && current is ErrorState)) {
                  return true;
                } else {
                  return false;
                }
              },
              builder: (context, state) {
                if (state is ImageLoading) {
                  return Container(
                    height: 250,
                    width: 250,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (state is ImageLoaded) {
                  img = File(state.image[0]);
                  imgW = state.image[1];
                  imgH = state.image[2];
                  return Container();
                  // return Container(
                  //   height: 250,
                  //   width: 250,
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(30),
                  //     child: Image.file(
                  //       state.image,
                  //       fit: BoxFit.contain,
                  //     ),
                  //   ),
                  // );
                } else if (state is ErrorState) {
                  return Container(
                    width: 250,
                    height: 250,
                  );
                } else {
                  return Container();
                }
              }),
          BlocBuilder<ClassificationBloc, ClassificationState>(
              cubit: classificationBloc,
              buildWhen: (previous, current) {
                if (previous is ImageLoaded && current is Prediction ||
                    (previous is ImageLoading && current is ErrorState)) {
                  return true;
                } else {
                  return false;
                }
              },
              builder: (context, state) {
                print(state);
                if (state is Prediction) {
                  double factorX;
                  double factorY;
                  double width;
                  Color blue = Color.fromRGBO(37, 213, 253, 1.0);
                  //szelesseg

                  if (imgH >= imgW) {
                    double szam;
                    if (imgH > (size.height / 2)) {
                      //decrease
                      szam = (imgH - (size.height / 2)) / imgH;
                      width = imgW * (1 - szam);
                    } else {
                      //increase
                      szam = ((size.height / 2) - imgH) / imgH;
                      width = imgW * (1 + szam);
                    }
                    factorX = width;
                    factorY = imgH / imgW * width;
                  } else {
                    width = size.width;
                    factorX = size.width;
                    factorY = imgH / imgW * size.width;
                  }

                  if (state.prediction.isNotEmpty) {
                    print('nem');
                  } else {
                    print('igen');
                  }

                  return Column(
                    children: [
                      Container(
                        height: size.height / 2,
                        width: width,
                        child: Stack(clipBehavior: Clip.none, children: [
                          Positioned(
                            top: 0.0,
                            left: 0.0,
                            width: width,
                            height: size.height / 2,
                            child: Container(
                              child: Image.file(
                                img,
                                fit: BoxFit.contain,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                          ),

                          state.prediction.isNotEmpty
                              ? Positioned(
                                  left: state.prediction[0]["rect"]["x"] *
                                      factorX,
                                  top: state.prediction[0]["rect"]["y"] *
                                      factorY,
                                  width: state.prediction[0]["rect"]["w"] *
                                      factorX,
                                  height: state.prediction[0]["rect"]["h"] *
                                      factorY,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      border: Border.all(
                                        color: blue,
                                        width: 2,
                                      ),
                                    ),
                                    child: Text(
                                      "${state.prediction[0]["detectedClass"]} ${(state.prediction[0]["confidenceInClass"] * 100).toStringAsFixed(0)}%",
                                      style: TextStyle(
                                        background: Paint()..color = blue,
                                        color: Colors.white,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),

                          // Container(
                          //   height: 250,
                          //   width: 250,
                          //   child: ClipRRect(
                          //     borderRadius: BorderRadius.circular(30),
                          //     child: Image.file(
                          //       img,
                          //       fit: BoxFit.contain,
                          //     ),
                          //   ),
                          // ),
                        ]),
                      ),
                      Container(
                          child: Text(
                              state.prediction.isNotEmpty
                                  ? 'The type is ${state.prediction[0]['detectedClass']}!'
                                  : 'No van detected!',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400)))
                    ],
                  );
                } else {
                  return Container();
                }
              }),
        ]),
      ),
      BlocBuilder<ClassificationBloc, ClassificationState>(
        cubit: classificationBloc,
        buildWhen: (previous, current) {
          if (previous is ClassificationInitial) {
            return true;
          } else {
            return false;
          }
        },
        builder: (context, state) {
          if (state is LoadedModel) {
            return Container(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      classificationBloc.add(CheckCameraPermissionEvent());
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(63, 136, 197, 1),
                          borderRadius: BorderRadius.circular(15)),
                      child: Text(
                        'Take A Photo',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      classificationBloc.add(CheckStoragePermissionEvent());
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(63, 136, 197, 1),
                          borderRadius: BorderRadius.circular(15)),
                      child: Text(
                        'Pick From Gallery',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ErrorState) {
            return Container(
              child: Text(state.message),
            );
          } else {
            return Container();
          }
        },
      ),
    ]);
  }
}
