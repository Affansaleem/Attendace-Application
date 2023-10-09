class GetActiveEmpModel {
  int? empId;
  String? empName;
  String? empCode;
  bool isSelected = false;

  GetActiveEmpModel({
    this.empId,
    this.empName,
    this.empCode,
  });

  factory GetActiveEmpModel.fromJson(Map<String, dynamic> json) {
    return GetActiveEmpModel(
      empId: json['empId'] as int?,
      empName: json['empName'] as String?,
      empCode: json['empCode'] as String?,
    );
  }
}
