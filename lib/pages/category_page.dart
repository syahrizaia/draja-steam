import 'package:draja_steam/models/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isExpense = true;
  int type = 2;
  final AppDb database = AppDb();
  TextEditingController categoryNameController = TextEditingController();

  Future insert(String name, int type) async {
    DateTime now = DateTime.now();
    final row = await database.into(database.categories).insertReturning(
      CategoriesCompanion.insert(
        name: name, type: type, createdAt: now, updatedAt: now
      )
    );
  }

  Future<List<Category>> getAllCategory(int type) async {
    return await database.getAllCategoryRepo(type);
  }

  Future update(int categoryId, String newName) async {
    return await database.updateCategoryRepo(categoryId, newName);
  }

  void openDialog(Category? category) {
    if (category != null) {
      categoryNameController.text = category.name;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Text(
                    (isExpense) ? "Tambah Pengeluaran" : "Tambah Pemasukan",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      color: (isExpense) ? Colors.red : Colors.green
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: categoryNameController,
                    decoration: InputDecoration(border: OutlineInputBorder(),
                    hintText: "Nama"),
                  ),
                  SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: () {
                      if (category == null) {
                        insert(categoryNameController.text, isExpense ? 2 : 1);
                      } else {
                        update(category.id, categoryNameController.text);
                      }

                      insert(categoryNameController.text, isExpense ? 2 : 1);
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      setState(() {});
                      categoryNameController.clear();
                    },
                    child: Text("Simpan")
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Switch(
                  value: isExpense,
                  onChanged: (bool value) {
                    setState(() {
                      isExpense = value;
                      type = value ? 2 : 1;
                    });
                  },
                  inactiveTrackColor: Colors.green[200],
                  inactiveThumbColor: Colors.green,
                  activeColor: Colors.red,
                ),
                IconButton(
                  onPressed: () {
                    openDialog(null);
                  },
                  icon: Icon(Icons.add)
                )
              ],
            ),
          ),
          FutureBuilder<List<Category>>(
            future: getAllCategory(type),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(),);
              } else {
                if (snapshot.hasData) {
                  if (snapshot.data!.length > 0) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Card(
                            elevation: 10,
                            child: ListTile(
                              leading: Container(
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                child: (isExpense)
                                  ? Icon(Icons.upload, color: Colors.redAccent[400])
                                  : Icon(Icons.download, color: Colors.greenAccent[400])
                              ),
                              // leading: (isExpense) ? Icon(Icons.upload, color: Colors.red,) : Icon(Icons.download, color: Colors.green,),
                              title: Text(snapshot.data![index].name),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      database.deleteCategoryRepo(snapshot.data![index].id);
                                      setState(() {});
                                    },
                                    icon: Icon(Icons.delete)
                                  ),
                                  SizedBox(width: 10,),
                                  IconButton(
                                    onPressed: () {
                                      openDialog(snapshot.data![index]);
                                    },
                                    icon: Icon(Icons.edit)
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    );
                  } else {
                    return Center(child: Text("Tidak ada data"),);
                  }
                } else {
                  return Center(child: Text("Tidak ada data"),);
                }
              }
            },
          ),
        ],
      )
    );
  }
}