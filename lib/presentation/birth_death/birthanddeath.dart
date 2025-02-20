
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../app/generalFunction.dart';
import 'birthanddeathwebView.dart';


class BirthAndDeathCertificate extends StatefulWidget {

  final name;
  final webUrl;
  BirthAndDeathCertificate({super.key,this.name,  this.webUrl});

  @override
  State<BirthAndDeathCertificate> createState() => _BirthAndDeathState();
}

class _BirthAndDeathState extends State<BirthAndDeathCertificate> {

  GeneralFunction generalFunction = GeneralFunction();
  var pageName;
  var webUrl;
  @override
  void initState() {
    pageName = "${widget.name}";
    webUrl = "${widget.webUrl}";
    super.initState();

   // BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        //appBar: getAppBarBack(context,"Birth & Death Certificate"),
        appBar: getAppBarBack(context,pageName),
        //drawer: generalFunction.drawerFunction(context, 'Suaib Ali', '9871950881'),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: BirthAndDeathWebViewStack(webUrl:webUrl)),
      ),
    );
  }
}
