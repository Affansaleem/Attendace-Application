import 'package:flutter/material.dart';
import '../../../../../api_intigration_files/models/AdminDashBoard_model.dart';
import '../adminConstants/adminconstants.dart';
import '../adminModels/adminFile_info_card.dart';
import '../adminModels/adminMyFiles.dart';
import '../adminResponsive.dart';

class AdminData extends StatefulWidget {
  final int totalEmployees;
  final int presentEmployees;
  final int absentEmployees;
  final int lateEmployees;

  const AdminData({
    Key? key,
    required this.totalEmployees,
    required this.presentEmployees,
    required this.absentEmployees,
    required this.lateEmployees,
    required demoMyFiles, required AdminDashBoard adminData,
  }) : super(key: key);

  @override
  State<AdminData> createState() => _AdminDataState();
}

class _AdminDataState extends State<AdminData> {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Reports",
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
        AdminResponsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 && _size.width > 350 ? 1.3 : 1,
            totalEmployees: widget.totalEmployees,
            presentEmployees: widget.presentEmployees,
            absentEmployees: widget.absentEmployees,
            lateEmployees: widget.lateEmployees,
          ),
          tablet: FileInfoCardGridView(
            totalEmployees: 20,
            presentEmployees: 30,
            absentEmployees: 40,
            lateEmployees: 50,
          ),
          desktop: FileInfoCardGridView(
              totalEmployees: 10,
              presentEmployees: 10,
              absentEmployees: 10,
              lateEmployees: 10),
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  const FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    required this.totalEmployees,
    required this.presentEmployees,
    required this.absentEmployees,
    required this.lateEmployees,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;
  final int totalEmployees;
  final int presentEmployees;
  final int absentEmployees;
  final int lateEmployees;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 4,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return AdminFileInfoCard(
              imageSrc: "assets/icons/employees.png",
              title: "Total Employee",
              numOfEmployees: totalEmployees,
              color: Colors.red,
            );
          case 1:
            return AdminFileInfoCard(
              imageSrc: "assets/icons/present.png",
              title: "Present Employee",
              numOfEmployees: presentEmployees,
              color: const Color(0xFFFFA113),
            );
          case 2:
            return AdminFileInfoCard(
              imageSrc: "assets/icons/absent.png",
              title: "Absent Employee",
              numOfEmployees: absentEmployees,
              color: const Color(0xFFA4CDFF),
            );
          case 3:
            return AdminFileInfoCard(
              imageSrc: "assets/icons/late.png",
              title: "Late Employee",
              numOfEmployees: lateEmployees,
              color: const Color(0xFF007EE5),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}
