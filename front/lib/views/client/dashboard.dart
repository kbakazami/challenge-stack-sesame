import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:front/views/client/account.dart';
import 'package:front/views/client/bathroomsList.dart';
import 'package:front/views/client/employee.dart';
import 'package:front/views/client/stats.dart';

import '../../constants/colors.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  static String routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(image: AssetImage("assets/icons/logo.png"), width: 60, height: 60),
              const SizedBox(width: 20),
              Flexible(
                child: Scaffold(
                  appBar: TabBar(
                    tabs: [
                      Tab(
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/icons/dashboard.svg', width: 25),
                            const SizedBox(width: 10),
                            const Text("Dashboard"),
                          ],
                        ),
                      ),
                      Tab(
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/icons/list.svg', width: 25),
                            const SizedBox(width: 10),
                            const Text("Liste des toilettes"),
                          ],
                        ),
                      ),
                      Tab(
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/icons/worker.svg', width: 30),
                            const SizedBox(width: 10),
                            const Text("Employés"),
                          ],
                        ),
                      ),
                      Tab(
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/icons/customer.svg', width: 20, color: Colors.black,),
                            const SizedBox(width: 10),
                            const Text("Gestion du compte"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  body: const TabBarView(
                    children: <Widget>[
                      Center(
                        child: Stats(),
                      ),
                      Center(
                        child: BathroomsList(),
                      ),
                      Center(
                        child: Employee(),
                      ),
                      Center(
                        child: Account(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )

    );
  }
}
