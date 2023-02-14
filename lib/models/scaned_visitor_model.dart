class ScannedVisitorModel {
  String? name;
  String? phoneNo;
  String? cnic;
  String? image;
  String? reason;

  ScannedVisitorModel({this.name, this.phoneNo, this.cnic, this.image, this.reason});

  ScannedVisitorModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phoneNo = json['phone_no'];
    cnic = json['cnic'];
    image = json['image'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone_no'] = this.phoneNo;
    data['cnic'] = this.cnic;
    data['image'] = this.image;
    data['reason'] = this.reason;
    return data;
  }
}