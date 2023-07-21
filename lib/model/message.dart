class MessageM {
  String? fromId;
  String? msg;
  String? read;
  String? sent;
  String? toId;
  String? type;

  MessageM({this.fromId, this.msg, this.read, this.sent, this.toId, this.type});

  MessageM.fromJson(Map<String, dynamic> json) {
    fromId = json['fromId'] ?? "";
    msg = json['msg'] ?? "";
    read = json['read'] ?? "";
    sent = json['sent'] ?? "";
    toId = json['toId'] ?? "";
    type = json['type'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fromId'] = this.fromId;
    data['msg'] = this.msg;
    data['read'] = this.read;
    data['sent'] = this.sent;
    data['toId'] = this.toId;
    data['type'] = this.type;
    return data;
  }
}
