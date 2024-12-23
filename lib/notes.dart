class Notes{

  int? _id;
  String _namaPerangkat;
  int _penggunaan;
  int _durasi;
  String _date;

// contructor
  Notes(this._namaPerangkat, this._penggunaan, this._durasi, this._date);

  Notes.withId(this._id, this._namaPerangkat, this._penggunaan, this._durasi, this._date);

//getter
  int get id => _id!;
  String get namaPerangkat => _namaPerangkat;
  int get penggunaan => _penggunaan;
  int get durasi => _durasi;
  String get date => _date;

//setter
  set namaPerangkat(String newNamaPerangkat){
    this._namaPerangkat = newNamaPerangkat;
  }
  set penggunaan(int newPenggunaan){
    this._penggunaan = newPenggunaan;
  }
  set durasi(int newDurasi){
    this._durasi = newDurasi;
  }
  set date(String newDate){
    this._date = newDate;
  }

//convert ke map
  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    
    if(id != null){
      map['id'] = _id;
    }

    map['namaPerangkat'] = _namaPerangkat;
    map['penggunaan'] = _penggunaan;
    map['durasi'] = _durasi;
    map['date'] = _date;

    return map;
  }

//constructor dari map
  Notes.fromMapObject(Map<String, dynamic> map):
    this._id = map['id'],
    this._namaPerangkat = map['namaPerangkat'],
    this._penggunaan = map['penggunaan'],
    this._durasi = map['durasi'],
    this._date = map['date'];

}