class StatsModel {
  int? statusCode;
  PlayerStats? playerStats;

  StatsModel({this.statusCode, this.playerStats});

  StatsModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    playerStats = json['playerStats'] != null
        ? new PlayerStats.fromJson(json['playerStats'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    if (this.playerStats != null) {
      data['playerStats'] = this.playerStats!.toJson();
    }
    return data;
  }
}

class PlayerStats {
  String? teamname;
  String? seasonname;
  String? leaguename;
  String? playername;
  String? bats;
  String? throws;
  String? position;
  List<Pitchingstats>? pitchingstatslist;
  List<Battingstats>? battingstatslist;


  PlayerStats(
      {this.teamname,
        this.seasonname,
        this.leaguename,
        this.playername,
        this.bats,
        this.throws,
        this.position,
        this.pitchingstatslist,
        this.battingstatslist,
      });

  PlayerStats.fromJson(Map<String, dynamic> json) {
    teamname = json['teamname'];
    seasonname = json['seasonname'];
    leaguename = json['leaguename'];
    playername = json['playername'];
    bats = json['bats'];
    throws = json['throws'];
    position = json['position'];
    if (json['pitchingstats'] != null && json['pitchingstats'].runtimeType == List) {
      pitchingstatslist = <Pitchingstats>[];
      json['pitchingstats'].forEach((v) {
        print(v);
        pitchingstatslist!.add(new Pitchingstats.fromJson(v));
      });
    } else if (json['pitchingstats'] != null && json['pitchingstats'].runtimeType != List) {
      json['pitchingstats'].forEach((key , value) {
        pitchingstatslist = <Pitchingstats>[];
        pitchingstatslist!.add(new Pitchingstats.fromJson(json['pitchingstats']));
      });
    }

    if (json['battingstats'] != null && json['battingstats'].runtimeType == List) {
      battingstatslist = <Battingstats>[];
      json['battingstats'].forEach((v) {
        battingstatslist!.add(new Battingstats.fromJson(v));
      });
    } else if (json['battingstats'] != null && json['battingstats'].runtimeType != List) {
      json['battingstats'].forEach((key , value) {
        battingstatslist = <Battingstats>[];
        battingstatslist?.add(Battingstats.fromJson(json['battingstats']));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['teamname'] = this.teamname;
    data['seasonname'] = this.seasonname;
    data['leaguename'] = this.leaguename;
    data['playername'] = this.playername;
    data['bats'] = this.bats;
    data['throws'] = this.throws;
    data['position'] = this.position;
    if (this.pitchingstatslist != null) {
      data['battingstats'] = this.pitchingstatslist!.map((v) => v.toJson()).toList();
    }
    if (this.battingstatslist != null) {
      data['battingstats'] = this.battingstatslist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pitchingstats {
  String? name;
  String? gp;
  String? w;
  String? l;
  String? h;
  String? bb;
  String? er;
  String? gs;
  String? era;
  String? sho;
  String? sv;
  String? ip;
  String? so;

  Pitchingstats(
      {this.name,
        this.gp,
        this.w,
        this.l,
        this.h,
        this.bb,
        this.er,
        this.gs,
        this.era,
        this.sho,
        this.sv,
        this.ip,
        this.so});

  Pitchingstats.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    gp = json['gp'];
    w = json['w'];
    l = json['l'];
    h = json['h'];
    bb = json['bb'];
    er = json['er'];
    gs = json['gs'];
    era = json['era'];
    sho = json['sho'];
    sv = json['sv'];
    ip = json['ip'];
    so = json['so'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['gp'] = this.gp;
    data['w'] = this.w;
    data['l'] = this.l;
    data['h'] = this.h;
    data['bb'] = this.bb;
    data['er'] = this.er;
    data['gs'] = this.gs;
    data['era'] = this.era;
    data['sho'] = this.sho;
    data['sv'] = this.sv;
    data['ip'] = this.ip;
    data['so'] = this.so;
    return data;
  }
}

class Battingstats {
  String? name;
  String? gp;
  String? ab;
  String? r;
  String? h;
  String? bb;
  String? x2b;
  String? x3b;
  String? bib;
  String? trib;
  String? hr;
  String? rbi;
  String? avg;
  String? so;
  String? sb;

  Battingstats(
      {this.name,
        this.gp,
        this.ab,
        this.r,
        this.h,
        this.bb,
        this.x2b,
        this.x3b,
        this.bib,
        this.trib,
        this.hr,
        this.rbi,
        this.avg,
        this.so,
        this.sb});

  Battingstats.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    gp = json['gp'];
    ab = json['ab'];
    r = json['r'];
    h = json['h'];
    bb = json['bb'];
    x2b = json['x_2b'];
    x3b = json['x_3b'];
    bib = json['bib'];
    trib = json['trib'];
    hr = json['hr'];
    rbi = json['rbi'];
    avg = json['avg'];
    so = json['so'];
    sb = json['sb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['gp'] = this.gp;
    data['ab'] = this.ab;
    data['r'] = this.r;
    data['h'] = this.h;
    data['bb'] = this.bb;
    data['x_2b'] = this.x2b;
    data['x_3b'] = this.x3b;
    data['bib'] = this.bib;
    data['trib'] = this.trib;
    data['hr'] = this.hr;
    data['rbi'] = this.rbi;
    data['avg'] = this.avg;
    data['so'] = this.so;
    data['sb'] = this.sb;
    return data;
  }
}
