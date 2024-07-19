import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/bathrooms.dart';
import '../services/bathrooms.dart';

class BathroomCard extends StatefulWidget {

  final int gridCount;
  final double childAspectRatio;

  const BathroomCard ({ Key? key, required this.gridCount, required this.childAspectRatio }): super(key: key);

  @override
  State<BathroomCard> createState() => _BathroomCardState();
}

class _BathroomCardState extends State<BathroomCard> {
  late Future<List<Bathrooms>> futureBathrooms;

  Future<void> _launchMapsUrl(double lat, double lon) async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lon');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    futureBathrooms = getAllBathrooms();
  }

  @override
  Widget build(BuildContext context) {
    int gridCountItems = widget.gridCount;
    double gridChildAspectRatio = widget.childAspectRatio;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des sanitaires'),
      ),
      body: FutureBuilder<List<Bathrooms>>(
          future: futureBathrooms,
          builder: (context, snapshot) {
            if(snapshot.hasError) {
              return const Text('Une erreur est survenue, veuillez réessayer.');
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final bathrooms = snapshot.data;
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: gridCountItems,
                  childAspectRatio: (1/ gridChildAspectRatio),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.vertical,
                itemBuilder: ((context, index) =>
                    GestureDetector(
                      onTap: (() => Navigator.pushNamed(context, 'bathroom-detail', arguments: bathrooms[index].id)),
                      child: Container(
                        decoration: BoxDecoration(
                            color: customBackgroundColor(bathrooms[index].state),
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset("assets/icons/bathroom.svg", color: customColor(bathrooms[index].state)),
                                    const SizedBox(width: 5),
                                    Text(bathrooms[index].label),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset("assets/icons/bathroom_status.svg", color: customColor(bathrooms[index].state)),
                                    const SizedBox(width: 5),
                                    customText(bathrooms[index].state),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            InkWell(
                              onTap: () => _launchMapsUrl(bathrooms[index].locationX, bathrooms[index].locationY),
                              child: Row(
                                children: [
                                  SvgPicture.asset("assets/icons/location.svg", color: customColor(bathrooms[index].state)),
                                  const SizedBox(width: 5),
                                  const Text("Coordonnées GPS"),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                ),
                itemCount: bathrooms!.length
            );
          }),
    );
  }

  customBackgroundColor(state) {
    switch (state) {
      case 1 :
        return const Color(0x33FF5C00);
      case 2 :
      case 5 :
        return const Color(0x3325D408);
      case 3 :
      case 4 :
        return const Color(0x33DB4F4F);
    }
  }

  customColor(state) {
    switch (state) {
      case 1 :
        return const Color(0xFFFF5C00);
      case 2 :
      case 5 :
        return const Color(0xFF25D408);
      case 3 :
      case 4 :
        return const Color(0xFFDB4F4F);
    }
  }

  customText(state) {
    switch (state) {
      case 1 :
        return const Text("Occupé");
      case 2 :
        return const Text("Disponible");
      case 3 :
        return const Text("Entretien");
      case 4 :
        return const Text("Maintenance");
      case 5 :
        return const Text("Ouverture");
    }
  }
}

