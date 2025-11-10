import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:wisatacandi/data/candi_data.dart';
import 'package:wisatacandi/models/candi.dart';

class DetailScreen extends StatelessWidget {
  // Model data for a specific temple
  final Candi candi;

  const DetailScreen({super.key, required this.candi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Display the image and name of the temple
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      candi.imageAsset, // Path to the temple image asset
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 32.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[100]?.withValues(alpha: 150),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.arrow_back),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.0),
                  // info atas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        candi.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.favorite_border),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  // info tengah
                  Row(
                    children: [
                      Icon(Icons.place, color: Colors.red),
                      SizedBox(width: 8.0),
                      SizedBox(
                        width: 70.0,
                        child: Text(
                          'Lokasi',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(' : ${candi.location} '),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.calendar_month, color: Colors.blue),
                      SizedBox(width: 8.0),
                      SizedBox(
                        width: 70.0,
                        child: Text(
                          'Dibangun',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(' : ${candi.built} '),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.house, color: Colors.green),
                      SizedBox(width: 8.0),
                      SizedBox(
                        width: 70.0,
                        child: Text(
                          'Tipe',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(' : ${candi.type} '),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Divider(color: Colors.deepPurple.shade100),
                  SizedBox(height: 16.0),
                  Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(candi.description),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(children: [
                      ],
                    ),
                  ),
                  // info bawah
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(color: Colors.deepPurple.shade100),
                        Text(
                          'Galeri',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        SizedBox(
                          height: 100.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: candi.imageUrls.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.deepPurple.shade100,
                                        width: 2,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: candi.imageUrls[index],
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
                                              width: 120,
                                              height: 120,
                                              color: Colors.deepPurple[50],
                                            ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'Tap untuk memperbesar gambar',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
