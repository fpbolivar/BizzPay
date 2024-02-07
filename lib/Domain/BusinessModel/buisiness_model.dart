import 'dart:convert';

class BusinessProductModel {
  final String? businessName;
  final String? businessDescription;
  final String? price;
  final String? location;
  final String? businessImage;
  final bool? isFav;

  BusinessProductModel({
    this.businessName,
    this.businessDescription,
    this.price,
    this.location,
    this.businessImage,
    this.isFav,
  });

  factory BusinessProductModel.fromRawJson(String str) =>
      BusinessProductModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BusinessProductModel.fromJson(Map<String, dynamic> json) =>
      BusinessProductModel(
        businessName: json["businessName"],
        businessDescription: json["businessDescription"],
        price: json["price"],
        location: json["location"],
        businessImage: json["businessImage"],
        isFav: json["isFav"],
      );

  Map<String, dynamic> toJson() => {
        "businessName": businessName,
        "businessDescription": businessDescription,
        "price": price,
        "location": location,
        "businessImage": businessImage,
        "isFav": isFav,
      };
}

class BusinessModel {
  final String? id;
  final String? name;
  final String? privence;
  final String? viewsCount;
  final String? foundationYear;
  final String? numberOfOwners;
  final String? numberOfEmployes;
  final String? businessDescription;
  final List<String>? images;
  final List<String>? attachedFiles;
  final List<String>? advantages;
  final int? salePrice;
  final List<FinancialDetail>? financialDetails;
  final CreatedBy? createdBy;
  final String? country;
  final String? city;
  final String? address;
  final String? zipcode;
  final String? businessHour;

  final dynamic industry;
  final List<dynamic>? subIndustry;
  final String? status;

  BusinessModel({
    this.id,
    this.createdBy,
    this.name,
    this.foundationYear,
    this.numberOfOwners,
    this.numberOfEmployes,
    this.businessDescription,
    this.images,
    this.attachedFiles,
    this.privence,
    this.advantages,
    this.salePrice,
    this.financialDetails,
    this.country,
    this.city,
    this.address,
    this.viewsCount,
    this.businessHour,
    this.zipcode,
    this.industry,
    this.subIndustry,
    this.status,
  });

  factory BusinessModel.fromRawJson(String str) =>
      BusinessModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BusinessModel.fromJson(Map<String, dynamic> json) => BusinessModel(
      privence: json['state'],
      id: json["_id"],
      name: json["name"],
      foundationYear: json["foundationYear"],
      numberOfOwners: json["numberOfOwners"].toString(),
      numberOfEmployes: json["numberOfEmployes"].toString(),
      businessHour: json['businessHours'],
      businessDescription: json["businessDescription"],
      images: json["images"] == null
          ? []
          : List<String>.from(json["images"]!.map((x) => x)),
      attachedFiles: json["attached_files"] == null
          ? []
          : List<String>.from(json["attached_files"]!.map((x) => x)),
      advantages: json["advantages"] == null
          ? []
          : List<String>.from(json["advantages"]!.map((x) => x)),
      salePrice: json["salePrice"],
      financialDetails: json["financialDetails"] == null
          ? []
          : List<FinancialDetail>.from(json["financialDetails"]!
              .map((x) => FinancialDetail.fromJson(x))),
      country: json["country"],
      city: json["city"],
      address: json["address"],
      zipcode: json["zipcode"],
      industry: json["industry"],
      subIndustry: json["subIndustry"] == null
          ? []
          : List<dynamic>.from(json["subIndustry"]!.map((x) => x)),
      status: json["status"],
      viewsCount: json['viewsCount'].toString(),
      createdBy: json['createdBy'] == null
          ? null
          : CreatedBy.fromJson(json['createdBy']));

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "foundationYear": foundationYear,
        "numberOfOwners": numberOfOwners,
        "numberOfEmployes": numberOfEmployes,
        "businessDescription": businessDescription,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "attached_files": attachedFiles == null
            ? []
            : List<dynamic>.from(attachedFiles!.map((x) => x)),
        "advantages": advantages == null
            ? []
            : List<dynamic>.from(advantages!.map((x) => x)),
        "salePrice": salePrice,
        "financialDetails": financialDetails == null
            ? []
            : List<dynamic>.from(financialDetails!.map((x) => x.toJson())),
        "country": country,
        "city": city,
        "businessHours": businessHour,
        "address": address,
        "zipcode": zipcode,
        "industry": industry,
        "subIndustry": subIndustry == null
            ? []
            : List<dynamic>.from(subIndustry!.map((x) => x)),
        "status": status,
        'viewsCount': viewsCount,
        "state": privence,
      };
}

class FinancialDetail {
  final String? financialYear;
  final int? revenue;
  final String? id;

  FinancialDetail({
    this.financialYear,
    this.revenue,
    this.id,
  });

  factory FinancialDetail.fromRawJson(String str) =>
      FinancialDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FinancialDetail.fromJson(Map<String, dynamic> json) =>
      FinancialDetail(
        financialYear: json["financialYear"],
        revenue: json["revenue"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "financialYear": financialYear,
        "revenue": revenue,
        "_id": id,
      };
}

class BusinessCategory {
  final String? id;
  final String? title;

  BusinessCategory({
    this.id,
    this.title,
  });

  factory BusinessCategory.fromRawJson(String str) =>
      BusinessCategory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BusinessCategory.fromJson(Map<String, dynamic> json) =>
      BusinessCategory(
        id: json["_id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
      };
}

class CreatedBy {
  final String? id;
  final String? fullName;
  final String? email;

  CreatedBy({
    this.id,
    this.fullName,
    this.email,
  });

  factory CreatedBy.fromRawJson(String str) =>
      CreatedBy.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        id: json["_id"],
        fullName: json["fullName"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "fullName": fullName,
        "email": email,
      };
}
